<?php

require_once("conn_dialogix.php");

$query = "select * from publications order by Year DESC, Topic, Journal";
$res = mysql_query($query);

if (!$res) {
   echo "Could not successfully run query ($sql) from DB: " . mysql_error();
   exit;
}

$num_pubs = mysql_num_rows($res);


if ($num_pubs == 0) {
   echo "No rows found, nothing to print so am exiting";
   exit;
}

$pubs = array();

while($r  = mysql_fetch_assoc($res))
	array_push($pubs, $r);

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td colspan="6" align="center"><FONT SIZE="5">Selected Publications (<?php echo "$num_pubs" ?>)</FONT></td></tr>
<tr>
	<td><b>Year</b></td>
	<td><b>Topic</b></td>
	<td><b>Authors</b></td>
	<td><b>Title</b></td>
	<td><b>Journal</b></td>
	<td><b>PubMed Reference</b></td>
</tr>

<?php
	foreach($pubs as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td>$Year</td>
		<td>$Topic</td>
		<td>$Authors</td>
		<td>$Title</td>
		<td>$Journal</td>
		<td><a href=\"$PubMed\" target=\"_blank\">$JournalRef</a></td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
