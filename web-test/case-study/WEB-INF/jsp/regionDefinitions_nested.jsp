<%@ taglib uri='regions' prefix='region' %>

<%-- Flag page --%>

<region:define id='FLAGPAGE' scope='application'
         template='/WEB-INF/jsp/templates/hscf.jsp'>
   <region:put section='content' 
               content='/WEB-INF/jsp/shared/flags.jsp'/>
</region:define>

<%-- Homepage --%>

<region:define id='HOMEPAGE' scope='application'
         template='/WEB-INF/jsp/templates/hscf.jsp'>
   <region:put section='title'
               content='FruitStand.com' 
                direct='true'/>

   <region:put section='background'
               content='graphics/blueAndWhiteBackground.gif'
                direct='true'/>

   <region:put section='header'
               content='FLAGPAGE'/>

   <region:put section='sidebar' 
               content='/WEB-INF/jsp/homepage/sidebar.jsp'/>

   <region:put section='content' 
               content='/WEB-INF/jsp/homepage/content.jsp'/>

   <region:put section='footer' 
               content='FLAGPAGE'/>
</region:define>

