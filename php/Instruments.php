<?php

require_once("conn_dialogix.php");

$query = "select * from instruments order by Title, Version";
$res = mysql_query($query);

if (!$res) {
   echo "Could not successfully run query ($sql) from DB: " . mysql_error();
   exit;
}

$num_instruments = mysql_num_rows($res);


if ($num_instruments == 0) {
   echo "No rows found, nothing to print so am exiting";
   exit;
}

$instruments = array();

while($r  = mysql_fetch_assoc($res))
	array_push($instruments, $r);

?>

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td colspan="8" align="center"><FONT SIZE="5">Selected Instruments (<?php echo "$num_instruments" ?>)</FONT></td></tr>
<tr>
	<td><b>Title</b></td>
	<td><b>Version</b></td>
	<td><b>Project</b></td>
	<td><b># Languages</b></td>
	<td><b>Date Implemented</b></td>
	<td><b>Questions<br>(min - max)</b></td>
	<td><b>Equations<b></td>
	<td><b>Logic<br>File</b></td>
</tr>

<?php
	foreach($instruments as $s)
	{
		
		extract($s);
		
		echo "<tr>\t
		<td><a href=\"$LaunchCommand\" target=\"_blank\">$Title</a></td>
		<td>$Version</td>
		<td>$Project</td>
		<td>$NumLanguages</td>
		<td>$DateImplemented</td>
		<td>($NumAlwaysQs - $NumQs)</td>
		<td>$NumEs</td>
		<td><a href=\"http://psychinformatics.nyspi.org:8080/$Project/$Base.htm\" target=\"_blank\">
			<img src=\"http://psychinformatics.nyspi.org:8080/images/info_i.jpg\"></a></td>
		</tr>\n";
	}
?>

</table>

<?php include("Dialogix_Table_PartB.php"); ?>
