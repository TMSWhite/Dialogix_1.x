<?php

/** 


	dbaccess.php	

	**
	  this file
          handles access to the database
	  and has a function, check_id
	  
	  that 
		checks
			a
				user's

		I          D



*/


/* kust0m|ze th3ez str7ngZz */


$host = "127.0.0.1";
$user = "kimdom";
$password = "lk1120";
$database = "vxml_dev";

$conn = mysql_pconnect($host, $user, $password);
mysql_select_db($database, $conn);



function check_id ($id) {

	global $conn;
	$query = "select count(*) as OK from users where user_id = $id";
	$res = mysql_query($query);
	while($res = mysql_fetch_assoc($res)){
		
		extract($res);
		if($OK > 0)
			return true;
		return false;
	}
	
}

?>
