<%@ page contentType='text/html; charset=UTF-8' %>
<%@ taglib uri='i18n' prefix='i18n' %>

<hr><p>
<table>
   <tr>
      <td><img src='graphics/duke.gif'/></td>
      <td>
         <i18n:message key='login.footer.message'/><i>
         <i18n:format date='<%=new java.util.Date()%>'
                 dateStyle='<%=java.text.DateFormat.FULL%>'/></i>.
      </td>
   </tr>
</table>
</p>
