package org.dianexus.triceps.modules.data;

import java.sql.Timestamp;
/* ********************************************************
 ** Copyright (c) 2000-2006, Thomas Maxwell White, all rights reserved.
 ** SessionDAO.java ,v 3.0.0 Created on March 3, 2006, 2:33 PM
 ** @author Gary Lyons
 ******************************************************** 
 */
         
 public interface SessionDAO {
     
    
     public void setId(int processId);
     public int getId();
     public void setUserId(int userId);
     public int getUserId();
     public void setSessionId(int sessionId);
     public int getSessionId();
     public void setInstrumentId(int instrumentId);
     public int getInstrumentId();
     public void setStudyId(int studyId);
     public int getStudyId();
     public void setLocationId(int locationId);
     public int getLocationId();
     public void setTimestamp(Timestamp ts);
     public Timestamp getTimestamp();
     
     
     public boolean setSession();
     public boolean updateSession();
     public boolean deleteSession();
     public String toString();
     
     
     
 }
