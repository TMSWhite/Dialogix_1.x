<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='i18n' prefix='i18n' %>
<%@ taglib uri='dom'  prefix='dom'  %>
<%@ taglib uri='html' prefix='html' %>

<font size='4' color='blue'>
   <i18n:message base='app' key='storefront.form.title'/>
</font><p>

<dom:parse id='inventory' scope='application'>
   <%@ include file='inventory-to-xml.jsp' %>
</dom:parse>

<table border='1' cellPadding='3'>

<th><i18n:message base='app' 
                   key='storefront.table.header.picture'/></th>
<th><i18n:message base='app' 
                   key='storefront.table.header.item'/></th>
<th><i18n:message base='app' 
                  key='storefront.table.header.description'/></th>
<th><i18n:message base='app' 
                   key='storefront.table.header.price'/></th>
<th><i18n:message base='app' 
                   key='storefront.table.header.addToCart'/></th>

<% String currentItem = null, currentSku = null; %>

<dom:iterate node='<%=inventory.getDocumentElement()%>' id='item'>
   <dom:iterate node='<%= item %>' id='itemField'>

      <dom:ifNodeNameEquals node='<%= itemField %>' names='SKU'>
         <dom:elementValue id='name' element='<%= itemField %>'/>
         <% currentSku = name; %>
         <tr><td>
            <img src=
               '<%= "graphics/fruit/" + name.trim() + ".jpg" %>'/>
         </td>
      </dom:ifNodeNameEquals>

      <dom:ifNodeNameEquals node='<%= itemField %>' names='NAME'>
         <dom:elementValue id='name' element='<%= itemField %>'/>
         <% currentItem = name; %>
            <td><%= name %></td>
            <td>
					<i18n:message key='<%=name + ".description"%>'/>
				</td>
      </dom:ifNodeNameEquals>

      <dom:ifNodeNameEquals node='<%= itemField %>' names='PRICE'>
         <dom:elementValue id='price' element='<%= itemField %>'/>
         <td>$&nbsp;<%= price %>&nbsp;/lb.</td>
         <td>
            <form action='add-selection-to-cart-action.do'>
            <html:links name='<%= currentSku + "-" + 
                                  currentItem + "-" + price %>'>
               <option value='0.00'>0.00</option>
               <option value='1.00'>1.00</option>
               <option value='1.50'>1.50</option>
               <option value='2.00'>2.00</option>
               <option value='2.50'>2.50</option>
               <option value='3.00'>3.00</option>
               <option value='3.50'>3.50</option>
               <option value='4.00'>4.00</option>
               <option value='4.50'>4.50</option>
               <option value='5.00'>5.00</option>
               <option value='5.50'>5.50</option>
            </html:links>
            </form>
         </td>
      </dom:ifNodeNameEquals> 
   </dom:iterate>
</dom:iterate>

</table>
