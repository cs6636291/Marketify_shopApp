<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$conn = new mysqli("localhost", "root", "", "margetify_mobileapp");
mysqli_set_charset($conn, "utf8");

$user_id = $_GET['user_id'];

// นับจำนวนแยกตามสถานะ
$sql = "SELECT 
            SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as to_pay,
            SUM(CASE WHEN status = 'paid' THEN 1 ELSE 0 END) as to_ship,
            SUM(CASE WHEN status = 'shipped' THEN 1 ELSE 0 END) as to_receive,
            SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END) as to_rate
        FROM orders 
        WHERE user_id = '$user_id'";

$result = $conn->query($sql);
$counts = $result->fetch_assoc();

// ส่งคืนค่าเป็นตัวเลข (ถ้าไม่มีให้เป็น 0)
echo json_encode([
    "to_pay" => (int)($counts['to_pay'] ?? 0),
    "to_ship" => (int)($counts['to_ship'] ?? 0),
    "to_receive" => (int)($counts['to_receive'] ?? 0),
    "to_rate" => (int)($counts['to_rate'] ?? 0)
]);

$conn->close();
?>