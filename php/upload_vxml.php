<?php

echo "<?xml version=\"1.0\"?>";

foreach ($_FILES as $file ) {
move_uploaded_file($file['tmp_name'], "/tmp/$file[name].wav");
}

?>

<vxml version="2.0">
 <form id="record_audio">
 </form>
</vxml>
