<?php

$msg = "";
$code = 1;
$tmpFile=$HTTP_POST_FILES['personal_greeting']['tmp_name'];
if (is_uploaded_file($tmpFile)) 
{
  $wavfile="wav/".date("YmdHis").".wav";
  copy($tmpFile, sprintf("%s",$wavfile));
  $msg = "audio saved";
} 
else 
{
  $code = 0;
  $msg = "unable to save audio";
}

echo "<vxml version='2.0'>";
echo "<form>";
echo "<var name=\"code\" expr=\".$code\"/>";
echo "<var name=\"msg\" expr=\"'.$msg'\"/>";
echo "<block>";
echo "<return namelist=\"code msg\"/>";
echo "</block></form></vxml>";

?>
