package org.dianexus.triceps;

import java.util.ArrayList;
import java.util.Iterator;

import org.dianexus.triceps.modules.data.DialogixDAOFactory;
import org.dianexus.triceps.modules.data.UserDAO;
import org.dianexus.triceps.modules.data.UserPermissionDAO;

public class DialogixUser {
	
	private ArrayList roles ;
	private UserDAO userDAO ;
	private int userId;
	
	
	
	
	public boolean loginUser(String userName, String password){
		int DBID = 1;// TODO add declaratively
		boolean rtn = false;
		DialogixDAOFactory dataFactory = DialogixDAOFactory.getDAOFactory(DBID);
		this.userDAO = dataFactory.getUserDAO();
		if(this.userDAO.getUser(userName, password)){
			this.userId=userDAO.getId();
			rtn = true;;
		}
        
		return rtn;
		
	}
	public ArrayList getPermissions(){
		ArrayList roleList;
		int DBID = 1;// TODO add declaratively
		DialogixDAOFactory dataFactory = DialogixDAOFactory.getDAOFactory(DBID);
		UserPermissionDAO userPermissionDAO = dataFactory.getUserPermissionDAO();
		roleList = userPermissionDAO.getUserPermissions(userId);
		this.roles = roleList;
		return roleList;
	}
	public ArrayList getInstrumentPermissions(int instrumentId){
		ArrayList roleList;
		int DBID = 1;// TODO add declaratively
		DialogixDAOFactory dataFactory = DialogixDAOFactory.getDAOFactory(DBID);
		UserPermissionDAO userPermissionDAO = dataFactory.getUserPermissionDAO();
		roleList = userPermissionDAO.getUserPermissions(userId, instrumentId);
		this.roles = roleList;
		return roleList;
	}
	
	
	public boolean hasPermission(String permission){
		if(this.roles != null){
		Iterator it = this.roles.iterator();
		while(it.hasNext()){
			UserPermission up = (UserPermission)it.next();
			if(up.getRole().equals(permission)){
				return true;
			}
		}
		}
		return false;
	}
	public int getUserId(){
		return userDAO.getId();
	}
}
