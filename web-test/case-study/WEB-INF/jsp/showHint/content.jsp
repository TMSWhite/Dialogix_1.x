<%@ page contentType='text/html; charset=UTF-8' %>
<%@ page import='beans.app.Users' %>

<%@ taglib uri='application' prefix='app'  %>
<%@ taglib uri='i18n'        prefix='i18n' %>
<%@ taglib uri='utilities'   prefix='util' %>

<%-- how about an application custom tag for this scriplet? --%>

<% String username = (String)session.getAttribute(
							 beans.app.Constants.USERNAME_KEY);

   Users users = (Users)application.getAttribute(
							 beans.app.Constants.USERS_KEY); 

	String hint = users.getPasswordHint(username);
%>

<i18n:message base='app' key='password.hint.for'/>
<b><%= username %></b> 
<i18n:message base='app' key='password.hint.is'/>
<i><%= hint %></i>

<p><font size='5' color='blue'>Please Login</font></p><hr>

<form action='<%= response.encodeURL("authenticate") %>'
      method='post'>
   <table>
      <tr> 
         <td>Name:</td> 
         <td><input type='text' name='userName'
			   value='<util:sessionAttribute property =
					   "<%= beans.app.Constants.USERNAME_KEY %>"/>'/>
         </td> 
      </tr><tr> 
         <td>Password:</td> 
         <td><input type='password' name='password' size='8'
			   value='<util:sessionAttribute property =
					   "<%= beans.app.Constants.PASSWORD_KEY %>"/>'/>
			</td>
      </tr>
   </table>
   <br>
   <input type='submit' value='login'> 
</form>

<jsp:include page='/WEB-INF/jsp/shared/createAccountLink.jsp'
			   flush='true' />
