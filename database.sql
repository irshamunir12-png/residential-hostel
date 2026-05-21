-- Universal Hostel ERP - Database Export
-- Residence Hostel ERP - Final Consolidated Database
-- Everything in one file for easy setup

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

-- --------------------------------------------------------

-- 1. Roles Table
CREATE TABLE `sys_roles` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `role_key` varchar(50) NOT NULL UNIQUE,
  `role_name` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `sys_roles` (`role_key`, `role_name`) VALUES
('super_admin', 'Super Admin'),
('warden', 'Hostel Warden'),
('student', 'Student');

-- 2. Users Table
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL UNIQUE,
  `password` varchar(255) NOT NULL,
  `role` varchar(50) NOT NULL,
  `registration_no` varchar(50) DEFAULT NULL,
  `phone` varchar(25) DEFAULT NULL,
  `identity_no` varchar(50) DEFAULT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `guardian_name` varchar(100) DEFAULT NULL,
  `emergency_contact` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_deleted` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Default Admin (Password: 123456)
INSERT INTO `users` (`name`, `email`, `password`, `role`, `is_active`) VALUES
('System Admin', 'admin@hostel.com', '$2y$10$8WkSIdY3X6QpY1Y/5.G0uekF6qR4F9pY.A8nCjZzMhV6fG5C7Y5Q.', 'super_admin', 1);

-- Default Warden & Student (Password: 123456)
INSERT INTO `users` (`name`, `email`, `password`, `role`, `is_active`) VALUES ('Main Warden', 'warden@hostel.com', '$2y$10$8WkSIdY3X6QpY1Y/5.G0uekF6qR4F9pY.A8nCjZzMhV6fG5C7Y5Q.', 'warden', 1);
INSERT INTO `users` (`name`, `email`, `password`, `role`, `registration_no`, `is_active`) VALUES ('Test Student', 'student@hostel.com', '$2y$10$8WkSIdY3X6QpY1Y/5.G0uekF6qR4F9pY.A8nCjZzMhV6fG5C7Y5Q.', 'student', 'ST-2024-001', 1);

-- 3. System Pages & Menu
CREATE TABLE `sys_pages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parent_id` int(11) DEFAULT 0,
  `page_name` varchar(100) NOT NULL,
  `page_url` varchar(255) NOT NULL,
  `icon_class` varchar(100) DEFAULT 'bi bi-circle',
  `sort_order` int(11) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Access Matrix
CREATE TABLE `role_access` (
  `role_key` varchar(50) NOT NULL,
  `page_id` int(11) NOT NULL,
  PRIMARY KEY (`role_key`,`page_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Rooms Table
CREATE TABLE `rooms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `building` varchar(100) NOT NULL,
  `block` varchar(50) DEFAULT NULL,
  `room_no` varchar(50) NOT NULL,
  `room_type` enum('student','staff','office') DEFAULT 'student',
  `capacity` int(11) DEFAULT 1,
  `gender` varchar(20) DEFAULT 'Any',
  `washroom_type` varchar(50) DEFAULT 'common',
  `notes` text DEFAULT NULL,
  `status` varchar(20) DEFAULT 'active',
  `is_deleted` tinyint(1) DEFAULT 0,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Room Allocations
CREATE TABLE `room_allocations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `room_id` int(11) NOT NULL,
  `bed_no` int(11) DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Student Fees
CREATE TABLE `student_fees` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `paid_amount` decimal(10,2) DEFAULT 0.00,
  `due_date` date NOT NULL,
  `paid_date` date DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Unpaid',
  `payment_receipt` varchar(255) DEFAULT NULL,
  `admin_remarks` text DEFAULT NULL,
  `created_at` timestamp DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Complaints
CREATE TABLE `complaints` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `priority` enum('Low','Medium','High') DEFAULT 'Low',
  `status` enum('pending','in_progress','resolved','rejected') DEFAULT 'pending',
  `sla_breached` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT current_timestamp(),
  `updated_at` timestamp DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7.1 Complaint Categories (For SLA Logic)
CREATE TABLE `complaint_categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category_name` varchar(100) NOT NULL,
  `sla_hours` int(11) DEFAULT 24,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `complaint_categories` (category_name, sla_hours) VALUES ('Plumbing', 12), ('Electrical', 6), ('Internet', 4), ('Other', 48);

-- 9. Inventory & Assets
CREATE TABLE `inventory` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `item_name` varchar(255) NOT NULL,
  `category` varchar(100) DEFAULT NULL,
  `quantity` int(11) DEFAULT 1,
  `location` varchar(255) DEFAULT NULL,
  `item_condition` varchar(50) DEFAULT 'Good',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `asset_categories` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `category_name` varchar(100) NOT NULL UNIQUE,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
INSERT INTO `asset_categories` (category_name) VALUES ('Bedding'), ('Furniture'), ('Electronics');

CREATE TABLE `assets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `asset_name` varchar(255) NOT NULL,
  `asset_tag` varchar(100) NOT NULL UNIQUE,
  `category_id` int(11) DEFAULT NULL,
  `purchase_date` date DEFAULT NULL,
  `purchase_price` decimal(10,2) DEFAULT 0.00,
  `status` varchar(50) DEFAULT 'available',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE `asset_allocations` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `asset_id` int(11) NOT NULL,
    `allocated_to_type` enum('student', 'room') NOT NULL,
    `allocated_to_id` int(11) NOT NULL,
    `issue_date` date NOT NULL,
    `return_date` date DEFAULT NULL,
    `condition_on_issue` varchar(100),
    `condition_on_return` varchar(100),
    `is_active` tinyint(1) NOT NULL DEFAULT 1,
    `notes` text DEFAULT NULL,
    `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10. Gate Logs
CREATE TABLE `gate_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `log_type` enum('in','out') NOT NULL,
  `is_late` tinyint(1) DEFAULT 0,
  `log_time` timestamp DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 10.1 Visitors
CREATE TABLE `visitors` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `student_id` int(11) NOT NULL,
  `visitor_name` varchar(100) NOT NULL,
  `visitor_cnic` varchar(20) DEFAULT NULL,
  `check_in` timestamp DEFAULT CURRENT_TIMESTAMP,
  `check_out` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 11. Mess Menu
CREATE TABLE `mess_menu` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `day_of_week` varchar(20) NOT NULL UNIQUE,
  `breakfast` text DEFAULT NULL,
  `lunch` text DEFAULT NULL,
  `dinner` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 12. System Settings
CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL UNIQUE,
  `setting_value` text DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO `system_settings` (`setting_key`, `setting_value`) VALUES
('system_name', 'Residential Hostel'),
('footer_text', 'Copyright © 2024 Residential Hostel. All rights reserved.'),
('curfew_time', '22:00:00'),
('currency_symbol', 'PKR'); -- Changed from Universal Hostels to Residential Hostel

-- 13. Attendance
CREATE TABLE `attendance` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `status` enum('Present','Absent','Leave') NOT NULL DEFAULT 'Present',
  `created_at` timestamp DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 14. Notifications
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 14.1 Student Leaves
CREATE TABLE `student_leaves` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 15. Student Profiles
CREATE TABLE `student_profiles` (
  `user_id` int(11) NOT NULL UNIQUE,
  `phone` varchar(25) DEFAULT NULL,
  `gender` varchar(20) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `address` text DEFAULT NULL,
  PRIMARY KEY (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 16. Announcements
CREATE TABLE `announcements` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `expiry_date` date DEFAULT NULL,
  `is_pinned` tinyint(1) DEFAULT 0,
  `is_deleted` tinyint(1) DEFAULT 0,
  `created_at` timestamp DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 17. Dispute Reports
CREATE TABLE `dispute_reports` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `status` enum('open','resolved') DEFAULT 'open',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

COMMIT;