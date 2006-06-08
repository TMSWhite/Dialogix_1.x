/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlInstrumentHeadersDAO.java ,v 3.0.0 Created on March 10, 2006, 9:11 AM
 ** @author Gary Lyons
 ******************************************************** */

package org.dianexus.triceps.modules.data;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Hashtable;

public class MysqlInstrumentHeadersDAO implements InstrumentHeadersDAO {

	public static final String SQL_GET_LAST_INSERT_ID = "SELECT LAST_INSERT_ID FROM InstrumentHeaders";

	public static final String SQL_GET_INSTRUMENT_HEADERS = "SELECT * FROM instrumentheaders WHERE instrument_version_id = ?";

	public static final String SQL_INSERT_INSTRUMENT_HEADERS = "INSERT INTO instrumentheaders VALUES(null,?,?,?)";

	public static final String SQL_DELETE_ISTRUMENT_HEADERS = "";

	private int instrumentHeaderId;
	
	private int instrumentVersionId;

	private String instrumentName;// TODO remove

	private String reservedVarName;

	private String reservedVarValue;

	private Hashtable headerValues;

	/** Creates a new instance of MysqlInstrumentHeadersDAO */
	public MysqlInstrumentHeadersDAO() {
	}

	public boolean getInstrumentHeaders(int id) {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			ps = con.prepareStatement(SQL_GET_INSTRUMENT_HEADERS);
			ps.clearParameters();

			ps.setInt(1, id);
			rs = ps.executeQuery();
			while (rs.next()) {
				headerValues.put(rs.getString("reservedVarName"), rs
						.getString("Value"));

			}

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {

				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		return true;
	}

	public boolean updateInstrumentHeader(String varname, String value) {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean updateInstrumentHeaders() {
		// TODO Auto-generated method stub
		return false;
	}

	public boolean deleteInstrumentHeader(String varName) {

		return false;
	}

	public boolean deleteInstrumentHeaders(int instrument_version_id) {

		return false;
	}

	public boolean setInstrumentHeaders() {
		Connection con = DialogixMysqlDAOFactory.createConnection();
		PreparedStatement ps = null;
		ResultSet rs = null;
		boolean rtn = false;
		try {
			ps = con.prepareStatement(SQL_INSERT_INSTRUMENT_HEADERS);
			ps.clearParameters();

			ps.setInt(1, this.instrumentVersionId);
			ps.setString(2, this.reservedVarName);
			ps.setString(3, this.reservedVarValue);
			ps.execute();
			ps = con.prepareStatement(SQL_GET_LAST_INSERT_ID);
			rs = ps.executeQuery();
			if(rs.next()){
				this.instrumentHeaderId = rs.getInt(1);
				rtn = true;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {

				if (ps != null) {
					ps.close();
				}
				if (con != null) {
					con.close();
				}
			} catch (Exception ee) {
				ee.printStackTrace();
			}

		}

		return rtn;
	}

	public int getInstrumentHeadersLastInsertId() {

		return this.instrumentHeaderId ;
	}

	public void addReserved(String varName, String value) {

	}

	public int getInstrumentVersionId() {

		return this.instrumentVersionId;
	}
	public void setInstrumentVersionId(int id) {
		this.instrumentVersionId = id;

	}

	public String getReserved(String varName) {

		return this.reservedVarValue;
	}
	public void setReserved(String varName, String value) {
		this.reservedVarName = varName;
		this.reservedVarValue = value;

	}

	public String[] getReservedVarNames() {
		// TODO Auto-generated method stub
		return null;
	}





}
