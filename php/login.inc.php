<?php

//
// Code to require Mysql based authentication
//

require_once("conn_dialogix.php");

$authenticated=0;
$failed_authentication=0;
$Cookiename="psychinformatics_nyspi_org_Dialogix";
$statusMessage = '';

extract($_POST);

/* If just posted a username password, then that is enough to authenticate */
if (isset($UserID) && isset($Password)) {

  $query = "select * from AuthenticatedUsers where UserID = '$UserID' and Password = '$Password'";
//  echo "$query\n";

  if ( !($dbq = mysql_query($query))) {
  	DialogixError("Unable to query database of authenticated users" . mysql_error());
  }
  $statusMessage .= "($query) succeeded<br>";

  $lim = mysql_num_rows( $dbq );
  
  $statusMessage .= "Lim = $lim<br>";

  if ($lim != 1) {
	$failed_authentication=1;
	}

  if ($lim == 1) {
	//make unique session id and store it in Database
	  $timer = md5(time());
	  $sid = $UserID . "+" . $timer;
	  SetCookie($Cookiename,$sid); //Set Cookie to expire at end of session
	  $query = "update AuthenticatedUsers set sid='$timer' where UserID='$UserID'";
//	  echo "$query\n";
	
	  if( !($dbq = mysql_query( $query))) {
	  	DialogixError("Unable to update database" . mysql_error());
	  }
	  $statusMessage .= "($query) succeeded, and Authenticated!<br>";
	  $authenticated = 1;
  }
}
else if (isset($_COOKIE["$Cookiename"])) {
  $sidarray = explode("+", $_COOKIE["$Cookiename"]);
  $query = "select * from AuthenticatedUsers where UserID = '$sidarray[0]' and sid = '$sidarray[1]'";
//  echo "$query\n";

  if ( !($dbq = mysql_query($query))) {
  	DialogixError("Unable to find database for authenticated users" . mysql_error());
  }
  $statusMessage .= "($query) succeeded<br>";

  if (mysql_num_rows( $dbq ) == 1) {
  	$authenticated = 1;
    $statusMessage .= "Successfully Authenticated!<br>";

  }
}
else {
	$statusMessage .= "Could not find cookie<BR>";
}

if ($authenticated == 0) {
//	echo "<HTML><HEAD><TITLE>Login Page</TITLE></HEAD><BODY>";
	include("Dialogix_Table_PartA.php");

//	echo "$statusMessage\n";
	$php_self = $_SERVER['PHP_SELF'];
	echo "<Form Action='$php_self' METHOD=POST>";
	echo "<DIV ALIGN='center'>";
	echo "<H1>Dialogix Management Interface</H1>";
	if ($failed_authentication == 1) {
		echo "<H3>Invalid User ID or Password. Please Try again</H3><BR>";
	}
	echo "<H2>User Name</H2>";
	echo "<Input TYPE='text' Name='UserID' Value='$UserID'>";
	echo "<BR>";
	echo "<H2>Password</H2>";
	echo "<Input TYPE='password' Name='Password'>";
	echo "<BR>";
	echo "<Input Type='submit' Value='Submit'>";
	echo "</DIV>";
	echo "</FORM>";
	/*
	print_r($_COOKIE);
	print_r($HTTP_COOKIE_VARS);
	*/
	include("Dialogix_Table_PartB.php");
	
//	echo "</BODY></HTML>";
	exit;
}
?>