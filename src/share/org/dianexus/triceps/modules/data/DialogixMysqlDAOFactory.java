/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** DialogixMysqlDAOFactory.java ,v 3.0.0 Created on February 23, 2006, 11:30 AM
 ** @author Gary Lyons
 ******************************************************** 
 */
package org.dianexus.triceps.modules.data;

import java.sql.*;

/**
 * DialogixMysqlDAOFactory is a Mysql implementation of the Interface DialogixDAOFactory
 * The abstract factory design pattern, when used in conjunction with the DAO pattern,
 * allows for the dynamic selection of concrete DAO instances at run time. The factory
 * products are DAOs and the product families are concrete instances of the same data
 * store.
 * 
 */

public class DialogixMysqlDAOFactory extends DialogixDAOFactory {
	// TODO Add generic exception logging

	// get the driver for jdbc.mysql
	public static final String DRIVER = Messages
			.getString("DialogixMysqlDAOFactory.DRIVER"); //$NON-NLS-1$

	// get the url for the db server
	public static final String DBURL = Messages
			.getString("DialogixMysqlDAOFactory.DBURL"); //$NON-NLS-1$

	// get the user name for the db server
	public static final String DBUSER = Messages
			.getString("DialogixMysqlDAOFactory.DBUSER"); //$NON-NLS-1$

	// get the password for the db server
	public static final String DBPASS = Messages
			.getString("DialogixMysqlDAOFactory.DBPASS"); //$NON-NLS-1$

	// Mysql setup variables
	static Connection con = null;

	static Statement stmt = null;

	public DialogixMysqlDAOFactory() {
	}

	public static Connection createConnection() {

		try {
			Class.forName(DRIVER).newInstance();
			con = DriverManager.getConnection(DBURL, DBUSER, DBPASS);

		} catch (Exception e) {
			e.printStackTrace();

		}

		return con;

	}
	/**
	 * 
	 * Returns MysqlSessionDataDAO Class as SessionDataDAO Interface
	 */
	public SessionDataDAO getSessionDataDAO() {
		return new MysqlSessionDataDAO();
	}
	/**
	 * 
	 * Returns MysqlRawDataDAO Class as RawDataDAO Interface
	 */
	public RawDataDAO getRawDataDAO() {
		return new MysqlRawDataDAO();

	}
	/**
	 * 
	 * Returns MysqlUserSessionDAO Class as UserSessionDAO Interface
	 */
	public UserSessionDAO getUserSessionDAO() {
		return new MysqlUserSessionDAO();
	}

	/**
	 * 
	 * Returns MysqlInstrumentContentsDAO Class as InstrumentContentsDAO Interface
	 */
	public InstrumentContentsDAO getInstrumentContentsDAO() {
		
		return new MysqlInstrumentContentsDAO();
	}

	/**
	 * 
	 * Returns MysqlInstrumentHeadersDAO Class as InstrumentHeadersDAO Interface
	 */
	public InstrumentHeadersDAO getInstrumentHeadersDAO() {
		
		return new MysqlInstrumentHeadersDAO();
	}

	/**
	 * 
	 * Returns MysqlInstrumentMetaDAO Class as InstrumentMetaDAO Interface
	 */
	public InstrumentMetaDAO getInstrumentMetaDAO() {
		
		return new MysqlInstrumentMetaDAO();
	}

	/**
	 * 
	 * Returns MysqlInstrumentSessionDAO Class as InstrumentSessionDAO Interface
	 */
	public InstrumentSessionDAO getInstrumentSessionDAO() {
		
		return new MysqlInstrumentSessionDAO();
	}

	/**
	 * 
	 * Returns MysqlInstrumentTranslastionsDAO Class as InstrumentTranslationsDAO Interface
	 */
	public InstrumentTranslationsDAO getInstrumentTranslationsDAO() {
		
		return new MysqlInstrumentTranslationsDAO();
	}

	/**
	 * 
	 * Returns MysqlPageHitEventsDAO Class as PageHitEventsDAO Interface
	 */
	public PageHitEventsDAO getPageHitEventsDAO() {
		
		return new MysqlPageHitEventsDAO();
	}

	/**
	 * 
	 * Returns MysqlPageHitsDAO Class as PageHitsDAO Interface
	 */
	public PageHitsDAO getPageHitsDAO() {
		
		return new MysqlPageHitsDAO();
	}

	public InstrumentDAO getInstrumentDAO() {

		return new MysqlInstrumentDAO();
	}

	public InstrumentVersionDAO getInstrumentVersionDAO() {

		return new MysqlInstrumentVersionDAO();
	}
	

}
