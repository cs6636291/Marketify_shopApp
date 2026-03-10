<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$conn = new mysqli("localhost", "root", "", "margetify_mobileapp");
mysqli_set_charset($conn, "utf8");

$user_id = $_GET['user_id'];
$status_filter = isset($_GET['status']) ? $_GET['status'] : 'all';

// ดึงข้อมูล Order + ข้อมูลการส่ง (Shipping)
$sql = "SELECT o.*, s.tracking_number, s.carrier_name, s.status as shipping_status 
        FROM orders o 
        LEFT JOIN shipping s ON o.id = s.order_id 
        WHERE o.user_id = '$user_id'";

if ($status_filter != 'all') {
    $sql .= " AND o.status = '$status_filter'";
}

$sql .= " ORDER BY o.created_at DESC";

$result = $conn->query($sql);
$orders = [];

while($row = $result->fetch_assoc()) {
    $order_id = $row['id'];
    // ดึงรายการสินค้าในออเดอร์นั้นๆ จาก order_items
    $item_sql = "SELECT oi.*, p.name, p.image_url 
                 FROM order_items oi 
                 JOIN products p ON oi.product_id = p.id 
                 WHERE oi.order_id = '$order_id'";
    $item_result = $conn->query($item_sql);
    $items = [];
    while($item = $item_result->fetch_assoc()) {
        $items[] = $item;
    }
    $row['items'] = $items;
    $orders[] = $row;
}

echo json_encode($orders);
$conn->close();
?>