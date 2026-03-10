<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
$conn = new mysqli("localhost", "root", "", "margetify_mobileapp");
$user_id = $_GET['user_id'] ?? null;
if ($user_id) {
    $stmt = $conn->prepare("SELECT id, status, created_at FROM orders WHERE user_id = ? ORDER BY created_at DESC");
    $stmt->bind_param("i", $user_id);
    $stmt->execute();
    echo json_encode($stmt->get_result()->fetch_all(MYSQLI_ASSOC));
}
$conn->close();
?>