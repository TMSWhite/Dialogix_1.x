package org.dianexus.bprsgaf;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.util.*;
import java.text.*;


public class parseBPRS extends HttpServlet
{
	private static Vector oqs = new Vector();
	private static Vector scales = new Vector();
	private static Scale andp = new Scale("Anxiety-Depression Subscale");
	private static Scale aner = new Scale("Anergia Subscale");
	private static Scale thot = new Scale("Thought Disturbance Subscale");
	private static Scale actv = new Scale("Activation Subscale");
	private static Scale host = new Scale("Hostile-Suspiciousness Subscale");
	private static Scale bprs = new Scale("Total BPRS Score");
	private static String dataDir = "";

	public void init(ServletConfig config) throws ServletException
	{
		super.init(config);

		String s = config.getInitParameter("dataDir");
		if (s != null)
			dataDir = s;

		scales.addElement(bprs);
		scales.addElement(andp);
		scales.addElement(aner);
		scales.addElement(thot);
		scales.addElement(actv);
		scales.addElement(host);

		bprs.addScale(andp);
		bprs.addScale(aner);
		bprs.addScale(thot);
		bprs.addScale(actv);
		bprs.addScale(host);

		initForms();
	}

	public void destroy()
	{
		super.destroy();
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
	throws ServletException, IOException
	{
		OutcomesForm form = new OutcomesForm("Brief Psychiatric Rating Scale", oqs, scales, req, resp);
		form.process(dataDir + "bprs.bar","","");
	}

	void initForms() {
		OutcomesQuestion oq;

		oq = new OutcomesQuestion("bprs1","Uncooperativeness","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\" ROWSPAN=\"2\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Attitude</B></FONT></P></TD>");
		host.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - does not seem motivated");
		oq.put("3","<B>3</B> - MILD - seems evasive in certain areas");
		oq.put("4","<B>4</B> - MODERATE - fails to elaborate spontaneously");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - expresses resentment and is unfriendly throughout");
		oq.put("6","<B>6</B> - SEVERE - refuses to answer a number of questions");
		oq.put("7","<B>7</B> - VERY SEVERE - refuses to answer most questions");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs2","Emotional Withdrawal","");
		aner.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. poor eye contact");
		oq.put("3","<B>3</B> - MILD - frequent poor eye contact");
		oq.put("4","<B>4</B> - MODERATE - little eye contact, but engaged and appropriately responsive");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - stares at floor OR oriented away from interviewer, but moderately engaged");
		oq.put("6","<B>6</B> - SEVERE - more persistent or pervasive than moderately severe");
		oq.put("7","<B>7</B> - VERY SEVERE - &quot;spacey&quot; (absence of emotional relatedness), and disproportionately unengaged");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs3","Motor Retardation","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\" ROWSPAN=\"3\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Motor</B></FONT></P></TD>");
		aner.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - slowness with doubtful clinical significance");
		oq.put("3","<B>3</B> - MILD - conversation somewhat retarded, movement somewhat slowed");
		oq.put("4","<B>4</B> - MODERATE - conversation noticeably retarded, but not strained");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - conversation strained, moves very slowly");
		oq.put("6","<B>6</B> - SEVERE - conversation difficult to maintain, hardly moves at all");
		oq.put("7","<B>7</B> - VERY SEVERE - conversation nearly impossible, does not move at all during interview");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs4","Tension","");
		actv.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. fidgets");
		oq.put("3","<B>3</B> - MILD - frequently fidgets");
		oq.put("4","<B>4</B> - MODERATE - constantly fidgets OR frequently fidgets and wrings hands or pulls clothes");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - constantly fidgets AND wrings hands, and pulls clothes");
		oq.put("6","<B>6</B> - SEVERE - cannot remain seated (e.g. must pace)");
		oq.put("7","<B>7</B> - VERY SEVERE - paces in a frantic manner");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs5","Mannerisms &amp; Posturing","");
		actv.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - odd behavior of doubtful significance (e.g. occ. lip movements, unprompted smiling)");
		oq.put("3","<B>3</B> - MILD - strange but not bizarre (e.g. occ. rhythmic head-tilting, or occ. abnormal finger movements)");
		oq.put("4","<B>4</B> - MODERATE - (e.g. assumes yoga position briefly, infrequent tongue protrusions, rocking)");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - (e.g. maintains yoga position throughout interview, unusual movements in several body areas)");
		oq.put("6","<B>6</B> - SEVERE - more frequent, intense, or pervasive than mod. severe");
		oq.put("7","<B>7</B> - VERY SEVERE - bizarre posturing throughout most of interview, continuous abnormal movements in several body areas");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs6","Blunted Affect","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\" ROWSPAN=\"2\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Affect</B></FONT></P></TD>");
		aner.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. seems indifferent to normally emotive material");
		oq.put("3","<B>3</B> - MILD - somewhat diminished in one dimension (face, gesture, voice)");
		oq.put("4","<B>4</B> - MODERATE - moderately diminished in one dimension, or somewhat in several (face, gesture, voice)");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - severely diminished in two dimensions (monotonous, restricted body gestures, severe lack of facial expression)");
		oq.put("6","<B>6</B> - SEVERE - profound flattening of affect");
		oq.put("7","<B>7</B> - VERY SEVERE - totally monotonous voice AND total lack of expressive gestures throughout the evaluation");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs7","Excitement","");
		actv.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - mild and of doubtful clinical significance");
		oq.put("3","<B>3</B> - MILD - irritable or expansive at times");
		oq.put("4","<B>4</B> - MODERATE - frequently irritable or expansive");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - constantly irritable or expansive OR at times enraged or euphoric");
		oq.put("6","<B>6</B> - SEVERE - enraged or euphoric during most of the interview");
		oq.put("7","<B>7</B> - VERY SEVERE - interview had to be stopped due to severe euphoria or rage");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs8","Conceptual Disorganization","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Thought Process</B></FONT></P></TD>");
		thot.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - somewhat vague");
		oq.put("3","<B>3</B> - MILD - frequently vague, but interview progressed smoothly");
		oq.put("4","<B>4</B> - MODERATE - occ. irrelevant statements OR infrequent neologisms OR moderate loosening of associations");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - frequent formal thought disorder without severely straining the interview");
		oq.put("6","<B>6</B> - SEVERE - formal thought disorder during most of interview, severely straining the interview");
		oq.put("7","<B>7</B> - VERY SEVERE - very little coherent information can be obtained");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs9","Depressive Mood","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\" ROWSPAN=\"3\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Mood</B></FONT></P></TD>");
		andp.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. somewhat depressed");
		oq.put("3","<B>3</B> - MILD - occ. moderately, OR often somewhat depressed");
		oq.put("4","<B>4</B> - MODERATE - occ. very, OR often moderately depressed");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - often very depressed");
		oq.put("6","<B>6</B> - SEVERE - depressed most of the time");
		oq.put("7","<B>7</B> - VERY SEVERE - depressed nearly all of the time");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs10","Anxiety","");
		andp.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. somewhat anxious");
		oq.put("3","<B>3</B> - MILD - occ. moderately, OR often somewhat anxious");
		oq.put("4","<B>4</B> - MODERATE - occ. very, OR often moderately anxious");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - often very anxious");
		oq.put("6","<B>6</B> - SEVERE - very anxious most of the time");
		oq.put("7","<B>7</B> - VERY SEVERE - very anxious nearly all of the time");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs11","Hostility","");
		host.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. somewhat angry");
		oq.put("3","<B>3</B> - MILD - occ. moderately, OR often somewhat angry");
		oq.put("4","<B>4</B> - MODERATE - occ. yells at others OR occ. very angry, OR often moderately angry");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - often yells at others OR often very angry OR occ. threatens to harm others");
		oq.put("6","<B>6</B> - SEVERE - physically abusive one or two times, OR makes frequent threats to harm others");
		oq.put("7","<B>7</B> - VERY SEVERE - intervention required to prevent assaultiveness on several occasions OR any serious assault");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs12","Somatic Concerns","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\" ROWSPAN=\"5\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Thought Content</B></FONT></P></TD>");
		andp.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. somewhat concerned");
		oq.put("3","<B>3</B> - MILD - occ. moderately, OR often somewhat concerned");
		oq.put("4","<B>4</B> - MODERATE - occ. very, OR often moderately concerned");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - often very concerned");
		oq.put("6","<B>6</B> - SEVERE - very concerned most of the time");
		oq.put("7","<B>7</B> - VERY SEVERE - very concerned nearly all of the time");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs13","Guilt Feelings","");
		andp.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - occ. feels somewhat guilty");
		oq.put("3","<B>3</B> - MILD - occ. feels moderately, OR often somewhat guilty");
		oq.put("4","<B>4</B> - MODERATE - occ. feels very, OR often moderately guilty");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - often feels very guilty");
		oq.put("6","<B>6</B> - SEVERE - very guilty most of the time OR encapsulated DELUSION of guilt");
		oq.put("7","<B>7</B> - VERY SEVERE - agonizing constant feelings of guilt OR pervasive DELUSION(s) of guilt");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs14","Grandiosity","");
		thot.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - more confident than most, but doubtful clinical significance");
		oq.put("3","<B>3</B> - MILD - exaggerates talents somewhat out of proportion to circumstances");
		oq.put("4","<B>4</B> - MODERATE - exaggerates talents clearly out of proportion to circumstances OR suspected DELUSION(s)");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - single encapsulated DELUSION OR multiple fragmented DELUSIONS");
		oq.put("6","<B>6</B> - SEVERE - DELUSION(s) or delusional system that patient seems preoccupied with");
		oq.put("7","<B>7</B> - VERY SEVERE - nearly all conversation related to patient's grandiose DELUSION(s)");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs15","Suspiciousness","");
		host.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - rare cases of distrust that may not be warranted");
		oq.put("3","<B>3</B> - MILD - occ. instances of suspiciousness that are definitely not warranted");
		oq.put("4","<B>4</B> - MODERATE - freq. suspiciousness OR transient ideas of reference");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - pervasive suspiciousness, OR frequent ideas of reference");
		oq.put("6","<B>6</B> - SEVERE - encapsulated DELUSION(s) of reference or persecution");
		oq.put("7","<B>7</B> - VERY SEVERE - pervasive or more widespread, frequent, or intense DELUSION(s)");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs16","Unusual Thought Content","");
		thot.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - delusions suspected or likely");
		oq.put("3","<B>3</B> - MILD - PARTIAL DELUSION at times patient questions own beliefs");
		oq.put("4","<B>4</B> - MODERATE - full DELUSIONAL conviction with little or no behavioral impact");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - full DELUSIONAL conviction with occ. behavioral impact");
		oq.put("6","<B>6</B> - SEVERE - significant behavioral impact (e.g. neglects responsibilities)");
		oq.put("7","<B>7</B> - VERY SEVERE - major impact (e.g. stops eating because believes food is poisoned)");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs17","Hallucinatory Behavior","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Perception</B></FONT></P></TD>");
		thot.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - suspected only");
		oq.put("3","<B>3</B> - MILD - definite hallucinations, but infreq., transient, or insignificant (e.g. voice calling patient's name)");
		oq.put("4","<B>4</B> - MODERATE - hallucinations are not extremely distressing nor every day (e.g. two conversing voices)");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - nearly every day, OR a source of extreme distress");
		oq.put("6","<B>6</B> - SEVERE - moderate impact on behavior (e.g. work impaired by concentration difficulty)");
		oq.put("7","<B>7</B> - VERY SEVERE - severe impact on behavior (e.g. suicide attempt 2&deg; command hallucination)");
		oq.put("9","<B>NOT ASSESSED</B>");
		oq = new OutcomesQuestion("bprs18","Disorientation","<TD WIDTH=\"10%\" BGCOLOR=\"#FFFF66\"><P ALIGN=\"CENTER\"><FONT FACE=\"Arial, Helvetica\"><B>Orientation</B></FONT></P></TD>");
		aner.add(oq);
		oqs.addElement(oq);
		oq.put("1","<B>1</B> - NONE");
		oq.put("2","<B>2</B> - VERY MILD - somewhat confused");
		oq.put("3","<B>3</B> - MILD - e.g. off by a year");
		oq.put("4","<B>4</B> - MODERATE - e.g off by a decade");
		oq.put("5","<B>5</B> - MODERATELY SEVERE - unsure where s/he is");
		oq.put("6","<B>6</B> - SEVERE - no idea where s/he is");
		oq.put("7","<B>7</B> - VERY SEVERE - does not know who s/he is");
		oq.put("9","<B>NOT ASSESSED</B>");
	}
}


