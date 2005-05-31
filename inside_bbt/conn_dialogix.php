<?php 

require_once("globals.inc.php");

$host = "localhost";
$user = "bbtutori";
$password = "280dfrd";
$db = "bbtutori_BrainBuilders";

$conn = mysql_pconnect($host, $user, $password) or die(mysql_error());
mysql_select_db($db, $conn) or die(mysql_error()); 

function DialogixError($message='') { 
	include("Dialogix_Table_PartA.php");
	echo "<DIV align='center'>$message</DIV>";
	include("Dialogix_Table_PartB.php");
	exit;
}

?>
