<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='i18n' prefix='i18n' %>

<font size='5' color='blue'>
   <i18n:message key='login.form.title'/>
</font><hr>

<jsp:include page='form.jsp' flush='true'/>
<jsp:include page='../shared/createAccountLink.jsp' flush='true'/>
