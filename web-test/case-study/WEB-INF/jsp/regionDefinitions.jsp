<%@ taglib uri='regions' prefix='region' %>

<region:define id='STOREFRONT_REGION' 
         template='/WEB-INF/jsp/templates/hscf.jsp'>
   <region:put section='title'
               content='FruitStand.com' 
                direct='true'/>

   <region:put section='background'
               content='graphics/blueAndWhiteBackground.gif'
                direct='true'/>

   <region:put section='header' 
               content='/WEB-INF/jsp/storefront/header.jsp'/>

   <region:put section='sidebar' 
               content='/WEB-INF/jsp/storefront/sidebar.jsp'/>

   <region:put section='content' 
               content='/WEB-INF/jsp/storefront/content.jsp'/>

   <region:put section='footer' 
               content='/WEB-INF/jsp/storefront/footer.jsp'/>
</region:define>

<region:define id='LOGIN_REGION' region='STOREFRONT_REGION'>
   <region:put section='header' 
               content='/WEB-INF/jsp/login/header.jsp'/>

   <region:put section='sidebar' 
               content='/WEB-INF/jsp/login/sidebar.jsp'/>

   <region:put section='content' 
               content='/WEB-INF/jsp/login/content.jsp'/>
</region:define>

<region:define id='HOMEPAGE_REGION' region='STOREFRONT_REGION'>
   <region:put section='sidebar' 
               content='/WEB-INF/jsp/homepage/sidebar.jsp'/>

   <region:put section='content' 
               content='/WEB-INF/jsp/homepage/content.jsp'/>
</region:define>

<region:define id='CREATE_ACCOUNT_REGION' region='LOGIN_REGION'>
   <region:put section='content' 
               content='/WEB-INF/jsp/createAccount/content.jsp'/>
   <region:put section='sidebar' 
               content='/WEB-INF/jsp/createAccount/sidebar.jsp'/>
</region:define>

<region:define id='LOGIN_FAILED_REGION' region='LOGIN_REGION'>
   <region:put section='content' 
               content='/WEB-INF/jsp/loginFailed/content.jsp'/>
</region:define>

<region:define id='ACCOUNT_CREATED_REGION' region='LOGIN_REGION'>
   <region:put section='content' 
               content='/WEB-INF/jsp/accountCreated/content.jsp'/>
</region:define>

<region:define id='CHECKOUT_REGION' region='LOGIN_REGION'>
   <region:put section='content' 
               content='/WEB-INF/jsp/checkout/content.jsp'/>
</region:define>

<region:define id='PURCHASE_REGION' region='LOGIN_REGION'>
   <region:put section='content' 
               content='/WEB-INF/jsp/purchase/content.jsp'/>
</region:define>

<region:define id='SHOW_HINT_REGION' region='LOGIN_REGION'>
   <region:put section='content' 
               content='/WEB-INF/jsp/showHint/content.jsp'/>
</region:define>
