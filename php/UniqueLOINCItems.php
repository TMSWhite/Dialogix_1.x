<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

$query = "
	SELECT ID, InstrumentName, ActionPhrase, AnswerOptions, DisplayType
	FROM InstrumentTranslations
	where ActionType != \"e\" and (LanguageName = \"en\" or LanguageName = \"en_US\") and InstrumentTranslations.DisplayType != \"nothing\"
	order by ActionPhrase, AnswerOptions, DisplayType
	LIMIT 0,200";

$res = mysql_query($query);

if (!$res) {
   DialogixError("Could not successfully run query ($sql) from DB: " . mysql_error());
}

$num_rows = mysql_num_rows($res);


if ($num_rows == 0) {
   DialogixError("No rows found");
}

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align='left'>
<tr><td colspan="10" align="center"><FONT SIZE="5">rows (<?php echo "$num_rows" ?>)</FONT></td></tr>
<tr>
	<td><b>#</b></td>
	<td><b>Survey Question Text</b></td>
	<td><b>Answer List</b></td>	
	<td><b>Instrument</b></td>
</tr>

<?php
	while($s  = mysql_fetch_assoc($res))
	{
		extract($s);
		echo "<tr><td>$ID</td>";
		echo "<td>$ActionPhrase</td>";
		echo "<td><font color='blue'>";
		if ($DisplayType == 'double') {
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
		echo "</td>";
		echo "<td><a title=\"Show Logic File\" href=\"InstrumentLogicFile.php?Instrument=$InstrumentName\">$InstrumentName</a></td>";
		echo "</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
