<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

if(!isset($_GET['Instrument'])) {
	DialogixError("Must specify an instrument name");
}

$InstrumentName = $_GET['Instrument'];


$query = "
SELECT InstrumentContents.*, InstrumentTranslations.ActionPhrase, InstrumentTranslations.DisplayType, InstrumentTranslations.AnswerOptions
FROM InstrumentContents INNER JOIN InstrumentTranslations
ON InstrumentContents.InstrumentName = InstrumentTranslations.InstrumentName and InstrumentContents.VarNum = InstrumentTranslations.VarNum
WHERE InstrumentContents.InstrumentName =  \"$InstrumentName\" AND InstrumentTranslations.LanguageNum =0
ORDER BY InstrumentContents.VarNum
";

$res = mysql_query($query);

if (!$res) {
   DialogixError("Could not successfully run query ($query) from DB: " . mysql_error());
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
<tr><td colspan="11" align="left"><FONT SIZE="5">LOINC File for (<?php echo $InstrumentName; ?>)<br>
	(<?php echo "$num_rows" ?> rows)</FONT></td></tr>
<tr>
	<td width='2%'><b>#</b></td>
	<td width='3%'><b>LOINC NUM</b></td>
	<td width='5%'><b>Component</b></td>
	<td width='5%'><b>Property</b></td>
	<td width='5%'><b>Time Aspect</b></td>
	<td width='5%'><b>System</b></td>
	<td width='5%'><b>Scale</b></td>
	<td width='5%'><b>Method</b></td>
	<td width='10%'><b>Survey Question Source</b></td>
	<td width='30%'><b>Survey Question Text</b></td>
	<td width='25%'><b>Answer List</b></td>
</tr>

<?php
	foreach($rows as $s)
	{
		extract($s);
		echo "<tr><td>$VarNum</td><td>";
		if ($LOINC_NUM == '') {
			echo "&nbsp;";
		}
		else {
			echo "$LOINC_NUM";
		}
		echo "</td><td>";
		
		if ($Concept == '') {
			echo "&nbsp;";
		}
		else {
			echo "$Concept";
		}
		
		echo "</td><td>$LOINCproperty</td><td>$LOINCtimeAspect</td><td>$LOINCsystem</td><td>$LOINCscale</td><td>$LOINCmethod</td><td>";
		
		if ($DisplayName == '') {
			echo "&nbsp;";
		}
		else {
			echo "$DisplayName";
		}
		echo "</td><td>";
		
		if ($ActionType == 'e') {
			echo "<font color='blue'>$ActionPhrase</font>";
		}
		else {
			echo "$ActionPhrase";
		}
		
		echo "</td><td><font color='blue'>";
		if ($ActionType == 'e') {
			echo "equation";
		}
		else if ($DisplayType == 'double') {
			echo "number";
		}
		else if ($DisplayType == 'nothing') {
			echo "message";
		}
		else {
			echo "$DisplayType";
		}
		echo "</font>";
		if ($AnswerOptions != '') {
			echo "<br>";
			$ansarray = explode("|", $AnswerOptions);
			$toggle = 0;
			foreach ($ansarray as $ans) {
				if ($toggle == 0) {
					echo "[$ans] ";
					$toggle = 1;
				}
				else {
					echo "$ans<br>";
					$toggle = 0;
				}
			}
		}
		echo "</td></tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
