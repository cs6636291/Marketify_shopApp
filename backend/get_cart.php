<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["error" => "Connection failed: " . $conn->connect_error]));
}

$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : null;

if (!$user_id) {
    echo json_encode(["error" => "No user_id provided"]);
    exit;
}

// SQL จะดึงเฉพาะของ User ที่ส่งมาเท่านั้น
$sql = "SELECT 
            MAX(c.id) as cart_id, 
            SUM(c.quantity) as quantity, 
            p.id as product_id, 
            p.name, 
            p.price, 
            p.image_url 
        FROM cart c
        JOIN products p ON c.product_id = p.id
        WHERE c.user_id = ? 
        GROUP BY p.id";

$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

$cart_items = array();
while($row = $result->fetch_assoc()) {
    $cart_items[] = $row;
}

echo json_encode($cart_items, JSON_UNESCAPED_UNICODE);

?>