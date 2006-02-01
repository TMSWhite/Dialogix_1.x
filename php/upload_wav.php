<?php

global $strDesc;
global $fileUpload;
global $fileUpload_name;
global $fileUpload_size;
global $fileUpload_type;

echo "<?xml version=\"1.0\"?>";

foreach ($_FILES as $file ) {
move_uploaded_file($file['tmp_name'], "/tmp/$file[name].wav");
}

$file = "myrecording.wav";
$speed = 9.0;

if(file_exists($file) && is_file($file)) 
	{
	$fd = fopen($file, "r");
	while(!feof($fd)) {
   	echo fread($fd, round($speed* 1024));
   	flush();
	}
	fclose($fd);
}

$dbServer = "localhost";
$dbDatabase = "vxml_dev";
$dbUser = "kimdom";
$dbPass = "lk1120";

//$fileHandle = fopen($fileUpload, "r");
//$fileContent = fread($fileHandle, $fileUpload_size($fileUpload));

$sConn = mysql_connect($dbServer, $dbUser, $dbPass)
or die("Couldn't connect to database server");

$dConn = mysql_select_db($dbDatabase, $sConn)
or die("Couldn't connect to database $dbDatabase");

$dbQuery = "INSERT INTO myBlobs VALUES ";
$dbQuery .= "(0, '$strDesc', '$fileContent', '$fileUpload_type')";

mysql_query($dbQuery) or die("Couldn't add file to database");

//if(file_exists($file)) {
//   rename("/tmp/$file[name].wav", "/home/kimdom/my_wavfile.wav");

$query = "select blobID, blobTitle, blobData, blobType from sessions";
$res = mysql_query($query);

$sessions = array();

while($r  = mysql_fetch_assoc($res))
        array_push($sessions, $r);

	
	echo "<h1>File Uploaded</h1>";
	echo "The details of the uploaded file are shown below:<br><br>";
	echo "<b>File name:</b> $fileUpload_name <br>";
	echo "<b>File type:</b> $fileUpload_type <br>";
	echo "<b>File size:</b> $fileUpload_size <br>";
	echo "<b>Uploaded to:</b> $fileUpload <br><br>";

?>

<vxml version="2.0">
 <form id="record_audio">
 </form>
</vxml>
