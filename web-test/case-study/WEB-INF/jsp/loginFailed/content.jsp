<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='application' prefix='app'  %>
<%@ taglib uri='i18n' 		  prefix='i18n' %>
<%@ taglib uri='utilities'   prefix='util' %>

<font color='red' size='5'>
	<i18n:message base='app' key='login.failed.title'/>
</font>

<font color='red' size='4'><p>
	<%=(String)session.getAttribute(
				  tags.security.Constants.LOGIN_ERROR_KEY)%>
</font></p>

<jsp:include page='../login/form.jsp' flush='true'/>

<app:hintAvailable>
	<jsp:include page='../shared/showHintLink.jsp' 
	            flush='true'/>
</app:hintAvailable>

<app:hintNotAvailable>
	<jsp:include page='../shared/createAccountLink.jsp' 
  			      flush='true'/>
</app:hintNotAvailable>
