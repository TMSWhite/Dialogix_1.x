/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

import java.io.*;
import java.util.Random;


/*public*/ class EvidenceIO implements VersionIF  {
	private EvidenceIO() {
	}
	
	static String createTempFile() {
		try {
			File name = createTempFile("tmp",null);
//			name.deleteOnExit();	// to facilitate cleanup
			return name.toString();
		} 
		catch (Exception e) {
			Logger.writeln("Unable to create temp file: " + e.getMessage());
			return null;	
		}
	}
	
	static boolean saveEvidence(Evidence ev, String filename, String[] names) {
		return false;	// XXX
	}
	
	static boolean saveAll(Schedule sched, String filename) {
		BufferedWriter bw = null;
		FileWriter fw = null;
		boolean ok = false;
		
		try {
			Evidence ev = sched.getTriceps().getEvidence();
			int length = sched.size();			
			fw = new FileWriter(filename);
			bw = new BufferedWriter(fw);
			

			for (int i=0;i<length;++i) {
				Node node = sched.getNode(i);
				printData(bw, ev, node);
			}
			ok = true;
		}
		catch (Exception e) {
			Logger.writeln("saveAll error: " + e.getMessage());
		}
		try {
			if (fw != null) {
				if (bw != null) {
					bw.close();
				}
				else {
					fw.close();
				}
			}
		}
		catch (Exception ex) { }		
		return ok;
	}
	
	private static void printData(BufferedWriter bw, Evidence ev, Node node) {
		try { 
			bw.write(node.getLocalName());
			bw.write("\t");
			
			Value v = ev.getValue(node);
			if (v == null) {
				bw.write("");
			}
			else {
				bw.write(v.getDatum().stringVal());
			}
			bw.newLine();
		}
		catch (Exception e) {
		}
	}
	
	private static final String WIN_ID = "Windows";
	private static final String WIN_PATH = "rundll32";
	private static final String WIN_FLAG = "url.dll,FileProtocolHandler";
	
	static boolean exec(String commands) {
		// FIXME: this is generating errors, rather than running a sub-process -- why?
		Runtime rt = Runtime.getRuntime();
		Process pr = null;
		String cmd = null;
		
		try {
			if (isWindowsPlatform()) {
				cmd = WIN_PATH + " " + WIN_FLAG + " " + commands;
			}
			else {
				cmd = commands;
			}
			pr = rt.exec(cmd);	// XXX -- check that works for Unix too
			pr.waitFor();
			int exit = pr.exitValue();
			return (exit == 0);	// means normal exit
		}
		catch (Exception e) {
			Logger.writeln("exec error (" + e.getClass().getName() + "): " + e.getMessage());
			Logger.printStackTrace(e);
			return false;
		}
	}
	
	private static boolean isWindowsPlatform() {
		String os = System.getProperty("os.name");
		if ( os != null && os.startsWith(WIN_ID))
		  return true;
		else
		  return false;
	}
	
/** Modified from JDK 1.3 createTempFile () */
    private static final Object tmpFileLock = new Object();

    private static int counter = -1; /* Protected by tmpFileLock */
    
    public static File createTempFile(String prefix, String suffix)
	throws IOException
    {
	return createTempFile(prefix, suffix, null);
	}

	public static File createTempFile(String prefix, String suffix,
				      File directory)
        throws IOException
    {
	if (prefix == null) throw new NullPointerException();
	if (prefix.length() < 3)
	    throw new IllegalArgumentException("Prefix string too short");
	String s = (suffix == null) ? ".tmp" : suffix;
	synchronized (tmpFileLock) {
	    if (directory == null) {
		directory = new File(getTempDir());
	    }
	    SecurityManager sm = System.getSecurityManager();
	    File f;
	    do {
		f = generateFile(prefix, s, directory);
	    } while (!checkAndCreate(f.getPath(), sm));
	    return f;
	}
	}

    private static String tmpdir; /* Protected by tmpFileLock */

    private static String getTempDir() {
	if (tmpdir == null) {
		tmpdir = "/tmp";	// this is cheating
//	    GetPropertyAction a = new GetPropertyAction("java.io.tmpdir");
//	    tmpdir = ((String) AccessController.doPrivileged(a));
	}
	return tmpdir;
	}

    private static File generateFile(String prefix, String suffix, File dir)
	throws IOException
    {
	if (counter == -1) {
	    counter = new Random().nextInt() & 0xffff;
	}
	counter++;
	return new File(dir, prefix + Integer.toString(counter) + suffix);
	}

    private static boolean checkAndCreate(String filename, SecurityManager sm)
	throws IOException
    {
	if (sm != null) {
	    try {
		sm.checkWrite(filename);
	    } catch (Exception x) {
		/* Throwing the original AccessControlException could disclose
		   the location of the default temporary directory, so we
		   re-throw a more innocuous SecurityException */
		throw new SecurityException("Unable to create temporary file");
	    }
	}
	return true;	// is this correct -- don't I need to create the actual file?
//	return fs.createFileExclusively(filename);
    }
}
