<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='application' prefix='app'  %>
<%@ taglib uri='i18n'        prefix='i18n' %>
<%@ taglib uri='i18n'        prefix='i18n' %>

<font size='4' color='blue'>
   <i18n:message base='app' key='purchase.title'/><p>
   <i18n:message base='app' key='purchase.willBeShippedOn'/>
   <i18n:format date='<%= new java.util.Date() %>'
           dateStyle='<%= java.text.DateFormat.SHORT %>'/></p>
</font>
