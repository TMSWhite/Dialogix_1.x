<?php

/*
*   +------------------------------------------------------------------------------+
*       VoiceXML PHP class
*   +------------------------------------------------------------------------------+
*
*	 VoiceXML is a markup language that:
*		- Minimizes client/server interactions by specifying multiple interactions per document.
*		- Shields application authors from low-level, and platform-specific details.
*		- Separates user interaction code (in VoiceXML) from service logic (CGI scripts).
*		- Promotes service portability across implementation platforms. VoiceXML is
*		a common language for content providers, tool providers, and platform providers.
*		- Is easy to use for simple interactions, and yet provides language features
*		to support complex dialogs.
* 
* 		While VoiceXML strives to accommodate the requirements of a majority of voice
*		 response services, services with stringent requirements may best be served by
*	 	dedicated applications that employ a finer level of control.
* 
*   +------------------------------------------------------------------------------+ 
* 		Description
*  
* 		This class allow to generate easily VXML document on the fly based on
* 		the W3C Working Draft, 23 October 2001 (VoiceXML) Version 2.0.
*
*   +------------------------------------------------------------------------------+
*       Disclaimer Notice(s)
* 
* 		The use of any code included into this project is prohibed without a written
* 		authorisation from the author of this project itself.
* 
*       This copyright notice cannot be removed in any case, and should be included
* 		in every Dynamix project or demo code.
*
*   +------------------------------------------------------------------------------+
*       Updates
*   +------------------------------------------------------------------------------+
* 		22-09-2002 (v1.0.1): removed multiple echo, added function generate(), addscript()
* 					 and you can add a small welcome message using welcome() ;-)
* 		04-12-2002 (v1.0.2): Fixed lot of small bugs in vxml code generated.
* 		Details : element such <menu> was generated this way <menu .... /> while it could be closed with </menu>
* 		this makes xml error that is fixed now.
* 		TODO : adding some more functions
* 		vxml_start_menu() // Open menu (should be closed)
* 		end_vxml_menu() // Close menu
* 
* 		vxml_menu() // same as vxml_start_menu() but should not be closed <menu .../>
*   +------------------------------------------------------------------------------+
* 
*/

class voicexml{

	var $_document;
	var $_encoding = "UTF-8";


	function start_xml()
	{
 		Header("Content-Type: text/xml; charset=\"".$this->_encoding."\"");
		$result=("<?xml version=\"1.0\" encoding=\"".$this->_encoding."\"?>\n"); 
		$this->_document = $result;
		return true;
	}
	
	/*
	* 
	* Start a new VXML document
	* 
	* @param	version     : The version of VoiceXML of this document (required). The current version number is 2.0.
	* @param	base	    : The base URI. As in HTML, an absolute URI which all relative references within the document take as their base.
	* @param	application : The URI of this document�s application root document, if any.
	* @param    xml:lang	: The language and locale type for this document as defined in RFC 1766. If omitted, the value is a platform-specific default.
	* 
	*/
	
	function start_vxml_header($lang="",$application="",$base="")
	{

		$this->start_xml();
		
		$result.=("<vxml version=\"2.0\"");
		
		if ((isset($base)) and ($base!=="")){
			$result.=(" base=\"$base\"");
		}

		if ((isset($lang)) and ($lang!=="")){
			$result.=(" xml:lang=\"$lang\"");
		}
		
		if ((isset($application)) and ($application!=="")){
			$result.=(" application=\"$application\"");
		}
		
		$result.=(">\n  ");
		
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml document.
	*/
	
	function end_vxml()
	{
		$this->_document .= "</vxml>\n";
	}
	
	/*
	* 
	* Function to create a assign statement with no nested tags.
	* 
	*  @param name : The name of the variable being assigned to.
	*  @param expr : The new value of the variable
	* 
	*/
	
	function vxml_start_assign($name="",$expr="")
	{
		$result= ("<assign");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		} else {
			$result.=(" <!-- a VXML Error occured in Assign. Need to pass \"name\"=... -->");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		} else {
			$result.=(" <!-- a VXML Error occured in Assign. Need to pass \"expr\"=... -->");
		}
		
		$result.= (">\n  ");
		
		$this->_document .= $result;
		
		return true;
	}

	/*
	* Function to close a vxml assign tag.
	*/
	
	function end_vxml_assign()
	{
		$this->_document .= "</assign>\n";
		return true;
	}
	
	/*
	* 
	*  Function to create a audio statement with no nested tags.
	* 
	*   @param src                The URI of the audio prompt.
	*   @param fetchfimeout       The interval to wait for the content to be returned before throwing an error.badfetch event. If not specified, a value derived from the innermost fetchtimeout property is used
	*   @param fetchhint          Defines when the interpreter context should retrieve content from the server. prefetch indicates a file may be downloaded when the page is loaded, whereas safe indicates a file that should only be downloaded when actually needed. If not specified, a value derived from the innermost relevant *fetchhint property is used.
	*   @param maxage             Indicates that the document is willing to use content whose age is no greater than the specified time in seconds. The document is not willing to use stale content, unless maxstale is also provided. If not specified, a value derived from the innermost relevant *maxage property, if present, is used.
	*   @param maxstale           Indicates that the document is willing to use content that has exceeded its expiration time. If maxstale is assigned a value, then the document is willing to accept content that has exceeded its expiration time by no more than the specified number of seconds. If not specified, a value derived from the innermost relevant *maxstale property, if present, is used.
	*   @param expr               Dynamically determine the URI to fetch by evaluating this ECMAScript expression. If a 'src' attribute is specified, it takes precedence over the 'expr' attribute.
	* 
	*/
	
	function vxml_start_audio($src="",$fetchtimeout="",$fetchhint="",$maxage="",$maxstale="",$expr="")
	{
		$result= ("<audio");
		
		if ((isset($src)) and ($src!=="")){
			$result.=(" src=\"$src\"");
		}/**
 else {
			$result.=(" <!-- a VXML Error occured in Audio. Need to pass \"src\"=... -->");
		}
//*/
		
		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		$result.= (">\n  ");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml audio tag.
	*/
	
	function end_vxml_audio()
	{
		$this->_document .= "</audio>\n";
		return true;
	}
	
	/*
	* Function to create audio statement with no nested tags.
	*/
	
	function vxml_audio($audio="",$src="",$fetchtimeout="",$fetchhint="",$maxage="",$maxstale="",$expr="")
	{
		$this->vxml_start_audio($src,$fetchtimeout,$fetchhint,$maxage,$maxstale,$expr);
		$this->_document .= $audio;
		$this->end_vxml_audio();
		return true;
	}

	/*
	* 
	*  Function to create a Block statement with no nested tags.
	* 
	*   @param name               The field item variable in the dialog scope that will hold the result. The name must be a unique variable name within the scope of the form. If the name is not unique, then a badfetch error is thrown when the document is fetched
	*   @param expr       		  The initial value of the form item variable; default is ECMAScript undefined. If initialized to a value, then the form item will not be visited unless the form item variable is cleared.
	*   @param cond	              A boolean condition that must also evaluate to true in order for the form item to be visited
	*   @param type	              The type of field, i.e., the name of an internal grammar. This name must be from a standard set supported by all conformant platforms. If not present, <grammar> elements can be specified instead.
	*   @param slot               The name of the grammar slot used to populate the variable (if it is absent, it defaults to the variable name). This attribute is useful in the case where the grammar format being used has a mechanism for returning sets of slot/value pairs and the slot names differ from the field item variable names. If the grammar returns only one slot, as do the builtin type grammars like boolean, then no matter what the slot�s name, the field item variable gets the value of that slot.
	*   @param modal              If this is false (the default) all active grammars are turned on while collecting this field. If this is true, then only the field�s grammars are enabled: all others are temporarily disabled.
	* 
	*/
	
	function vxml_start_block($name="",$expr="",$cond="",$type="",$slot="",$modal="")
	{
		$result= ("<block");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}

		if ((isset($type)) and ($type!=="")){
			$result.=(" type=\"$type\"");
		}

		if ((isset($slot)) and ($slot!=="")){
			$result.=(" slot=\"$slot\"");
		}
		
		if ((isset($modal)) and ($modal!=="")){
			$result.=(" modal=\"$modal\"");
		}

		$result.= (">\n  ");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml Block tag.
	*/
	
	function end_vxml_block()
	{
		$this->_document .= "</block>\n";
		return true;
	}
	
	/*
	* 
	*  Function to create a Block statement with no nested tags.
	* 
	*   @param text		text to display inside the block
	*   @param name
	*   @param expr
	*   @param cond
	*   @param type
	*   @param slot
	*   @param modal
	* 
	*/
	
	function vxml_block($text="",$name="",$expr="",$cond="",$type="",$slot="",$modal="")
	{
		$this->vxml_start_block($name="",$expr="",$cond="",$type="",$slot="",$modal="");
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_block();
		return true;
	}
	
	/*
	* 
	* Function to create a BEAK statement
	* 
	*  @param time : The absolute pause duration in seconds or milliseconds, following the "time" value format from the W3C Cascading Style Sheets, level 2 CSS2 Specification. Examples of valid time values include "250ms", "2.5s", or "3s".
	*  @param size : A relative pause duration. Possible values are: none, small, medium or large. Actual pause duration depends upon variables such as speaking rate and platform defaults.
	* 
	*/
	
	function vxml_start_break($time="",$size="")
	{
		$result= ("<break");
		
		if ((isset($time)) and ($time!=="")){
			$result.=(" time=\"$time\"");
		}
		
		if ((isset($size)) and ($size!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* 
	* Function to create a CATCH statement
	* 
	*  @param event 	The event or events to catch. This may be an empty string indicating that all events are to be caught. Alternatively, a space-separated list of events may be specified, indicating that this <catch> element catches all the events named in the list. In such a case a separate event counter (see "count" attribute) is maintained for each event.
	*  @param count		The occurrence of the event (default is 1). The count allows you to handle different occurrences of the same event differently. Each <form>, <menu> and form item maintains a counter for each event that occurs while it is being visited; these counters are reset each time the <menu> or form item's <form> is re-entered. The form-level counters are used in the selection of an event handler for events thrown in a form-level <filled>.
	*  @param cond		An optional condition to test to see if the event may be caught by this element. Defaults to true.
	* 
	*/
	
	function vxml_start_catch($event="",$count="",$cond="")
	{
		$result= ("<catch");
		
		if ((isset($event)) and ($event!=="")){
			$result.=(" event=\"$event\"");
		} else {
			$result.=(" <!-- a VXML Error occured in CATCH. Need to pass \"event\"=... -->");
		}
		
		if ((isset($count)) and ($count!=="")){
			$result.=(" count=\"$count\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml CATCH tag.
	*/
	
	function end_vxml_catch()
	{
		$this->_document .= "</catch>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a CHOICE statement
	* 
	*  @param dtmf		The DTMF sequence for this choice
	*  @param accept	Override the setting for accept in <menu> for this particular choice. When set to "exact" (the default), the text of the choice element defines the exact phrase to be recognized. When set to "approximate", the text of the choice element defines an approximate recognition phrase (as described under grammar generation).
	*  @param next		The URI of next dialog or document
	*  @param event		Specify an event to be thrown instead of specifying a next. The 'next' and 'expr' attributes have precedence over the 'event' attribute.
	*  @param expr		Specify an expression to evaluate as a URI to transition to instead of specifying a next. The 'next' attribute has precedence over the 'expr' attribute.
	*  @param fetchaudio
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_choice($dtmf="",$accept="",$next="",$event="",$expr="",$fetchaudio="",$fetchtimeout="",$fetchhint="",$maxage="",$maxstale="")
	{
		$result= ("<choice");
		
		if ((isset($dtmf)) and ($dtmf!=="")){
			$result.=(" dtmf=\"$dtmf\"");
		}
		
		if ((isset($accept)) and ($accept!=="")){
			$result.=(" accept=\"$accept\"");
		}

		if ((isset($next)) and ($next!=="")){
			$result.=(" next=\"$next\"");
		} else {
			$result.=(" <!-- a VXML Error occured in CHOICE. Need to pass \"next\"=... -->");
		}
		
		if ((isset($event)) and ($event!=="")){
			$result.=(" event=\"$event\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		if ((isset($fetchaudio)) and ($fetchaudio!=="")){
			$result.=(" fetchaudio=\"$fetchaudio\"");
		}
		
		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml CHOICE tag.
	*/
	
	function end_vxml_choice()
	{
		$this->_document .= "</choice>\n";
		return true;
	}

	/*
	* Function to create a CHOICE statement
	* @param $next
	* @param $title
	*/		
	function vxml_choice($next,$title)
	{
		$this->vxml_start_choice("","" ,$next );
		$this->_document .= $title;
		$this->end_vxml_choice();
		return true;
	}
	
	/*
	* 
	* Function to create a CLEAR statement (Clear one or more form item variables)
	* 
	*  @param namelist		The names of the form items to be reset. When not specified, all form items in the current form are cleared.
	* 
	*/
	
	function vxml_start_clear($namelist="")
	{
		$result= ("<clear");
		
		if ((isset($namelist)) and ($namelist!=="")){
			$result.=(" namelist=\"$namelist\"");
		} else {
			$result.=(" <!-- a VXML Error occured in CLEAR. Need to pass \"namelist\"=... -->");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml CATCH tag.
	*/
	
	function end_vxml_clear()
	{
		$this->_document .= "</clear>\n";
		return true;
	}
	
	/*
	* Function to close a vxml DISCONNET tag.
	*/
	
	function vxml_start_disconnect()
	{
		$this->_document .= "<disconnect/>\n";
		return true;
	}
	
	/*
	* 
	* Function to create ELSE Statement
	* 
	*/
	
	function vxml_start_else()
	{
		$this->_document .= "<else/>";
		return true;
	}
	
	/*
	* 
	* Function to create ELSEIF Statement
	* 
	* @param cond		Condition for elseif statement
	* 
	*/
	
	function vxml_start_elseif($cond="")
	{
		$result= ("<elseif");
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		} else {
			$result.=(" <!-- a VXML Error occured in ELSEIF. Need to pass \"cond\"=... -->");
		}
		
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* 
	* Function to create ENUMERATE Statement
	* 
	*/
	
	function vxml_start_enumerate()
	{
		$this->_document .= "<enumerate>";
		return true;
	}
	
	/*
	* 
	* Function to close an ENUMERATE Statement
	* 
	*/
	
	function end_vxml_enumerate()
	{
		$this->_document .= "</enumerate>";
		return true;
	}
	
	/*
	* 
	* General ENUMERATE Statement
	* 
	*/
	
	function vxml_enumerate($text="")
	{
		$this->vxml_start_enumerate();
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_enumerate();
		return true;
	}
	
	/*
	* 
	* Function to create a ERROR statement
	* 
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_start_error($count="",$cond="")
	{
		$result= ("<error");
		
		if ((isset($count)) and ($count!=="")){
			$result.=(" count=\"$count\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml CATCH tag.
	*/
	
	function end_vxml_error()
	{
		$this->_document .= "</error>\n";
		return true;
	}
	
	/*
	* 
	* Function to create an EXIT statement
	* 
	*  @param expr			A return expression (e.g. "0", or "'oops!'").
	*  @param namelist		Variable names to be returned to interpreter context. The default is to return no variables; this means the interpreter context will receive an empty ECMAScript object.
	* 
	*/
	
	function vxml_start_exit($expr="",$namelist="")
	{
		$result= ("<exit");
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		if ((isset($namelist)) and ($namelist!=="")){
			$result.=(" namelist=\"$namelist\"");
		} else {
			$result.=(" <!-- a VXML Error occured in CLEAR. Need to pass \"namelist\"=... -->");
		}
		
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* 
	* Function to create an FIELD statement (A field specifies an input item to be gathered from the user)
	* 
	*  @param name		The field item variable in the dialog scope that will hold the result. The name must be a unique variable name within the scope of the form. If the name is not unique, then a badfetch error is thrown when the document is fetched. The name must conform to the variable naming conventions in Section 5.1.
	*  @param expr		The initial value of the form item variable; default is ECMAScript undefined. If initialized to a value, then the form item will not be visited unless the form item variable is cleared
	*  @param cond		A boolean condition that must also evaluate to true in order for the form item to be visited
	*  @param type		The type of field, i.e., the name of an internal grammar. This name must be from a standard set supported by all conformant platforms. If not present, <grammar> elements can be specified instead.
	*  @param slot		The name of the grammar slot used to populate the variable (if it is absent, it defaults to the variable name). This attribute is useful in the case where the grammar format being used has a mechanism for returning sets of slot/value pairs and the slot names differ from the field item variable names. If the grammar returns only one slot, as do the builtin type grammars like boolean, then no matter what the slot�s name, the field item variable gets the value of that slot.
	*  @param modal		If this is false (the default) all active grammars are turned on while collecting this field. If this is true, then only the field�s grammars are enabled: all others are temporarily disabled.
	* 
	*/
	
	function vxml_start_field($name="",$expr="",$cond="",$type="",$slot="",$modal="")
	{
		$result= ("<field");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		} else {
			$result.=(" <!-- a VXML Error occured in Block. Need to pass \"name\"=... -->");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}

		if ((isset($type)) and ($type!=="")){
			$result.=(" type=\"$type\"");
		}

		if ((isset($slot)) and ($slot!=="")){
			$result.=(" slot=\"$slot\"");
		}
		
		if ((isset($modal)) and ($modal!=="")){
			$result.=(" modal=\"$modal\"");
		}
		
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml FIELD tag.
	*/
	
	function end_vxml_field()
	{
		$this->_document .= "</field>\n";
		return true;
	}
	
	/*
	* 
	* Function to create an FILLED statement
	* 
	*  @param mode		Either all (the default), or any. If any, this action is executed when any of the specified fields is filled by the last user input. If all, this action is executed when all of the mentioned fields are filled, and at least one has been filled by the last user input. A <filled> element in a field item cannot specify a mode.
	*  @param namelist	The fields to trigger on. For a <filled> in a form, namelist defaults to the names (explicit and implicit) of the form�s field items. A <filled> element in a field item cannot specify a namelist; the namelist in this case is the field item name.
	* 
	*/
	
	function vxml_start_filled($mode="",$namelist="")
	{
		$result= ("<filled");
		
		if ((isset($mode)) and ($mode!=="")){
			$result.=(" mode=\"$mode\"");
		}
		
		if ((isset($namelist)) and ($namelist!=="")){
			$result.=(" namelist=\"$namelist\"");
		}
		
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml FILLED tag.
	*/
	
	function end_vxml_filled()
	{
		$this->_document .= "</filled>\n";
		return true;
	}
	
	/*
	* 
	* Function to create an FORM statement
	* 
	*  @param id		The name of the form. If specified, the form can be referenced within the document or from another document. For instance <form id="weather">, <goto next="#weather">.
	*  @param scope	The fields to trigger on. For a <filled> in a form, namelist defaults to the names (explicit and implicit) of the form�s field items. A <filled> element in a field item cannot specify a namelist; the namelist in this case is the field item name.
	* 
	*/
	
	function vxml_start_form($id="",$scope="")
	{
		$result= ("<form");
		
		if ((isset($id)) and ($id!=="")){
			$result.=(" id=\"$id\"");
		}
		
		if ((isset($scope)) and ($scope!=="")){
			$result.=(" scope=\"$scope\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml FORM tag.
	*/
	
	function end_vxml_form()
	{
		$this->_document .= "</form>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a GOTO statement
	* 
	*  @param next		The URI to which to transition
	*  @param expr		An ECMAScript expression that yields the URI. The 'next' attribute has precedence over 'expr'
	*  @param nextitem	The name of the next form item to visit in the current form. 'next' and 'expr' attributes have precedence over 'nextitem'.
	*  @param expritem	An ECMAScript expression that yields the name of the next form item to visit. The 'nextitem' attribute has precedence over 'expritem'.
	*  @param fetchaudio
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_goto($next="",$expr="",$nextitem="",$expritem="",$fetchaudio="",$fetchtimeout="",$fetchhint="",$maxage="",$maxstale="")
	{
		$result= ("<goto");
		
		if ((isset($next)) and ($next!=="")){
			$result.=(" next=\"$next\"");
		} else {
			$result.=(" <!-- a VXML Error occured in Goto. Element need at least attribute \"next\"=... -->");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($nextitem)) and ($nextitem!=="")){
			$result.=(" nextitem=\"$nextitem\"");
		}
		
		if ((isset($fetchaudio)) and ($fetchaudio!=="")){
			$result.=(" fetchaudio=\"$fetchaudio\"");
		}
		
		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml GOTO tag.
	*/
	
	function end_vxml_goto()
	{
		$this->_document .= "</goto>\n";
		return true;
	}

	/*
	* 
	* Function to create a GRAMMAR statement
	* 
	*  @param xml:lang	The language and locale identifier of the contained or referenced grammar following RFC 1766. (For example, "fr-CA" for Canadian French.) If omitted, the value is inherited down from the document hierarchy. Should the grammar self-identify its locale, that definition has precedence.
	*  @param src		The URI specifying the location of the grammar and optionally a rulename within that grammar, if it is external. The URI is interpreted as a rule reference as defined in Section 2.2 of the Speech Recognition Grammar Format but not all forms of rule reference are permitted from within VoiceXML. The rule reference capabilities are described in detail below this table.
	*  @param scope		Either "document", which makes the grammar active in all dialogs of the current document (and relevant application leaf documents), or "dialog", to make the grammar active throughout the current form. If omitted, the grammar scoping is resolved by looking at the parent element. See Section 3.1.3 for details on scoping including precedence behavior.
	*  @param type		The media type of the grammar. If this is omitted, the interpreter context will attempt to determine the type dynamically. If the content of the element is an XML grammar then the media type may be omitted. The tentative media types for the W3C grammar format are "application/grammar+xml" for the XML form and "application/grammar" for Augmented BNF grammars.
	*  @param mode		Defines the mode of the contained or referenced grammar following the modes of the W3C Speech Recognition Grammar Format. Defined values are "voice" and "dtmf" for DTMF input. If the mode value is in conflict with the mode of the grammar itself, a "badfetch" event is thrown.
	*  @param root		Defines the public rule which acts as the root rule of the grammar. The root rule is only used when the grammar is inline and must be present when using an inline XML grammar to identify which rule to activate.
	*  @param version	Defines the version of the grammar. The default value is "1.0".
	*  @param weight	Specifies the weight of the grammar
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_grammar($lang="",$src="",$scope="",$type="",$mode="",$root="",$version="",$weight="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$result= ("<grammar");
		
		if ((isset($lang)) and ($lang!=="")){
			$result.=(" lang=\"$lang\"");
		}
		
		if ((isset($src)) and ($src!=="")){
			$result.=(" src=\"$src\"");
		}

		if ((isset($scope)) and ($scope!=="")){
			$result.=(" scope=\"$scope\"");
		}
		
		if ((isset($type)) and ($type!=="")){
			$result.=(" type=\"$type\"");
		}
		
		if ((isset($mode)) and ($mode!=="")){
			$result.=(" mode=\"$mode\"");
		}

		if ((isset($root)) and ($root!=="")){
			$result.=(" root=\"$root\"");
		}

		if ((isset($version)) and ($version!=="")){
			$result.=(" version=\"$version\"");
		}

		if ((isset($weight)) and ($weight!=="")){
			$result.=(" scope=\"$scope\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml GRAMMAR tag.
	*/
	
	function end_vxml_grammar()
	{
		$this->_document .= "</goto>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a HELP statement
	* 
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_start_help($count="",$cond="")
	{
		$result= ("<help");
		
		if ((isset($count)) and ($count!=="")){
			$result.=(" count=\"$count\"");
		}
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml HELP tag.
	*/
	
	function end_vxml_help()
	{
		$this->_document .= "</help>\n";
		return true;
	}
	
	/*
	* General vxml HELP tag.
	* 
	*  @param text		text to prompt for help
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_help($text="",$count="",$cond="")
	{
		$this->vxml_start_help($count,$cond);
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_help();
		return true;
	}
	
	/*
	* 
	* Function to create IF Statement
	* 
	* @param cond		Condition for elseif statement
	* 
	*/
	
	function vxml_start_if($cond="")
	{
		$result= ("<if");
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		} else {
			$result.=(" <!-- a VXML Error occured in IF. Need to pass \"cond\"=... -->");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml IF tag.
	*/
	
	function end_vxml_if()
	{
		$this->_document .= "</if>\n";
		return true;
	}
	
	/*
	* 
	* Function to create INITIAL Statement
	* 
	* @param name		The name of a form item variable used to track whether the <initial> is eligible to execute; defaults to an inaccessible internal variable.
	* @param expr		The initial value of the form item variable; default is ECMAScript undefined. If initialized to a value, then the form item will not be visited unless the form item variable is cleared.
	* @param cond		A boolean condition that must also evaluate to true in order for the form item to be visited.
	* 
	*/
	
	function vxml_start_initial($name="",$expr="",$cond="")
	{
		$result= ("<initial");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		} else {
			$result.=(" <!-- a VXML Error occured in INITIAL. Need to pass \"name\"=... -->");
		}

		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml INITIAL tag.
	*/
	
	function end_vxml_initial()
	{
		$this->_document .= "</initial>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a LINK statement
	* 
	*  @param next		The URI to go to. This URI is a document (perhaps with an anchor to specify the starting dialog), or a dialog in the current document (just a bare anchor).
	*  @param expr		Like next, except that the URI is dynamically determined by evaluating the given ECMAScript expression.
	*  @param event		The event to throw when the user matches one of the link grammars. Note that only one of next, expr, or event may be specified.
	*  @param dtfm		The DTMF sequence for this link. It is equivalent to a simple DTMF <grammar>. The attribute can be used at the same time as other <grammar>s: the link is activated when user input matches a link grammar or the DTMF sequence
	*  @param fetchaudio
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_link($next="",$expr="",$event="",$dtfm="",$fetchaudio="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$result= ("<link");
		
		if ((isset($next)) and ($next!=="")){
			$result.=(" next=\"$next\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($event)) and ($event!=="")){
			$result.=(" event=\"$event\"");
		}
		
		if ((isset($dtfm)) and ($dtfm!=="")){
			$result.=(" dtfm=\"$dtfm\"");
		}
		
		if ((isset($fetchaudio)) and ($fetchaudio!=="")){
			$result.=(" fetchaudio=\"$fetchaudio\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml LINK tag.
	*/
	
	function end_vxml_link()
	{
		$this->_document .= "</link>\n";
		return true;
	}

	/*
	* 
	* Function to create LOG Statement
	* 
	* @param label		A string which may be used, for example, to indicate the purpose of the log. It is added as a separate message following document order.
	* @param expr		An ECMAscript expression evaluating to a string. The string is added as a separate message following document order.
	* 
	*/
	
	function vxml_start_log($label="",$expr="")
	{
		$result= ("<log");
		
		if ((isset($label)) and ($label!=="")){
			$result.=(" label=\"$label\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml LOG tag.
	*/
	
	function end_vxml_log()
	{
		$this->_document .= "</log>\n";
		return true;
	}	

	/*
	* 
	* Function to create MENU Statement
	* 
	* @param id			The identifier of the menu. It allows the menu to be the target of a <goto> or a <submit>.
	* @param scope		The menu�s grammar scope. If it is dialog � the default � the menu�s grammars are only active when the user transitions into the menu. If the scope is document, its grammars are active over the whole document (or if the menu is in the application root document, any loaded document in the application).
	* @param dtmf		When set to true, any choices that do not have explicit DTMF elements are given the implicit ones "1", "2", etc.
	* @param accept		When set to "exact" (the default), the text of the choice elements in the menu defines the exact phrase to be recognized. When set to "approximate", the text of the choice elements defines an approximate recognition phrase (as described under grammar generation). Each <choice> can override this setting.
	* 
	*/
	
	function vxml_start_menu($id="",$scope="",$dtmf="",$accept="")
	{
		$result= ("<menu");
		
		if ((isset($id)) and ($id!=="")){
			$result.=(" id=\"$id\"");
		}
		
		if ((isset($scope)) and ($scope!=="")){
			$result.=(" scope=\"$scope\"");
		}
		
		if ((isset($dtmf)) and ($dtmf!=="")){
			$result.=(" dtmf=\"$dtmf\"");
		}
		
		if ((isset($accept)) and ($accept!=="")){
			$result.=(" accept=\"$accept\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml MENU tag.
	*/
	
	function end_vxml_menu()
	{
		$this->_document .= "</menu>\n";
		return true;
	}	

	/*
	* 
	* Function to create META Statement
	* 
	* @param author			Information describing the author
	* @param copyright		A copyright notice.
	* @param description	A description of the document for search engines.
	* @param keywords		Keywords describing the document
	* @param maintainer		The document maintainer�s email address.
	* @param robots			Directives to search engine web robots.
	* 
	*/
	
	function vxml_start_meta($author="",$copyright="",$description="",$keywords="",$maintainer="",$robots="")
	{
		$result= ("<meta");
		
		if ((isset($author)) and ($author!=="")){
			$result.=(" author=\"$author\"");
		}
		
		if ((isset($copyright)) and ($copyright!=="")){
			$result.=(" copyright=\"$copyright\"");
		}
		
		if ((isset($description)) and ($description!=="")){
			$result.=(" description=\"$description\"");
		}
		
		if ((isset($keywords)) and ($keywords!=="")){
			$result.=(" accept=\"$accept\"");
		}
		
		if ((isset($maintainer)) and ($maintainer!=="")){
			$result.=(" maintainer=\"$maintainer\"");
		}
		
		if ((isset($robots)) and ($robots!=="")){
			$result.=(" robots=\"$robots\"");
		}
		
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function to close a vxml META tag.
	*/
	
	function end_vxml_meta()
	{
		$this->_document .= "</meta>\n";
		return true;
	}	

	/*
	* 
	* Function to create a NOINPUT statement
	* 
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_start_noinput($count="",$cond="")
	{
		$result= ("<noinput");
		
		if ((isset($count)) and ($count!=="")){
			$result.=(" count=\"$count\"");
		}
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml NOINPUT tag.
	*/
	
	function end_vxml_noinput()
	{
		$this->_document .= "</noinput>\n";
		return true;
	}
	
	/*
	* General vxml NOINPUT tag.
	* 
	*  @param text		text to prompt for help
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_noinput($text="",$count="",$cond="")
	{
		$this->vxml_start_noinput($count,$cond);
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_noinput();
		return true;
	}

	/*
	* 
	* Function to create a NOMATCH statement
	* 
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_start_nomatch($count="",$cond="")
	{
		$result= ("<nomatch");
		
		if ((isset($count)) and ($count!=="")){
			$result.=(" count=\"$count\"");
		}
		
		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml NOMATCH tag.
	*/
	
	function end_vxml_nomatch()
	{
		$this->_document .= "</nomatch>\n";
		return true;
	}
	
	/*
	* General vxml NOMATCH tag.
	* 
	*  @param text		text to prompt for help
	*  @param count		The event count (as in <catch>).
	*  @param cond		An optional condition to test to see if the event is caught by this element (as in <catch>). Defaults to true.
	* 
	*/
	
	function vxml_nomatch($text="",$count="",$cond="")
	{
		$this->vxml_start_noinput($count,$cond);
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_noinput();
		return true;
	}
	
	/*
	* 
	* Function to create a OBJECT statement
	* 
	*  @param name		When the object is evaluated, it sets this variable to an ECMAScript value whose type is defined by the object.
	*  @param expr		The initial value of the form item variable; default is ECMAScript undefined. If initialized to a value, then the form item will not be visited unless the form item variable is cleared.
	*  @param cond		A boolean condition that must also evaluate to true in order for the form item to be visited
	*  @param classid	The URI specifying the location of the object�s implementation. The URI conventions are platform-dependent.
	*  @param codebase	The base path used to resolve relative URIs specified by classid, data, and archive. It defaults to the base URI of the current document.
	*  @param codetype	The content type of data expected when downloading the object specified by classid. When absent it defaults to the value of the type attribute.
	*  @param data		The URI specifying the location of the object�s data. If it is a relative URI, it is interpreted relative to the codebase attribute.
	*  @param type		The content type of the data specified by the data attribute.
	*  @param archive	A space-separated list of URIs for archives containing resources relevant to the object, which may include the resources specified by the classid and data attributes. URIs which are relative are interpreted relative to the codebase attribute.
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_object($name="",$expr="",$cond="",$classid="",$codebase="",$codetype="",$data="",$type="",$archive="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$result= ("<object");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		if ((isset($classid)) and ($classid!=="")){
			$result.=(" classid=\"$classid\"");
		}
		
		if ((isset($codebase)) and ($codebase!=="")){
			$result.=(" codebase=\"$codebase\"");
		}
		
		if ((isset($codetype)) and ($codetype!=="")){
			$result.=(" codetype=\"$codetype\"");
		}
		
		if ((isset($data)) and ($data!=="")){
			$result.=(" data=\"$data\"");
		}
		
		if ((isset($type)) and ($type!=="")){
			$result.=(" type=\"$type\"");
		}
		
		if ((isset($archive)) and ($archive!=="")){
			$result.=(" archive=\"$archive\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml OBJECT tag.
	*/
	
	function end_vxml_object()
	{
		$this->_document .= "</object>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a OPTION statement
	* 
	*  @param value
	*  @param dtmf
	* 
	*/
	
	function vxml_start_option($value="",$dtmf="")
	{
		$result= ("<option");
		
		if ((isset($value)) and ($value!=="")){
			$result.=(" value=\"$value\"");
		}
		
		if ((isset($dtmf)) and ($dtmf!=="")){
			$result.=(" dtmf=\"$dtmf\"");
		}
		
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml OPTION tag.
	*/
	
	function end_vxml_option()
	{
		$this->_document .= "</option>\n";
		return true;
	}
	
	/*
	* General vxml OPTION tag.
	* 
	*  @param text		text to prompt for option
	*  @param value
	*  @param dtmf
	* 
	*/
	
	function vxml_option($text="",$value="",$dtmf="")
	{
		$this->vxml_start_noinput($value,$dtmf);
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_noinput();
		return true;
	}

	/*
	* 
	* Function to create a PARAM statement
	* 
	*  @param name		The name to be associated with this parameter when the object or subdialog is invoked
	*  @param expr		An expression that computes the value associated with name.
	*  @param value		Associates a literal string value with name
	*  @param valuetype	One of data or ref, by default data; used to indicate to an object if the value associated with name is data or a URI (ref). This is not used for <subdialog>.
	*  @param type		The media type of the result provided by a URI if the valuetype is ref; only relevant for uses of <param> in <object>.
	* 
	*/
	
	function vxml_start_param($name="",$expr="",$value="",$valuetype="",$type="")
	{
		$result= ("<param");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($value)) and ($value!=="")){
			$result.=(" value=\"$value\"");
		}
		
		if ((isset($valuetype)) and ($valuetype!=="")){
			$result.=(" valuetype=\"$valuetype\"");
		}
		
		if ((isset($type)) and ($type!=="")){
			$result.=(" type=\"$type\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml PARAM tag.
	*/
	
	function end_vxml_param()
	{
		$this->_document .= "</param>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a PROMPT statement
	* 
	*  @param bargein		Control whether a user can interrupt a prompt. Default is true.
	*  @param bargeintype	Sets the type of bargein to be 'energy', 'speech', or 'recognition'. Default is platform-specific.
	*  @param cond			An expression telling if the prompt should be spoken. Default is true.
	*  @param count			A number that allows you to emit different prompts if the user is doing something repeatedly. If omitted, it defaults to "1".
	*  @param timeout		The timeout that will be used for the following user input. The default noinput timeout is platform specific.
	*  @param xml:lang		The language and locale type as defined in RFC 1766. If omitted, it defaults to the value specified in the document's "xml:lang" attribute.
	* 
	*/
	
	function vxml_start_prompt($bargein="",$bargeintype="",$cond="",$count="",$timeout="",$lang="")
	{
		$result= ("<prompt");
		
		if ((isset($bargein)) and ($bargein!=="")){
			$result.=(" bargein=\"$bargein\"");
		}
		
		if ((isset($bargeintype)) and ($bargeintype!=="")){
			$result.=(" bargeintype=\"$bargeintype\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		if ((isset($count)) and ($count!=="")){
			$result.=(" count=\"$count\"");
		}
		
		if ((isset($timeout)) and ($timeout!=="")){
			$result.=(" timeout=\"$timeout\"");
		}
		
		if ((isset($lang)) and ($lang!=="")){
			$result.=(" lang=\"$lang\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml PROMPT tag.
	*/
	
	function end_vxml_prompt()
	{
		$this->_document .= "</prompt>\n";
		return true;
	}
	
	/*
	* GENERAL vxml PROMPT tag.
	*/
	
	function vxml_prompt($text="",$bargein="",$bargeintype="",$cond="",$count="",$timeout="",$lang="")
	{
		$this->vxml_start_prompt($bargein="",$bargeintype="",$cond="",$count="",$timeout="",$lang="");
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_prompt();
		return true;
	}
	
	/*
	* 
	* Function to create a PROPERTY statement
	* 
	*  @param name
	*  @param value
	* 
	*/
	
	function vxml_start_property ($name="",$value="")
	{
		$result= ("<property");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($value)) and ($value!=="")){
			$result.=(" value=\"$value\"");
		}
				
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* 
	* Function to create a RECORD statement
	* 
	*  @param name			The field item variable that will hold the recording.
	*  @param expr			The initial value of the form item variable; default is ECMAScript undefined. If initialized to a value, then the form item will not be visited unless the form item variable is cleared.
	*  @param cond			A boolean condition that must also evaluate to true in order for the form item to be visited
	*  @param modal			If this is true (the default) all higher level speech and DTMF grammars are turned off while making the recording. If this is false, speech and DTMF grammars scoped to the form, document, application, and calling documents are listened for. Most implementations will not support simultaneous recognition and recording.
	*  @param beep			If true, a tone is emitted just prior to recording. Defaults to false
	*  @param maxtime		The maximum duration to record.
	*  @param finalsilence	The interval of silence that indicates end of speech.
	*  @param dtmfterm		If true, a DTMF keypress terminates recording. Defaults to true. The DTMF tone is not part of the recording.
	*  @param type			The media format of the resulting recording. Platforms must support the audio file formats specified in Appendix E (other formats may also be supported). Defaults to a platform-specific format which should be one of the required formats.
	*  @param dest			The URI for the destination of the recording, for platforms that may support storage of recording to streaming media or messaging servers.
	*						If the recording destination cannot be accessed for audio playback and/or HTTP POST submit, error.semantic is thrown when the recording field variable is referenced.
	* 
	*/
	
	function vxml_start_record($name="",$expr="",$cond="",$modal="",$beep="",$maxtime="",$finalsilence="",$dtmfterm="",$type="",$dest="")
	{
		$result= ("<record");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		if ((isset($modal)) and ($modal!=="")){
			$result.=(" modal=\"$modal\"");
		}
		
		if ((isset($beep)) and ($beep!=="")){
			$result.=(" beep=\"$beep\"");
		}
		
		if ((isset($maxtime)) and ($maxtime!=="")){
			$result.=(" maxtime=\"$maxtime\"");
		}
		
		if ((isset($finalsilence)) and ($finalsilence!=="")){
			$result.=(" finalsilence=\"$finalsilence\"");
		}
		
		if ((isset($dtmfterm)) and ($dtmfterm!=="")){
			$result.=(" maxtime=\"$maxtime\"");
		}
		
		if ((isset($type)) and ($type!=="")){
			$result.=(" type=\"$type\"");
		}
		
		if ((isset($dest)) and ($dest!=="")){
			$result.=(" dest=\"$dest\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* Function vxml REPROMPT tag.
	*/
	
	function vxml_reprompt()
	{
		$this->_document .= "<reprompt/>\n";
		return true;
	}
	
	/*
	* Function vxml RETURN tag.
	* 
	* @param event		Return, then throw this event.
	* @param namelist	Variable names to be returned to calling dialog. The default is to return no variables; this means the caller will receive an empty ECMAScript object.
	* 
	*/
	
	function vxml_return($event="",$namelist="")
	{
		$result= ("<return");
		
		if ((isset($event)) and ($event!=="")){
			$result.=(" event=\"$event\"");
		}
		
		if ((isset($namelist)) and ($$namelist!=="")){
			$result.=(" $namelist=\"$$namelist\"");
		}
				
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* 
	* Function to create a SCRIPT statement
	* 
	*  @param src		The URI specifying the location of the script, if it is external
	*  @param charset	The character encoding of the script designated by src. UTF-8 and UTF-16 encodings of 10646 must be supported (as in XML) and other encodings, as defined in the IANA character set registry, may be supported. The default value is UTF-8.
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_script($src="",$charset="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$result= ("<script");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($charset)) and ($charset!=="")){
			$result.=(" charset=\"$charset\"");
		}

		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml SCRIPT tag.
	*/
	
	function end_vxml_script()
	{
		$this->_document .= "</script>\n";
		return true;
	}

	/*
	* GENERAL vxml SCRIPT tag.
	* 
	*  @param text
	*  @param src
	*  @param charset
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	*/
	
	function vxml_script($text="",$src="",$charset="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$this->vxml_start_script($src="",$charset="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="");
		if ($text){
			$this->_document .= $text;
		}
		$this->end_vxml_script();
		return true;
	}

	/*
	* 
	* Function to create a SUBDIALOG statement
	* 
	*  @param name		The result returned from the subdialog, an ECMAScript object whose properties are the ones defined in the namelist attribute of the <return> element.
	*  @param expr		The initial value of the form item variable; default is ECMAScript undefined. If initialized to a value, then the form item will not be visited unless the form item variable is cleared.
	*  @param cond		A boolean condition that must also evaluate to true in order for the form item to be visited
	*  @param namelist	Same as namelist in <submit>, except that the default is to submit nothing. Only valid when fetching another document.
	*  @param src		The URI of the <subdialog>.
	*  @param method
	*  @param enctype
	*  @param fetchaudio
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_subdialog($name="",$expr="",$cond="",$namelist="",$src="",$method="",$enctype="",$fetchaudio="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$result= ("<subdialog");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		if ((isset($namelist)) and ($namelist!=="")){
			$result.=(" namelist=\"$namelist\"");
		}
		
		if ((isset($src)) and ($src!=="")){
			$result.=(" src=\"$src\"");
		}
		
		if ((isset($method)) and ($method!=="")){
			$result.=(" method=\"$method\"");
		}
		
		if ((isset($enctype)) and ($enctype!=="")){
			$result.=(" enctype=\"$enctype\"");
		}
		
		if ((isset($fetchaudio)) and ($fetchaudio!=="")){
			$result.=(" fetchaudio=\"$fetchaudio\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml SUBDIALOG tag.
	*/
	
	function end_vxml_subdialog()
	{
		$this->_document .= "</subdialog>\n";
		return true;
	}

	/*
	* 
	* Function to create a SUBMIT statement
	* 
	*  @param next		The URI to which the query is submitted.
	*  @param expr		Like next, except that the URI is dynamically determined by evaluating the given ECMAScript expression. One of next or expr is required
	*  @param namelist	The list of variables to submit. By default, all the named field item variables are submitted. If a namelist is supplied, it may contain individual variable references which are submitted with the same qualification used in the namelist. Declared VoiceXML and ECMAScript variables can be referenced.
	*  @param method	The request method: get (the default) or post.
	*  @param enctype	The media encoding type of the submitted document. The default is application/x-www-form-urlencoded. Interpreters must also support multipart/form-data and may support additional encoding types.
	*  @param fetchaudio
	*  @param fetchhint
	*  @param fetchtimeout
	*  @param maxage
	*  @param maxstale
	* 
	*/
	
	function vxml_start_submit($next="",$expr="",$namelist="",$method="",$enctype="",$fetchaudio="",$fetchhint="",$fetchtimeout="",$maxage="",$maxstale="")
	{
		$result= ("<submit");
		
		if ((isset($next)) and ($next!=="")){
			$result.=(" next=\"$next\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($namelist)) and ($namelist!=="")){
			$result.=(" namelist=\"$namelist\"");
		}
		
		if ((isset($method)) and ($method!=="")){
			$result.=(" method=\"$method\"");
		}
		
		if ((isset($enctype)) and ($enctype!=="")){
			$result.=(" enctype=\"$enctype\"");
		}
		
		if ((isset($fetchaudio)) and ($fetchaudio!=="")){
			$result.=(" fetchaudio=\"$fetchaudio\"");
		}
		
		if ((isset($fetchhint)) and ($fetchhint!=="")){
			$result.=(" fetchhint=\"$fetchhint\"");
		}

		if ((isset($fetchtimeout)) and ($fetchtimeout!=="")){
			$result.=(" fetchtimeout=\"$fetchtimeout\"");
		}
		
		if ((isset($maxage)) and ($maxage!=="")){
			$result.=(" maxage=\"$maxage\"");
		}

		if ((isset($maxstale)) and ($maxstale!=="")){
			$result.=(" maxstale=\"$maxstale\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml SUBMIT tag.
	*/
	
	function end_vxml_submit()
	{
		$this->_document .= "</submit>\n";
		return true;
	}

	/*
	* 
	* Function to create a THROW statement
	* 
	*  @param event			The event being thrown.
	*  @param eventexpr		An ECMAScript expression evaluating to the name of the event being thrown. The 'event' attribute has precedence over 'eventexpr'.
	*  @param message		An message string providing additional context about the event being thrown. For the pre-defined events thrown by the platform, the value of the message is platform-dependent. The message is available as the value of a variable within the scope of the catch element, see below.
	*  @param messageexpr	An ECMAScript expression evaluating to the message string. The 'message' attribute has precedence over 'messageexpr'.
	* 
	*/
	
	function vxml_start_throw($event="",$eventexpr="",$message="",$messageexpr="")
	{
		$result= ("<throw");
		
		if ((isset($event)) and ($event!=="")){
			$result.=(" event=\"$event\"");
		} else {
			$result.=(" <!-- a VXML Error occured in THROW. Need to pass \"event\"=... -->");
		}
		
		if ((isset($eventexpr)) and ($eventexpr!=="")){
			$result.=(" eventexpr=\"$eventexpr\"");
		}

		if ((isset($message)) and ($message!=="")){
			$result.=(" message=\"$message\"");
		}
		
		if ((isset($messageexpr)) and ($messageexpr!=="")){
			$result.=(" valuetype=\"$valuetype\"");
		}
				
		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml THROW tag.
	*/
	
	function end_vxml_throw()
	{
		$this->_document .= "</throw>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a TRANSFER statement
	* 
	*  @param name				The outcome of the transfer attempt.
	*  @param expr				The initial value of the form item variable; default is ECMAScript undefined.
	* 							If initialized to a value, then the form item will not be visited unless the
	* 							form item variable is cleared.
	*  @param cond				A boolean condition that must also evaluate to true in order for the form item
	* 							to be visited
	*  @param dest				The URI of the destination (phone, IP telephony address). Platforms must support
	* 							the tel: URL syntax described in RFC 2806 and may support other URI-based addressing
	* 							schemes.
	*  @param destexpr			An ECMAScript expression yielding the URI of the destination. Note that only
	* 							one of dest or destexpr is allowed.
	*  @param bridge			This attribute determines what to do once the call is connected. If bridge is true,
	* 							document interpretation suspends until the transferred call terminates and the
	* 							platform remains connected to the call.
	* 							If it is false, as soon as the call connects, the platform throws a telephone.
	* 							disconnect.transfer.
	*  @param connecttimeout	The time to wait while trying to connect the call before returning the noanswer
	* 							condition. Default is platform specific.
	*  @param maxtime			The time that the call is allowed to last, or 0 if it can last arbitrarily long.
	* 							Only applies if bridge is true. Default is 0.
	*  @param transferaudio		URI of audio file/stream;
	* 							for example, transferaudio="http://www.musiconhold.example.com/foo.wav"
	* 
	*/
	
	function vxml_start_transfer($name="",$expr="",$cond="",$dest="",$destexpr="",$bridge="",$connecttimeout="",$maxtime="",$transferaudio="")
	{
		$result= ("<transfer");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		}

		if ((isset($cond)) and ($cond!=="")){
			$result.=(" cond=\"$cond\"");
		}
		
		if ((isset($dest)) and ($dest!=="")){
			$result.=(" dest=\"$dest\"");
		}
		
		if ((isset($destexpr)) and ($destexpr!=="")){
			$result.=(" destexpr=\"$destexpr\"");
		}
		
		if ((isset($bridge)) and ($bridge!=="")){
			$result.=(" bridge=\"$bridge\"");
		}
		
		if ((isset($connecttimeout)) and ($connecttimeout!=="")){
			$result.=(" connecttimeout=\"$connecttimeout\"");
		}		
				
		if ((isset($maxtime)) and ($maxtime!=="")){
			$result.=(" maxtime=\"$maxtime\"");
		}
		
		if ((isset($transferaudio)) and ($transferaudio!=="")){
			$result.=(" transferaudio=\"$transferaudio\"");
		}

		$result.= (">\n");
		$this->_document .= $result;
		return true;
	}

	/*
	* Function to close a vxml TRANSFER tag.
	*/
	
	function end_vxml_transfer()
	{
		$this->_document .= "</transfer>\n";
		return true;
	}
	
	/*
	* 
	* Function to create a VALUE statement
	* 
	*  @param expr			The expression to render.
	* 
	*/
	
	function vxml_start_value($expr="")
	{
		$result= ("<value");
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		} else {
			$result.=(" <!-- a VXML Error occured in VALUE. Need to pass \"expr\"=... -->");
		}
				
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* 
	* Function to create a VAR statement
	* 
	* @param name			The name of the variable that will hold the result. 
	* @param expr			The initial value of the variable (optional). If there is no expr attribute, the variable retains its current value, if any. Variables start out with the ECMAScript value undefined if they are not given initial values.
	* 
	*/
	
	function vxml_start_var($name="",$expr="")
	{
		$result= ("<var");
		
		if ((isset($name)) and ($name!=="")){
			$result.=(" name=\"$name\"");
		} else {
			$result.=(" <!-- a VXML Error occured in VAR. Need to pass \"name\"=... -->");
		}
		
		if ((isset($expr)) and ($expr!=="")){
			$result.=(" expr=\"$expr\"");
		} else {
			$result.=(" <!-- a VXML Error occured in VAR. Need to pass \"expr\"=... -->");
		}
				
		$result.= ("/>\n");
		$this->_document .= $result;
		return true;
	}
	
	/*
	* 
	* Function to generate the VXML document
	* 
	*/
	
	function generate()
	{
		echo $this->_document;
	}
	
	/*
	* 
	* Function to add a JavaScript to your VXML document
	* 
	* @param script			The script itself
	* 
	*/
	
	function addscript($script)
	{
		$this->_document .= "<![CDATA[\n  ".$script."\n]]>\n";
	}
	
	/*
	* 
	* Function to add any non-available vxml stuff to your application
	* 
	* @param text			The text itself
	* 
	*/

	function addtext($text)
	{
		$this->_document .= $text;
	}
	
	/*
	* 
	* Function to add a welcome message to your application, it just prompt
	* a $message then goto form with ID=$next.
	* 
	* @param message			The welcome message
	* @param next				The next form ID after the welcome message
	*  
	*/
	
	function welcome($message="", $next="")
	{
		$this->vxml_start_form();
		
			$this->vxml_start_block();
			
				$this->vxml_prompt($message);
				
					$this->vxml_start_goto($next);
				
			$this->end_vxml_block();
			
		$this->end_vxml_form();
		
		return true;
	}

}

?>
