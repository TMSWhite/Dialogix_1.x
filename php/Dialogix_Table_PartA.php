<?php require_once("globals.inc.php"); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>Dialogix Home</title>
</head>
<body>
<table style="height: 100%; text-align: left; width: 100%;" border="0" cellpadding="2" cellspacing="2">
<tr>
<td style="width: 100px; vertical-align: top;">
 <a href="index.php">
<img src="images/dialogoSmall.jpg" align="bottom" border="0" height="40" width="89">
</a>
<br>
<br>
 <a href="Collaborations.php">Collaborations</a><br>
 <a href="Instruments.php">Instruments</a><br>
 <a href="Publications.php">Publications</a><br>
 <a href="Contact.php">Contact</a><br>
<br>
<hr>
<?php if ($_COOKIE['dgx_authenticated'] == 1)  { ?>
Welcome, <i><?php echo $_COOKIE['dgx_username']; ?></i>
<hr>
Review:</br>
 <a href="UserManual.php">User Manual</a><br>
 <a href="InstrumentSearch.php">Results</a><br>
 <a href="InstrumentDetails.php">Instruments</a><br>
 <a href="LOINC.php">LOINC</a><br>
 <a href="WorkPlan.php">Work Plan</a><br>
 <a href="http://psychinformatics.nyspi.org/phpmyadmin/">phpMyAdmin</a><br>
 <br>
 <a href="Logout.php">Logout</a><br>
<?php } else { ?>
 <a href="Login.php">Login</a><br>
<?php } ?>
</td>
<td style="vertical-align: top;">