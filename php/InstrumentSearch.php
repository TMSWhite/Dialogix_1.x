<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

//$query = "select * from UniqueInstruments order by InstrumentName";
$query = "select Instances.*, InstrumentMeta.ID, InstrumentMeta.Title, InstrumentMeta.Version, count(*) as NumInstances 
	from Instances left join InstrumentMeta 
	on Instances.InstrumentName = InstrumentMeta.InstrumentName
	group by InstrumentName order by InstrumentName";

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
<tr><td colspan="9" align="center"><FONT SIZE="5">Instruments with Data (<?php echo "$num_instruments" ?>)</FONT></td></tr>
<tr>
	<td><b>#</b></td>
	<td><b>InstrumentName</b></td>	
	<td><b>Version</b></td>
	<td><b>Instances</b></td>
	<td><b>All Results</b></td>			
	<td><b>What Subject Saw</b></td>			
	<td><b>Changed Answers</b></td>		
	<td><b>Timing by Screen</b></td>	
	<td><b>Timing by Var</b></td>	
</tr>

<?php
	foreach($instruments as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td><a title='View LOINC file for this instrument'
			href=\"InstrumentLOINCFile.php?Instrument=$InstrumentName\">$ID</a></td>
		<td><a title='View logic file for this instrument'
			href=\"InstrumentLogicFile.php?Instrument=$InstrumentName\">$Title</a></td>
		<td>$Version</td>
		<td>$NumInstances</td>
		<td><a title='View final data from all instances of this instrument'
			href=\"StructuredDataView.php?Instrument=$InstrumentName\">Results</a></td>
		<td><a title='View what the subject saw for each instance' 
			href=\"InstanceSearch.php?Instrument=$InstrumentName\">Recap</a></td>
		<td><a title='View how answers were changed, by variable'
			href=\"ChangesByVar.php?Instrument=$InstrumentName\">Changes</a></td>
		<td><a title='View timing per screen'
			href=\"TimingByScreen.php?Instrument=$InstrumentName\">Per-Screen</a></td>
		<td><a title='View timing per variable'
			href=\"TimingByVar.php?Instrument=$InstrumentName\">Per-Var</a></td>		
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
