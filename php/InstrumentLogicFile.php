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
<tr><td colspan="8" align="left"><FONT SIZE="5">Logic File for (<?php echo $InstrumentName; ?>)<br>
	(<?php echo "$num_instruments" ?> rows)</FONT></td></tr>
<tr>
	<td width='2%'><b>Group</b></td>
	<td width='2%'><b>#</b></td>
	<td width='6%'><b>Name<br><font color='blue'>Concept</font></b></td>
	<td width='30%'><b>Relevance<br><font color='blue'>Validation</font></b></td>
	<td width='30%'><b>Question<br><font color='blue'>Equation</font></b></td>
	<td width='30%'><b><font color='blue'>Display Style</font><br>Answer Options</b></td>
</tr>

<?php
	foreach($instruments as $s)
	{
		extract($s);
		echo "<tr><td>$GroupNum</td><td>$VarNum</td><td>$VarName";
			
		if ($Concept != '') {
			echo "<br><font color='blue'>$Concept</font>";
		}
		
		/* Split relevance in case it is too long */
		$rel_array = preg_split("/(\W+)/", $Relevance, -1, PREG_SPLIT_DELIM_CAPTURE | PREG_SPLIT_NO_EMPTY);
		$new_rel = implode(" ",$rel_array);
		
		echo "<td>$new_rel";
			
		if ($Validation == '') {
			echo "&nbsp;";
		}
		else {
			echo "<br><font color='blue'>";
			if ($MinVal != '' or $MaxVal != '') {
				echo "($MinVal - $MaxVal)";
			}
			if ($OtherVals != '') {
				$otherarray = explode(";",$OtherVals);
				echo "(";
				$count = 0;
				foreach ($otherarray as $other) {
					++$count;
					if ($count > 1) {
						echo ", ";
					}
					echo "$other";
				}
				echo ")";
			}
			if ($ReturnType != '') {
				echo " => $ReturnType";
			}
			echo "</font>";
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
