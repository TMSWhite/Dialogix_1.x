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

<?php include("Dialogix_Table_PartA.php"); ?>

<table border=1 width=100% align=center>
<tr><td align="center"><FONT SIZE="5">Voice XML File for (<?php echo $InstrumentName; ?>)</FONT></td></tr>
<tr><td>
<?php
  $namelist='';
  $nonmatch = "<catch event='nomatch noinput help'>
      Sorry, I did not understand that.
      <reprompt/>
      </catch>
      ";
  echo ('
    <?xml version="1.0" encoding="UTF-8"?>
    <vxml version="2.0">
    <form>
    ');
  foreach($rows as $r){  
    extract($r);
    $namelist .= " $VarName";
    switch($DisplayType) {
      case 'check':
      case 'combo':
      case 'combo2':
      case 'list':
      case 'list2':
      case 'radio':
      case 'radio2':
      case 'radio3':
        echo ("<field name='$VarName'>
          <prompt>
            $ActionPhrase
            <enumerate/>
          </prompt>
        ");
        /* Do options here */
        $ansarray = explode("|", $AnswerOptions);
        $toggle = 0;
        $counter = 1;
        foreach ($ansarray as $ans) {
          if ($toggle == 0) {
            echo "<option dtmf='$counter' value='$ans'>";
            ++$counter;
            $toggle = 1;
          }
          else {
            echo "$ans</option>";
            $toggle = 0;
          }
        }
        echo ("$nonmatch</field>");
        break;
      case 'double':
        echo ("<field name='$VarName' type='number'>
          <prompt>
            $ActionPhrase
          </prompt>
          $nonmatch
          </field>
        ");
        break;
      case 'date':
      case 'day':
      case 'month':
      case 'year':
        echo ("<field name='$VarName' type='date'>
          <prompt>
            $ActionPhrase
          </prompt>
          $nonmatch
          </field>
        ");
        break;
      case 'time':
      case 'hour':
      case 'minute':
      case 'second':
        echo ("<field name='$VarName' type='time'>
          <prompt>
            $ActionPhrase
          </prompt>
          $nonmatch
          </field>
        ");
        break;     
      default:
      case 'nothing':
          echo ("
          <prompt>
            $ActionPhrase
          </prompt>
        ");
        break;
      case 'memo':
      case 'password':
      case 'text':
        echo ("<record name='$VarName' maxtime='60s' dtmfterm='true' beep='true'>
          <prompt>$ActionPhrase</prompt>
          $nonmatch
          </record>
        ");
        break;
    }
  }
  echo ("<filled>
    <submit enctype='multippart/form-data' next='http://dialogix.org/LogVoiceXMLResponse.php'
      namelist='$namelist' method='post'/>
    </filled>
    </form>
    </vxml>
    ");
?>
</table>

<?php include("Dialogix_Table_PartB.php"); ?>
