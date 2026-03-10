-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 10, 2026 at 04:30 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `margetify_mobileapp`
--

-- --------------------------------------------------------

--
-- Table structure for table `cart`
--

CREATE TABLE `cart` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) DEFAULT 1,
  `added_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cart`
--

INSERT INTO `cart` (`id`, `user_id`, `product_id`, `quantity`, `added_at`) VALUES
(1, 1, 1, 2, '2026-02-23 03:52:35'),
(2, 1, 3, 1, '2026-02-23 03:52:35'),
(3, 1, 1, 1, '2026-03-06 02:06:26'),
(4, 1, 1, 1, '2026-03-06 02:20:54'),
(5, 1, 1, 1, '2026-03-06 02:53:03'),
(6, 1, 1, 1, '2026-03-06 02:53:45'),
(7, 1, 1, 1, '2026-03-06 03:22:01'),
(8, 1, 1, 2, '2026-03-06 03:39:53'),
(9, 1, 1, 2, '2026-03-06 03:55:36'),
(10, 1, 1, 1, '2026-03-06 04:57:54'),
(11, 3, 1, 7, '2026-03-07 07:32:24'),
(15, 3, 2, 2, '2026-03-06 13:14:41'),
(16, 5, 3, 3, '2026-03-06 15:33:36'),
(17, 5, 1, 1, '2026-03-06 16:25:49');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`) VALUES
(1, 'Clothing'),
(2, 'Accessories'),
(3, 'Gadgets');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `promotion_id` int(11) DEFAULT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `discount_amount` decimal(10,2) DEFAULT 0.00,
  `net_amount` decimal(10,2) DEFAULT NULL,
  `status` enum('pending','paid','shipped','cancelled','completed') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `promotion_id`, `total_price`, `discount_amount`, `net_amount`, `status`, `created_at`, `is_read`) VALUES
(1, 1, NULL, 1900.00, 0.00, NULL, 'paid', '2026-02-23 03:53:00', 0),
(4, 3, 1, 990.00, 10.00, 980.00, 'paid', '2026-03-07 05:52:24', 1),
(5, 3, 2, 290.00, 50.00, 240.00, 'completed', '2026-03-07 05:52:55', 1),
(6, 3, NULL, 990.00, 0.00, 990.00, 'paid', '2026-03-07 06:33:10', 1),
(7, 3, NULL, 4010.00, 0.00, 4010.00, 'paid', '2026-03-07 07:32:52', 1),
(8, 4, NULL, 290.00, 0.00, 290.00, 'completed', '2026-03-08 09:00:17', 1),
(9, 4, NULL, 990.00, 0.00, 990.00, 'completed', '2026-03-08 09:21:37', 1),
(10, 4, NULL, 150.00, 0.00, 150.00, 'paid', '2026-03-08 09:35:21', 1),
(11, 4, NULL, 990.00, 0.00, 990.00, 'shipped', '2026-03-08 09:44:45', 1),
(12, 4, 2, 2300.00, 50.00, 2250.00, 'paid', '2026-03-08 15:30:49', 1),
(13, 4, NULL, 990.00, 0.00, 990.00, 'completed', '2026-03-09 01:10:18', 1),
(14, 4, NULL, 150.00, 0.00, 150.00, 'paid', '2026-03-09 01:21:02', 1),
(15, 4, NULL, 290.00, 0.00, 290.00, 'paid', '2026-03-09 01:32:07', 1),
(16, 4, NULL, 990.00, 0.00, 990.00, 'paid', '2026-03-09 01:32:35', 1),
(17, 4, NULL, 990.00, 0.00, 990.00, 'paid', '2026-03-09 01:48:40', 1),
(18, 4, NULL, 150.00, 0.00, 150.00, 'paid', '2026-03-09 01:49:21', 1),
(19, 4, NULL, 990.00, 0.00, 990.00, 'paid', '2026-03-09 02:01:51', 1),
(20, 4, NULL, 2600.00, 0.00, 2600.00, 'paid', '2026-03-09 18:07:15', 1),
(21, 4, NULL, 2750.00, 0.00, 2750.00, 'paid', '2026-03-09 18:22:16', 1),
(22, 4, NULL, 290.00, 0.00, 290.00, 'paid', '2026-03-09 18:38:54', 1),
(23, 4, NULL, 290.00, 0.00, 290.00, 'paid', '2026-03-09 18:41:06', 1),
(24, 4, NULL, 290.00, 0.00, 290.00, 'paid', '2026-03-10 02:07:40', 1),
(25, 4, NULL, 290.00, 0.00, 290.00, 'paid', '2026-03-10 02:23:31', 1),
(26, 4, NULL, 990.00, 0.00, 990.00, 'paid', '2026-03-10 02:23:54', 1),
(27, 4, NULL, 300.00, 0.00, 300.00, 'paid', '2026-03-10 02:24:31', 1),
(28, 4, NULL, 990.00, 0.00, 990.00, 'paid', '2026-03-10 02:56:15', 1),
(29, 4, NULL, 580.00, 0.00, 580.00, 'paid', '2026-03-10 02:56:48', 1),
(30, 4, NULL, 290.00, 0.00, 290.00, 'paid', '2026-03-10 02:57:36', 1),
(31, 4, 1, 290.00, 10.00, 280.00, 'paid', '2026-03-10 03:20:34', 1),
(32, 3, NULL, 4010.00, 0.00, 4050.00, 'paid', '2026-03-10 13:35:02', 1);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price_at_purchase` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `product_id`, `quantity`, `price_at_purchase`) VALUES
(1, 1, 1, 2, 350.00),
(2, 1, 3, 1, 1200.00),
(3, 4, 2, 1, 990.00),
(4, 5, 1, 1, 290.00),
(5, 6, 2, 1, 990.00),
(6, 7, 1, 7, 290.00),
(7, 7, 2, 2, 990.00),
(8, 8, 1, 1, 290.00),
(9, 9, 2, 1, 990.00),
(10, 10, 3, 1, 150.00),
(11, 11, 2, 1, 990.00),
(12, 12, 1, 4, 290.00),
(13, 12, 2, 1, 990.00),
(14, 12, 3, 1, 150.00),
(15, 13, 2, 1, 990.00),
(16, 14, 3, 1, 150.00),
(17, 15, 1, 1, 290.00),
(18, 16, 2, 1, 990.00),
(19, 17, 2, 1, 990.00),
(20, 18, 3, 1, 150.00),
(21, 19, 2, 1, 990.00),
(22, 20, 1, 4, 290.00),
(23, 20, 2, 1, 990.00),
(24, 20, 3, 3, 150.00),
(25, 21, 1, 4, 290.00),
(26, 21, 2, 1, 990.00),
(27, 21, 3, 4, 150.00),
(28, 22, 1, 1, 290.00),
(29, 23, 1, 1, 290.00),
(30, 24, 1, 1, 290.00),
(31, 25, 1, 1, 290.00),
(32, 26, 2, 1, 990.00),
(33, 27, 3, 2, 150.00),
(34, 28, 2, 1, 990.00),
(35, 29, 1, 2, 290.00),
(36, 30, 1, 1, 290.00),
(37, 31, 1, 1, 290.00),
(38, 32, 1, 7, 290.00),
(39, 32, 2, 2, 990.00);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL,
  `stock` int(11) DEFAULT 0,
  `image_url` varchar(255) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `shop_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`id`, `name`, `description`, `price`, `stock`, `image_url`, `category_id`, `shop_id`, `created_at`) VALUES
(1, 'เสื้อยืดสีขาว', 'เสื้อผ้าฝ้าย 100% ใส่สบาย', 290.00, 44, 'white_tshirt.jpg', 1, 1, '2026-02-22 15:22:57'),
(2, 'เสื้อกางเกงยีนส์', 'กางเกงยีนส์ทรงกระบอก สีเข้ม', 990.00, 18, 'blue_jeans.jpg', 1, 1, '2026-02-22 15:22:57'),
(3, 'หมวกแก๊ป', 'หมวกสีดำ กันแดดได้ดี', 150.00, 98, 'black_cap.jpg', 2, 1, '2026-02-22 15:22:57'),
(4, 'เสื้อยืดสีดำ', 'เสื้อยืดผ้าฝ้าย ใส่สบาย', 320.00, 50, 'black_tshirt.jpg', 1, 1, '2026-03-10 13:07:44'),
(5, 'เสื้อฮู้ดสีเทา', 'เสื้อฮู้ดกันหนาว ผ้านุ่ม', 790.00, 25, 'gray_hoodie.jpg', 1, 1, '2026-03-10 13:07:44'),
(6, 'เสื้อเชิ้ตลายสก็อต', 'เสื้อเชิ้ตลำลอง ลายสก็อต', 650.00, 30, 'plaid_shirt.jpg', 1, 1, '2026-03-10 13:07:44'),
(7, 'กางเกงขาสั้น', 'กางเกงขาสั้น ใส่สบาย', 450.00, 40, 'shorts.jpg', 1, 1, '2026-03-10 13:07:44'),
(8, 'เสื้อโปโล', 'เสื้อโปโลสุภาพ ใส่ทำงานได้', 520.00, 35, 'polo_shirt.jpg', 1, 1, '2026-03-10 13:07:44'),
(9, 'แจ็คเก็ตยีนส์', 'แจ็คเก็ตยีนส์แฟชั่น', 1200.00, 15, 'denim_jacket.jpg', 1, 1, '2026-03-10 13:07:44'),
(10, 'กางเกงสแลค', 'กางเกงสแลคสุภาพ', 880.00, 22, 'slacks.jpg', 1, 1, '2026-03-10 13:07:44'),
(11, 'เสื้อกล้าม', 'เสื้อกล้ามผ้าฝ้าย ระบายอากาศดี', 190.00, 60, 'tank_top.jpg', 1, 1, '2026-03-10 13:07:44'),
(12, 'เสื้อกันหนาว', 'เสื้อกันหนาวผ้าฟลีซ', 990.00, 18, 'sweater.jpg', 1, 1, '2026-03-10 13:07:44'),
(13, 'กางเกงวอร์ม', 'กางเกงวอร์มใส่ออกกำลังกาย', 540.00, 33, 'jogger.jpg', 1, 1, '2026-03-10 13:07:44'),
(14, 'หมวกแก๊ปสีขาว', 'หมวกแฟชั่น กันแดด', 180.00, 70, 'white_cap.jpg', 2, 1, '2026-03-10 13:07:44'),
(15, 'หมวกบัคเก็ต', 'หมวกทรง bucket สุดเท่', 220.00, 55, 'bucket_hat.jpg', 2, 1, '2026-03-10 13:07:44'),
(16, 'เข็มขัดหนัง', 'เข็มขัดหนังแท้', 350.00, 40, 'leather_belt.jpg', 2, 1, '2026-03-10 13:07:44'),
(17, 'แว่นกันแดด', 'แว่นกันแดดแฟชั่น', 450.00, 28, 'sunglasses.jpg', 2, 1, '2026-03-10 13:07:44'),
(18, 'กระเป๋าสะพาย', 'กระเป๋าสะพายข้าง ใส่ของได้เยอะ', 650.00, 20, 'shoulder_bag.jpg', 2, 1, '2026-03-10 13:07:44'),
(19, 'กระเป๋าสตางค์', 'กระเป๋าสตางค์หนัง', 390.00, 45, 'wallet.jpg', 2, 1, '2026-03-10 13:07:44'),
(20, 'ผ้าพันคอ', 'ผ้าพันคอแฟชั่น', 210.00, 30, 'scarf.jpg', 2, 1, '2026-03-10 13:07:44'),
(21, 'ถุงเท้า', 'ถุงเท้าผ้าฝ้าย นุ่มสบาย', 90.00, 100, 'socks.jpg', 2, 1, '2026-03-10 13:07:44'),
(22, 'กำไลข้อมือ', 'กำไลแฟชั่น', 120.00, 75, 'bracelet.jpg', 2, 1, '2026-03-10 13:07:44'),
(23, 'แหวนแฟชั่น', 'แหวนสแตนเลส', 150.00, 60, 'ring.jpg', 2, 1, '2026-03-10 13:07:44'),
(24, 'หูฟังบลูทูธ', 'หูฟังไร้สาย เสียงคมชัด', 1290.00, 25, 'bluetooth_earbuds.jpg', 3, 1, '2026-03-10 13:07:44'),
(25, 'เมาส์ไร้สาย', 'เมาส์ wireless ใช้งานสะดวก', 450.00, 40, 'wireless_mouse.jpg', 3, 1, '2026-03-10 13:07:44'),
(26, 'คีย์บอร์ดเกมมิ่ง', 'คีย์บอร์ด mechanical', 1590.00, 18, 'gaming_keyboard.jpg', 3, 1, '2026-03-10 13:07:44'),
(27, 'ลำโพงบลูทูธ', 'ลำโพงพกพา เสียงดี', 990.00, 27, 'bluetooth_speaker.jpg', 3, 1, '2026-03-10 13:07:44'),
(28, 'พาวเวอร์แบงค์', 'แบตสำรอง 10000mAh', 690.00, 35, 'powerbank.jpg', 3, 1, '2026-03-10 13:07:44'),
(29, 'สายชาร์จ USB-C', 'สายชาร์จเร็ว', 120.00, 90, 'usb_c_cable.jpg', 3, 1, '2026-03-10 13:07:44'),
(30, 'แท่นวางมือถือ', 'แท่นวางมือถือปรับระดับได้', 180.00, 50, 'phone_stand.jpg', 3, 1, '2026-03-10 13:07:44'),
(31, 'ไฟริงไลท์', 'ไฟ ring light สำหรับถ่ายรูป', 750.00, 15, 'ring_light.jpg', 3, 1, '2026-03-10 13:07:44'),
(32, 'กล้องเว็บแคม', 'เว็บแคมสำหรับประชุมออนไลน์', 890.00, 12, 'webcam.jpg', 3, 1, '2026-03-10 13:07:44'),
(33, 'ฮับ USB', 'USB hub เพิ่มพอร์ต', 340.00, 28, 'usb_hub.jpg', 3, 1, '2026-03-10 13:07:44');

-- --------------------------------------------------------

--
-- Table structure for table `promotions`
--

CREATE TABLE `promotions` (
  `id` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `promotion_type` enum('discount','free_shipping') DEFAULT 'discount',
  `discount_type` enum('percent','fixed') NOT NULL,
  `discount_value` decimal(10,2) NOT NULL,
  `min_order_amount` decimal(10,2) DEFAULT 0.00,
  `limit_count` int(11) DEFAULT 0,
  `claimed_count` int(11) DEFAULT 0,
  `expiry_date` date NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `promotions`
--

INSERT INTO `promotions` (`id`, `code`, `promotion_type`, `discount_type`, `discount_value`, `min_order_amount`, `limit_count`, `claimed_count`, `expiry_date`, `created_at`) VALUES
(1, 'WELCOME10', 'discount', '', 10.00, 0.00, 2, 2, '2026-12-31', '2026-03-07 03:49:27'),
(2, 'HOT50', 'discount', 'fixed', 50.00, 300.00, 5, 2, '2026-12-31', '2026-03-07 03:49:27');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` int(11) DEFAULT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`id`, `product_id`, `user_id`, `rating`, `comment`, `created_at`) VALUES
(6, 1, 1, 5, 'สินค้าดีมากครับ ส่งไวมาก เนื้อผ้าดีเกินราคา!', '2026-03-03 19:01:34'),
(7, 1, 2, 4, 'โดยรวมโอเคค่ะ แต่สีเพี้ยนจากรูปนิดหน่อย', '2026-03-03 19:01:34'),
(8, 2, 1, 5, 'แพ็คสินค้ามาดีมาก ประทับใจสุดๆ ซื้อซ้ำแน่นอน', '2026-03-03 19:01:34'),
(9, 2, 2, 5, 'ใช้ดีบอกต่อครับ ของแท้แน่นอน', '2026-03-03 19:01:34'),
(10, 3, 1, 3, 'ใช้งานได้ปกติครับ แต่ขนส่งส่งช้าไปหน่อย', '2026-03-03 19:01:34');

-- --------------------------------------------------------

--
-- Table structure for table `shipping`
--

CREATE TABLE `shipping` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `tracking_number` varchar(100) DEFAULT NULL,
  `carrier_name` varchar(100) DEFAULT NULL,
  `status` enum('preparing','in_transit','delivered','returned') DEFAULT 'preparing',
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `shops`
--

CREATE TABLE `shops` (
  `id` int(11) NOT NULL,
  `shop_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `shops`
--

INSERT INTO `shops` (`id`, `shop_name`, `description`, `logo_url`, `user_id`, `created_at`) VALUES
(1, 'ร้านสบายใจจังเลย', 'ร้านขายเสื้อผ้าและสินค้าจากต่างประเทศ ในราคาถูก พร้อมคุณภาพคับราคาที่หาจากที่ไหนไม่ได้อีก', 'shop1.jpg', 1, '2026-02-23 05:49:59');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `email` varchar(100) NOT NULL,
  `address` text DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `address`, `phone`, `created_at`) VALUES
(1, 'member01', '1111', 'member01@email.com', '123 Rama 9, Bangkok, Thailand', '0812345678', '2026-02-23 03:52:11'),
(2, 'member02', '2222', 'member02@email.com', '456 Rama 9, Bangkok, Thailand', '0812345678', '2026-02-23 03:52:11'),
(3, 'gukgukkai', '$2y$10$cEXZj6t5kqWbNXR6RnFu0uj/QqaY5Jg13ld.KjfbWgI8YiO2Hivc6', 'gukguk@gmail.com', '456 tawanchai road Bangkok , Thailand10100', '0984848484', '2026-03-06 07:41:56'),
(4, 'kai', '$2y$10$F4FYlo4h0xlrJAd61CDGm.J5UKdtpgIj0/0luXFe/nTjFPhmuphI6', 'kaima@gmail.com', '123456 serithis', 'ยังไม่ได้ระบุเบอร์โท', '2026-03-06 11:50:17'),
(5, 'taaaan1', '$2y$10$DfJWf57yzPTGxiZ3siKrNeabqbqt8Q6Ol0VDSBZ.MKQ5ktfiAatRe', 'taan@gmail.com', '123 serithai road', '0888888888', '2026-03-06 13:16:44');

-- --------------------------------------------------------

--
-- Table structure for table `user_vouchers`
--

CREATE TABLE `user_vouchers` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `promotion_id` int(11) NOT NULL,
  `is_used` tinyint(1) DEFAULT 0,
  `claimed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_vouchers`
--

INSERT INTO `user_vouchers` (`id`, `user_id`, `promotion_id`, `is_used`, `claimed_at`) VALUES
(1, 3, 1, 1, '2026-03-07 04:59:05'),
(2, 3, 2, 1, '2026-03-07 04:59:30'),
(3, 4, 1, 1, '2026-03-08 15:29:30'),
(4, 4, 2, 1, '2026-03-08 15:29:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `promotion_id` (`promotion_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `shop_id` (`shop_id`);

--
-- Indexes for table `promotions`
--
ALTER TABLE `promotions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `shipping`
--
ALTER TABLE `shipping`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`);

--
-- Indexes for table `shops`
--
ALTER TABLE `shops`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_vouchers`
--
ALTER TABLE `user_vouchers`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart`
--
ALTER TABLE `cart`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=40;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `promotions`
--
ALTER TABLE `promotions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `shipping`
--
ALTER TABLE `shipping`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `shops`
--
ALTER TABLE `shops`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user_vouchers`
--
ALTER TABLE `user_vouchers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cart_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`promotion_id`) REFERENCES `promotions` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`);

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `products_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `products_ibfk_2` FOREIGN KEY (`shop_id`) REFERENCES `shops` (`id`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shipping`
--
ALTER TABLE `shipping`
  ADD CONSTRAINT `shipping_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `shops`
--
ALTER TABLE `shops`
  ADD CONSTRAINT `shops_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
