<?ob_start();?>
<?php

require_once '../config/db_connect.php';

$headers = apache_request_headers();

$postData = file_get_contents("php://input");

$request = json_decode($postData);

if (isset($postData) && !empty($postData)) {
  $time = mysqli_real_escape_string($conn, trim($request->time));

  // $email = mysqli_real_escape_string($conn, trim($request->account->email));
  // $pwd = mysqli_real_escape_string($conn, trim($request->account->pwd));

  $sql = "UPDATE `tbl_time` SET `time_set` = '$time' WHERE `time_id` = 1";
  $query = mysqli_query($conn, $sql);

  if ($query) {
    echo json_encode(array(
      'time_id' => 1,
      'time_set' => $time,
      'msg' => 'success'
    ), JSON_UNESCAPED_UNICODE);
    http_response_code(200);
  } else {
    echo json_encode(array('msg' => 'error'), JSON_UNESCAPED_UNICODE);
    http_response_code(501);
  }
}
