/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

import java.io.File;
import java.util.zip.ZipOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.io.UnsupportedEncodingException;
import java.io.FileNotFoundException;
import java.lang.SecurityException;
import java.io.InputStream;
import java.io.FileInputStream;

/*public*/ class JarWriter implements VersionIF {
	private String filename = null;
	private FileOutputStream fos = null;
	private ZipOutputStream jos = null;
	private Logger errorLogger = new Logger();
	/*public*/ static final JarWriter NULL = new JarWriter();	
	
	private JarWriter() {
	}
	
	/*public*/ static JarWriter getInstance(String name) {
		JarWriter jf = new JarWriter();
		if (jf.init(name)) {
			return jf;
		}
		else {
			return null;
		}
	}
	
	private boolean init(String name) {
		Exception err = null;
		
		try {
			filename = name;
			fos = new FileOutputStream(filename);
			jos = new ZipOutputStream(fos);
		}
		catch (Exception e) {	// FileNotFoundException, SecurityException, IOException, NullPointerException
			err = e;	// unable to create file
		}
		
		if (err != null) {
			if (jos != null) try { jos.close(); jos=null; } catch (Exception t) { }
			if (fos != null) try { fos.close(); fos=null; } catch (Exception t) { }

			setError("JarWriter.init(" + name + ")->" + err.getMessage());
			return false;			
		}
		return true;
	}
	
	/*public*/ boolean addEntry(String name, File file) {
		FileInputStream fis = null;
		boolean ok = false;
		
		if (name == null || file == null)
			return false;
		
		try {
			fis = new FileInputStream(file);
		}
		catch (Exception e) {	// FileNotFoundException, SecurityException
			setError("JarWriter.addEntry(" + name + "," + file + ")->" + e.getMessage());		
			ok = false;	
		}
	
		ok = addEntry(name, fis);
		
//		if (fis != null) try { fis.close(); } catch (Exception t) { }	// should be closed by addEntry()
		return ok;
	}
	
	/*public*/ boolean addEntry(String name, InputStream is) {
		ZipEntry ze = null;
		Exception err = null;
		
		if (name == null || is == null)
			return false;
		
		try {
			ze = new ZipEntry(name);
			jos.putNextEntry(ze);
			
			byte[] buf = new byte[1000];
			int bytesRead = 0;
			
			while((bytesRead = is.read(buf)) != -1) {
				jos.write(buf,0,bytesRead);
			}
		}
		catch (Exception e) { 
			// NullPointerException, IllegalArgumentException
			// UnsupportedEncodingException, ZipException, IOException
			err = e;
		}
		if (err != null) {
			setError("JarWriter.addEntry()->" + err.getMessage());
		}
		try { is.close(); } catch (Exception e) { }
		
		return (err == null);
	}
	
	/*public*/ boolean close() {
		if (jos != null) try { jos.close(); jos=null; } catch (Exception t) { }
		return true;
	}
	
	/*public*/ boolean copyFile(String src, String dst) {
		if (src == null || dst == null) {
			setError("copyFile:  src or dst is null");
			return false;
		}
			
		Exception err = null;
		FileInputStream fis = null;
		FileOutputStream fos = null;
		File fi = null;
		File fo = null;
			
		try {
			fi = new File(src);
			fo = new File(dst);
			
			if (!fi.canRead()) {
				setError("copyFile: " + src + " is unreadable");
				return false;
			}
			if (fi.length() == 0L) {
				setError("copyFile: " + src + " has 0 size");
				return false;
			}
			// do not overwrite a good copy of the jar File currently on the floppy with a bad (smaller) version
			if (fo.exists()) {
				if (fo.length() > fi.length()) {
					setError("copyFile(" + src + ")->(" + dst + "): dst is larger than source");
					return false;
				}
			}
				
			fis = new FileInputStream(fi);
			fos = new FileOutputStream(fo);
			
			byte[] buf = new byte[1000];
			int bytesRead = 0;
			
			while((bytesRead = fis.read(buf)) != -1) {
				fos.write(buf,0,bytesRead);
			}
		}
		catch (Exception e) {
			// FileNotFoundException, SecurityException, IOException
			err = e;
		}
		
		if (fis != null) try { fis.close(); } catch (Exception t) { setError("copyFile: " + t.getMessage()); }
		if (fos != null) try { fos.close(); } catch (Exception t) { setError("copyFile: " + t.getMessage()); }		
		
		if (err != null) {
			setError("copyFile(" + src + ")->(" + dst + "): " + err.getMessage());
			return false;
		}
if (DEBUG) Logger.writeln("copyFile(" + src + ")->(" + dst + "): SUCCESS");
		return true;
	}
	
	private void setError(String s) { 
if (DEBUG) Logger.writeln("##" + s);
		errorLogger.println(s); 
	}
	/*public*/ boolean hasErrors() { return (errorLogger.size() > 0); }
	/*public*/ String getErrors() { return errorLogger.toString(); }		
}
