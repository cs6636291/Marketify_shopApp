<?php
error_reporting(0);
ini_set('display_errors', 0);

header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

// ส่วนเชื่อมต่อ Database
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);
mysqli_set_charset($conn, "utf8");

if ($conn->connect_error) {
    die(json_encode([]));
}

// รับค่า user_id จากแอป
$user_id = isset($_GET['user_id']) ? $conn->real_escape_string($_GET['user_id']) : '';

$vouchers = array();

if ($user_id !== '') {
    // ดึงข้อมูลโค้ดที่ User เก็บไว้ โดย Join กับตาราง promotions เพื่อเอาค่า promotion_type มาด้วย
    $sql = "SELECT uv.id as voucher_id, p.* FROM user_vouchers uv 
            INNER JOIN promotions p ON uv.promotion_id = p.id 
            WHERE uv.user_id = '$user_id' AND uv.is_used = 0";

    $result = $conn->query($sql);

    if ($result) {
        while($row = $result->fetch_assoc()) {
            $vouchers[] = [
                "voucher_id" => (string)$row['voucher_id'],
                "id" => (string)$row['id'],
                "code" => (string)$row['code'],
                "discount_type" => (string)$row['discount_type'],
                "discount_value" => (float)$row['discount_value'],
                "min_order" => (float)$row['min_order_amount'],
                // เพิ่มบรรทัดนี้เพื่อให้ Flutter แยกได้ว่าอันไหนคือ 'discount' หรือ 'free_shipping'
                "promotion_type" => (string)$row['promotion_type'] 
            ];
        }
    }
}

echo json_encode($vouchers, JSON_UNESCAPED_UNICODE);
$conn->close();
?>