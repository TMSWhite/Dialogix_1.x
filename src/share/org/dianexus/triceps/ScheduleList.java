import java.io.*;
import java.util.*;

public class ScheduleList {
	private Vector schedules = new Vector();
	private String sourceDir = null;
	private Logger logger = new Logger();
	private Triceps triceps = Triceps.NULL;

    public ScheduleList(Triceps lang, String sourceDir) {
     	triceps = (lang == null) ? Triceps.NULL : lang;
	   	this.sourceDir = sourceDir;
	    File dir = new File(sourceDir);

	    if (!dir.isDirectory()) {
	    	logger.println(sourceDir + triceps.get("is_not_a_directory"));
	    	return;
	    }
	    else if (!dir.canRead()) {
	    	logger.println(sourceDir + triceps.get("is_not_accessible"));
	    	return;
	    }

		String[] files = dir.list();

		int count=0;
		for (int i=0;i<files.length;++i) {
			File f = new File(dir.toString() + File.separator + files[i]);
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

	public boolean hasErrors() { return (logger.size() > 0); }
	public String getErrors() { return logger.toString(); }

    public Vector getSchedules() { return schedules; }

}
