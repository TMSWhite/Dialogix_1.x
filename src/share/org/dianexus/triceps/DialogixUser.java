package org.dianexus.triceps;

import java.util.ArrayList;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.UserDAO;

public class DialogixUser {
	
	private ArrayList roles = null;
	private UserDAO userDAO = null;
	
	
	
	public DialogixUser(String name, String pass){
		userDAO = getUser( name, pass);
		roles = getPermissions(userDAO.getId());
	}
	
	public UserDAO getUser(String userName, String password){
		int DBID = 1;// TODO add declaratively
		
		DialogixDAOFactory dataFactory = DialogixDAOFactory.getDAOFactory(DBID);
		UserDAO userDAO = dataFactory.getUserDAO();
		if(userDAO.getUser(userName, password)){
			
			return userDAO;
		}
        
		return null;
		
	}
	public ArrayList getPermissions(int userId){
		ArrayList roleList = new ArrayList();
		return roleList;
	}
	
	public boolean hasPermission(String permission){
		if(roles.contains(permission)){
			return true;
		}
		return false;
	}

}
