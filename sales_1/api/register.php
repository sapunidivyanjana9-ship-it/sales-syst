<?php
declare(strict_types=1);

require_once __DIR__ . '/db_connect.php';

function districts(): array
{
    return [
        'Colombo', 'Gampaha', 'Kalutara', 'Kandy', 'Matale', 'Nuwara Eliya',
        'Galle', 'Matara', 'Hambantota', 'Jaffna', 'Kilinochchi', 'Mannar',
        'Vavuniya', 'Mullaitivu', 'Batticaloa', 'Ampara', 'Trincomalee',
        'Kurunegala', 'Puttalam', 'Anuradhapura', 'Polonnaruwa', 'Badulla',
        'Moneragala', 'Ratnapura', 'Kegalle'
    ];
}

function customer_spices(): array
{
    return [
        'Turmeric', 'Chili Powder', 'Black Pepper', 'Cinnamon', 'Cardamom',
        'Coriander', 'Curry Powder', 'Cloves', 'Nutmeg', 'Vanilla'
    ];
}

function short_code(string $prefix): string
{
    return $prefix . date('ymd') . strtoupper(substr(bin2hex(random_bytes(3)), 0, 6));
}

function has_column(PDO $pdo, string $table, string $column): bool
{
    $stmt = $pdo->prepare('
        SELECT COUNT(*)
        FROM information_schema.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?
    ');
    $stmt->execute([$table, $column]);
    return (int)$stmt->fetchColumn() > 0;
}

function ensure_supplier_request_columns(PDO $pdo): void
{
    if (!has_column($pdo, 'supplier_registration_requests', 'username')) {
        $pdo->exec('ALTER TABLE supplier_registration_requests ADD username VARCHAR(50) NULL AFTER request_code');
    }

    if (!has_column($pdo, 'supplier_registration_requests', 'postal_code')) {
        $pdo->exec('ALTER TABLE supplier_registration_requests ADD postal_code VARCHAR(20) NULL AFTER city');
    }
}

function password_error(string $password): string
{
    if (strlen($password) < 6 || !preg_match('/[0-9]/', $password) || !preg_match('/[A-Z]/', $password)) {
        return 'Password must be at least 6 characters and include at least 1 number and 1 uppercase letter';
    }

    return '';
}

endpoint_guard(function (): void {
    require_method(['POST']);

    $input = json_input();
    $role = strtolower(trim((string)($input['role'] ?? '')));
    $allowedRoles = ['customer', 'supplier', 'wholesaler'];

    if (!in_array($role, $allowedRoles, true)) {
        fail('Invalid registration type', 422);
    }

    require_fields($input, ['email', 'phone', 'address', 'city', 'postal_code', 'username', 'password', 'confirm_password']);

    $email = trim((string)$input['email']);
    $phone = trim((string)$input['phone']);
    $address = trim((string)$input['address']);
    $district = trim((string)$input['city']);
    $postalCode = trim((string)$input['postal_code']);
    $username = trim((string)$input['username']);
    $password = (string)$input['password'];
    $confirmPassword = (string)$input['confirm_password'];

    if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
        fail('Enter a valid email address', 422);
    }

    if (!preg_match('/^07[0-9]{8}$/', $phone)) {
        fail('Phone number must be exactly 10 digits', 422);
    }

    if (!preg_match('/^[0-9]{5}$/', $postalCode)) {
        fail('Postal code must be exactly 5 digits', 422);
    }

    if (!in_array($district, districts(), true)) {
        fail('Please select a valid Sri Lankan district', 422);
    }

    if (strlen($username) < 4) {
        fail('Username must be at least 4 characters', 422);
    }

    $passwordError = password_error($password);
    if ($passwordError !== '') {
        fail($passwordError, 422);
    }

    if ($password !== $confirmPassword) {
        fail('Password and confirm password do not match', 422);
    }

    $pdo = get_pdo();
    ensure_supplier_request_columns($pdo);

    $exists = $pdo->prepare('
        SELECT user_id FROM users WHERE username = ? OR email = ?
        UNION
        SELECT request_id AS user_id FROM supplier_registration_requests WHERE username = ? OR email = ?
        LIMIT 1
    ');
    $exists->execute([$username, $email, $username, $email]);
    if ($exists->fetch()) {
        fail('Username or email is already registered', 409);
    }

    $pdo->beginTransaction();

    if ($role === 'customer') {
        require_fields($input, ['first_name', 'last_name']);

        $firstName = trim((string)$input['first_name']);
        $lastName = trim((string)$input['last_name']);
        $fullName = trim($firstName . ' ' . $lastName);
        $spicePreferences = $input['spice_preferences'] ?? [];
        $spicePreferences = is_array($spicePreferences)
            ? $spicePreferences
            : array_filter(array_map('trim', explode(',', (string)$spicePreferences)));
        $spicePreferences = array_values(array_intersect($spicePreferences, customer_spices()));

        if (count($spicePreferences) === 0) {
            $pdo->rollBack();
            fail('Please select at least one spice preference', 422);
        }

        $stmt = $pdo->prepare('
            INSERT INTO users (username, password, role, full_name, email, phone, address, city, status, redirect_page)
            VALUES (?, ?, "customer", ?, ?, ?, ?, ?, "active", "customer.html")
        ');
        $stmt->execute([$username, password_hash($password, PASSWORD_DEFAULT), $fullName, $email, $phone, $address, $district]);
        $userId = (int)$pdo->lastInsertId();

        $stmt = $pdo->prepare('
            INSERT INTO customers
                (user_id, customer_code, first_name, last_name, name, email, phone, address, city, postal_code, district, spice_preferences, account_status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "active")
        ');
        $stmt->execute([
            $userId,
            short_code('CUST'),
            $firstName,
            $lastName,
            $fullName,
            $email,
            $phone,
            $address,
            $district,
            $postalCode,
            $district,
            implode(', ', $spicePreferences),
        ]);

        $pdo->commit();
        respond(true, 'Registration successful. Redirecting to login.', ['redirect' => 'index.html'], 201);
    }

    if ($role === 'wholesaler') {
        require_fields($input, ['first_name', 'last_name', 'company_name', 'business_type']);

        $businessType = trim((string)$input['business_type']);
        $allowedBusinessTypes = ['Retailer', 'Wholesaler', 'Distributor', 'Exporter'];
        if (!in_array($businessType, $allowedBusinessTypes, true)) {
            $pdo->rollBack();
            fail('Please select a valid business type', 422);
        }

        $firstName = trim((string)$input['first_name']);
        $lastName = trim((string)$input['last_name']);
        $fullName = trim($firstName . ' ' . $lastName);
        $companyName = trim((string)$input['company_name']);

        $stmt = $pdo->prepare('
            INSERT INTO users (username, password, role, full_name, email, phone, address, city, status, redirect_page)
            VALUES (?, ?, "wholesaler", ?, ?, ?, ?, ?, "active", "wholeseller.html")
        ');
        $stmt->execute([$username, password_hash($password, PASSWORD_DEFAULT), $fullName, $email, $phone, $address, $district]);
        $userId = (int)$pdo->lastInsertId();

        $stmt = $pdo->prepare('
            INSERT INTO wholesalers
                (user_id, wholesaler_code, first_name, last_name, company_name, email, phone, address, city, postal_code, district, business_type, account_status)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "active")
        ');
        $stmt->execute([
            $userId,
            short_code('WHL'),
            $firstName,
            $lastName,
            $companyName,
            $email,
            $phone,
            $address,
            $district,
            $postalCode,
            $district,
            $businessType,
        ]);

        $pdo->commit();
        respond(true, 'Registration successful. Redirecting to login.', ['redirect' => 'index.html'], 201);
    }

    require_fields($input, ['company_name', 'contact_person', 'business_type', 'materials']);

    $businessType = trim((string)$input['business_type']);
    $allowedSupplierTypes = ['Spice Supplier', 'Raw Material Supplier', 'Packaging Supplier', 'Transport Service'];
    if (!in_array($businessType, $allowedSupplierTypes, true)) {
        $pdo->rollBack();
        fail('Please select a valid supplier business type', 422);
    }

    $requestCode = generate_code('SUPREQ');
    $stmt = $pdo->prepare('
        INSERT INTO supplier_registration_requests
            (request_code, username, company_name, contact_person, email, phone, address, city, postal_code, materials, business_type, password, status)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "Pending")
    ');
    $stmt->execute([
        $requestCode,
        $username,
        trim((string)$input['company_name']),
        trim((string)$input['contact_person']),
        $email,
        $phone,
        $address,
        $district,
        $postalCode,
        trim((string)$input['materials']),
        $businessType,
        password_hash($password, PASSWORD_DEFAULT),
    ]);

    $pdo->commit();
    respond(true, 'Supplier registration submitted. Pending approval by admin or manager.', [
        'request_code' => $requestCode,
        'redirect' => 'index.html',
    ], 201);
});
?>
