package actions;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import beans.app.ShoppingCart;

import action.ActionBase;
import action.ActionRouter;

import beans.app.Item;

public class GoShoppingAction extends ActionBase 
                         implements beans.app.Constants { 
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException {
      HttpSession session = req.getSession();
      ShoppingCart   cart = (ShoppingCart)session.getAttribute(
                                               SHOPPING_CART_KEY);
      if(cart == null) {
         cart = new ShoppingCart();

         synchronized(this) {
            session.setAttribute(SHOPPING_CART_KEY, cart);
         }
      }
      return new ActionRouter("storefront-page");
   }
}
