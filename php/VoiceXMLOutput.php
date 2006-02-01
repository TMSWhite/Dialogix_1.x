<?php require_once("login.inc.php"); ?>

<?php

require_once("conn_dialogix.php");

if(!isset($_GET['Instrument'])) {
	DialogixError("Must specify an instrument name");
}

$question = 0;

if(!isset($_GET['question'])) {
	$question = 1;
}
else {

	$question = $_GET['question'];
	
}

$InstrumentName = $_GET['Instrument'];


$query = "
SELECT InstrumentContents.*, InstrumentTranslations.ActionPhrase, InstrumentTranslations.DisplayType, InstrumentTranslations.AnswerOptions
FROM InstrumentContents INNER JOIN InstrumentTranslations
ON InstrumentContents.InstrumentName = InstrumentTranslations.InstrumentName and InstrumentContents.VarNum = InstrumentTranslations.VarNum
WHERE InstrumentContents.InstrumentName =  \"$InstrumentName\" AND InstrumentTranslations.LanguageNum =0
ORDER BY InstrumentContents.VarNum
";

$res = mysql_query($query);

if (!$res) {
   DialogixError("Could not successfully run query ($query) from DB: " . mysql_error());
}

$num_rows = mysql_num_rows($res);


if ($num_rows == 0) {
   DialogixError("No rows found");
}

$rows = array();

while($r  = mysql_fetch_assoc($res))
	array_push($rows, $r);

?>


<table border=1 width=100% align=center>
<tr><td align="center"><FONT SIZE="5">Voice XML File for (<?php echo $InstrumentName; ?>)</FONT></td></tr>

<?php
/* 

new changes here - make VoiceXML dynamic - add InstrumentTranslations.ActionPhrase as a prompt

*/

	echo nl2br(htmlspecialchars('
		<?xml version="1.0" encoding="UTF-8"?>
		<vxml xmlns="http://www.w3.org/2001/vxml" 
		  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
		  xsi:schemaLocation="http://www.w3.org/2001/vxml 
		   http://www.w3.org/TR/voicexml20/vxml.xsd"
		   version="2.0">

			'));


/*	foreach($rows as $r){	

	extract($r);
		echo nl2br(htmlspecialchars('<form>

		  <field name="survey_question">
		     <prompt>'));
		     
		     echo $ActionPhrase;
		     
		     echo nl2br(htmlspecialchars('</prompt>
		  </field>

		  <block>
		     <submit next="InstrumentAsVoiceXML_save.php?question='));
		     
		     echo $question;
		     $question++;
		     
		
		     
		     echo nl2br(htmlspecialchars('"/>
		  </block>


		 </form>


		'));
}
echo "</vxml>"; */
	?>

</table>
