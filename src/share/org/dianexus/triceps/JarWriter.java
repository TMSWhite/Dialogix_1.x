package org.dianexus.triceps;

import java.io.File;
import java.util.jar.JarOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.util.zip.ZipException;
import java.util.jar.JarEntry;
import java.io.UnsupportedEncodingException;
import java.io.FileNotFoundException;
import java.lang.SecurityException;
import java.io.InputStream;
import java.io.FileInputStream;

/*public*/ class JarWriter implements VersionIF {
	private String filename = null;
	private FileOutputStream fos = null;
	private JarOutputStream jos = null;
	/*public*/ static JarWriter NULL = new JarWriter();
	
	private JarWriter() {
	}
	
	/*public*/ static JarWriter getInstance(String name) {
		JarWriter jf = new JarWriter();
		if (jf.init(name)) {
			return jf;
		}
		else {
if (DEBUG) Logger.writeln("##JarWriter.getInstance(" + name + ")->null");	
			return null;
		}
	}
	
	private boolean init(String name) {
		Throwable err = null;
		
		try {
			filename = name;
			fos = new FileOutputStream(filename);
			jos = new JarOutputStream(fos);
		}
		catch (Throwable e) {	// FileNotFoundException, SecurityException, IOException, NullPointerException
			err = e;	// unable to create file
		}
		
		if (err != null) {
			if (jos != null) try { jos.close(); jos=null; } catch (Throwable t) { }
			if (fos != null) try { fos.close(); fos=null; } catch (Throwable t) { }

if (DEBUG) Logger.writeln("##JarWriter.init(" + name + ")->" + err.getMessage());
			return false;			
		}
		return true;
	}
	
	/*public*/ boolean addEntry(String name, File file) {
		FileInputStream fis = null;
		boolean ok = false;
		
		if (name == null || file == null || this == NULL)
			return false;
		
		try {
			fis = new FileInputStream(file);
		}
		catch (Exception e) {	// FileNotFoundException, SecurityException
if (DEBUG) Logger.writeln("##JarWriter.addEntry(" + name + "," + file + ")->" + e.getMessage());		
			ok = false;	
		}
	
		ok = addEntry(name, fis);
		
//		if (fis != null) try { fis.close(); } catch (Throwable t) { }	// should be closed by addEntry()
		return ok;
	}
	
	/*public*/ boolean addEntry(String name, InputStream is) {
		ZipEntry ze = null;
		Throwable err = null;
		
		if (name == null || is == null || this == NULL)
			return false;
		
		try {
			ze = new JarEntry(name);
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
if (DEBUG) Logger.writeln("##JarWriter.addEntry()->" + err.getMessage());
		}
		try { is.close(); } catch (Throwable e) { }
		
		return (err == null);
	}
	
	/*public*/ boolean close() {
		if (this == NULL)
			return false;
			
		if (jos != null) try { jos.close(); jos=null; } catch (Throwable t) { }
		return true;
	}
	
	
	/*public*/ boolean copyFile(String src, String dst) {
		if (src == null || dst == null)
			return false;
			
		Throwable err = null;
		FileInputStream fis = null;
		FileOutputStream fos = null;
			
		try {
			fis = new FileInputStream(src);
			fos = new FileOutputStream(dst);
			
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
		
		if (fis != null) try { fis.close(); } catch (Throwable t) { }
		if (fos != null) try { fos.close(); } catch (Throwable t) { }		
		
if (DEBUG) Logger.writeln("##Triceps.copyFile(" + src + ")->(" + dst + "): " + ((err != null) ? err.getMessage() : "OK"));
		if (err != null) {
			return false;
		}
		return true;
	}
}
