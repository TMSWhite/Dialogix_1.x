<%@ page contentType='text/html; charset=UTF-8' %>
<%@ page import='beans.app.User' %>

<%@ taglib uri='application' prefix='app'  %>
<%@ taglib uri='i18n'        prefix='i18n' %>

<font size='4' color='blue'>
   <i18n:message base='app' key='checkout.title'/>
</font><p>

<img src='graphics/cart.gif'/>

<table cellpadding='10'>
   <th><i18n:message base='app' 
                     key='checkout.table.header.item'/></th>
   <th><i18n:message base='app' 
                     key='checkout.table.header.amount'/></th>
   <th><i18n:message base='app' 
                     key='checkout.table.header.pricePerLb'/></th>
   <th><i18n:message base='app' 
                     key='checkout.table.header.price'/></th>

   <% double total = 0.0; %>

   <app:iterateCart id='item'>
      <% String  name = item.getName();
         float    amt = item.getAmount(), 
                price = item.getPrice();       
      %>
      <tr>
         <td><%= name %></td>
         <td><%= amt %> lbs.</td>
         <td><i18n:format currency='<%=new Double(price)%>'/></td>
         <td><i18n:format currency='<%=new Double(price*amt)%>'/>
         </td>
      </tr>
      <% total += price * amt; %>
   </app:iterateCart>

   <tr>
      <td colspan='4'><hr/></td>
   </tr>
      <td><b><i18n:message base='app' key='checkout.table.total'/>
      </b></td>
      <td></td><td></td>
      <td><i18n:format currency='<%= new Double(total) %>'/></td>
   </tr>
</table><p>

<% User user = (User)session.getAttribute(
               tags.security.Constants.USER_KEY); %>

<font size='4' color='blue'>
   <i18n:message base='app' key='checkout.billTo'/><p>
</font>
   <%= user.getFirstName() %> <%= user.getLastName() %><br/>
   <%= user.getAddress() %><br/>
   <%= user.getCity() %>, <%= user.getState() %><br/>
   <%= user.getCountry() %><br/>
   <%= user.getCreditCardType() %><br/>
</p>

<form action='purchase-action.do'>
   <input type='submit' 
         value='<i18n:message key="checkout.purchase.button"/>'/>
</form>
