<?php require_once("globals.inc.php"); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">
<title>Brain Builders Home</title>
</head>
<body>
<table style="height: 100%; text-align: left; width: 100%;" border="0" cellpadding="2" cellspacing="2">
<tr>
<td style="width: 100px; vertical-align: top;">
<br>
<br>
 <a href="http://www.bbtutoring.com/">Home</a></br>
<br>
 <hr>
<?php if ($_COOKIE['dgx_authenticated'] == 1)  { ?>
Welcome, <i><?php echo $_COOKIE['dgx_username']; ?></i>
<hr>
Word Lists:<br>
 <a href="word_list.php?guideme">Custom List</a><br>
 <a href="word_list.php?type[]=noun">Nouns</a><br>
 <a href="word_list.php?type[]=verb">Verbs</a><br>
 <a href="word_list.php?type[]=adjective">Adjectives</a><br>
 <a href="word_list.php">Mixed</a><br>
 <a href="word_list.php?subtype[]=animal">Animals</a><br>
 <a href="word_list.php?subtype[]=bodypart">Body Parts</a><br>
 <a href="word_list.php?subtype[]=state">States</a><br>
 <a href="word_list.php?subtype[]=capital">Capitals</a><br>
 <a href="word_list.php?subtype[]=food">Food</a><br>
<br>
<hr>
 <a href="https://host118.ipowerweb.com:8087/phpMyAdmin/index.php?lang=en-iso-8859-1&server=1" target="_blank">Databases</a><br>
 <br>
 <br>
 <a href="Logout.php">Logout</a><br>
<?php } else { ?>
 <a href="Login.php">Login</a><br>
<?php } ?>
</td>
<td style="vertical-align: top;">