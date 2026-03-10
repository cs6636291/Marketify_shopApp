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

// รับค่าจาก URL เช่น get_reviews.php?product_id=1
$product_id = isset($_GET['product_id']) ? intval($_GET['product_id']) : 0;

if ($product_id > 0) {
    // ใช้ LEFT JOIN เพื่อให้ดึงข้อมูลมาได้แม้ User จะไม่มีชื่อ (ป้องกัน Error)
    $sql = "SELECT r.rating, r.comment, r.created_at, u.username 
            FROM reviews r 
            LEFT JOIN users u ON r.user_id = u.id 
            WHERE r.product_id = $product_id";
    
    $result = $conn->query($sql);
    $reviews = array();

    while($row = $result->fetch_assoc()) {
        $reviews[] = $row;
    }
    
    // ถ้าไม่มีรีวิวเลย จะส่งเป็น Array ว่าง [] ไม่ใช่ Error
    echo json_encode($reviews, JSON_UNESCAPED_UNICODE);
} else {
    echo json_encode(["error" => "กรุณาระบุ product_id ใน URL (เช่น ?product_id=1)"]);
}

$conn->close();
?>