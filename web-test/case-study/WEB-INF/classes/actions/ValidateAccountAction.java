package actions;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import action.ActionBase;
import action.ActionRouter;

import beans.app.forms.CreateAccountForm;

public class ValidateAccountAction extends ActionBase 
                         implements beans.app.Constants { 
   public ActionRouter perform(HttpServlet servlet,
                               HttpServletRequest req, 
                               HttpServletResponse res)
                               throws ServletException {
      CreateAccountForm form = (CreateAccountForm)
                                req.getAttribute("form");
      if(form == null) {
         throw new ServletException("Can't find form");
      }

      String  errMsg;
      boolean errorDetected = false;

      if(!form.validate()) {
         errMsg = form.getValidationError();
         errorDetected = true;
         req.setAttribute("createAccount-form-error", errMsg);
      }
      return errorDetected ?
         new ActionRouter("query-account-page") :
         new ActionRouter("/new-account-action.do", true, false);
   }
}
