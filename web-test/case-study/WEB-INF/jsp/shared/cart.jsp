<%@ taglib uri='application' prefix='app' %>

<img src='graphics/cart.gif'/>

<table cellpadding='3'>
   <app:iterateCart id='cartItem'>
      <tr>
         <td><%= cartItem.getName()   %></td>
         <td><%= cartItem.getAmount() %></td>
      </tr>
   </app:iterateCart>
</table>

<form action='checkout-action.do'>
   <input type='submit'value='checkout'/>
</form>
