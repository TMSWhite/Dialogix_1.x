<?xml version="1.0"?>
<!--/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ -->

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="triceps">
<xsl:processing-instruction name="cocoon-format">type="text/html"</xsl:processing-instruction>
	<html>
	<head>
		<title><xsl:value-of select="@title" /></title>
	 	<xsl:apply-templates select="script"/>
		</head>
		<body bgcolor='white'>
			<xsl:choose>
				<xsl:when test="script[@browser='NS']">
					<xsl:attribute name="onload">evHandler(event);init();document.myForm.<xsl:value-of select="@firstFocus"/>.focus();</xsl:attribute>
				</xsl:when>
			</xsl:choose>
		
		<form method='POST' name='myForm'>
			<xsl:attribute name="action">
				<xsl:value-of select="@target"/>
			</xsl:attribute>
		
		 <table border='1' cellpadding='1' cellspacing='3' width='100%'>
			 <tr>
				<td width='1%'>
					 <img name='icon' align='top' border='0' onMouseUp='evHandler(event);setAdminModePassword();'>
						<xsl:attribute name="src"><xsl:value-of select="admin/icon[@name='logo']"/></xsl:attribute>
						<xsl:attribute name="alt"><xsl:value-of select="admin/icon[@name='logo']/alt[@value]"/></xsl:attribute>
					</img>
				</td>
				<td align='left'>
					<font size='4'>
						<xsl:apply-templates select="header"/>
					</font>
				</td>
				<td width='1%'>
					<xsl:if test="admin/icon[@name='help']">
						 <img name='icon' align='top' border='0' onMouseUp='evHandler(event);help()'>
							<xsl:attribute name="src"><xsl:value-of select="admin/icon[@name='help']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="(admin/icon[@name='help'])/alt[@value]"/></xsl:attribute>
							<xsl:attribute name="onMouseUp">evHandler(event);help('_TOP_','<xsl:value-of select="@helpSrc"/>');</xsl:attribute>
						</img>			
					</xsl:if>
				</td>
			</tr>
		</table>

		<center>
		<xsl:apply-templates select="languages"/>
		</center>
		  <table cellpadding='1' cellspacing='0' width='100%' border='1'>
		  	<xsl:apply-templates select="nodes"/>
		  </table>
		
		  <table cellpadding='1' cellspacing='1' width='100%' border='1'>
			<xsl:apply-templates select="navigation"/>
			<xsl:apply-templates select="admin"/>
		  </table>
		</form>
   
	</body>
	</html>
</xsl:template>

<xsl:template match="header">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>

<xsl:template match="navigation">
	<tr>
		<td align="center">
			<xsl:apply-templates select="act"/>
		</td>
	</tr>
</xsl:template>

<xsl:template match="admin">
	<tr>
		<td align="center">
			<xsl:apply-templates select="act"/>
		</td>
	</tr>
</xsl:template>

<xsl:template match="nodes">
	<table border='1' cellpadding='1' cellspacing='0' width='100%'>
		<xsl:apply-templates select="node"/>
	</table>
</xsl:template>

<xsl:template match="node">
	<tr>
		<xsl:if test="../node[not(@extName='')]">
			<!-- then at least one labelled question -->
			<td width="1%">
				<xsl:choose>
					<xsl:when test="@extName=''">&#160;</xsl:when>
					<xsl:otherwise><xsl:value-of select="@extName"/></xsl:otherwise>
				</xsl:choose>
			</td>			
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="listen/mono[@type='nothing']">
				<td colspan='2'>
					<xsl:apply-templates select="ask"/>
				</td>
			</xsl:when>
			<xsl:when test="listen/multi[@type='radio2']">
				<td colspan='2'>
 					  <table border='1' cellpadding='1' cellspacing='1'>
						<tr>
							<td>
								<xsl:attribute name="colspan"><xsl:value-of select="count(listen/multi/ac)"/></xsl:attribute>
								<font>
									<xsl:if test="not(@err='')"><xsl:attribute name="color">red</xsl:attribute></xsl:if>
									<xsl:apply-templates select="ask"/>
								</font>
							</td>		
						</tr>
						<tr>
							<xsl:apply-templates select="listen"/>
						</tr>
						<xsl:if test="not(@err='')">
							<tr>
								<td>
									<xsl:attribute name="colspan"><xsl:value-of select="count(listen/multi/ac)"/></xsl:attribute>
									<font color="red">
										<xsl:value-of select="@err"/>						
									</font>
								</td>
							</tr>
						</xsl:if>								
						
					</table>
				</td>
			</xsl:when>			
			<xsl:otherwise>
				<td>
					<font>
						<xsl:if test="not(@err='')"><xsl:attribute name="color">red</xsl:attribute></xsl:if>
						<xsl:apply-templates select="ask"/>
					</font>
				</td>
				<td>
					<xsl:apply-templates select="listen"/>
					<xsl:if test="not(@err='')">
						<font color="red">
							<xsl:value-of select="@err"/>						
						</font>
					</xsl:if>
				</td>
			</xsl:otherwise>
		</xsl:choose>
		
		<td width="1%" nowrap='nowrap'>
			<xsl:apply-templates select="action"/>
			
			<input type="hidden">
				<xsl:attribute name="name"><xsl:value-of select="@name"/>_COMMENT</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@comment"/></xsl:attribute>
			</input>
			<input type="hidden">
				<xsl:attribute name="name"><xsl:value-of select="@name"/>_SPECIAL</xsl:attribute>
				<xsl:attribute name="value">
					<xsl:choose>
						<xsl:when test="@refused='1'">*REFUSED*</xsl:when>
						<xsl:when test="@unknown='1'">*UNKNOWN*</xsl:when>
						<xsl:when test="@huh='1'">*HUH*</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</input>
			<input type="hidden">
				<xsl:attribute name="name"><xsl:value-of select="@name"/>_HELP</xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@help"/></xsl:attribute>
			</input>
	
			<xsl:if test="@help!=''">
				 <img align='top' border='0'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/>_HELP_ICON</xsl:attribute>
					<xsl:attribute name="onMouseUp">evHandler(event);help('_TOP_','<xsl:value-of select="@help"/>');</xsl:attribute>
					<xsl:attribute name="src"><xsl:value-of select="/triceps/admin/icon[@name='help']"/></xsl:attribute>
					<xsl:attribute name="alt"><xsl:value-of select="(/triceps/admin/icon[@name='help'])/alt[@value]"/></xsl:attribute>
				</img>			
			</xsl:if>			
			
			<xsl:if test="../@allowComment='1'">
				<img align='top' border='0'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/>_COMMENT_ICON</xsl:attribute>
					<xsl:attribute name="onMouseUp">evHandler(event);comment('<xsl:value-of select="@name"/>');</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@comment=''">
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='comment_off']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="(/triceps/icons/icon[@name='comment_off'])/alt[@value]"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='comment_on']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="(/triceps/icons/icon[@name='comment_on'])/alt[@value]"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</img>
			</xsl:if>	
			
			<xsl:if test="../@allowRefused='1'">
				<img align='top' border='0'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/>_REFUSED_ICON</xsl:attribute>
					<xsl:attribute name="onMouseUp">evHandler(event);markAsRefused('<xsl:value-of select="@name"/>');</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@refused='0'">
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='refused_off']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="/triceps/icons/icon[@name='refused_off']/alt[@value]"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='refused_on']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="/triceps/icons/icon[@name='refused_on']/alt[@value]"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</img>
			</xsl:if>	
			
			<xsl:if test="../@allowUnknown='1'">
				<img align='top' border='0'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/>_UNKNOWN_ICON</xsl:attribute>
					<xsl:attribute name="onMouseUp">evHandler(event);markAsUnknown('<xsl:value-of select="@name"/>');</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@unknown='0'">
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='unknown_off']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="/triceps/icons/icon[@name='unknown_off']/alt[@value]"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='unknown_on']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="/triceps/icons/icon[@name='unknown_on']/alt[@value]"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</img>
			</xsl:if>	
			
			<xsl:if test="../@allowHuh='1'">
				<img align='top' border='0'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/>_NOT_UNDERSTOOD_ICON</xsl:attribute>
					<xsl:attribute name="onMouseUp">evHandler(event);markAsNotUnderstood('<xsl:value-of select="@name"/>');</xsl:attribute>
					<xsl:choose>
						<xsl:when test="@huh='0'">
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='not_understood_off']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="/triceps/icons/icon[@name='not_understood_off']/alt[@value]"/></xsl:attribute>
						</xsl:when>
						<xsl:otherwise>
							<xsl:attribute name="src"><xsl:value-of select="/triceps/icons/icon[@name='not_understood_on']"/></xsl:attribute>
							<xsl:attribute name="alt"><xsl:value-of select="/triceps/icons/icon[@name='not_understood_on']/alt[@value]"/></xsl:attribute>
						</xsl:otherwise>
					</xsl:choose>
				</img>
			</xsl:if>							
		</td>
	</tr>
</xsl:template>

<xsl:template match="action[@type='img']">
	<img border='0' >
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/>_<xsl:value-of select="@why"/>_ICON</xsl:attribute>
		<xsl:attribute name="src"><xsl:value-of select="@url"/></xsl:attribute>
		<xsl:attribute name="alt"><xsl:value-of select="@name"/></xsl:attribute>
	</img>
</xsl:template>

<xsl:template match="action[@type='submit']">
	<input type="submit">
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/>_<xsl:value-of select="@why"/>_SUBMIT</xsl:attribute>
	</input>
</xsl:template>

<xsl:template match="listen">
	<xsl:apply-templates select="mono | multi"/>
</xsl:template>
 
<xsl:template match="mono[@type='password']">
	<input type="password">
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
	</input>
</xsl:template>

<xsl:template match="mono[@type='memo']">
	<textarea rows="5" cols="40">
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
	</textarea>		
</xsl:template>

<xsl:template match="mono[@type='nothing']">
	&#160;
</xsl:template>

<!-- all other mono -->
<xsl:template match="mono">
	<input type="text">
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
	</input>
</xsl:template>

<xsl:template match="multi[@type='radio']">
	<xsl:for-each select="ac">
		<input type="radio">
			<xsl:attribute name="name"><xsl:value-of select="../../../@name"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
			<xsl:if test="@on='1'">
						<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="."/>
			<br/>
		</input>
	</xsl:for-each>
</xsl:template>

<xsl:template match="multi[@type='radio2']">
	<xsl:for-each select="ac">
		<td valign='top'>
			<input type="radio">
				<xsl:attribute name="name"><xsl:value-of select="../../../@name"/></xsl:attribute>
				<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
				<xsl:if test="@on='1'">
							<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>
			</input>
		</td>
	</xsl:for-each>
</xsl:template>

<xsl:template match="multi[@type='check']">
	<xsl:for-each select="ac">
		<input type="check">
			<xsl:attribute name="name"><xsl:value-of select="../../@name"/></xsl:attribute>
			<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
			<xsl:if test="@on='1'"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
			<xsl:value-of select="."/>
		</input>
	</xsl:for-each>
</xsl:template>

<xsl:template match="multi[@type='combo']">
	<select>
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/></xsl:attribute>

		<xsl:for-each select="ac">
			<option>
				<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
				<xsl:if test="@on='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="@key=' '">&#160;&#160;&#160;</xsl:when>
					<xsl:when test="@key=''"></xsl:when>
					<xsl:otherwise><xsl:value-of select="@key"/>) </xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</select>
</xsl:template>

<xsl:template match="multi[@type='list']">
	<select>
		<xsl:attribute name="name"><xsl:value-of select="../../@name"/></xsl:attribute>
		<xsl:attribute name="size"><xsl:value-of select="count(ac)"/>"</xsl:attribute>
		<xsl:for-each select="ac">
			<option>
				<xsl:attribute name="value"><xsl:value-of select="@val"/></xsl:attribute>
				<xsl:if test="@on='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
				<xsl:choose>
					<xsl:when test="@key=' '">&#160;&#160;&#160;</xsl:when>
					<xsl:when test="@key=''"></xsl:when>
					<xsl:otherwise><xsl:value-of select="@key"/>) </xsl:otherwise>
				</xsl:choose>
				<xsl:value-of select="."/>
			</option>
		</xsl:for-each>
	</select>
</xsl:template>

<xsl:template match="script[@browser='NS']">
	<script  type="text/javascript">
	<![CDATA[
	<!--
	]]>
	var val = null;
	var name = null;
	var msg = null;
	var startTime = new Date();
	var el = null;
	var evH = null;
	var ans = null;
	function keyHandler(e) {
	        now = new Date();
	        val = String.fromCharCode(e.which) + ',';
	        name = e.target.name;
	        msg = name + ',' + e.target.type + ',' + e.type + ',' + now.getTime() + ',' + (now.getTime() - startTime.getTime()) + ',' + val + '     ';
	        document.myForm.EVENT_TIMINGS.value += msg;
	        return true;
	}
	function submitHandler(e) {
	        now = new Date();
	        val = ',';
	        msg = e.target.name + ',' + e.target.type + ',' + e.type + ',' + now.getTime() + ',' + (now.getTime() - startTime.getTime()) + ',' + val + '    ';
	        document.myForm.EVENT_TIMINGS.value += msg;
	        name = document.myForm.elements['DIRECTIVE_' + e.target.name].value;
	        if (e.type == 'focus') { e.target.value='««' + name + '»»'; }
	        else if (e.type == 'blur') { e.target.value='    ' + name + '    '; }
	        document.myForm.elements['DIRECTIVE'].value = e.target.name;
	        return true;
	}
	function selectHandler(e) {
	        now = new Date();
	        val = e.target.options[e.target.selectedIndex].value + ',' + e.target.options[e.target.selectedIndex].text;
	        name = e.target.name;
	        msg = name + ',' + e.target.type + ',' + e.type + ',' + now.getTime() + ',' + (now.getTime() - startTime.getTime()) + ',' + val + '     ';
	        document.myForm.EVENT_TIMINGS.value += msg;
	        return true;
	}
	function evHandler(e) {
	        now = new Date();
	        val = ',' + e.target.value;
	        name = e.target.name;
	        msg = name + ',' + e.target.type + ',' + e.type + ',' + now.getTime() + ',' + (now.getTime() - startTime.getTime()) + ',' + val + '     ';
	        document.myForm.EVENT_TIMINGS.value += msg;
		if (e.target.type == 'text' || e.target.type == 'textarea') {  e.target.select(); }
	        return true;
	}
	window.captureEvents(Event.Load);
	window.onLoad = evHandler;
	function init() {
		<![CDATA[
	        for (var i=0;i<document.myForm.elements.length;++i) {
		]]>
	                el = document.myForm.elements[i];
	                evH = evHandler;
	                if (el.type == 'select-multiple' || el.type == 'select-one') { evH = selectHandler; } else 
	                if (el.type == 'submit') { evH = submitHandler; }
	                el.onBlur = evH;
	                el.onClick = evH;
	                el.onFocus = evH;
	                el.onChange = evH;
	                el.onKeyPress = keyHandler;
	        }
		<![CDATA[	
	        for (var k=0;k<document.images.length;++k){
		]]>
	                el = document.images[k];
	                el.onMouseUp = evHandler;
	        }
	}
	function setAdminModePassword(name) {
	        ans = prompt('Enter password to enter Administrative Mode  ','');
	        if (ans == null || ans == '') return;
	        document.myForm.PASSWORD_FOR_ADMIN_MODE.value = ans;
	        document.myForm.submit();
	
	}
	function markAsRefused(name) {
	        if (!name) return;
	        val = document.myForm.elements[name + '_SPECIAL'];
	        if (val.value == '*REFUSED*') {
	                val.value = '';
	                document.myForm.elements[name + '_REFUSED_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='refused_off']"/>';
	        } else {
	                val.value = '*REFUSED*';
	                document.myForm.elements[name + '_REFUSED_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='refused_on']"/>';
			<xsl:if test="/triceps/nodes[@allowUnknown='1']">
	                document.myForm.elements[name + '_UNKNOWN_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='unknown_off']"/>';
			</xsl:if>
			<xsl:if test="/triceps/nodes[@allowHuh='1']">
	                document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='not_understood_off']"/>';
			</xsl:if>

	        }
	}
	function markAsUnknown(name) {
	        if (!name) return;
	        val = document.myForm.elements[name + '_SPECIAL'];
	        if (val.value == '*UNKNOWN*') {
	                val.value = '';
	                document.myForm.elements[name + '_UNKNOWN_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='unknown_off']"/>';
	        } else {
	                val.value = '*UNKNOWN*';
	                document.myForm.elements[name + '_UNKNOWN_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='unknown_on']"/>';
			<xsl:if test="/triceps/nodes[@allowRefused='1']">
				document.myForm.elements[name + '_REFUSED_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='refused_off']"/>';
			</xsl:if>
			<xsl:if test="/triceps/nodes[@allowHuh='1']">
	                document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='not_understood_off']"/>';
			</xsl:if>	        }
	}
	function markAsNotUnderstood(name) {
	        if (!name) return;
	        val = document.myForm.elements[name + '_SPECIAL'];
	        if (val.value == '*HUH*') {
	                val.value = '';
	                document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src =  '<xsl:value-of select="/triceps/icons/icon[@name='not_understood_off']"/>';
	        } else {
	                val.value = '*HUH*';
	                document.myForm.elements[name + '_NOT_UNDERSTOOD_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='not_understood_on']"/>';
			<xsl:if test="/triceps/nodes[@allowRefused='1']">
				document.myForm.elements[name + '_REFUSED_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='refused_off']"/>';
			</xsl:if>
			<xsl:if test="/triceps/nodes[@allowUnknown='1']">
	                document.myForm.elements[name + '_UNKNOWN_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='unknown_off']"/>';
			</xsl:if>	        }
	}
	function help(name,target) {
	        if (target != null 
			<![CDATA[
				&& 
			]]>
		target.length != 0) { window.open(target,'__HELP__'); }
	}
	function comment(name) {
	        if (!name) return;
	        ans = prompt('Enter a comment for this question  ',document.myForm.elements[name + '_COMMENT'].value);
	        if (ans == null) return;
	        document.myForm.elements[name + '_COMMENT'].value = ans;
	        if (ans != null 
				<![CDATA[
				&& 
			]]>
			ans.length > 0) {
	                document.myForm.elements[name + '_COMMENT_ICON'].src = '<xsl:value-of select="/triceps/icons/icon[@name='comment_on']"/>';
	        } else { document.myForm.elements[name + '_COMMENT_ICON'].src =  '<xsl:value-of select="/triceps/icons/icon[@name='comment_off']"/>'; }
	}
	function setLanguage(lang) {
	        document.myForm.LANGUAGE.value = lang;
	        document.myForm.submit();
	}
	<![CDATA[
	// -->
	]]>
	</script>
</xsl:template>

<xsl:template match="languages">
	<xsl:apply-templates select="language"/>
</xsl:template>

<xsl:template match="language">
	<xsl:choose>
		<xsl:when test="@on=1">
			<u>
				<input type='button'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
					<xsl:attribute name="onClick">evHandler(event);setLanguage('<xsl:value-of select="@value"/>');</xsl:attribute>
				</input>			
			</u>
		</xsl:when>
		<xsl:otherwise>
				<input type='button'>
					<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
					<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
					<xsl:attribute name="onClick">evHandler(event);setLanguage('<xsl:value-of select="@value"/>');</xsl:attribute>
				</input>
		</xsl:otherwise>
	</xsl:choose>
	&#160;
</xsl:template>

<xsl:template match="act[@type='hidden']">
	<input type='hidden'>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@value"/></xsl:attribute>
	</input>
</xsl:template>

<xsl:template match="act[@type='button']">
	<input type='submit'>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
		<xsl:attribute name="value">&#160;&#160;<xsl:value-of select="@value"/>&#160;&#160;</xsl:attribute>
	</input>
	<input type='hidden'>
		<xsl:attribute name="name">DIRECTIVE_<xsl:value-of select="@name"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@name"/></xsl:attribute>
	</input>	
	&#160;
</xsl:template>

<xsl:template match="act[@type='textGo']">
	<input type='submit'>
		<xsl:attribute name="name"><xsl:value-of select="@name"/></xsl:attribute>
		<xsl:attribute name="value">&#160;&#160;<xsl:value-of select="@value"/>&#160;&#160;</xsl:attribute>
	</input>
	<input type='hidden'>
		<xsl:attribute name="name">DIRECTIVE_<xsl:value-of select="@name"/></xsl:attribute>
		<xsl:attribute name="value"><xsl:value-of select="@name"/></xsl:attribute>
	</input>	
	<input type="text" size="20">
		<xsl:attribute name="name"><xsl:value-of select="@name"/>_data</xsl:attribute>
	</input>	
</xsl:template>

<xsl:template match="ask">
	<xsl:apply-templates select="@*|node()"/>
</xsl:template>

<!-- identity transform -->
<xsl:template match="@*|node()">
	<xsl:copy>
		<xsl:apply-templates select="@*|node()"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
