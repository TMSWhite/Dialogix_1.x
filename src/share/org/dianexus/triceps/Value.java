import java.lang.*;
import java.util.*;

class Value {
	private Node	node=null;
	private Datum	datum=null;
	private Date	timeStamp=null;
	private String	timeStampStr=null;
	private int reserved = -1;
	private Schedule schedule = null;
			
	Value() {
	}
		
	Value(Node n, Datum d, String time) {
		node = n;
		datum = d;
		if (time != null && time.trim().length() > 0) {	// don't set to default if no time specified
			n.setTimeStamp(time);
		}
	}
		
	Value(String s, Datum d) {
		// no associated node - so a temporary variable
		datum = d;
	}
		
	Value(String s, Datum d, int reserved, Schedule schedule) {
		datum = d;
		this.reserved = reserved;
		this.schedule = schedule;
	}
		
	Node getNode() { return node; }
		
	void setDatum(Datum d, String time) { 
		datum = d; 
		if (node != null)	// do set default time, even if no time string specified
			node.setTimeStamp(time);
				
		if (reserved >= 0 && schedule != null) {
			schedule.setReserved(reserved,d.stringVal());
		}
	}
	Datum getDatum() { return datum; }
}
