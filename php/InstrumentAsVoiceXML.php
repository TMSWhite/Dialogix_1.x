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
<tr><td align="center"><FONT SIZE="5">Voice XML File for (<?php echo $InstrumentName; ?>)</FONT></td></tr>
<tr><td>
	<?php echo nl2br(htmlspecialchars('
		<?xml version="1.0" encoding="UTF-8"?>
		<vxml xmlns="http://www.w3.org/2001/vxml" 
		  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		  xsi:schemaLocation="http://www.w3.org/2001/vxml 
		   http://www.w3.org/TR/voicexml20/vxml.xsd"
		   version="2.0">
		  <form>
		  <field name="drink">
		     <prompt>Would you like coffee, tea, milk, or nothing?</prompt>
		     <grammar src="drink.grxml" type="application/srgs+xml"/>
		  </field>
		  <block>
		     <submit next="http://www.drink.example.com/drink2.asp"/>
		  </block>
		 </form>
		</vxml>
		'));
	?>
</td></tr>

<?php
/*
	foreach($rows as $s)
	{
		extract($s);
		echo "<tr><td>$GroupNum</td><td>$VarNum</td><td>$VarName";
			
		if ($Concept != '') {
			echo "<br><font color='blue'>$Concept</font>";
		}
		
		// Split relevance in case it is too long
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
		echo "</td></tr>\n";
	}
*/
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
