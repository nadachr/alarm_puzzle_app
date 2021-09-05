<?ob_start();?>

<?php

		
require_once '../config/db_connect.php';

$headers = apache_request_headers();

$ques = [];

$sql = "SELECT * FROM `tbl_question` WHERE `ques_status` = '1' ORDER BY RAND() LIMIT 5";
$result = mysqli_query($conn, $sql);

if($result->num_rows > 0){
  $i = 0;
  foreach($result as $row){
    $ques[$i]['question'] = $row['question'];
    $ques[$i]['answer'] = $row['answer'];
    $ques[$i]['pathImage'] = $row['img_path'];
    $i++;
  }
  echo json_encode($ques, JSON_UNESCAPED_UNICODE);
  http_response_code(200);
} else echo json_encode(array('msg'=>'null'), JSON_UNESCAPED_UNICODE);
