<?php require_once("login.inc.php"); ?>
<?php include("Dialogix_Table_PartA.php"); ?>

<div style="text-align: center;"><br>
<img src="images/dialogo.jpg" align="bottom" border="0" height="81" width="180"> <br>

<H1>Upload Unicode Text Excel instrument files to the Test site</H1>
<H2>Your Dialogix file will be added to the list <a href="http://www.dialogix.org:8080/OMH-Test/servlet/Dialogix" target="_blank">here</a></H2>
<H2>The Dialogix instruction manual can be found <a href="http://www.dialogix.org/downloads/instructions.htm" target="_blank">here</a></H2>

<form enctype="multipart/form-data" action="UploadUnicode.php" method="post">
    <input type="hidden" name="MAX_FILE_SIZE" value="200000" />
    Choose a file to upload: <input name="userfile" type="file" />
    <input type="submit" value="Upload File" />
</form>

<?php
if (isset($_FILES['userfile']['size']) && $_FILES['userfile']['size'] > 0) {
  print "<hr><pre>";
  
  //  "Uploading " . $_FILES['userfile']['name'] . " to here: " . $_FILES['userfile']['tmp_name'] . "<br>";
  
  if (preg_match('/^(.*)\.txt$/', $_FILES['userfile']['name'], $matches) != 1) {
    print "Please upload a unicode text file conforming to the Dialogix Structure";
  }
  else {
    //$uploadDir = '/usr/local/dialogix7777/webapps/Demos/WEB-INF/schedules/';
    $uploadDir ='/home/istcgxl/';
    $instrument = $matches[1] . ".txt";
    $uploadFile = $uploadDir . $instrument;   
      

if(move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadFile)) {
    echo "The file ".( $_FILES['userfile']['name']). " has been uploaded";
    print "You can start it directly by clicking " .
          "<a href=\"http://www.dialogix.org:8080/OMH-Test/servlet/Dialogix?DIRECTIVE=START&schedule=WEB-INF/schedules/" .
          $instrument .
          "\" target=\"_blank\">here</a>";  
    @chmod($uploadFile, 0644);
    @unlink($_FILES['userfile']['tmp_name']);  /* remove the temp file */

} else{
    echo "There was an error uploading the file, please try again!";
}
}
  print "</pre>";
}

?>

<?php include("Dialogix_Table_PartB.php"); ?>


