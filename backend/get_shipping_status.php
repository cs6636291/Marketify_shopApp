<?php
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Origin: *");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$order_id = isset($_GET['order_id']) ? intval($_GET['order_id']) : 0;

if ($order_id > 0) {
    $sql = "SELECT * FROM shipping WHERE order_id = $order_id";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode($row, JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["error" => "ไม่พบข้อมูลการจัดส่งสำหรับ Order ID: $order_id"]);
    }
} else {
    echo json_encode(["error" => "กรุณาระบุ order_id ใน URL"]);
}

$conn->close();
?>