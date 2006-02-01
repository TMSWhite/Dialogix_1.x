<?php


/**

	logcontent.php

	functions for logging strings and files to the content table

	in the database

	

*/


require_once("lib/dbaccess.php");

function writelog ($content) { 
	/** 

		this function takes the string $content and writes
		it to the content column of the content table

		it escapes the string first

	*/ 

	mysql_query(sprintf("insert into content(entry_time, content) values (now(), '%s')", mysql_escape_string($content)));


}
function writefile ($filename) { 
	/** 

		this function takes the file given by $filename 
		and writes its contents to the content column of the content table

		it escapes the contents first

	*/ 

	mysql_query(sprintf("insert into content(entry_time, content) values (now(), '%s')", mysql_escape_string(file_get_contents($filename))));


}
function writerequest(&$request) { 
	/** 

		this function takes a request or get given by $filename 
		and writes its contents to the content column of the content table

		it escapes the contents first

	*/ 
	$content = "";
	foreach(array_keys($request) as $p)
		$content .= sprintf("%s=%s&", $p, $request[$p]);
	mysql_query(sprintf("insert into content(entry_time, content) values (now(), '%s')", mysql_escape_string($content)));


}
?>
