<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='i18n' prefix='i18n' %>
<%@ taglib uri='utilities' prefix='util' %>

<form action='<%= response.encodeURL("authenticate") %>' 
      method='post'>
   <table>
      <tr> 
         <td><i18n:message base='app' key='login.textfield.name'/>
         </td>
         <td><input type='text' name='userName'
            value='<util:sessionAttribute property=
                  "<%= beans.app.Constants.USERNAME_KEY %>"/>'/>
         </td> 
      </tr><tr> 
         <td><i18n:message base='app' key='login.textfield.pwd'/>
         </td>
         <td><input type='password' name='password' size='8'
            value='<util:sessionAttribute property=
                  "<%= beans.app.Constants.PASSWORD_KEY %>"/>'/>
         </td>
      </tr>
   </table>
   <br>
   <input type='submit' value=
         '<i18n:message key="login.button.submit"/>'/>
</form>
