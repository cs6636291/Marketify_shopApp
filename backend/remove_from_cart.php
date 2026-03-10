<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

// เชื่อมต่อตามรูปแบบของคุณ
$conn = new mysqli("localhost", "root", "", "margetify_mobileapp");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

// รับค่าจาก Flutter (ใช้ POST เพื่อความปลอดภัย)
$user_id = $_POST['user_id'] ?? null;
$product_id = $_POST['product_id'] ?? null;

if ($user_id && $product_id) {
    // ใช้ prepare และ bind_param เหมือนตัวอย่างที่คุณให้มา
    $stmt = $conn->prepare("DELETE FROM cart WHERE user_id = ? AND product_id = ?");
    $stmt->bind_param("ii", $user_id, $product_id);
    
    if ($stmt->execute()) {
        echo json_encode(["status" => "success"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
}

$conn->close();
?>