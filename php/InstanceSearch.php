<?php require_once("login.inc.php"); ?>

<?php

extract($_GET);

if(!isset($_GET['InstrumentName'])) {
	DialogixError("Must specify an instrument name");
}

$InstrumentName = $_GET['InstrumentName'];

require_once("conn_dialogix.php");

$query = "select * from Instances where InstrumentName = '$InstrumentName' order by StartDate DESC";

$res = mysql_query($query);

if (!$res) {
   DialogixError("Could not successfully run query ($sql) from DB: " . mysql_error());
}

$num_rows = mysql_num_rows($res);


if ($num_rows == 0) {
	DialogixError("No rows found");
}

$rows = array();

while($r  = mysql_fetch_assoc($res))
	array_push($rows, $r);

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td colspan="8" align="center"><FONT SIZE="5">Instances for <?php echo "$InstrumentName" ?> (<?php echo "$num_rows" ?> rows)</FONT></td></tr>
<tr>
	<td><b>StartDate</b></td>
	<td><b>Filename</b></td>
	<td><b>NumPagesViewed</b></td>
	<td><b>Duration hh:mm:ss</b></td>
</tr>

<?php
	foreach($rows as $s)
	{
		
		extract($s);
		
		$hours = floor($Duration / 3600);
		$minutes = floor(($Duration - $hours * 3600) / 60);
		$seconds = ($Duration - $hours * 3600 - $minutes * 60);
		
		echo "<tr>\t
		<td>$StartDate</td>
		<td><a href=\"http://psychinformatics.nyspi.org/Dialogix/ShowInstrumentData.php?Instance=$InstanceName&Instrument=$InstrumentName&StartDate=$StartDate\">$InstanceName</a></td>
		<td>$NumPagesViewed</td>
		<td>$hours:$minutes:$seconds</td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
