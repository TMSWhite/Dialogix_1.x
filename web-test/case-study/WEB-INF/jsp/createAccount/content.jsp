<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='application' prefix='app'    %>
<%@ taglib uri='i18n'        prefix='i18n'   %>
<%@ taglib uri='tokens'      prefix='tokens' %>
<%@ taglib uri='utilities'   prefix='util'   %>

<jsp:useBean id='form' scope='request'
                       class='beans.app.forms.CreateAccountForm'/>

<font size='5' color='blue'><u>
   <i18n:message key='createAccount.header.title'/></u>
</font><p>

<% String error = (String)request.getAttribute(
                                  "createAccount-form-error");
   if(error != null) { %>
      <font size='5' color='red'>
         <i18n:message key='createAccount.error.fix'/>
      </font><font size='4' color='red'>
      <%= error %></p></font>
<%    request.removeAttribute("createAccount-form-error");
   } %>

<form action='validate-account.jsp' method='post' >
   <table width='450'><tr> 
      <td colspan='2'><font size='4' color='blue'>
         <i18n:message key='createAccount.header.personal'/>
      </font></td></tr><tr height='10'></tr>

      <tr><td>
         <i18n:message key='createAccount.field.firstName'/></td> 
      <td><input type='text' name='firstName'
                value='<%= form.getFirstName() %>'/>
      </td></tr>

      <tr><td>
         <i18n:message key='createAccount.field.lastName'/></td> 
      <td><input type='text' name='lastName'
                value='<%= form.getLastName() %>'/>
      </td></tr>

      <tr><td>
         <i18n:message key='createAccount.field.address'/></td> 
      <td><input type='text' name='address' size='39'
                value='<%= form.getAddress() %>'/>
      </td></tr>

      <tr><td> 
         <i18n:message key='createAccount.field.city'/></td> 
      <td><input type='text' name='city'
                value='<%= form.getCity() %>'/>
      </td></tr>

      <tr><td> 
         <i18n:message key='createAccount.field.state'/></td> 
      <td><input type='text' name='state'
                value='<%= form.getState() %>'/>
      </td></tr>

      <tr><td>
         <i18n:message key='createAccount.field.country'/></td> 
         <td><select name='country'>

         <i18n:bean id='germany' 
                   key='createAccount.option.germany'/>

          <option <%=form.getCountrySelectionAttr(germany)%>/>
            <%= germany %>

         <i18n:bean id='uk' 
                   key='createAccount.option.unitedKingdom'/>

          <option <%=form.getCountrySelectionAttr(uk)%>/>
            <%= uk %>
            
         <i18n:bean id='china' key='createAccount.option.china'/>

          <option <%=form.getCountrySelectionAttr(china)%>/>
            <%= china %>

      </select></td></tr>

      <tr><td> 
         <i18n:message key='createAccount.field.phone'/></td> 
         <td><input type='text' name='phone'
                  value='<%= form.getState() %>'/></td>
      </tr><tr height='20'></tr>

      <tr><td colspan='2'><font size='4' color='blue'>
         <i18n:message key='createAccount.header.credit'/></td> 
      </font></td></tr><tr height='10'></tr>

      <tr><td>
         <i18n:message 
                   key='createAccount.field.creditCardType'/></td>
         <td><select name='creditCardType'>
            <option <%= form.getCreditCardTypeSelectionAttr(
                        "Discover")%>>
               Discovery
            <option <%= form.getCreditCardTypeSelectionAttr(
                        "Master Card")%>>
               Master Card
            <option <%= form.getCreditCardTypeSelectionAttr(
                        "Visa")%>>
               Visa
         </select></td></tr>

      <tr><td>
         <i18n:message 
                 key='createAccount.field.creditCardNumber'/></td>
         <td><input type='text' name='creditCardNumber'
                   value='<%= form.getCreditCardNumber() %>'/>
         </td>
      </tr></tr>
      
      <tr><td> 
         <i18n:message 
             key='createAccount.field.creditCardExpiration'/></td>
         <td><input type='text' name='creditCardExpiration'
                   value='<%= form.getCreditCardExpiration() %>'/>
         </td>
      </tr><tr height='20'></tr>

      <tr><td colspan='2'><font size='4' color='blue'>
         <i18n:message 
                     key='createAccount.header.unameAndPwd'/></td>
      </font></td></tr><tr height='10'></tr>

      <tr><td> 
         <i18n:message 
             key='createAccount.field.username'/></td>
         <td><input type='text' name='userName'
                  value='<%= form.getUserName() %>'/></td>
         </td></tr>
         
         <tr><td> 
            <i18n:message 
                         key='createAccount.field.password'/></td>
         <td><input type='password' name='password' size='8'
                  value='<%= form.getPassword() %>'/></td>
         </td></tr>
         
         <tr><td>
            <i18n:message 
                       key='createAccount.field.pwdConfirm'/></td>
         <td><input type='password' name='pwdConfirm' size='8' 
                  value='<%= form.getPwdConfirm() %>'/></td>
         
         <tr><td>
            <i18n:message key='createAccount.field.pwdHint'/></td>
         <td><input type='text' name='pwdHint'
                  value='<%= form.getPwdHint() %>'/></td>
         </td>
      </tr>
   </table>
   <br>
   <input type='submit' value='create account'>
	<tokens:token/>
</form>
