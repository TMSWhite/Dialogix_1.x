<html><head>
  <%@ taglib uri='regions' prefix='region' %>
  <title><region:render section='title'/></title>
</head>

<body background='<region:render section='background'/>'>

<table>
   <tr valign='top'>
      <td><region:render section='sidebar'/></td>
      <td>
         <table>
            <tr><td><region:render section='header'/></td></tr>
            <tr><td><region:render section='content'/></td></tr>
            <tr><td><region:render section='footer'/></td></tr>
         </table>
      </td>
   </tr> 
</table>

</body></html>
