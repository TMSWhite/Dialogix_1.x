<?php include("Dialogix_Table_PartA.php"); ?>

<div style="text-align: center;"><br>
<img src="images/dialogo.jpg" align="bottom" border="0" height="81" width="180"> <br>

<H1>Upload Data File to the Dialogix Site</H1>

<form enctype="multipart/form-data" action="Upload.php" method="post">
    <input type="hidden" name="MAX_FILE_SIZE" value="200000" />
    Choose a file to upload: <input name="userfile" type="file" />
    <input type="submit" value="Upload File" />
</form>

<?php
if (isset($_FILES['userfile']['size']) && $_FILES['userfile']['size'] > 0) {
  print "<hr><pre>";
  
  //  "Uploading " . $_FILES['userfile']['name'] . " to here: " . $_FILES['userfile']['tmp_name'] . "<br>";
  
  if (preg_match('/^(.*)\.jar$/', $_FILES['userfile']['name'], $matches) != 1) {
    print "Please upload a jar file conforming to the Dialogix Structure";
  }
  else {
    $uploadDir = '/usr/local/dialogix/webapps/Wave7/WEB-INF/archive/suspended/';
    $instrument = $matches[1] . ".jar";
    $uploadFile = $uploadDir . $instrument;  /* so that uploaded file is TSV equivalent of Excel file */  
      

if(move_uploaded_file($_FILES['uploadedfile']['tmp_name'], $uploadFile)) {
    echo "The file ".( $_FILES['uploadedfile']['name']). " has been uploaded";
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


