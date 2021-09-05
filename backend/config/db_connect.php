
<?php

//กำหนดให้ไฟล์ที่กำลังสร้างอยู่อนุญาติให้มาจากโดเมนไหนก็ได้ สามารถ Active จากโดเมน หรือ Device ก็ได้
header("Access-Control-Allow-Origin: *");
//ระบุรูปแบบการส่งข้อมูลให้ทำได้แค่ PUT GET POST DELETE
header("Access-Control-Allow-Methods: PUT, GET, POST, DELETE");
//รูปแบบ header ที่ยอมรับได้ - Origin จากโดเมนเดียวกัน, - X-Requested-with จากโดเมนอื่นๆ
header("Access-Control-Allow-Headers: Origin, X-Requested-With, Content-Type, Accept");

define('DB_HOST', '127.0.0.1');
define('DB_USER', 'root');
define('DB_PASS', '');
define('DB_NAME', 'db_robot_ccs');

function connect()
{
    $connect = mysqli_connect(DB_HOST, DB_USER, DB_PASS, DB_NAME);

    if (mysqli_connect_errno($connect)) {
        die("Failed to connect:" . mysqli_connect_error());
    }

    mysqli_set_charset($connect, "utf8");

    return $connect;
}

$conn = connect();

?>
