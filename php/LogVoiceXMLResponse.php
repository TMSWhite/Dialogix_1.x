<?php
include_once("lib/dbaccess.php");
include_once("lib/logcontent.php");

echo("<?xml version='1.0'?>\n");
echo("<vxml version='2.0'>\n");
?>
	<form>
		<block>
			<prompt>
				<paragraph>
					<sentence>The server received your submission.</sentence>
					<?php
						foreach($_REQUEST as $key => $val) {
							echo("<sentence>For $key, you entered $val .</sentence>");
						}
					?>
				</paragraph>
			</prompt>
		</block>
	</form>
</vxml>

<?php

	// log the POST data to the database as a raw chunk

	writerequest($_REQUEST); // works for both GET and POST

?>

