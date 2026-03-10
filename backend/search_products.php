<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);
mysqli_set_charset($conn, "utf8");

if ($conn->connect_error) {
    die(json_encode([]));
}

// รับค่าทั้ง query และ category_id
$query = isset($_GET['query']) ? $_GET['query'] : '';
$category_id = isset($_GET['category_id']) ? $_GET['category_id'] : '';
$products = array();

// เริ่มต้น SQL พื้นฐาน
$sql = "SELECT p.*, s.shop_name, s.logo_url FROM products p 
        LEFT JOIN shops s ON p.shop_id = s.id WHERE 1=1";

// ถ้าส่ง category_id มา ให้กรองตาม ID (แม่นยำกว่า)
if ($category_id !== '') {
    $safe_id = $conn->real_escape_string($category_id);
    $sql .= " AND p.category_id = '$safe_id'";
} 
// ถ้าไม่ส่ง ID แต่ส่งคำค้นหามา ให้ค้นตามชื่อ
elseif ($query !== '') {
    $safe_query = $conn->real_escape_string($query);
    $sql .= " AND p.name LIKE '%$safe_query%'";
}

$result = $conn->query($sql);

if ($result) {
    while($row = $result->fetch_assoc()) {
        $products[] = [
            "id" => (string)$row['id'],
            "name" => (string)($row['name'] ?? ""),
            "price" => (string)($row['price'] ?? "0"),
            "image_url" => (string)($row['image_url'] ?? ""),
            "description" => (string)($row['description'] ?? ""),
            "stock" => (int)($row['stock'] ?? 0),
            "shop_id" => (string)$row['shop_id'],
            "shop_name" => (string)($row['shop_name'] ?? "ร้านค้าทั่วไป"),
            "logo_url" => (string)($row['logo_url'] ?? "")
        ];
    }
}

echo json_encode($products, JSON_UNESCAPED_UNICODE);
$conn->close();
?>