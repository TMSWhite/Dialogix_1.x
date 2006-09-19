package org.dianexus.triceps.modules.view;

import org.dianexus.triceps.modules.data.DialogixMysqlDAOFactory;

public class ViewFactory {
	
	private static final int JSP_VIEW = 1;
	private static final int JSF_VIEW = 2;
	private static final int XFORMS_VIEW = 3;
	private static final int VOICEXML_VIEW =4;
	private static final int VELOCITY_VIEW = 5;
	private static final int WEBSERVICE_VIEW = 6;
	
	public View getView(int view_type){
		
		switch(view_type){
        
        case JSP_VIEW:
            return new JspView();
            
        case JSF_VIEW:
            return null;
            	
        case XFORMS_VIEW:
            return null;
            
        case VOICEXML_VIEW:
            return null;
            
        case VELOCITY_VIEW:
            return null;
            
        case WEBSERVICE_VIEW:
            return null;
            
        default:
            return null;
                  
                    
    }
	
	}

}
