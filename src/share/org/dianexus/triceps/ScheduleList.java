/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

/*import java.io.*;*/
/*import java.util.*;*/
import java.util.Vector;
import java.io.File;
import java.io.IOException;
import java.io.BufferedInputStream;
import java.io.FileOutputStream;
import java.util.jar.JarFile;
import java.util.jar.JarEntry;
import java.util.Enumeration;

/*public*/ final class ScheduleList implements VersionIF {
	private Vector schedules = new Vector();
	private String sourceDir = null;
	private Logger logger = new Logger();
	private Triceps triceps = Triceps.NULL;

    /*public*/ ScheduleList(Triceps lang, String sourceDir, boolean isSuspended) {
     	triceps = (lang == null) ? Triceps.NULL : lang;
	   	this.sourceDir = sourceDir;
	    File dir = new File(sourceDir);

	    if (!dir.isDirectory()) {
	    	setError(sourceDir + triceps.get("is_not_a_directory"));
	    	return;
	    }
	    else if (!dir.canRead()) {
	    	setError(sourceDir + triceps.get("is_not_accessible"));
	    	return;
	    }
	    
	    if (isSuspended) {
	    	unjarSuspendedInterviews(dir);
	    }

		String[] files = dir.list();

		int count=0;
		for (int i=0;i<files.length;++i) {
			File f = new File(dir.toString() + "/" + files[i]);
			if (!f.isDirectory()) {
				Schedule schedule = new Schedule(triceps, f.toString());
				if (schedule.isFound()) {
					schedules.addElement(schedule);
					++count;
				}
				else {
					schedule.getErrors();	// clear the schedule's errors so that don't report names of files not accessible to user
				}
			}
		}
		triceps.setLocale(null);	// set it to the default
    }
    
    private void unjarSuspendedInterviews(File dir) {
		String[] files = dir.list();

		int count=0;
		for (int i=0;i<files.length;++i) {
			File f = new File(dir.toString() + "/" + files[i]);
			try {
				if (f.getName().toLowerCase().endsWith(".jar") && f.canRead()) {
					// unjar file and remove it
					unjar(f);
					f.delete();	// delete regardless of whether successfully unjared
				}
			}
			catch (Exception e) {
				setError("unjarSuspendedInterviews: " + e.getMessage());
			}				
		}    	
    }
    
    private boolean unjar(File file) {
		JarFile jf = null;
		boolean ok = true;
		
		try {
			jf = new JarFile(file);
			Enumeration entries = jf.entries();
			
			while(entries.hasMoreElements()) {
				if (!saveUnjaredFile(jf, (JarEntry) entries.nextElement())) {
					ok = false;
					break;
				}
			}
		}
		catch (Throwable e) {
			setError("##unjar " + e.getMessage());
			ok = false;
		}
		if (jf != null) try { jf.close(); } catch (Throwable t) { }
		return ok;
	}
	
	private boolean saveUnjaredFile(JarFile jf, JarEntry je) {
		BufferedInputStream bis = null;
		FileOutputStream fos = null;
		File file = null;
		boolean ok = true;
		try {
			file = new File(sourceDir + je.getName());
			if (file.exists()) {
				if (file.length() > je.getSize()) {
					File jarFile = new File(jf.getName());
					String jarFileName = jarFile.getName();
					setError("Unable to restore (" + jarFileName + "): existing file (" + file.getName() + ") is larger than the one you are trying to retore, so it may be more recent.");
					String baseName = file.toString();
					baseName = baseName.substring(0,baseName.indexOf("."));
					setError("If you really want to overwrite the existing files, you must manually delete them (" + baseName + ".*) before restoring (" + jarFileName + ").");
				}
				return false;
			}
			
			bis = new BufferedInputStream(jf.getInputStream(je));
			fos = new FileOutputStream(file);
			
			byte[] buf = new byte[1000];
			int bytesRead = 0;
			
			while((bytesRead = bis.read(buf)) != -1) {
				fos.write(buf,0,bytesRead);
			}
		}
		catch (Exception e) {
			setError("##saveUnjaredFile: " + e.getMessage());
			ok = false;
		}
		if (bis != null) {
			try { bis.close(); } catch (IOException t) { }
		}
		if (fos != null) {
			try { fos.close(); } catch (Exception e) {
				setError("saveUnjaredFile " + file.toString() + ": " + e.getMessage());	
				ok = false;
			}				
		}		
		return ok;					
	}
    
    private void setError(String s) {
if (DEBUG) Logger.writeln(s);
		logger.println(s);
	}

	/*public*/ boolean hasErrors() { return (logger.size() > 0); }
	/*public*/ String getErrors() { return logger.toString(); }

    /*public*/ Vector getSchedules() { return schedules; }

}
