<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

$query = "select * from InstrumentMeta order by InstrumentName";
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

<table border=1 width=100% align='left'>
<tr><td colspan="10" align="center"><FONT SIZE="5">Instruments (<?php echo "$num_instruments" ?>)</FONT></td></tr>
<tr>
	<td><b>ID</b></td>
	<td><b>Title</b></td>
	<td><b>Version</b></td>
	<td><b>Vars</b></td>
	<td><b>Languages</b></td>
	<td><b>Questions</b></td>
	<td><b>Equations</b></td>
	<td><b>Branches</b></td>
	<td><b>Tailorings</b></td>
</tr>

<?php
	foreach($instruments as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td>$ID</td>
		<td><a title='View logic file for this instrument'
			href=\"InstrumentLogicFile.php?Instrument=$InstrumentName\">$Title</td>
		<td>$Version</td>
		<td>$NumVars</td>
		<td><a title='View Translation File' href=\"InstrumentTranslationFile.php?Instrument=$InstrumentName&NumLanguages=$NumLanguages\">$LanguageList</a></td>
		<td>$NumQuestions</td>
		<td>$NumEquations</td>
		<td>$NumBranches</td>
		<td>$NumTailorings</td>	
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
