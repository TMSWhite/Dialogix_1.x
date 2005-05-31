<?php require_once("login.inc.php"); ?>

<?php

/* Should give option to select multiple word types */

require_once("conn_dialogix.php");

if (!isset($_GET['length'])) {
	$length = 20;
}
else {
	$length = $_GET['length'];
	if ($length <= 0 || $length > 60) {
		$length = 20;
	}
}

$where_clause = "where 1";

if(isset($_GET['type'])) {
	$type = $_GET['type'];
	$where_clause .= " and type = '$type'";
}

if (isset($_GET['subtype'])) {
	$subtype = $_GET['subtype'];
	$where_clause .= " and subtype = '$subtype'";
}

$query = "select * from words $where_clause";

$res = mysql_query($query);

if (!$res) {
   echo "Could not successfully run query ($sql) from DB: " . mysql_error();
   exit;
}

$num_words = mysql_num_rows($res);


if ($num_words == 0) {
   echo "No rows found, nothing to print so exiting";
   exit;
}

$words = array();

while($r  = mysql_fetch_assoc($res)) {
	array_push($words, $r);
}
	
// Randomly select a subset of these 
srand((float) microtime() * 10000000);
$rand_keys = array_rand($words, $length);

$newwords = array();

for ($i=0;$i<$length;++$i) {
	array_push($newwords,$words[$rand_keys[$i]]);
}

shuffle($newwords);

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td colspan="2" align="center"><FONT SIZE="5">MVL Word List <?php if (isset($_GET['type'])) echo "(${type}s)"; ?></FONT></td></tr>
<tr>
	<td><b>#</b></td>
	<td><b>Word</b></td>
</tr>

<?php
	$count = 0;
	foreach($newwords as $s)
	{
		extract($s);
		++$count;
		echo "<tr>\t
		<td>$count</td>
		<td>$word</td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
