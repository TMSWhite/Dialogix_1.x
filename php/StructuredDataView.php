<?php require_once("login.inc.php"); ?>

<?php

if(!isset($_GET['InstrumentName'])) {
	DialogixError("Must specify an Instrument Name");
}

$InstrumentName= $_GET['InstrumentName'];

$pattern = "/\W/i";
$replacement = "_";
$InstrumentName = preg_replace($pattern, $replacement, $InstrumentName);

require_once("conn_dialogix.php");

$info_query = "SHOW COLUMNS FROM $InstrumentName";
$info_res = mysql_query($info_query);
if (!$info_res) {
   DialogixError("Could not successfully run query ($info_query) from DB: " . mysql_error());
}
$num_cols = mysql_num_rows($info_res);


$query = "select * from $InstrumentName order by ID LIMIT 0,30";
$res = mysql_query($query);
if (!$res) {
   DialogixError("Could not successfully run query ($query) from DB: " . mysql_error());
}
$num_rows = mysql_num_rows($res);


if ($num_rows == 0) {
   DialogixError("No rows found");
}

$cols = array();
while($c = mysql_fetch_assoc($info_res)) {
	array_push($cols, $c);
}

$rows = array();
while($r  = mysql_fetch_assoc($res))
	array_push($rows, $r);

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td colspan="<?php echo $num_cols; ?>" align="center"><FONT SIZE="5">Up to 30 rows of data from (<?php echo "$InstrumentName" ?>)</FONT></td></tr>
<tr>
<?php
	foreach($cols as $c) {
		extract($c);
		echo "<td><b>$Field</b></td>";
	}
?>
<?php
	foreach($rows as $r)
	{
		echo "<tr>";
		$colCount = 0;
		foreach ($r as $c) {
			if (++$colCount == 3) {
				echo "<td><a href=\"ShowInstrumentData.php?Instance=$c\">$c</td>";
			}
			else {
				echo "<td>$c</td>";
			}
		}
		echo "</tr>";
	}
?>
</table>

<?php include("Dialogix_Table_PartB.php"); ?>
