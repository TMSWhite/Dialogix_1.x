<?php

//
// Code to require Mysql based authentication
//

require_once("conn_dialogix.php");

$failed_authentication=0;
$session_timedout=0;
$statusMessage = '';
// If hitting the login page, reset the username and authentication variables
$_COOKIE['dgx_authenticated'] = 0;
$_COOKIE['dgx_username'] = '';

extract($_POST);

/* If just posted a username password, then that is enough to authenticate */
if (isset($UserID) && isset($Password)) {

  $query = "select * from AuthenticatedUsers where UserID = '$UserID' and Password = password('$Password')";
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
	else if ($lim == 1) {
	//make unique session id and store it in Database
	  $time = time();
	  $timer = md5($time);
	  $sid = $UserID . "+" . $timer;
	  SetCookie("$Cookiename",$sid); //Set Cookie to expire at end of session
	  $query = "update AuthenticatedUsers set sid='$timer', LastAccess=$time where UserID='$UserID'";
//	  echo "$query\n";
	
	  if( !($dbq = mysql_query( $query))) {
	  	DialogixError("Unable to update database" . mysql_error());
	  }
	  $statusMessage .= "($query) succeeded, and Authenticated!<br>";
	  $_COOKIE['dgx_authenticated']=1;
	  $_COOKIE['dgx_username']=$UserID;
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
  	$r  = mysql_fetch_assoc($dbq);
  	extract($r);
  	
  	$time = time();
  	if ($time - $LastAccess > 600) {
  		$session_timedout = 1;
  		$statusMessage .= "Session Timedout!<br>";
  	}
  	else {
	  	$_COOKIE['dgx_authenticated']=1;
		$_COOKIE['dgx_username']=$sidarray[0];
	    $statusMessage .= "Successfully Authenticated!<br>";
	    
		  $query = "update AuthenticatedUsers set LastAccess=$time where UserID='$sidarray[0]'";
		  if ( !($dbq = mysql_query($query))) {
		  	DialogixError("Unable to update database" . mysql_error());
		  }	    
	}
  }
}
else {
	$statusMessage .= "Could not find cookie<BR>";
}

if (!($_COOKIE['dgx_authenticated'] == 1)) {
	include("Dialogix_Table_PartA.php");

//	echo "$statusMessage\n";
	$php_self = $_SERVER['PHP_SELF'];
	echo "<Form Action='$php_self' METHOD=POST>";
	echo "<DIV ALIGN='center'>";
	echo "<H1>Dialogix Management Interface</H1>";
	if ($session_timedout == 1) {
		echo "<H3>You session timed out due to inactivity.  Please login again</H3><BR>";
	}
	else if ($failed_authentication == 1) {
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
	include("Dialogix_Table_PartB.php");
	
	exit;
}
?>