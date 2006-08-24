package org.dianexus.triceps.modules.data;

public interface UserDAO {
	
	boolean getUser(int id);
	boolean getUser(String userName, String password);
	boolean updateUser(int id);
	boolean deleteUser(int id);
	boolean setUser();
	
	
	void setId(int id);
	int getId();
	void setUserName(String userName);
	String getUserName();
	void setPassword(String password);
	String getPassword();
	void setFirstName(String firstName);
	String getFirstName();
	void setLastName(String lastName);
	String getLastName();
	void setEmail(String email);
	String getEmail();
	void setPhone(String phone);
	String getPhone();

}
