<%@ page contentType='text/html; charset=UTF-8' %>

<%@ taglib uri='database'    prefix='database' %>
<%@ taglib uri='html'        prefix='html'     %>
<%@ taglib uri='i18n'        prefix='i18n'     %>
<%@ taglib uri='logic'       prefix='logic'    %>

<font size='4' color='blue'>
   <i18n:message key='storefront.form.title'/>
</font><p>

<database:query id='inventory' scope='session'>
   SELECT * FROM Inventory
</database:query>

<% String currentItem = null, currentSku = null; %>

<table border='1' cellpadding='5'>
   <tr><th><i18n:message key='storefront.table.header.picture'/>
      </th>

      <database:columnNames query='inventory' id='name'>
         <logic:stringsNotEqual compare='SKU' to='<%= name %>'>
            <% String hdrKey = "storefront.table.header." + 
                                name.toLowerCase(); %>

            <th><i18n:message key='<%= hdrKey %>'/></th>

            <logic:stringsEqual compare='NAME' to='<%= name %>'>
               <th><i18n:message 
                       key='storefront.table.header.description'/>
               </th>
            </logic:stringsEqual>
         </logic:stringsNotEqual>
      </database:columnNames>

      <th><i18n:message key='storefront.table.header.addToCart'/>
      </th>
   </tr>

   <tr>
   <database:rows query='inventory'>
      <database:columns query='inventory' columnName='name' 
                                         columnValue='value'> 
         <logic:stringsEqual compare='SKU' to='<%= name %>'>
            <% currentSku = value; %>
            <td><img src='<%= "graphics/fruit/" + currentSku + 
                              ".jpg" %>'/></td> 
         </logic:stringsEqual>
         
         <logic:stringsEqual compare='NAME' to='<%= name %>'>
            <% currentItem = value; %>
            <td><%= value %></td>
            <td><i18n:message key='<%=value + ".description"%>'/>
            </td> 
         </logic:stringsEqual>

         <logic:stringsEqual compare='PRICE' to='<%= name %>'>
            <td><%= value %></td>
            <td>
               <form action='add-selection-to-cart-action.do'>
                  <html:links name='<%= currentSku  + "-" + 
                                        currentItem + "-" + 
                                        value %>'>
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
            </tr><tr>
         </logic:stringsEqual>

      </database:columns>
   </database:rows>
</table>
</p>

<database:release query='inventory'/>
