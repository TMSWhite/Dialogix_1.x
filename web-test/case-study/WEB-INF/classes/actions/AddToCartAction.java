package actions;

import java.util.Enumeration;
import java.util.Iterator;
import java.util.StringTokenizer;

import javax.servlet.*;
import javax.servlet.http.*;

import beans.app.Item;
import beans.app.ShoppingCart;

import action.ActionBase;
import action.ActionRouter;

// sku stands for stock keeping unit, an accounting term for
// something that's in stock pending sale. This action's request
// has a parameter that looks like this: sku-fruit-price=amount; 
// for example, 1002-banana-0.69=0.75.

public class AddToCartAction extends ActionBase 
                             implements beans.app.Constants { 
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException {
      Enumeration      e = req.getParameterNames();
      String skuAndFruit = (String)e.nextElement();
      String      amount = req.getParameterValues(skuAndFruit)[0];
      ShoppingCart  cart = (ShoppingCart)req.getSession().
                                 getAttribute(SHOPPING_CART_KEY);
      if(cart == null) {
         throw new ServletException("No cart found");
      }

      StringTokenizer tok = new StringTokenizer(skuAndFruit, "-");
      String sku = (String)tok.nextElement(),
           fruit = (String)tok.nextElement(),
           price = (String)tok.nextElement();

      Iterator it = cart.getItems().iterator();
      boolean fruitWasInCart = false;

      while(it.hasNext()) {
         Item item = (Item)it.next();

         if(item.getName().equals(fruit)) {
            fruitWasInCart = true;
            item.setAmount(item.getAmount() + 
                           Float.parseFloat(amount));   
         }
      }
      if(!fruitWasInCart) {
         cart.addItem(new Item(Integer.parseInt(sku), fruit,
                               Float.parseFloat(price),
                               Float.parseFloat(amount)));
      }
      return new ActionRouter("storefront-page");
   }
}
