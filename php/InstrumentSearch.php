<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

//$query = "select * from UniqueInstruments order by InstrumentName";
$query = "select *, count(*) as NumInstances from Instances group by InstrumentName order by InstrumentName";

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
	<td><b>InstrumentName</b></td>
	<td><b>NumInstances</b></td>
</tr>

<?php
	foreach($instruments as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td><a title='View path taken through individual instances -- what the subject saw' 
			href=\"InstanceSearch.php?InstrumentName=$InstrumentName\">$InstrumentName</a></td>
		<td><a title='View final data from all instances of this instrument'
			href=\"StructuredDataView.php?InstrumentName=$InstrumentName\">$NumInstances</a></td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
