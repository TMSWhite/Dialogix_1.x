<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

if(!isset($_GET['Instrument'])) {
	DialogixError("Must specify an instrument name");
}

$InstrumentName = $_GET['Instrument'];
$NumLanguages = $_GET['NumLanguages'];


$query = "select * from InstrumentTranslations where InstrumentName='$InstrumentName' order by VarNum,LanguageNum";
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
<tr><td colspan="5" align="center"><FONT SIZE="5">Translation File for (<?php echo $InstrumentName; ?>)<br>
	(<?php echo $NumLanguages; ?> languages; <?php echo "$num_instruments" ?> rows)</FONT></td></tr>
<tr>
	<td><b>VarName</b></td>
	<td><b>LanguageName</b></td>
	<td><b>ActionType</b></td>
	<td><b>ActionPhrase</b></td>
	<td><b>AnswerOptions</b></td>
</tr>

<?php
	foreach($instruments as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td>$VarName</td>
		<td>$LanguageName</td>
		<td>$ActionType</td>
		<td>$ActionPhrase</td>
		<td>";
		
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
		echo "</td></tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
