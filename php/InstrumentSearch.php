<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

$query = "select * from UniqueInstruments order by InstrumentName";
$res = mysql_query($query);

if (!$res) {
   DialogixError("Could not successfully run query ($sql) from DB: " . mysql_error());
}

$num_instruments = mysql_num_rows($res);


if ($num_instruments == 0) {
   DialogixError("No rows found");
}

$instruments = array();

while($r  = mysql_fetch_assoc($res))
	array_push($instruments, $r);

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td colspan="8" align="center"><FONT SIZE="5">Instruments with Data (<?php echo "$num_instruments" ?>)</FONT></td></tr>
<tr>
	<td><b>ID</b></td>
	<td><b>InstrumentName</b></td>
</tr>

<?php
	foreach($instruments as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td>$ID</td>
		<td><a href=\"http://psychinformatics.nyspi.org/Dialogix/InstanceSearch.php?InstrumentName=$InstrumentName\">$InstrumentName</a></td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
