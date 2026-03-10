<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

$email = $_POST['email'] ?? '';
$pass = $_POST['password'] ?? '';

if (empty($email) || empty($pass)) {
    echo json_encode(["status" => "error", "message" => "กรุณากรอกข้อมูลให้ครบ"], JSON_UNESCAPED_UNICODE);
    exit;
}

$sql = "SELECT * FROM users WHERE email = '$email' LIMIT 1";
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $user = $result->fetch_assoc();
    
    if (password_verify($pass, $user['password'])) {
        echo json_encode([
            "status" => "success", 
            "message" => "Login Success",
            "user" => [
                "id" => (string)$user['id'],
                "email" => (string)$user['email'],
                "username" => (string)($user['username'] ?? ''),
                "address" => (string)($user['address'] ?? ''),
                "created_at" => (string)($user['created_at'] ?? '')
            ]
        ], JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["status" => "error", "message" => "Invalid Password"], JSON_UNESCAPED_UNICODE);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found"], JSON_UNESCAPED_UNICODE);
}

$conn->close();
?>