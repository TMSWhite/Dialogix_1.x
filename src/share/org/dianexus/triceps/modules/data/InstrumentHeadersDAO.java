package org.dianexus.triceps.modules.data;
/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** InstrumentHeadersDAO.java ,v 3.0.0 Created on March 9, 2006, 1:03 PM
 ** @author Gary Lyons
 ******************************************************** 
 */
        
 

public interface InstrumentHeadersDAO {
     
     /**
     * @param instrument_version_id
     * @return - true if header data is found
     */
     boolean getInstrumentHeaders(int instrument_version_id);
     
     /**
     * @return - true if data written without error
     */
     boolean setInstrumentHeaders();
     /**
     * @return - true if data updated without error
     */
    boolean updateInstrumentHeaders();
     /**
     * @param varname - header reserved name for update row
     * @param value - value to update
     * @return - true if header is updated without error
     */
    boolean updateInstrumentHeader(String varname, String value);
     /**
     * @param instrument_version_id
     * @return - true if header data deleted without error
     */
    boolean deleteInstrumentHeaders(int instrument_version_id);
     /**
     * @param varName - reserved element to delete
     * @return - true if data deleted  without error
     */
    boolean deleteInstrumentHeader(String varName);
     /**
     * @return - get the last insert id for this connection
     * (call after create)
     */
    int getInstrumentHeadersLastInsertId();
     
     /**
     * @param id - instrument version id to set
     */
    void setInstrumentVersionId(int id);
     /**
     * @return - get the instrument version id of the current rowset
     */
    public int getInstrumentVersionId();
     /**
     * @param varName -  reserved name to add
     * @param value -  value to add
     * adds to local storage must call setInstrumentHeaders() to store in db.
     */
    public void addReserved(String varName, String value);
     /**
     * @return
     */
    String[] getReservedVarNames();
     /**
     * @param varName
     * @return
     */
    public String getReserved(String varName);
     /**
     * @param varName
     * @param value
     */
    void setReserved(String varName, String value);
     
     
 }
