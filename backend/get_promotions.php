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

// ดึงโปรโมชั่นที่จำนวนการเก็บ (claimed_count) ยังไม่ครบขีดจำกัด (limit_count)
$sql = "SELECT * FROM promotions WHERE claimed_count < limit_count";
$result = $conn->query($sql);

$promos = array();
if ($result) {
    while($row = $result->fetch_assoc()) {
        $promos[] = [
            "id" => (string)$row['id'],
            "code" => (string)$row['code'],
            "discount_type" => (string)$row['discount_type'],
            "discount_value" => (float)($row['discount_value'] ?? 0),
            "min_order" => (float)($row['min_order_amount'] ?? 0),
            "limit" => (int)($row['limit_count'] ?? 0),
            "claimed" => (int)($row['claimed_count'] ?? 0)
        ];
    }
}

echo json_encode($promos, JSON_UNESCAPED_UNICODE);
$conn->close();
?>