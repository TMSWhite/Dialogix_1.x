package org.dianexus.bprsgaf;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;

public class parseGAF extends HttpServlet
{
	private static Vector oqs = new Vector();
	private static Vector scales = new Vector();
	private static final int NUM_QUESTIONS = 15;
	private static final int FIRST_SOCIAL = 1;
	private static final int LAST_SOCIAL = 4;
	private static String dataDir = "";

	public void init(ServletConfig config) throws ServletException
	{
		super.init(config);
		// to do: code goes here.

		String s = config.getInitParameter("dataDir");
		if (s != null)
			dataDir = s;

		initForms();
	}

	public void destroy()
	{
		// to do: code goes here.
		super.destroy();
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException
	{

		OutcomesForm form = new OutcomesForm("Global Assessment of Function", oqs, scales, req, resp);

		int[] iGAF = new int[NUM_QUESTIONS+1];

		for (int i=1;i<=NUM_QUESTIONS;++i) {
			iGAF[i] = form.getInt("gaf" + i);
		}

		iGAF[0] = iGAF[LAST_SOCIAL+1];	// copy user-entered overall social to index 0

		int overall_social = 100;
		int score = 100;
		int seriouses = 0;
		for (int i=FIRST_SOCIAL;i<=LAST_SOCIAL;++i) {
			if (iGAF[i] == 45) {
				++seriouses;
			}
			overall_social = Math.min(overall_social,iGAF[i]);
		}
		switch(seriouses) {
			case 0: break;
			case 1: overall_social = 45; break;
			case 2: overall_social = 35; break;
			case 3: case 4: overall_social = 25; break;
		}

		iGAF[LAST_SOCIAL+1] = overall_social;	// instead of parsed value
		score = overall_social;

		for (int i=0;i<=NUM_QUESTIONS;++i) {
			score = Math.min(score,iGAF[i]);
		}

		// Create HTML response
		/*
		extra.appendln("<TABLE BORDER=\"1\" CELLPADDING=\"0\" CELLSPACING=\"0\" WIDTH=\"100%\">");
		Iterator it = oqs.iterator();
		for (int i=1;it.hasNext();++i) {
			OutcomesQuestion oq = (OutcomesQuestion) it.next();
			extra.appendln(oq.toString(iGAF[i]));	// search for string matching the given choice
		}
		extra.appendln("<TR></TR><TR><TD COLSPAN=\"2\" BGCOLOR=\"#FFFF66\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>GAF Score</B></FONT></P></TD>");
		extra.appendln("<TD BGCOLOR=\"#FFFF66\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>" + (score - 4) + "-" + (score + 5) + "</B></FONT></P></TD></TR>");
		extra.appendln("</TABLE>");

     	extra.appendln("</BODY>");
		extra.appendln("</HTML>");
		out.close();
		*/

		StringBuffer extra = new StringBuffer();
		String scoreStr = "" + (score-4) + "-" + (score+5);

		extra.append("<TR><TD COLSPAN=\"2\"" + form.BGCOLOR + ">");
		extra.append("<P ALIGN=\"CENTER\"><FONT FACE=\"Arial\">");
		extra.append("<B>" + "GAF Score" + "</B>");
		extra.append("</FONT></P></TD>\n");
		extra.append("<TD" + form.BGCOLOR + "><P ALIGN=\"CENTER\"><FONT FACE=\"Arial\">");
		extra.append("<B>" + scoreStr + "</B>");
		extra.append("</FONT></P></TD></TR>\n");

		form.resetAnswers();

		form.process(dataDir + "gaf.bar",extra.toString(), scoreStr);

		// Ideally write to database before returning confirmed submission?
	}

	private void initForms() {
		// put GAF question initializers here
		OutcomesQuestion oq;

		oq = new OutcomesQuestion("gaf1","Job, School, Parenting","<TD BGCOLOR=\"#FFFF66\" ROWSPAN=\"5\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Social Functioning</B></FONT></P></TD>");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B>: SUPERIOR FUNCTIONING");
		oq.put("85","<B>81-90</B>: GOOD FUNCTIONING");
		oq.put("75","<B>71-80</B>: SLIGHT IMPAIRMENT - temporarily falls behind in schoolwork");
		oq.put("65","<B>61-70</B>: SOME DIFFICULTY - occasional truancy");
		oq.put("55","<B>51-60</B>: MODERATE DIFFICULTY - conflicts with peers and coworkers");
		oq.put("45","<B>41-50</B>: SERIOUS IMPAIRMENT - unable to keep job;child failing school;parent neglects family");
		oq = new OutcomesQuestion("gaf2","Friends, Relationships","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B>: SUPERIOR FUNCTIONING");
		oq.put("85","<B>81-90</B>: GOOD FUNCTIONING");
		oq.put("75","<B>71-80</B>: SLIGHT IMPAIRMENT");
		oq.put("65","<B>61-70</B>: SOME DIFFICULTY - only some meaningful relationships");
		oq.put("55","<B>51-60</B>: MODERATE DIFFICULTY - few friends, conflicts with peers");
		oq.put("45","<B>41-50</B>: SERIOUS IMPAIRMENT - no friends, child defiant at home; child beats up younger children");
		oq = new OutcomesQuestion("gaf3","Activities","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B>: SUPERIOR FUNCTIONING");
		oq.put("85","<B>81-90</B>: GOOD FUNCTIONING - involved in wide range of activities");
		oq.put("75","<B>71-80</B>: SLIGHT IMPAIRMENT");
		oq.put("65","<B>61-70</B>: SOME DIFFICULTY - occasional thefts within household");
		oq.put("55","<B>51-60</B>: MODERATE DIFFICULTY");
		oq.put("45","<B>41-50</B>: SERIOUS IMPAIRMENT - stays in bed all day; severe obsessional rituals; frequent shoplifting");
		oq = new OutcomesQuestion("gaf4","Housing","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B>: SUPERIOR FUNCTIONING");
		oq.put("45","<B>41-50</B>: SERIOUS IMPAIRMENT - no home");
		oq = new OutcomesQuestion("gaf5","Overall Social Functioning","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - superior");
		oq.put("85","<B>81-90</B> - GOOD or MINIMAL impairment");
		oq.put("75","<B>71-80</B> - SLIGHT or TRANSIENT impairment in ONE functional domain");
		oq.put("65","<B>61-70</B> - SOME or MILD difficulty in ONE domain");
		oq.put("55","<B>51-60</B> - MODERATE difficulty on ONE domain");
		oq.put("45","<B>41-50</B> - ONE SERIOUS impairment");
		oq.put("35","<B>31-40</B> - SEVERAL SERIOUS impairments");
		oq.put("25","<B>21-30</B> - SERIOUS impairment in ALMOST ALL areas");
		oq = new OutcomesQuestion("gaf6","Anxiety","<TD BGCOLOR=\"#FFFF66\" ROWSPAN=\"8\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Symptoms</B></FONT></P></TD>");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("85","<B>81-90</B> - minimal - mild anxiety before exam");
		oq.put("75","<B>71-80</B> - transient");
		oq.put("65","<B>61-70</B> - mild");
		oq.put("55","<B>51-60</B> - moderate - occasional panic attack");
		oq.put("45","<B>41-50</B> - serious - severe obsessional rituals");
		oq = new OutcomesQuestion("gaf7","Mood Sx","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("85","<B>81-90</B> - minimal");
		oq.put("75","<B>71-80</B> - transient");
		oq.put("65","<B>61-70</B> - mild - depressed mood and insomnia");
		oq.put("55","<B>51-60</B> - moderate");
		oq.put("45","<B>41-50</B> - serious - depression with suicidal ideation");
		oq.put("15","<B>11-20</B> - manic excitement");
		oq = new OutcomesQuestion("gaf8","Concentration Impairment","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("85","<B>81-90</B> - minimal");
		oq.put("75","<B>71-80</B> - transient - decreased concentration after family argument");
		oq.put("65","<B>61-70</B> - mild");
		oq.put("55","<B>51-60</B> - moderate");
		oq.put("45","<B>41-50</B> - serious");
		oq = new OutcomesQuestion("gaf9","Delusions","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("55","<B>51-60</B> - delusion without loss of reality testing");
		oq.put("45","<B>41-50</B> - partial delusions - questions beliefs");
		oq.put("35","<B>31-40</B> - delusion without loss of reality testing");
		oq.put("25","<B>21-30</B> - behavior considerably influenced by delusions");
		oq = new OutcomesQuestion("gaf10","Hallucinations","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("55","<B>51-60</B> - hallucination without loss of reality testing");
		oq.put("35","<B>31-40</B> - hallucination with loss of reality testing");
		oq.put("25","<B>21-30</B> - behavior considerably influenced by hallucinations");
		oq = new OutcomesQuestion("gaf11","Communication or Formal Thought Disorder","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("55","<B>51-60</B> - circumstantial speech");
		oq.put("35","<B>31-40</B> - speech at time illogical, obscure, or irrelevant");
		oq.put("25","<B>21-30</B> - sometimes incoherent or acts grossly inappropriately");
		oq.put("15","<B>11-20</B> - largely incoherent or mute");
		oq = new OutcomesQuestion("gaf12","Negative Sx","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - none");
		oq.put("65","<B>61-70</B> - mild");
		oq.put("55","<B>51-60</B> - moderate - flat affect");
		oq.put("45","<B>41-50</B> - serious");
		oq = new OutcomesQuestion("gaf13","Hygeine","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - adequate");
		oq.put("15","<B>11-20</B> - occasionally fails to maintain minimal hygiene (smearing feces)");
		oq.put("5","<B>1-10</B> - persistent inability to maintain minimal hygiene");
		oq = new OutcomesQuestion("gaf14","Danger to Self","<TD BGCOLOR=\"#FFFF66\" ROWSPAN=\"2\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Danger</B></FONT></P></TD>");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - no");
		oq.put("45","<B>41-50</B> - some suicidal ideation");
		oq.put("25","<B>21-30</B> - suicidal preoccupation without attempt");
		oq.put("15","<B>11-20</B> - some danger to self (attempt without expectation of death, frequent violence)");
		oq.put("5","<B>1-10</B> - persistent danger of hurting self OR suicide attempt with expectation of death");
		oq = new OutcomesQuestion("gaf15","Danger to Others","");
		oqs.addElement(oq);
		oq.put("95","<B>91-100</B> - no");
		oq.put("45","<B>41-50</B> - child frequently beats up on younger children");
		oq.put("25","<B>21-30</B> - violence against property");
		oq.put("15","<B>11-20</B> - some danger of hurting self or others (frequent violence)");
		oq.put("5","<B>1-10</B> - persistent danger of hurting self or others (recurrent violence)");
	}
}
