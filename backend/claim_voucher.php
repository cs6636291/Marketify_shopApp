<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);
mysqli_set_charset($conn, "utf8");

$data = json_decode(file_get_contents("php://input"), true);

if (isset($data['user_id']) && isset($data['promotion_id'])) {
    $user_id = $conn->real_escape_string($data['user_id']);
    $promotion_id = $conn->real_escape_string($data['promotion_id']);

    // เช็คก่อนว่าเคยเก็บไปหรือยัง
    $check = $conn->query("SELECT id FROM user_vouchers WHERE user_id = '$user_id' AND promotion_id = '$promotion_id'");
    
    if ($check->num_rows > 0) {
        echo json_encode(["status" => "error", "message" => "คุณเก็บโค้ดนี้ไปแล้ว"]);
    } else {
        $sql = "INSERT INTO user_vouchers (user_id, promotion_id, is_used, claimed_at) 
                VALUES ('$user_id', '$promotion_id', 0, NOW())";
        if ($conn->query($sql)) {
            echo json_encode(["status" => "success", "message" => "เก็บโค้ดสำเร็จ!"]);
        } else {
            echo json_encode(["status" => "error", "message" => "เกิดข้อผิดพลาดในการเก็บโค้ด"]);
        }
    }
}
$conn->close();
?>