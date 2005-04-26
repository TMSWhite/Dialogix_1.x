
data cet7a.automeq7a;
	%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
	infile '/data/cet-2005-04/new/AutoMEQ-SA-irb_v7.0_n497_a4e831b09889e5dcdac77bf475e413d9_MAIN-summary.tsv'
	delimiter='09'x MISSOVER DSD lrecl=32767 firstobs=2;
	informat UniqueID $50.; format UniqueID $50.;
	informat Finished best32.; format Finished best12.;
	informat StartDat mmddyy10.; format StartDat mmddyy10.;
	informat StopDate mmddyy10.; format StopDate mmddyy10.;
	informat Title $50.; format Title $50.;
	informat Version $50.; format Version $50.;
	informat d_who best32.;  format d_who best12.;
	informat d_study best32.;  format d_study best12.;
	informat d_age best32.;  format d_age best12.;
	informat _ask best32.;  format _ask best12.;
	informat d_sex best32.;  format d_sex best12.;
	informat d_eye best32.;  format d_eye best12.;
	informat d_country $25.;  format d_country $25.;
	informat d_state best32.;  format d_state best12.;
	informat _state_name $50.;  format _state_name $50.;
	informat d_los best32.;  format d_los best12.;
	informat d_zip best32.;  format d_zip best12.;
	informat d_eth_ai best32.;  format d_eth_ai best12.;
	informat d_eth_as best32.;  format d_eth_as best12.;
	informat d_eth_bl best32.;  format d_eth_bl best12.;
	informat d_eth_his best32.;  format d_eth_his best12.;
	informat d_eth_hw best32.;  format d_eth_hw best12.;
	informat d_eth_wh best32.;  format d_eth_wh best12.;
	informat d_working_days best32.;  format d_working_days best12.;
	informat d_sleep_workday $25.;  format d_sleep_workday $25.;
	informat d_sleep_nonworkday $25.;  format d_sleep_nonworkday $25.;
	informat d_awake_workday $25.;  format d_awake_workday $25.;
	informat d_awake_nonworkday $25.;  format d_awake_nonworkday $25.;
	informat d_sleep_darkroom best32.;  format d_sleep_darkroom best12.;
	informat d_wake_withlight best32.;  format d_wake_withlight best12.;
	informat d_outsidelight_work best32.;  format d_outsidelight_work best12.;
	informat d_outsidelight_nonwork best32.;  format d_outsidelight_nonwork best12.;
	informat d_height_units best32.;  format d_height_units best12.;
	informat d_weight_units best32.;  format d_weight_units best12.;
	informat d_height_feet best32.;  format d_height_feet best12.;
	informat d_height_inches best32.;  format d_height_inches best12.;
	informat d_height_meters best32.;  format d_height_meters best12.;
	informat d_weight_pounds best32.;  format d_weight_pounds best12.;
	informat d_weight_kilograms best32.;  format d_weight_kilograms best12.;
	informat d_height_m best32.;  format d_height_m best12.;
	informat d_weight_kg best32.;  format d_weight_kg best12.;
	informat d_BMI best32.;  format d_BMI best12.;
	informat askPIDS best32.;  format askPIDS best12.;
	informat CompletionDate $50.;  format CompletionDate $50.;
	informat A1 best32.;  format A1 best12.;
	informat A2 best32.;  format A2 best12.;
	informat A3 best32.;  format A3 best12.;
	informat A4 best32.;  format A4 best12.;
	informat A5 best32.;  format A5 best12.;
	informat A6 best32.;  format A6 best12.;
	informat A7 best32.;  format A7 best12.;
	informat A8 best32.;  format A8 best12.;
	informat A9 best32.;  format A9 best12.;
	informat Ascore best32.;  format Ascore best12.;
	informat B1 best32.;  format B1 best12.;
	informat B2 best32.;  format B2 best12.;
	informat B3 best32.;  format B3 best12.;
	informat B4 best32.;  format B4 best12.;
	informat B5 best32.;  format B5 best12.;
	informat B6 best32.;  format B6 best12.;
	informat B7 best32.;  format B7 best12.;
	informat Bscore best32.;  format Bscore best12.;
	informat C1A_Non best32.;  format C1A_Non best12.;
	informat C1A_Jan best32.;  format C1A_Jan best12.;
	informat C1A_Feb best32.;  format C1A_Feb best12.;
	informat C1A_Mar best32.;  format C1A_Mar best12.;
	informat C1A_Apr best32.;  format C1A_Apr best12.;
	informat C1A_May best32.;  format C1A_May best12.;
	informat C1A_Jun best32.;  format C1A_Jun best12.;
	informat C1A_Jul best32.;  format C1A_Jul best12.;
	informat C1A_Aug best32.;  format C1A_Aug best12.;
	informat C1A_Sep best32.;  format C1A_Sep best12.;
	informat C1A_Oct best32.;  format C1A_Oct best12.;
	informat C1A_Nov best32.;  format C1A_Nov best12.;
	informat C1A_Dec best32.;  format C1A_Dec best12.;
	informat C1A_Score best32.;  format C1A_Score best12.;
	informat C1A_Err $50.;  format C1A_Err $50.;
	informat C1A_Err2 $50.;  format C1A_Err2 $50.;
	informat C1B_Non best32.;  format C1B_Non best12.;
	informat C1B_Jan best32.;  format C1B_Jan best12.;
	informat C1B_Feb best32.;  format C1B_Feb best12.;
	informat C1B_Mar best32.;  format C1B_Mar best12.;
	informat C1B_Apr best32.;  format C1B_Apr best12.;
	informat C1B_May best32.;  format C1B_May best12.;
	informat C1B_Jun best32.;  format C1B_Jun best12.;
	informat C1B_Jul best32.;  format C1B_Jul best12.;
	informat C1B_Aug best32.;  format C1B_Aug best12.;
	informat C1B_Sep best32.;  format C1B_Sep best12.;
	informat C1B_Oct best32.;  format C1B_Oct best12.;
	informat C1B_Nov best32.;  format C1B_Nov best12.;
	informat C1B_Dec best32.;  format C1B_Dec best12.;
	informat C1B_Score best32.;  format C1B_Score best12.;
	informat C1B_Err $50.;  format C1B_Err $50.;
	informat C1B_Err2 $50.;  format C1B_Err2 $50.;
	informat C1_Jan_Err best32.;  format C1_Jan_Err best12.;
	informat C1_Feb_Err best32.;  format C1_Feb_Err best12.;
	informat C1_Mar_Err best32.;  format C1_Mar_Err best12.;
	informat C1_Apr_Err best32.;  format C1_Apr_Err best12.;
	informat C1_May_Err best32.;  format C1_May_Err best12.;
	informat C1_Jun_Err best32.;  format C1_Jun_Err best12.;
	informat C1_Jul_Err best32.;  format C1_Jul_Err best12.;
	informat C1_Aug_Err best32.;  format C1_Aug_Err best12.;
	informat C1_Sep_Err best32.;  format C1_Sep_Err best12.;
	informat C1_Oct_Err best32.;  format C1_Oct_Err best12.;
	informat C1_Nov_Err best32.;  format C1_Nov_Err best12.;
	informat C1_Dec_Err best32.;  format C1_Dec_Err best12.;
	informat C1_Err_Num best32.;  format C1_Err_Num best12.;
	informat C1_Err_List $100.;  format C1_Err_List $100.;
	informat C1_Err $50.;  format C1_Err $50.;
	informat C2A_Non best32.;  format C2A_Non best12.;
	informat C2A_Jan best32.;  format C2A_Jan best12.;
	informat C2A_Feb best32.;  format C2A_Feb best12.;
	informat C2A_Mar best32.;  format C2A_Mar best12.;
	informat C2A_Apr best32.;  format C2A_Apr best12.;
	informat C2A_May best32.;  format C2A_May best12.;
	informat C2A_Jun best32.;  format C2A_Jun best12.;
	informat C2A_Jul best32.;  format C2A_Jul best12.;
	informat C2A_Aug best32.;  format C2A_Aug best12.;
	informat C2A_Sep best32.;  format C2A_Sep best12.;
	informat C2A_Oct best32.;  format C2A_Oct best12.;
	informat C2A_Nov best32.;  format C2A_Nov best12.;
	informat C2A_Dec best32.;  format C2A_Dec best12.;
	informat C2A_Score best32.;  format C2A_Score best12.;
	informat C2A_Err $50.;  format C2A_Err $50.;
	informat C2A_Err2 $50.;  format C2A_Err2 $50.;
	informat C2B_Non best32.;  format C2B_Non best12.;
	informat C2B_Jan best32.;  format C2B_Jan best12.;
	informat C2B_Feb best32.;  format C2B_Feb best12.;
	informat C2B_Mar best32.;  format C2B_Mar best12.;
	informat C2B_Apr best32.;  format C2B_Apr best12.;
	informat C2B_May best32.;  format C2B_May best12.;
	informat C2B_Jun best32.;  format C2B_Jun best12.;
	informat C2B_Jul best32.;  format C2B_Jul best12.;
	informat C2B_Aug best32.;  format C2B_Aug best12.;
	informat C2B_Sep best32.;  format C2B_Sep best12.;
	informat C2B_Oct best32.;  format C2B_Oct best12.;
	informat C2B_Nov best32.;  format C2B_Nov best12.;
	informat C2B_Dec best32.;  format C2B_Dec best12.;
	informat C2B_Score best32.;  format C2B_Score best12.;
	informat C2B_Err $50.;  format C2B_Err $50.;
	informat C2B_Err2 $50.;  format C2B_Err2 $50.;
	informat C2_Jan_Err best32.;  format C2_Jan_Err best12.;
	informat C2_Feb_Err best32.;  format C2_Feb_Err best12.;
	informat C2_Mar_Err best32.;  format C2_Mar_Err best12.;
	informat C2_Apr_Err best32.;  format C2_Apr_Err best12.;
	informat C2_May_Err best32.;  format C2_May_Err best12.;
	informat C2_Jun_Err best32.;  format C2_Jun_Err best12.;
	informat C2_Jul_Err best32.;  format C2_Jul_Err best12.;
	informat C2_Aug_Err best32.;  format C2_Aug_Err best12.;
	informat C2_Sep_Err best32.;  format C2_Sep_Err best12.;
	informat C2_Oct_Err best32.;  format C2_Oct_Err best12.;
	informat C2_Nov_Err best32.;  format C2_Nov_Err best12.;
	informat C2_Dec_Err best32.;  format C2_Dec_Err best12.;
	informat C2_Err_Num best32.;  format C2_Err_Num best12.;
	informat C2_Err_List $100.;  format C2_Err_List $100.;
	informat C2_Err $50.;  format C2_Err $50.;
	informat C3A_Non best32.;  format C3A_Non best12.;
	informat C3A_Jan best32.;  format C3A_Jan best12.;
	informat C3A_Feb best32.;  format C3A_Feb best12.;
	informat C3A_Mar best32.;  format C3A_Mar best12.;
	informat C3A_Apr best32.;  format C3A_Apr best12.;
	informat C3A_May best32.;  format C3A_May best12.;
	informat C3A_Jun best32.;  format C3A_Jun best12.;
	informat C3A_Jul best32.;  format C3A_Jul best12.;
	informat C3A_Aug best32.;  format C3A_Aug best12.;
	informat C3A_Sep best32.;  format C3A_Sep best12.;
	informat C3A_Oct best32.;  format C3A_Oct best12.;
	informat C3A_Nov best32.;  format C3A_Nov best12.;
	informat C3A_Dec best32.;  format C3A_Dec best12.;
	informat C3A_Score best32.;  format C3A_Score best12.;
	informat C3A_Err $50.;  format C3A_Err $50.;
	informat C3A_Err2 $50.;  format C3A_Err2 $50.;
	informat C3B_Non best32.;  format C3B_Non best12.;
	informat C3B_Jan best32.;  format C3B_Jan best12.;
	informat C3B_Feb best32.;  format C3B_Feb best12.;
	informat C3B_Mar best32.;  format C3B_Mar best12.;
	informat C3B_Apr best32.;  format C3B_Apr best12.;
	informat C3B_May best32.;  format C3B_May best12.;
	informat C3B_Jun best32.;  format C3B_Jun best12.;
	informat C3B_Jul best32.;  format C3B_Jul best12.;
	informat C3B_Aug best32.;  format C3B_Aug best12.;
	informat C3B_Sep best32.;  format C3B_Sep best12.;
	informat C3B_Oct best32.;  format C3B_Oct best12.;
	informat C3B_Nov best32.;  format C3B_Nov best12.;
	informat C3B_Dec best32.;  format C3B_Dec best12.;
	informat C3B_Score best32.;  format C3B_Score best12.;
	informat C3B_Err $50.;  format C3B_Err $50.;
	informat C3B_Err2 $50.;  format C3B_Err2 $50.;
	informat C3_Jan_Err best32.;  format C3_Jan_Err best12.;
	informat C3_Feb_Err best32.;  format C3_Feb_Err best12.;
	informat C3_Mar_Err best32.;  format C3_Mar_Err best12.;
	informat C3_Apr_Err best32.;  format C3_Apr_Err best12.;
	informat C3_May_Err best32.;  format C3_May_Err best12.;
	informat C3_Jun_Err best32.;  format C3_Jun_Err best12.;
	informat C3_Jul_Err best32.;  format C3_Jul_Err best12.;
	informat C3_Aug_Err best32.;  format C3_Aug_Err best12.;
	informat C3_Sep_Err best32.;  format C3_Sep_Err best12.;
	informat C3_Oct_Err best32.;  format C3_Oct_Err best12.;
	informat C3_Nov_Err best32.;  format C3_Nov_Err best12.;
	informat C3_Dec_Err best32.;  format C3_Dec_Err best12.;
	informat C3_Err_Num best32.;  format C3_Err_Num best12.;
	informat C3_Err_List $100.;  format C3_Err_List $100.;
	informat C3_Err $50.;  format C3_Err $50.;
	informat C4A_Non best32.;  format C4A_Non best12.;
	informat C4A_Jan best32.;  format C4A_Jan best12.;
	informat C4A_Feb best32.;  format C4A_Feb best12.;
	informat C4A_Mar best32.;  format C4A_Mar best12.;
	informat C4A_Apr best32.;  format C4A_Apr best12.;
	informat C4A_May best32.;  format C4A_May best12.;
	informat C4A_Jun best32.;  format C4A_Jun best12.;
	informat C4A_Jul best32.;  format C4A_Jul best12.;
	informat C4A_Aug best32.;  format C4A_Aug best12.;
	informat C4A_Sep best32.;  format C4A_Sep best12.;
	informat C4A_Oct best32.;  format C4A_Oct best12.;
	informat C4A_Nov best32.;  format C4A_Nov best12.;
	informat C4A_Dec best32.;  format C4A_Dec best12.;
	informat C4A_Score best32.;  format C4A_Score best12.;
	informat C4A_Err $50.;  format C4A_Err $50.;
	informat C4A_Err2 $50.;  format C4A_Err2 $50.;
	informat C4B_Non best32.;  format C4B_Non best12.;
	informat C4B_Jan best32.;  format C4B_Jan best12.;
	informat C4B_Feb best32.;  format C4B_Feb best12.;
	informat C4B_Mar best32.;  format C4B_Mar best12.;
	informat C4B_Apr best32.;  format C4B_Apr best12.;
	informat C4B_May best32.;  format C4B_May best12.;
	informat C4B_Jun best32.;  format C4B_Jun best12.;
	informat C4B_Jul best32.;  format C4B_Jul best12.;
	informat C4B_Aug best32.;  format C4B_Aug best12.;
	informat C4B_Sep best32.;  format C4B_Sep best12.;
	informat C4B_Oct best32.;  format C4B_Oct best12.;
	informat C4B_Nov best32.;  format C4B_Nov best12.;
	informat C4B_Dec best32.;  format C4B_Dec best12.;
	informat C4B_Score best32.;  format C4B_Score best12.;
	informat C4B_Err $50.;  format C4B_Err $50.;
	informat C4B_Err2 $50.;  format C4B_Err2 $50.;
	informat C4_Jan_Err best32.;  format C4_Jan_Err best12.;
	informat C4_Feb_Err best32.;  format C4_Feb_Err best12.;
	informat C4_Mar_Err best32.;  format C4_Mar_Err best12.;
	informat C4_Apr_Err best32.;  format C4_Apr_Err best12.;
	informat C4_May_Err best32.;  format C4_May_Err best12.;
	informat C4_Jun_Err best32.;  format C4_Jun_Err best12.;
	informat C4_Jul_Err best32.;  format C4_Jul_Err best12.;
	informat C4_Aug_Err best32.;  format C4_Aug_Err best12.;
	informat C4_Sep_Err best32.;  format C4_Sep_Err best12.;
	informat C4_Oct_Err best32.;  format C4_Oct_Err best12.;
	informat C4_Nov_Err best32.;  format C4_Nov_Err best12.;
	informat C4_Dec_Err best32.;  format C4_Dec_Err best12.;
	informat C4_Err_Num best32.;  format C4_Err_Num best12.;
	informat C4_Err_List $100.;  format C4_Err_List $100.;
	informat C4_Err $50.;  format C4_Err $50.;
	informat C5A_Non best32.;  format C5A_Non best12.;
	informat C5A_Jan best32.;  format C5A_Jan best12.;
	informat C5A_Feb best32.;  format C5A_Feb best12.;
	informat C5A_Mar best32.;  format C5A_Mar best12.;
	informat C5A_Apr best32.;  format C5A_Apr best12.;
	informat C5A_May best32.;  format C5A_May best12.;
	informat C5A_Jun best32.;  format C5A_Jun best12.;
	informat C5A_Jul best32.;  format C5A_Jul best12.;
	informat C5A_Aug best32.;  format C5A_Aug best12.;
	informat C5A_Sep best32.;  format C5A_Sep best12.;
	informat C5A_Oct best32.;  format C5A_Oct best12.;
	informat C5A_Nov best32.;  format C5A_Nov best12.;
	informat C5A_Dec best32.;  format C5A_Dec best12.;
	informat C5A_Score best32.;  format C5A_Score best12.;
	informat C5A_Err $50.;  format C5A_Err $50.;
	informat C5A_Err2 $50.;  format C5A_Err2 $50.;
	informat C5B_Non best32.;  format C5B_Non best12.;
	informat C5B_Jan best32.;  format C5B_Jan best12.;
	informat C5B_Feb best32.;  format C5B_Feb best12.;
	informat C5B_Mar best32.;  format C5B_Mar best12.;
	informat C5B_Apr best32.;  format C5B_Apr best12.;
	informat C5B_May best32.;  format C5B_May best12.;
	informat C5B_Jun best32.;  format C5B_Jun best12.;
	informat C5B_Jul best32.;  format C5B_Jul best12.;
	informat C5B_Aug best32.;  format C5B_Aug best12.;
	informat C5B_Sep best32.;  format C5B_Sep best12.;
	informat C5B_Oct best32.;  format C5B_Oct best12.;
	informat C5B_Nov best32.;  format C5B_Nov best12.;
	informat C5B_Dec best32.;  format C5B_Dec best12.;
	informat C5B_Score best32.;  format C5B_Score best12.;
	informat C5B_Err $50.;  format C5B_Err $50.;
	informat C5B_Err2 $50.;  format C5B_Err2 $50.;
	informat C5_Jan_Err best32.;  format C5_Jan_Err best12.;
	informat C5_Feb_Err best32.;  format C5_Feb_Err best12.;
	informat C5_Mar_Err best32.;  format C5_Mar_Err best12.;
	informat C5_Apr_Err best32.;  format C5_Apr_Err best12.;
	informat C5_May_Err best32.;  format C5_May_Err best12.;
	informat C5_Jun_Err best32.;  format C5_Jun_Err best12.;
	informat C5_Jul_Err best32.;  format C5_Jul_Err best12.;
	informat C5_Aug_Err best32.;  format C5_Aug_Err best12.;
	informat C5_Sep_Err best32.;  format C5_Sep_Err best12.;
	informat C5_Oct_Err best32.;  format C5_Oct_Err best12.;
	informat C5_Nov_Err best32.;  format C5_Nov_Err best12.;
	informat C5_Dec_Err best32.;  format C5_Dec_Err best12.;
	informat C5_Err_Num best32.;  format C5_Err_Num best12.;
	informat C5_Err_List $100.;  format C5_Err_List $100.;
	informat C5_Err $50.;  format C5_Err $50.;
	informat C6A_Non best32.;  format C6A_Non best12.;
	informat C6A_Jan best32.;  format C6A_Jan best12.;
	informat C6A_Feb best32.;  format C6A_Feb best12.;
	informat C6A_Mar best32.;  format C6A_Mar best12.;
	informat C6A_Apr best32.;  format C6A_Apr best12.;
	informat C6A_May best32.;  format C6A_May best12.;
	informat C6A_Jun best32.;  format C6A_Jun best12.;
	informat C6A_Jul best32.;  format C6A_Jul best12.;
	informat C6A_Aug best32.;  format C6A_Aug best12.;
	informat C6A_Sep best32.;  format C6A_Sep best12.;
	informat C6A_Oct best32.;  format C6A_Oct best12.;
	informat C6A_Nov best32.;  format C6A_Nov best12.;
	informat C6A_Dec best32.;  format C6A_Dec best12.;
	informat C6A_Score best32.;  format C6A_Score best12.;
	informat C6A_Err $50.;  format C6A_Err $50.;
	informat C6A_Err2 $50.;  format C6A_Err2 $50.;
	informat C6B_Non best32.;  format C6B_Non best12.;
	informat C6B_Jan best32.;  format C6B_Jan best12.;
	informat C6B_Feb best32.;  format C6B_Feb best12.;
	informat C6B_Mar best32.;  format C6B_Mar best12.;
	informat C6B_Apr best32.;  format C6B_Apr best12.;
	informat C6B_May best32.;  format C6B_May best12.;
	informat C6B_Jun best32.;  format C6B_Jun best12.;
	informat C6B_Jul best32.;  format C6B_Jul best12.;
	informat C6B_Aug best32.;  format C6B_Aug best12.;
	informat C6B_Sep best32.;  format C6B_Sep best12.;
	informat C6B_Oct best32.;  format C6B_Oct best12.;
	informat C6B_Nov best32.;  format C6B_Nov best12.;
	informat C6B_Dec best32.;  format C6B_Dec best12.;
	informat C6B_Score best32.;  format C6B_Score best12.;
	informat C6B_Err $50.;  format C6B_Err $50.;
	informat C6_Jan_Err best32.;  format C6_Jan_Err best12.;
	informat C6_Feb_Err best32.;  format C6_Feb_Err best12.;
	informat C6_Mar_Err best32.;  format C6_Mar_Err best12.;
	informat C6_Apr_Err best32.;  format C6_Apr_Err best12.;
	informat C6_May_Err best32.;  format C6_May_Err best12.;
	informat C6_Jun_Err best32.;  format C6_Jun_Err best12.;
	informat C6_Jul_Err best32.;  format C6_Jul_Err best12.;
	informat C6_Aug_Err best32.;  format C6_Aug_Err best12.;
	informat C6_Sep_Err best32.;  format C6_Sep_Err best12.;
	informat C6_Oct_Err best32.;  format C6_Oct_Err best12.;
	informat C6_Nov_Err best32.;  format C6_Nov_Err best12.;
	informat C6_Dec_Err best32.;  format C6_Dec_Err best12.;
	informat C6_Err_Num best32.;  format C6_Err_Num best12.;
	informat C6_Err_List $100.;  format C6_Err_List $100.;
	informat C6_Err $50.;  format C6_Err $50.;
	informat C6B_Err2 $50.;  format C6B_Err2 $50.;
	informat CscrJanA best32.;  format CscrJanA best12.;
	informat CscrJanB best32.;  format CscrJanB best12.;
	informat CscrFebA best32.;  format CscrFebA best12.;
	informat CscrFebB best32.;  format CscrFebB best12.;
	informat CscrMarA best32.;  format CscrMarA best12.;
	informat CscrMarB best32.;  format CscrMarB best12.;
	informat CscrAprA best32.;  format CscrAprA best12.;
	informat CscrAprB best32.;  format CscrAprB best12.;
	informat CscrMayA best32.;  format CscrMayA best12.;
	informat CscrMayB best32.;  format CscrMayB best12.;
	informat CscrJunA best32.;  format CscrJunA best12.;
	informat CscrJunB best32.;  format CscrJunB best12.;
	informat CscrJulA best32.;  format CscrJulA best12.;
	informat CscrJulB best32.;  format CscrJulB best12.;
	informat CscrAugA best32.;  format CscrAugA best12.;
	informat CscrAugB best32.;  format CscrAugB best12.;
	informat CscrSepA best32.;  format CscrSepA best12.;
	informat CscrSepB best32.;  format CscrSepB best12.;
	informat CscrOctA best32.;  format CscrOctA best12.;
	informat CscrOctB best32.;  format CscrOctB best12.;
	informat CscrNovA best32.;  format CscrNovA best12.;
	informat CscrNovB best32.;  format CscrNovB best12.;
	informat CscrDecA best32.;  format CscrDecA best12.;
	informat CscrDecB best32.;  format CscrDecB best12.;
	informat CscrNonA best32.;  format CscrNonA best12.;
	informat CscrNonB best32.;  format CscrNonB best12.;
	informat D1 best32.;  format D1 best12.;
	informat D2 best32.;  format D2 best12.;
	informat D3 best32.;  format D3 best12.;
	informat D4 best32.;  format D4 best12.;
	informat D5 best32.;  format D5 best12.;
	informat D6 best32.;  format D6 best12.;
	informat D7 best32.;  format D7 best12.;
	informat D8 best32.;  format D8 best12.;
	informat D9 best32.;  format D9 best12.;
	informat Dscore best32.;  format Dscore best12.;
	informat MDcrit1 best32.;  format MDcrit1 best12.;
	informat MDcrit2 best32.;  format MDcrit2 best12.;
	informat MDcrit3 best32.;  format MDcrit3 best12.;
	informat MDcrit4 best32.;  format MDcrit4 best12.;
	informat MDcrit5 best32.;  format MDcrit5 best12.;
	informat MDcrit6 best32.;  format MDcrit6 best12.;
	informat q1 best32.;  format q1 best12.;
	informat q2 best32.;  format q2 best12.;
	informat d_abnl_sleep best32.;  format d_abnl_sleep best12.;
	informat d_abnl_sleep_cont best32.;  format d_abnl_sleep_cont best12.;
	informat _ask2 best32.;  format _ask2 best12.;
	informat q3 best32.;  format q3 best12.;
	informat q4 best32.;  format q4 best12.;
	informat q5 best32.;  format q5 best12.;
	informat q6 best32.;  format q6 best12.;
	informat q7 best32.;  format q7 best12.;
	informat q8 best32.;  format q8 best12.;
	informat q9 best32.;  format q9 best12.;
	informat q10 best32.;  format q10 best12.;
	informat q11 best32.;  format q11 best12.;
	informat q12 best32.;  format q12 best12.;
	informat q13 best32.;  format q13 best12.;
	informat q14 best32.;  format q14 best12.;
	informat q15 best32.;  format q15 best12.;
	informat q16 best32.;  format q16 best12.;
	informat q17 best32.;  format q17 best12.;
	informat q18 best32.;  format q18 best12.;
	informat q19 best32.;  format q19 best12.;
	informat MEQ best32.;  format MEQ best12.;
	informat MEQstd best32.;  format MEQstd best12.;
	informat DLMO best32.;  format DLMO best12.;
	informat DLMO_h best32.;  format DLMO_h best12.;
	informat DLMO_m best32.;  format DLMO_m best12.;
	informat DLMO_time0 time8.0;  format DLMO_time0 time8.0;
	informat DLMO_time best32.;  format DLMO_time best12.;
	informat SL_ONSET best32.;  format SL_ONSET best12.;
	informat SL_ONSET_h best32.;  format SL_ONSET_h best12.;
	informat SL_ONSET_m best32.;  format SL_ONSET_m best12.;
	informat SL_ONSET_time0 time8.0;  format SL_ONSET_time0 time8.0;
	informat SL_ONSET_time $50.;  format SL_ONSET_time $50.;
	informat LIGHTS_ON best32.;  format LIGHTS_ON best12.;
	informat LIGHTS_ON_h best32.;  format LIGHTS_ON_h best12.;
	informat LIGHTS_ON_m best32.;  format LIGHTS_ON_m best12.;
	informat LIGHTS_ON_time0 time8.0;  format LIGHTS_ON_time0 time8.0;
	informat LIGHTS_ON_time $50.;  format LIGHTS_ON_time $50.;
	informat MEQ_type $50.;  format MEQ_type $50.;
	informat Feedback0 best32.;  format Feedback0 best12.;
	informat Feedback_us $254.;  format Feedback_us $254.;


	INPUT
		UniqueID $
		Finished
		StartDat
		StopDate
		Title $
		Version $
		d_who
		d_study
		d_age
		_ask
		d_sex
		d_eye
		d_country $
		d_state
		_state_name $
		d_los
		d_zip
		d_eth_ai
		d_eth_as
		d_eth_bl
		d_eth_his
		d_eth_hw
		d_eth_wh
		d_working_days
		d_sleep_workday $
		d_sleep_nonworkday $
		d_awake_workday $
		d_awake_nonworkday $
		d_sleep_darkroom
		d_wake_withlight
		d_outsidelight_work
		d_outsidelight_nonwork
		d_height_units
		d_weight_units
		d_height_feet
		d_height_inches
		d_height_meters
		d_weight_pounds
		d_weight_kilograms
		d_height_m
		d_weight_kg
		d_BMI
		askPIDS
		CompletionDate $
		A1
		A2
		A3
		A4
		A5
		A6
		A7
		A8
		A9
		Ascore
		B1
		B2
		B3
		B4
		B5
		B6
		B7
		Bscore
		C1A_Non
		C1A_Jan
		C1A_Feb
		C1A_Mar
		C1A_Apr
		C1A_May
		C1A_Jun
		C1A_Jul
		C1A_Aug
		C1A_Sep
		C1A_Oct
		C1A_Nov
		C1A_Dec
		C1A_Score
		C1A_Err
		C1A_Err2
		C1B_Non
		C1B_Jan
		C1B_Feb
		C1B_Mar
		C1B_Apr
		C1B_May
		C1B_Jun
		C1B_Jul
		C1B_Aug
		C1B_Sep
		C1B_Oct
		C1B_Nov
		C1B_Dec
		C1B_Score
		C1B_Err
		C1B_Err2
		C1_Jan_Err
		C1_Feb_Err
		C1_Mar_Err
		C1_Apr_Err
		C1_May_Err
		C1_Jun_Err
		C1_Jul_Err
		C1_Aug_Err
		C1_Sep_Err
		C1_Oct_Err
		C1_Nov_Err
		C1_Dec_Err
		C1_Err_Num
		C1_Err_List
		C1_Err
		C2A_Non
		C2A_Jan
		C2A_Feb
		C2A_Mar
		C2A_Apr
		C2A_May
		C2A_Jun
		C2A_Jul
		C2A_Aug
		C2A_Sep
		C2A_Oct
		C2A_Nov
		C2A_Dec
		C2A_Score
		C2A_Err
		C2A_Err2
		C2B_Non
		C2B_Jan
		C2B_Feb
		C2B_Mar
		C2B_Apr
		C2B_May
		C2B_Jun
		C2B_Jul
		C2B_Aug
		C2B_Sep
		C2B_Oct
		C2B_Nov
		C2B_Dec
		C2B_Score
		C2B_Err
		C2B_Err2
		C2_Jan_Err
		C2_Feb_Err
		C2_Mar_Err
		C2_Apr_Err
		C2_May_Err
		C2_Jun_Err
		C2_Jul_Err
		C2_Aug_Err
		C2_Sep_Err
		C2_Oct_Err
		C2_Nov_Err
		C2_Dec_Err
		C2_Err_Num
		C2_Err_List
		C2_Err
		C3A_Non
		C3A_Jan
		C3A_Feb
		C3A_Mar
		C3A_Apr
		C3A_May
		C3A_Jun
		C3A_Jul
		C3A_Aug
		C3A_Sep
		C3A_Oct
		C3A_Nov
		C3A_Dec
		C3A_Score
		C3A_Err
		C3A_Err2
		C3B_Non
		C3B_Jan
		C3B_Feb
		C3B_Mar
		C3B_Apr
		C3B_May
		C3B_Jun
		C3B_Jul
		C3B_Aug
		C3B_Sep
		C3B_Oct
		C3B_Nov
		C3B_Dec
		C3B_Score
		C3B_Err
		C3B_Err2
		C3_Jan_Err
		C3_Feb_Err
		C3_Mar_Err
		C3_Apr_Err
		C3_May_Err
		C3_Jun_Err
		C3_Jul_Err
		C3_Aug_Err
		C3_Sep_Err
		C3_Oct_Err
		C3_Nov_Err
		C3_Dec_Err
		C3_Err_Num
		C3_Err_List
		C3_Err
		C4A_Non
		C4A_Jan
		C4A_Feb
		C4A_Mar
		C4A_Apr
		C4A_May
		C4A_Jun
		C4A_Jul
		C4A_Aug
		C4A_Sep
		C4A_Oct
		C4A_Nov
		C4A_Dec
		C4A_Score
		C4A_Err
		C4A_Err2
		C4B_Non
		C4B_Jan
		C4B_Feb
		C4B_Mar
		C4B_Apr
		C4B_May
		C4B_Jun
		C4B_Jul
		C4B_Aug
		C4B_Sep
		C4B_Oct
		C4B_Nov
		C4B_Dec
		C4B_Score
		C4B_Err
		C4B_Err2
		C4_Jan_Err
		C4_Feb_Err
		C4_Mar_Err
		C4_Apr_Err
		C4_May_Err
		C4_Jun_Err
		C4_Jul_Err
		C4_Aug_Err
		C4_Sep_Err
		C4_Oct_Err
		C4_Nov_Err
		C4_Dec_Err
		C4_Err_Num
		C4_Err_List
		C4_Err
		C5A_Non
		C5A_Jan
		C5A_Feb
		C5A_Mar
		C5A_Apr
		C5A_May
		C5A_Jun
		C5A_Jul
		C5A_Aug
		C5A_Sep
		C5A_Oct
		C5A_Nov
		C5A_Dec
		C5A_Score
		C5A_Err
		C5A_Err2
		C5B_Non
		C5B_Jan
		C5B_Feb
		C5B_Mar
		C5B_Apr
		C5B_May
		C5B_Jun
		C5B_Jul
		C5B_Aug
		C5B_Sep
		C5B_Oct
		C5B_Nov
		C5B_Dec
		C5B_Score
		C5B_Err
		C5B_Err2
		C5_Jan_Err
		C5_Feb_Err
		C5_Mar_Err
		C5_Apr_Err
		C5_May_Err
		C5_Jun_Err
		C5_Jul_Err
		C5_Aug_Err
		C5_Sep_Err
		C5_Oct_Err
		C5_Nov_Err
		C5_Dec_Err
		C5_Err_Num
		C5_Err_List
		C5_Err
		C6A_Non
		C6A_Jan
		C6A_Feb
		C6A_Mar
		C6A_Apr
		C6A_May
		C6A_Jun
		C6A_Jul
		C6A_Aug
		C6A_Sep
		C6A_Oct
		C6A_Nov
		C6A_Dec
		C6A_Score
		C6A_Err
		C6A_Err2
		C6B_Non
		C6B_Jan
		C6B_Feb
		C6B_Mar
		C6B_Apr
		C6B_May
		C6B_Jun
		C6B_Jul
		C6B_Aug
		C6B_Sep
		C6B_Oct
		C6B_Nov
		C6B_Dec
		C6B_Score
		C6B_Err
		C6_Jan_Err
		C6_Feb_Err
		C6_Mar_Err
		C6_Apr_Err
		C6_May_Err
		C6_Jun_Err
		C6_Jul_Err
		C6_Aug_Err
		C6_Sep_Err
		C6_Oct_Err
		C6_Nov_Err
		C6_Dec_Err
		C6_Err_Num
		C6_Err_List
		C6_Err
		C6B_Err2
		CscrJanA
		CscrJanB
		CscrFebA
		CscrFebB
		CscrMarA
		CscrMarB
		CscrAprA
		CscrAprB
		CscrMayA
		CscrMayB
		CscrJunA
		CscrJunB
		CscrJulA
		CscrJulB
		CscrAugA
		CscrAugB
		CscrSepA
		CscrSepB
		CscrOctA
		CscrOctB
		CscrNovA
		CscrNovB
		CscrDecA
		CscrDecB
		CscrNonA
		CscrNonB
		D1
		D2
		D3
		D4
		D5
		D6
		D7
		D8
		D9
		Dscore
		MDcrit1
		MDcrit2
		MDcrit3
		MDcrit4
		MDcrit5
		MDcrit6
		q1
		q2
		d_abnl_sleep
		d_abnl_sleep_cont
		_ask2
		q3
		q4
		q5
		q6
		q7
		q8
		q9
		q10
		q11
		q12
		q13
		q14
		q15
		q16
		q17
		q18
		q19
		MEQ
		MEQstd
		DLMO
		DLMO_h
		DLMO_m
		DLMO_time0
		DLMO_time
		SL_ONSET
		SL_ONSET_h
		SL_ONSET_m
		SL_ONSET_time0
		SL_ONSET_time $
		LIGHTS_ON
		LIGHTS_ON_h
		LIGHTS_ON_m
		LIGHTS_ON_time0
		LIGHTS_ON_time $
		MEQ_type $
		Feedback0
		Feedback_us
		;
	if _ERROR_ then call symput('_EFIERR_',1);  /* set ERROR detection macro variable */
	
if (Finished = 44444 or Finished = 55555 or Finished = 99999) then Finished = .;
if (StartDat = 44444 or StartDat = 55555 or StartDat = 99999) then StartDat = .;
if (StopDate = 44444 or StopDate = 55555 or StopDate = 99999) then StopDate = .;
if (d_who = 44444 or d_who = 55555 or d_who = 99999) then d_who = .;
if (d_study = 44444 or d_study = 55555 or d_study = 99999) then d_study = .;
if (d_age = 44444 or d_age = 55555 or d_age = 99999) then d_age = .;
if (_ask = 44444 or _ask = 55555 or _ask = 99999) then _ask = .;
if (d_sex = 44444 or d_sex = 55555 or d_sex = 99999) then d_sex = .;
if (d_eye = 44444 or d_eye = 55555 or d_eye = 99999) then d_eye = .;
if (d_state = 44444 or d_state = 55555 or d_state = 99999) then d_state = .;
if (d_los = 44444 or d_los = 55555 or d_los = 99999) then d_los = .;
if (d_zip = 44444 or d_zip = 55555 or d_zip = 99999) then d_zip = .;
if (d_eth_ai = 44444 or d_eth_ai = 55555 or d_eth_ai = 99999) then d_eth_ai = .;
if (d_eth_as = 44444 or d_eth_as = 55555 or d_eth_as = 99999) then d_eth_as = .;
if (d_eth_bl = 44444 or d_eth_bl = 55555 or d_eth_bl = 99999) then d_eth_bl = .;
if (d_eth_his = 44444 or d_eth_his = 55555 or d_eth_his = 99999) then d_eth_his = .;
if (d_eth_hw = 44444 or d_eth_hw = 55555 or d_eth_hw = 99999) then d_eth_hw = .;
if (d_eth_wh = 44444 or d_eth_wh = 55555 or d_eth_wh = 99999) then d_eth_wh = .;
if (d_working_days = 44444 or d_working_days = 55555 or d_working_days = 99999) then d_working_days = .;
if (d_sleep_darkroom = 44444 or d_sleep_darkroom = 55555 or d_sleep_darkroom = 99999) then d_sleep_darkroom = .;
if (d_wake_withlight = 44444 or d_wake_withlight = 55555 or d_wake_withlight = 99999) then d_wake_withlight = .;
if (d_outsidelight_work = 44444 or d_outsidelight_work = 55555 or d_outsidelight_work = 99999) then d_outsidelight_work = .;
if (d_outsidelight_nonwork = 44444 or d_outsidelight_nonwork = 55555 or d_outsidelight_nonwork = 99999) then d_outsidelight_nonwork = .;
if (d_height_units = 44444 or d_height_units = 55555 or d_height_units = 99999) then d_height_units = .;
if (d_weight_units = 44444 or d_weight_units = 55555 or d_weight_units = 99999) then d_weight_units = .;
if (d_height_feet = 44444 or d_height_feet = 55555 or d_height_feet = 99999) then d_height_feet = .;
if (d_height_inches = 44444 or d_height_inches = 55555 or d_height_inches = 99999) then d_height_inches = .;
if (d_height_meters = 44444 or d_height_meters = 55555 or d_height_meters = 99999) then d_height_meters = .;
if (d_weight_pounds = 44444 or d_weight_pounds = 55555 or d_weight_pounds = 99999) then d_weight_pounds = .;
if (d_weight_kilograms = 44444 or d_weight_kilograms = 55555 or d_weight_kilograms = 99999) then d_weight_kilograms = .;
if (d_height_m = 44444 or d_height_m = 55555 or d_height_m = 99999) then d_height_m = .;
if (d_weight_kg = 44444 or d_weight_kg = 55555 or d_weight_kg = 99999) then d_weight_kg = .;
if (d_BMI = 44444 or d_BMI = 55555 or d_BMI = 99999) then d_BMI = .;
if (askPIDS = 44444 or askPIDS = 55555 or askPIDS = 99999) then askPIDS = .;
if (A1 = 44444 or A1 = 55555 or A1 = 99999) then A1 = .;
if (A2 = 44444 or A2 = 55555 or A2 = 99999) then A2 = .;
if (A3 = 44444 or A3 = 55555 or A3 = 99999) then A3 = .;
if (A4 = 44444 or A4 = 55555 or A4 = 99999) then A4 = .;
if (A5 = 44444 or A5 = 55555 or A5 = 99999) then A5 = .;
if (A6 = 44444 or A6 = 55555 or A6 = 99999) then A6 = .;
if (A7 = 44444 or A7 = 55555 or A7 = 99999) then A7 = .;
if (A8 = 44444 or A8 = 55555 or A8 = 99999) then A8 = .;
if (A9 = 44444 or A9 = 55555 or A9 = 99999) then A9 = .;
if (Ascore = 44444 or Ascore = 55555 or Ascore = 99999) then Ascore = .;
if (B1 = 44444 or B1 = 55555 or B1 = 99999) then B1 = .;
if (B2 = 44444 or B2 = 55555 or B2 = 99999) then B2 = .;
if (B3 = 44444 or B3 = 55555 or B3 = 99999) then B3 = .;
if (B4 = 44444 or B4 = 55555 or B4 = 99999) then B4 = .;
if (B5 = 44444 or B5 = 55555 or B5 = 99999) then B5 = .;
if (B6 = 44444 or B6 = 55555 or B6 = 99999) then B6 = .;
if (B7 = 44444 or B7 = 55555 or B7 = 99999) then B7 = .;
if (Bscore = 44444 or Bscore = 55555 or Bscore = 99999) then Bscore = .;
if (C1A_Non = 44444 or C1A_Non = 55555 or C1A_Non = 99999) then C1A_Non = .;
if (C1A_Jan = 44444 or C1A_Jan = 55555 or C1A_Jan = 99999) then C1A_Jan = .;
if (C1A_Feb = 44444 or C1A_Feb = 55555 or C1A_Feb = 99999) then C1A_Feb = .;
if (C1A_Mar = 44444 or C1A_Mar = 55555 or C1A_Mar = 99999) then C1A_Mar = .;
if (C1A_Apr = 44444 or C1A_Apr = 55555 or C1A_Apr = 99999) then C1A_Apr = .;
if (C1A_May = 44444 or C1A_May = 55555 or C1A_May = 99999) then C1A_May = .;
if (C1A_Jun = 44444 or C1A_Jun = 55555 or C1A_Jun = 99999) then C1A_Jun = .;
if (C1A_Jul = 44444 or C1A_Jul = 55555 or C1A_Jul = 99999) then C1A_Jul = .;
if (C1A_Aug = 44444 or C1A_Aug = 55555 or C1A_Aug = 99999) then C1A_Aug = .;
if (C1A_Sep = 44444 or C1A_Sep = 55555 or C1A_Sep = 99999) then C1A_Sep = .;
if (C1A_Oct = 44444 or C1A_Oct = 55555 or C1A_Oct = 99999) then C1A_Oct = .;
if (C1A_Nov = 44444 or C1A_Nov = 55555 or C1A_Nov = 99999) then C1A_Nov = .;
if (C1A_Dec = 44444 or C1A_Dec = 55555 or C1A_Dec = 99999) then C1A_Dec = .;
if (C1A_Score = 44444 or C1A_Score = 55555 or C1A_Score = 99999) then C1A_Score = .;
if (C1B_Non = 44444 or C1B_Non = 55555 or C1B_Non = 99999) then C1B_Non = .;
if (C1B_Jan = 44444 or C1B_Jan = 55555 or C1B_Jan = 99999) then C1B_Jan = .;
if (C1B_Feb = 44444 or C1B_Feb = 55555 or C1B_Feb = 99999) then C1B_Feb = .;
if (C1B_Mar = 44444 or C1B_Mar = 55555 or C1B_Mar = 99999) then C1B_Mar = .;
if (C1B_Apr = 44444 or C1B_Apr = 55555 or C1B_Apr = 99999) then C1B_Apr = .;
if (C1B_May = 44444 or C1B_May = 55555 or C1B_May = 99999) then C1B_May = .;
if (C1B_Jun = 44444 or C1B_Jun = 55555 or C1B_Jun = 99999) then C1B_Jun = .;
if (C1B_Jul = 44444 or C1B_Jul = 55555 or C1B_Jul = 99999) then C1B_Jul = .;
if (C1B_Aug = 44444 or C1B_Aug = 55555 or C1B_Aug = 99999) then C1B_Aug = .;
if (C1B_Sep = 44444 or C1B_Sep = 55555 or C1B_Sep = 99999) then C1B_Sep = .;
if (C1B_Oct = 44444 or C1B_Oct = 55555 or C1B_Oct = 99999) then C1B_Oct = .;
if (C1B_Nov = 44444 or C1B_Nov = 55555 or C1B_Nov = 99999) then C1B_Nov = .;
if (C1B_Dec = 44444 or C1B_Dec = 55555 or C1B_Dec = 99999) then C1B_Dec = .;
if (C1B_Score = 44444 or C1B_Score = 55555 or C1B_Score = 99999) then C1B_Score = .;
if (C1_Jan_Err = 44444 or C1_Jan_Err = 55555 or C1_Jan_Err = 99999) then C1_Jan_Err = .;
if (C1_Feb_Err = 44444 or C1_Feb_Err = 55555 or C1_Feb_Err = 99999) then C1_Feb_Err = .;
if (C1_Mar_Err = 44444 or C1_Mar_Err = 55555 or C1_Mar_Err = 99999) then C1_Mar_Err = .;
if (C1_Apr_Err = 44444 or C1_Apr_Err = 55555 or C1_Apr_Err = 99999) then C1_Apr_Err = .;
if (C1_May_Err = 44444 or C1_May_Err = 55555 or C1_May_Err = 99999) then C1_May_Err = .;
if (C1_Jun_Err = 44444 or C1_Jun_Err = 55555 or C1_Jun_Err = 99999) then C1_Jun_Err = .;
if (C1_Jul_Err = 44444 or C1_Jul_Err = 55555 or C1_Jul_Err = 99999) then C1_Jul_Err = .;
if (C1_Aug_Err = 44444 or C1_Aug_Err = 55555 or C1_Aug_Err = 99999) then C1_Aug_Err = .;
if (C1_Sep_Err = 44444 or C1_Sep_Err = 55555 or C1_Sep_Err = 99999) then C1_Sep_Err = .;
if (C1_Oct_Err = 44444 or C1_Oct_Err = 55555 or C1_Oct_Err = 99999) then C1_Oct_Err = .;
if (C1_Nov_Err = 44444 or C1_Nov_Err = 55555 or C1_Nov_Err = 99999) then C1_Nov_Err = .;
if (C1_Dec_Err = 44444 or C1_Dec_Err = 55555 or C1_Dec_Err = 99999) then C1_Dec_Err = .;
if (C1_Err_Num = 44444 or C1_Err_Num = 55555 or C1_Err_Num = 99999) then C1_Err_Num = .;
if (C2A_Non = 44444 or C2A_Non = 55555 or C2A_Non = 99999) then C2A_Non = .;
if (C2A_Jan = 44444 or C2A_Jan = 55555 or C2A_Jan = 99999) then C2A_Jan = .;
if (C2A_Feb = 44444 or C2A_Feb = 55555 or C2A_Feb = 99999) then C2A_Feb = .;
if (C2A_Mar = 44444 or C2A_Mar = 55555 or C2A_Mar = 99999) then C2A_Mar = .;
if (C2A_Apr = 44444 or C2A_Apr = 55555 or C2A_Apr = 99999) then C2A_Apr = .;
if (C2A_May = 44444 or C2A_May = 55555 or C2A_May = 99999) then C2A_May = .;
if (C2A_Jun = 44444 or C2A_Jun = 55555 or C2A_Jun = 99999) then C2A_Jun = .;
if (C2A_Jul = 44444 or C2A_Jul = 55555 or C2A_Jul = 99999) then C2A_Jul = .;
if (C2A_Aug = 44444 or C2A_Aug = 55555 or C2A_Aug = 99999) then C2A_Aug = .;
if (C2A_Sep = 44444 or C2A_Sep = 55555 or C2A_Sep = 99999) then C2A_Sep = .;
if (C2A_Oct = 44444 or C2A_Oct = 55555 or C2A_Oct = 99999) then C2A_Oct = .;
if (C2A_Nov = 44444 or C2A_Nov = 55555 or C2A_Nov = 99999) then C2A_Nov = .;
if (C2A_Dec = 44444 or C2A_Dec = 55555 or C2A_Dec = 99999) then C2A_Dec = .;
if (C2A_Score = 44444 or C2A_Score = 55555 or C2A_Score = 99999) then C2A_Score = .;
if (C2B_Non = 44444 or C2B_Non = 55555 or C2B_Non = 99999) then C2B_Non = .;
if (C2B_Jan = 44444 or C2B_Jan = 55555 or C2B_Jan = 99999) then C2B_Jan = .;
if (C2B_Feb = 44444 or C2B_Feb = 55555 or C2B_Feb = 99999) then C2B_Feb = .;
if (C2B_Mar = 44444 or C2B_Mar = 55555 or C2B_Mar = 99999) then C2B_Mar = .;
if (C2B_Apr = 44444 or C2B_Apr = 55555 or C2B_Apr = 99999) then C2B_Apr = .;
if (C2B_May = 44444 or C2B_May = 55555 or C2B_May = 99999) then C2B_May = .;
if (C2B_Jun = 44444 or C2B_Jun = 55555 or C2B_Jun = 99999) then C2B_Jun = .;
if (C2B_Jul = 44444 or C2B_Jul = 55555 or C2B_Jul = 99999) then C2B_Jul = .;
if (C2B_Aug = 44444 or C2B_Aug = 55555 or C2B_Aug = 99999) then C2B_Aug = .;
if (C2B_Sep = 44444 or C2B_Sep = 55555 or C2B_Sep = 99999) then C2B_Sep = .;
if (C2B_Oct = 44444 or C2B_Oct = 55555 or C2B_Oct = 99999) then C2B_Oct = .;
if (C2B_Nov = 44444 or C2B_Nov = 55555 or C2B_Nov = 99999) then C2B_Nov = .;
if (C2B_Dec = 44444 or C2B_Dec = 55555 or C2B_Dec = 99999) then C2B_Dec = .;
if (C2B_Score = 44444 or C2B_Score = 55555 or C2B_Score = 99999) then C2B_Score = .;
if (C2_Jan_Err = 44444 or C2_Jan_Err = 55555 or C2_Jan_Err = 99999) then C2_Jan_Err = .;
if (C2_Feb_Err = 44444 or C2_Feb_Err = 55555 or C2_Feb_Err = 99999) then C2_Feb_Err = .;
if (C2_Mar_Err = 44444 or C2_Mar_Err = 55555 or C2_Mar_Err = 99999) then C2_Mar_Err = .;
if (C2_Apr_Err = 44444 or C2_Apr_Err = 55555 or C2_Apr_Err = 99999) then C2_Apr_Err = .;
if (C2_May_Err = 44444 or C2_May_Err = 55555 or C2_May_Err = 99999) then C2_May_Err = .;
if (C2_Jun_Err = 44444 or C2_Jun_Err = 55555 or C2_Jun_Err = 99999) then C2_Jun_Err = .;
if (C2_Jul_Err = 44444 or C2_Jul_Err = 55555 or C2_Jul_Err = 99999) then C2_Jul_Err = .;
if (C2_Aug_Err = 44444 or C2_Aug_Err = 55555 or C2_Aug_Err = 99999) then C2_Aug_Err = .;
if (C2_Sep_Err = 44444 or C2_Sep_Err = 55555 or C2_Sep_Err = 99999) then C2_Sep_Err = .;
if (C2_Oct_Err = 44444 or C2_Oct_Err = 55555 or C2_Oct_Err = 99999) then C2_Oct_Err = .;
if (C2_Nov_Err = 44444 or C2_Nov_Err = 55555 or C2_Nov_Err = 99999) then C2_Nov_Err = .;
if (C2_Dec_Err = 44444 or C2_Dec_Err = 55555 or C2_Dec_Err = 99999) then C2_Dec_Err = .;
if (C2_Err_Num = 44444 or C2_Err_Num = 55555 or C2_Err_Num = 99999) then C2_Err_Num = .;
if (C3A_Non = 44444 or C3A_Non = 55555 or C3A_Non = 99999) then C3A_Non = .;
if (C3A_Jan = 44444 or C3A_Jan = 55555 or C3A_Jan = 99999) then C3A_Jan = .;
if (C3A_Feb = 44444 or C3A_Feb = 55555 or C3A_Feb = 99999) then C3A_Feb = .;
if (C3A_Mar = 44444 or C3A_Mar = 55555 or C3A_Mar = 99999) then C3A_Mar = .;
if (C3A_Apr = 44444 or C3A_Apr = 55555 or C3A_Apr = 99999) then C3A_Apr = .;
if (C3A_May = 44444 or C3A_May = 55555 or C3A_May = 99999) then C3A_May = .;
if (C3A_Jun = 44444 or C3A_Jun = 55555 or C3A_Jun = 99999) then C3A_Jun = .;
if (C3A_Jul = 44444 or C3A_Jul = 55555 or C3A_Jul = 99999) then C3A_Jul = .;
if (C3A_Aug = 44444 or C3A_Aug = 55555 or C3A_Aug = 99999) then C3A_Aug = .;
if (C3A_Sep = 44444 or C3A_Sep = 55555 or C3A_Sep = 99999) then C3A_Sep = .;
if (C3A_Oct = 44444 or C3A_Oct = 55555 or C3A_Oct = 99999) then C3A_Oct = .;
if (C3A_Nov = 44444 or C3A_Nov = 55555 or C3A_Nov = 99999) then C3A_Nov = .;
if (C3A_Dec = 44444 or C3A_Dec = 55555 or C3A_Dec = 99999) then C3A_Dec = .;
if (C3A_Score = 44444 or C3A_Score = 55555 or C3A_Score = 99999) then C3A_Score = .;
if (C3B_Non = 44444 or C3B_Non = 55555 or C3B_Non = 99999) then C3B_Non = .;
if (C3B_Jan = 44444 or C3B_Jan = 55555 or C3B_Jan = 99999) then C3B_Jan = .;
if (C3B_Feb = 44444 or C3B_Feb = 55555 or C3B_Feb = 99999) then C3B_Feb = .;
if (C3B_Mar = 44444 or C3B_Mar = 55555 or C3B_Mar = 99999) then C3B_Mar = .;
if (C3B_Apr = 44444 or C3B_Apr = 55555 or C3B_Apr = 99999) then C3B_Apr = .;
if (C3B_May = 44444 or C3B_May = 55555 or C3B_May = 99999) then C3B_May = .;
if (C3B_Jun = 44444 or C3B_Jun = 55555 or C3B_Jun = 99999) then C3B_Jun = .;
if (C3B_Jul = 44444 or C3B_Jul = 55555 or C3B_Jul = 99999) then C3B_Jul = .;
if (C3B_Aug = 44444 or C3B_Aug = 55555 or C3B_Aug = 99999) then C3B_Aug = .;
if (C3B_Sep = 44444 or C3B_Sep = 55555 or C3B_Sep = 99999) then C3B_Sep = .;
if (C3B_Oct = 44444 or C3B_Oct = 55555 or C3B_Oct = 99999) then C3B_Oct = .;
if (C3B_Nov = 44444 or C3B_Nov = 55555 or C3B_Nov = 99999) then C3B_Nov = .;
if (C3B_Dec = 44444 or C3B_Dec = 55555 or C3B_Dec = 99999) then C3B_Dec = .;
if (C3B_Score = 44444 or C3B_Score = 55555 or C3B_Score = 99999) then C3B_Score = .;
if (C3_Jan_Err = 44444 or C3_Jan_Err = 55555 or C3_Jan_Err = 99999) then C3_Jan_Err = .;
if (C3_Feb_Err = 44444 or C3_Feb_Err = 55555 or C3_Feb_Err = 99999) then C3_Feb_Err = .;
if (C3_Mar_Err = 44444 or C3_Mar_Err = 55555 or C3_Mar_Err = 99999) then C3_Mar_Err = .;
if (C3_Apr_Err = 44444 or C3_Apr_Err = 55555 or C3_Apr_Err = 99999) then C3_Apr_Err = .;
if (C3_May_Err = 44444 or C3_May_Err = 55555 or C3_May_Err = 99999) then C3_May_Err = .;
if (C3_Jun_Err = 44444 or C3_Jun_Err = 55555 or C3_Jun_Err = 99999) then C3_Jun_Err = .;
if (C3_Jul_Err = 44444 or C3_Jul_Err = 55555 or C3_Jul_Err = 99999) then C3_Jul_Err = .;
if (C3_Aug_Err = 44444 or C3_Aug_Err = 55555 or C3_Aug_Err = 99999) then C3_Aug_Err = .;
if (C3_Sep_Err = 44444 or C3_Sep_Err = 55555 or C3_Sep_Err = 99999) then C3_Sep_Err = .;
if (C3_Oct_Err = 44444 or C3_Oct_Err = 55555 or C3_Oct_Err = 99999) then C3_Oct_Err = .;
if (C3_Nov_Err = 44444 or C3_Nov_Err = 55555 or C3_Nov_Err = 99999) then C3_Nov_Err = .;
if (C3_Dec_Err = 44444 or C3_Dec_Err = 55555 or C3_Dec_Err = 99999) then C3_Dec_Err = .;
if (C3_Err_Num = 44444 or C3_Err_Num = 55555 or C3_Err_Num = 99999) then C3_Err_Num = .;
if (C4A_Non = 44444 or C4A_Non = 55555 or C4A_Non = 99999) then C4A_Non = .;
if (C4A_Jan = 44444 or C4A_Jan = 55555 or C4A_Jan = 99999) then C4A_Jan = .;
if (C4A_Feb = 44444 or C4A_Feb = 55555 or C4A_Feb = 99999) then C4A_Feb = .;
if (C4A_Mar = 44444 or C4A_Mar = 55555 or C4A_Mar = 99999) then C4A_Mar = .;
if (C4A_Apr = 44444 or C4A_Apr = 55555 or C4A_Apr = 99999) then C4A_Apr = .;
if (C4A_May = 44444 or C4A_May = 55555 or C4A_May = 99999) then C4A_May = .;
if (C4A_Jun = 44444 or C4A_Jun = 55555 or C4A_Jun = 99999) then C4A_Jun = .;
if (C4A_Jul = 44444 or C4A_Jul = 55555 or C4A_Jul = 99999) then C4A_Jul = .;
if (C4A_Aug = 44444 or C4A_Aug = 55555 or C4A_Aug = 99999) then C4A_Aug = .;
if (C4A_Sep = 44444 or C4A_Sep = 55555 or C4A_Sep = 99999) then C4A_Sep = .;
if (C4A_Oct = 44444 or C4A_Oct = 55555 or C4A_Oct = 99999) then C4A_Oct = .;
if (C4A_Nov = 44444 or C4A_Nov = 55555 or C4A_Nov = 99999) then C4A_Nov = .;
if (C4A_Dec = 44444 or C4A_Dec = 55555 or C4A_Dec = 99999) then C4A_Dec = .;
if (C4A_Score = 44444 or C4A_Score = 55555 or C4A_Score = 99999) then C4A_Score = .;
if (C4B_Non = 44444 or C4B_Non = 55555 or C4B_Non = 99999) then C4B_Non = .;
if (C4B_Jan = 44444 or C4B_Jan = 55555 or C4B_Jan = 99999) then C4B_Jan = .;
if (C4B_Feb = 44444 or C4B_Feb = 55555 or C4B_Feb = 99999) then C4B_Feb = .;
if (C4B_Mar = 44444 or C4B_Mar = 55555 or C4B_Mar = 99999) then C4B_Mar = .;
if (C4B_Apr = 44444 or C4B_Apr = 55555 or C4B_Apr = 99999) then C4B_Apr = .;
if (C4B_May = 44444 or C4B_May = 55555 or C4B_May = 99999) then C4B_May = .;
if (C4B_Jun = 44444 or C4B_Jun = 55555 or C4B_Jun = 99999) then C4B_Jun = .;
if (C4B_Jul = 44444 or C4B_Jul = 55555 or C4B_Jul = 99999) then C4B_Jul = .;
if (C4B_Aug = 44444 or C4B_Aug = 55555 or C4B_Aug = 99999) then C4B_Aug = .;
if (C4B_Sep = 44444 or C4B_Sep = 55555 or C4B_Sep = 99999) then C4B_Sep = .;
if (C4B_Oct = 44444 or C4B_Oct = 55555 or C4B_Oct = 99999) then C4B_Oct = .;
if (C4B_Nov = 44444 or C4B_Nov = 55555 or C4B_Nov = 99999) then C4B_Nov = .;
if (C4B_Dec = 44444 or C4B_Dec = 55555 or C4B_Dec = 99999) then C4B_Dec = .;
if (C4B_Score = 44444 or C4B_Score = 55555 or C4B_Score = 99999) then C4B_Score = .;
if (C4_Jan_Err = 44444 or C4_Jan_Err = 55555 or C4_Jan_Err = 99999) then C4_Jan_Err = .;
if (C4_Feb_Err = 44444 or C4_Feb_Err = 55555 or C4_Feb_Err = 99999) then C4_Feb_Err = .;
if (C4_Mar_Err = 44444 or C4_Mar_Err = 55555 or C4_Mar_Err = 99999) then C4_Mar_Err = .;
if (C4_Apr_Err = 44444 or C4_Apr_Err = 55555 or C4_Apr_Err = 99999) then C4_Apr_Err = .;
if (C4_May_Err = 44444 or C4_May_Err = 55555 or C4_May_Err = 99999) then C4_May_Err = .;
if (C4_Jun_Err = 44444 or C4_Jun_Err = 55555 or C4_Jun_Err = 99999) then C4_Jun_Err = .;
if (C4_Jul_Err = 44444 or C4_Jul_Err = 55555 or C4_Jul_Err = 99999) then C4_Jul_Err = .;
if (C4_Aug_Err = 44444 or C4_Aug_Err = 55555 or C4_Aug_Err = 99999) then C4_Aug_Err = .;
if (C4_Sep_Err = 44444 or C4_Sep_Err = 55555 or C4_Sep_Err = 99999) then C4_Sep_Err = .;
if (C4_Oct_Err = 44444 or C4_Oct_Err = 55555 or C4_Oct_Err = 99999) then C4_Oct_Err = .;
if (C4_Nov_Err = 44444 or C4_Nov_Err = 55555 or C4_Nov_Err = 99999) then C4_Nov_Err = .;
if (C4_Dec_Err = 44444 or C4_Dec_Err = 55555 or C4_Dec_Err = 99999) then C4_Dec_Err = .;
if (C4_Err_Num = 44444 or C4_Err_Num = 55555 or C4_Err_Num = 99999) then C4_Err_Num = .;
if (C5A_Non = 44444 or C5A_Non = 55555 or C5A_Non = 99999) then C5A_Non = .;
if (C5A_Jan = 44444 or C5A_Jan = 55555 or C5A_Jan = 99999) then C5A_Jan = .;
if (C5A_Feb = 44444 or C5A_Feb = 55555 or C5A_Feb = 99999) then C5A_Feb = .;
if (C5A_Mar = 44444 or C5A_Mar = 55555 or C5A_Mar = 99999) then C5A_Mar = .;
if (C5A_Apr = 44444 or C5A_Apr = 55555 or C5A_Apr = 99999) then C5A_Apr = .;
if (C5A_May = 44444 or C5A_May = 55555 or C5A_May = 99999) then C5A_May = .;
if (C5A_Jun = 44444 or C5A_Jun = 55555 or C5A_Jun = 99999) then C5A_Jun = .;
if (C5A_Jul = 44444 or C5A_Jul = 55555 or C5A_Jul = 99999) then C5A_Jul = .;
if (C5A_Aug = 44444 or C5A_Aug = 55555 or C5A_Aug = 99999) then C5A_Aug = .;
if (C5A_Sep = 44444 or C5A_Sep = 55555 or C5A_Sep = 99999) then C5A_Sep = .;
if (C5A_Oct = 44444 or C5A_Oct = 55555 or C5A_Oct = 99999) then C5A_Oct = .;
if (C5A_Nov = 44444 or C5A_Nov = 55555 or C5A_Nov = 99999) then C5A_Nov = .;
if (C5A_Dec = 44444 or C5A_Dec = 55555 or C5A_Dec = 99999) then C5A_Dec = .;
if (C5A_Score = 44444 or C5A_Score = 55555 or C5A_Score = 99999) then C5A_Score = .;
if (C5B_Non = 44444 or C5B_Non = 55555 or C5B_Non = 99999) then C5B_Non = .;
if (C5B_Jan = 44444 or C5B_Jan = 55555 or C5B_Jan = 99999) then C5B_Jan = .;
if (C5B_Feb = 44444 or C5B_Feb = 55555 or C5B_Feb = 99999) then C5B_Feb = .;
if (C5B_Mar = 44444 or C5B_Mar = 55555 or C5B_Mar = 99999) then C5B_Mar = .;
if (C5B_Apr = 44444 or C5B_Apr = 55555 or C5B_Apr = 99999) then C5B_Apr = .;
if (C5B_May = 44444 or C5B_May = 55555 or C5B_May = 99999) then C5B_May = .;
if (C5B_Jun = 44444 or C5B_Jun = 55555 or C5B_Jun = 99999) then C5B_Jun = .;
if (C5B_Jul = 44444 or C5B_Jul = 55555 or C5B_Jul = 99999) then C5B_Jul = .;
if (C5B_Aug = 44444 or C5B_Aug = 55555 or C5B_Aug = 99999) then C5B_Aug = .;
if (C5B_Sep = 44444 or C5B_Sep = 55555 or C5B_Sep = 99999) then C5B_Sep = .;
if (C5B_Oct = 44444 or C5B_Oct = 55555 or C5B_Oct = 99999) then C5B_Oct = .;
if (C5B_Nov = 44444 or C5B_Nov = 55555 or C5B_Nov = 99999) then C5B_Nov = .;
if (C5B_Dec = 44444 or C5B_Dec = 55555 or C5B_Dec = 99999) then C5B_Dec = .;
if (C5B_Score = 44444 or C5B_Score = 55555 or C5B_Score = 99999) then C5B_Score = .;
if (C5_Jan_Err = 44444 or C5_Jan_Err = 55555 or C5_Jan_Err = 99999) then C5_Jan_Err = .;
if (C5_Feb_Err = 44444 or C5_Feb_Err = 55555 or C5_Feb_Err = 99999) then C5_Feb_Err = .;
if (C5_Mar_Err = 44444 or C5_Mar_Err = 55555 or C5_Mar_Err = 99999) then C5_Mar_Err = .;
if (C5_Apr_Err = 44444 or C5_Apr_Err = 55555 or C5_Apr_Err = 99999) then C5_Apr_Err = .;
if (C5_May_Err = 44444 or C5_May_Err = 55555 or C5_May_Err = 99999) then C5_May_Err = .;
if (C5_Jun_Err = 44444 or C5_Jun_Err = 55555 or C5_Jun_Err = 99999) then C5_Jun_Err = .;
if (C5_Jul_Err = 44444 or C5_Jul_Err = 55555 or C5_Jul_Err = 99999) then C5_Jul_Err = .;
if (C5_Aug_Err = 44444 or C5_Aug_Err = 55555 or C5_Aug_Err = 99999) then C5_Aug_Err = .;
if (C5_Sep_Err = 44444 or C5_Sep_Err = 55555 or C5_Sep_Err = 99999) then C5_Sep_Err = .;
if (C5_Oct_Err = 44444 or C5_Oct_Err = 55555 or C5_Oct_Err = 99999) then C5_Oct_Err = .;
if (C5_Nov_Err = 44444 or C5_Nov_Err = 55555 or C5_Nov_Err = 99999) then C5_Nov_Err = .;
if (C5_Dec_Err = 44444 or C5_Dec_Err = 55555 or C5_Dec_Err = 99999) then C5_Dec_Err = .;
if (C5_Err_Num = 44444 or C5_Err_Num = 55555 or C5_Err_Num = 99999) then C5_Err_Num = .;
if (C6A_Non = 44444 or C6A_Non = 55555 or C6A_Non = 99999) then C6A_Non = .;
if (C6A_Jan = 44444 or C6A_Jan = 55555 or C6A_Jan = 99999) then C6A_Jan = .;
if (C6A_Feb = 44444 or C6A_Feb = 55555 or C6A_Feb = 99999) then C6A_Feb = .;
if (C6A_Mar = 44444 or C6A_Mar = 55555 or C6A_Mar = 99999) then C6A_Mar = .;
if (C6A_Apr = 44444 or C6A_Apr = 55555 or C6A_Apr = 99999) then C6A_Apr = .;
if (C6A_May = 44444 or C6A_May = 55555 or C6A_May = 99999) then C6A_May = .;
if (C6A_Jun = 44444 or C6A_Jun = 55555 or C6A_Jun = 99999) then C6A_Jun = .;
if (C6A_Jul = 44444 or C6A_Jul = 55555 or C6A_Jul = 99999) then C6A_Jul = .;
if (C6A_Aug = 44444 or C6A_Aug = 55555 or C6A_Aug = 99999) then C6A_Aug = .;
if (C6A_Sep = 44444 or C6A_Sep = 55555 or C6A_Sep = 99999) then C6A_Sep = .;
if (C6A_Oct = 44444 or C6A_Oct = 55555 or C6A_Oct = 99999) then C6A_Oct = .;
if (C6A_Nov = 44444 or C6A_Nov = 55555 or C6A_Nov = 99999) then C6A_Nov = .;
if (C6A_Dec = 44444 or C6A_Dec = 55555 or C6A_Dec = 99999) then C6A_Dec = .;
if (C6A_Score = 44444 or C6A_Score = 55555 or C6A_Score = 99999) then C6A_Score = .;
if (C6B_Non = 44444 or C6B_Non = 55555 or C6B_Non = 99999) then C6B_Non = .;
if (C6B_Jan = 44444 or C6B_Jan = 55555 or C6B_Jan = 99999) then C6B_Jan = .;
if (C6B_Feb = 44444 or C6B_Feb = 55555 or C6B_Feb = 99999) then C6B_Feb = .;
if (C6B_Mar = 44444 or C6B_Mar = 55555 or C6B_Mar = 99999) then C6B_Mar = .;
if (C6B_Apr = 44444 or C6B_Apr = 55555 or C6B_Apr = 99999) then C6B_Apr = .;
if (C6B_May = 44444 or C6B_May = 55555 or C6B_May = 99999) then C6B_May = .;
if (C6B_Jun = 44444 or C6B_Jun = 55555 or C6B_Jun = 99999) then C6B_Jun = .;
if (C6B_Jul = 44444 or C6B_Jul = 55555 or C6B_Jul = 99999) then C6B_Jul = .;
if (C6B_Aug = 44444 or C6B_Aug = 55555 or C6B_Aug = 99999) then C6B_Aug = .;
if (C6B_Sep = 44444 or C6B_Sep = 55555 or C6B_Sep = 99999) then C6B_Sep = .;
if (C6B_Oct = 44444 or C6B_Oct = 55555 or C6B_Oct = 99999) then C6B_Oct = .;
if (C6B_Nov = 44444 or C6B_Nov = 55555 or C6B_Nov = 99999) then C6B_Nov = .;
if (C6B_Dec = 44444 or C6B_Dec = 55555 or C6B_Dec = 99999) then C6B_Dec = .;
if (C6B_Score = 44444 or C6B_Score = 55555 or C6B_Score = 99999) then C6B_Score = .;
if (C6_Jan_Err = 44444 or C6_Jan_Err = 55555 or C6_Jan_Err = 99999) then C6_Jan_Err = .;
if (C6_Feb_Err = 44444 or C6_Feb_Err = 55555 or C6_Feb_Err = 99999) then C6_Feb_Err = .;
if (C6_Mar_Err = 44444 or C6_Mar_Err = 55555 or C6_Mar_Err = 99999) then C6_Mar_Err = .;
if (C6_Apr_Err = 44444 or C6_Apr_Err = 55555 or C6_Apr_Err = 99999) then C6_Apr_Err = .;
if (C6_May_Err = 44444 or C6_May_Err = 55555 or C6_May_Err = 99999) then C6_May_Err = .;
if (C6_Jun_Err = 44444 or C6_Jun_Err = 55555 or C6_Jun_Err = 99999) then C6_Jun_Err = .;
if (C6_Jul_Err = 44444 or C6_Jul_Err = 55555 or C6_Jul_Err = 99999) then C6_Jul_Err = .;
if (C6_Aug_Err = 44444 or C6_Aug_Err = 55555 or C6_Aug_Err = 99999) then C6_Aug_Err = .;
if (C6_Sep_Err = 44444 or C6_Sep_Err = 55555 or C6_Sep_Err = 99999) then C6_Sep_Err = .;
if (C6_Oct_Err = 44444 or C6_Oct_Err = 55555 or C6_Oct_Err = 99999) then C6_Oct_Err = .;
if (C6_Nov_Err = 44444 or C6_Nov_Err = 55555 or C6_Nov_Err = 99999) then C6_Nov_Err = .;
if (C6_Dec_Err = 44444 or C6_Dec_Err = 55555 or C6_Dec_Err = 99999) then C6_Dec_Err = .;
if (C6_Err_Num = 44444 or C6_Err_Num = 55555 or C6_Err_Num = 99999) then C6_Err_Num = .;
if (CscrJanA = 44444 or CscrJanA = 55555 or CscrJanA = 99999) then CscrJanA = .;
if (CscrJanB = 44444 or CscrJanB = 55555 or CscrJanB = 99999) then CscrJanB = .;
if (CscrFebA = 44444 or CscrFebA = 55555 or CscrFebA = 99999) then CscrFebA = .;
if (CscrFebB = 44444 or CscrFebB = 55555 or CscrFebB = 99999) then CscrFebB = .;
if (CscrMarA = 44444 or CscrMarA = 55555 or CscrMarA = 99999) then CscrMarA = .;
if (CscrMarB = 44444 or CscrMarB = 55555 or CscrMarB = 99999) then CscrMarB = .;
if (CscrAprA = 44444 or CscrAprA = 55555 or CscrAprA = 99999) then CscrAprA = .;
if (CscrAprB = 44444 or CscrAprB = 55555 or CscrAprB = 99999) then CscrAprB = .;
if (CscrMayA = 44444 or CscrMayA = 55555 or CscrMayA = 99999) then CscrMayA = .;
if (CscrMayB = 44444 or CscrMayB = 55555 or CscrMayB = 99999) then CscrMayB = .;
if (CscrJunA = 44444 or CscrJunA = 55555 or CscrJunA = 99999) then CscrJunA = .;
if (CscrJunB = 44444 or CscrJunB = 55555 or CscrJunB = 99999) then CscrJunB = .;
if (CscrJulA = 44444 or CscrJulA = 55555 or CscrJulA = 99999) then CscrJulA = .;
if (CscrJulB = 44444 or CscrJulB = 55555 or CscrJulB = 99999) then CscrJulB = .;
if (CscrAugA = 44444 or CscrAugA = 55555 or CscrAugA = 99999) then CscrAugA = .;
if (CscrAugB = 44444 or CscrAugB = 55555 or CscrAugB = 99999) then CscrAugB = .;
if (CscrSepA = 44444 or CscrSepA = 55555 or CscrSepA = 99999) then CscrSepA = .;
if (CscrSepB = 44444 or CscrSepB = 55555 or CscrSepB = 99999) then CscrSepB = .;
if (CscrOctA = 44444 or CscrOctA = 55555 or CscrOctA = 99999) then CscrOctA = .;
if (CscrOctB = 44444 or CscrOctB = 55555 or CscrOctB = 99999) then CscrOctB = .;
if (CscrNovA = 44444 or CscrNovA = 55555 or CscrNovA = 99999) then CscrNovA = .;
if (CscrNovB = 44444 or CscrNovB = 55555 or CscrNovB = 99999) then CscrNovB = .;
if (CscrDecA = 44444 or CscrDecA = 55555 or CscrDecA = 99999) then CscrDecA = .;
if (CscrDecB = 44444 or CscrDecB = 55555 or CscrDecB = 99999) then CscrDecB = .;
if (CscrNonA = 44444 or CscrNonA = 55555 or CscrNonA = 99999) then CscrNonA = .;
if (CscrNonB = 44444 or CscrNonB = 55555 or CscrNonB = 99999) then CscrNonB = .;
if (D1 = 44444 or D1 = 55555 or D1 = 99999) then D1 = .;
if (D2 = 44444 or D2 = 55555 or D2 = 99999) then D2 = .;
if (D3 = 44444 or D3 = 55555 or D3 = 99999) then D3 = .;
if (D4 = 44444 or D4 = 55555 or D4 = 99999) then D4 = .;
if (D5 = 44444 or D5 = 55555 or D5 = 99999) then D5 = .;
if (D6 = 44444 or D6 = 55555 or D6 = 99999) then D6 = .;
if (D7 = 44444 or D7 = 55555 or D7 = 99999) then D7 = .;
if (D8 = 44444 or D8 = 55555 or D8 = 99999) then D8 = .;
if (D9 = 44444 or D9 = 55555 or D9 = 99999) then D9 = .;
if (Dscore = 44444 or Dscore = 55555 or Dscore = 99999) then Dscore = .;
if (MDcrit1 = 44444 or MDcrit1 = 55555 or MDcrit1 = 99999) then MDcrit1 = .;
if (MDcrit2 = 44444 or MDcrit2 = 55555 or MDcrit2 = 99999) then MDcrit2 = .;
if (MDcrit3 = 44444 or MDcrit3 = 55555 or MDcrit3 = 99999) then MDcrit3 = .;
if (MDcrit4 = 44444 or MDcrit4 = 55555 or MDcrit4 = 99999) then MDcrit4 = .;
if (MDcrit5 = 44444 or MDcrit5 = 55555 or MDcrit5 = 99999) then MDcrit5 = .;
if (MDcrit6 = 44444 or MDcrit6 = 55555 or MDcrit6 = 99999) then MDcrit6 = .;
if (q1 = 44444 or q1 = 55555 or q1 = 99999) then q1 = .;
if (q2 = 44444 or q2 = 55555 or q2 = 99999) then q2 = .;
if (d_abnl_sleep = 44444 or d_abnl_sleep = 55555 or d_abnl_sleep = 99999) then d_abnl_sleep = .;
if (d_abnl_sleep_cont = 44444 or d_abnl_sleep_cont = 55555 or d_abnl_sleep_cont = 99999) then d_abnl_sleep_cont = .;
if (_ask2 = 44444 or _ask2 = 55555 or _ask2 = 99999) then _ask2 = .;
if (q3 = 44444 or q3 = 55555 or q3 = 99999) then q3 = .;
if (q4 = 44444 or q4 = 55555 or q4 = 99999) then q4 = .;
if (q5 = 44444 or q5 = 55555 or q5 = 99999) then q5 = .;
if (q6 = 44444 or q6 = 55555 or q6 = 99999) then q6 = .;
if (q7 = 44444 or q7 = 55555 or q7 = 99999) then q7 = .;
if (q8 = 44444 or q8 = 55555 or q8 = 99999) then q8 = .;
if (q9 = 44444 or q9 = 55555 or q9 = 99999) then q9 = .;
if (q10 = 44444 or q10 = 55555 or q10 = 99999) then q10 = .;
if (q11 = 44444 or q11 = 55555 or q11 = 99999) then q11 = .;
if (q12 = 44444 or q12 = 55555 or q12 = 99999) then q12 = .;
if (q13 = 44444 or q13 = 55555 or q13 = 99999) then q13 = .;
if (q14 = 44444 or q14 = 55555 or q14 = 99999) then q14 = .;
if (q15 = 44444 or q15 = 55555 or q15 = 99999) then q15 = .;
if (q16 = 44444 or q16 = 55555 or q16 = 99999) then q16 = .;
if (q17 = 44444 or q17 = 55555 or q17 = 99999) then q17 = .;
if (q18 = 44444 or q18 = 55555 or q18 = 99999) then q18 = .;
if (q19 = 44444 or q19 = 55555 or q19 = 99999) then q19 = .;
if (MEQ = 44444 or MEQ = 55555 or MEQ = 99999) then MEQ = .;
if (MEQstd = 44444 or MEQstd = 55555 or MEQstd = 99999) then MEQstd = .;
if (DLMO = 44444 or DLMO = 55555 or DLMO = 99999) then DLMO = .;
if (DLMO_h = 44444 or DLMO_h = 55555 or DLMO_h = 99999) then DLMO_h = .;
if (DLMO_m = 44444 or DLMO_m = 55555 or DLMO_m = 99999) then DLMO_m = .;
if (DLMO_time0 = 44444 or DLMO_time0 = 55555 or DLMO_time0 = 99999) then DLMO_time0 = .;
if (DLMO_time = 44444 or DLMO_time = 55555 or DLMO_time = 99999) then DLMO_time = .;
if (SL_ONSET = 44444 or SL_ONSET = 55555 or SL_ONSET = 99999) then SL_ONSET = .;
if (SL_ONSET_h = 44444 or SL_ONSET_h = 55555 or SL_ONSET_h = 99999) then SL_ONSET_h = .;
if (SL_ONSET_m = 44444 or SL_ONSET_m = 55555 or SL_ONSET_m = 99999) then SL_ONSET_m = .;
if (SL_ONSET_time0 = 44444 or SL_ONSET_time0 = 55555 or SL_ONSET_time0 = 99999) then SL_ONSET_time0 = .;
if (LIGHTS_ON = 44444 or LIGHTS_ON = 55555 or LIGHTS_ON = 99999) then LIGHTS_ON = .;
if (LIGHTS_ON_h = 44444 or LIGHTS_ON_h = 55555 or LIGHTS_ON_h = 99999) then LIGHTS_ON_h = .;
if (LIGHTS_ON_m = 44444 or LIGHTS_ON_m = 55555 or LIGHTS_ON_m = 99999) then LIGHTS_ON_m = .;
if (LIGHTS_ON_time0 = 44444 or LIGHTS_ON_time0 = 55555 or LIGHTS_ON_time0 = 99999) then LIGHTS_ON_time0 = .;
if (Feedback0 = 44444 or Feedback0 = 55555 or Feedback0 = 99999) then Feedback0 = .;

if (UniqueID = "44444" or UniqueID = "55555" or UniqueID = "99999") then UniqueID = ' ';
if (Title = "44444" or Title = "55555" or Title = "99999") then Title = ' ';
if (Version = "44444" or Version = "55555" or Version = "99999") then Version = ' ';
if (d_country = "44444" or d_country = "55555" or d_country = "99999") then d_country = ' ';
if (_state_name = "44444" or _state_name = "55555" or _state_name = "99999") then _state_name = ' ';
if (d_sleep_workday = "44444" or d_sleep_workday = "55555" or d_sleep_workday = "99999") then d_sleep_workday = ' ';
if (d_sleep_nonworkday = "44444" or d_sleep_nonworkday = "55555" or d_sleep_nonworkday = "99999") then d_sleep_nonworkday = ' ';
if (d_awake_workday = "44444" or d_awake_workday = "55555" or d_awake_workday = "99999") then d_awake_workday = ' ';
if (d_awake_nonworkday = "44444" or d_awake_nonworkday = "55555" or d_awake_nonworkday = "99999") then d_awake_nonworkday = ' ';
if (CompletionDate = "44444" or CompletionDate = "55555" or CompletionDate = "99999") then CompletionDate = ' ';
if (C1A_Err = "44444" or C1A_Err = "55555" or C1A_Err = "99999") then C1A_Err = ' ';
if (C1A_Err2 = "44444" or C1A_Err2 = "55555" or C1A_Err2 = "99999") then C1A_Err2 = ' ';
if (C1B_Err = "44444" or C1B_Err = "55555" or C1B_Err = "99999") then C1B_Err = ' ';
if (C1B_Err2 = "44444" or C1B_Err2 = "55555" or C1B_Err2 = "99999") then C1B_Err2 = ' ';
if (C1_Err_List = "44444" or C1_Err_List = "55555" or C1_Err_List = "99999") then C1_Err_List = ' ';
if (C1_Err = "44444" or C1_Err = "55555" or C1_Err = "99999") then C1_Err = ' ';
if (C2A_Err = "44444" or C2A_Err = "55555" or C2A_Err = "99999") then C2A_Err = ' ';
if (C2A_Err2 = "44444" or C2A_Err2 = "55555" or C2A_Err2 = "99999") then C2A_Err2 = ' ';
if (C2B_Err = "44444" or C2B_Err = "55555" or C2B_Err = "99999") then C2B_Err = ' ';
if (C2B_Err2 = "44444" or C2B_Err2 = "55555" or C2B_Err2 = "99999") then C2B_Err2 = ' ';
if (C2_Err_List = "44444" or C2_Err_List = "55555" or C2_Err_List = "99999") then C2_Err_List = ' ';
if (C2_Err = "44444" or C2_Err = "55555" or C2_Err = "99999") then C2_Err = ' ';
if (C3A_Err = "44444" or C3A_Err = "55555" or C3A_Err = "99999") then C3A_Err = ' ';
if (C3A_Err2 = "44444" or C3A_Err2 = "55555" or C3A_Err2 = "99999") then C3A_Err2 = ' ';
if (C3B_Err = "44444" or C3B_Err = "55555" or C3B_Err = "99999") then C3B_Err = ' ';
if (C3B_Err2 = "44444" or C3B_Err2 = "55555" or C3B_Err2 = "99999") then C3B_Err2 = ' ';
if (C3_Err_List = "44444" or C3_Err_List = "55555" or C3_Err_List = "99999") then C3_Err_List = ' ';
if (C3_Err = "44444" or C3_Err = "55555" or C3_Err = "99999") then C3_Err = ' ';
if (C4A_Err = "44444" or C4A_Err = "55555" or C4A_Err = "99999") then C4A_Err = ' ';
if (C4A_Err2 = "44444" or C4A_Err2 = "55555" or C4A_Err2 = "99999") then C4A_Err2 = ' ';
if (C4B_Err = "44444" or C4B_Err = "55555" or C4B_Err = "99999") then C4B_Err = ' ';
if (C4B_Err2 = "44444" or C4B_Err2 = "55555" or C4B_Err2 = "99999") then C4B_Err2 = ' ';
if (C4_Err_List = "44444" or C4_Err_List = "55555" or C4_Err_List = "99999") then C4_Err_List = ' ';
if (C4_Err = "44444" or C4_Err = "55555" or C4_Err = "99999") then C4_Err = ' ';
if (C5A_Err = "44444" or C5A_Err = "55555" or C5A_Err = "99999") then C5A_Err = ' ';
if (C5A_Err2 = "44444" or C5A_Err2 = "55555" or C5A_Err2 = "99999") then C5A_Err2 = ' ';
if (C5B_Err = "44444" or C5B_Err = "55555" or C5B_Err = "99999") then C5B_Err = ' ';
if (C5B_Err2 = "44444" or C5B_Err2 = "55555" or C5B_Err2 = "99999") then C5B_Err2 = ' ';
if (C5_Err_List = "44444" or C5_Err_List = "55555" or C5_Err_List = "99999") then C5_Err_List = ' ';
if (C5_Err = "44444" or C5_Err = "55555" or C5_Err = "99999") then C5_Err = ' ';
if (C6A_Err = "44444" or C6A_Err = "55555" or C6A_Err = "99999") then C6A_Err = ' ';
if (C6A_Err2 = "44444" or C6A_Err2 = "55555" or C6A_Err2 = "99999") then C6A_Err2 = ' ';
if (C6B_Err = "44444" or C6B_Err = "55555" or C6B_Err = "99999") then C6B_Err = ' ';
if (C6_Err_List = "44444" or C6_Err_List = "55555" or C6_Err_List = "99999") then C6_Err_List = ' ';
if (C6_Err = "44444" or C6_Err = "55555" or C6_Err = "99999") then C6_Err = ' ';
if (C6B_Err2 = "44444" or C6B_Err2 = "55555" or C6B_Err2 = "99999") then C6B_Err2 = ' ';
if (SL_ONSET_time = "44444" or SL_ONSET_time = "55555" or SL_ONSET_time = "99999") then SL_ONSET_time = ' ';
if (LIGHTS_ON_time = "44444" or LIGHTS_ON_time = "55555" or LIGHTS_ON_time = "99999") then LIGHTS_ON_time = ' ';
if (MEQ_type = "44444" or MEQ_type = "55555" or MEQ_type = "99999") then MEQ_type = ' ';
if (Feedback_us = "44444" or Feedback_us = "55555" or Feedback_us = "99999") then Feedback_us = ' ';
	
run;
