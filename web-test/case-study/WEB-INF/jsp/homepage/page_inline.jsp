<%@ taglib uri='regions' prefix='region' %>

<region:paint template='<%= "/WEB-INF/jsp/templates/header-" +
							       "sidebar-content-footer.jsp" %>'>
	<region:put section='title'
               content='FruitStand.com' 
                direct='true'/>

   <region:put section='background'
                 content='graphics/blueAndWhiteBackground.gif'
                  direct='true'/>

   <region:put section='header'
               content='/WEB-INF/jsp/storefront/header.jsp'/>

   <region:put section='sidebar' 
               content='/WEB-INF/jsp/homepage/sidebar.jsp'/>

   <region:put section='content' 
               content='/WEB-INF/jsp/homepage/content.jsp'/>

   <region:put section='footer' 
               content='/WEB-INF/jsp/storefront/footer.jsp'/>
</region:paint>
