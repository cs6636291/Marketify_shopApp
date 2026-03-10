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

// รับค่าจาก URL เช่น get_shop_profile.php?id=1
$shop_id = isset($_GET['id']) ? intval($_GET['id']) : 0;

if ($shop_id > 0) {
    $sql = "SELECT id, shop_name, description, logo_url FROM shops WHERE id = $shop_id";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        echo json_encode($row, JSON_UNESCAPED_UNICODE);
    } else {
        echo json_encode(["error" => "ไม่พบข้อมูลร้านค้า ID: $shop_id"]);
    }
} else {
    echo json_encode(["error" => "กรุณาระบุ id ร้านค้าใน URL (เช่น ?id=1)"]);
}

$conn->close();
?>