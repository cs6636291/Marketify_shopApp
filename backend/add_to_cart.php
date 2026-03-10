<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization");
header("Content-Type: application/json; charset=UTF-8");

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "margetify_mobileapp";

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Connection failed: " . $conn->connect_error]));
}

// รับข้อมูลจาก Flutter
$user_id = isset($_POST['user_id']) ? $_POST['user_id'] : null;
$product_id = isset($_POST['product_id']) ? $_POST['product_id'] : null;
$quantity = isset($_POST['quantity']) ? $_POST['quantity'] : null;

if ($user_id && $product_id && $quantity) {
    
    // --- 1. ตรวจสอบก่อนว่า User คนนี้เคยใส่สินค้าชิ้นนี้ในตะกร้าหรือยัง ---
    $check_stmt = $conn->prepare("SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?");
    $check_stmt->bind_param("ii", $user_id, $product_id);
    $check_stmt->execute();
    $result = $check_stmt->get_result();

    if ($result->num_rows > 0) {
        // --- 2. ถ้ามีอยู่แล้ว: อัปเดตจำนวนเพิ่ม (บวกของใหม่เข้ากับของเก่า) ---
        $row = $result->fetch_assoc();
        $new_quantity = $row['quantity'] + $quantity;
        $cart_id = $row['id'];

        $update_stmt = $conn->prepare("UPDATE cart SET quantity = ?, added_at = NOW() WHERE id = ?");
        $update_stmt->bind_param("ii", $new_quantity, $cart_id);

        if ($update_stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "อัปเดตจำนวนสินค้าในรถเข็นแล้ว"]);
        } else {
            echo json_encode(["status" => "error", "message" => "อัปเดตไม่สำเร็จ: " . $update_stmt->error]);
        }
        $update_stmt->close();
    } else {
        // --- 3. ถ้ายังไม่มี: เพิ่มแถวใหม่ (INSERT) ---
        $insert_stmt = $conn->prepare("INSERT INTO cart (user_id, product_id, quantity, added_at) VALUES (?, ?, ?, NOW())");
        $insert_stmt->bind_param("iii", $user_id, $product_id, $quantity);

        if ($insert_stmt->execute()) {
            echo json_encode(["status" => "success", "message" => "เพิ่มลงรถเข็นสำเร็จ"]);
        } else {
            echo json_encode(["status" => "error", "message" => "เพิ่มไม่สำเร็จ: " . $insert_stmt->error]);
        }
        $insert_stmt->close();
    }
    
    $check_stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "ข้อมูลไม่ครบถ้วน"]);
}

$conn->close();
?>