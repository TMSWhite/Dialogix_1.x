<%@ taglib uri='security' prefix='security'%>
<%@ taglib uri='regions' prefix='region' %>

<security:enforceLogin 
   loginPage='/WEB-INF/jsp/login/page.jsp'
   errorPage='/WEB-INF/jsp/loginFailed/page.jsp'/>

<region:render region='CHECKOUT_REGION'/>
