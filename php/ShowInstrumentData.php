<?php require_once("login.inc.php"); ?>

<?php

// extract($_GET);

if(!isset($_GET['Instance'])) {
	DialogixError("Must specify an Instance Name");
}

$InstanceName = $_GET['Instance'];
$InstrumentName= $_GET['Instrument'];
$StartTime = $_GET['StartTime'];

require_once("conn_dialogix.php");

$query = "select RawDataID, DisplayNum, GroupNum, VarNum, VarName, QuestionAsAsked, Answer from RawData where InstanceName = '$InstanceName' and AnswerType = 0 order by RawDataID";

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
<tr><td colspan="6" align="center"><FONT SIZE="5"><?php echo "$InstrumentName" ?><br\><?php echo "$InstanceName" ?></br><?php echo "$StartDate" ?> (<?php echo "$num_rows" ?> rows)</FONT></td></tr>
<tr>
	<td><b>Page</b></td>
	<td><b>Group</b></td>
	<td><b>VarNum</b></td>
	<td><b>VarName</b></td>
	<td><b>QuestionAsAsked</b></td>
	<td><b>Answer</b></td>
	
</tr>

<?php
	foreach($rows as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td>$DisplayNum</td>
		<td>$GroupNum</td>
		<td>$VarNum</td>
		<td>$VarName</td>
		<td>$QuestionAsAsked</td>
		<td>$Answer</td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
