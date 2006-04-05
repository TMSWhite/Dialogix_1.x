/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** MysqlInstrumentMetaDAO.java ,v 3.0.0 Created on March 10, 2006, 9:13 AM
 ** @author Gary Lyons
 ******************************************************** */


package org.dianexus.triceps.modules.data;

import java.sql.Date;
import java.sql.*;


public class  MysqlInstrumentMetaDAO implements InstrumentMetaDAO{
    
    /** Creates a new instance of MysqlInstrumentMetaDAO */
    public  MysqlInstrumentMetaDAO() {
    }

    public boolean getInstrumentMeta(int id) {
        return true;
    }

    public boolean getInstrumentMeta(java.lang.String name) {
        return true;
    }

    public boolean setInstrumentMeta() {
        return true;
    }

    public boolean updateInstrumentMeta(java.lang.String column, java.lang.String value) {
        return true;
    }

    public boolean deleteInstrumentMeta(int id) {
        return true;
    }

    public int getInstrumentMetaLastInsertId() {
        return 0;
    }

    public java.lang.String getInstrumentName() {
        return "";
    }

    public void setInstrumentName(java.lang.String name) {
    }

    public void setTitle(java.lang.String title) {
    }

    public java.lang.String getTitle() {
        return "";
    }

    public void setVersion(java.lang.String version) {
    }

    public java.lang.String getVersion() {
        return "";
    }

    public void setCreationDate(Date date) {
    }

    public java.sql.Date getCreationDate() {
        return null;
    }

    public void setNumVars(int numVars) {
    }

    public int getNumVars() {
        return 0;
    }

    public void setVarListMD5(java.lang.String varListMD5) {
    }

    public java.lang.String getVarListMD5() {
        return "";
    }

    public void setInstrumentMD5(java.lang.String instrumentMD5) {
    }

    public void setLanguageList(java.lang.String languageList) {
    }

    public java.lang.String[] getLanguageListArray() {
        return null;
    }

    public void setNumLanguages(int numLanguages) {
    }

    public int getNumLanguages() {
        return 0;
    }

    public void setNumInstructions(int numInstructions) {
    }

    public int getNuInstructions() {
        return 0;
    }

    public void setNumEquations(int numEquations) {
    }

    public int getNumEquations() {
        return 0;
    }

    public void setNumQuestions(int numQuestions) {
    }

    public int getNumQuestions() {
        return 0;
    }

    public void setNumBranches(int numBranches) {
    }

    public int getNumBranches() {
        return 0;
    }

    public void setNumTailorings(int numTailorings) {
    }

    public int getNumTailorings() {
        return 0;
    }

    public boolean equals(Object obj) {

        boolean retValue;
        
        retValue = super.equals(obj);
        return retValue;
    }





    public String toString() {

        String retValue;
        
        retValue = super.toString();
        return retValue;
    }

    protected Object clone() throws CloneNotSupportedException {

        Object retValue;
        
        retValue = super.clone();
        return retValue;
    }

    protected void finalize() throws Throwable {

        super.finalize();
    }

    public String getInstrumentMD5() {
    return "";
    }

    public String getLanguageList() {
        return "";
    }

   

    public int hashCode() {

        int retValue;
        
        retValue = super.hashCode();
        return retValue;
    }
    
}
