/* ******************************************************** 
** Copyright (c) 2000-2001, Thomas Maxwell White, all rights reserved. 
** $Header$
******************************************************** */ 

package org.dianexus.triceps;

import java.io.*;

/*public*/ class EvidenceIO implements VersionIF  {
	private EvidenceIO() {
	}
	
	static String createTempFile() {
		try {
			File name = File.createTempFile("tmp",null);
			name.deleteOnExit();	// to facilitate cleanup
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
	
	static boolean exec(String commands) {
		// FIXME: this is generating errors, rather than running a sub-process -- why?
		Runtime rt = Runtime.getRuntime();
		Process pr = null;
		
		try {
			pr = rt.exec(commands);
			pr.waitFor();
			int exit = pr.exitValue();
			return (exit == 0);	// means normal exit
		}
		catch (Exception e) {
			Logger.writeln("exec error: " + e.getMessage());
			return false;
		}
	}
}
