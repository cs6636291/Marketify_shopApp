<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn = new mysqli("localhost", "root", "", "margetify_mobileapp");
$user_id = $_GET['user_id'] ?? null;
if ($user_id) {
    $stmt = $conn->prepare("SELECT COUNT(*) as unread_count FROM orders WHERE user_id = ? AND is_read = 0");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    echo json_encode($stmt->get_result()->fetch_assoc());
}
$conn->close();
?>