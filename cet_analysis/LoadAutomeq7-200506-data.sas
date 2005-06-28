data automeq7;
	%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
	infile '/data/cet_200506/analysis/AutoMEQ-SA-irb_v7.0_n497_a4e831b09889e5dcdac77bf475e413d9_MAIN-summary.tsv'
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
run;