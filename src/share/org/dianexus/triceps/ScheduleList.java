import java.io.*;
import java.util.*;

public class ScheduleList {
	private Vector schedules = new Vector();
	private String sourceDir = null;
	private String errors = null;
	
    public ScheduleList(String sourceDir) {
    	this.sourceDir = sourceDir;
        try {
		    File dir = new File(sourceDir);

		    if (!dir.isDirectory()) {
		    	errors = sourceDir + " is not a directory";
			    System.err.println(errors);
		    	return;
		    }
		    else if (!dir.canRead()) {
		    	errors = sourceDir + " is not accessible";
			    System.err.println(errors);
		    	return;
		    }
		    
			String[] files = dir.list();

			int count=0;
			for (int i=0;i<files.length;++i) {
				try {
					File f = new File(dir.toString() + File.separator + files[i]);
					if (!f.isDirectory()) {
						Schedule schedule = new Schedule(f.toString());
						if (schedule.isFound()) {
							schedules.addElement(schedule);
							++count;
						}
						else {
							schedule.getErrors();	// clear the schedule's errors so that don't report names of files not accessible to user
						}
					}
				}
				catch (Throwable t) {
					errors = "Unexpected error reading from " + sourceDir + " : " + t.getMessage();
					System.err.println(errors);
				}
			}
		}
		catch(Throwable t) {
			errors = "Error reading from " + sourceDir + " : "  + t.getMessage();
			System.err.println(errors);
		}
    }
    
    public String getErrors()	{
    	String tmp = errors;
    	errors = null;
    	return tmp;
    }
	
	public boolean hasErrors() { return (errors != null); }    
    
    public Vector getSchedules() { return schedules; }
}