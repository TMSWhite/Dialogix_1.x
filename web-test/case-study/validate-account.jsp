<jsp:useBean id='form' scope='request'
                       class='beans.app.forms.CreateAccountForm'/>

<jsp:setProperty name='form' property='*'/>

<jsp:forward page='/validate-account-action.do'/> 
