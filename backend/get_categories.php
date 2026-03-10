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

// ดึงข้อมูลจากตาราง categories
$sql = "SELECT id, name FROM categories";
$result = $conn->query($sql);

$categories = array();
if ($result->num_rows > 0) {
    while($row = $result->fetch_assoc()) {
        $categories[] = $row;
    }
}

echo json_encode($categories, JSON_UNESCAPED_UNICODE);
$conn->close();
?>