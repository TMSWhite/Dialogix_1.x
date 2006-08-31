package org.dianexus.triceps;

public class UserPermission {
	
	private int permissionId;
	private int instrumentId;
	private int userId;
	private String role;
	private String comment;
	public String getComment() {
		return comment;
	}
	public void setComment(String comment) {
		this.comment = comment;
	}
	public int getInstrumentId() {
		return instrumentId;
	}
	public void setInstrumentId(int instrumentId) {
		this.instrumentId = instrumentId;
	}
	public int getPermissionId() {
		return permissionId;
	}
	public void setPermissionId(int permissionId) {
		this.permissionId = permissionId;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	

}
