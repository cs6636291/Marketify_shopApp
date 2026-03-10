<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp"; // ตรวจสอบชื่อ DB ให้ตรงนะครับ

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

$email = $_POST['email'] ?? '';
$pass = $_POST['password'] ?? '';
$username_gen = explode('@', $email)[0];

if (empty($email) || empty($pass)) {
    echo json_encode(["status" => "error", "message" => "กรุณากรอกข้อมูลให้ครบ"], JSON_UNESCAPED_UNICODE);
    exit;
}

// 1. เช็คว่า Email ซ้ำไหม
$checkEmail = "SELECT id FROM users WHERE email = '$email'";
$resultCheck = $conn->query($checkEmail);

if ($resultCheck->num_rows > 0) {
    echo json_encode(["status" => "error", "message" => "อีเมลนี้ถูกใช้งานแล้ว"], JSON_UNESCAPED_UNICODE);
} else {
    // 2. Hash รหัสผ่านก่อนบันทึก (สำคัญมาก!)
    $hashed_password = password_hash($pass, PASSWORD_DEFAULT);

    $sql = "INSERT INTO users (username, email, password) VALUES ('$username_gen', '$email', '$hashed_password')";
    
    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "สมัครสมาชิกสำเร็จ"], JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["status" => "error", "message" => "เกิดข้อผิดพลาด: " . $conn->error], JSON_UNESCAPED_UNICODE);
    }
}

$conn->close();
?>