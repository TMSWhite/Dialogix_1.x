<?php include("Dialogix_Table_PartA.php"); ?>

<div style="text-align: center;"><br>
<img src="images/dialogo.jpg" align="bottom" border="0" height="81" width="180"> <br>

<H1>Upload Files to the OMH Test Directory</H1>
<H2>The file will be available <a href="http://www.dialogix.org:8888/OMH/servlet/Dialogix">here</a></H2>

<form enctype="multipart/form-data" action="Upload.php" method="post">
    <input type="hidden" name="MAX_FILE_SIZE" value="200000" />
    Choose a file to upload: <input name="userfile" type="file" />
    <input type="submit" value="Upload File" />
</form>

<?php
if (isset($_FILES['userfile']['size']) && $_FILES['userfile']['size'] > 0) {
  $uploadDir = '/usr/local/tomcat554/webapps/OMH/WEB-INF/schedules/';
  $uploadFile = $uploadDir . $_FILES['userfile']['name'];
  print "<hr><pre>";
  if (move_uploaded_file($_FILES['userfile']['tmp_name'], $uploadFile))
  {
    chmod($uploadFile, 0644);
    print "File is valid, and was successfully uploaded. ";
    print "You can access it <a href=\"http://www.dialogix.org:8888/OMH/servlet/Dialogix\">here</a>";
  }
  else
  {
    print "File upload failed.  Here's some debugging info:\n";
    print_r($_FILES);
  }
  print "</pre>";
}
?>

<?php include("Dialogix_Table_PartB.php"); ?>


