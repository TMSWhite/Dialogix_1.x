<?php include("Dialogix_Table_PartA.php"); ?>

<div style="text-align: center;"><br>
<img src="images/dialogo.jpg" align="bottom" border="0" height="81" width="180"> <br>

<H1>Upload Excel instrument files to the Test site</H1>
<H2>Your Dialogix file will be added to the list <a href="http://www.dialogix.org:8888/OMH/servlet/Dialogix" target="_blank">here</a></H2>
<H2>The Dialogix instruction manual can be found <a href="http://www.dialogix.org/downloads/instructions.htm" target="_blank">here</a></H2>

<form enctype="multipart/form-data" action="Upload.php" method="post">
    <input type="hidden" name="MAX_FILE_SIZE" value="200000" />
    Choose a file to upload: <input name="userfile" type="file" />
    <input type="submit" value="Upload File" />
</form>

<?php
if (isset($_FILES['userfile']['size']) && $_FILES['userfile']['size'] > 0) {
  print "<hr><pre>";
  
  //  "Uploading " . $_FILES['userfile']['name'] . " to here: " . $_FILES['userfile']['tmp_name'] . "<br>";
  
  if (preg_match('/^(.*)\.xls$/', $_FILES['userfile']['name'], $matches) != 1) {
    print "Please upload an Excel file conforming to the Dialogix Structure";
  }
  else {
    $uploadDir = '/usr/local/tomcat554/webapps/OMH/WEB-INF/schedules/';
    $uploadFile = $uploadDir . $matches[1] . ".txt";  /* so that uploaded file is TSV equivalent of Excel file */
    
    // print "Uploading to file $uploadFile<br>";
    
    require_once 'Excel/reader.php';
    
    error_reporting(E_ALL ^ E_NOTICE);

    // ExcelFile($filename, $encoding);
    $data = new Spreadsheet_Excel_Reader();
    
    // Set output Encoding.
    $data->setOutputEncoding('CP1251');
    $data->setDefaultFormat('%s');    
    $data->setColumnFormat(3, '%s');
    
    $data->read($_FILES['userfile']['tmp_name']);
    
    $handle = fopen($uploadFile, "w"); /* replace file of same name */
    if (!$handle) {
      print "Unable to create file <i>$uploadFile</i>";
    }
    else {
      /* N.B. When reads in "true" or "false", converts to 1 and 0, even if set default format.
        So, if a reserved word, must convert back */
      
      for ($i = 1; $i <= $data->sheets[0]['numRows']; $i++) {
        $row = '';
      	for ($j = 1; $j <= $data->sheets[0]['numCols']; $j++) {
      	  if ($j > 1) {
      	    $row .= "\t";
      	  }
      	  if ($j == 3) {
      	    if ($data->sheets[0]['cells'][$i][1] == 'RESERVED') {
      	      if ($data->sheets[0]['cells'][$i][2] == '__TRICEPS_VERSION_MAJOR__' ||
      	          $data->sheets[0]['cells'][$i][2] == '__TRICEPS_VERSION_MINOR__') {
      	        $row .= $data->sheets[0]['cells'][$i][3];
      	      }
      	      else {
      	        if ($data->sheets[0]['cells'][$i][3] == '1') {
      	          $row .= 'true';
      	        }
      	        else if ( $data->sheets[0]['cells'][$i][3] == '0') {
      	          $row .= 'false';
      	        }
      	        else {
      	          $row .= $data->sheets[0]['cells'][$i][3];
      	        }
      	      }
      	    }
      	    else {
      	      $row .= $data->sheets[0]['cells'][$i][3];
            }
      	  }
      	  else {
      	    $row .= $data->sheets[0]['cells'][$i][$j];
      	  }
      	}
      	$row .= "\n";
      	if (fwrite($handle,$row) === FALSE) {
      	  print "Unable to write row $i <i>$row</i> to file\n";
      	  break;
      	}
      }
      if (fclose($handle) === FALSE) {
        print "Error closing file <i>$uploadFile</i>";
      }
      else {
        print $_FILES['userfile']['name'] . " was successfully uploaded<br>";
        print "You can access it <a href=\"http://www.dialogix.org:8888/OMH/servlet/Dialogix\" target=\"_blank\">here</a>";  
      }    
      @chmod($uploadFile, 0644);
      @unlink($_FILES['userfile']['tmp_name']);  /* remove the temp file */
    }     
  }
  print "</pre>";
}

?>

<?php include("Dialogix_Table_PartB.php"); ?>


