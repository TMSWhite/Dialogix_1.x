<% String thisPage = request.getServletPath();
   String updateLocaleAction = "update-locale-action.do?page=" +
                               thisPage + "&country="; %>
<table width='160'>
   <tr><td>
      <a href='<%= updateLocaleAction + "EN" %>'>
         <img src='graphics/flags/britain_flag.gif'/></a>

      <a href='<%= updateLocaleAction + "DE" %>'>
         <img src='graphics/flags/german_flag.gif'/></a>

      <a href='<%= updateLocaleAction + "ZH" %>'>
         <img src='graphics/flags/chinese_flag.gif'/></a></tr>
   </td><td height='25'></td>
</table>
