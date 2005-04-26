
/**********************************************/
/* SAS Module __MAIN__-summary */
/**********************************************/

data WORK.AutoMEQ4;
	%let _EFIERR_ = 0; /* set the ERROR detection macro variable */
	infile '\data\cet7\analysis\AutoMEQ-SA-v4.0-(AutoMEQ-SA-irb)\__MAIN__-summary.tsv'
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
	informat DLMO_time time8.0;  format DLMO_time time8.0;
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

proc format;
	value DF0001f
		1 = "[1]For yourself"
		2 = "[2]For someone else"
		3 = "[3]Just testing the system"
		4 = "[4]I cannot or do not want to answer this question."
		. = ' '
		OTHER = '?'
	;
	value DF0002f
		0 = "[0]No, I want to use the questionnaire only for my personal use"
		1 = "[1]Yes, I agree to join the study"
		. = ' '
		OTHER = '?'
	;
	value DF0003f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]male"
		1 = "[1]female"
		. = ' '
		OTHER = '?'
	;
	value DF0004f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]blue"
		1 = "[1]gray"
		2 = "[2]green"
		3 = "[3]hazel"
		4 = "[4]brown"
		5 = "[5]black"
		6 = "[6]albino"
		. = ' '
		OTHER = '?'
	;
	value $DF0005f
		"Afghanistan" = "['Afghanistan']Afghanistan"
		"Albania" = "['Albania']Albania"
		"Algeria" = "['Algeria']Algeria"
		"Andorra" = "['Andorra']Andorra"
		"Angola" = "['Angola']Angola"
		"Antigua and Barbuda" = "['Antigua and Barbuda']Antigua and Barbuda"
		"Argentina" = "['Argentina']Argentina"
		"Armenia" = "['Armenia']Armenia"
		"Australia" = "['Australia']Australia"
		"Austria" = "['Austria']Austria"
		"Azerbaijan" = "['Azerbaijan']Azerbaijan"
		"Bahamas" = "['Bahamas']Bahamas"
		"Bahrain" = "['Bahrain']Bahrain"
		"Bangladesh" = "['Bangladesh']Bangladesh"
		"Barbados" = "['Barbados']Barbados"
		"Belarus" = "['Belarus']Belarus"
		"Belgium" = "['Belgium']Belgium"
		"Belize" = "['Belize']Belize"
		"Benin" = "['Benin']Benin"
		"Bermuda" = "['Bermuda']Bermuda"
		"Bjibouti" = "['Bjibouti']Bjibouti"
		"Bolivia" = "['Bolivia']Bolivia"
		"Bosnia Herzegovian" = "['Bosnia Herzegovian']Bosnia Herzegovian"
		"Botswana" = "['Botswana']Botswana"
		"Brazil" = "['Brazil']Brazil"
		"Brunei" = "['Brunei']Brunei"
		"Bulgaria" = "['Bulgaria']Bulgaria"
		"Burkina Faso" = "['Burkina Faso']Burkina Faso"
		"Burma" = "['Burma']Burma"
		"Burundi" = "['Burundi']Burundi"
		"Cambodia" = "['Cambodia']Cambodia"
		"Cameroon" = "['Cameroon']Cameroon"
		"Canada" = "['Canada']Canada"
		"Cape Verde" = "['Cape Verde']Cape Verde"
		"Central African Republic" = "['Central African Republic']Central African Republic"
		"Chad" = "['Chad']Chad"
		"Chile" = "['Chile']Chile"
		"China" = "['China']China"
		"Colombia" = "['Colombia']Colombia"
		"Comoros" = "['Comoros']Comoros"
		"Congo" = "['Congo']Congo"
		"Costa Rica" = "['Costa Rica']Costa Rica"
		"Cote d_Ivoire" = "['Cote d_Ivoire']Cote d'Ivoire"
		"Croatia" = "['Croatia']Croatia"
		"Cuba" = "['Cuba']Cuba"
		"Cyprus" = "['Cyprus']Cyprus"
		"Czech" = "['Czech']Czech"
		"Democratic Republic of Congo" = "['Democratic Republic of Congo']Democratic Republic of Congo"
		"Denmark" = "['Denmark']Denmark"
		"Dominica" = "['Dominica']Dominica"
		"Dominican Republic" = "['Dominican Republic']Dominican Republic"
		"Ecuador" = "['Ecuador']Ecuador"
		"Egypt" = "['Egypt']Egypt"
		"El Salvador" = "['El Salvador']El Salvador"
		"Equatorial uinea" = "['Equatorial uinea']Equatorial Guinea"
		"Eritrea" = "['Eritrea']Eritrea"
		"Estonia" = "['Estonia']Estonia"
		"Ethiopia" = "['Ethiopia']Ethiopia"
		"European Union" = "['European Union']European Union"
		"Faroe Islands" = "['Faroe Islands']Faroe Islands"
		"Fiji" = "['Fiji']Fiji"
		"Finland" = "['Finland']Finland"
		"France" = "['France']France"
		"Gabon" = "['Gabon']Gabon"
		"Gambia" = "['Gambia']Gambia"
		"Georgia" = "['Georgia']Georgia"
		"Germany" = "['Germany']Germany"
		"Ghana" = "['Ghana']Ghana"
		"Great Britain" = "['Great Britain']Great Britain"
		"Greece" = "['Greece']Greece"
		"Greenland" = "['Greenland']Greenland"
		"Grenada" = "['Grenada']Grenada"
		"Guatemala" = "['Guatemala']Guatemala"
		"Guinea Bissau" = "['Guinea Bissau']Guinea Bissau"
		"Guinea" = "['Guinea']Guinea"
		"Guyana" = "['Guyana']Guyana"
		"Haiti" = "['Haiti']Haiti"
		"Holy See" = "['Holy See']Holy See"
		"Honduras" = "['Honduras']Honduras"
		"Hong Kong" = "['Hong Kong']Hong Kong"
		"Hungary" = "['Hungary']Hungary"
		"Iceland" = "['Iceland']Iceland"
		"India" = "['India']India"
		"Indonesia" = "['Indonesia']Indonesia"
		"Iran" = "['Iran']Iran"
		"Iraq" = "['Iraq']Iraq"
		"Ireland" = "['Ireland']Ireland"
		"Isle of Man" = "['Isle of Man']Isle of Man"
		"Israel" = "['Israel']Israel"
		"Italy" = "['Italy']Italy"
		"Jamaica" = "['Jamaica']Jamaica"
		"Jan Mayen" = "['Jan Mayen']Jan Mayen"
		"Japan" = "['Japan']Japan"
		"Jarvis Island" = "['Jarvis Island']Jarvis Island"
		"Jersey" = "['Jersey']Jersey"
		"Johnston Atoll" = "['Johnston Atoll']Johnston Atoll"
		"Jordan" = "['Jordan']Jordan"
		"Juan de Nova Island" = "['Juan de Nova Island']Juan de Nova Island"
		"Kazakstan" = "['Kazakstan']Kazakstan"
		"Kenya" = "['Kenya']Kenya"
		"Kiribati" = "['Kiribati']Kiribati"
		"Kuwait" = "['Kuwait']Kuwait"
		"Kyrgyztan" = "['Kyrgyztan']Kyrgyztan"
		"Laos" = "['Laos']Laos"
		"Latvia" = "['Latvia']Latvia"
		"Lebanon" = "['Lebanon']Lebanon"
		"Lesotho" = "['Lesotho']Lesotho"
		"Libria" = "['Libria']Liberia"
		"Libya" = "['Libya']Libya"
		"Liechtenstein" = "['Liechtenstein']Liechtenstein"
		"Lithuania" = "['Lithuania']Lithuania"
		"Luxembourg" = "['Luxembourg']Luxembourg"
		"Macau" = "['Macau']Macau"
		"Macedonia" = "['Macedonia']Macedonia"
		"Madagascar" = "['Madagascar']Madagascar"
		"Malaw" = "['Malaw']Malawi"
		"Malaysia" = "['Malaysia']Malaysia"
		"Mali" = "['Mali']Mali"
		"Marshall Islands" = "['Marshall Islands']Marshall Islands"
		"Martinique" = "['Martinique']Martinique"
		"Mauritania" = "['Mauritania']Mauritania"
		"Mauritius" = "['Mauritius']Mauritius"
		"Mayotte" = "['Mayotte']Mayotte"
		"Mexico" = "['Mexico']Mexico"
		"Micronesia" = "['Micronesia']Micronesia"
		"Midway Islands" = "['Midway Islands']Midway Islands"
		"Moldova" = "['Moldova']Moldova"
		"Monaco" = "['Monaco']Monaco"
		"Mongolia" = "['Mongolia']Mongolia"
		"Montserrat" = "['Montserrat']Montserrat"
		"Morocco" = "['Morocco']Morocco"
		"Mozambique" = "['Mozambique']Mozambique"
		"Myanmar" = "['Myanmar']Myanmar"
		"N/A" = "['N/A']I cannot or do not want to answer this question."
		"Namibia" = "['Namibia']Namibia"
		"Nauru" = "['Nauru']Nauru"
		"Navassa sland" = "['Navassa sland']Navassa sland"
		"Nepal" = "['Nepal']Nepal"
		"Netherlands Antilles" = "['Netherlands Antilles']Netherlands Antilles"
		"Netherlands" = "['Netherlands']Netherlands"
		"New Caledonia" = "['New Caledonia']New Caledonia"
		"New Zealand" = "['New Zealand']New Zealand"
		"Nicaragua" = "['Nicaragua']Nicaragua"
		"Niger" = "['Niger']Niger"
		"Nigeria" = "['Nigeria']Nigeria"
		"Niue" = "['Niue']Niue"
		"Norfolk Island" = "['Norfolk Island']Norfolk Island"
		"North Korea" = "['North Korea']North Korea"
		"Northern Mariana Islands" = "['Northern Mariana Islands']Northern Mariana Islands"
		"Norway" = "['Norway']Norway"
		"Oman" = "['Oman']Oman"
		"Pakistan" = "['Pakistan']Pakistan"
		"Palau" = "['Palau']Palau"
		"Palestine" = "['Palestine']Palestine"
		"Panama" = "['Panama']Panama"
		"Papua New Guinea" = "['Papua New Guinea']Papua New Guinea"
		"Paraguay" = "['Paraguay']Paraguay"
		"Peru" = "['Peru']Peru"
		"Philippines" = "['Philippines']Philippines"
		"Pitcairn Islands" = "['Pitcairn Islands']Pitcairn Islands"
		"Poland" = "['Poland']Poland"
		"Portugal" = "['Portugal']Portugal"
		"Puerto Rico" = "['Puerto Rico']Puerto Rico"
		"Qatar" = "['Qatar']Qatar"
		"Reunion" = "['Reunion']Reunion"
		"Romania" = "['Romania']Romania"
		"Royal Bhutan" = "['Royal Bhutan']Royal Bhutan"
		"Russia" = "['Russia']Russia"
		"Rwanda" = "['Rwanda']Rwanda"
		"Saint Kitts and Nevis" = "['Saint Kitts and Nevis']Saint Kitts and Nevis"
		"Saint Lucia" = "['Saint Lucia']Saint Lucia"
		"Saint Pierre and Miquelon" = "['Saint Pierre and Miquelon']Saint Pierre and Miquelon"
		"Saint Vincent and the Grenadines" = "['Saint Vincent and the Grenadines']Saint Vincent and the Grenadines"
		"Samoa American" = "['Samoa American']Samoa American"
		"Samoa" = "['Samoa']Samoa"
		"San Marino" = "['San Marino']San Marino"
		"Sao Tome and Principe" = "['Sao Tome and Principe']Sao Tome and Principe"
		"Saudi Arabia" = "['Saudi Arabia']Saudi Arabia"
		"Senegal" = "['Senegal']Senegal"
		"Serbia and Montenegro" = "['Serbia and Montenegro']Serbia and Montenegro"
		"Seychelles" = "['Seychelles']Seychelles"
		"Sierra Leone" = "['Sierra Leone']Sierra Leone"
		"Singapore" = "['Singapore']Singapore"
		"Slovakia" = "['Slovakia']Slovakia"
		"Slovenia" = "['Slovenia']Slovenia"
		"Solomon Islands" = "['Solomon Islands']Solomon Islands"
		"Somalia" = "['Somalia']Somalia"
		"South Korea" = "['South Korea']South Korea"
		"South frica" = "['South frica']South frica"
		"Spain" = "['Spain']Spain"
		"Sri Lanka" = "['Sri Lanka']Sri Lanka"
		"Sudan" = "['Sudan']Sudan"
		"Suriname" = "['Suriname']Suriname"
		"Swaziland" = "['Swaziland']Swaziland"
		"Sweden" = "['Sweden']Sweden"
		"Switzerland" = "['Switzerland']Switzerland"
		"Syria" = "['Syria']Syria"
		"Taiwan" = "['Taiwan']Taiwan"
		"Tajikistan" = "['Tajikistan']Tajikistan"
		"Tanzania" = "['Tanzania']Tanzania"
		"Thailand" = "['Thailand']Thailand"
		"Togo" = "['Togo']Togo"
		"Tonga" = "['Tonga']Tonga"
		"Trinidad and Tobago" = "['Trinidad and Tobago']Trinidad and Tobago"
		"Tunisia" = "['Tunisia']Tunisia"
		"Turkey" = "['Turkey']Turkey"
		"Turkmenistan" = "['Turkmenistan']Turkmenistan"
		"Tuvalu" = "['Tuvalu']Tuvalu"
		"Uganda" = "['Uganda']Uganda"
		"Ukraine" = "['Ukraine']Ukraine"
		"United Arab Emirates" = "['United Arab Emirates']United Arab Emirates"
		"United States" = "['United States']United States"
		"Uruguay" = "['Uruguay']Uruguay"
		"Uzbekistan" = "['Uzbekistan']Uzbekistan"
		"Vanuatu" = "['Vanuatu']Vanuatu"
		"Vatican" = "['Vatican']Vatican"
		"Venezuela" = "['Venezuela']Venezuela"
		"Vietnam" = "['Vietnam']Vietnam"
		"Western Samoa" = "['Western Samoa']Western Samoa"
		"Yemen" = "['Yemen']Yemen"
		"Yugoslavia" = "['Yugoslavia']Yugoslavia"
		"Zaire" = "['Zaire']Zaire"
		"Zambia" = "['Zambia']Zambia"
		"Zimbawe" = "['Zimbawe']Zimbawe"
		. = ' '
		OTHER = '?'
	;
	value DF0006f
		-1 = "[-1]I cannot or do not want to answer this question."
		1 = "[1]Alabama"
		10 = "[10]Florida"
		11 = "[11]Georgia"
		12 = "[12]Hawaii"
		13 = "[13]Idaho"
		14 = "[14]Illinois"
		15 = "[15]Indiana"
		16 = "[16]Iowa"
		17 = "[17]Kansas"
		18 = "[18]Kentucky"
		19 = "[19]Louisiana"
		2 = "[2]Alaska"
		20 = "[20]Maine"
		21 = "[21]Maryland"
		22 = "[22]Massachusetts"
		23 = "[23]Michigan"
		24 = "[24]Minnesota"
		25 = "[25]Mississippi"
		26 = "[26]Missouri"
		27 = "[27]Montana"
		28 = "[28]Nebraska"
		29 = "[29]Nevada"
		3 = "[3]Arizona"
		30 = "[30]New Hampshire"
		31 = "[31]New Jersey"
		32 = "[32]New Mexico"
		33 = "[33]New York"
		34 = "[34]North Carolina"
		35 = "[35]North Dakota"
		36 = "[36]Ohio"
		37 = "[37]Oklahoma"
		38 = "[38]Oregon"
		39 = "[39]Pennsylvania"
		4 = "[4]Arkansas"
		40 = "[40]Rhode Island"
		41 = "[41]South Carolina"
		42 = "[42]South Dakota"
		43 = "[43]Tennessee"
		44 = "[44]Texas"
		45 = "[45]Utah"
		46 = "[46]Vermont"
		47 = "[47]Virginia"
		48 = "[48]Washington"
		49 = "[49]West Virginia"
		5 = "[5]California"
		50 = "[50]Wisconsin"
		51 = "[51]Wyoming"
		6 = "[6]Colorado"
		7 = "[7]Connecticut"
		8 = "[8]Delaware"
		9 = "[9]District of Columbia"
		. = ' '
		OTHER = '?'
	;
	value DF0007f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0008f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0009f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0010f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0011f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0012f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0013f
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0014f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]0"
		1 = "[1]1"
		2 = "[2]2"
		3 = "[3]3"
		4 = "[4]4"
		5 = "[5]5"
		6 = "[6]6"
		7 = "[7]7"
		. = ' '
		OTHER = '?'
	;
	value $DF0015f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value $DF0016f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value $DF0017f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value $DF0018f
		" 1:00 AM" = "[' 1:00 AM'] 1:00 AM"
		" 1:00 PM" = "[' 1:00 PM'] 1:00 PM"
		" 1:15 AM" = "[' 1:15 AM'] 1:15 AM"
		" 1:15 PM" = "[' 1:15 PM'] 1:15 PM"
		" 1:30 AM" = "[' 1:30 AM'] 1:30 AM"
		" 1:30 PM" = "[' 1:30 PM'] 1:30 PM"
		" 1:45 AM" = "[' 1:45 AM'] 1:45 AM"
		" 1:45 PM" = "[' 1:45 PM'] 1:45 PM"
		" 2:00 AM" = "[' 2:00 AM'] 2:00 AM"
		" 2:00 PM" = "[' 2:00 PM'] 2:00 PM"
		" 2:15 AM" = "[' 2:15 AM'] 2:15 AM"
		" 2:15 PM" = "[' 2:15 PM'] 2:15 PM"
		" 2:30 AM" = "[' 2:30 AM'] 2:30 AM"
		" 2:30 PM" = "[' 2:30 PM'] 2:30 PM"
		" 2:45 AM" = "[' 2:45 AM'] 2:45 AM"
		" 2:45 PM" = "[' 2:45 PM'] 2:45 PM"
		" 3:00 AM" = "[' 3:00 AM'] 3:00 AM"
		" 3:00 PM" = "[' 3:00 PM'] 3:00 PM"
		" 3:15 AM" = "[' 3:15 AM'] 3:15 AM"
		" 3:15 PM" = "[' 3:15 PM'] 3:15 PM"
		" 3:30 AM" = "[' 3:30 AM'] 3:30 AM"
		" 3:30 PM" = "[' 3:30 PM'] 3:30 PM"
		" 3:45 AM" = "[' 3:45 AM'] 3:45 AM"
		" 3:45 PM" = "[' 3:45 PM'] 3:45 PM"
		" 4:00 AM" = "[' 4:00 AM'] 4:00 AM"
		" 4:00 PM" = "[' 4:00 PM'] 4:00 PM"
		" 4:15 AM" = "[' 4:15 AM'] 4:15 AM"
		" 4:15 PM" = "[' 4:15 PM'] 4:15 PM"
		" 4:30 AM" = "[' 4:30 AM'] 4:30 AM"
		" 4:30 PM" = "[' 4:30 PM'] 4:30 PM"
		" 4:45 AM" = "[' 4:45 AM'] 4:45 AM"
		" 4:45 PM" = "[' 4:45 PM'] 4:45 PM"
		" 5:00 AM" = "[' 5:00 AM'] 5:00 AM"
		" 5:00 PM" = "[' 5:00 PM'] 5:00 PM"
		" 5:15 AM" = "[' 5:15 AM'] 5:15 AM"
		" 5:15 PM" = "[' 5:15 PM'] 5:15 PM"
		" 5:30 AM" = "[' 5:30 AM'] 5:30 AM"
		" 5:30 PM" = "[' 5:30 PM'] 5:30 PM"
		" 5:45 AM" = "[' 5:45 AM'] 5:45 AM"
		" 5:45 PM" = "[' 5:45 PM'] 5:45 PM"
		" 6:00 AM" = "[' 6:00 AM'] 6:00 AM"
		" 6:00 PM" = "[' 6:00 PM'] 6:00 PM"
		" 6:15 AM" = "[' 6:15 AM'] 6:15 AM"
		" 6:15 PM" = "[' 6:15 PM'] 6:15 PM"
		" 6:30 AM" = "[' 6:30 AM'] 6:30 AM"
		" 6:30 PM" = "[' 6:30 PM'] 6:30 PM"
		" 6:45 AM" = "[' 6:45 AM'] 6:45 AM"
		" 6:45 PM" = "[' 6:45 PM'] 6:45 PM"
		" 7:00 AM" = "[' 7:00 AM'] 7:00 AM"
		" 7:00 PM" = "[' 7:00 PM'] 7:00 PM"
		" 7:15 AM" = "[' 7:15 AM'] 7:15 AM"
		" 7:15 PM" = "[' 7:15 PM'] 7:15 PM"
		" 7:30 AM" = "[' 7:30 AM'] 7:30 AM"
		" 7:30 PM" = "[' 7:30 PM'] 7:30 PM"
		" 7:45 AM" = "[' 7:45 AM'] 7:45 AM"
		" 7:45 PM" = "[' 7:45 PM'] 7:45 PM"
		" 8:00 AM" = "[' 8:00 AM'] 8:00 AM"
		" 8:00 PM" = "[' 8:00 PM'] 8:00 PM"
		" 8:15 AM" = "[' 8:15 AM'] 8:15 AM"
		" 8:15 PM" = "[' 8:15 PM'] 8:15 PM"
		" 8:30 AM" = "[' 8:30 AM'] 8:30 AM"
		" 8:30 PM" = "[' 8:30 PM'] 8:30 PM"
		" 8:45 AM" = "[' 8:45 AM'] 8:45 AM"
		" 8:45 PM" = "[' 8:45 PM'] 8:45 PM"
		" 9:00 AM" = "[' 9:00 AM'] 9:00 AM"
		" 9:00 PM" = "[' 9:00 PM'] 9:00 PM"
		" 9:15 AM" = "[' 9:15 AM'] 9:15 AM"
		" 9:15 PM" = "[' 9:15 PM'] 9:15 PM"
		" 9:30 AM" = "[' 9:30 AM'] 9:30 AM"
		" 9:30 PM" = "[' 9:30 PM'] 9:30 PM"
		" 9:45 AM" = "[' 9:45 AM'] 9:45 AM"
		" 9:45 PM" = "[' 9:45 PM'] 9:45 PM"
		"10:00 AM" = "['10:00 AM']10:00 AM"
		"10:00 PM" = "['10:00 PM']10:00 PM"
		"10:15 AM" = "['10:15 AM']10:15 AM"
		"10:15 PM" = "['10:15 PM']10:15 PM"
		"10:30 AM" = "['10:30 AM']10:30 AM"
		"10:30 PM" = "['10:30 PM']10:30 PM"
		"10:45 AM" = "['10:45 AM']10:45 AM"
		"10:45 PM" = "['10:45 PM']10:45 PM"
		"11:00 AM" = "['11:00 AM']11:00 AM"
		"11:00 PM" = "['11:00 PM']11:00 PM"
		"11:15 AM" = "['11:15 AM']11:15 AM"
		"11:15 PM" = "['11:15 PM']11:15 PM"
		"11:30 AM" = "['11:30 AM']11:30 AM"
		"11:30 PM" = "['11:30 PM']11:30 PM"
		"11:45 AM" = "['11:45 AM']11:45 AM"
		"11:45 PM" = "['11:45 PM']11:45 PM"
		"12:00 AM" = "['12:00 AM']12:00 AM (midnight)"
		"12:00 PM" = "['12:00 PM']12:00 PM (noon)"
		"12:15 AM" = "['12:15 AM']12:15 AM"
		"12:15 PM" = "['12:15 PM']12:15 PM"
		"12:30 AM" = "['12:30 AM']12:30 AM"
		"12:30 PM" = "['12:30 PM']12:30 PM"
		"12:45 AM" = "['12:45 AM']12:45 AM"
		"12:45 PM" = "['12:45 PM']12:45 PM"
		"N/A" = "['N/A']I do not want to answer this question."
		"variable" = "['variable']My sleep pattern is too irregular to answer this question."
		. = ' '
		OTHER = '?'
	;
	value DF0019f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0020f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0021f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]0:00"
		105 = "[105]1:45"
		120 = "[120]2:00"
		135 = "[135]2:15"
		15 = "[15]0:15"
		150 = "[150]2:30"
		165 = "[165]2:45"
		180 = "[180]3:00"
		195 = "[195]3:15"
		210 = "[210]3:30"
		225 = "[225]3:45"
		240 = "[240]4:00"
		255 = "[255]4:15"
		270 = "[270]4:30"
		285 = "[285]4:45"
		30 = "[30]0:30"
		300 = "[300]5:00"
		315 = "[315]5:15"
		330 = "[330]5:30"
		345 = "[345]5:45"
		360 = "[360]6:00"
		375 = "[375]6:15"
		390 = "[390]6:30"
		405 = "[405]6:45"
		420 = "[420]7:00"
		435 = "[435]7:15"
		45 = "[45]0:45"
		450 = "[450]7:30"
		465 = "[465]7:45"
		480 = "[480]8:00"
		495 = "[495]8:15"
		510 = "[510]8:30"
		525 = "[525]8:45"
		540 = "[540]9:00"
		555 = "[555]9:15"
		570 = "[570]9:30"
		585 = "[585]9:45"
		60 = "[60]1:00"
		600 = "[600]10:00"
		615 = "[615]10:15"
		630 = "[630]10:30"
		645 = "[645]10:45"
		660 = "[660]11:00"
		675 = "[675]11:15"
		690 = "[690]11:30"
		705 = "[705]11:45"
		720 = "[720]12:00"
		735 = "[735]12:15"
		75 = "[75]1:15"
		750 = "[750]12:30"
		765 = "[765]12:45"
		780 = "[780]13:00"
		795 = "[795]13:15"
		810 = "[810]13:30"
		825 = "[825]13:45"
		840 = "[840]14:00"
		855 = "[855]14:15"
		870 = "[870]14:30"
		885 = "[885]14:45"
		90 = "[90]1:30"
		900 = "[900]15:00"
		. = ' '
		OTHER = '?'
	;
	value DF0022f
		-1 = "[-1]I cannot or do not want to answer this question."
		0 = "[0]0:00"
		105 = "[105]1:45"
		120 = "[120]2:00"
		135 = "[135]2:15"
		15 = "[15]0:15"
		150 = "[150]2:30"
		165 = "[165]2:45"
		180 = "[180]3:00"
		195 = "[195]3:15"
		210 = "[210]3:30"
		225 = "[225]3:45"
		240 = "[240]4:00"
		255 = "[255]4:15"
		270 = "[270]4:30"
		285 = "[285]4:45"
		30 = "[30]0:30"
		300 = "[300]5:00"
		315 = "[315]5:15"
		330 = "[330]5:30"
		345 = "[345]5:45"
		360 = "[360]6:00"
		375 = "[375]6:15"
		390 = "[390]6:30"
		405 = "[405]6:45"
		420 = "[420]7:00"
		435 = "[435]7:15"
		45 = "[45]0:45"
		450 = "[450]7:30"
		465 = "[465]7:45"
		480 = "[480]8:00"
		495 = "[495]8:15"
		510 = "[510]8:30"
		525 = "[525]8:45"
		540 = "[540]9:00"
		555 = "[555]9:15"
		570 = "[570]9:30"
		585 = "[585]9:45"
		60 = "[60]1:00"
		600 = "[600]10:00"
		615 = "[615]10:15"
		630 = "[630]10:30"
		645 = "[645]10:45"
		660 = "[660]11:00"
		675 = "[675]11:15"
		690 = "[690]11:30"
		705 = "[705]11:45"
		720 = "[720]12:00"
		735 = "[735]12:15"
		75 = "[75]1:15"
		750 = "[750]12:30"
		765 = "[765]12:45"
		780 = "[780]13:00"
		795 = "[795]13:15"
		810 = "[810]13:30"
		825 = "[825]13:45"
		840 = "[840]14:00"
		855 = "[855]14:15"
		870 = "[870]14:30"
		885 = "[885]14:45"
		90 = "[90]1:30"
		900 = "[900]15:00"
		. = ' '
		OTHER = '?'
	;
	value DF0023f
		-1 = "[-1]I cannot or do not want to answer this question."
		1 = "[1]Feet and Inches"
		2 = "[2]Meters"
		. = ' '
		OTHER = '?'
	;
	value DF0024f
		-1 = "[-1]I cannot or do not want to answer this question."
		1 = "[1]Pounds"
		2 = "[2]Kilograms"
		. = ' '
		OTHER = '?'
	;
	value DF0025f
		0 = "[0]0"
		1 = "[1]1"
		2 = "[2]2"
		3 = "[3]3"
		4 = "[4]4"
		5 = "[5]5"
		6 = "[6]6"
		7 = "[7]7"
		8 = "[8]8"
		9 = "[9]9"
		. = ' '
		OTHER = '?'
	;
	value DF0026f
		0 = "[0]0"
		1 = "[1]1"
		10 = "[10]10"
		11 = "[11]11"
		2 = "[2]2"
		3 = "[3]3"
		4 = "[4]4"
		5 = "[5]5"
		6 = "[6]6"
		7 = "[7]7"
		8 = "[8]8"
		9 = "[9]9"
		. = ' '
		OTHER = '?'
	;
	value DF0027f
		1 = "[1]Yes, show me the seasonality questions."
		2 = "[2]No, I'll skip the seasonality questions."
		. = ' '
		OTHER = '?'
	;
	value DF0028f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0029f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0030f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0031f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0032f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0033f
		0 = "[0]no change"
		1 = "[1]slight change"
		2 = "[2]moderate change"
		3 = "[3]marked change"
		4 = "[4]extreme change"
		. = ' '
		OTHER = '?'
	;
	value DF0034f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0035f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0036f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0037f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0038f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0039f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0040f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0041f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0042f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0043f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0044f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0045f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0046f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0047f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0048f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0049f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0050f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0051f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0052f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0053f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0054f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0055f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0056f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0057f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0058f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0059f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0060f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0061f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0062f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0063f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0064f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0065f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0066f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0067f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0068f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0069f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0070f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0071f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0072f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0073f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0074f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0075f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0076f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0077f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0078f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0079f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0080f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0081f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0082f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0083f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0084f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0085f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0086f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0087f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0088f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0089f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0090f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0091f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0092f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0093f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0094f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0095f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0096f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0097f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0098f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0099f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0100f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0101f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0102f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0103f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0104f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0105f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0106f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0107f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0108f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0109f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0110f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0111f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0112f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0113f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0114f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0115f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0116f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0117f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0118f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0119f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0120f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0121f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0122f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0123f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0124f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0125f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0126f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0127f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0128f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0129f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0130f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0131f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0132f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0133f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0134f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0135f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0136f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0137f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0138f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0139f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0140f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0141f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0142f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0143f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0144f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0145f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0146f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0147f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0148f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0149f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0150f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0151f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0152f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0153f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0154f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0155f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0156f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0157f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0158f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0159f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0160f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0161f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0162f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0163f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0164f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0165f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0166f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0167f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0168f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0169f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0170f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0171f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0172f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0173f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0174f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0175f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0176f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0177f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0178f
		1 = "[1]Yes (NONE)"
		. = ' '
		OTHER = '?'
	;
	value DF0179f
		1 = "[1]Yes (January)"
		. = ' '
		OTHER = '?'
	;
	value DF0180f
		1 = "[1]Yes (February)"
		. = ' '
		OTHER = '?'
	;
	value DF0181f
		1 = "[1]Yes (March)"
		. = ' '
		OTHER = '?'
	;
	value DF0182f
		1 = "[1]Yes (April)"
		. = ' '
		OTHER = '?'
	;
	value DF0183f
		1 = "[1]Yes (May)"
		. = ' '
		OTHER = '?'
	;
	value DF0184f
		1 = "[1]Yes (June)"
		. = ' '
		OTHER = '?'
	;
	value DF0185f
		1 = "[1]Yes (July)"
		. = ' '
		OTHER = '?'
	;
	value DF0186f
		1 = "[1]Yes (August)"
		. = ' '
		OTHER = '?'
	;
	value DF0187f
		1 = "[1]Yes (September)"
		. = ' '
		OTHER = '?'
	;
	value DF0188f
		1 = "[1]Yes (October)"
		. = ' '
		OTHER = '?'
	;
	value DF0189f
		1 = "[1]Yes (November)"
		. = ' '
		OTHER = '?'
	;
	value DF0190f
		1 = "[1]Yes (December)"
		. = ' '
		OTHER = '?'
	;
	value DF0191f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0192f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0193f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0194f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0195f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0196f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0197f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0198f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0199f
		0 = "[0]no"
		1 = "[1]yes"
		. = ' '
		OTHER = '?'
	;
	value DF0200f
		0 = "[0]12:00 noon-5:00 a.m."
		1 = "[1]11:00 a.m.-12:00 noon"
		2 = "[2]9:45-11:00 a.m."
		3 = "[3]7:45-9:45 a.m."
		4 = "[4]6:30-7:45 a.m."
		5 = "[5]5:00-6:30 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0201f
		0 = "[0]3:00 a.m.-8:00 p.m."
		1 = "[1]1:45-3:00 a.m."
		2 = "[2]12:30-1:45 a.m."
		3 = "[3]10:15 p.m.-12:30 a.m."
		4 = "[4]9:00-10:15 p.m."
		5 = "[5]8:00-9:00 p.m."
		. = ' '
		OTHER = '?'
	;
	value DF0202f
		0 = "[0]No"
		1 = "[1]Yes"
		. = ' '
		OTHER = '?'
	;
	value DF0203f
		1 = "[1]Very much"
		2 = "[2]Somewhat"
		3 = "[3]Slightly"
		4 = "[4]Not at all"
		. = ' '
		OTHER = '?'
	;
	value DF0204f
		1 = "[1]Very difficult"
		2 = "[2]Somewhat difficult"
		3 = "[3]Fairly easy"
		4 = "[4]Very easy"
		. = ' '
		OTHER = '?'
	;
	value DF0205f
		1 = "[1]Not at all alert"
		2 = "[2]Slightly alert"
		3 = "[3]Fairly alert"
		4 = "[4]Very alert"
		. = ' '
		OTHER = '?'
	;
	value DF0206f
		1 = "[1]Not at all hungry"
		2 = "[2]Slightly hungry"
		3 = "[3]Fairly hungry"
		4 = "[4]Very hungry"
		. = ' '
		OTHER = '?'
	;
	value DF0207f
		1 = "[1]Very tired"
		2 = "[2]Fairly tired"
		3 = "[3]Fairly refreshed"
		4 = "[4]Very refreshed"
		. = ' '
		OTHER = '?'
	;
	value DF0208f
		1 = "[1]More than 2 hours later"
		2 = "[2]1-2 hours later"
		3 = "[3]Less than 1 hour later"
		4 = "[4]Seldom or never later"
		. = ' '
		OTHER = '?'
	;
	value DF0209f
		1 = "[1]Would find it very difficult"
		2 = "[2]Would find it difficult"
		3 = "[3]Would be in reasonable form"
		4 = "[4]Would be in good form"
		. = ' '
		OTHER = '?'
	;
	value DF0210f
		1 = "[1]2-3 a.m."
		2 = "[2]12:45-2:00 a.m."
		3 = "[3]10:15 p.m.-12:45 a.m."
		4 = "[4]9-10:15 p.m."
		5 = "[5]8-9 p.m."
		. = ' '
		OTHER = '?'
	;
	value DF0211f
		0 = "[0]7-9 p.m."
		2 = "[2]3-5 p.m."
		4 = "[4]11 a.m.-1 p.m."
		6 = "[6]8-10 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0212f
		0 = "[0]Not at all tired"
		2 = "[2]A little tired"
		3 = "[3]Fairly tired"
		5 = "[5]Very tired"
		. = ' '
		OTHER = '?'
	;
	value DF0213f
		1 = "[1]Will not wake up until later than usual"
		2 = "[2]Will wake up at usual time, but will fall asleep again"
		3 = "[3]Will wake up at usual time and will doze thereafter"
		4 = "[4]Will wake up at usual time, but will not fall back asleep"
		. = ' '
		OTHER = '?'
	;
	value DF0214f
		1 = "[1]Would not go to bed until the watch was over"
		2 = "[2]Would take a nap before and sleep after"
		3 = "[3]Would take a good sleep before and nap after"
		4 = "[4]Would sleep only before the watch"
		. = ' '
		OTHER = '?'
	;
	value DF0215f
		1 = "[1]7-9 p.m."
		2 = "[2]3-5 p.m."
		3 = "[3]11 a.m.-1 p.m."
		4 = "[4]8-10 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0216f
		1 = "[1]Would be in good form"
		2 = "[2]Would be in reasonable form"
		3 = "[3]Would find it difficult"
		4 = "[4]Would find it very difficult"
		. = ' '
		OTHER = '?'
	;
	value DF0217f
		1 = "[1]5 hours starting between 5 p.m. and 4 a.m."
		2 = "[2]5 hours starting between 2 p.m. and 5 p.m."
		3 = "[3]5 hours starting between 9 a.m. and 2 p.m."
		4 = "[4]5 hours starting between 8 a.m. and 9 a.m."
		5 = "[5]5 hours starting between 4 a.m. and 8 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0218f
		1 = "[1]10 pm-5 a.m."
		2 = "[2]5-10 p.m."
		3 = "[3]10 a.m-5 p.m."
		4 = "[4]8-10 a.m."
		5 = "[5]5-8 a.m."
		. = ' '
		OTHER = '?'
	;
	value DF0219f
		0 = "[0]Definitely an evening type"
		2 = "[2]Rather more an evening type than a morning type"
		4 = "[4]Rather more a morning type than an evening type"
		6 = "[6]Definitely a morning type"
		. = ' '
		OTHER = '?'
	;
	value DF0220f
		1 = "[1]Please let me review my answers from the beginning"
		2 = "[2]My answers are correct - please continue"
		. = ' '
		OTHER = '?'
	;
run;
data WORK.AutoMEQ4; set WORK.AutoMEQ4;
	format d_who DF0001f.;
	format d_study DF0002f.;
	format d_sex DF0003f.;
	format d_eye DF0004f.;
	format d_country $DF0005f.;
	format d_state DF0006f.;
	format d_los DF0007f.;
	format d_eth_ai DF0008f.;
	format d_eth_as DF0009f.;
	format d_eth_bl DF0010f.;
	format d_eth_his DF0011f.;
	format d_eth_hw DF0012f.;
	format d_eth_wh DF0013f.;
	format d_working_days DF0014f.;
	format d_sleep_workday $DF0015f.;
	format d_sleep_nonworkday $DF0016f.;
	format d_awake_workday $DF0017f.;
	format d_awake_nonworkday $DF0018f.;
	format d_sleep_darkroom DF0019f.;
	format d_wake_withlight DF0020f.;
	format d_outsidelight_work DF0021f.;
	format d_outsidelight_nonwork DF0022f.;
	format d_height_units DF0023f.;
	format d_weight_units DF0024f.;
	format d_height_feet DF0025f.;
	format d_height_inches DF0026f.;
	format askPIDS DF0027f.;
	format B1 DF0028f.;
	format B2 DF0029f.;
	format B3 DF0030f.;
	format B4 DF0031f.;
	format B5 DF0032f.;
	format B6 DF0033f.;
	format B7 DF0034f.;
	format C1A_Non DF0035f.;
	format C1A_Jan DF0036f.;
	format C1A_Feb DF0037f.;
	format C1A_Mar DF0038f.;
	format C1A_Apr DF0039f.;
	format C1A_May DF0040f.;
	format C1A_Jun DF0041f.;
	format C1A_Jul DF0042f.;
	format C1A_Aug DF0043f.;
	format C1A_Sep DF0044f.;
	format C1A_Oct DF0045f.;
	format C1A_Nov DF0046f.;
	format C1A_Dec DF0047f.;
	format C1B_Non DF0048f.;
	format C1B_Jan DF0049f.;
	format C1B_Feb DF0050f.;
	format C1B_Mar DF0051f.;
	format C1B_Apr DF0052f.;
	format C1B_May DF0053f.;
	format C1B_Jun DF0054f.;
	format C1B_Jul DF0055f.;
	format C1B_Aug DF0056f.;
	format C1B_Sep DF0057f.;
	format C1B_Oct DF0058f.;
	format C1B_Nov DF0059f.;
	format C1B_Dec DF0060f.;
	format C2A_Non DF0061f.;
	format C2A_Jan DF0062f.;
	format C2A_Feb DF0063f.;
	format C2A_Mar DF0064f.;
	format C2A_Apr DF0065f.;
	format C2A_May DF0066f.;
	format C2A_Jun DF0067f.;
	format C2A_Jul DF0068f.;
	format C2A_Aug DF0069f.;
	format C2A_Sep DF0070f.;
	format C2A_Oct DF0071f.;
	format C2A_Nov DF0072f.;
	format C2A_Dec DF0073f.;
	format C2B_Non DF0074f.;
	format C2B_Jan DF0075f.;
	format C2B_Feb DF0076f.;
	format C2B_Mar DF0077f.;
	format C2B_Apr DF0078f.;
	format C2B_May DF0079f.;
	format C2B_Jun DF0080f.;
	format C2B_Jul DF0081f.;
	format C2B_Aug DF0082f.;
	format C2B_Sep DF0083f.;
	format C2B_Oct DF0084f.;
	format C2B_Nov DF0085f.;
	format C2B_Dec DF0086f.;
	format C3A_Non DF0087f.;
	format C3A_Jan DF0088f.;
	format C3A_Feb DF0089f.;
	format C3A_Mar DF0090f.;
	format C3A_Apr DF0091f.;
	format C3A_May DF0092f.;
	format C3A_Jun DF0093f.;
	format C3A_Jul DF0094f.;
	format C3A_Aug DF0095f.;
	format C3A_Sep DF0096f.;
	format C3A_Oct DF0097f.;
	format C3A_Nov DF0098f.;
	format C3A_Dec DF0099f.;
	format C3B_Non DF0100f.;
	format C3B_Jan DF0101f.;
	format C3B_Feb DF0102f.;
	format C3B_Mar DF0103f.;
	format C3B_Apr DF0104f.;
	format C3B_May DF0105f.;
	format C3B_Jun DF0106f.;
	format C3B_Jul DF0107f.;
	format C3B_Aug DF0108f.;
	format C3B_Sep DF0109f.;
	format C3B_Oct DF0110f.;
	format C3B_Nov DF0111f.;
	format C3B_Dec DF0112f.;
	format C4A_Non DF0113f.;
	format C4A_Jan DF0114f.;
	format C4A_Feb DF0115f.;
	format C4A_Mar DF0116f.;
	format C4A_Apr DF0117f.;
	format C4A_May DF0118f.;
	format C4A_Jun DF0119f.;
	format C4A_Jul DF0120f.;
	format C4A_Aug DF0121f.;
	format C4A_Sep DF0122f.;
	format C4A_Oct DF0123f.;
	format C4A_Nov DF0124f.;
	format C4A_Dec DF0125f.;
	format C4B_Non DF0126f.;
	format C4B_Jan DF0127f.;
	format C4B_Feb DF0128f.;
	format C4B_Mar DF0129f.;
	format C4B_Apr DF0130f.;
	format C4B_May DF0131f.;
	format C4B_Jun DF0132f.;
	format C4B_Jul DF0133f.;
	format C4B_Aug DF0134f.;
	format C4B_Sep DF0135f.;
	format C4B_Oct DF0136f.;
	format C4B_Nov DF0137f.;
	format C4B_Dec DF0138f.;
	format C5A_Non DF0139f.;
	format C5A_Jan DF0140f.;
	format C5A_Feb DF0141f.;
	format C5A_Mar DF0142f.;
	format C5A_Apr DF0143f.;
	format C5A_May DF0144f.;
	format C5A_Jun DF0145f.;
	format C5A_Jul DF0146f.;
	format C5A_Aug DF0147f.;
	format C5A_Sep DF0148f.;
	format C5A_Oct DF0149f.;
	format C5A_Nov DF0150f.;
	format C5A_Dec DF0151f.;
	format C5B_Non DF0152f.;
	format C5B_Jan DF0153f.;
	format C5B_Feb DF0154f.;
	format C5B_Mar DF0155f.;
	format C5B_Apr DF0156f.;
	format C5B_May DF0157f.;
	format C5B_Jun DF0158f.;
	format C5B_Jul DF0159f.;
	format C5B_Aug DF0160f.;
	format C5B_Sep DF0161f.;
	format C5B_Oct DF0162f.;
	format C5B_Nov DF0163f.;
	format C5B_Dec DF0164f.;
	format C6A_Non DF0165f.;
	format C6A_Jan DF0166f.;
	format C6A_Feb DF0167f.;
	format C6A_Mar DF0168f.;
	format C6A_Apr DF0169f.;
	format C6A_May DF0170f.;
	format C6A_Jun DF0171f.;
	format C6A_Jul DF0172f.;
	format C6A_Aug DF0173f.;
	format C6A_Sep DF0174f.;
	format C6A_Oct DF0175f.;
	format C6A_Nov DF0176f.;
	format C6A_Dec DF0177f.;
	format C6B_Non DF0178f.;
	format C6B_Jan DF0179f.;
	format C6B_Feb DF0180f.;
	format C6B_Mar DF0181f.;
	format C6B_Apr DF0182f.;
	format C6B_May DF0183f.;
	format C6B_Jun DF0184f.;
	format C6B_Jul DF0185f.;
	format C6B_Aug DF0186f.;
	format C6B_Sep DF0187f.;
	format C6B_Oct DF0188f.;
	format C6B_Nov DF0189f.;
	format C6B_Dec DF0190f.;
	format D1 DF0191f.;
	format D2 DF0192f.;
	format D3 DF0193f.;
	format D4 DF0194f.;
	format D5 DF0195f.;
	format D6 DF0196f.;
	format D7 DF0197f.;
	format D8 DF0198f.;
	format D9 DF0199f.;
	format q1 DF0200f.;
	format q2 DF0201f.;
	format d_abnl_sleep_cont DF0202f.;
	format q3 DF0203f.;
	format q4 DF0204f.;
	format q5 DF0205f.;
	format q6 DF0206f.;
	format q7 DF0207f.;
	format q8 DF0208f.;
	format q9 DF0209f.;
	format q10 DF0210f.;
	format q11 DF0211f.;
	format q12 DF0212f.;
	format q13 DF0213f.;
	format q14 DF0214f.;
	format q15 DF0215f.;
	format q16 DF0216f.;
	format q17 DF0217f.;
	format q18 DF0218f.;
	format q19 DF0219f.;
	format Feedback0 DF0220f.;
run;
options compress=BINARY;
data '\data\cet7\analysis\AutoMEQ-SA-v4.0-(AutoMEQ-SA-irb)\AutoMEQv40.sas7bdat'; set WORK.AutoMEQ4; run;
/*proc sql; drop table WORK.AutoMEQ4;*/
