
/**********************************************/
/* SAS Module AutoSIGH-rev-04-10_v0.7._n122_d5e6a7530f70402c40ed8d3752f58133_MAIN-summary */
/**********************************************/

data WORK.AutoSigh;
	%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
	infile '/data/cet8/analysis/AutoSIGH-rev-04-10_v0.7._n122_d5e6a7530f70402c40ed8d3752f58133_MAIN-summary.tsv'
	delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
	informat UniqueID $50.; format UniqueID $50.;
	informat Finished best32.; format Finished best12.;
	informat StartDat mmddyy10.; format StartDat mmddyy10.;
	informat StopDate mmddyy10.; format StopDate mmddyy10.;
	informat Title $50.; format Title $50.;
	informat Version $50.; format Version $50.;
	informat intro1 best32.;  format intro1 best12.;
	informat d_change_width best32.;  format d_change_width best12.;
	informat use best32.;  format use best12.;
	informat age best32.;  format age best12.;
	informat country $25.;  format country $25.;
	informat english best32.;  format english best12.;
	informat gdate best32.;  format gdate best12.;
	informat D1 best32.;  format D1 best12.;
	informat D2 best32.;  format D2 best12.;
	informat D3 best32.;  format D3 best12.;
	informat d_change_header best32.;  format d_change_header best12.;
	informat H1 best32.;  format H1 best12.;
	informat H2 best32.;  format H2 best12.;
	informat A1 best32.;  format A1 best12.;
	informat H3 best32.;  format H3 best12.;
	informat H4 best32.;  format H4 best12.;
	informat H5 best32.;  format H5 best12.;
	informat A2 best32.;  format A2 best12.;
	informat A3 best32.;  format A3 best12.;
	informat A4 best32.;  format A4 best12.;
	informat d_change_header2 best32.;  format d_change_header2 best12.;
	informat A3n best32.;  format A3n best12.;
	informat A4n best32.;  format A4n best12.;
	informat A5 best32.;  format A5 best12.;
	informat A2n best32.;  format A2n best12.;
	informat d_change_header3 best32.;  format d_change_header3 best12.;
	informat H6 best32.;  format H6 best12.;
	informat H7 best32.;  format H7 best12.;
	informat H8 best32.;  format H8 best12.;
	informat A6 best32.;  format A6 best12.;
	informat H9a best32.;  format H9a best12.;
	informat H9b best32.;  format H9b best12.;
	informat H9c best32.;  format H9c best12.;
	informat H10 best32.;  format H10 best12.;
	informat H11 best32.;  format H11 best12.;
	informat H12 best32.;  format H12 best12.;
	informat d_change_header4 best32.;  format d_change_header4 best12.;
	informat q37 best32.;  format q37 best12.;
	informat d_change_header5 best32.;  format d_change_header5 best12.;
	informat H13 best32.;  format H13 best12.;
	informat d_change_header6 best32.;  format d_change_header6 best12.;
	informat a7c0 best32.;  format a7c0 best12.;
	informat a7c1 best32.;  format a7c1 best12.;
	informat a7c2 best32.;  format a7c2 best12.;
	informat a7c3 best32.;  format a7c3 best12.;
	informat a7 best32.;  format a7 best12.;
	informat H13a best32.;  format H13a best12.;
	informat d_change_header7 best32.;  format d_change_header7 best12.;
	informat H14 best32.;  format H14 best12.;
	informat H16 best32.;  format H16 best12.;
	informat H17 best32.;  format H17 best12.;
	informat d_change_header8 best32.;  format d_change_header8 best12.;
	informat q49a best32.;  format q49a best12.;
	informat q62 best32.;  format q62 best12.;
	informat d_change_header9 best32.;  format d_change_header9 best12.;
	informat A8 best32.;  format A8 best12.;
	informat t24 best32.;  format t24 best12.;
	informat H15 best32.;  format H15 best12.;
	informat hsum best32.;  format hsum best12.;
	informat q63b best32.;  format q63b best12.;
	informat d_change_header10 best32.;  format d_change_header10 best12.;
	informat asum best32.;  format asum best12.;
	informat h4n0 best32.;  format h4n0 best12.;
	informat h5n0 best32.;  format h5n0 best12.;
	informat asumad best32.;  format asumad best12.;
	informat atypbal best32.;  format atypbal best12.;
	informat t25 best32.;  format t25 best12.;
	informat acrit best32.;  format acrit best12.;
	informat d_change_header12 best32.;  format d_change_header12 best12.;
	informat d_change_width2 best32.;  format d_change_width2 best12.;
	informat Feedback_us $254.;  format Feedback_us $254.;


	INPUT
		UniqueID $
		Finished
		StartDat
		StopDate
		Title $
		Version $
		intro1
		d_change_width
		use
		age
		country $
		english
		gdate
		D1
		D2
		D3
		d_change_header
		H1
		H2
		A1
		H3
		H4
		H5
		A2
		A3
		A4
		d_change_header2
		A3n
		A4n
		A5
		A2n
		d_change_header3
		H6
		H7
		H8
		A6
		H9a
		H9b
		H9c
		H10
		H11
		H12
		d_change_header4
		q37
		d_change_header5
		H13
		d_change_header6
		a7c0
		a7c1
		a7c2
		a7c3
		a7
		H13a
		d_change_header7
		H14
		H16
		H17
		d_change_header8
		q49a
		q62
		d_change_header9
		A8
		t24
		H15
		hsum
		q63b
		d_change_header10
		asum
		h4n0
		h5n0
		asumad
		atypbal
		t25
		acrit
		d_change_header12
		d_change_width2
		Feedback_us
		;
	if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
run;

data AutoSigh2; set AutoSigh;
	young = (age=0);
	f1 = (D1=1);
	f2 = (D2=1);
	f3 = (D3=1);
	f4 = (t25<4);
	f5 = (t25<4 and hsum>1 and H1<4);
	f6 = (t25<4 and H1=4);
	f7 = (t25<4 and H2>1 and H2<4);
	f8 = (t25<4 and H2=4);
	f9 = (t25<4 and H11>0 and H11<3);
	young2 = (t25<4 and H11=3 and age=1);
	older1 = (t25<4 and H11=3 and age=2);
	f10 = (t25<4 and H11=4 and age=1);
	older2 = (t25<4 and H11=4 and age=2);
	f11 = (t25>4 and t25<11);
	f12 = (t25>4 and t25<11 and H1=0 and H2=0);
	f13 = (t25>4 and t25<11 and H11>0 and H11<3);
	f14 = (t25>4 and t25<11 and H11>2);
	msu1 = (t25>4 and t25<11 and H11=3 and age=1);
	msu2 = (t25>4 and t25<11 and H11=3 and age=2);
	msu3 = (t25>4 and t25<11 and H11=4 and age=1);
	msu4 = (t25>4 and t25<11 and H11=4 and age=2);
	f15 = (t25>10 and t25<20);
	f16 = (t25>20);
	f17 = (t25>20 and H11>0 and H11<3);
	ssu1 = (t25>20 and H11=3 and age=1);
	ssu2 = (t25>20 and H11=3 and age=2);
	ssu3 = (t25>20 and H11=4 and age=1);
	ssu4 = (t25>20 and H11=4 and age=2);
	f19 = (t25<16 and asum>acrit);
	f20 = (t25>15 and atypbal>50);
	f21 = (H6=2);
	f22 = (H7=2);
	f23 = (H8=2);
	f24 = (H12>2);
	f25 = (H10=4);
	f26 = (H13=4);
	f27 = (H16>2);
	f28 = (H17=4);
	f29 = (t25>20 and H15=2 and H1>1);
	recruit = (t25>=15 and H1>1 and (country="Canada"||country="United States"));
run;

proc freq data=Autosigh2;
	table	young;
	table	f1;
	table	f2;
	table	f3;
	table	f4;
	table	f5;
	table	f6;
	table	f7;
	table	f8;
	table	f9;
	table	young2;
	table	older1;
	table	f10;
	table	older2;
	table	f11;
	table	f12;
	table	f13;
	table	f14;
	table	msu1;
	table	msu2;
	table	msu3;
	table	msu4;
	table	f15;
	table	f16;
	table	f17;
	table	ssu1;
	table	ssu2;
	table	ssu3;
	table	ssu4;
	table	f19;
	table	f20;
	table	f21;
	table	f22;
	table	f23;
	table	f24;
	table	f25;
	table	f26;
	table	f27;
	table	f28;
	table	f29;
	table	recruit;
run;

proc freq data=Autosigh2;
	title 'Variables about suicidal ideation';
	table	f9;
	table	young2;
	table	older1;
	table	f10;
	table	older2;
	table	f13;
	table	f14;
	table	msu1;
	table	msu2;
	table	msu3;
	table	msu4;
	table	f17;
	table	ssu1;
	table	ssu2;
	table	ssu3;
	table	ssu4;
run;

proc sql;
	create table suicidal as		/* 199 */
	select * from autosigh2
	where 
		f9 = 1 or 
		young2 = 1 or 
		older1 = 1 or 
		f10 = 1 or 
		older2 = 1 or 
		f13 = 1 or 
		f14 = 1 or 
		msu1 = 1 or 
		msu2 = 1 or 
		msu3 = 1 or 
		msu4 = 1 or 
		f17 = 1 or 
		ssu1 = 1 or 
		ssu2 = 1 or 
		ssu3 = 1 or 
		ssu4 = 1;
quit;

proc sql;
	create table suicidal_act as	/* 5 */
	select * from autosigh2
	where 
		f10 = 1 or 
		older2 = 1 or 
		f14 = 1 or 
		msu3 = 1 or 
		msu4 = 1 or 
		ssu3 = 1 or 
		ssu4 = 1;
quit;