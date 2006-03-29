/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileInputStream;
import java.util.Vector;
import java.util.Hashtable;

import java.util.zip.ZipFile;
import java.io.IOException;
import java.util.zip.ZipEntry;
import java.io.InputStreamReader;
//import java.security.cert.Certificate;
import java.io.ByteArrayInputStream;

/*public*/ final class ScheduleSource implements VersionIF {
	private boolean isValid = false;
	private Vector headers = new Vector();
	private Vector body = new Vector();
	private SourceInfo sourceInfo = null;
	private int reservedCount = 0;
	private static final ScheduleSource NULL = new ScheduleSource();
	
	/* maintain Pooled Collection of ScheduleSources, indexed by name.  Only update if file has changed */
	private static final Hashtable sources = new Hashtable();
	
	private ScheduleSource() {
	}
	
	private ScheduleSource(SourceInfo si) {
		sourceInfo = si;
		
		if (sourceInfo.isReadable() && load()) {
			if (headers.size() > 0 && body.size() > 0 && reservedCount > 0) {
				isValid = true; 
			}
		}
	}
	
	/*public*/ static synchronized ScheduleSource getInstance(String src) {
		if (src == null) {
			return NULL;
		}
		
		ScheduleSource ss = (ScheduleSource) sources.get(src);
		
		SourceInfo newSI = SourceInfo.getInstance(src);
		SourceInfo oldSI = ((ss == null) ? null : ss.getSourceInfo());
		
		if (!newSI.isReadable()) {
			// then does not exist, or deleted
if (DEBUG) Logger.writeln("##ScheduleSource(" + src + ") is not accessible, or has been deleted");
			sources.put(src,NULL);
			return NULL;
		}
		else if (ss == null || oldSI == null) {
			// then this is the first time it is accessed, or the file has changed
			 ss = new ScheduleSource(newSI);
			sources.put(src,ss);
//if (DEBUG) Logger.writeln("##ScheduleSource(" + src + ") is new ->(" + ss.getHeaders().size() + "," + ss.getBody().size() + ")");
			 return ss;
		}
		else if (!oldSI.equals(newSI)) {
			// then the file has changed and needs to be reloaded
//if (DEBUG) Logger.write("##ScheduleSource(" + src + ") has changed from (" + ss.getHeaders().size() + "," + ss.getBody().size() + ")");
			ss = new ScheduleSource(newSI);
			sources.put(src,ss);
//if (DEBUG) Logger.writeln(" -> (" + ss.getHeaders().size() + "," + ss.getBody().size() + ")");
			return ss;
		}
		else {
			// file is unchanged - use buffered copy
//if (DEBUG) Logger.writeln("##ScheduleSource(" + src + ") unchanged");
			return ss;
		}
	}
	
	private boolean load() {
		String name = sourceInfo.getSource();
		
		if ((DEPLOYABLE || DEMOABLE) && name.toLowerCase().endsWith(".jar")) {
			return readFromJar();
		}
		else if (AUTHORABLE && name.toLowerCase().endsWith(".txt")) {
			return readFromAscii();
		}
		else if (name.toLowerCase().endsWith(".dat")) {
			return readFromAscii();
		}
		else {
			return false;
		}
	}
	
	private boolean readFromAscii() {
		// load from text file
		boolean pastHeaders = false;
		BufferedReader br = null;
		InputStreamReader isr = null;
		try {
			br = new BufferedReader( new InputStreamReader(new FileInputStream(new File(sourceInfo.getSource())),"ISO-8859-1"));
			String fileLine = null;
			while ((fileLine = br.readLine()) != null) {
				if ("".equals(fileLine.trim())) {
					continue;
				}
				if (!pastHeaders && fileLine.startsWith("RESERVED")) {
					++reservedCount;
					headers.addElement(fileLine);
					continue;
				}
				if (fileLine.startsWith("COMMENT")) {
					if (pastHeaders) {
						body.addElement(fileLine);
					}
					else {
						headers.addElement(fileLine);
					}
					continue;
				}
				// otherwise a body line
				pastHeaders = true;	// so that datafile RESERVED words are added in sequence
				body.addElement(fileLine);
			}
		}
		catch (Exception e) {
if (DEBUG)	Logger.writeln("##Exception @ ScheduleSource.readFromAscii() " + e.getMessage());
		}
		if (br != null) {
			try { br.close(); } catch (IOException t) { }
		}
		return true;
	}
	
	/*public*/ Vector getHeaders() { return headers; }
	/*public*/ Vector getBody() { return body; }
	/*public*/ boolean isValid() { return isValid; }
	/*public*/ String getSrcName() { if (sourceInfo == null) return "";  return sourceInfo.getSource(); }
	
	/*public*/ SourceInfo getSourceInfo() { return sourceInfo; }
	
	private boolean readFromJar() {
		// load from Jar file
		ZipFile jf = null;
		ZipEntry je = null;
		boolean ok = true;
		
		try {
			jf = new ZipFile(sourceInfo.getSource());
			headers = jarEntryToVector(jf, "headers");
			body = jarEntryToVector(jf, "body");
			reservedCount = headers.size();
		}
		catch (Exception e) {
if (DEBUG) Logger.writeln("##readFromJar " + e.getMessage());
			ok = false;
		}
		if (jf != null) try { jf.close(); } catch (Exception t) { }
		return ok;
	}
	
	private Vector jarEntryToVector(ZipFile jf, String name) {
		Vector v = new Vector();
		
		try {
			ZipEntry je = jf.getEntry(name);
			
			/* first read the data */
								
			InputStreamReader isr = new InputStreamReader(jf.getInputStream(je));
			BufferedReader br = new BufferedReader(isr);

			String fileLine = null;
			try {
				while ((fileLine = br.readLine()) != null) {
					if ("".equals(fileLine.trim())) {
						continue;
					}
					v.addElement(fileLine);
				}
			}
			catch (Exception e) {	// IOException
if (DEBUG)		Logger.writeln("##IOException @ ScheduleSource.jarEntryToVector()" + e.getMessage());
			}
			if (br != null) {
				try { br.close(); } catch (IOException t) { }
			}
			
			/* then validate certificates */
/*	Temporarily remove need to validate certificates
			Certificate certs[] = je.getCertificates();
			
			if (certs == null || certs.length == 0) {
if (DEBUG) 		Logger.writeln("##ScheduleSource.jarEntryToVector(" + sourceInfo.getSource() + "," + name + ") is not signed");
if (DEPLOYABLE)	return new Vector();	// empty;		
			}
			else {
				Certificate cert = certs[0];
				
				try {
//if (DEBUG) Logger.writeln("##verifying certificate " + cert.toString());
					cert.verify(cert.getPublicKey());
				}
				catch (Exception t) {
if (DEBUG) Logger.writeln("##invalid certificate or corrupted signing: " + t.getMessage());
if (DEPLOYABLE)	return new Vector();	// empty;		
				}
			}
*/						
		}	
		catch (Exception e) {
if (DEBUG) Logger.writeln("##Exception @ jarEntryToVector"  + e.getMessage());
		}
		return v;	
	}

	/*public*/ String saveAsJar(String name) {
if (AUTHORABLE) {		
		JarWriter jf = null;
		
		int lastPeriod = name.lastIndexOf(".");
		if (lastPeriod != -1) {
			name = name.substring(0,lastPeriod) + ".jar";
		}
		else {
			name = name + ".jar";
		}
		
		jf = JarWriter.getInstance(name);
		
		if (jf == null)
			return null;
			
		boolean ok = false;
				
		ok = jf.addEntry("headers",vectorToIS(getHeaders()));
		ok = jf.addEntry("body",vectorToIS(getBody())) && ok;
		jf.close();
		
		File f = new File(name);
		if (f.length() == 0L) {
			ok = false;
		}
		
		return (ok) ? name : null;
}
		return null;
	}
	
	private ByteArrayInputStream vectorToIS(Vector v) {
		if (v == null)
			return null;
			
		StringBuffer sb = new StringBuffer();
		for (int i=0;i<v.size();++i) {
			sb.append((String) v.elementAt(i));
			sb.append("\n");
		}
		return new ByteArrayInputStream(sb.toString().getBytes());
	}	
}
