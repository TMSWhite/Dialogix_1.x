<%@ taglib uri='database' prefix='database' %>

<database:query id='inventory' scope='session'>
   SELECT * FROM Inventory
</database:query>

<?xml version="1.0" encoding="ISO-8859-1"?>
<FRUITS>
   <database:rows query='inventory'>
      <ITEM>
      <database:columns query='inventory' columnName='name' 
                                         columnValue='value'> 
         <%= "<" + name + ">" %>
            <%= value %>
         <%= "</" + name + ">" %>
      </database:columns>
      </ITEM>
   </database:rows>
</FRUITS>

<database:release query='inventory'/>
