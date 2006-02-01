<?php
include_once("lib/dbaccess.php");
include_once("lib/logcontent.php");

echo("<?xml version='1.0'?>\n");
echo("<vxml version='2.0'>\n");
?>
    <form>
        <block>
            <?php
            // Here we call check_id() function from dbaccess.php
            if(isset($_REQUEST["id"]) && check_id($_REQUEST["id"])) {
                echo("<prompt>Your user identification number is valid.\n");
                echo("Starting session");
		echo("You entered " . $_REQUEST["id"] . ".\n");
		echo("You entered " . $_REQUEST["city"] . ". </prompt>\n");
                //echo("<goto next='begin_session.vxml'/>\n");
            } else {
                echo("<prompt>Your user identification number is not valid.\n");
                echo("You entered " . $_REQUEST["id"] . ".\n");
		echo("You entered " . $_REQUEST["city"] . ". </prompt>\n");
		//echo("<goto next='getid.vxml'/>\n");
            }
            ?>
        </block>
    </form>
</vxml>



<?php

	// log the POST data to the database as a raw chunk

//	writelog(file_get_contents("php://stdin") . $_SERVER['QUERY_STRING']);
	writerequest($_REQUEST); // works for both GET and POST


?>
