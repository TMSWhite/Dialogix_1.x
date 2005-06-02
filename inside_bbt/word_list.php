<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

if (isset($_GET['guideme'])) {
	$query = "select distinct type, subtype from words order by type, subtype";
	$res = mysql_query($query);
	if (!$res) {
	   echo "Could not successfully run query ($query) from DB: " . mysql_error();
	   exit;
	}
	$num_words = mysql_num_rows($res);
	if ($num_words == 0) {
	   echo "No rows found, nothing to print so exiting";
	   exit;
	}
	$types = array();
	
	while($r  = mysql_fetch_assoc($res)) {
		array_push($types, $r);
	}	
	
	include("Dialogix_Table_PartA.php");

	$php_self = $_SERVER['PHP_SELF'];
	echo "<Form Action='$php_self' METHOD=GET>";
	echo "<DIV ALIGN='center'>";
	echo "<H1>Word Lists</H1>";
	echo "<H2>Type</H2>";
	echo "<select name='type[]' multiple>";
	$lastval = '';
	foreach ($types as $t) {
		extract($t);
		if ($type != $lastval) {
			echo "	<option value='$type'>$type</option>";
		}
		$lastval = $type;
	}
	echo "</select>";
	
	echo "<H2>SubType</H2>";
	echo "<select name='subtype[]' multiple>";
	$lastval = '';
	foreach ($types as $t) {
		extract($t);
		if ($subtype != $lastval && $subtype != 'NULL') {
			echo "	<option value='$subtype'>$subtype</option>";
		}
		$lastval = $subtype;
	}
	echo "</select>";
	
	echo "<H2>Length</H2>";
	echo "<input type='text' name='length'>";
	
	echo "<BR>";
	echo "<Input Type='submit' Value='Submit'>";
	echo "</DIV>";
	echo "</FORM>";
	include("Dialogix_Table_PartB.php");
	
	exit;
}

if (!isset($_GET['length'])) {
	$length = 20;
}
else {
	$length = $_GET['length'];
	if ($length <= 0 || $length > 60) {
		$length = 20;
	}
}

if(isset($_GET['type'])) {
	$type = $_GET['type'];
	$where_clause1 .= "where type in (";
	for ($i=0;$i<count($type);++$i) {
		if ($i > 0) {
			$where_clause1 .= ",";
		}
		$where_clause1 .= "'$type[$i]'";
	}
	$where_clause1 .= ")";
}

if (isset($_GET['subtype'])) {
	$subtype = $_GET['subtype'];
	$where_clause2 .= "where subtype in (";
	for ($i=0;$i<count($subtype);++$i) {
		if ($i > 0) {
			$where_clause2 .= ",";
		}
		$where_clause2 .= "'$subtype[$i]'";
	}
	$where_clause2 .= ")";	
}

if (isset($where_clause1) and isset($where_clause2)) {
	$query = "select * from words $where_clause1 union select * from words $where_clause2";
}
else if (isset($where_clause1)) {
	$query = "select * from words $where_clause1";
}
else if (isset($where_clause2)) {
	$query = "select * from words $where_clause2";
}
else {
	$query = "select * from words";
}

$res = mysql_query($query);

if (!$res) {
   echo "Could not successfully run query ($query) from DB: " . mysql_error();
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
