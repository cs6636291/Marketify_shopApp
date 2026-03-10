<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Content-Type: application/json; charset=UTF-8");
$conn = new mysqli("localhost", "root", "", "margetify_mobileapp");
$user_id = $_POST['user_id'] ?? null;
if ($user_id) {
    $stmt = $conn->prepare("UPDATE orders SET is_read = 1 WHERE user_id = ? AND is_read = 0");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    echo json_encode(["status" => "success"]);
}
$conn->close();
?>