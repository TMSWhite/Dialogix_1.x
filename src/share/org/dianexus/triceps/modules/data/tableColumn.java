package org.dianexus.triceps.modules.data;

public class tableColumn {
	
	private String columnName;
	private String dataType;
	private boolean isNull;
	private int size;
	private String collate;
	private String defaultValue;
	
	
	public String getCollate() {
		return collate;
	}
	public void setCollate(String collate) {
		this.collate = collate;
	}
	public String getColumnName() {
		return columnName;
	}
	public void setColumnName(String columnName) {
		this.columnName = columnName;
	}
	public String getDataType() {
		return dataType;
	}
	public void setDataType(String dataType) {
		this.dataType = dataType;
	}
	public String getDefaultValue() {
		return defaultValue;
	}
	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}
	public boolean isNull() {
		return isNull;
	}
	public void setNull(boolean isNull) {
		this.isNull = isNull;
	}
	public int getSize() {
		return size;
	}
	public void setSize(int size) {
		this.size = size;
	}
	

}
