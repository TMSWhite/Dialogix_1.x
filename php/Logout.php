<?php require_once("globals.inc.php"); ?>
<?php
	SetCookie("$Cookiename","",time()-3600);
	$_COOKIE['dgx_username']='';
	$_COOKIE['dgx_authenticated']=0;
?>

<?php include("index.php"); ?>
