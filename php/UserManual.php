<?php require_once("login.inc.php"); ?>
<?php include("Dialogix_Table_PartA.php"); ?>

<P ALIGN="CENTER"><B><FONT SIZE="4">Dialogix System Instructions</FONT></B></P>
<P>
<HR ALIGN="CENTER">
</P>

<P><B><FONT SIZE="4">Overview</FONT></B></P>

<P>Dialogix is a tool for authoring, validating, deploying, and analyzing human-computer dialogs.</P>

<P><A NAME="Authors"></A><B>The Role of the Author</B></P>

<P>The author (who is an expert in a content domain) creates an <B><A HREF="#instrumentFile"><I>instrumentFile</I></A></B>

(a tab-delimitted spreadsheet editable in any spreadsheet program) which encapsulates the content and flow of an
dialog.</P>

<P>Specifically an <B><A HREF="#instrumentFile"><I>instrumentFile</I></A></B> is implemented as a list of nodes,
with one node for row in the spreadsheet.&nbsp; In a node the author encapsulates the logic and rationale for each
possible action in the schedule and specifies the data type of the response (if any) to be stored.&nbsp; Dialogix
currently supports 2 basic kinds of actions -- displays and evaluations.&nbsp; The author defines display actions
to send a new display with information or a question and answer options to the browser.&nbsp; The author defines
evaluations that perform procedures on the data, e.g., count, list, logical and mathematical comparison.</P>

<P>For example, a display action might be a question that asks a person's age.&nbsp; The author specifies the text
of the question (&quot;What is your age?&quot;), the data type (double), and might specify a minimum value (e.g.,
5) or a maximum if appropriate.</P>

<P>For an evaluation action example, consider a schedule which has 5 nodes to ask questions with yes/no answers
about each of 5 symptoms.&nbsp; A subsequent node with an evaluation action to count the symptoms present might
take the form: <I>count(symptom1 == 'yes', symptom2 == 'yes', symptom3 == 'yes', symptom4 == 'yes', symptom5 ==
'yes') </I>and it will store the answer.&nbsp; If the symptom count is supposed to be above a threshold, say 3,
then another node can be defined to test for that, e.g., <I>symptom_count &gt; 3</I>.&nbsp; If it is not necessary
to store both facts separately, one could simply add the &quot;&gt; 3&quot; to the count expression.</P>

<P>Before a node's action is performed its <B><I><A HREF="#relevance">relevance</A></I></B> are checked to determine
if its action is applicable.&nbsp; The <B><I><A HREF="#relevance">relevance</A></I></B> are written as Boolean
expressions.&nbsp; If the expression is TRUE the action is applicable and will be performed storing the appropriate
data.&nbsp; If the expression is FALSE, the action is not applicable so the datum stored for that node is a special
value of <B><I><A HREF="#NOT%20APPLICABLE">notApplicable</A></I></B> and the flow moves on to the next node.&nbsp;

There are two important points to note about using <A HREF="#relevance"><B><I>relevance</I></B></A> like this.&nbsp;
First, each node in its <A HREF="#relevance"><B><I>relevance</I></B></A> expressions explicitly specifies the exact
circumstances in which it is applicable and its connections to other nodes.&nbsp; Second, one does not have to
record a &quot;goto&quot; for each answer option at a given node which eliminates the difficulty of following the
flow of a schedule through all the possible paths.</P>

<P>For example, consider an interview that asks for the subject's gender in one node, then asks whether the subject
has ever been pregnant in the next.&nbsp; The first node will always be asked so its dependency expression is simply
1 (Boolean TRUE).&nbsp; Let's say the response is &quot;female&quot;.&nbsp; The second node should be asked only
if the subject is female, so its <A HREF="#relevance"><B><I>relevance</I></B></A> will be an expression like, <I>gender
== &quot;female&quot;</I>.&nbsp; If this evaluates to TRUE, as it will in this case, the node's action, asking
about pregnancy, will be performed and the response stored.&nbsp;&nbsp; Had the response been &quot;male&quot;

the dependency expression would evaluate to FALSE and a notApplicable would be stored.</P>

<P>As a schedule proceeds, then, each node is considered in order from first to last without jumps.&nbsp; Whether
or not the node's action is performed is determined by the evaluation of the node's <B><A HREF="#relevance"><I>relevance</I></A></B>.&nbsp;
An important consideration in authoring <B><A HREF="#relevance"><I>relevance</I></A></B> is how to handle their
evaluation in the event that one of the nodes was not answered.&nbsp; Dialogix currently supports the distinction
among and special treatment of such cases, including <B><I><A HREF="#UNASKED">notYetAsked</A>, <A HREF="#NOT%20APPLICABLE">notApplicable</A>,

<A HREF="#NOT%20UNDERSTOOD">notUnderstood</A></I></B> (the user did not understand the question), <B><I><A HREF="#UNKNOWN">notKnown</A></I></B>
(the user did not know the answer), and <B><I><A HREF="#REFUSED">refused</A></I></B> (the user refused to answer).</P>

<P>Once authors have created an <B><A HREF="#instrumentFile"><I>instrumentFile</I></A></B>, they copy it to the
<B><I><A HREF="#scheduleSrcDir">scheduleDirectory</A></I></B> to make it available to validators and users.</P>

<P><A NAME="Users"></A><B>The Role of the User</B></P>

<P>The user is anyone who navigates through an interview.&nbsp; The user may be an interviewer, interviewee, author,
or validator.</P>

<P>To start, the user launches a web browser and opens the URL of the Dialogix servlet.&nbsp; The opening screen
provides the means to select a new interview (from a drop-down list of available interviews) or restore an interview
in progress (from a drop-down list of suspended interviews).</P>

<P>After selecting an interview to start (using the <B>Start</B> button), or resume (using the <B>Resume</B> button),
users will see a series of screens in which they will be presented with information and asked questions. The standard
user-interface employed by HTML-based forms is used. After answering the questions on the screen, users must press
the <B>Next</B> button to proceed to the next set of questions. At each stage, Dialogix collects, processes, and
saves any information entered. If required questions are not answered, or if the answers do not conform to the
required data type or value ranges (as specified by the author), Dialogix will re-display the page with informative
messages saying what went wrong, and what needs to be done to correct it. For each question on which Dialogix detected
a problem, Dialogix will paint that question in red, and indicate what needs to be done (e..g <I>Please answer
this question</I>, or <I>Please enter a number in the range (5 - 14)</I>)</P>

<P>At any time, the user can also press the <B>Previous</B> button to return to prior screens and review or change
answers.</P>

<P>When the interview is completed, the users will be thanked and informed that they are done. Despite being finished,
users will have the opportunity to backup (via the <B>Previous</B> button) and review or change answers as needed.</P>

<P><A NAME="Analysts"></A><B>The Role of Analyst</B></P>

<P>The analyst is the person who analyzes the contents of the <B><I><A HREF="#DataFile">dataFile</A></I></B>.</P>

<P>
<HR ALIGN="CENTER">
<BR>
<A NAME="instrumentFile"></A><B><FONT SIZE="4">instrumentFile Format</FONT></B></P>

<P><B>Overview</B></P>

<P>This section applies to <B><I><A HREF="#instrumentFile">instrumentFiles</A></I></B>. Columns in which the values
are optional are marked with an asterix (*).</P>

<P>Each <B><I><A HREF="#instrumentFile">instrumentFile</A></I></B> contains three sections


<UL>
	<LI><B><I>ReservedVariables</I></B>
	<LI><B><I>Comments</I></B>
	<LI><B><I>Nodes</I></B>
</UL>

<P>In each case, there is only one <B><I>ReservedVariable</I></B>, <B><I>Node</I></B>, or <B><I>Comment</I></B>

on a row. The differ in the number of columns required in each section.</P>
<P><B><U>ReservedVariables</U></B> conform to the following syntax: 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="33%"><B>RESERVED</B></TD>
		<TD WIDTH="33%"><B><I><A HREF="#ReservedVariableName">ReservedVariableName</A></I></B></TD>
		<TD WIDTH="34%">value</TD>

	</TR>
</TABLE>
</P>
<P><B><U>Comments</U></B> conform to the following syntax:</P>
<P>The line begins with the <I>string</I> <B>COMMENT</B>. Any content can follow this string, in zero or more columns.</P>
<P><B><U>Nodes</U></B> conform to the following syntax:</P>

<P>The first five columns contain this information: 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="20%"><B><I><A HREF="#concept">concept</A> (*)</I></B></TD>
		<TD WIDTH="20%"><B><I><A HREF="#internalName">internalName</A></I></B></TD>
		<TD WIDTH="20%"><B><I><A HREF="#externalName">externalName</A> (*)</I></B></TD>

		<TD WIDTH="20%"><B><I><A HREF="#relevance">relevance</A></I></B></TD>
		<TD WIDTH="20%"><B><I><A HREF="#questionOrEvalTypeField">questionOrEvalTypeField</A></I></B></TD>
	</TR>
</TABLE>
</P>
<P>The next four columns are repeated, once for each language to be supported. Thus, if three languages are to
be supported, there are three copies of these four columns, each with different, localized content. 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="25%"><B><I><A HREF="#readback">readback</A> (*)</I></B></TD>

		<TD WIDTH="25%"><B><I><A HREF="#questionOrEval">questionOrEval</A></I></B></TD>
		<TD WIDTH="25%"><B><I><A HREF="#answerChoices">answerChoices</A></I></B></TD>
		<TD WIDTH="25%"><B><I><A HREF="#helpURL">helpURL</A> (*)</I></B></TD>
	</TR>
</TABLE>
</P>
<P>These last four columns are only used for setting the default value for questions.</P>

<P>
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="25%"><B><I>NA (*)</I></B></TD>
		<TD WIDTH="25%"><B><I>NA (*)</I></B></TD>
		<TD WIDTH="25%"><B><I><A HREF="#answerGiven">defaultAnswer</A> (*)</I></B></TD>
		<TD WIDTH="25%"><B><I><A HREF="#comment">comment</A> (*)</I></B></TD>

	</TR>
</TABLE>
</P>

<P><B>Detailed Descriptions of Columns / Fields</B></P>

<P><A NAME="concept"></A><B><I>concept</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>

		<TD WIDTH="87%">Syntax</TD>
	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%"><B>string</B></TD>
	</TR>

</TABLE>
The concept is one possible name a node. Although this field is optional, we recommend that it be used, as it allows
authors to explicitly label the rational behind each node. It will also facilitate the creation of or linking to
controlled vocabularies. For example, a node designed to capture the height of a subject in inches might be labeled
as <I>subject.height.inches.</I></P>

<P><A NAME="internalName"></A><B><I>internalName</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>

	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>yes</B></TD>
		<TD WIDTH="87%"><B><A HREF="#Variable%20Names">NMTOKEN</A></B></TD>
	</TR>
</TABLE>
The internalName is the main name for a node. Names are commonly the variable names which will be used for analysis;
or other names that will help make equations more meaningful.</P>

<P><A NAME="externalName"></A><B><I>externalName</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>
	</TR>

	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%"><B>string</B></TD>
	</TR>
</TABLE>
The externalName is another possible name for a node. It is meant to be a reference to existing naming systems
for questions. This is the value that is displayed when <I><A HREF="#__SHOW_QUESTION_REF__">__SHOW_QUESTION_REF__</A></I>

equals <I>true</I>.</P>

<P><A NAME="relevance"></A><B><I>relevance</I></B> (whether the node is applicable - whether the question should
be asked) 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>

		<TD WIDTH="87%">Syntax</TD>
	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%"><B>Boolean equation (1 equals <I>true</I>)</B></TD>

	</TR>
</TABLE>
This field specifies whether a nodes is to be evaluated. If the equation evaluates to <I>false</I>, then the node
is *NA* (e.g. men should not be asked questions about menstruation). Below is an abbreviated example of how <B><A
HREF="#relevance"><I>relevance</I></A></B> work. The goal is to ask all subjects their gender, age, whether they
have children, and whether they have a job. Additionally, women are asked if they menstruate; and if they do menstruate,
they are also asked for the date of their last period and the age of Menarche. Furthermore, if a subject has children,
they are asked how many children they have. Rather than using a procedural <I>if-then</I> approach to specifying
which questions to ask, Dialogix uses a declarative approach. Authors must explicitly specify the <A HREF="#relevance"><B><I>relevance</I></B></A>
of each node. Thus, q3 is only applicable if the subject is female (q1 == 0). Moreover, q4 and q5 are only applicable
for menstruating females. 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>

		<TD WIDTH="13%"><B><I>internalName</I></B></TD>
		<TD WIDTH="12%"><B><I>relevance</I></B></TD>
		<TD WIDTH="50%"><B><I>questionOrEval</I></B></TD>
		<TD WIDTH="25%"><B><I>answerChoices</I></B></TD>
	</TR>
	<TR>
		<TD WIDTH="13%">gender</TD>

		<TD WIDTH="12%">1</TD>
		<TD WIDTH="50%">Are you male or female?</TD>
		<TD WIDTH="25%">male=1, female=0</TD>
	</TR>
	<TR>
		<TD WIDTH="13%">age</TD>
		<TD WIDTH="12%">1</TD>

		<TD WIDTH="50%">How old are you?</TD>
		<TD WIDTH="25%">number</TD>
	</TR>
	<TR>
		<TD WIDTH="13%">menstruate</TD>
		<TD WIDTH="12%">gender==0</TD>
		<TD WIDTH="50%">Do you menstruate?</TD>

		<TD WIDTH="25%">yes=1, no=0</TD>
	</TR>
	<TR>
		<TD WIDTH="13%">LMP</TD>
		<TD WIDTH="12%">menstruate==1</TD>
		<TD WIDTH="50%">When was your last period?</TD>
		<TD WIDTH="25%">date</TD>

	</TR>
	<TR>
		<TD WIDTH="13%">menarche</TD>
		<TD WIDTH="12%">menstruate==1</TD>
		<TD WIDTH="50%">At what age did you start menstruating?</TD>
		<TD WIDTH="25%">number</TD>
	</TR>

	<TR>
		<TD WIDTH="13%">hasChildren</TD>
		<TD WIDTH="12%">1</TD>
		<TD WIDTH="50%">Do you have any children?</TD>
		<TD WIDTH="25%">yes=1,no=0</TD>
	</TR>
	<TR>

		<TD WIDTH="13%">numChildren</TD>
		<TD WIDTH="12%">hasChildren==1</TD>
		<TD WIDTH="50%">How many children do you have?</TD>
		<TD WIDTH="25%">number</TD>
	</TR>
	<TR>
		<TD WIDTH="13%">hasJob</TD>

		<TD WIDTH="12%">1</TD>
		<TD WIDTH="50%">Do you have a job?</TD>
		<TD WIDTH="25%">yes=1,no=0</TD>
	</TR>
</TABLE>
</P>

<P><A NAME="questionOrEvalTypeField"></A><B><I>questionOrEvalTypeField</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">

	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>
	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>

		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%"><I><A HREF="#questionOrEvalType">questionOrEvalType</A></I><B>;</B><I><A HREF="#dataType">dataType</A></I><B>;</B><I><A
			HREF="#min">min</A></I><B>;</B><I><A HREF="#max">max</A></I><B>;</B><I><A HREF="#formatMask">formatMask</A></I>;<A
			HREF="#extraAllowableValues">extraAllowableValues</A></TD>
	</TR>

</TABLE>


<BLOCKQUOTE>
	<P><A NAME="questionOrEvalType"></A><I>questionOrEvalType</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>

		</TR>
		<TR>
			<TD WIDTH="7%"><B>yes</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%">one of the following:</TD>
		</TR>
	</TABLE>

	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="16%">questionOrEvalType</TD>
			<TD WIDTH="84%">Meaning</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>q</B></TD>

			<TD WIDTH="84%">display information (e.g. a question), and optionally request a response</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>e</B></TD>
			<TD WIDTH="84%">evaluate an <I><A HREF="#Equation">equation</A></I></TD>
		</TR>
		<TR>

			<TD WIDTH="16%"><B>[</B></TD>
			<TD WIDTH="84%">start a display group, and treat this node as a <B>q</B>. The display group may not contain nested <B>e</B> <I><A
				HREF="#Equation">equations</A></I></TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B><FONT SIZE="4">]</FONT></B></TD>

			<TD WIDTH="84%">stop a display group, and treat this node as a <B>q</B>.</TD>
		</TR>
	</TABLE>
</P>
	<P><A NAME="dataType"></A><I>dataType</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>

			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>no</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%">one of the following. If not set, then implicitly the default dataType from <B><I>answerChoices</I></B></TD>

		</TR>
	</TABLE>

	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="16%">dataType</TD>
			<TD WIDTH="84%">Meaning</TD>
		</TR>

		<TR>
			<TD WIDTH="16%"><B>number</B></TD>
			<TD WIDTH="84%">a decimal number</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>string</B></TD>
			<TD WIDTH="84%">any text</TD>

		</TR>
		<TR>
			<TD WIDTH="16%"><B>date</B></TD>
			<TD WIDTH="84%">year/month/day - default format is <I>MM/dd/yyyy</I> (e.g. 07/04/2000)</TD>
		</TR>
		<TR>

			<TD WIDTH="16%"><B>time</B></TD>
			<TD WIDTH="84%">hour/minute/second - default format is <I>HH:mm:ss</I> (e.g. 17:30:00)</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>year</B></TD>
			<TD WIDTH="84%">year - default format is <I>yyyy</I> (e.g. 1984)</TD>

		</TR>
		<TR>
			<TD WIDTH="16%"><B>month</B></TD>
			<TD WIDTH="84%">month - default format is <I>MMMM</I> (e.g. February)</TD>
		</TR>
		<TR>

			<TD WIDTH="16%"><B>day</B></TD>
			<TD WIDTH="84%">day - default format is <I>d</I> (e.g. 4)</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>weekday</B></TD>
			<TD WIDTH="84%">weekday - default format is <I>E</I> (e.g. Fri)</TD>

		</TR>
		<TR>
			<TD WIDTH="16%"><B>hour</B></TD>
			<TD WIDTH="84%">hour - default format is <I>H</I> (e.g. 17)</TD>
		</TR>
		<TR>

			<TD WIDTH="16%"><B>minute</B></TD>
			<TD WIDTH="84%">minute - default format is <I>m</I> (e.g. 10)</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>second</B></TD>
			<TD WIDTH="84%">second - default format it <I>s</I> (e.g. 35)</TD>

		</TR>
		<TR>
			<TD WIDTH="16%"><B>month_num</B></TD>
			<TD WIDTH="84%">month as number - default format is <I>M</I> (e.g. 7)</TD>
		</TR>
		<TR>

			<TD WIDTH="16%"><B>*</B><A NAME="INVALID"></A><B>INVALID*</B></TD>
			<TD WIDTH="84%">special datatype indicating a data error (e.g. multiplying a <I>string</I> by a <I>number</I>)</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>*</B><A NAME="UNASKED"></A><B>UNASKED*</B></TD>

			<TD WIDTH="84%">special datatype indicating that a node's questionOrEval has not yet been &quot;asked&quot;</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>*</B><A NAME="UNKNOWN"></A><B>UNKNOWN*</B></TD>
			<TD WIDTH="84%">special datatype indicating that the subject does not know the answer to a question</TD>
		</TR>

		<TR>
			<TD WIDTH="16%"><B>*</B><A NAME="REFUSED"></A><B>REFUSED*</B></TD>
			<TD WIDTH="84%">special datatype indicating that the subject refused to answer a question</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>*</B><A NAME="NA"></A><B>NA*</B></TD>

			<TD WIDTH="84%">special datatype indicating that the questionOrEval should not be asked (e.g. men should not be asked about menstruation)</TD>
		</TR>
		<TR>
			<TD WIDTH="16%"><B>*</B><A NAME="HUH"></A><B>HUH*</B></TD>
			<TD WIDTH="84%">special datatype indicating that the subject did not understand the question (e.g. language barriers)</TD>
		</TR>
	</TABLE>

</P>
	<P><A NAME="min"></A><I>min</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>

		<TR>
			<TD WIDTH="7%"><B>no</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%">a variable name, number, or string (in quotes)</TD>
		</TR>
	</TABLE>
</P>
	<P><A NAME="max"></A><I>max</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">

		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>no</B></TD>

			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%">a variable name, number, or string (in quotes)</TD>
		</TR>
	</TABLE>
</P>
	<P><A NAME="formatMask"></A><I>formatMask</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>

			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>no</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>

			<TD WIDTH="87%">a valid SimpleDateFormat or DecimalFormat string, as per Java specifications. Examples are seen under <I><A HREF="#dataType">dataType</A></I>.</TD>
		</TR>
	</TABLE>
</P>

	<P><A NAME="extraAllowableValues"></A><I>extraAllowableValues</I></P>

	<P>

	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>

			<TD WIDTH="7%"><B>no</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%">value ; [value] (e.g. 77;88;99)</TD>
		</TR>
	</TABLE>

</BLOCKQUOTE>

<P><A NAME="readback"></A><B><I>readback</I></B> 

<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>
	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>

		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">a <I>string</I> - substitution is applied to the readback. This field is accessed by the <I><A HREF="#description">desc</A>()</I>
			function (short for <I>description</I>)</TD>
	</TR>

</TABLE>
</P>
<P><A NAME="questionOrEval"></A><B><I>questionOrEval</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>
	</TR>

	<TR>
		<TD WIDTH="7%"><B>yes</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">if questionOrEvalType == 'e', then use <I><A HREF="#evalSyntax">evalSyntax</A><BR>
			</I>otherwise, use <I><A HREF="#questionSyntax">questionSyntax</A></I></TD>
	</TR>

</TABLE>
</P>

<BLOCKQUOTE>
	<P><A NAME="questionSyntax"></A><I>questionSyntax</I></P>
	<P>
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>

			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>yes</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%"><I>Question</I>: a <I>string</I>, which can contain embedded HTML tags (&lt;b&gt;&lt;/b&gt;, &lt;i&gt;&lt;/i&gt;,
				&lt;u&gt;&lt;/u&gt;, &lt;br&gt;, etc.), as well as embedded <I><A HREF="#Equation">equations</A></I>, surrounded
				by back-ticks (e.g. `5 + 3`). Substitution is performed on these questions.</TD>

		</TR>
	</TABLE>
</P>
	<P><A NAME="evalSyntax"></A><I>evalSyntax</I></P>
	<P>
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>

			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>yes</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%"><I><A HREF="#Equation">Equations</A></I>: these are <I>not</I> surrounded by back-ticks.</TD>

		</TR>
	</TABLE>
</P>
</BLOCKQUOTE>

<P><A NAME="answerChoices"></A><B><I>answerChoices</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>

		<TD WIDTH="87%">Syntax</TD>
	</TR>
	<TR>
		<TD WIDTH="7%"><B>yes</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%"><I><A HREF="#answerType">answerType</A></I><B>|</B><I><A HREF="#value">value1</A>|<A HREF="#msg">msg1</A>|<A HREF="#value">value2</A>|<A
			HREF="#msg">msg2</A>;...</I></TD>

	</TR>
</TABLE>


<BLOCKQUOTE>
	<P><A NAME="answerType"></A><I>answerType</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>

			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>yes</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%">one of the following:</TD>
		</TR>

	</TABLE>

	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="9%">answerType</TD>
			<TD WIDTH="11%">defaultDataType</TD>
			<TD WIDTH="64%">Meaning</TD>
			<TD WIDTH="16%">use value|msg pairs?</TD>

		</TR>
		<TR>
			<TD WIDTH="9%"><B>nothing</B></TD>
			<TD WIDTH="11%"><B>string (blank)</B></TD>
			<TD WIDTH="64%">display the question, but don't collect any information</TD>
			<TD WIDTH="16%">no</TD>
		</TR>

		<TR>
			<TD WIDTH="9%"><B>radio</B></TD>
			<TD WIDTH="11%"><B><I>string</I></B></TD>
			<TD WIDTH="64%">display value|msg pairs using radio buttons; collect value associated with selected msg</TD>
			<TD WIDTH="16%"><B>yes</B></TD>
		</TR>
		<TR>

			<TD WIDTH="9%"><B>check</B></TD>
			<TD WIDTH="11%"><B>string</B></TD>
			<TD WIDTH="64%">display value|msg pairs using check boxes; collect values associated with selected msgs</TD>
			<TD WIDTH="16%"><B>yes</B></TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>combo</B></TD>

			<TD WIDTH="11%"><B>string</B></TD>
			<TD WIDTH="64%">display value|msg pairs using a combo box; collect value associated with selected msg</TD>
			<TD WIDTH="16%"><B>yes</B></TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>list</B></TD>
			<TD WIDTH="11%"><B>string</B></TD>

			<TD WIDTH="64%">display value|msg pairs using a list box (max of 20 lines); collect value associated with selected msg</TD>
			<TD WIDTH="16%"><B>yes</B></TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>text</B></TD>
			<TD WIDTH="11%"><B>string</B></TD>
			<TD WIDTH="64%">display a text entry box; collect entered <I>string</I></TD>

			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>double</B></TD>
			<TD WIDTH="11%"><B>number</B></TD>
			<TD WIDTH="64%">display a text entry box; collect entered <I>number</I></TD>

			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>radio2</B></TD>
			<TD WIDTH="11%"><B>string</B></TD>
			<TD WIDTH="64%">display value|msg pairs using radio buttons horizontally on next row; collect value associated with selected msg</TD>
			<TD WIDTH="16%"><B>yes</B></TD>

		</TR>
		<TR>
			<TD WIDTH="9%"><B>password</B></TD>
			<TD WIDTH="11%"><B>string</B></TD>
			<TD WIDTH="64%">display password entry box; collect entered <I>string</I></TD>
			<TD WIDTH="16%">no</TD>

		</TR>
		<TR>
			<TD WIDTH="9%"><B>memo</B></TD>
			<TD WIDTH="11%"><B>string</B></TD>
			<TD WIDTH="64%">display multi-line text entry box; collect selected <I>string</I></TD>
			<TD WIDTH="16%">no</TD>

		</TR>
		<TR>
			<TD WIDTH="9%"><B>date</B></TD>
			<TD WIDTH="11%"><B>date</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered date (e.g. 07/04/1942)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>

		<TR>
			<TD WIDTH="9%"><B>time</B></TD>
			<TD WIDTH="11%"><B>time</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered time (e.g. 14:25:37)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>

			<TD WIDTH="9%"><B>year</B></TD>
			<TD WIDTH="11%"><B>year</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered year (e.g. 1937)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>month</B></TD>

			<TD WIDTH="11%"><B>month</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered month (e.g. July)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>day</B></TD>
			<TD WIDTH="11%"><B>day</B></TD>

			<TD WIDTH="64%">display text entry box; collect entered day (e.g. 25)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>weekday</B></TD>
			<TD WIDTH="11%"><B>weekday</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered weekday (e.g. Fri)</TD>

			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>
			<TD WIDTH="9%"><B>hour</B></TD>
			<TD WIDTH="11%"><B>hour</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered hour (e.g. 15)</TD>
			<TD WIDTH="16%">no</TD>

		</TR>
		<TR>
			<TD WIDTH="9%"><B>minute</B></TD>
			<TD WIDTH="11%"><B>minute</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered minute (e.g. 10)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>

		<TR>
			<TD WIDTH="9%"><B>second</B></TD>
			<TD WIDTH="11%"><B>second</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered second (e.g. 37)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>
		<TR>

			<TD WIDTH="9%"><B>month_num</B></TD>
			<TD WIDTH="11%"><B>month_num</B></TD>
			<TD WIDTH="64%">display text entry box; collect entered month as number (e.g. 7)</TD>
			<TD WIDTH="16%">no</TD>
		</TR>
	</TABLE>
</P>

	<P><A NAME="value"></A><I>value1...n</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>
			<TD WIDTH="87%">Syntax</TD>
		</TR>

		<TR>
			<TD WIDTH="7%"><B>yes</B></TD>
			<TD WIDTH="6%"><B>yes</B></TD>
			<TD WIDTH="87%"><I><A HREF="#Equation">equation</A></I> (no two <I>values</I> for a given node can be the same). If multiple languages
				are used, the system will check to make sure that each language has the same number of value|msg pairs, and that
				the order of values is the same.  Since this is an <A HREF="#Equation">equation</A>, it can refer to other variables,
				or be calculated; and it must not include back-ticks.  If you want the stored value to be a string, it needs to
				be surrounded by double quotes.  Numerical values can be listed as-is.</TD>

		</TR>
	</TABLE>
</P>
	<P><A NAME="msg"></A><I>msg1...n</I> 
	<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="90%">
		<TR>
			<TD WIDTH="7%">Required?</TD>
			<TD WIDTH="6%">Unique?</TD>

			<TD WIDTH="87%">Syntax</TD>
		</TR>
		<TR>
			<TD WIDTH="7%"><B>yes</B></TD>
			<TD WIDTH="6%"><B>no</B></TD>
			<TD WIDTH="87%"><I>string</I> - the msg is parsed to substitute&nbsp;equations (e.g. this can contain back-ticked <A HREF="#Equation">equations</A>)</TD>

		</TR>
	</TABLE>

</BLOCKQUOTE>

<P><A NAME="helpURL"></A><B><I>helpURL</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>

		<TD WIDTH="87%">Syntax</TD>
	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">a valid URL. No substitution is performed.  If present, this will appear as a help-icon to the right of the question.</TD>
	</TR>

</TABLE>
</P>
<P><A NAME="languageNum"></A><B><I>languageNum</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>
	</TR>

	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">Dialogix sets this value when the node is processed. This <I>number</I> value is the language used when asking
			a question. The valid range is 0 - (numLanguages-1).  This refers to the <A HREF="#__LANGUAGES__">__LANGUAGES__</A>
			option.</TD>

	</TR>
</TABLE>
</P>

<P><A NAME="questionAsAsked"></A><B><I>questionAsAsked</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>

	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">Dialogix sets this value when the node is processed. This <I>string</I> value is the question exactly as it appeared
			to the subject - in the selected language, and with the appropriate substitutions.</TD>
	</TR>

</TABLE>
</P>

<P><A NAME="answerGiven"></A><B><I>answerGiven</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>

	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">Dialogix sets this value when the node is processed. This <I>string</I> value is the data entered by the subject.</TD>
	</TR>

</TABLE>
</P>

<P><A NAME="defaultAnswer"></A><B><I>defaultAnswer</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>

	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">If this value is present when the instrument is first loaded, it is stored as the default value for the node. 
			However, if the &quot;startFresh&quot; option is pressed, this value is not re-loaded.  You would need to re-load
			the instrument to reset </TD>
	</TR>

</TABLE>
</P>

<P><A NAME="comment"></A><B><I>comment</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>

	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">Dialogix sets this value when the node is processed. This <I>string</I> value is the optional comment entered by
			the interviewee via the Comment popup.</TD>
	</TR>

</TABLE>
</P>

<P><A NAME="timeStamp"></A><B><I>timeStamp</I></B> 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="7%">Required?</TD>
		<TD WIDTH="6%">Unique?</TD>
		<TD WIDTH="87%">Syntax</TD>

	</TR>
	<TR>
		<TD WIDTH="7%"><B>no</B></TD>
		<TD WIDTH="6%"><B>no</B></TD>
		<TD WIDTH="87%">Dialogix sets this value when the node is processed. This numbeical value is the number of milliseconds since 1/1/1970</TD>
	</TR>
</TABLE>
</P>

<P><B><I>dataType</I></B></P>

<P><A NAME="ReservedVariableName"></A><B><I>ReservedVariableName</I></B></P>
<P>All ReservedVariableNames are in upper case, and begin and end with two underscores ('__') 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="30%"><B>reservedVariableName</B></TD>
		<TD WIDTH="9%"><B>Syntax</B></TD>
		<TD WIDTH="61%"><B>meaning</B></TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__ACTIVE_BUTTON_PREFIX__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the prefix of the string that wraps a button when the button is active (e.g. &lt;&lt;)</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__ACTIVE_BUTTON_SUFFIX__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the prefix of the string that wraps a button when the button is active (e.g. &gt;&gt;)</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__ALLOW_COMMENTS__</TD>

		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the comment icon is available</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__ALLOW_DONT_UNDERSTAND__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the icon for *HUH* is available</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__ALLOW_JUMP_TO__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the jump_to button is available, even in non-Developer mode</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__ALLOW_LANGUAGE_SWITCHING__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then allows switching among languages</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__ALLOW_REFUSED__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>

		<TD WIDTH="61%">if true, then the icon for *REFUSED* is available</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__ALLOW_UNKNOWN__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the icon for *UNKNOWN* is available</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__ALWAYS_SHOW_ADMIN_ICONS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the administrator icons (comment, refused, etc.) are always visible</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__ANSWER_OPTION_FIELD_WIDTH__</TD>

		<TD WIDTH="9%"><I>number</I></TD>
		<TD WIDTH="61%">the default width of text and menu boxes</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__AUTOGEN_OPTION_NUM__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then lists of of options (combo, list) will use sequential numbers (starting from 1), as their accelerator
			keys. If false, then the internal values associated with the displayed choices will be used as the accelerator
			keys</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__BROWSER_TYPE__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">[this is writtent to the data file the first time an instrument is loaded]</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__COMMENT_ICON_OFF__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the icon to use to indicate that there is <I>no</I> comment</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__COMMENT_ICON_ON__</TD>

		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the icon to use to indicate that there <I>is</I> a comment</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__COMPLETED_DIR__</TD>
		<TD WIDTH="9%"><I>dir</I></TD>

		<TD WIDTH="61%">[this is set internally by Dialogix]</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__CONNECTION_TYPE__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">HTTP or HTTPS</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__CURRENT_LANGUAGE__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the language abbreviation</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__DEBUG_MODE__</TD>

		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then display the debugging information</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__DEVELOPER_MODE__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then display the developer mode information and buttons</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__DISPLAY_COUNT__</TD>
		<TD WIDTH="9%"><I>number</I></TD>
		<TD WIDTH="61%">[this is set internally by Dialogix - it reflects the number of screens the subject has seen]</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__DISALLOW_COMMENTS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the comment icons are never visible, even if the other administrator icons are visible</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__DONT_UNDERSTAND_ICON_OFF__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>

		<TD WIDTH="61%">the icon to use to indicate that the subject did understand the question</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__DONT_UNDERSTAND_ICON_ON__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the icon to use to show that the subject <I>did not</I> understand the question</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__FILENAME__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the name of the <B><I><A HREF="#DataFile">dataFile</A></I></B> to be saved in the <B><I><A HREF="#workingDir">workingDirectory</A></I></B></TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__FLOPPY_DIR__</TD>
		<TD WIDTH="9%"><I>dir</I></TD>
		<TD WIDTH="61%">the directory of an secondary drive to which the completed datafiles are written. Alternatively, this can be a
			shared server drive, or nothing.</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__HEADER_MSG__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the message to be displayed to the right of the __ICON__</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__HELP_ICON__</TD>
		<TD WIDTH="9%"><I>URL</I></TD>

		<TD WIDTH="61%">the filename for the help icon</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__ICON__</TD>
		<TD WIDTH="9%"><I>URL</I></TD>
		<TD WIDTH="61%">the filename for the logo icon</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__IMAGE_FILES_DIR__</TD>
		<TD WIDTH="9%"><I>dir</I></TD>
		<TD WIDTH="61%">[this is set internally by Dialogix. It is the directory for the icons (so that don't need full path name)]</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__IP_ADDRESS__</TD>

		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">[this is written to the data file the when the instrument is first loaded]</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__JUMP_TO_FIRST_UNASKED__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the jump-to-first-unasked button is always available</TD>

	</TR>
	<TR>
		<TD WIDTH="30%"><A NAME="__LANGUAGES__"></A>__LANGUAGES__</TD>
		<TD WIDTH="9%"><I>string|string|...</I></TD>
		<TD WIDTH="61%">a list of language names, separated by the pipe ('|') character. For example <B>en_US|es_PR</B></TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__LOADED_FROM__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the location of the schedule file</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__PASSWORD_FOR_ADMIN_MODE__</TD>
		<TD WIDTH="9%"><I>string</I></TD>

		<TD WIDTH="61%">an optional password to enable access to the Developer mode</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__REFUSED_ICON_OFF__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the icon to use to indicate that the subject did not refuse to answer the question</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__REFUSED_ICON_ON__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the icon to use to indicate that the subject <I>did</I> refuse to answer the question</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__RECORD_EVENTS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if false, then events are not recorded.  Defaults to <I>true</I></TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__REDIRECT_ON_FINISH_MSG__</TD>

		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">If not empty, users will see this string after completing an interview to indicate that they will be re-directed
			to another site</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__REDIRECT_ON_FINISH_URL__</TD>
		<TD WIDTH="9%"><I>URL</I></TD>
		<TD WIDTH="61%">If not empty, users will be re-directed to this site 5 seconds after completing an interview</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__SCHED_AUTHORS__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">an optional string to indicate who authored the schedule - a way to give appropriate credit the those who originally
			created the instrument, and/or who transcribed it into Dialogix form</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__SCHED_HELP_URL__</TD>
		<TD WIDTH="9%"><I>URL</I></TD>
		<TD WIDTH="61%">an optional URL for the main help for the instrument</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__SCHED_VERSION_MAJOR__</TD>
		<TD WIDTH="9%"><I>string</I></TD>

		<TD WIDTH="61%">a way to track the revisions in the schedule</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__SCHED_VERSION_MINOR__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">a way to track the revisions in the schedule</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__SCHEDULE_DIR__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">[this is set internally by Dialogix - it is the directory of where all of the schedules are located]</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__SCHEDULE_SOURCE__</TD>

		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the name of the schedule file</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__SET_DEFAULT_FOCUS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the focus will automatically be set to the first data entry element or button.  If there will be
			many lengthly instructions screens, this can be set to false so that the browser does not scroll to the &quot;next&quot;

			button at the bottom  of the screen.</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__SHOW_ADMIN_ICONS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, the pressing the admin icon allows admin mode to be entered</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__SHOW_QUESTION_REF__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the value for <B><I><A HREF="#externalName">externalName</A></I></B> will be shown as the first column
			of the table of questions asked.</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__SHOW_SAVE_TO_FLOPPY_IN_ADMIN_MODE__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the &quot;save-to-floppy&quot; button will be visible in admin mode</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__START_TIME__</TD>

		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the time that the interview was started, in milliseconds since Jan 1, 1900</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__STARTING_STEP__</TD>
		<TD WIDTH="9%"><I>number</I></TD>
		<TD WIDTH="61%">the index of the first node (after the reserved variables and comments)</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__SUSPEND_TO_FLOPPY__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the &quot;save-to-floppy&quot; button will be visible all the time</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__SWAP_NEXT_AND_PREVIOUS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, the then &quot;next&quot; button will be to the right of the &quot;previous&quot; button</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__TITLE__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the message to display on the web-browser title bar</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__TITLE_FOR_PICKLIST_WHEN_IN_PROGRESS__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">the descriptive name that will appear in the dropdown combobox on the splash screen for those files currently in
			the <B><I><A HREF="#workingDir">workingDirectory</A></I></B>. Files in the <B><I><A HREF="#scheduleSrcDir">scheduleSrcDir</A></I></B>
			are descriptively shown by their Title, and the available language options (if more than one)</TD>
	</TR>

	<TR>
		<TD WIDTH="30%">__TRICEPS_FILE_TYPE__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">either SCHEDULE or DATA</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__TRICEPS_VERSION_MAJOR__</TD>

		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">to track revisions of Dialogix - e.g. 2.8</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__TRICEPS_VERSION_MINOR__</TD>
		<TD WIDTH="9%"><I>string</I></TD>
		<TD WIDTH="61%">to track the revisions of Dialogix - e.g. 1</TD>

	</TR>
	<TR>
		<TD WIDTH="30%">__UNKNOWN_ICON_OFF__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the name of the icon to show when the subject does know the answer</TD>
	</TR>
	<TR>

		<TD WIDTH="30%">__UNKNOWN_ICON_ON__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>
		<TD WIDTH="61%">the name of the icon to show when the subject does not know the answer</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__WORKING_DIR__</TD>
		<TD WIDTH="9%"><I>filename</I></TD>

		<TD WIDTH="61%">[this is set internally by Dialogix - it is the directory where temporary data files are stored]</TD>
	</TR>
	<TR>
		<TD WIDTH="30%">__WRAP_ADMIN_ICONS__</TD>
		<TD WIDTH="9%"><I>true|false</I></TD>
		<TD WIDTH="61%">if true, then the admin icons that appear to the right of a question will be word-wrapped.  This is helpful when
			the icons are large and textual.</TD>
	</TR>

</TABLE>
</P>
<P><A NAME="InitializationVariables"></A><B><I>InitializationVariables</I></B></P>

<P>These variables are set once when Dialogix loads. They are not available for change by the user. 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0">
	<TR>
		<TD WIDTH="30%">InitializationVariables</TD>
		<TD WIDTH="21%">Syntax</TD>
		<TD WIDTH="49%">meaning</TD>

	</TR>
	<TR>
		<TD WIDTH="30%"><B>dialogix.dir</B></TD>
		<TD WIDTH="21%">directory</TD>
		<TD WIDTH="49%">canonical directory that acts as prefix for relative directories listed below</TD>
	</TR>
	<TR>

		<TD WIDTH="30%"><A NAME="scheduleSrcDir"></A><B>scheduleSrcDir</B></TD>
		<TD WIDTH="21%">URL or filename prefix</TD>
		<TD WIDTH="49%">canonical or relative directory where instrument files are located</TD>
	</TR>
	<TR>
		<TD WIDTH="30%"><A NAME="workingDir"></A><B>workingDir</B></TD>
		<TD WIDTH="21%">directory</TD>

		<TD WIDTH="49%">canonical or relative directory where working files are to be stored</TD>
	</TR>
	<TR>
		<TD WIDTH="30%"><A NAME="completedDir"></A><B>completedDir</B></TD>
		<TD WIDTH="21%">directory</TD>
		<TD WIDTH="49%">canonical or relative directory where completed files are stored.</TD>
	</TR>

	<TR>
		<TD WIDTH="30%"><A NAME="floppyDir"></A><B>floppyDir</B></TD>
		<TD WIDTH="21%">directory</TD>
		<TD WIDTH="49%">another directory where completed files are stored</TD>
	</TR>
	<TR>
		<TD WIDTH="30%"><A NAME="imageFilesDir"></A><B>imageFilesDir</B></TD>

		<TD WIDTH="21%">URL or directory</TD>
		<TD WIDTH="49%">prefix of image and ICON files</TD>
	</TR>
	<TR>
		<TD WIDTH="30%"><A NAME="helpIcon"></A><B>helpIcon</B></TD>
		<TD WIDTH="21%">filename</TD>
		<TD WIDTH="49%">name of the help icon</TD>

	</TR>
	<TR>
		<TD WIDTH="30%"><A NAME="logoIcon"></A><B>logoIcon</B></TD>
		<TD WIDTH="21%">filename</TD>
		<TD WIDTH="49%">name of default logo icon</TD>
	</TR>
	<TR>

		<TD WIDTH="30%"><A NAME="helpURL1"></A><B>helpURL</B></TD>
		<TD WIDTH="21%">URL</TD>
		<TD WIDTH="49%">name of default help URL</TD>
	</TR>
	<TR>
		<TD WIDTH="30%"><B>displayWorking</B></TD>
		<TD WIDTH="21%"><I>true|false</I></TD>

		<TD WIDTH="49%">whether the RESTORE option is visible.  Normally this is disabled in the web-server version; but there are rare
			cases where this should be visible</TD>
	</TR>
</TABLE>
</P>

<P><A NAME="Equation"></A><B><FONT SIZE="4">Equation Syntax</FONT></B></P>
<P><A NAME="Variable%20Names"></A><B>Variable Names</B></P>
<P>Valid names must conform to the XML NMTOKEN specification. Briefly, names can be any combination of letters,
digits, and underscores ('_'), periods ('.'), hyphens ('-'), and colons (':'), so long as the first character is
either a letter or underscore.<B> </B>This restriction ensures portability to XML and into relational databases.</P>

<P><B>Weak DataTyping</B></P>

<P>Dialogix tries to treat values as generically as possible. Variables can always be treated as <I>strings</I>.
They can also be treated as a <I>number</I>s if they can be successfully parsed as a <I>number</I>. Their Boolean
value is <I>true</I> if they are <I>numbers</I> with a non-zero value, otherwise the Boolean value is <I>false</I>

(e.g. if they are not <I>numbers</I>, if they have a numerical value of 0, or if they are one of the special datatypes).
Variables can also be treated as <I>date</I> or <I>time</I> values, but only if explicitly declared as such (otherwise
there is no way for Dialogix to guess whether a value of 10 is supposed to be a year, month, day, hour, etc.).</P>

<P><B>Operators</B></P>

<P>The following operators are available, and use the following precedence (top to bottom): 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>

		<TD WIDTH="33%">Name</TD>
		<TD WIDTH="25%">Syntax</TD>
		<TD WIDTH="42%">meaning</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">negation <BR>
			boolean not</TD>

		<TD WIDTH="25%">-X <BR>
			!X</TD>
		<TD WIDTH="42%">negative X (<I><A HREF="#INVALID">invalid</A></I> for <I>strings</I>) <BR>
			not X - the boolean</TD>

	</TR>
	<TR>
		<TD WIDTH="33%">multiply <BR>
			divide <BR>
			string concatenate</TD>
		<TD WIDTH="25%">X * Y <BR>
			X / Y <BR>

			X . Y</TD>
		<TD WIDTH="42%">X times Y (<I><A HREF="#INVALID">invalid</A></I> for <I>strings</I>) <BR>
			X divided by Y (<I><A HREF="#INVALID">invalid</A></I> for <I>strings</I>) <BR>

			Y appended string-wise to X (e.g. 5 . 6 = 56)</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">add <BR>
			subtract</TD>
		<TD WIDTH="25%">X + Y <BR>
			X - Y</TD>

		<TD WIDTH="42%">X plus Y (<I><A HREF="#INVALID">invalid</A></I> for <I>strings</I>) <BR>
			X minus Y (<I><A HREF="#INVALID">invalid</A></I> for <I>strings</I>)</TD>
	</TR>

	<TR>
		<TD WIDTH="33%">greater than <BR>
			greater than or equal to <BR>
			less than <BR>
			less than or equal to</TD>
		<TD WIDTH="25%">X &gt; Y <BR>

			X &gt;= Y <BR>
			X &lt; Y <BR>
			X &lt;= Y</TD>
		<TD WIDTH="42%">is X greater than Y? <BR>
			is X greater than or equal to Y? <BR>

			is X less than Y? <BR>
			is X less than or equal to Y?</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">equality <BR>
			inequality</TD>
		<TD WIDTH="25%">X == Y <BR>

			X != Y</TD>
		<TD WIDTH="42%">does X equal Y? <BR>
			does X not equal Y?</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">binary AND</TD>
		<TD WIDTH="25%">X &amp; Y</TD>

		<TD WIDTH="42%">&nbsp;</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">binary inclusive OR</TD>
		<TD WIDTH="25%">X | Y</TD>
		<TD WIDTH="42%">&nbsp;</TD>
	</TR>
	<TR>

		<TD WIDTH="33%">binary exclusive OR</TD>
		<TD WIDTH="25%">X ^ Y</TD>
		<TD WIDTH="42%">&nbsp;</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">logical AND</TD>
		<TD WIDTH="25%">X &amp;&amp; Y</TD>

		<TD WIDTH="42%">&nbsp;</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">logical OR</TD>
		<TD WIDTH="25%">X || Y</TD>
		<TD WIDTH="42%">&nbsp;</TD>
	</TR>
	<TR>

		<TD WIDTH="33%">conditional</TD>
		<TD WIDTH="25%">(X) ? T : F</TD>
		<TD WIDTH="42%">if X is true, then select T, else select F</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">assignment</TD>
		<TD WIDTH="25%">X = Y</TD>

		<TD WIDTH="42%">assign the value of Y to the variable X</TD>
	</TR>
	<TR>
		<TD WIDTH="33%">equation separators</TD>
		<TD WIDTH="25%">E1, E2 <BR>
			E1; E2</TD>
		<TD WIDTH="42%">first evaluate equation E1, then evaluate equation E2</TD>

	</TR>
</TABLE>
</P>
<P><A NAME="Functions"></A><B>Functions</B></P>
<P>
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="15%"><B>Name</B></TD>
		<TD WIDTH="15%"><B>Syntax</B></TD>
		<TD WIDTH="60%"><B>Description</B></TD>

	</TR>
	<TR>
		<TD WIDTH="15%">abs</TD>
		<TD WIDTH="15%">abs(X)</TD>
		<TD WIDTH="60%">returns the absolute value of X</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">acos</TD>
		<TD WIDTH="15%">acos(X)</TD>
		<TD WIDTH="60%">returns the arc cosine of X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">asin</TD>
		<TD WIDTH="15%">asin(X)</TD>

		<TD WIDTH="60%">returns the arc sine of X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">atan</TD>
		<TD WIDTH="15%">atan(X)</TD>
		<TD WIDTH="60%">returns the arc tangent of X</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">atan2</TD>
		<TD WIDTH="15%">atan2(X,Y)</TD>
		<TD WIDTH="60%">returns the arc tangent of (X,Y)</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">ceil</TD>

		<TD WIDTH="15%">ceil(X)</TD>
		<TD WIDTH="60%">returns the ceiling of X (round number to next larger integer)</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">charAt</TD>
		<TD WIDTH="15%">charAt(X,Y)</TD>
		<TD WIDTH="60%">returns the character at the Yth position in string X, where the first position is 0</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">compareTo</TD>
		<TD WIDTH="15%">compareTo(X,Y)</TD>
		<TD WIDTH="60%">lexically compares two strings. If they are equal, returns 0. If X is less than Y, returns -1. If X is greater
			than Y, returns 1</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">compareToIgnoreCase</TD>
		<TD WIDTH="15%">compareToIgnoreCase(X,Y)</TD>
		<TD WIDTH="60%">like compareTo(), but ignores case</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">cos</TD>
		<TD WIDTH="15%">cos(X)</TD>

		<TD WIDTH="60%">returns the cosine of X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">count</TD>
		<TD WIDTH="15%">count(X,...)</TD>
		<TD WIDTH="60%">the number of positive values</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">createTempFile</TD>
		<TD WIDTH="15%">createTempFile()</TD>
		<TD WIDTH="60%">returns a new tempory, but unique, filename</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">desc</TD>

		<TD WIDTH="15%">desc(X)</TD>
		<TD WIDTH="60%">the language-specific <A HREF="#readback">readback</A> string for a node.</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">e</TD>
		<TD WIDTH="15%">e()</TD>

		<TD WIDTH="60%">returns the value <I>e</I></TD>
	</TR>
	<TR>
		<TD WIDTH="15%">endsWith</TD>
		<TD WIDTH="15%">endsWith(X,Y)</TD>
		<TD WIDTH="60%">returns true if string X ends with string Y</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">eraseData</TD>
		<TD WIDTH="15%">eraseData()</TD>
		<TD WIDTH="60%">reset all of the data to *unasked*</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">exec</TD>
		<TD WIDTH="15%">exec(X)</TD>
		<TD WIDTH="60%">runs the external function X -- this does not currently work properly on all platorms</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">exp</TD>
		<TD WIDTH="15%">exp(X)</TD>

		<TD WIDTH="60%">return the value of exp(X)</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">fileExists</TD>
		<TD WIDTH="15%">fileExists(X)</TD>
		<TD WIDTH="60%">returns true of the file X exists.  Canonical names can be used by adding `__WORKING_DIR__` or other prefixes</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">floor</TD>
		<TD WIDTH="15%">floor(X)</TD>
		<TD WIDTH="60%">returns the floor of X (round number to next smaller integer)</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">formatDate</TD>

		<TD WIDTH="15%">formatDate(X,PAT)</TD>
		<TD WIDTH="60%">return the string value of date X formatted according to Java data format pattern PAT</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">formatNumber</TD>
		<TD WIDTH="15%">formatNumber(X,PAT)</TD>
		<TD WIDTH="60%">return the string value of number X formatted according to Java number format pattern PAT</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">getActionText</TD>
		<TD WIDTH="15%">getActionText(X)</TD>
		<TD WIDTH="60%">return the actionText for node named X -- this lets one access the text of a previously asked question (e.g. for
			generating a report)</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">getAnsOption</TD>
		<TD WIDTH="15%">getAnsOption(X)<BR>
			getAnsOption(X,Y)</TD>
		<TD WIDTH="60%">returns the text corresponding to the selected option for node X<BR>
			returns the text corresponding to the option at index Y of node X</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">getComment</TD>
		<TD WIDTH="15%">getComment(X)</TD>
		<TD WIDTH="60%">returns the comment for node X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">getConcept</TD>

		<TD WIDTH="15%">getConcept(X)</TD>
		<TD WIDTH="60%">returns the concept field for node X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">getDependencies</TD>
		<TD WIDTH="15%">getDependencies(X)</TD>
		<TD WIDTH="60%">returns the relevance field for node X (this field was formerly called &quot;dependencies&quot;)</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">getExternalName</TD>
		<TD WIDTH="15%">getExternalName(X)</TD>
		<TD WIDTH="60%">returns the external name field for node X -- this is usually the display name</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">getLocalName</TD>
		<TD WIDTH="15%">getLocalName(X)</TD>
		<TD WIDTH="60%">returns the internal, unique, variable name for node X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">getNow</TD>
		<TD WIDTH="15%">getNow()</TD>

		<TD WIDTH="60%">returns the date corresponding to the current system time (if the computer clock is accurate)</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">getStartTime</TD>
		<TD WIDTH="15%">getStartTime()</TD>
		<TD WIDTH="60%">returns the date corresponding to the system time when the interview was started</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">getType</TD>
		<TD WIDTH="15%">getType(X)</TD>
		<TD WIDTH="60%">returns the string name of the datatype - e.g. *NA* if isNA()</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">gotoFirst</TD>

		<TD WIDTH="15%">gotoFirst()</TD>
		<TD WIDTH="60%">jumps to the first node in the instrument -- this violates the normal flow of the system</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">gotoNext</TD>
		<TD WIDTH="15%">gotoNext()</TD>
		<TD WIDTH="60%">jumps to the next set of relevant nodes in the instrument -- this violates the normal flow of the system</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">gotoPrevious</TD>
		<TD WIDTH="15%">gotoPrevious()</TD>
		<TD WIDTH="60%">jumps to the previous set of relevant nodes to the instrumetn -- this violates the normal flow of the system</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">hasComment</TD>
		<TD WIDTH="15%">hasComment(X)</TD>
		<TD WIDTH="60%">returns true is node X has a comment</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">indexOf</TD>
		<TD WIDTH="15%">indexOf(X,Y)</TD>

		<TD WIDTH="60%">the first index (base 0) of string Y in string X. Returns -1 if Y is not contained within X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">isAnswered</TD>
		<TD WIDTH="15%">isAnswered(X)</TD>
		<TD WIDTH="60%">returns true if the answer is neither (*UNASKED* nor *INVALID*), and the is not empty if the answer is of type
			STRING</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">isAsked</TD>
		<TD WIDTH="15%">isAsked(X)</TD>
		<TD WIDTH="60%">returns true if the answer is neiter *NA*, *INVALID*, nor *UNASKED*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">isDate</TD>

		<TD WIDTH="15%">isDate(X)</TD>
		<TD WIDTH="60%">returns true if the answer happens to be a valid date</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">isInvalid</TD>
		<TD WIDTH="15%">isInvalid(X)</TD>
		<TD WIDTH="60%">returns true if the answer is of type *INVALID*</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">isNA</TD>
		<TD WIDTH="15%">isNA(X)</TD>
		<TD WIDTH="60%">returns true if the answer is of type *NA*</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">isNotUnderstood</TD>
		<TD WIDTH="15%">isNotUnderstood(X)</TD>
		<TD WIDTH="60%">returns true if the answer if of type *HUH*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">isNumber</TD>
		<TD WIDTH="15%">isNumber(X)</TD>

		<TD WIDTH="60%">returns true if the answer is a valid number</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">isRefused</TD>
		<TD WIDTH="15%">isRefused(X)</TD>
		<TD WIDTH="60%">returns true if the answer is of type *REFUSED*</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">isSpecial</TD>
		<TD WIDTH="15%">isSpecial(X)</TD>
		<TD WIDTH="60%">returns true if the answer is of type *UNASKED*, *NA*, *REFUSED*, *INVALID*, *UNKNOWN*, or *HUH*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">isUnknown</TD>

		<TD WIDTH="15%">isUnknown(X)</TD>
		<TD WIDTH="60%">returns true if the answer is of type *UNKNOWN*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">jumpTo</TD>
		<TD WIDTH="15%">jumpTo(X)</TD>
		<TD WIDTH="60%">jump to a named node -- this violates the normal flow of the system</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">jumpToFirstUnasked</TD>
		<TD WIDTH="15%">jumpToFirstUnasked()</TD>
		<TD WIDTH="60%">jump to the first unasked question -- thus bypassing previous answered questions -- this violates the norma flow
			of the system</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">lastIndexOf</TD>
		<TD WIDTH="15%">lastIndexOf(X,Y)</TD>
		<TD WIDTH="60%">returns the last index (base 0) of string Y in string X. Returns -1 if Y is not contained within X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">length</TD>
		<TD WIDTH="15%">length(X)</TD>

		<TD WIDTH="60%">returns the number of characters in string X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">list</TD>
		<TD WIDTH="15%">list(X,...)</TD>
		<TD WIDTH="60%">a <I>string</I> containing a comma separated list of the positive values with &quot;and&quot; separating the last
			two</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">log</TD>
		<TD WIDTH="15%">log(X)</TD>
		<TD WIDTH="60%">returns the natural log of X</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">max</TD>
		<TD WIDTH="15%">max(X,...)</TD>
		<TD WIDTH="60%">returns the maxium value of the list of values passed to the function</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">mean</TD>
		<TD WIDTH="15%">mean(X,...)</TD>

		<TD WIDTH="60%">returns the mean of a list of values</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">min</TD>
		<TD WIDTH="15%">min(X,...)</TD>
		<TD WIDTH="60%">returns the minimum value of the list of values passed to the function</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">newDate</TD>
		<TD WIDTH="15%">newDate(W)<BR>
			newDate(S,M)<BR>
			newDate(Y,M,D)</TD>
		<TD WIDTH="60%">returns a date corresponding to day of the week W (1 = Sunday, 2 = Monday, ...)<BR>

			returns a date corresponding to string S as parsed by date mask M<BR>
			returns a date corresponding to year Y, month M, and day D</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">newTime</TD>
		<TD WIDTH="15%">newTime(S,M)<BR>
			newTime(H,M,S)</TD>

		<TD WIDTH="60%">returns a date/time corresponding to string S as parsed by time mask M<BR>
			returns a date/time corresponding to hour H, minutes M, and seconds S</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">numAnsOptions</TD>
		<TD WIDTH="15%">numAnsOptions(X)</TD>
		<TD WIDTH="60%">returns the number of answer options that node X has</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">orlist</TD>
		<TD WIDTH="15%">orlist(X,...)</TD>
		<TD WIDTH="60%">a <I>string</I> containing a comma separated list of the positive values, with &quot;or&quot; separting the last
			two</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">parseDate</TD>
		<TD WIDTH="15%">parseDate(X,PAT)</TD>
		<TD WIDTH="60%">returns the date value of string X parsed with Java date format pattern PAT</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">parseNumber</TD>
		<TD WIDTH="15%">parseNumber(X,PAT)</TD>
		<TD WIDTH="60%">returns the numerical value of string X parsed with Java number format pattern PAT</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">pi</TD>
		<TD WIDTH="15%">pi()</TD>

		<TD WIDTH="60%">returns the value of <I>pi</I></TD>
	</TR>
	<TR>
		<TD WIDTH="15%">pow</TD>
		<TD WIDTH="15%">pow(X,Y)</TD>
		<TD WIDTH="60%">returns the value of X raised to the power of Y</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">random</TD>
		<TD WIDTH="15%">random()</TD>
		<TD WIDTH="60%">returns a random number -- the value is seeded based upon the starting time of the instrument</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">regexMatch</TD>
		<TD WIDTH="15%">regexMatch(X,Y)</TD>
		<TD WIDTH="60%">returns Boolean of whether string X matches the regular expression pattern Y</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">round</TD>
		<TD WIDTH="15%">round(X)</TD>

		<TD WIDTH="60%">returns the value of X rounded to the nearest whole integer</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">saveData</TD>
		<TD WIDTH="15%">saveData(X)</TD>
		<TD WIDTH="60%">saves all of the current Dialogix data for an instance to the file X, returning true if successful.  One commonly
			uses a temp file for this.  The two column, tab delimited file format has the variable name in the first column
			and the value in the second.  This does not work on all platforms.</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">sin</TD>
		<TD WIDTH="15%">sin(X)</TD>
		<TD WIDTH="60%">returns the sine of X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">sqrt</TD>

		<TD WIDTH="15%">sqrt(X)</TD>
		<TD WIDTH="60%">returns the square root of X</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">startsWith</TD>
		<TD WIDTH="15%">startsWith(X,Y)</TD>
		<TD WIDTH="60%">returns true if the string X starts with string Y</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">stddev</TD>
		<TD WIDTH="15%">stddev(X,...)</TD>
		<TD WIDTH="60%">returns the standard deviation of a list of values</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">substring</TD>
		<TD WIDTH="15%">substring(X,Y,Z)</TD>
		<TD WIDTH="60%">returns the part of string X that lies between indices Y and Z</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">suspendToFloppy</TD>
		<TD WIDTH="15%">suspendToFloppy()</TD>

		<TD WIDTH="60%">saves the data and events files, as a jar file, to the floppy directory -- this is often used for archiving of
			intermediate files</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">tan</TD>
		<TD WIDTH="15%">tan(X)</TD>
		<TD WIDTH="60%">returns the tangent of X</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">toDate</TD>
		<TD WIDTH="15%">toDate(X)</TD>
		<TD WIDTH="60%">returns the answer for node X, as a date if possible, otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toDay</TD>

		<TD WIDTH="15%">toDay(X)</TD>
		<TD WIDTH="60%">returns the day components of X if possible, otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toDayNum</TD>
		<TD WIDTH="15%">toDayNum(X)</TD>
		<TD WIDTH="60%">returns the day number components of X (day of the year) if possible, otherwise returns *INVALID*</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">toHour</TD>
		<TD WIDTH="15%">toHour(X)</TD>
		<TD WIDTH="60%">returns the hour component of X</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">toLowerCase</TD>
		<TD WIDTH="15%">toLowerCase(X)</TD>
		<TD WIDTH="60%">returns string X as lowercase</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toMinute</TD>
		<TD WIDTH="15%">toMinute(X)</TD>

		<TD WIDTH="60%">returns the minute component of X if possible, otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toMonth</TD>
		<TD WIDTH="15%">toMonth(X)</TD>
		<TD WIDTH="60%">returns the month component of X if possible, otherwise returns *INVALID*</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">toMonthNum</TD>
		<TD WIDTH="15%">toMonthNum(X)</TD>
		<TD WIDTH="60%">returns the month number (1-12) component of X if possible, otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toSecond</TD>

		<TD WIDTH="15%">toSecond(X)</TD>
		<TD WIDTH="60%">returns the seconds component of X if possible, otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toTime</TD>
		<TD WIDTH="15%">toTime(X)</TD>
		<TD WIDTH="60%">returns X as a time value (hh:mm:ss) if possible, otherwise returns *INVALID*</TD>

	</TR>
	<TR>
		<TD WIDTH="15%">toUpperCase</TD>
		<TD WIDTH="15%">toUppercase(X)</TD>
		<TD WIDTH="60%">returns string X as uppercase</TD>
	</TR>
	<TR>

		<TD WIDTH="15%">toWeekday</TD>
		<TD WIDTH="15%">toWeekday(X)</TD>
		<TD WIDTH="60%">returns the weekday component of X if possible (e.g. 'Monday'), otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">toYear</TD>
		<TD WIDTH="15%">toYear(X)</TD>

		<TD WIDTH="60%">returns the year component of X if possible, otherwise returns *INVALID*</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">todegrees</TD>
		<TD WIDTH="15%">todegrees(X)</TD>
		<TD WIDTH="60%">converts from radians to degrees</TD>
	</TR>

	<TR>
		<TD WIDTH="15%">toradians</TD>
		<TD WIDTH="15%">toradians(X)</TD>
		<TD WIDTH="60%">converts from degrees to radians</TD>
	</TR>
	<TR>
		<TD WIDTH="15%">trim</TD>

		<TD WIDTH="15%">trim(X)</TD>
		<TD WIDTH="60%">removes trailing whitespace from string X</TD>
	</TR>
</TABLE>
</P>
<P><A NAME="DataFile"></A><B><FONT SIZE="4">DataFile Format</FONT></B></P>

<P>Each time the user interacts with the interview (e.g. when a user presses the <B>Next</B> button), the <B><I><A
HREF="#DataFile">dataFile</A></I></B> and <B><I><A HREF="#eventFile">eventFile</A></I></B> are updated and written
to the <B><I><A HREF="#workingDir">workingDirectory</A></I></B>. When the interview is completed, the finalized

<B><I><A HREF="#DataFile">dataFile</A></I></B> is written to both the <B><I><A HREF="#completedDir">completedDirectory</A></I></B>
and the <B><I><A HREF="#floppyDir">floppyDirectory</A></I></B> (e.g. to the floppy disk, if Dialogix is being run
on a local machine). The <B><I><A HREF="#DataFile">dataFile</A></I></B> is a spreadsheet with 7 columns, as indicated
below. There are two interleaved syntaxes - one for reserved words, the other for regular data. Each time new information
is collected, it is appended to the dataFile. Thus, if a node is answered multiple times, each answer will be recorded.
This makes it possible to check for changed answers.</P>

<P>For each node, the following information is collected:

<UL>
	<LI><B><I><A HREF="#languageNum">languageNum</A></I></B> - indicates which of the available languages was used
	to display information and questions
	<LI><B><I><A HREF="#questionAsAsked">questionAsAsked</A></I></B> - the exact question asked, in the appropriate
	language, with any substitutions appropriately inserted
	<LI><B><I><A HREF="#answerGiven">answerGiven</A></I></B> - the data collected by the node - either information
	entered by the user, the internal value associated with pick-list choices, or the results of evaluations.
	<LI><B><I><A HREF="#comment">comment</A></I></B> - any additional comment the user might want to make about a question
	(e.g. a reason for refusing to answer, or an answer that was not available on a pick-list)
	<LI><B><I><A HREF="#timeStamp">timeStamp</A></I></B> - the date and time (to the second) at which the data for
	the node was collected (e.g. when a question was answered)

</UL>

<P>
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<TR>
		<TD WIDTH="10%">&nbsp;</TD>
		<TD WIDTH="14%"><B><I><A HREF="#internalName">internalName</A></I></B></TD>
		<TD WIDTH="14%"><B><I><A HREF="#languageNum">languageNum</A></I></B></TD>
		<TD WIDTH="10%"><B><I><A HREF="#timeStamp">timeStamp</A></I></B></TD>

		<TD WIDTH="14%"><B><I><A HREF="#questionAsAsked">questionAsAsked</A></I></B></TD>
		<TD WIDTH="14%"><B><I><A HREF="#answerGiven">answerGiven</A></I></B></TD>
		<TD WIDTH="10%"><I><B><A HREF="#comment">comment</A></B></I></TD>
	</TR>
	<TR>
		<TD WIDTH="10%"><B>RESERVED</B></TD>
		<TD WIDTH="14%"><B><I><A HREF="#ReservedVariableName">ReservedVariableName</A></I></B></TD>

		<TD WIDTH="14%"><B>value</B></TD>
		<TD WIDTH="10%"><B><I><A HREF="#timeStamp">timeStamp</A></I></B></TD>
		<TD WIDTH="14%">&nbsp;</TD>
		<TD WIDTH="14%">&nbsp;</TD>
		<TD WIDTH="10%">&nbsp;</TD>
	</TR>
</TABLE>
</P>

<P><B><FONT SIZE="4">EventFile Format</FONT></B></P>

<P>[XXX - documentation needed]</P>

<P><B>MySQL Data Files</B></P>

<P>Each time data is received by the server, the following data files are created  in Mysql<B>.</B></P>

<P><BR>
#<BR>
# Table structure for table `pageHits`<BR>

#<BR>
<BR>
DROP TABLE IF EXISTS pageHits;<BR>
CREATE TABLE pageHits (<BR>
  pageHitID int(11) NOT NULL auto_increment,<BR>
  timeStamp timestamp(14) NOT NULL,<BR>
  accessCount int(11) NOT NULL default '-1',<BR>
  currentIP varchar(16) NOT NULL default '',<BR>

  username varchar(15) NOT NULL default '',<BR>
  sessionID varchar(35) NOT NULL default '',<BR>
  workingFile varchar(100) NOT NULL default '',<BR>
  javaObject varchar(40) NOT NULL default '',<BR>
  browser varchar(200) NOT NULL default '',<BR>
  instrumentName varchar(100) NOT NULL default '',<BR>

  currentStep int(11) NOT NULL default '-1',<BR>
  displayCount int(11) NOT NULL default '-1',<BR>
  lastAction varchar(15) NOT NULL default '',<BR>
  statusMsg varchar(35) NOT NULL default '',<BR>
  totalMemory bigint(15) NOT NULL default '0',<BR>
  freeMemory bigint(15) NOT NULL default '0',<BR>

  PRIMARY KEY  (pageHitID)<BR>
) TYPE=MyISAM;<BR>
# --------------------------------------------------------<BR>
<BR>
#<BR>
# Table structure for table `pageHitDetails`<BR>
#<BR>
<BR>
DROP TABLE IF EXISTS pageHitDetails;<BR>

CREATE TABLE pageHitDetails (<BR>
  pageHitDetailsID int(11) NOT NULL auto_increment,<BR>
  pageHitID_FK int(11) NOT NULL default '0',<BR>
  param varchar(40) NOT NULL default '',<BR>
  value varchar(254) NOT NULL default '',<BR>
  PRIMARY KEY  (pageHitDetailsID)<BR>

) TYPE=MyISAM;<BR>
# --------------------------------------------------------<BR>
<BR>
#<BR>
# Table structure for table `pageHitEvents`<BR>
#<BR>
<BR>
DROP TABLE IF EXISTS pageHitEvents;<BR>
CREATE TABLE pageHitEvents (<BR>
  pageHitEventsID int(11) NOT NULL auto_increment,<BR>

  pageHitID_FK int(11) NOT NULL default '0',<BR>
  varName varchar(40) NOT NULL default '',<BR>
  actionType varchar(18) NOT NULL default '',<BR>
  eventType varchar(18) NOT NULL default '',<BR>
  timestamp bigint(15) NOT NULL default '0',<BR>
  duration int(11) NOT NULL default '0',<BR>

  value1 varchar(10) NOT NULL default '',<BR>
  value2 varchar(50) NOT NULL default '',<BR>
  PRIMARY KEY  (pageHitEventsID)<BR>
) TYPE=MyISAM;<BR>
# --------------------------------------------------------<BR>
</P>

<P><B>XML Schema Format</B></P>

<P>[XXX - more documentation needed]</P>

<P>Here is a sample XML file fragment for a node</P>

<P>&lt;node linenum=&quot;11&quot;&gt;<BR>
	&lt;concept&gt;interview;date;month;position&lt;/concept&gt;<BR>
	&lt;uniqueName&gt;intro_day_position&lt;/uniqueName&gt;<BR>

	&lt;displayName&gt;intro_day_position&lt;/displayName&gt;<BR>
	&lt;relevance&gt;1&lt;/relevance&gt;<BR>
	&lt;actionSymbol&gt;e&lt;/actionSymbol&gt;<BR>
	&lt;actionType&gt;eval&lt;/actionType&gt;<BR>

	&lt;nesting&gt;&lt;/nesting&gt;<BR>
	&lt;dataType&gt;string&lt;/dataType&gt;<BR>
	&lt;displayType&gt;nothing&lt;/displayType&gt;<BR>
	&lt;validation&gt;<BR>

		&lt;castto&gt;&lt;/castto&gt;<BR>
		&lt;min&gt;&lt;/min&gt;<BR>
		&lt;max&gt;&lt;/max&gt;<BR>
		&lt;mask&gt;&lt;/mask&gt;<BR>
		&lt;regex&gt;&lt;/regex&gt;<BR>

		&lt;extras count=&quot;0&quot;/&gt;<BR>
	&lt;/validation&gt;<BR>
	&lt;hows count=&quot;2&quot;&gt;<BR>
		&lt;how index=&quot;1&quot; lang=&quot;en_US&quot;&gt;<BR>

			&lt;readback&gt;&lt;/readback&gt;<BR>
			&lt;helpURL&gt;&lt;/helpURL&gt;<BR>
			&lt;actionExp&gt;toDay(getNow()) lt 10?'beginning':toDay(getNow()) gt 20?'end':'middle'&lt;/actionExp&gt;<BR>
			&lt;options count=&quot;0&quot;/&gt;<BR>

		&lt;/how&gt;<BR>
		&lt;how index=&quot;2&quot; lang=&quot;es&quot;&gt;<BR>
			&lt;readback&gt;&lt;/readback&gt;<BR>
			&lt;helpURL&gt;&lt;/helpURL&gt;<BR>

			&lt;actionExp&gt;toDay(getNow()) lt 10?'principios':toDay(getNow()) gt 20?'finales':'mediados'&lt;/actionExp&gt;<BR>
			&lt;options count=&quot;0&quot;/&gt;<BR>
		&lt;/how&gt;<BR>
	&lt;/hows&gt;<BR>
&lt;/node&gt;

<?php include("Dialogix_Table_PartB.php"); ?>
