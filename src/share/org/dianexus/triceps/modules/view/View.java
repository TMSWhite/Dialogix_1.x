package org.dianexus.triceps.modules.view;

import java.util.ArrayList;

public interface View {
	
	public void setTemplate(String template);
	public String getTemplate();
	public void setParameter(Object parameter);
	public void getParameter();
	public ArrayList getParameterNames();

}
