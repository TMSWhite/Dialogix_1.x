package org.dianexus.triceps;

import java.io.IOException;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.Vector;
import java.util.HashMap;

/*public*/ final class ScheduleSource implements VersionIF {
	private boolean isValid = false;
	private Vector headers = new Vector();
	private Vector body = new Vector();
	private SourceInfo sourceInfo = null;
	private static final ScheduleSource NULL = new ScheduleSource();
	
	/* maintain Pooled Collection of ScheduleSources, indexed by name.  Only update if file has changed */
	private static final HashMap sources = new HashMap();
	
	private ScheduleSource() {
	}
	
	private ScheduleSource(SourceInfo si) {
		sourceInfo = si;
		
		if (sourceInfo.isReadable() && load()) {
			if (headers.size() > 0 && body.size() > 0) {
				isValid = true; 
			}
		}
	}
	
	/*public*/ static ScheduleSource getInstance(String src) {
		if (src == null || 
			!(src.endsWith(".txt") || src.endsWith(".jar") || src.endsWith(".dat"))
			) {
			return NULL;
		}
			
		ScheduleSource ss = (ScheduleSource) sources.get(src);
		
		SourceInfo newSI = SourceInfo.getInstance(src);
		SourceInfo oldSI = null;
		
		if (ss == null || ((oldSI = ss.getSourceInfo()) == null) || !newSI.isReadable() || !oldSI.equals(newSI)) {
			// then this is the first time it is accessed, or the file has changed
			 ss = new ScheduleSource(newSI);
			 sources.put(src,ss);
if (DEBUG) Logger.writeln("##ScheduleSource(" + src + ") is new or has changed ->(" + ss.getHeaders().size() + "," + ss.getBody().size() + ")");
			 return ss;
		}
		else {
			// file is unchanged - use buffered copy
if (DEBUG) Logger.writeln("##ScheduleSource(" + src + ") unchanged");
			return ss;
		}
	}
	
	
	private boolean load() {
		if (DEPLOYABLE && sourceInfo.getSource().endsWith(".jar")) {
			// load from Jar file
			return false;
		}
		else if (AUTHORABLE && (sourceInfo.getSource().endsWith(".txt") || sourceInfo.getSource().endsWith(".dat"))) {
			// load from text file
			boolean pastHeaders = false;
			BufferedReader br = null;
			try {
				br = new BufferedReader(new FileReader(new File(sourceInfo.getSource())));
				String fileLine = null;
				while ((fileLine = br.readLine()) != null) {
					if (fileLine.trim().equals("")) {
						continue;
					}
					if (!pastHeaders && fileLine.startsWith("RESERVED")) {
						headers.addElement(fileLine);
						continue;
					}
					if (fileLine.startsWith("COMMENT")) {
						continue;
					}
					// otherwise a body line
					pastHeaders = true;	// so that datafile RESERVED words are added in sequence
					body.addElement(fileLine);
				}
			}
			catch (IOException e) {
if (DEBUG)		Logger.writeln("##IOException @ ScheduleSource.load()" + e.getMessage());
			}
			if (br != null) {
				try { br.close(); } catch (IOException t) { }
			}
			return true;
		}
		else {
			return false;
		}
	}
	
	
	/*public*/ Vector getHeaders() { return headers; }
	/*public*/ Vector getBody() { return body; }
	/*public*/ boolean isValid() { return isValid; }
	
	/*public*/ SourceInfo getSourceInfo() { return sourceInfo; }
}
