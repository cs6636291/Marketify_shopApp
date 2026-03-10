<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $user_id = $_POST['user_id'];
    $new_username = $_POST['username'];
    $new_address = $_POST['address'];
    $new_phone = $_POST['phone'];

    // Update ข้อมูลตาม user_id
    $sql = "UPDATE users SET username = '$new_username', address = '$new_address', phone = '$new_phone' WHERE id = '$user_id'";

    if ($conn->query($sql) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Update successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error updating record: " . $conn->error]);
    }
}
$conn->close();
?>