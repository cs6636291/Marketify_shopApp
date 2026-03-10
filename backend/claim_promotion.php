<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);
mysqli_set_charset($conn, "utf8");

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "เชื่อมต่อฐานข้อมูลล้มเหลว"]));
}

$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : '';
$promo_id = isset($_POST['promotion_id']) ? $_POST['promotion_id'] : '';

if (empty($user_id) || empty($promo_id)) {
    echo json_encode(["status" => "error", "message" => "ข้อมูลไม่ครบ"]);
    exit;
}

// 1. เช็คว่าเคยเก็บไปหรือยัง
$check_stmt = $conn->prepare("SELECT id FROM user_vouchers WHERE user_id = ? AND promotion_id = ?");
$check_stmt->bind_param("ss", $user_id, $promo_id);
$check_stmt->execute();
$check_result = $check_stmt->get_result();

if ($check_result->num_rows > 0) {
    echo json_encode(["status" => "already_claimed", "message" => "คุณเก็บโค้ดนี้ไปแล้ว"]);
    exit;
}

// 2. เช็คว่าโค้ดเต็มหรือยัง
$promo_stmt = $conn->prepare("SELECT limit_count, claimed_count FROM promotions WHERE id = ?");
$promo_stmt->bind_param("s", $promo_id);
$promo_stmt->execute();
$promo = $promo_stmt->get_result()->fetch_assoc();

if ($promo['claimed_count'] >= $promo['limit_count']) {
    echo json_encode(["status" => "full", "message" => "ขออภัย โค้ดนี้ถูกเก็บครบจำนวนแล้ว"]);
    exit;
}

// 3. ทำการบันทึก (Transaction)
$conn->begin_transaction();
try {
    // เพิ่มยอด claimed_count
    $update_sql = "UPDATE promotions SET claimed_count = claimed_count + 1 WHERE id = ?";
    $upd_stmt = $conn->prepare($update_sql);
    $upd_stmt->bind_param("s", $promo_id);
    $upd_stmt->execute();

    // บันทึกการเก็บของ User
    $insert_sql = "INSERT INTO user_vouchers (user_id, promotion_id) VALUES (?, ?)";
    $ins_stmt = $conn->prepare($insert_sql);
    $ins_stmt->bind_param("ss", $user_id, $promo_id);
    $ins_stmt->execute();

    $conn->commit();
    echo json_encode(["status" => "success", "message" => "เก็บโค้ดสำเร็จ!"]);
} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["status" => "error", "message" => "เกิดข้อผิดพลาดในการบันทึก"]);
}

$conn->close();
?>