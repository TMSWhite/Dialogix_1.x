<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='i18n' prefix='i18n' %>
<%@ taglib uri='xslt' prefix='xslt' %>

<font size='4' color='blue'>
   <i18n:message base='app' key='storefront.form.title'/>
</font><p>

<% out.flush(); %>

<xslt:apply xslt='/WEB-INF/jsp/storefront/inventory.xsl'>
   <%@ include file='inventory-to-xml.jsp' %>
</xslt:apply>
