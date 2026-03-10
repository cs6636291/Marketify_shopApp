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
    die(json_encode(["status" => "error", "message" => "Connection failed"]));
}

$json = file_get_contents('php://input');
$data = json_decode($json, true);

if (!$data) {
    die(json_encode(["status" => "error", "message" => "No data received"]));
}

$user_id = $conn->real_escape_string($data['user_id']);
$promotion_id = (isset($data['promotion_id']) && $data['promotion_id'] !== '') ? $conn->real_escape_string($data['promotion_id']) : null;
$total_price = $conn->real_escape_string($data['total_price']);
$discount_amount = $conn->real_escape_string($data['discount_amount']);
$net_amount = $conn->real_escape_string($data['net_amount']);
$items = $data['items']; 

$conn->begin_transaction(); 

try {
    // 1. บันทึกลงตาราง orders
    $promo_val = ($promotion_id) ? "'$promotion_id'" : "NULL";
    $sql_order = "INSERT INTO orders (user_id, promotion_id, total_price, discount_amount, net_amount, status) 
                  VALUES ('$user_id', $promo_val, '$total_price', '$discount_amount', '$net_amount', 'paid')";
    
    if (!$conn->query($sql_order)) throw new Exception("Orders Error: " . $conn->error);
    $order_id = $conn->insert_id;

    // 2. บันทึกรายการสินค้า และ ตัดสต็อก
    foreach ($items as $item) {
        $product_id = $conn->real_escape_string($item['product_id']);
        $quantity = (int)$item['quantity'];
        $price = $conn->real_escape_string($item['price']);
        
        // --- ส่วนที่เพิ่ม: เช็คสต็อกและลดสต็อก ---
        $sql_update_stock = "UPDATE products SET stock = stock - $quantity WHERE id = '$product_id' AND stock >= $quantity";
        $conn->query($sql_update_stock);

        if ($conn->affected_rows == 0) {
            // ถ้าไม่มีแถวไหนถูกอัปเดต แสดงว่าของไม่พอ
            throw new Exception("สินค้าบางรายการหมด หรือจำนวนคงเหลือไม่พอ");
        }

        // บันทึกลง order_items
        $sql_item = "INSERT INTO order_items (order_id, product_id, quantity, price_at_purchase) 
                     VALUES ('$order_id', '$product_id', '$quantity', '$price')";
        if (!$conn->query($sql_item)) throw new Exception("Order Items Error: " . $conn->error);
    }

    // 3. อัปเดตสถานะโค้ดส่วนลด
    if ($promotion_id) {
        $sql_voucher = "UPDATE user_vouchers SET is_used = 1 
                        WHERE user_id = '$user_id' AND promotion_id = '$promotion_id'";
        if (!$conn->query($sql_voucher)) throw new Exception("Voucher Update Error: " . $conn->error);
    }

    $conn->commit();
    echo json_encode(["status" => "success", "message" => "บันทึกคำสั่งซื้อเรียบร้อย"]);

} catch (Exception $e) {
    $conn->rollback();
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}

$conn->close();
?>