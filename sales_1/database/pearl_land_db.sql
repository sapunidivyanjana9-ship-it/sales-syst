-- ======================================================
-- PEARL LAND COMMODITIES (PELCOMO) - COMPLETE DATABASE
-- FIXED VERSION - NO ERRORS
-- ======================================================

-- First, disable foreign key checks
SET FOREIGN_KEY_CHECKS = 0;

-- Drop database if exists and create new one
DROP DATABASE IF EXISTS pearl_land_db;
CREATE DATABASE pearl_land_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE pearl_land_db;

-- ======================================================
-- CREATE ALL TABLES (NO FOREIGN KEY CONSTRAINTS FIRST)
-- ======================================================

-- TABLE 1: users
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('manager', 'admin', 'customer', 'wholesaler', 'supplier', 'stock_clerk', 'account_clerk') NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(120),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(80),
    profile_image VARCHAR(255),
    status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    redirect_page VARCHAR(120),
    last_login TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 2: customers
CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    customer_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(80),
    last_name VARCHAR(80),
    name VARCHAR(160) NOT NULL,
    email VARCHAR(120),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(80),
    postal_code VARCHAR(20),
    district VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Sri Lanka',
    spice_preferences VARCHAR(255) DEFAULT 'General',
    newsletter_subscribed TINYINT(1) DEFAULT 0,
    loyalty_points INT DEFAULT 0,
    total_orders INT DEFAULT 0,
    total_spent DECIMAL(12,2) DEFAULT 0.00,
    account_status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 3: wholesalers
CREATE TABLE wholesalers (
    wholesaler_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    wholesaler_code VARCHAR(20) NOT NULL UNIQUE,
    first_name VARCHAR(80),
    last_name VARCHAR(80),
    company_name VARCHAR(160),
    email VARCHAR(120),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(80),
    postal_code VARCHAR(20),
    district VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Sri Lanka',
    buyer_type VARCHAR(80),
    business_type VARCHAR(80),
    registration_number VARCHAR(80),
    tax_id VARCHAR(80),
    nic VARCHAR(30),
    years_in_business INT DEFAULT 0,
    employees INT DEFAULT 0,
    turnover VARCHAR(80),
    credit_limit DECIMAL(12,2) DEFAULT 0.00,
    outstanding_balance DECIMAL(12,2) DEFAULT 0.00,
    wants_offers TINYINT(1) DEFAULT 0,
    account_status ENUM('active', 'inactive', 'pending') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 4: suppliers
CREATE TABLE suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    supplier_code VARCHAR(20) UNIQUE,
    name VARCHAR(160) NOT NULL,
    contact VARCHAR(120),
    email VARCHAR(120),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(80),
    postal_code VARCHAR(20),
    business_type VARCHAR(80),
    materials VARCHAR(255),
    payment_terms VARCHAR(80),
    orders_cost DECIMAL(12,2) DEFAULT 0.00,
    outstanding_payment DECIMAL(12,2) DEFAULT 0.00,
    rating DECIMAL(2,1) DEFAULT 0.0,
    status ENUM('active', 'inactive', 'pending', 'rejected') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 5: supplier_registration_requests
CREATE TABLE supplier_registration_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_code VARCHAR(30) NOT NULL UNIQUE,
    company_name VARCHAR(160) NOT NULL,
    contact_person VARCHAR(120),
    email VARCHAR(120),
    phone VARCHAR(20),
    address TEXT,
    city VARCHAR(80),
    materials VARCHAR(255),
    business_type VARCHAR(80),
    password VARCHAR(255),
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    rejection_reason TEXT,
    orders_cost DECIMAL(12,2) DEFAULT 0.00,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewed_by INT NULL
) ENGINE=InnoDB;

-- TABLE 6: customer_registration_requests
CREATE TABLE customer_registration_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_code VARCHAR(30) NOT NULL UNIQUE,
    first_name VARCHAR(80) NOT NULL,
    last_name VARCHAR(80) NOT NULL,
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(80),
    postal_code VARCHAR(20),
    district VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Sri Lanka',
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    confirm_password VARCHAR(255),
    spice_preferences VARCHAR(255) DEFAULT 'General',
    newsletter_subscribed TINYINT(1) DEFAULT 0,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    rejection_reason TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewed_by INT NULL
) ENGINE=InnoDB;

-- TABLE 7: wholesaler_registration_requests
CREATE TABLE wholesaler_registration_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_code VARCHAR(30) NOT NULL UNIQUE,
    company_name VARCHAR(160) NOT NULL,
    first_name VARCHAR(80),
    last_name VARCHAR(80),
    email VARCHAR(120) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    address TEXT,
    city VARCHAR(80),
    postal_code VARCHAR(20),
    district VARCHAR(80),
    country VARCHAR(80) DEFAULT 'Sri Lanka',
    business_type VARCHAR(80),
    registration_number VARCHAR(80),
    tax_id VARCHAR(80),
    nic VARCHAR(30),
    years_in_business INT DEFAULT 0,
    employees INT DEFAULT 0,
    turnover VARCHAR(80),
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    confirm_password VARCHAR(255),
    credit_limit DECIMAL(12,2) DEFAULT 50000.00,
    wants_offers TINYINT(1) DEFAULT 0,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    rejection_reason TEXT,
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reviewed_at TIMESTAMP NULL,
    reviewed_by INT NULL
) ENGINE=InnoDB;

-- TABLE 8: admin_activity_log
CREATE TABLE admin_activity_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    admin_id INT NOT NULL,
    admin_name VARCHAR(120),
    action_type VARCHAR(50) NOT NULL,
    target_type VARCHAR(50),
    target_id INT,
    target_name VARCHAR(160),
    target_email VARCHAR(120),
    remarks TEXT,
    ip_address VARCHAR(45),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 9: products
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_code VARCHAR(20) NOT NULL UNIQUE,
    name VARCHAR(120) NOT NULL,
    category VARCHAR(80),
    sub_category VARCHAR(80),
    description TEXT,
    unit VARCHAR(20) DEFAULT 'kg',
    price DECIMAL(10,2) NOT NULL,
    wholesale_price DECIMAL(10,2),
    cost_price DECIMAL(10,2) DEFAULT 0.00,
    current_stock DECIMAL(10,2) DEFAULT 0.00,
    reorder_level DECIMAL(10,2) DEFAULT 10.00,
    supplier_id INT NULL,
    image_path VARCHAR(255),
    is_available TINYINT(1) DEFAULT 1,
    min_order_qty DECIMAL(10,2) DEFAULT 1.00,
    status ENUM('active', 'inactive') DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 10: cart
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    user_role ENUM('customer', 'wholesaler') NOT NULL,
    session_id VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 11: cart_items
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    product_name VARCHAR(120) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(12,2) NOT NULL,
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 12: orders
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_code VARCHAR(30) NOT NULL UNIQUE,
    customer_id INT NULL,
    wholesaler_id INT NULL,
    order_type ENUM('customer', 'wholesaler') DEFAULT 'customer',
    cart_id INT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    delivery_date DATE NULL,
    delivery_region VARCHAR(80),
    shipping_amount DECIMAL(10,2) DEFAULT 0.00,
    subtotal DECIMAL(12,2) DEFAULT 0.00,
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    tax_amount DECIMAL(10,2) DEFAULT 0.00,
    total_amount DECIMAL(12,2) NOT NULL,
    manager_approval ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    delivery_status ENUM('pending', 'processing', 'shipped', 'delivered', 'cancelled') DEFAULT 'pending',
    payment_status ENUM('pending', 'processing', 'paid', 'failed') DEFAULT 'pending',
    tracking_number VARCHAR(100),
    notes TEXT,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 13: order_items
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NULL,
    product_name VARCHAR(120) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(12,2) NOT NULL
) ENGINE=InnoDB;

-- TABLE 14: payments
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NULL,
    customer_id INT NULL,
    wholesaler_id INT NULL,
    payment_type ENUM('customer', 'wholesaler', 'supplier') DEFAULT 'customer',
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(50),
    reference_no VARCHAR(100),
    status ENUM('pending', 'paid', 'partial', 'failed', 'refunded') DEFAULT 'pending',
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT
) ENGINE=InnoDB;

-- TABLE 15: wholesale_payments
CREATE TABLE wholesale_payments (
    wholesale_payment_id INT AUTO_INCREMENT PRIMARY KEY,
    wholesaler_id INT NOT NULL,
    order_id INT NULL,
    invoice_number VARCHAR(50),
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(50),
    reference_no VARCHAR(100),
    status ENUM('pending', 'paid', 'partial', 'overdue') DEFAULT 'pending',
    due_date DATE,
    payment_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 16: raw_materials
CREATE TABLE raw_materials (
    raw_material_id INT AUTO_INCREMENT PRIMARY KEY,
    material_name VARCHAR(120) NOT NULL,
    category VARCHAR(80),
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    quantity DECIMAL(10,2) DEFAULT 0.00,
    unit VARCHAR(20) DEFAULT 'kg',
    unit_price DECIMAL(10,2) DEFAULT 0.00,
    batch_no VARCHAR(60),
    received_date DATE,
    expiry_date DATE,
    storage_location VARCHAR(100),
    status ENUM('in_stock', 'low_stock', 'out_of_stock') DEFAULT 'in_stock',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 17: raw_material_requests
CREATE TABLE raw_material_requests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_code VARCHAR(30) NOT NULL UNIQUE,
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    material_name VARCHAR(120) NOT NULL,
    category VARCHAR(80),
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2),
    total_value DECIMAL(12,2),
    status ENUM('pending', 'approved', 'rejected', 'completed') DEFAULT 'pending',
    requested_date DATE,
    approved_date DATE,
    rejected_reason TEXT,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 18: sample_requests
CREATE TABLE sample_requests (
    sample_request_id INT AUTO_INCREMENT PRIMARY KEY,
    request_code VARCHAR(30) NOT NULL UNIQUE,
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    material_name VARCHAR(120) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    requested_date DATE,
    sample_sent_date DATE,
    status ENUM('pending', 'sample_sent', 'qc_completed', 'rejected') DEFAULT 'pending',
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 19: qc_reports
CREATE TABLE qc_reports (
    qc_report_id INT AUTO_INCREMENT PRIMARY KEY,
    sample_request_id INT NULL,
    sample_code VARCHAR(30),
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    material_name VARCHAR(120) NOT NULL,
    test_date DATE,
    result ENUM('Pass', 'Fail', 'Pending') DEFAULT 'Pending',
    quality_score DECIMAL(3,1),
    moisture_content DECIMAL(5,2),
    purity_percentage DECIMAL(5,2),
    price_suggestion DECIMAL(10,2),
    remarks TEXT,
    tested_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 20: supplier_samples
CREATE TABLE supplier_samples (
    sample_id INT AUTO_INCREMENT PRIMARY KEY,
    sample_code VARCHAR(30) NOT NULL UNIQUE,
    sample_request_id INT NULL,
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    material VARCHAR(120),
    quantity DECIMAL(10,2),
    qc_result ENUM('Pending', 'Pass', 'Fail') DEFAULT 'Pending',
    quality_score DECIMAL(3,1),
    price_suggestion DECIMAL(10,2),
    remarks TEXT,
    requested_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    inspected_at TIMESTAMP NULL
) ENGINE=InnoDB;

-- TABLE 21: purchase_orders
CREATE TABLE purchase_orders (
    purchase_order_id INT AUTO_INCREMENT PRIMARY KEY,
    po_number VARCHAR(30) NOT NULL UNIQUE,
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    sample_id INT NULL,
    material VARCHAR(120),
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_amount DECIMAL(12,2) NOT NULL,
    delivery_date DATE,
    payment_terms VARCHAR(80),
    status ENUM('Pending', 'Approved', 'Received', 'Cancelled') DEFAULT 'Pending',
    manager_approved TINYINT(1) DEFAULT 0,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP NULL
) ENGINE=InnoDB;

-- TABLE 22: purchase_order_items
CREATE TABLE purchase_order_items (
    po_item_id INT AUTO_INCREMENT PRIMARY KEY,
    purchase_order_id INT NOT NULL,
    material VARCHAR(120) NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    line_total DECIMAL(12,2) NOT NULL
) ENGINE=InnoDB;

-- TABLE 23: grns
CREATE TABLE grns (
    grn_id INT AUTO_INCREMENT PRIMARY KEY,
    grn_number VARCHAR(30) NOT NULL UNIQUE,
    purchase_order_id INT NULL,
    po_number VARCHAR(30),
    supplier_id INT NULL,
    supplier_name VARCHAR(160),
    received_date DATE,
    received_quantity DECIMAL(10,2),
    inspected_by VARCHAR(120),
    inspector_id INT NULL,
    remarks TEXT,
    amount DECIMAL(12,2) DEFAULT 0.00,
    status ENUM('Pending', 'Manager Approved', 'Rejected', 'Paid') DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    approved_at TIMESTAMP NULL
) ENGINE=InnoDB;

-- TABLE 24: supplier_payments
CREATE TABLE supplier_payments (
    supplier_payment_id INT AUTO_INCREMENT PRIMARY KEY,
    grn_id INT NULL,
    purchase_order_id INT NULL,
    supplier_id INT NOT NULL,
    invoice_number VARCHAR(50),
    amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(50),
    reference_no VARCHAR(100),
    status ENUM('pending', 'paid', 'partial', 'overdue') DEFAULT 'pending',
    due_date DATE,
    payment_date DATE,
    notes TEXT,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 25: stock_movements
CREATE TABLE stock_movements (
    movement_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NULL,
    raw_material_id INT NULL,
    movement_type ENUM('in', 'out', 'adjustment', 'return_in', 'return_out') NOT NULL,
    quantity DECIMAL(10,2) NOT NULL,
    previous_stock DECIMAL(10,2),
    new_stock DECIMAL(10,2),
    reference_type VARCHAR(50),
    reference_id INT,
    reason VARCHAR(255),
    notes TEXT,
    created_by INT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 26: returns
CREATE TABLE returns (
    return_id INT AUTO_INCREMENT PRIMARY KEY,
    return_code VARCHAR(30) NOT NULL UNIQUE,
    order_id INT NULL,
    customer_id INT NULL,
    wholesaler_id INT NULL,
    product_id INT NULL,
    product_name VARCHAR(120),
    quantity DECIMAL(10,2) NOT NULL,
    return_type ENUM('customer', 'wholesaler', 'supplier') DEFAULT 'customer',
    reason VARCHAR(120),
    details TEXT,
    return_date DATE,
    refund_amount DECIMAL(10,2) DEFAULT 0.00,
    status ENUM('pending', 'approved', 'rejected', 'completed', 'refunded') DEFAULT 'pending',
    approved_by INT NULL,
    approved_date DATE,
    rejection_reason TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 27: user_messages
CREATE TABLE user_messages (
    message_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_id INT NULL,
    receiver_id INT NULL,
    sender_role VARCHAR(50),
    receiver_role VARCHAR(50),
    sender_name VARCHAR(120),
    receiver_name VARCHAR(120),
    subject VARCHAR(160),
    message TEXT,
    is_read TINYINT(1) DEFAULT 0,
    read_at TIMESTAMP NULL,
    status ENUM('unread', 'read', 'archived', 'deleted') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- TABLE 28: notifications
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    user_role VARCHAR(50),
    type ENUM('info', 'success', 'warning', 'error', 'alert') DEFAULT 'info',
    title VARCHAR(160),
    message TEXT,
    link VARCHAR(255),
    is_read TINYINT(1) DEFAULT 0,
    read_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ======================================================
-- ADD FOREIGN KEY CONSTRAINTS (AFTER ALL TABLES CREATED)
-- ======================================================

ALTER TABLE customers ADD CONSTRAINT fk_customers_user 
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE wholesalers ADD CONSTRAINT fk_wholesalers_user 
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE suppliers ADD CONSTRAINT fk_suppliers_user 
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE customer_registration_requests ADD CONSTRAINT fk_cust_req_reviewed_by 
FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE wholesaler_registration_requests ADD CONSTRAINT fk_whole_req_reviewed_by 
FOREIGN KEY (reviewed_by) REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE admin_activity_log ADD CONSTRAINT fk_activity_admin 
FOREIGN KEY (admin_id) REFERENCES users(user_id) ON DELETE CASCADE;

ALTER TABLE products ADD CONSTRAINT fk_products_supplier 
FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id) ON DELETE SET NULL;

ALTER TABLE cart ADD CONSTRAINT fk_cart_user 
FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE;

ALTER TABLE cart_items ADD CONSTRAINT fk_cart_items_cart 
FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE;

ALTER TABLE cart_items ADD CONSTRAINT fk_cart_items_product 
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE;

ALTER TABLE orders ADD CONSTRAINT fk_orders_customer 
FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE SET NULL;

ALTER TABLE orders ADD CONSTRAINT fk_orders_wholesaler 
FOREIGN KEY (wholesaler_id) REFERENCES wholesalers(wholesaler_id) ON DELETE SET NULL;

ALTER TABLE orders ADD CONSTRAINT fk_orders_created_by 
FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL;

ALTER TABLE order_items ADD CONSTRAINT fk_order_items_order 
FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE;

ALTER TABLE order_items ADD CONSTRAINT fk_order_items_product 
FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE SET NULL;

-- ======================================================
-- STORED PROCEDURES
-- ======================================================

DELIMITER //

CREATE PROCEDURE approve_customer_registration(
    IN p_request_id INT,
    IN p_admin_id INT,
    IN p_admin_ip VARCHAR(45)
)
BEGIN
    DECLARE v_email VARCHAR(120);
    DECLARE v_username VARCHAR(50);
    DECLARE v_password VARCHAR(255);
    DECLARE v_first_name VARCHAR(80);
    DECLARE v_last_name VARCHAR(80);
    DECLARE v_phone VARCHAR(20);
    DECLARE v_address TEXT;
    DECLARE v_city VARCHAR(80);
    DECLARE v_district VARCHAR(80);
    DECLARE v_spice_preferences VARCHAR(255);
    DECLARE v_newsletter_subscribed TINYINT(1);
    DECLARE v_user_id INT;
    DECLARE v_admin_name VARCHAR(120);
    
    SELECT full_name INTO v_admin_name FROM users WHERE user_id = p_admin_id;
    
    SELECT email, username, password, first_name, last_name, phone, 
           address, city, district, spice_preferences, newsletter_subscribed
    INTO v_email, v_username, v_password, v_first_name, v_last_name, v_phone,
         v_address, v_city, v_district, v_spice_preferences, v_newsletter_subscribed
    FROM customer_registration_requests
    WHERE request_id = p_request_id;
    
    INSERT INTO users (username, password, role, full_name, email, phone, address, city, status)
    VALUES (v_username, v_password, 'customer', CONCAT(v_first_name, ' ', v_last_name), 
            v_email, v_phone, v_address, v_city, 'active');
    
    SET v_user_id = LAST_INSERT_ID();
    
    INSERT INTO customers (user_id, customer_code, first_name, last_name, name, email, 
                          phone, address, city, district, spice_preferences, newsletter_subscribed, account_status)
    VALUES (v_user_id, CONCAT('CUST', LPAD(v_user_id, 5, '0')), v_first_name, v_last_name, 
            CONCAT(v_first_name, ' ', v_last_name), v_email, v_phone, v_address, 
            v_city, v_district, v_spice_preferences, v_newsletter_subscribed, 'active');
    
    UPDATE customer_registration_requests 
    SET status = 'approved', reviewed_at = NOW(), reviewed_by = p_admin_id
    WHERE request_id = p_request_id;
    
    INSERT INTO admin_activity_log (admin_id, admin_name, action_type, target_type, target_id, target_name, target_email, ip_address)
    VALUES (p_admin_id, v_admin_name, 'approve_customer', 'customer', v_user_id, 
            CONCAT(v_first_name, ' ', v_last_name), v_email, p_admin_ip);
END//

CREATE PROCEDURE reject_customer_registration(
    IN p_request_id INT,
    IN p_admin_id INT,
    IN p_reason TEXT,
    IN p_admin_ip VARCHAR(45)
)
BEGIN
    DECLARE v_email VARCHAR(120);
    DECLARE v_first_name VARCHAR(80);
    DECLARE v_last_name VARCHAR(80);
    DECLARE v_admin_name VARCHAR(120);
    
    SELECT full_name INTO v_admin_name FROM users WHERE user_id = p_admin_id;
    
    SELECT email, first_name, last_name INTO v_email, v_first_name, v_last_name
    FROM customer_registration_requests WHERE request_id = p_request_id;
    
    UPDATE customer_registration_requests 
    SET status = 'rejected', rejection_reason = p_reason, reviewed_at = NOW(), reviewed_by = p_admin_id
    WHERE request_id = p_request_id;
    
    INSERT INTO admin_activity_log (admin_id, admin_name, action_type, target_type, target_id, target_name, target_email, remarks, ip_address)
    VALUES (p_admin_id, v_admin_name, 'reject_customer', 'customer', p_request_id, 
            CONCAT(v_first_name, ' ', v_last_name), v_email, p_reason, p_admin_ip);
END//

CREATE PROCEDURE approve_wholesaler_registration(
    IN p_request_id INT,
    IN p_admin_id INT,
    IN p_admin_ip VARCHAR(45)
)
BEGIN
    DECLARE v_email VARCHAR(120);
    DECLARE v_username VARCHAR(50);
    DECLARE v_password VARCHAR(255);
    DECLARE v_company_name VARCHAR(160);
    DECLARE v_first_name VARCHAR(80);
    DECLARE v_last_name VARCHAR(80);
    DECLARE v_phone VARCHAR(20);
    DECLARE v_address TEXT;
    DECLARE v_city VARCHAR(80);
    DECLARE v_district VARCHAR(80);
    DECLARE v_business_type VARCHAR(80);
    DECLARE v_registration_number VARCHAR(80);
    DECLARE v_credit_limit DECIMAL(12,2);
    DECLARE v_wants_offers TINYINT(1);
    DECLARE v_user_id INT;
    DECLARE v_admin_name VARCHAR(120);
    
    SELECT full_name INTO v_admin_name FROM users WHERE user_id = p_admin_id;
    
    SELECT email, username, password, company_name, first_name, last_name, phone,
           address, city, district, business_type, registration_number, credit_limit, wants_offers
    INTO v_email, v_username, v_password, v_company_name, v_first_name, v_last_name, v_phone,
         v_address, v_city, v_district, v_business_type, v_registration_number, v_credit_limit, v_wants_offers
    FROM wholesaler_registration_requests
    WHERE request_id = p_request_id;
    
    INSERT INTO users (username, password, role, full_name, email, phone, address, city, status)
    VALUES (v_username, v_password, 'wholesaler', v_company_name, 
            v_email, v_phone, v_address, v_city, 'active');
    
    SET v_user_id = LAST_INSERT_ID();
    
    INSERT INTO wholesalers (user_id, wholesaler_code, first_name, last_name, company_name, 
                           email, phone, address, city, district, business_type, 
                           registration_number, credit_limit, wants_offers, account_status)
    VALUES (v_user_id, CONCAT('WHL', LPAD(v_user_id, 5, '0')), v_first_name, v_last_name, v_company_name,
            v_email, v_phone, v_address, v_city, v_district, v_business_type,
            v_registration_number, v_credit_limit, v_wants_offers, 'active');
    
    UPDATE wholesaler_registration_requests 
    SET status = 'approved', reviewed_at = NOW(), reviewed_by = p_admin_id
    WHERE request_id = p_request_id;
    
    INSERT INTO admin_activity_log (admin_id, admin_name, action_type, target_type, target_id, target_name, target_email, ip_address)
    VALUES (p_admin_id, v_admin_name, 'approve_wholesaler', 'wholesaler', v_user_id, 
            v_company_name, v_email, p_admin_ip);
END//

CREATE PROCEDURE reject_wholesaler_registration(
    IN p_request_id INT,
    IN p_admin_id INT,
    IN p_reason TEXT,
    IN p_admin_ip VARCHAR(45)
)
BEGIN
    DECLARE v_email VARCHAR(120);
    DECLARE v_company_name VARCHAR(160);
    DECLARE v_admin_name VARCHAR(120);
    
    SELECT full_name INTO v_admin_name FROM users WHERE user_id = p_admin_id;
    
    SELECT email, company_name INTO v_email, v_company_name
    FROM wholesaler_registration_requests WHERE request_id = p_request_id;
    
    UPDATE wholesaler_registration_requests 
    SET status = 'rejected', rejection_reason = p_reason, reviewed_at = NOW(), reviewed_by = p_admin_id
    WHERE request_id = p_request_id;
    
    INSERT INTO admin_activity_log (admin_id, admin_name, action_type, target_type, target_id, target_name, target_email, remarks, ip_address)
    VALUES (p_admin_id, v_admin_name, 'reject_wholesaler', 'wholesaler', p_request_id, 
            v_company_name, v_email, p_reason, p_admin_ip);
END//

CREATE PROCEDURE get_pending_requests()
BEGIN
    SELECT 
        'Customer' AS request_type,
        request_id,
        request_code,
        CONCAT(first_name, ' ', last_name) AS name,
        email,
        phone,
        city,
        submitted_at
    FROM customer_registration_requests 
    WHERE status = 'pending'
    
    UNION ALL
    
    SELECT 
        'Wholesaler' AS request_type,
        request_id,
        request_code,
        company_name AS name,
        email,
        phone,
        city,
        submitted_at
    FROM wholesaler_registration_requests 
    WHERE status = 'pending'
    
    ORDER BY submitted_at ASC;
END//

DELIMITER ;

-- ======================================================
-- INSERT DATA
-- ======================================================

-- Insert System Users
INSERT INTO users (username, password, role, full_name, email, phone, address, city, status, redirect_page) VALUES
('manager_kamal', 'manager123', 'manager', 'Kamal Perera', 'kamal@pearlland.com', '071-0000001', 'No 308/4, Temple Road', 'Horana', 'active', 'managerdashboard.html'),
('admin_nimal', 'admin123', 'admin', 'Nimal Fernando', 'nimal@pearlland.com', '071-0000002', 'No 301/2, Medikele', 'Horana', 'active', 'admin-dashboard.html'),
('clerk_saman', 'clerk123', 'stock_clerk', 'Saman Rathnayake', 'saman@pearlland.com', '071-0000003', 'No 308/4, Temple Road', 'Horana', 'active', 'stockdashboard.html'),
('account_sunil', 'account123', 'account_clerk', 'Sunil Wickramasinghe', 'sunil@pearlland.com', '071-0000004', 'No 308/4, Temple Road', 'Horana', 'active', 'accountdashboard.html'),
('saman_cust', 'customer123', 'customer', 'Saman Perera', 'saman@gmail.com', '071-1234567', 'No 123, Galle Road', 'Colombo', 'active', 'customer.html'),
('nimal_wholesale', 'wholesaler123', 'wholesaler', 'Nimal Perera', 'nimal@wholesale.com', '077-4567890', 'Wholesale Lane', 'Colombo', 'active', 'wholeseller.html'),
('lanka_supplier', 'supplier123', 'supplier', 'Lanka Spices', 'lanka@spices.com', '071-2223333', 'Farm Road', 'Matale', 'active', 'supllierdashboard.html');

-- Insert Customers
INSERT INTO customers (user_id, customer_code, first_name, last_name, name, email, phone, address, city, postal_code, district, spice_preferences, newsletter_subscribed)
SELECT user_id, 'CUST001', 'Saman', 'Perera', 'Saman Perera', 'saman@gmail.com', '071-1234567', 'No 123, Galle Road', 'Colombo', '00300', 'Colombo', 'Chili, Turmeric, Cinnamon', 1
FROM users WHERE username = 'saman_cust';

-- Insert Wholesalers
INSERT INTO wholesalers (user_id, wholesaler_code, first_name, last_name, company_name, email, phone, address, city, postal_code, district, buyer_type, business_type, registration_number, wants_offers)
SELECT user_id, 'WHL001', 'Nimal', 'Perera', 'City Wholesale', 'nimal@wholesale.com', '077-4567890', 'Wholesale Lane', 'Colombo', '01000', 'Colombo', 'Wholesale Buyer', 'Retail Shop', 'BR-1001', 1
FROM users WHERE username = 'nimal_wholesale';

-- Insert Suppliers
INSERT INTO suppliers (supplier_id, supplier_code, name, contact, email, phone, address, city, business_type, materials, payment_terms, orders_cost, status) VALUES
(1, 'SUP001', 'Lanka Spices', 'Kamal Perera', 'lanka@spices.com', '071-2223333', 'Farm Road', 'Matale', 'Manufacturer', 'Turmeric, Chili, Pepper', '30 Days Credit', 500000.00, 'active'),
(2, 'SUP002', 'Kalutara Farmers', 'Nimal Silva', 'kalutara@farmers.com', '072-7654321', 'Growers Road', 'Kalutara', 'Farmer Group', 'Coriander, Pepper, Cinnamon', 'Cash on Delivery', 320000.00, 'active');

-- Update supplier user_id
UPDATE suppliers 
SET user_id = (SELECT user_id FROM users WHERE username = 'lanka_supplier')
WHERE supplier_code = 'SUP001';

-- Insert Products
INSERT INTO products (product_code, name, category, description, unit, price, wholesale_price, cost_price, current_stock, reorder_level, supplier_id, status) VALUES
('P001', 'Turmeric Powder', 'Spice', 'Premium Ceylon turmeric powder', 'kg', 500.00, 450.00, 320.00, 450.00, 100.00, 1, 'active'),
('P002', 'Chili Powder', 'Spice', 'Fine red chili powder', 'kg', 400.00, 360.00, 260.00, 15.00, 50.00, 1, 'active'),
('P003', 'Black Pepper', 'Spice', 'Whole black pepper corns', 'kg', 780.00, 700.00, 500.00, 8.00, 40.00, 2, 'active'),
('P004', 'Cinnamon Sticks', 'Spice', 'Ceylon cinnamon sticks', 'kg', 950.00, 850.00, 650.00, 320.00, 100.00, 2, 'active'),
('P005', 'Cardamom', 'Whole Spice', 'Green cardamom pods', 'kg', 2800.00, 2500.00, 2100.00, 25.00, 30.00, 1, 'active');

-- Insert Sample Customer Registration Requests (Pending)
INSERT INTO customer_registration_requests 
(request_code, first_name, last_name, email, phone, address, city, district, username, password, spice_preferences)
VALUES 
('REQ-CUST-001', 'Priyanka', 'Silva', 'priyanka@gmail.com', '0711234567', 'No 123, Main Street', 'Galle', 'Galle', 'priyanka_silva', 'temp123', 'Turmeric, Chili'),
('REQ-CUST-002', 'Dinesh', 'Perera', 'dinesh@gmail.com', '0727654321', 'No 45, Lake Road', 'Kandy', 'Kandy', 'dinesh_perera', 'temp123', 'Cinnamon, Pepper'),
('REQ-CUST-003', 'Kumari', 'Fernando', 'kumari@gmail.com', '0778899001', 'No 12, Beach Road', 'Negombo', 'Gampaha', 'kumari_fdo', 'temp123', 'Cardamom, Cloves');

-- Insert Sample Wholesaler Registration Requests (Pending)
INSERT INTO wholesaler_registration_requests 
(request_code, company_name, first_name, last_name, email, phone, address, city, district, business_type, registration_number, username, password, credit_limit)
VALUES 
('REQ-WHOL-001', 'City Spices Wholesale', 'Mahesh', 'Fernando', 'mahesh@cityspices.com', '0778881234', 'No 200, Commercial Area', 'Colombo', 'Colombo', 'Wholesale Trader', 'BR-2024-001', 'mahesh_wholesale', 'temp123', 100000.00),
('REQ-WHOL-002', 'Lanka Traders', 'Ruwan', 'Jayawardena', 'ruwan@lankatraders.com', '0765554321', 'No 75, Market Street', 'Negombo', 'Gampaha', 'Importer', 'BR-2024-002', 'ruwan_traders', 'temp123', 150000.00),
('REQ-WHOL-003', 'Ceylon Spice Exporters', 'Anura', 'Bandara', 'anura@ceylonspice.com', '0712223334', 'No 300, Export Zone', 'Matara', 'Matara', 'Exporter', 'BR-2024-003', 'anura_exports', 'temp123', 200000.00);

-- Insert Sample Stock Movements
INSERT INTO stock_movements (product_id, movement_type, quantity, previous_stock, new_stock, reference_type, created_by)
VALUES (2, 'out', 5.00, 20.00, 15.00, 'order', 3);

-- Insert Sample Notifications
INSERT INTO notifications (user_id, user_role, type, title, message, is_read)
VALUES (3, 'stock_clerk', 'warning', 'Low Stock Alert', 'Chili Powder stock is below reorder level (15kg < 50kg)', 0),
       (1, 'manager', 'info', 'New Supplier Registration', 'Fresh Herb Suppliers has requested registration', 0);

-- Insert Sample User Messages
INSERT INTO user_messages (sender_id, receiver_id, sender_role, receiver_role, sender_name, receiver_name, subject, message, status)
VALUES (3, 1, 'stock_clerk', 'manager', 'Saman Rathnayake', 'Kamal Perera', 'Low Stock Alert', 'Chili Powder and Black Pepper are below reorder level. Please approve purchase orders.', 'unread');

-- ======================================================
-- FINAL - ENABLE FOREIGN KEY CHECKS
-- ======================================================

SET FOREIGN_KEY_CHECKS = 1;

-- ======================================================
-- DISPLAY SUMMARY
-- ======================================================

SELECT '==================================================' AS '';
SELECT 'PEARL LAND COMMODITIES - DATABASE SETUP COMPLETE' AS '';
SELECT '==================================================' AS '';

SELECT 'Total Tables Created:' AS '';
SELECT COUNT(*) AS table_count FROM information_schema.tables WHERE table_schema = 'pearl_land_db';

SELECT 'System Users:' AS '';
SELECT username, role, email, status FROM users;

SELECT 'Pending Registration Requests:' AS '';
CALL get_pending_requests();

SELECT 'Products Summary:' AS '';
SELECT COUNT(*) AS total_products, SUM(current_stock) AS total_stock FROM products;

SELECT '==================================================' AS '';
SELECT 'DATABASE SETUP SUCCESSFUL! NO ERRORS!' AS '';
SELECT '==================================================' AS '';

-- ======================================================
-- END OF FILE
-- ======================================================