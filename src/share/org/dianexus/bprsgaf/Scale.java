package org.dianexus.bprsgaf;

import java.util.*;
import java.text.*;

public class Scale {
    private static NumberFormat nf = NumberFormat.getPercentInstance();
	private String name;
	private Vector questions = new Vector();
	private Vector scales = new Vector();
	private int	max = 0;
	private int	score = 0;
	private boolean known = false;
	private String percent = null;
				
	public Scale(String name) {
		this.name = name;
	}
	
	public void add(OutcomesQuestion oq) {
	    questions.addElement(oq);
	}
	
	public void addScale(Scale scale) {
	    scales.addElement(scale);
	}
	
	public String getName() {
	    return name;
	}

	public int getMax() {
	    if (!known) {
	        calc();
	    }
	    return max;
	}
	
	public int getScore() {
	    if (!known) {
	        calc();
	    }
	    return score;
	}
	
	public String getPercent() {
	    if (!known) {
	        calc();
	    }
	    return percent;
	}
	
	public void reset() {
	    max = 0;
	    score = 0;
	    known = false;
	    percent = null;
	}
	
	private void calc() {
		Enumeration enum = questions.elements();
		while (enum.hasMoreElements()) {
		    OutcomesQuestion oq = (OutcomesQuestion) enum.nextElement();
		    int ans = oq.getAnswer();
		    if (ans != 9 && ans != 0) { // this is a kludge - GAF doesn't use this coding!
		        max += 7;   // max for BPRS
		        score += ans;
		    }
		}
		enum = scales.elements();
		while (enum.hasMoreElements()) {
		    Scale scale = (Scale) enum.nextElement();
		    max += scale.getMax();
		    score += scale.getScore();
		}
		
		float pct;
		try {
		    percent = nf.format((double) score / (double) max);
//		    pct = (float) 100 * (float) score / (float) max;
//		    percent = String.valueOf(pct);
		} catch (Exception e) {
		    percent = "Undefined";
		}
		
		known = true;
	}
}
