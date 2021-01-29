#pragma rtGlobals=1		// Use modern global access method.
#pragma ModuleName = CCN

static constant ccn_version=3.2
static strconstant namespace = "ccn"

// --- Changes from 3.x to3.2 --- 21 May 2018 
//  	- Change to make cleaning NaNs persist when making new ss_waves
// --- Changes from 3.1 to3.x --- 
//  	- Cleaned up menus
// 	- Changed rename_itx_waves to allow use of mono_waves as input (i.e., only run one version of daq for both mono and spectra)
//	-  added namespace pragma and namespace constant
//	- 
// --- Changes from 3.0 to3.1 --- 27 Feb 2018
//	- Unkown changes...save this as working copy before major changes
// --- Changes from 2.6 to3.0 --- 01 Sept 2017 :: Not backward compatible?
//	- add function to load tthdma valve 
// --- Changes from 2.4 to 2.6 --- 31 Aug 2017
// 	- unknown all the changes. Just catching for major change now.
// --- Changes from 2.3 to 2.4 --- 24 May 2010
//	- fixed: mono code to allow "new way" (i.e., no dp stepping)
// --- Changes from 2.2 to 2.3 --- 19 May 2010
//	- added ability to use dchart itx data
//	- broken: still need to fix mono code
// --- Changes from 2.1 to 2.2 --- 16 April 2008
//	- changed wave names to be somewhat decipherable
//	- put avg_mask on ccn timebase and average is created on the fly
/// --- Changes from 2.0 to 2.1 --- 11 April 2008
//	- added function to match tubing delay times between ccn and cn (mono)
// --- Changes from 1.9 to 2.0 --- 10 April 2008
//	- added function average over multiple periods using marquee - pretty kludgy right now
// --- Changes from 1.8 to 1.9 --- 04 April 2008
//	- added function to adjust older mono_dp to new values
// --- Changes from 1.7 to 1.8 --- 30 March 2008
//	- merged Trish's changes
//	- added function to average concatenated ccn, cn, and ratio for mono data
// --- Changes from 1.6 to 1.7 --- 28 March 2008
//	- added mono cleaning and averaging
// --- Changes from 1.5 to 1.6 --- 27 March 2008
//	- made extra overshoot parameter for large jumps in SS actually work. I hope
//	- changed so that NaN's do not trigger overshoot cleaning
// --- Changes from 1.4 to 1.5 --- 24 March 2008
//	- added extra overshoot parameter for large jumps in SS
//	- added ability to load mono parameters
// --- Changes from 1.4 to 1.4 --- 23 March 2008
// 	- incorporated changes from Trish
// --- Changes from 1.2 to 1.3 --- 20 March 2008
//  	- changed to allow for new data format in ICEALOT


strconstant ccn_tmp_data_folder = "root:ccn_tmp_data_folder"
strconstant ccn_data_folder = "root:ccn"
strconstant ccn_dataselector_format = "dataselector"
strconstant ccn_dataselector_format_2 = "dataselector2"  // ICEALOT format
strconstant ccn_instrument_format = "native"
strconstant ccn_dchart_itx_format = "dchart_itx"
//strconstant raw_folder = "raw"
//strconstant tmp_dataset_name = "dataset_name"
//strconstant tmp_dataset_waves = "dataset_waves"

//strconstant data_folder = "root:CCNdata051223002642" // ccn data folder
//constant ccn_overshoot_sec = 180  // number of seconds to clean from beginning of ss step
//constant ccn_overshoot_sec_big = 500 // e.g., going from 1.0 back to 0.2
constant ccn_overshoot_sec = 60  // number of seconds to clean from beginning of ss step
constant ccn_overshoot_sec_big = 120 // e.g., going from 1.0 back to 0.2
constant ccn_overshoot_ss_from = .7
constant ccn_overshoot_ss_to = 0.3
//strconstant ccn_nom_ss_levels = "0.2;0.3;0.4;0.5;1.0" // ICEALOT
//strconstant ccn_nom_ss_levels = "0.1;0.15;0.2;0.3;0.6" // VOCALS
//strconstant ccn_nom_ss_levels = "0.3;0.4;0.5;0.6;0.7" // CalNex
//strconstant ccn_nom_ss_levels= "0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1;1.1;1.2;1.3;1.4;1.5;1.6;1.7;1.8" // WACS
//strconstant ccn_nom_ss_levels= "0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8" // NAAMES
strconstant ccn_nom_ss_levels= "0.1;0.11;0.12;0.13;0.14;0.15;0.16;0.17;0.18;0.19;0.2;0.21;0.22;0.23;0.24;0.25;0.26;0.27;0.28;0.29;0.3;0.31;0.32;0.33;0.34;0.35;0.36;0.37;0.38;0.39;0.4;0.41;0.42;0.43;0.44;0.45;0.46;0.47;0.48;0.49;0.5;0.52;0.54;0.55;0.56;0.58;0.6;0.62" // NAAMES3

constant ccn_avg_period = 10 // seconds
//constant doAvg = 0 // (0=false, 1=true) toggle data reduction through averaging

constant ccn_defaultTimeBase = 1 // second


constant ccn_cpc_flow = 1.0 //  might be easier to correct input file first
constant ccn_use_this_cpc = 4 // 0=CN_AMS, 1=WCPC, 2=UFCN, 3=CN_water, 4=CCN_mono_cn_concentration

constant ccn_system_type = 1 // 1 = spectra, 2 = mono
constant ccn_dp_steps = 5 // number of dp steps per SS

constant ccn_cn_tubing_delay = 8 // sec
constant ccn_mono_tubing_delay = 20 // sec

//strconstant ccn_mono_dp_list= "30;40;50;60;70;80;90;100;110" // WACS
strconstant ccn_mono_dp_list= "50;75;100;150" // NAAMES
//strconstant ccn_mono_dp_list= "60" // CalNex
//strconstant ccn_mono_ss_list= "0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1;1.1;1.2;1.3;1.4;1.5;1.6;1.7;1.8" // WACS
//strconstant ccn_mono_ss_list= "0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8" // NAAMES
strconstant ccn_mono_ss_list= "0.1;0.11;0.12;0.13;0.14;0.15;0.16;0.17;0.18;0.19;0.2;0.21;0.22;0.23;0.24;0.25;0.26;0.27;0.28;0.29;0.3;0.31;0.32;0.33;0.34;0.35;0.36;0.37;0.38;0.39;0.4;0.41;0.42;0.43;0.44;0.45;0.46;0.47;0.48;0.49;0.5;0.52;0.54;0.55;0.56;0.58;0.6;0.62" // NAAMES3
//strconstant ccn_mono_ss_list= "0.3;0.4;0.5;0.6;0.7" // CalNex

// Do not include a "BAD" or "NORMAL" types to the list, they will be prepended automatically
//strconstant ccn_samp_type_list ="SS_LOW_CHL;SS_HI_CHL;AMBIENT;CAL_SULF" // WACS
//strconstant ccn_samp_type_list ="SS_LOW_CHL;SS_HI_CHL;AMBIENT_1;AMBIENT_2" // WACS
//strconstant ccn_samp_type_list ="CLEAN_MAR;SM_BAY;SB_CHANNEL;LA_HARBOR;SF_BAY;SAC;SHIPS;SeaSweep" // CalNex
//strconstant ccn_samp_type_list =""
//strconstant ccn_samp_type_list ="CAL_SULF" // VanPark
// Trish's initial pass at sample types during the cruise...will change to the one after.
//strconstant ccn_samp_type_list ="SEA_SWEEP_1;AMB_5_24;SEA_SWEEP_2;AMB_5_25_H;SEA_SWEEP_2_SF;AmmSulf;NaCl;STATION_2_SW;AMB_5_29_H;SEA_SWEEP_3;AMB_5_31;AMB_5_31_H;SEA_SWEEP_4;SEA_SWEEP_4_H;AMB_6_2;AMB_6_3;AMB_6_3_H;AMB_6_4;SEA_SWEEP_5;SEA_SWEEP_5_H;STATION_5_SW;AMB_5_20;AMB_5_21;AMB_5_25;AMB_5_29;AMB_6_4_H;NaCl_H;AmmSulf_H" 


//strconstant ccn_samp_type_list ="SEA_SWEEP_1;AMB_5_24;SEA_SWEEP_2;AMB_5_25_H;SEA_SWEEP_2_SF;AmmSulf;NaCl;STATION_2_SW;AMB_5_29_H;SEA_SWEEP_3;AMB_5_31;AMB_5_31_H;SEA_SWEEP_4;SEA_SWEEP_4_H;AMB_6_2;AMB_6_3;AMB_6_3_H;AMB_6_4_H;SEA_SWEEP_5;SEA_SWEEP_5_H;STATION_5_SW;AMB_5_20;AMB_5_21;AMB_5_25;AMB_5_29;AMB_6_4;NaCl_H;AmmSulf_H" 
////strconstant ccn_samp_type_list ="AMBIENT;SEASWEEP;STATION_1;STATION_2;Denuder;AmSulf;NaCl;Station_2_SW;SS_Large_Frits;SS_Small_Frits;AMBIENT_1;AMBIENT_2;Denuder_2;STATION_3;STATION_4;ST_4_Denuder;AMBIENT_3;Spectra_Denuder;Spectra_Ambient;SP_Denuder_2;AMBIENT_4;SP_AMB_UH_5;SP_AMB_H_5;SP_AmSulf_UH;SP_NaCl_UH;SS_5_UH;SS_5_H;NaCl_H;AmmSulf_H;St5_SW_H;St5_SW_UH;DENUDER_4" // WACS
//strconstant ccn_samp_type_list_old ="AMBIENT;SEASWEEP;STATION_1;STATION_2;Denuder;AmSulf;NaCl;Station_2_SW;SS_Large_Frits;SS_Small_Frits;AMBIENT_1;AMBIENT_2;Denuder_2;STATION_3;STATION_4;ST_4_Denuder;AMBIENT_3;Spectra_Denuder;Spectra_Ambient;SP_Denuder_2;AMBIENT_4;SP_AMB_UH_5;SP_AMB_H_5;SP_AmSulf_UH;SP_NaCl_UH;SS_5_UH;SS_5_H;NaCl_H;AmmSulf_H;St5_SW_H;St5_SW_UH;DENUDER_4" // WACS
//strconstant ccn_samp_type_list_new ="SEA_SWEEP_1;AMB_5_24;SEA_SWEEP_2;AMB_5_25_H;SEA_SWEEP_2_SF;AmmSulf;NaCl;STATION_2_SW;AMB_5_29_H;SEA_SWEEP_3;AMB_5_31;AMB_5_31_H;SEA_SWEEP_4;SEA_SWEEP_4_H;AMB_6_2;AMB_6_3;AMB_6_3_H;AMB_6_4_H;SEA_SWEEP_5;SEA_SWEEP_5_H;STATION_5_SW;AMB_5_20;AMB_5_21;AMB_5_25;AMB_5_29;AMB_6_4;NaCl_H;AmmSulf_H" 

//strconstant ccn_samp_type_list ="SS_1;SS_2;MART_tr_907;SS_3;MART_st_3;AS_cal_909;NaCl_cal_909;SS_4_1;MART_st_4;SS_4_2;SS_4_3;Mart_tr_910;MART_st_6_1;MART_st_6_2;MART_st_6_3;SS_6_1;MART_st_6_4;SW_st1_905_130L;ML_st1_905_100L;ML_st5_912_600L;SW_st5_912_215L;MART_tr_919N;MART_tr_919D;SS_6_2"//NAAMES 3 calibration & Seasweep
//strconstant ccn_samp_type_list_new ="SS_1;SS_2;MART_tr_907;SS_3;MART_st_3;AS_cal_909;NaCl_cal_909;SS_4_1;MART_st_4;SS_4_2;SS_4_3;Mart_tr_910;MART_st_6_1;MART_st_6_2;MART_st_6_3;SS_6_1;MART_st_6_4;SW_st1_905_130L;ML_st1_905_100L;ML_st5_912_600L;SW_st5_912_215L;MART_tr_919N;MART_tr_919D;SS_6_2"//NAAMES 3 calibration & Seasweep

strconstant ccn_samp_type_list_new ="SEA_SWEEP_1;SEA_SWEEP_2;SEA_SWEEP_3;SEA_SWEEP_4;SEA_SWEEP_5;SEA_SWEEP_6;SEA_SWEEP_7"
strconstant ccn_samp_type_list ="SEA_SWEEP_1;SEA_SWEEP_2;SEA_SWEEP_3;SEA_SWEEP_4;SEA_SWEEP_5;SEA_SWEEP_6;SEA_SWEEP_7"

constant mono_cn_lower_limit = 1.5

constant kappa_TimeBase = 10

// From CCN Model.ipf

constant MW_h2o = 18.0
constant MW_nh4_2_so4 = 132.14

constant DENSITY_h2o = 1.0
constant DENSITY_nh4_2_so4 = 1.77

constant auto_update_dp_ss_waves=0
constant auto_update_matrix=1
//constant default_normalize=0
strconstant default_normalize="no"

//menu "CCN"
menu "ACG Data"
	submenu "CCN"
		submenu "Load Data"
			"from DChart - spectra", load_ccn_data(ccn_dchart_itx_format,1)
			"from DChart - mono", load_ccn_data(ccn_dchart_itx_format,2)
//			"from DataSelector()", load_ccn_data(ccn_dataselector_format)
//			"from DataSelector - spectra", load_ccn_data(ccn_dataselector_format_2,1)
//			"from DataSelector - mono", load_ccn_data(ccn_dataselector_format_2,2)
//			"from CCN Instrument - spectra", load_ccn_data(ccn_instrument_format,1)
//			"from CCN Instrument - mono", load_ccn_data(ccn_instrument_format,2)
			"load ttdma valve", ccn_ttdma_load_valve()
		end
		submenu "Process Data"
//			"create SS mask waves - mono",Make_SS_mask_waves_mono()
//			"create SS mask waves - spectra",Make_SS_mask_waves_spectra()
			"average all ccn, cn, and ratio - mono", ccn_avg_mono_all()
			"-"
			submenu "Generate waves/matrices"	
				submenu "mono"
					"Generate dp vs ss both",ccn_mono_generate_dp_vs_ss()
					"Generate dp vs ss waves", ccn_generate_dp_vs_ss_waves()
					"Generate dp vs ss matrix",ccn_generate_dp_vs_ss_matrix(normalize=default_normalize)
				end
			end
		end
		//"Remove Unstable T from Num Conc", NaNPoints_TStab()
		//"Clean first X minutes from Num Conc_Tstab", NaNPoints_Overshoot()
		//"Remove Unstable T and Clean first X minutes from Num Conc", NaNPoints_TStab_and_Overshoot()
	end
end

Menu "GraphMarquee", dynamic
	"-"
	"CCN mono: add selection to avg", ccn_add_sel_to_avg_from_marq()
	"CCN mono: remove selection from avg", ccn_rem_sel_from_avg_from_marq()
//	submenu "CCN mono: set cn offset"
//		"custom", ccn_set_mono_cn_offset_marquee(0,isCustom=1)
//		"minus 10", ccn_set_mono_cn_offset_marquee(-10)
//		"minus 9", ccn_set_mono_cn_offset_marquee(-9)
//		"minus 9", ccn_set_mono_cn_offset_marquee(-8)
//		"minus 7", ccn_set_mono_cn_offset_marquee(-7)
//		"minus 6", ccn_set_mono_cn_offset_marquee(-6)
//		"minus 5", ccn_set_mono_cn_offset_marquee(-5)
//		"minus 4", ccn_set_mono_cn_offset_marquee(-4)
//		"minus 3", ccn_set_mono_cn_offset_marquee(-3)
//		"minus 2", ccn_set_mono_cn_offset_marquee(-2)
//		"minus 1", ccn_set_mono_cn_offset_marquee(-1)
//		"0", ccn_set_mono_cn_offset_marquee(0)
//		"1", ccn_set_mono_cn_offset_marquee(1)
//		"2", ccn_set_mono_cn_offset_marquee(2)
//		"3", ccn_set_mono_cn_offset_marquee(3)
//		"4", ccn_set_mono_cn_offset_marquee(4)
//		"5", ccn_set_mono_cn_offset_marquee(5)
//		"6", ccn_set_mono_cn_offset_marquee(6)
//		"7", ccn_set_mono_cn_offset_marquee(7)
//		"8", ccn_set_mono_cn_offset_marquee(8)
//		"9", ccn_set_mono_cn_offset_marquee(9)
//		"10", ccn_set_mono_cn_offset_marquee(10)
//	end
	submenu "CCN mono: dp_v_ss_wave"
		"NaN",ccn_toggle_dp_v_ss_nan_marquee(1)
		"Reset",ccn_toggle_dp_v_ss_nan_marquee(0)
	end
	submenu "CCN spectra: ss_wave"
		"NaN",ccn_spectra_toggle_ss_nan_marq(1)
		"Reset",ccn_spectra_toggle_ss_nan_marq(0)
	end
	submenu "CCN kappa: ss_wave"
		"NaN",ccn_kappa_toggle_ss_nan_marq(1)
		"Reset",ccn_kappa_toggle_ss_nan_marq(0)
	end
	
	

	"-"
	submenu "CCN: set sample type"
		ccn_get_samp_type_list(),/Q,ccn_set_sample_type_marquee()
	end
	
//	"PILS-IC: reset selection", pils_reset_sel_from_marquee()
//	"PILS-IC: mark selection as blank", pils_mark_blank_from_marquee()
//	"PILS-IC: unmark selection as blank", pils_unmark_blank_from_marquee()
End


Function load_ccn_instrument_format()
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
	//LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path 
	
	// load all data into nativeXX waves
	LoadWave/J/D/N=native/O/K=0/L={4,6,0,0,0}/P=loaddata_base_path 
	NewPath/o/z path_to_ccn, S_path
	string ccn_file = S_filename
	wave timewave = native0
	
	//get date from 2nd line of file
	LoadWave/J/D/N=nativedate/K=0/L={0,1,1,1,1}/P=path_to_ccn ccn_file
	wave datewave = nativedate0
	
	//create Start_DateTime, AvePeriod and DOY
	duplicate/O native0 Start_DateTime, AvePeriod
	wave ccn_dt = Start_DateTime
	ccn_dt = datewave[0] + timewave
	AvePeriod[] = 1 // set to 1 second
	datetime2doy_wave(ccn_dt,"DOY")
	
	// rename rest of waves
	string list1 = "X1stStageVoltage;AbsolutePressure;ADC_Overflow;BinSetting;CCN_Concentration;"
	string list2 = "LaserCurrnet;PropprtionalValveVolts;SampleFlow;SampleTemp;Sheath_Flow;SS_setting;"
	string list3 = "T1;T2;T3;TempGradient;TempStable;T_inlet;T_Nafion;T_OPC"
	string dslist = list1+list2+list3
	
	string nativeindex_list = "23;19;21;24;45;20;20;17;16;18;1;5;7;9;3;2;13;11;15"
	
	if (itemsinlist(dslist) != itemsinlist(nativeindex_list))
		print "Error in stringlists!"
		print "dslist = " + num2str(itemsinlist(dslist))
		print "nativeindex_list = " + num2str(itemsinlist(nativeindex_list))
		return -1
	endif
	
	variable i
	for (i=0; i<itemsinlist(dslist); i+=1)
	
		string ds = stringfromlist(i,dslist)
		wave nat = $("native"+stringfromlist(i,nativeindex_list))
		duplicate/o nat $ds 
	
	endfor
	
	//clean up	
	for (i=0; i<47; i+=1)
		killwaves/Z $("native"+num2str(i))
	endfor
	killwaves/Z nativedate0
	killpath/Z path_to_ccn
	
	//done
End

Function ccn_rename_waves()

	string wlist = acg_get_wave_list()
	
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		string name = stringfromlist(i,wlist)
		// check if wave contains CCN_mono_ or CCN_spectra_ and remove
		if (strsearch(name,"CCN_mono_",0) >=0 )
			name = ReplaceString("CCN_mono_", name, "")
			
			if (cmpstr(name, "Concentration") == 0)
				Rename $stringfromlist(i,wlist), $("CCN_Concentration")
			elseif (cmpstr(name, "1stStageVoltage") == 0)
				Rename $stringfromlist(i,wlist), $("X1stStageVoltage")
			else
				Rename $stringfromlist(i,wlist), $name
			endif
		elseif (strsearch(name,"CCN_spectra_",0) >=0 )
			name = ReplaceString("CCN_spectra_", name, "")
			
			if (cmpstr(name, "Concentration") == 0)
				Rename $stringfromlist(i,wlist), $("CCN_Concentration")
			elseif (cmpstr(name, "1stStageVoltage") == 0)
				Rename $stringfromlist(i,wlist), $("X1stStageVoltage")
			else
				Rename $stringfromlist(i,wlist), $name
			endif
		endif
		
		// handle new DateTime label
		if (cmpstr(name, "DateTimeW") == 0)
			Rename $name, $("Start_DateTime")
		endif
	endfor
	
	

End


Function ccn_rename_itx_waves(sys_type,allow_mono_as_input)
 	variable sys_type // 1=spectra, 2=mono
 	variable allow_mono_as_input // 0=false, 1=true

	string wlist = acg_get_wave_list()
	
	string ccn_mono_long_name="ccn_ss_ccn_mono;zi_flag_temp_stable_ccn_mono;zi_temp1_ccn_mono;zi_temp2_ccn_mono;"
	ccn_mono_long_name += "zi_temp3_ccn_mono;zi_temp_sample_ccn_mono;zi_temp_inlet_ccn_mono;"
	ccn_mono_long_name += "zi_temp_opc_ccn_mono;zi_temp_nafion_ccn_mono;ccn_flow_sample_ccn_mono;"
	ccn_mono_long_name += "ccn_flow_sheath_ccn_mono;zi_pressure_absolute_ccn_mono;zi_laser_current_ccn_mono;"
	ccn_mono_long_name += "zi_v_first_stage_ccn_mono;zi_temp_gradient_ccn_mono;zi_v_prop_valve_ccn_mono;"
	ccn_mono_long_name += "zi_bin_setting_ccn_mono;ccn_concentration_ccn_mono;zi_adc_overflow_ccn_mono"

	string ccn_spectra_long_name="ccn_ss_ccn_spectra;zi_flag_temp_stable_ccn_spectra;zi_temp1_ccn_spectra;zi_temp2_ccn_spectra;"
	ccn_spectra_long_name += "zi_temp3_ccn_spectra;zi_temp_sample_ccn_spectra;zi_temp_inlet_ccn_spectra;"
	ccn_spectra_long_name += "zi_temp_opc_ccn_spectra;zi_temp_nafion_ccn_spectra;ccn_flow_sample_ccn_spectra;"
	ccn_spectra_long_name += "ccn_flow_sheath_ccn_spectra;zi_pressure_absolute_ccn_spectra;zi_laser_current_ccn_spectra;"
	ccn_spectra_long_name += "zi_v_first_stage_ccn_spectra;zi_temp_gradient_ccn_spectra;zi_v_prop_valve_ccn_spectra;"
	ccn_spectra_long_name += "zi_bin_setting_ccn_spectra;ccn_concentration_ccn_spectra;zi_adc_overflow_ccn_spectra"

//	string ccn_mono_label = "CCN_mono_SS_setting;CCN_mono_TempStable;CCN_mono_T1;CCN_mono_T2;CCN_mono_T3;CCN_mono_SampleTemp;"
//	ccn_mono_label += "CCN_mono_T_inlet;CCN_mono_T_OPC;CCN_mono_T_Nafion;CCN_mono_SampleFlow;CCN_mono_Sheath_Flow;"
//	ccn_mono_label += "CCN_mono_AbsolutePressure;CCN_mono_LaserCurrnet;CCN_mono_1stStageVoltage;CCN_mono_TempGradient;"
//	ccn_mono_label += "CCN_mono_PropprtionalValveVolts;CCN_mono_BinSetting;CCN_mono_Concentration;CCN_mono_ADC_Overflow"
//	
//	string ccn_spectra_label = "CCN_spectra_SS_setting;CCN_spectra_TempStable;CCN_spectra_T1;CCN_spectra_T2;CCN_spectra_T3;CCN_spectra_SampleTemp;"
//	ccn_spectra_label += "CCN_spectra_T_inlet;CCN_spectra_T_OPC;CCN_spectra_T_Nafion;CCN_spectra_SampleFlow;CCN_spectra_Sheath_Flow;"
//	ccn_spectra_label += "CCN_spectra_AbsolutePressure;CCN_spectra_LaserCurrnet;CCN_spectra_1stStageVoltage;CCN_spectra_TempGradient;"
//	ccn_spectra_label += "CCN_spectra_PropprtionalValveVolts;CCN_spectra_BinSetting;CCN_spectra_Concentration;CCN_spectra_ADC_Overflow"

	string ccn_label = "SS_setting;TempStable;T1;T2;T3;SampleTemp;T_inlet;T_OPC;T_Nafion;SampleFlow;Sheath_Flow;AbsolutePressure;"
	ccn_label += "LaserCurrnet;X1stStageVoltage;TempGradient;PropprtionalValveVolts;BinSetting;CCN_Concentration;ADC_Overflow"


	string ccn_long_name = ccn_spectra_long_name
	//string ccn_label = ccn_spectra_label
	if (sys_type == 2 || allow_mono_as_input)
		ccn_long_name = ccn_mono_long_name
		//ccn_label = ccn_mono_label
	endif
	
	newdatafolder ::cn
	newdatafolder ::mono
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		string name = stringfromlist(i,wlist)

		if (cmpstr(name[0,2] ,"cn_") == 0) // cn wave
			if (cmpstr(name,"cn_ccn_mono")==0)
				duplicate/o $name, $("::mono:CCN_mono_cn_concentration")
			endif
				duplicate/o $name, $("::cn:"+name) // changed 22Aug2012: moved this out of if stmt to duplicate both places
				killwaves/Z $name
			// endif
		else
		
			variable index = whichlistitem(name,ccn_long_name)
			if (index >= 0)
				Rename $name, $StringFromList(index,ccn_label)
			endif
					
			// handle new DateTime label
			if (cmpstr(name, "StartDateTime") == 0)
				//duplicate/o $name ::cn:Start_DateTime, ::mono:Start_DateTime
				Rename $name, $("Start_DateTime")
				duplicate/o $("Start_DateTime") $("::cn:Start_DateTime"),$("::mono:Start_DateTime")
			endif
			
			
//			if (sys_type==2)
//				duplicate/o $name $(":mono:"+name)
//				killwaves/Z $name
//			endif
			
		endif 
	endfor

	setdatafolder ::cn
	
	// copy user selected CN data to CN_Concentration
	if (ccn_use_this_cpc == 0) // use CN_AMS ** not a valid option
		//duplicate/o CN_AMS CN_Concentration
	elseif (ccn_use_this_cpc == 1) // use WCPC
		duplicate/o cn_water CN_Concentration
	elseif (ccn_use_this_cpc == 2) // use UFCN
		duplicate/o cn_ultrafine CN_Concentration
	elseif (ccn_use_this_cpc == 3) // use CN_water
		duplicate/o cn_water CN_Concentration
	elseif (ccn_use_this_cpc == 4) // use CN_water
		duplicate/o cn_ccn_mono CN_Concentration
	else
		print "unknown cpc to use!"
		Abort "unkown cpc type!"
	endif
	killwaves/Z cn_water, cn_ultrafine	



End

Function/S ccn_goto_ccn_folder()
	
	string sdf = getdatafolder(1)
	setdatafolder root:
	newdatafolder/o/s $ccn_data_folder
	
	return sdf
End

Function/s ccn_goto_local_config()
	
	string sdf = ccn_goto_ccn_folder()
	newdatafolder/o/s local_config
	
	return sdf
End

Function ccn_init_local_config(force)
	variable force // 0=false, 1=true
	
	string sdf = ccn_goto_local_config()
	
	// Sample Types
	if (!datafolderexists("sample_types") || force)
		newdatafolder/o/s :sample_types
		string/G sample_type_list = ""
		string/G tag_map = ""
		
		// Base types that all datasets will have
		ccn_update_sample_type("BAD")	
		ccn_update_sample_type("NORMAL")	
	endif
	
	setdatafolder sdf
End

//Function ccn_add_sample_type(name, [tags])
//	string name // sample type name
//	string tags   // tags to differentiate states within a sample type 
//	
//	
//	string sdf = ccn_goto_local_config()
//	setdatafolder :sample_types
//	SVAR list = sample_type_list
//	
//		
//	
//End

Function ccn_update_sample_type(name,[tags])
	string name
	string tags
	
	string sdf = ccn_goto_local_config()
	setdatafolder :sample_types
	
	SVAR samp_types = sample_type_list

	if (ParamIsDefault(tags))
		tags = ""
	endif
	
	variable i
	string tag_list =""
	for (i=0; i<itemsinlist(tags); i+=1)
		//string t = stringfromlist(i,tags)
		tag_list += (stringfromlist(i,tags)+"$")
	endfor
	
	samp_types = ReplaceStringByKey(name,samp_types, tag_list,"=" )
	
	setdatafolder sdf
	
End

Function ccn_sample_type_exists(name)
	string name
	
	string sdf = ccn_goto_local_config()
	setdatafolder :sample_types
	SVAR list = sample_type_list
	
	
End

// sample_type_entry : {<name=(<tag name>$<tag_name)}
// tag_entry : {<tag_name>=(<name%suffix>$<name%suffix>)}

// Define the tag with subtypes and suffixes for filenames
Function/S ccn_update_tag_map_(name,subtype_entry_list)
	string name
	string subtype_entry_list
	
	string sdf = ccn_goto_local_config()
	setdatafolder :sample_types
	SVAR tags = tag_map
		
	tags = ReplaceStringByKey(name,tags, subtype_entry_list,"=" )
	
	setdatafolder sdf
End

Function/S ccn_get_name_from_sample_type_(sample_type_entry)
	string sample_type_entry
	
End


// *** 27 Feb 2018 : added variable/switch to allow use of single "system" for both mono and spectra
//	decision was made to use mono for everything. To enable this feature, set 
//		allow_mono_as_input = 1
//	otherwise set it to 0
// *** 
Function load_ccn_data(file_format, sys_type)
	string file_format
	variable sys_type
	string sdf = getdatafolder(1)
	
	// ** added 27 Feb 2018 (see description above)
	variable allow_mono_as_input = 1
	
	newdatafolder/o $ccn_data_folder            // create main ccn data folder
	
	ccn_init_local_config(0)

	if (datafolderexists(ccn_tmp_data_folder))
		killdatafolder/Z $ccn_tmp_data_folder
	endif
	newdatafolder/o/s $ccn_tmp_data_folder  // create temporary data folder

	variable/G ccn_system_type = sys_type

	newdatafolder/o/s :ccn  //create tmp ccn folder
	print "Starting on CCN data:"
	print "	loading..."
	if (cmpstr(file_format,ccn_dataselector_format) == 0)
		load_data_selector_format()
	elseif (cmpstr(file_format,ccn_dataselector_format_2) == 0)
		load_data_selector_format_v2()
		ccn_rename_waves()
	elseif (cmpstr(file_format,ccn_instrument_format) == 0)
		load_ccn_instrument_format()
	elseif (cmpstr(file_format,ccn_dchart_itx_format) == 0)
		load_data_dchart_itx_format()
		ccn_rename_itx_waves(sys_type,allow_mono_as_input)
	endif
	
	// Temporary(?) fix for missing ProportionalValveVolts in native file:
	killwaves/Z PropprtionalValveVolts
	killwaves/Z root:PropprtionalValveVolts
	// end temp fix	
	
	
	if (sys_type == 2) // ccn mono
		ccn_match_tubing_delay((ccn_tmp_data_folder+":ccn"))
	endif
	
	NaNPoints_TempStable((ccn_tmp_data_folder+":ccn"))
	NaNPoints_Overshoot2((ccn_tmp_data_folder+":ccn"))
	setdatafolder $ccn_tmp_data_folder

	if (cmpstr(file_format,ccn_dchart_itx_format) != 0) // no need if itx files
		// Load and correct CN data
		newdatafolder/o/s :cn
		print "Starting on CN data:"
		print "	loading..."
		//load_data_selector_format()
		if (cmpstr(file_format,ccn_dataselector_format) == 0)
			load_data_selector_format()
		elseif (cmpstr(file_format,ccn_dataselector_format_2) == 0)
			load_data_selector_format_v2()
			if (waveexists(DateTimeW))
				Rename DateTimeW $("Start_DateTime")
			endif
		endif
	
		// copy user selected CN data to CN_Concentration
		if (ccn_use_this_cpc == 0) // use CN_AMS
			duplicate/o CN_AMS CN_Concentration
		elseif (ccn_use_this_cpc == 1) // use WCPC
			duplicate/o WCPC CN_Concentration
		elseif (ccn_use_this_cpc == 2) // use UFCN
			duplicate/o UFCN CN_Concentration
		elseif (ccn_use_this_cpc == 3) // use CN_water
			duplicate/o CN_water CN_Concentration
		elseif (ccn_use_this_cpc == 4) // use CN_water
			duplicate/o cn_ccn_mono CN_Concentration			
		else
			print "unknown cpc to use!"
			Abort "unkown cpc type!"
		endif
		killwaves/Z CN_AMS, WCPC	

	endif 

	correct_cn_data((ccn_tmp_data_folder+":cn"))
	setdatafolder $ccn_tmp_data_folder
	

	if (sys_type == 2 || sys_type == 1) // ccn mono

		if (cmpstr(file_format,ccn_dchart_itx_format) != 0) // no need if itx files
			// Load and correct mono data
			newdatafolder/o/s :mono
			print "Starting on mono data:"
			print "	loading..."
			//load_data_selector_format()
			if (cmpstr(file_format,ccn_dataselector_format) == 0)
				load_data_selector_format()
			elseif (cmpstr(file_format,ccn_dataselector_format_2) == 0)
				load_data_selector_format_v2()
				if (waveexists(DateTimeW))
					Rename DateTimeW $("Start_DateTime")
				endif
			endif
		else
			setdatafolder :mono
		endif
		
		// Changing names of mono waves for clarity (hopefully)
//		duplicate/o CCN_mono_cn_concentration CN_Concentration_mono
		//duplicate/o CCN_mono_ccn_cn_ratio mono_ccn_cn_ratio
		duplicate/o CCN_mono_cn_concentration mono_cn_conc
		duplicate/o CCN_mono_cn_concentration mono_ccn_cn_ratio
		wave ratio = mono_ccn_cn_ratio
		//wave conc = mono_cn_conc
		//wave cn = ::cn:CN_Concentration
		
		wave conc = ::ccn:CCN_Concentration
		wave cn = mono_cn_conc
		
		ratio = conc/cn
		ratio = (ratio[p] > 5) ? NaN : ratio[p]
		//ratio = (cn[p] < 10) ? NaN : ratio[p]
		//ratio = (ccn[p] < 1) ? NaN : ratio[p]

		//duplicate/o CCN_mono_cycle_state mono_cycle_state
		//duplicate/o CCN_mono_delta_time mono_delta_time
		//duplicate/o CCN_mono_smps_dp mono_smps_dp
		//duplicate/o CCN_mono_smps_voltage mono_smps_voltage

		// create mask and nan waves
		duplicate/o CCN_mono_cn_concentration mono_avg_mask, ccn_user_nan
		wave mask = mono_avg_mask
		mask = 0 // value is 0 (do not include) or 1 (include in avg)
		
		wave user_nan = ccn_user_nan
		user_nan = 1 // value is 1 (keep points) or NaN (remove points)
		
		killwaves/Z CCN_mono_cn_concentration, CCN_mono_ccn_cn_ratio, CCN_mono_cycle_state
		killwaves/Z CCN_mono_delta_time, CCN_mono_delta_time, CCN_mono_smps_dp, CCN_mono_smps_voltage

		//correct_cn_data((ccn_tmp_data_folder+":cn"))	
		ccn_NaNPoints_mono((ccn_tmp_data_folder+":mono")) // uncommented these 3 lines 22Aug2012
		//ccn_avg_mono((ccn_tmp_data_folder+":mono"))  // ***
		//ccn_adjust_dp_mono((ccn_tmp_data_folder+":mono")) 
		setdatafolder $ccn_tmp_data_folder
	endif

	// "Converting new data to constant time base and averaging into " + num2str(ccn_avg_period) + " sec periods"
	ccn_same_timebase_tmp()
	
	// "Adding new data to main data"
	ccn_combine_data_from_tmp()
	
	// calculate ratio
	ratio_ccn_to_cn()
	
	// sync shift waves and sample types
	ccn_sync_other_waves()
	
	// remove tmp folders and waves
	ccn_clean_up()
	
	print "Done."
	setdatafolder sdf	
End

Function ccn_clean_up()
	print "Cleaning up..."
	killdatafolder/Z $ccn_tmp_data_folder
	killwaves/Z root:ccn:main_wave_list
End

Function ccn_match_tubing_delay(dfolder)
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		adjusting time to match tubing delays..."

	wave ccn_dt = Start_DateTime
	// shift ccn datetime to match that of the cn
	ccn_dt -= (ccn_mono_tubing_delay - ccn_cn_tubing_delay)
	 
	setdatafolder sdf 
End

Function  NaNPoints_TempStable(dfolder)  // Sets non Tstabilized points to NaN
//removes points for TStab = 0
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		removing data when T was unstable..."
	
	wave tstab = TempStable
	duplicate/o CCN_Concentration CCN_Concentration_TStable
	wave conc = CCN_Concentration
	wave conc_tstab = CCN_Concentration_TStable
	
	// removed for icealot - 26Mar2008
	//conc_tstab = (tstab[p] == 0) ? NaN : conc[p]
		
	setdatafolder sdf 
End

Function ccn_is_nominal_SS(ss_val)
	variable ss_val
	
	variable k
	for (k=0; k<itemsinlist(ccn_nom_ss_levels); k+=1)
		//nom_ss_val = str2num(stringfromlist(k,ccn_nom_ss_levels))
		//if (ss_val == str2num(stringfromlist(k,ccn_nom_ss_levels)) )
		if ((whichlistitem(num2str(ss_val),ccn_nom_ss_levels)) >= 0)
			//nom_ss=1
			return 1
		endif
	endfor
	return 0
End

Function ccn_NaNPoints_mono(dfolder)
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		removing data during mono dp change & overshoot periods..."
	//variable ccn_overshoot_sec = floor(overshoot_min*60)

	wave ccn_time = Start_DateTime
	duplicate/o mono_ccn_cn_ratio mono_ccn_cn_ratio_Clean
	wave ccn_ratio = mono_ccn_cn_ratio_Clean
	duplicate/o mono_cn_conc mono_cn_conc_Clean
	wave ccn_cn = mono_cn_conc_Clean
	duplicate/o ccn_cn mono_ccn_conc_Clean
	wave ccn_clean = mono_ccn_conc_Clean
	wave flag = mono_cycle_state
	
	variable i
	for (i=0; i<numpnts(flag); i+=1)
		if (flag[i] != 3) // nan point
			ccn_ratio[i] = NaN
			ccn_cn[i] = NaN
		endif
	endfor
	
	ccn_clean = ccn_ratio*ccn_cn
End

Function ccn_avg_mono_all()

	ccn_avg_mono(ccn_data_folder)
	ccn_avg_over_dp_at_ss(ccn_data_folder)

End

// This function is only to be run once to "upgrade" the main data to use
//	the adjusted dp values. It must be run before any more data is added
Function ccn_adjust_dp_mono_upgrade()
	if (!waveexists($(ccn_data_folder+":mono_smps_dp_raw")))
		ccn_adjust_dp_mono(ccn_data_folder)
	endif
End

Function ccn_adjust_dp_mono(dfolder)
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		adjust mono dp to nominal values..."
	//variable ccn_overshoot_sec = floor(overshoot_min*60)

//	wave ccn_time = Start_DateTime
	duplicate/o mono_smps_dp mono_smps_dp_raw
	wave dp = mono_smps_dp
	wave dp_raw = mono_smps_dp_raw
	
	string prefix = ""
	if (cmpstr(dfolder, (ccn_tmp_data_folder+":mono")) == 0)
		prefix = "::ccn:"
	endif
	wave ss = $(prefix+"SS_setting")
	
	variable i
	for (i=0; i<numpnts(dp); i+=1)
		if (ss[i] != 1)
			dp[i] = round(dp_raw[i]/10)*10
		else
				if (dp_raw[i] == 22)
					dp[i] = 20
				elseif (dp_raw[i] == 27)
					dp[i] = 30
				elseif (dp_raw[i] == 32)
					dp[i] = 35
				elseif (dp_raw[i] == 38)
					dp[i] = 40
				elseif (dp_raw[i] == 43)
					dp[i] = 45
				endif
		endif
	endfor
				
	setdatafolder sdf 
End

	
Function ccn_avg_mono(dfolder)
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		avg mono sample periods..."
	//variable ccn_overshoot_sec = floor(overshoot_min*60)

//	wave ccn_time = Start_DateTime
	duplicate/o mono_ccn_cn_ratio_Clean mono_ccn_cn_ratio_avg
	wave ccn_ratio = mono_ccn_cn_ratio_avg
	duplicate/o mono_cn_conc_Clean mono_cn_conc_avg
	wave ccn_cn = mono_cn_conc_avg
	duplicate/o ccn_cn mono_ccn_conc_avg
	wave ccn_avg = mono_ccn_conc_avg
	
	wave flag = mono_cycle_state
	
	variable i
	variable in_period = 0
	variable starti, stopi
	starti = -1
	stopi = -1
	for (i=0; i<numpnts(flag); i+=1)
		
		if (flag[i] == 3)
			
			if (!in_period)
				starti = i
				in_period = 1
			else 
				if ( i == (numpnts(flag)-1) )
					stopi = i-1
					in_period = 0
			
					WaveStats/Q/R=[starti,stopi] ccn_ratio
					ccn_ratio[starti,stopi] = V_avg
	
					WaveStats/Q/R=[starti,stopi] ccn_cn
					ccn_cn[starti,stopi] = V_avg			
				endif
			endif
//		elseif (flag[i] != 3 || i == numpnts(flag)-1)
		elseif (flag[i] != 3)
			if (in_period)
				stopi = i-1
				in_period = 0
		
				WaveStats/Q/R=[starti,stopi] ccn_ratio
				ccn_ratio[starti,stopi] = V_avg

				WaveStats/Q/R=[starti,stopi] ccn_cn
				ccn_cn[starti,stopi] = V_avg

			endif
		endif
	endfor

	ccn_avg = ccn_ratio*ccn_cn
	setdatafolder sdf
	
End

Function ccn_avg_over_dp_at_ss(dfolder)
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		avg over each dp for a given SS..."
	//variable ccn_overshoot_sec = floor(overshoot_min*60)

//	wave ccn_time = Start_DateTime
	wave ccn_time = ccn_datetime
	wave dp = mono_smps_dp
	
	//duplicate/o mono_ccn_cn_ratio_Clean mono_ccn_cn_ratio_avg
	wave ccn_ratio = mono_ccn_cn_ratio_avg
	//duplicate/o CN_Conc_mono_Clean CN_Conc_mono_avg
	wave ccn_cn = mono_cn_conc_avg
	//duplicate/o ccn_cn CCN_Conc_mono_avg
	//wave ccn_avg = CCN_Conc_mono_avg
	
	wave  ss = SS_setting
	wave flag = mono_cycle_state

	variable i
	variable ss_cnt=0
	variable current_ss = 0	

	// find number of ss periods
	for (i=0; i<numpnts(ss); i+=1)
		//print ss[i], current_ss
		if (ccn_is_nominal_SS(ss[i]) && ss[i] != current_ss)
			ss_cnt+=1
			current_ss = ss[i]
		endif
	endfor	
	ss_cnt -= 1
	
//	make/o/d/n=(ss_cnt,ccn_dp_steps) mono_ccn_cn_rat_avg_dp
	make/o/d/n=(ss_cnt,ccn_dp_steps) mono_ccn_cn_ratio_avg_m
	wave ratio_m = mono_ccn_cn_ratio_avg_m
	ratio_m = NaN
	
	duplicate/o ratio_m mono_datetime_avg_m
	wave dt_m = mono_datetime_avg_m
		
	duplicate/o ratio_m mono_smps_dp_avg_m
	wave dp_m = mono_smps_dp_avg_m

	// make ss wave for the matrices
	make/o/n=(ss_cnt) mono_ss_avg
	wave ss_avg_dp = mono_ss_avg
 	
	variable ss_index = 0
	current_ss = 0
	variable ss_starti = 0
	variable ss_stopi = 0
	for (i=0; i<numpnts(ss); i+=1)
		//print ss[i], current_ss
		if (ccn_is_nominal_SS(ss[i]) && ss[i] != current_ss)

			if (ss_starti == 0 && ss_stopi == 0) // first time
				current_ss = ss[i]
				ss_starti = i
			else
	
				ss_avg_dp[ss_index] = current_ss
				
				duplicate/o/R=[ss_starti, ss_stopi] ccn_ratio tmp_ccn_ratio
				wave tmp_rat = tmp_ccn_ratio
				duplicate/o/R=[ss_starti, ss_stopi] ccn_time tmp_ccn_time
				wave tmp_time = tmp_ccn_time
				duplicate/o/R=[ss_starti, ss_stopi] dp tmp_ccn_dp
				wave tmp_dp = tmp_ccn_dp

	

				duplicate/o/R=[ss_starti, ss_stopi] flag tmp_cycle_state
				wave tmp_flag = tmp_cycle_state
				
				variable j
				variable in_period = 0
				variable starti, stopi
				variable dp_index=0
				starti = -1
				stopi = -1
				for (j=0; j<numpnts(tmp_flag); j+=1)
					
					//print j, numpnts(tmp_flag), numpnts(tmp_flag)-1, (j==(numpnts(tmp_flag)-1))
					if (tmp_flag[j] == 3)
						
						if (!in_period)
							starti = j
							in_period = 1
						else 

							if ( j == (numpnts(tmp_flag)-1) ) 
									stopi = j-1
									in_period = 0
							
									//dt_m[ss_index][dp_index] = tmp_time[starti]
									WaveStats/Q/R=[starti,stopi] tmp_time
									dt_m[ss_index][dp_index] = V_avg
		
									WaveStats/Q/R=[starti,stopi] tmp_dp
									dp_m[ss_index][dp_index] = V_avg
		
									WaveStats/Q/R=[starti,stopi] tmp_rat
									ratio_m[ss_index][dp_index] = V_avg
		
									//WaveStats/Q/R=[starti,stopi] ccn_cn
									//ccn_cn[starti,stopi] = V_avg
									
									dp_index += 1
							endif
						
						endif
						
					//elseif ( (tmp_flag[j] != 3) || ( j == (numpnts(tmp_flag)-1)) )
					elseif ( (tmp_flag[j] != 3) )
						if (in_period)
							stopi = j-1
							in_period = 0
					
							WaveStats/Q/R=[starti,stopi] tmp_time
							//dt_m[ss_index][dp_index] = tmp_time[starti]
							dt_m[ss_index][dp_index] = V_avg

							WaveStats/Q/R=[starti,stopi] tmp_dp
							dp_m[ss_index][dp_index] = V_avg

							WaveStats/Q/R=[starti,stopi] tmp_rat
							ratio_m[ss_index][dp_index] = V_avg

							//WaveStats/Q/R=[starti,stopi] ccn_cn
							//ccn_cn[starti,stopi] = V_avg
							
							dp_index += 1
						endif
					endif
				endfor
				ss_index += 1

				
				// start over
				current_ss = ss[i]
				ss_starti = i
			
				killwaves/Z tmp_rat, tmp_time, tmp_dp, tmp_flag
			endif
		else
			ss_stopi = i
		endif

	endfor	

//	// create avg mask
//	variable has_old_avg = 0
//	wave w = mono_avg_mask
//	if (waveexists(w))
//		has_old_avg = 1
//		duplicate/o w mono_avg_mask_old
//		wave avg_mask_old = mono_avg_mask_old
//		wave ww = mono_avg_plot_datetime
//		duplicate/o ww mono_avg_plot_datetime_old
//		wave dt_old = mono_avg_plot_datetime_old
//	endif
//	make/o/n=(dimsize(ratio_m,0) * dimsize(ratio_m,1)) mono_avg_mask
//	wave avg_mask = mono_avg_mask	
//	avg_mask = 0
	
	// create time vs ratio waves for plot
//	make/o/d/n=(dimsize(ratio_m,0) * dimsize(ratio_m,1)) mono_ratio_v_dt_datetime
//	wave plot_dt = mono_ratio_v_dt_datetime	
//	make/o/d/n=(dimsize(ratio_m,0) * dimsize(ratio_m,1)) mono_ratio_v_dt_ratio
//	wave plot_ratio = mono_ratio_v_dt_ratio	
	make/o/d/n=(dimsize(ratio_m,0) * dimsize(ratio_m,1)) mono_avg_plot_datetime
	wave plot_dt = mono_avg_plot_datetime	
	make/o/d/n=(dimsize(ratio_m,0) * dimsize(ratio_m,1)) mono_avg_plot_ratio
	wave plot_ratio = mono_avg_plot_ratio	


	variable cnt = 0
	for (i=0; i<dimsize(ratio_m,0); i+=1)
		for (j=0; j<dimsize(ratio_m,1); j+=1)
			plot_dt[cnt] = dt_m[i][j]
			plot_ratio[cnt] = ratio_m[i][j]
			cnt+=1
		endfor
	endfor

//	if (waveexists(mono_avg_mask_old))
//		wave old_mask = mono_avg_mask_old
//		wave old_time = mono_avg_plot_datetime_old
//		
//		wave new_time = mono_avg_plot_datetime
//		
//		// account for old_time containing nans
//		variable old_firsti=-1
//		for (i=0; i<numpnts(old_time); i+=1)
//			if (numtype(old_time[i]) == 0)
//				old_firsti = i
//				break;
//			endif
//		endfor
//		
//		if (old_firsti >= 0) 					
//			variable firsti = ccn_BSI_search_with_NaNs(new_time, old_time[old_firsti]) 
//			print "first i: ", firsti
//			variable ii
//			for (ii=old_firsti; ii<numpnts(old_mask); ii+=1)
//				new_time[firsti+ii] = old_time[ii]
//				avg_mask[firsti+ii] = old_mask[ii]
//			endfor
//		endif
//				
//		killwaves/Z  old_mask, old_time
//	endif

//	variable i
//	variable in_period = 0
//	variable starti, stopi
//	starti = -1
//	stopi = -1
//	for (i=0; i<numpnts(flag); i+=1)
//		
//		if (flag[i] == 3)
//			
//			if (!in_period)
//				starti = i
//				in_period = 1
//			endif
//		elseif (flag[i] != 3 || i == numpnts(flag)-1)
//			if (in_period)
//				stopi = i-1
//				in_period = 0
//		
//				WaveStats/Q/R=[starti,stopi] ccn_ratio
//				ccn_ratio[starti,stopi] = V_avg
//
//				WaveStats/Q/R=[starti,stopi] ccn_cn
//				ccn_cn[starti,stopi] = V_avg
//
//			endif
//		endif
//	endfor
//
//	ccn_avg = ccn_ratio*ccn_cn
	setdatafolder sdf
	
End

//Function ccn_find_ratio_

Function/S ccn_find_all_dp(dp)
	wave dp
	
	string list = ""
	variable i,j,d
	for (i=0; i<dimsize(dp,0); i+=1)
		for (j=0; j<dimsize(dp,1); j+=1)
			d = dp[i][j]
			if ( numtype(d) == 0 && WhichListItem(num2str(d), list) == -1 ) // add to list
				if (strlen(list) > 0)
					list += ";"
				endif
				list += num2str(d);
			endif
		endfor
	endfor
	return SortList(list,";",2)
	//return list
End

Function ccn_find_avg_at_ss_dp(ss,dp,avg_mat)
	variable ss
	variable dp
	wave avg_mat
	
	string sdf = getdatafolder(1)
	setdatafolder ccn_data_folder

	wave ss_avg_dp = mono_ss_avg
	wave dp_m= mono_smps_dp_avg_m

	variable i,j

//	for (i=0; i<numpnts(ss_avg_dp); i+=1)
//		print ss, ss_avg_dp[i], (ss==ss_avg_dp[i])
//	endfor

	variable total = 0
	variable cnt = 0 	
	//print ss, dp
	for (i=0; i<dimsize(avg_mat,0); i+=1)
		for (j=0; j<dimsize(avg_mat,1); j+=1)
			//print ss, dp, " --- ", ss_avg_dp[i], dp_m[i][j], " -- ",  avg_mat[i][j], " :: ", (ss/ss_avg_dp[i])
						
			//if ( ss==ss_avg_dp[i] && dp==dp_m[i][j] )
				if (ss==ss_avg_dp[i])
					//print "ss worked"
					//print dp,dp_m[i][j], (dp==dp_m[i][j]), (dp/dp_m[i][j]
					if (dp==dp_m[i][j])
						//print "dp worked"
						if (numtype(avg_mat[i][j])==0)
							total += avg_mat[i][j]
							cnt += 1
						endif
						//print ss, dp, total, cnt, total/cnt
					endif
				endif
			//endif
		endfor
	endfor
	setdatafolder sdf

	return total/cnt	

End

Function ccn_mono_avg_dp_from_mask()
	string sdf = getdatafolder(1)
	setdatafolder ccn_data_folder
	
	wave ccn_dt= ccn_datetime
	wave ccn_avg_mask = mono_avg_mask

	wave avg_dt= mono_avg_plot_datetime	
	wave avg_rat = mono_avg_plot_ratio

	// create avg_mask on avg timebase
	duplicate/o avg_rat tmp_avg_mask
	wave avg_mask = tmp_avg_mask
	avg_mask = 0;
	
	variable i
	for (i=0; i<numpnts(avg_dt); i+=1)
		if (numtype(avg_dt[i])==0)
			variable sti = round(BinarySearchInterp(ccn_dt, avg_dt[i]))
			if (ccn_avg_mask[sti-1] && ccn_avg_mask[sti] && ccn_avg_mask[sti+1]) 
				avg_mask[i] = 1
			endif
		endif
	endfor
	
	// matrix waves
	wave rat_m= mono_ccn_cn_ratio_avg_m
	wave dp_m= mono_smps_dp_avg_m
	
	// mask data wave 
	duplicate/o rat_m tmp_data_m
	wave rat_m_tmp = tmp_data_m
	
	variable mask_index=0
	variable j
	for (i=0; i<dimsize(rat_m,0); i+=1)
		for (j=0; j<dimsize(rat_m,1); j+=1)
			if (avg_mask[mask_index] == 1)
				rat_m_tmp[i][j] = rat_m[i][j]
			else	
				rat_m_tmp[i][j] =NaN
			endif
			mask_index += 1
		endfor
	endfor
	
	string ss_list = ccn_nom_ss_levels

	// find all dp possible
	string dp_list = ccn_find_all_dp(dp_m)
	print dp_list
	print itemsinlist(dp_list)
	
//	make/o/n=(itemsinlist(ss_list),itemsinlist(dp_list)) mono_avg_rat_dp_over_ss	
//	wave avg_rat = mono_avg_rat_dp_over_ss
//	make/o/n=(itemsinlist(ss_list)) mono_avg_ss
//	wave avg_ss = mono_avg_ss
	make/o/n=(itemsinlist(ss_list),itemsinlist(dp_list)) mono_ratio_from_avg_mask
	wave avg_rat = mono_ratio_from_avg_mask
	make/o/n=(itemsinlist(ss_list)) mono_ss_from_avg_mask
	wave avg_ss = mono_ss_from_avg_mask

	make/o/n=(itemsinlist(dp_list)) mono_dp_from_avg_mask
	wave avg_dp = mono_dp_from_avg_mask



	for (i=0; i<dimsize(avg_rat,0); i+=1)
		variable ss = str2num(stringfromlist(i,ss_list))
		avg_ss[i] = round(ss*10)/10
		for (j=0; j<dimsize(avg_rat,1); j+=1)
			variable dp = 	str2num(stringfromlist(j,dp_list))
			if (i==0)
				avg_dp[j] = dp
			endif
			avg_rat[i][j] = ccn_find_avg_at_ss_dp(avg_ss[i],dp,rat_m_tmp)
			//print i, j, ss, dp, avg_rat[i][j]
		endfor
	endfor
	
	killwaves/Z tmp_avg_mask
	setdatafolder sdf
End

Function ccn_BSI_search_with_NaNs(dat, val)
	wave dat
	variable val
	
	duplicate/o dat dat_tmp, index
	index[0] = 0
	index[1,] = index[p-1] + 1
	
	variable i=0, count = numpnts(dat_tmp)
	for (i=0; i<numpnts(dat_tmp); i+=1)
	do 
		if (numtype(dat_tmp[i]) != 0)
			DeletePoints i, 1, index, dat_tmp
		else
			i+=1
		endif
	while (i < count)
	endfor
	
	if (numpnts(dat_tmp) == 0) 
		return -1
	endif
	
	variable idx = round(BinarySearchInterp(dat_tmp,val))
	variable ret = index[idx]
	killwaves/Z dat_tmp, index

	return ret
end
	

Function ccn_add_sel_to_avg_from_marq()

	string sdf = getdatafolder(1)
	setdatafolder ccn_data_folder
	GetMarquee/K/Z bottom
	//GetWindow $S_marqueeWin wavelist
	//wave/T wlist = W_WaveList
	//print wlist
	
	wave avg_mask = mono_avg_mask
//	wave avg_dt= mono_avg_plot_datetime
	wave avg_dt= ccn_datetime
	print BinarySearchInterp(avg_dt,V_left)
	print BinarySearchInterp(avg_dt,V_right)
	//print ccn_BSI_search_with_NaNs(avg_dt,V_left)
	//print ccn_BSI_search_with_NaNs(avg_dt,V_right)
	
	variable starti = round(BinarySearchInterp(avg_dt,V_left))
	variable stopi = round(BinarySearchInterp(avg_dt,V_right))
	//variable starti = ccn_BSI_search_with_NaNs(avg_dt,V_left)
	//variable stopi = ccn_BSI_search_with_NaNs(avg_dt,V_right)

	
	avg_mask[starti,stopi] = 1
	
	ccn_mono_avg_dp_from_mask()
	
//	variable i,j
//	string batchname
//	
////	wave ion = $(wlist[0][1])  // ion wave
////	wave t = $(wlist[1][1])     // datetime wave
//
//	for (i=0; i<itemsinlist(wlist[2][1],":"); i+=1)
//		print i, stringfromlist(i,wlist[2][1],":")
//	endfor
//	batchname = stringfromlist(2,wlist[2][1],":")
//	batchname = replacestring("'",batchname,"",0,2)
//	string ion_name = stringfromlist(3,wlist[2][1],":")
//	print batchname
//	setdatafolder root:datasets:$batchname
//	//wave ion = $(wlist[0][1])  // ion wave
//	wave t = $(wlist[1][0])     // datetime wave
//	//wave user_nan = $("root:datasets:"+batchname+":"+ion_name+"_user_nan")
//	wave user_nan = $(ion_name+"_user_nan")
//	
//	variable starti, stopi
//	FindValue/T=(sample_duration*60/2)/V=(V_left) t
//	starti = V_value>-1 ? V_value : 0
//	FindValue/T=(sample_duration*60/2)/V=(V_right) t
//	stopi = V_value>-1 ? V_value : numpnts(t)-1
//	print starti, stopi		
//	
//	user_nan[starti,stopi] = 1
//
//	pils_apply_user_nan(batchname,0)
//
//	setdatafolder sdf		
////	setdatafolder dfolder
//	
////	wave d = $(dpname[0,idx-1])    // diameter wave
////	
////	// get datafolder for avg plot data
////	dfolder = getwavesdatafolder($wlist[i][1],1)
////	string sdf = getdatafolder(1)
////	setdatafolder dfolder
////
////	// for now...all average data in one folder
////	variable starti, stopi
////	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
////	starti = V_value>-1 ? V_value : 0
////	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
////	stopi = V_value>-1 ? V_value : numpnts(t)-1
////	print starti, stopi		
////
////	wave user_nan = smps_user_nan
////	user_nan[starti,stopi] = 1
////	
////	variable tb
////	variable levels = itemsinlist(dfolder,":")
////	string datafolder = stringfromlist(levels-1,dfolder,":")
////	sscanf datafolder,"data_%dsec",tb
////
////	smps_clean_user_times(tb)
////	//wsoc_process_data()	
////	smps_reprocess_data(tb)
	
	setdatafolder sdf
End

Function ccn_rem_sel_from_avg_from_marq()

	string sdf = getdatafolder(1)
	setdatafolder ccn_data_folder
	GetMarquee/K/Z bottom
	//GetWindow $S_marqueeWin wavelist
	//wave/T wlist = W_WaveList
	//print wlist
	
	wave avg_mask = mono_avg_mask
//	wave avg_dt= mono_avg_plot_datetime
	wave avg_dt= ccn_datetime
	print BinarySearchInterp(avg_dt,V_left)
	print BinarySearchInterp(avg_dt,V_right)
//	print ccn_BSI_search_with_NaNs(avg_dt,V_left)
//	print ccn_BSI_search_with_NaNs(avg_dt,V_right)
	
	variable starti = round(BinarySearchInterp(avg_dt,V_left))
	variable stopi = round(BinarySearchInterp(avg_dt,V_right))
//	variable starti = ccn_BSI_search_with_NaNs(avg_dt,V_left)
//	variable stopi = ccn_BSI_search_with_NaNs(avg_dt,V_right)
	
	avg_mask[starti,stopi] = 0

	ccn_mono_avg_dp_from_mask()


//	variable i,j
//	string batchname
//	
////	wave ion = $(wlist[0][1])  // ion wave
////	wave t = $(wlist[1][1])     // datetime wave
//
//	for (i=0; i<itemsinlist(wlist[2][1],":"); i+=1)
//		print i, stringfromlist(i,wlist[2][1],":")
//	endfor
//	batchname = stringfromlist(2,wlist[2][1],":")
//	batchname = replacestring("'",batchname,"",0,2)
//	string ion_name = stringfromlist(3,wlist[2][1],":")
//	print batchname
//	setdatafolder root:datasets:$batchname
//	//wave ion = $(wlist[0][1])  // ion wave
//	wave t = $(wlist[1][0])     // datetime wave
//	//wave user_nan = $("root:datasets:"+batchname+":"+ion_name+"_user_nan")
//	wave user_nan = $(ion_name+"_user_nan")
//	
//	variable starti, stopi
//	FindValue/T=(sample_duration*60/2)/V=(V_left) t
//	starti = V_value>-1 ? V_value : 0
//	FindValue/T=(sample_duration*60/2)/V=(V_right) t
//	stopi = V_value>-1 ? V_value : numpnts(t)-1
//	print starti, stopi		
//	
//	user_nan[starti,stopi] = 1
//
//	pils_apply_user_nan(batchname,0)
//
//	setdatafolder sdf		
////	setdatafolder dfolder
//	
////	wave d = $(dpname[0,idx-1])    // diameter wave
////	
////	// get datafolder for avg plot data
////	dfolder = getwavesdatafolder($wlist[i][1],1)
////	string sdf = getdatafolder(1)
////	setdatafolder dfolder
////
////	// for now...all average data in one folder
////	variable starti, stopi
////	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
////	starti = V_value>-1 ? V_value : 0
////	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
////	stopi = V_value>-1 ? V_value : numpnts(t)-1
////	print starti, stopi		
////
////	wave user_nan = smps_user_nan
////	user_nan[starti,stopi] = 1
////	
////	variable tb
////	variable levels = itemsinlist(dfolder,":")
////	string datafolder = stringfromlist(levels-1,dfolder,":")
////	sscanf datafolder,"data_%dsec",tb
////
////	smps_clean_user_times(tb)
////	//wsoc_process_data()	
////	smps_reprocess_data(tb)
////	setdatafolder sdf
End


//Function ccn_reset_sel_from_marquee()
//
//	string sdf = getdatafolder(1)
//	setdatafolder root:
//	GetMarquee/K/Z left, bottom
//	GetWindow $S_marqueeWin wavelist
//	wave/T wlist = W_WaveList
//	print wlist
//	
//	variable i,j
//	string batchname
//	
////	wave ion = $(wlist[0][1])  // ion wave
////	wave t = $(wlist[1][1])     // datetime wave
//
//	for (i=0; i<itemsinlist(wlist[2][1],":"); i+=1)
//		print i, stringfromlist(i,wlist[2][1],":")
//	endfor
//	batchname = stringfromlist(2,wlist[2][1],":")
//	batchname = replacestring("'",batchname,"",0,2)
//	string ion_name = stringfromlist(3,wlist[2][1],":")
//	print batchname
//	setdatafolder root:datasets:$batchname
//	//wave ion = $(wlist[0][1])  // ion wave
//	wave t = $(wlist[1][0])     // datetime wave
//	//wave user_nan = $("root:datasets:"+batchname+":"+ion_name+"_user_nan")
//	wave user_nan = $(ion_name+"_user_nan")
//	
//	variable starti, stopi
//	FindValue/T=(sample_duration*60/2)/V=(V_left) t
//	starti = V_value>-1 ? V_value : 0
//	FindValue/T=(sample_duration*60/2)/V=(V_right) t
//	stopi = V_value>-1 ? V_value : numpnts(t)-1
//	print starti, stopi		
//	
//	user_nan[starti,stopi] = 0
//	
//	pils_apply_user_nan(batchname,1)
//
//	setdatafolder sdf		
//	
////	variable i,j
////	string dfolder
////	
////	wave dw = $(wlist[0][1])  // dWdlogDp matrix
////	wave t = $(wlist[1][1])     // datetime wave
////	variable idx = strsearch(wlist[2][1],"_",Inf,1)
////	string dpname = wlist[2][1]
////	//print "dpname = " , dpname[0,idx-1]
////	wave d = $(dpname[0,idx-1])    // diameter wave
////	
////	// get datafolder for avg plot data
////	dfolder = getwavesdatafolder($wlist[i][1],1)
////	string sdf = getdatafolder(1)
////	setdatafolder dfolder
////
////	// for now...all average data in one folder
////	variable starti, stopi
////	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
////	starti = V_value>-1 ? V_value : 0
////	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
////	stopi = V_value>-1 ? V_value : numpnts(t)-1
////	print starti, stopi		
////
////	wave user_nan = smps_user_nan
////	user_nan[starti,stopi] = 0
////
////	variable tb
////	variable levels = itemsinlist(dfolder,":")
////	string datafolder = stringfromlist(levels-1,dfolder,":")
////	sscanf datafolder,"data_%dsec",tb
////
////	smps_clean_user_times(tb)
////	smps_reprocess_data(tb)
//	
////	setdatafolder sdf
//End

//Function ccn_mark_blank_from_marquee()
//
//	string sdf = getdatafolder(1)
//	setdatafolder root:
//	GetMarquee/K/Z left, bottom
//	GetWindow $S_marqueeWin wavelist
//	wave/T wlist = W_WaveList
//	print wlist
//	
//	variable i,j
//	string batchname
//	
//	batchname = stringfromlist(2,wlist[2][1],":")
//	batchname = replacestring("'",batchname,"",0,2)
//	setdatafolder root:datasets:$batchname
//	wave t = $(wlist[1][0])     // datetime wave
//	wave blank = batch_blanks
//	
//	variable starti, stopi
//	FindValue/T=(sample_duration*60/2)/V=(V_left) t
//	starti = V_value>-1 ? V_value : 0
//	FindValue/T=(sample_duration*60/2)/V=(V_right) t
//	stopi = V_value>-1 ? V_value : numpnts(t)-1
//	print starti, stopi		
//	
//	blank[starti,stopi] = 1
//	
//	//pils_apply_user_nan()
//
//	setdatafolder sdf		
//End
//



Function  NaNPoints_Overshoot2(dfolder)  // sets all data from Tstab conc within the first <overshoot_min> minutes to NaN
// Must run NaNPoints_TStab() first (or at least once before)
	string dfolder
	// optional: uncomment the next line to force an initial call to NaNPoints_TStab()
	//NaNPoints_TStab()
	
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		removing data during T overshoot periods..."
	//variable ccn_overshoot_sec = floor(overshoot_min*60)
	

	wave ccn_time = Start_DateTime
	wave ccn_ss = SS_setting
	duplicate/o CCN_Concentration_TStable CCN_Concentration_Cleaned
	wave conc_tstab = CCN_Concentration_TStable
	wave conc_clean = CCN_Concentration_Cleaned
	
	variable i
	variable curr_ss
	
	variable ccn_big_overshoot_flag = 0
	
	variable overshoot_sec = ccn_overshoot_sec
	
	curr_ss = ccn_ss[0]
	conc_clean[0] = NaN
//	variable cnt = 1  // changed to allow for other than 1sec data - ICEALOT (3/22/2008)
	variable cnt = ccn_defaultTimeBase
	for (i=1; i<numpnts(conc_tstab); i+=1)
	
		//print ccn_ss[i], curr_ss
		if ( (numtype(ccn_ss[i]) == 0) && (ccn_ss[i] != curr_ss) ) // start over

			if ( (curr_ss == ccn_overshoot_ss_from) )
				overshoot_sec = ccn_overshoot_sec_big
				ccn_big_overshoot_flag = 1
			endif

			if (!ccn_big_overshoot_flag)
				overshoot_sec = ccn_overshoot_sec
			endif	
					
//			if (ccn_big_overshoot_flag)
//			
//				if (ccn_is_nominal_ss(curr_ss) || ccn_is_nominal_ss(ccn_ss[i]) )
//					// overshoot_sec = overshoot_sec  // no change
//				else
//					overshoot_sec = ccn_overshoot_sec
//				endif
//			endif
		
//			//ccn_nom_ss_levels
//			variable nom_ss = 0
//			variable nom_ss_val
//			variable k
//			for (k=0; k<itemsinlist(ccn_nom_ss_levels); k+=1)
//				nom_ss_val = str2num(stringfromlist(k,ccn_nom_ss_levels))
//				if (ccn_ss[i] == str2num(stringfromlist(k,ccn_nom_ss_levels)) )
//					nom_ss=1
//				endif
//				print nom_ss, nom_ss_val, ccn_ss[i]
//			endfor
//			
//			//if ( (curr_ss == ccn_overshoot_ss_from) && (ccn_ss[i] == ccn_overshoot_ss_to) )
//			if (nom_ss)
//				if ( (curr_ss == ccn_overshoot_ss_from)  )  // hardcoded for ICEALOT
//					overshoot_sec = ccn_overshoot_sec_big
//				else
//					overshoot_sec = ccn_overshoot_sec
//				endif
//			endif

			
			curr_ss = ccn_ss[i]
			conc_clean[i] = NaN
			//cnt=1 changed to allow for other than 1sec data - ICEALOT (3/22/2008)
			cnt=ccn_defaultTimeBase
		
		else
		
			//if (cnt <= ccn_overshoot_sec) 
			if (cnt <= overshoot_sec) 
				conc_clean[i] = NaN
				//cnt += 1
				cnt += ccn_defaultTimeBase // changed to allow for other than 1sec data - ICEALOT (3/22/2008)
			else
				conc_clean[i] = conc_tstab[i]
				ccn_big_overshoot_flag = 0
			endif
			
		endif		
			
	endfor 
	
	setdatafolder sdf 
End

Function correct_cn_data(dfolder)
	string dfolder	
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	print "		adjusting cn data for flow rate..."
	
	wave cn = CN_Concentration
	cn /= ccn_cpc_flow
		
	setdatafolder sdf
End

Function ccn_same_timebase_tmp()
	string sdf = getdatafolder(1)
	setdatafolder $ccn_tmp_data_folder

	print "Converting new data to constant time base and averaging into " + num2str(ccn_avg_period) + " sec periods"
	
	wave ccn_tw = :ccn:Start_DateTime
	wave cn_tw = :cn:Start_DateTime
	
	NVAR sys_type = ccn_system_type
	
	// get timebase limits
	wavestats/Q ccn_tw
	variable mintime=V_min
	variable maxtime=V_max
	//wavestats/Q cn_tw
	//mintime=(mintime>V_min) ? V_min : mintime
	//maxtime=(maxtime<V_max) ? V_max : maxtime

	variable/G first_starttime=mintime - mod(mintime,ccn_avg_period)
	variable/G last_starttime=maxtime - mod(maxtime,ccn_avg_period)
	
	variable time_periods = (maxtime-first_starttime) + 1
	variable time_periods_avg = (last_starttime-first_starttime)/(ccn_avg_period) + 1

	string dset_list = "ccn;cn"
	if (sys_type == 2 || sys_type == 1)
		dset_list += ";mono"
	endif
	//string dset_list = "ccn"
	variable i,j,k
	make/O/N=(time_periods)/d date_time
	make/O/N=(time_periods_avg)/d date_time_avg
	
	date_time[0] = first_starttime
	for (i=1; i<time_periods; i+=1)
		date_time[i] = date_time[i-1] + 1
	endfor

	date_time_avg[0] = first_starttime
	for (i=1; i<time_periods_avg; i+=1)
		date_time_avg[i] = date_time_avg[i-1] + ccn_avg_period
	endfor

	// create string wave to hold list of waves to combine
	//make/O/T/N=(itemsinlist(dset_list)) root:main_wave_list
	string mwl = ccn_data_folder + ":main_wave_list"
	make/O/T/N=(itemsinlist(dset_list)) $(mwl)
	//wave/T wavlist = root:main_wave_list
	wave/T wavlist = $(mwl)
	
	// put all 1sec waves into date_time base
	for (i=0; i<itemsinlist(dset_list); i+=1)

		print "	working on " + stringfromlist(i,dset_list) + " data"	
		string wlist=""
		string wname=""
		variable index=0
		do
			string ds=":"+stringfromlist(i,dset_list)
			wname = GetIndexedObjName(ds,1, index)
			if (strlen(wname) == 0)
				break
			endif
				
			//Print wname
			if ( (cmpstr(wname,"Start_DateTime") !=0) && (cmpstr(wname,"DOY") !=0) && (cmpstr(wname,"AvePeriod") !=0) ) 
				wlist += wname + ";"
			endif
			index += 1
		while(1)
		//print wlist
		wavlist[i] = wlist

		// do time base once because it takes awhile
		print "		creating time index for constant time base (may take awhile)..."
		wave dst = $(ds+":Start_DateTime")
		duplicate/o dst time_index
		time_index = -1
		for (k=0; k<numpnts(dst); k+=1)
			//FindValue/T=(0.2)/V=(dst[k]) date_time
			//time_index[k]=V_value
			time_index[k] = BinarySearch(date_time,dst[k])
		endfor


		for (j=0; j<itemsinlist(wlist); j+=1)
			duplicate/o date_time $(stringfromlist(j,wlist))
			duplicate/o date_time_avg $(stringfromlist(j,wlist)+"_avg")
			wave w = $(stringfromlist(j,wlist))
			wave w_avg = $(stringfromlist(j,wlist)+"_avg")
			wave dsw = $(ds+":"+stringfromlist(j,wlist))
			variable idx
			
			print "			processing " + stringfromlist(j,wlist)
			
			w = NaN
			w_avg = NaN
			
			// insert missing values
			for (k=0; k<numpnts(dsw); k+=1)
				//FindValue/V=(dst[k]) date_time
				//idx=V_value
				idx = time_index[k]
				if (idx > -1)
					w[idx] = dsw[k]
				endif
			endfor
			
			//variable last_idx=0
			//for (k=0; k<numpnts(dsw); k+=1)
			//	for (idx=last_idx; idx<numpnts(date_time); idx+=1)
			//		if (dst[k] == date_time[idx])
			//			w[idx] = dsw[k]
			//			last_idx = idx
			//			idx = numpnts(date_time)-1
			//		endif
			//		print "idx=",idx
			//	endfor
			//	print "k=", k
			//endfor	
						
			// avg wave into ccn_avg_periods
			idx = 0;
			for (k=0; k<numpnts(date_time_avg); k+=1)
				variable inc = ( (numpnts(w)-idx) < ccn_avg_period ) ? (numpnts(w)-idx-1) : (ccn_avg_period-1)
				wavestats/Q/R=[idx,idx+inc] w
				w_avg[k] = V_avg
				idx += ccn_avg_period
			endfor
			killwaves/Z w
		endfor
	endfor
	
	setdatafolder sdf	
End

Function ccn_sync_other_waves()
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	if (!waveexists(new_time_index))
		ccn_init_samp_type_waves()
		ccn_mono_shift_cn(1)
		
		// added 03 March 2018
		ccn_init_sample_info_waves()
	else
		wave main_tw = ccn_datetime
		wave bak_time_index = bak_time_index
		wave new_time_index = new_time_index
		

		print "		adding sample types"
		duplicate/o/T ccn_sample_type ccn_sample_type_bak
		make/o/T/n=(numpnts(main_tw)) ccn_sample_type
		wave/T tbak = ccn_sample_type_bak
		wave/T tmain = ccn_sample_type
		string list = ccn_get_samp_type_list()
		tmain = stringfromlist(1,list) // init to NORMAL
		SetScale/P x main_tw[0],ccn_avg_period,"dat", tmain
		
		variable k, idx		
		// only have to add bak values as we init all new types to "NORMAL"
		for (k=0; k<numpnts(tbak); k+=1)
			idx = bak_time_index[k]
			if (idx > -1)
				tmain[idx] = tbak[k]
			endif
		endfor
		ccn_generate_samp_type_index(1) // generate new index wave


		
		// temporarily do sample_dev waves, too
		duplicate/o/T ccn_sample_type_dev ccn_sample_type_dev_bak
		make/o/T/n=(numpnts(main_tw)) ccn_sample_type_dev
		wave/T tbak = ccn_sample_type_dev_bak
		wave/T tmain = ccn_sample_type_dev
		//string list = ccn_get_samp_type_list()
		//tmain = stringfromlist(1,list) // init to NORMAL
		tmain = "NORMAL"
		SetScale/P x main_tw[0],ccn_avg_period,"dat", tmain

		// recreate sample_type_dev waves
		for (k=0; k<numpnts(tbak); k+=1)
			idx = bak_time_index[k]
			if (idx > -1)
				tmain[idx] = tbak[k]
			endif
		endfor

		// temporarily do flag_dev waves, too
		duplicate/o/T ccn_flag_dev ccn_flag_dev_bak
		make/o/T/n=(numpnts(main_tw)) ccn_flag_dev
		wave/T tbak = ccn_flag_dev_bak
		wave/T tmain = ccn_flag_dev
		//string list = ccn_get_samp_type_list()
		//tmain = stringfromlist(1,list) // init to NORMAL
		tmain = ""
		SetScale/P x main_tw[0],ccn_avg_period,"dat", tmain

		// recreate flag_dev waves
		for (k=0; k<numpnts(tbak); k+=1)
			idx = bak_time_index[k]
			if (idx > -1)
				tmain[idx] = tbak[k]
			endif
		endfor
		//ccn_generate_samp_type_index(1) // generate new index wave
		ccn_update_sample_info_index(force="true")

		print "		adding shifted waves"
		duplicate/o mono_cn_offset mono_cn_offset_bak 
		ccn_mono_shift_cn(1)
		wave bak = mono_cn_offset_bak
		wave main = mono_cn_offset
		SetScale/P x main_tw[0],ccn_avg_period,"dat", main

		// only have to add bak values as we init all new types to default
		for (k=0; k<numpnts(bak); k+=1)
			idx = bak_time_index[k]
			if (idx > -1)
				main[idx] = bak[k]
			endif
		endfor
		ccn_mono_shift_cn(0)
	endif
	SetDataFolder dfr
End

Function ccn_combine_data_from_tmp()
	string sdf = getdatafolder(1)
	//setdatafolder $ccn_tmp_data_folder
	//setdatafolder root:
	setdatafolder ccn_data_folder

	print "Adding new data to main data"
	
	if (!waveexists(ccn_datetime))
		ccn_first_data_copy()
		return(0)
	endif 
	//wave main_tw = root:ccn_datetime
	wave new_tw = $(ccn_tmp_data_folder + ":date_time_avg")
	duplicate/o ccn_datetime ccn_datetime_bak
	wave bak_tw = ccn_datetime_bak
	
	variable i,j,k
	
	// get timebase limits
	wavestats/Q bak_tw
	variable mintime=V_min
	variable maxtime=V_max
	wavestats/Q new_tw
	mintime=(mintime>V_min) ? V_min : mintime
	maxtime=(maxtime<V_max) ? V_max : maxtime

	variable/G first_starttime=mintime 
	variable/G last_starttime=maxtime
	
	variable time_periods = (last_starttime-first_starttime)/ccn_avg_period + 1

	make/o/n=(time_periods)/d ccn_datetime
	wave main_tw = ccn_datetime
	
	// create main timewave
	main_tw[0] = first_starttime
	for (i=1; i<time_periods; i+=1)
		main_tw[i] = main_tw[i-1] + ccn_avg_period
	endfor
	
	// create time_index for main data
	print "	creating main time index for constant time base (may take awhile)..."
	duplicate/o bak_tw bak_time_index
	bak_time_index = -1
	for (k=0; k<numpnts(bak_tw); k+=1)
		//FindValue/T=(0.2)/V=(bak_tw[k]) main_tw
		//bak_time_index[k]=V_value
		bak_time_index[k] = BinarySearch(main_tw,bak_tw[k])
	endfor
		
	// create time_index for new data
	print "	creating new time index for constant time base (may take awhile)..."
	duplicate/o new_tw new_time_index
	new_time_index = -1
	for (k=0; k<numpnts(new_tw); k+=1)
		//FindValue/T=(0.2)/V=(new_tw[k]) main_tw
		//new_time_index[k]=V_value
		new_time_index[k]=BinarySearch(main_tw, new_tw[k])
	endfor
		
	// create combine the data: main first and overwrite with new
	wave/T wlist = main_wave_list
	variable idx
	print "	starting to add..."
	for (i=0; i<numpnts(main_wave_list); i+=1)
		string list = wlist[i]
		for (j=0; j<itemsinlist(list); j+=1)
			print "		adding " + stringfromlist(j,list)
			duplicate/o $(stringfromlist(j,list)) $(stringfromlist(j,list)+"_bak")
			duplicate/o main_tw $(stringfromlist(j,list))
			wave main = $(stringfromlist(j,list))
			wave bak = $(stringfromlist(j,list)+"_bak")
			wave new = $(ccn_tmp_data_folder + ":" + stringfromlist(j,list)+"_avg")
	
			SetScale/P x main_tw[0],ccn_avg_period,"dat", main
			main = NaN

			for (k=0; k<numpnts(bak); k+=1)
				//FindValue/V=(dst[k]) date_time
				//idx=V_value
				idx = bak_time_index[k]
				if (idx > -1)
					main[idx] = bak[k]
				endif
			endfor
		
			for (k=0; k<numpnts(new); k+=1)
				//FindValue/V=(dst[k]) date_time
				//idx=V_value
				idx = new_time_index[k]
				if (idx > -1)
					main[idx] = new[k]
				endif
			endfor
			killwaves bak
		endfor
	endfor

End

Function ccn_first_data_copy()
	string sdf = getdatafolder(1)
	setdatafolder $ccn_tmp_data_folder
	
	
	print "	First time...move new data to main"
	duplicate/o date_time_avg root:ccn:ccn_datetime
	wave main_tw = root:ccn:ccn_datetime
	
	variable i,j,k
	//wave/T wavlist = root:main_wave_list
	wave/T wavlist = $(ccn_data_folder + ":main_wave_list")
	for (i=0; i<numpnts(wavlist); i+=1)
		string wlist = wavlist[i]
		for (j=0; j<itemsinlist(wlist); j+=1)
			//duplicate/o $(stringfromlist(j,wlist)+"_avg") root:ccn:$(stringfromlist(j,wlist))
			duplicate/o $(stringfromlist(j,wlist)+"_avg") $(ccn_data_folder+":"+stringfromlist(j,wlist))
			wave main = $(ccn_data_folder+":"+stringfromlist(j,wlist))
			SetScale/P x main_tw[0],ccn_avg_period,"dat", main
		endfor
	endfor
	
	setdatafolder sdf	
End

//Function test_avg()
//	Make/o/n=10/d testavg
//	variable i
//	testavg=NaN
//	for (i=0; i<7; i+=1)
//		testavg[i]=i
//	endfor
//	testavg = NaN
//	wavestats testavg
//	print V_avg
//End

function ratio_ccn_to_cn()
	string sdf = getdatafolder(1)
	//setdatafolder root:
	setdatafolder ccn_data_folder
	
	print "calculating ratio of CCNconc over CNconc"
	
	duplicate/o CCN_Concentration_Cleaned CCN_CN_ratio_Cleaned
	duplicate/o CCN_Concentration CCN_CN_ratio
	wave ratio_cleaned = CCN_CN_ratio_Cleaned
	wave ratio = CCN_CN_ratio
	ratio_cleaned = NaN
	ratio = NaN
	wave ccn_cleaned = CCN_Concentration_Cleaned
	wave ccn = CCN_Concentration
	wave cn = CN_Concentration
	ratio_cleaned = ccn_cleaned/cn
	ratio_cleaned = (cn == 0.0) ? NaN : ratio_cleaned
	ratio_cleaned = (ratio_cleaned > 5) ? NaN : ratio_cleaned
	ratio_cleaned = (cn < 1) ? NaN : ratio_cleaned
	ratio_cleaned = (ccn_cleaned < 0) ? NaN : ratio_cleaned
	ratio = ccn/cn
	ratio = (ratio[p] > 5) ? NaN : ratio[p]
	ratio = (cn[p] < 1) ? NaN : ratio[p]
	ratio = (ccn[p] < 1) ? NaN : ratio[p]
	duplicate/o ratio mono_ccn_cn_ratio_Clean
	
	setdatafolder sdf
End

//NOx_NOy_ratio = (NO_ppbv < 0.0) ? NaN : NOx_NOy_ratio




Function test_sdf()
	setdatafolder  $(ccn_data_folder+":SS_Mask")
End

//make mask waves for 5 different SS settings for CCN mono
Function Make_SS_mask_waves_mono()
	string sdf = getdatafolder(1)
	//setdatafolder $(ccn_data_folder+":SS_Mask")
	//setdatafolder ccn_data_folder

	newdatafolder/o/s $(ccn_data_folder+":SS_Mask")
	
	wave SS_Setting =  root:ccn:SS_setting
	wave CCN_Concentration_Cleaned = root:ccn:CCN_Concentration_Cleaned
	wave CN_Concentration_mono = root:ccn:mono_cn_conc
	//wave CCN_mono_smps_dp = root:ccn:mono_smps_dp
	//wave mono_ccn_cn_ratio_avg = root:ccn:mono_ccn_cn_ratio_avg
	wave mono_ccn_cn_ratio_avg = root:ccn:mono_cn_ccn_ratio //changed for CalNex--CCN/CN ratio created by hand by Trish
	
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_1,CN_Concentration_mono_1, CCN_mono_smps_dp_1, mono_ccn_cn_ratio_avg_1, SS_Mask_1
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_2,CN_Concentration_mono_2, CCN_mono_smps_dp_2, mono_ccn_cn_ratio_avg_2, SS_Mask_2
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_3,CN_Concentration_mono_3, CCN_mono_smps_dp_3, mono_ccn_cn_ratio_avg_3, SS_Mask_3
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_4,CN_Concentration_mono_4, CCN_mono_smps_dp_4, mono_ccn_cn_ratio_avg_4, SS_Mask_4
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_5,CN_Concentration_mono_5, CCN_mono_smps_dp_5, mono_ccn_cn_ratio_avg_5, SS_Mask_5
	duplicate/o root:ccn:ccn_datetime ccn_datetime
	
	SS_Mask_1 = 0
	SS_Mask_2 = 0
	SS_Mask_3 = 0
	SS_Mask_4 = 0	
	SS_Mask_5 = 0	
			
	variable lower_limit_SS_1 = 0.29
	variable upper_limit_SS_1 = 0.31
	
	variable lower_limit_SS_2 = 0.39
	variable upper_limit_SS_2 = 0.41

	variable lower_limit_SS_3 = 0.49
	variable upper_limit_SS_3 = 0.51
	
	variable lower_limit_SS_4 = 0.59
	variable upper_limit_SS_4 = 0.61
	
	variable lower_limit_SS_5 = 0.69
	variable upper_limit_SS_5 = 0.71		
	
	variable np = numpnts(SS_Mask_1)
	
	variable i
	
	//Mask for SS_1
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_1) && ((SS_Setting[i])>=lower_limit_SS_1))
			SS_Mask_1[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_1 = CCN_Concentration_Cleaned*SS_Mask_1
	CN_Concentration_mono_1 = CN_Concentration_mono*SS_Mask_1
	//CCN_mono_smps_dp_1 = CCN_mono_smps_dp*SS_Mask_1
	mono_ccn_cn_ratio_avg_1 = mono_ccn_cn_ratio_avg*SS_Mask_1
	
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_1[i]) ==0) 
		CCN_Concentration_Cleaned_1[i]=nan	
		endif
		if ((CN_Concentration_mono_1[i]) ==0) 
		CN_Concentration_mono_1[i]=nan	
		endif
		//if ((CCN_mono_smps_dp_1[i]) ==0) 
		//CCN_mono_smps_dp_1[i]=nan	
		//endif
		if ((mono_ccn_cn_ratio_avg_1[i]) ==0) 
		mono_ccn_cn_ratio_avg_1[i]=nan	
		endif
	endfor
	
	//Mask for SS_2
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_2) && ((SS_Setting[i])>=lower_limit_SS_2))
			SS_Mask_2[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_2 = CCN_Concentration_Cleaned*SS_Mask_2
	CN_Concentration_mono_2 = CN_Concentration_mono*SS_Mask_2
	//CCN_mono_smps_dp_2 = CCN_mono_smps_dp*SS_Mask_2
	mono_ccn_cn_ratio_avg_2 = mono_ccn_cn_ratio_avg*SS_Mask_2
	
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_2[i]) ==0) 
		CCN_Concentration_Cleaned_2[i]=nan	
		endif
		if ((CN_Concentration_mono_2[i]) ==0) 
		CN_Concentration_mono_2[i]=nan	
		endif
		//if ((CCN_mono_smps_dp_2[i]) ==0) 
		//CCN_mono_smps_dp_2[i]=nan	
		//endif
		if ((mono_ccn_cn_ratio_avg_2[i]) ==0) 
		mono_ccn_cn_ratio_avg_2[i]=nan	
		endif
	endfor
	
	//Mask for SS_3
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_3) && ((SS_Setting[i])>=lower_limit_SS_3))
			SS_Mask_3[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_3 = CCN_Concentration_Cleaned*SS_Mask_3
	CN_Concentration_mono_3 = CN_Concentration_mono*SS_Mask_3
	//CCN_mono_smps_dp_3 = CCN_mono_smps_dp*SS_Mask_3
	mono_ccn_cn_ratio_avg_3 = mono_ccn_cn_ratio_avg*SS_Mask_3
	
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_3[i]) ==0) 
		CCN_Concentration_Cleaned_3[i]=nan	
		endif
		if ((CN_Concentration_mono_3[i]) ==0) 
		CN_Concentration_mono_3[i]=nan	
		endif
		//if ((CCN_mono_smps_dp_3[i]) ==0) 
		//CCN_mono_smps_dp_3[i]=nan	
		//endif
		if ((mono_ccn_cn_ratio_avg_3[i]) ==0) 
		mono_ccn_cn_ratio_avg_3[i]=nan	
		endif
	endfor
	
	//Mask for SS_4
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_4) && ((SS_Setting[i])>=lower_limit_SS_4))
			SS_Mask_4[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_4 = CCN_Concentration_Cleaned*SS_Mask_4
	CN_Concentration_mono_4 = CN_Concentration_mono*SS_Mask_4
	//CCN_mono_smps_dp_4 = CCN_mono_smps_dp*SS_Mask_4
	mono_ccn_cn_ratio_avg_4 = mono_ccn_cn_ratio_avg*SS_Mask_4
	
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_4[i]) ==0) 
		CCN_Concentration_Cleaned_4[i]=nan	
		endif
		if ((CN_Concentration_mono_4[i]) ==0) 
		CN_Concentration_mono_4[i]=nan	
		endif
		//if ((CCN_mono_smps_dp_4[i]) ==0) 
		//CCN_mono_smps_dp_4[i]=nan	
		//endif
		if ((mono_ccn_cn_ratio_avg_4[i]) ==0) 
		mono_ccn_cn_ratio_avg_4[i]=nan	
		endif
	endfor
	
	//Mask for SS_5
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_5) && ((SS_Setting[i])>=lower_limit_SS_5))
			SS_Mask_5[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_5 = CCN_Concentration_Cleaned*SS_Mask_5
	CN_Concentration_mono_5 = CN_Concentration_mono*SS_Mask_5
	//CCN_mono_smps_dp_5 = CCN_mono_smps_dp*SS_Mask_5
	mono_ccn_cn_ratio_avg_5 = mono_ccn_cn_ratio_avg*SS_Mask_5
	
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_5[i]) ==0) 
		CCN_Concentration_Cleaned_5[i]=nan	
		endif
		if ((CN_Concentration_mono_5[i]) ==0) 
		CN_Concentration_mono_5[i]=nan	
		endif
		//if ((CCN_mono_smps_dp_5[i]) ==0) 
		//CCN_mono_smps_dp_5[i]=nan	
		//endif
		if ((mono_ccn_cn_ratio_avg_5[i]) ==0) 
		mono_ccn_cn_ratio_avg_5[i]=nan	
		endif
	endfor

	setdatafolder sdf
end

//make mask waves for 5 different SS settings for CCN spectra
Function Make_SS_mask_waves_spectra()
	string sdf = getdatafolder(1)
	//setdatafolder $(ccn_data_folder+":SS_Mask")
	//setdatafolder ccn_data_folder

	newdatafolder/o/s $(ccn_data_folder+":SS_Mask")
	
	wave SS_Setting =  root:ccn:SS_setting
	wave CCN_Concentration_Cleaned = root:ccn:CCN_Concentration_Cleaned
	wave CN_Concentration = root:ccn:CN_Concentration
	wave CCN_CN_ratio_Cleaned = root:ccn:CCN_CN_ratio_Cleaned
	
	
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_1,CN_Concentration_1, CCN_CN_ratio_Cleaned_1, SS_Mask_1
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_2,CN_Concentration_2, CCN_CN_ratio_Cleaned_2, SS_Mask_2
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_3,CN_Concentration_3, CCN_CN_ratio_Cleaned_3, SS_Mask_3
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_4,CN_Concentration_4, CCN_CN_ratio_Cleaned_4, SS_Mask_4
	duplicate/o root:ccn:CCN_Concentration_Cleaned  CCN_Concentration_Cleaned_5,CN_Concentration_5, CCN_CN_ratio_Cleaned_5, SS_Mask_5
	duplicate/o root:ccn:ccn_datetime ccn_datetime
	
	SS_Mask_1 = 0
	SS_Mask_2 = 0
	SS_Mask_3 = 0
	SS_Mask_4 = 0	
	SS_Mask_5 = 0	
			
	variable lower_limit_SS_1 = 0.19
	variable upper_limit_SS_1 = 0.21
	
	variable lower_limit_SS_2 = 0.29
	variable upper_limit_SS_2 = 0.31

	variable lower_limit_SS_3 = 0.39
	variable upper_limit_SS_3 = 0.41
	
	variable lower_limit_SS_4 = 0.49
	variable upper_limit_SS_4 = 0.51
	
	variable lower_limit_SS_5 = 0.99
	variable upper_limit_SS_5 = 1.01		
	
	variable np = numpnts(SS_Mask_1)
	
	variable i
	
	//Mask for SS_1
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_1) && ((SS_Setting[i])>=lower_limit_SS_1))
			SS_Mask_1[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_1 = CCN_Concentration_Cleaned*SS_Mask_1
	CN_Concentration_1 = CN_Concentration*SS_Mask_1
	CCN_CN_ratio_Cleaned_1 = CCN_CN_ratio_Cleaned*SS_Mask_1
		
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_1[i]) ==0) 
		CCN_Concentration_Cleaned_1[i]=nan	
		endif
		if ((CN_Concentration_1[i]) ==0) 
		CN_Concentration_1[i]=nan	
		endif
		if ((CCN_CN_ratio_Cleaned_1[i]) ==0) 
		CCN_CN_ratio_Cleaned_1[i]=nan	
		endif
	endfor
	
	//Mask for SS_2
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_2) && ((SS_Setting[i])>=lower_limit_SS_2))
			SS_Mask_2[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_2 = CCN_Concentration_Cleaned*SS_Mask_2
	CN_Concentration_2 = CN_Concentration*SS_Mask_2
	CCN_CN_ratio_Cleaned_2 = CCN_CN_ratio_Cleaned*SS_Mask_2
		
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_2[i]) ==0) 
		CCN_Concentration_Cleaned_2[i]=nan	
		endif
		if ((CN_Concentration_2[i]) ==0) 
		CN_Concentration_2[i]=nan	
		endif
		if ((CCN_CN_ratio_Cleaned_2[i]) ==0) 
		CCN_CN_ratio_Cleaned_2[i]=nan	
		endif
	endfor
	
	//Mask for SS_3
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_3) && ((SS_Setting[i])>=lower_limit_SS_3))
			SS_Mask_3[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_3 = CCN_Concentration_Cleaned*SS_Mask_3
	CN_Concentration_3 = CN_Concentration*SS_Mask_3
	CCN_CN_ratio_Cleaned_3 = CCN_CN_ratio_Cleaned*SS_Mask_3
		
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_3[i]) ==0) 
		CCN_Concentration_Cleaned_3[i]=nan	
		endif
		if ((CN_Concentration_3[i]) ==0) 
		CN_Concentration_3[i]=nan	
		endif
		if ((CCN_CN_ratio_Cleaned_3[i]) ==0) 
		CCN_CN_ratio_Cleaned_3[i]=nan	
		endif
	endfor
	
	//Mask for SS_4
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_4) && ((SS_Setting[i])>=lower_limit_SS_4))
			SS_Mask_4[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_4 = CCN_Concentration_Cleaned*SS_Mask_4
	CN_Concentration_4 = CN_Concentration*SS_Mask_4
	CCN_CN_ratio_Cleaned_4 = CCN_CN_ratio_Cleaned*SS_Mask_4
		
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_4[i]) ==0) 
		CCN_Concentration_Cleaned_4[i]=nan	
		endif
		if ((CN_Concentration_4[i]) ==0) 
		CN_Concentration_4[i]=nan	
		endif
		if ((CCN_CN_ratio_Cleaned_4[i]) ==0) 
		CCN_CN_ratio_Cleaned_4[i]=nan	
		endif
	endfor
	
	//Mask for SS_5
	
	for (i=0;i<np;i+=1)
		if (((SS_Setting[i]) <= upper_limit_SS_5) && ((SS_Setting[i])>=lower_limit_SS_5))
			SS_Mask_5[i] = 1
		endif
	endfor
	
	
	CCN_Concentration_Cleaned_5 = CCN_Concentration_Cleaned*SS_Mask_5
	CN_Concentration_5 = CN_Concentration*SS_Mask_5
	CCN_CN_ratio_Cleaned_5 = CCN_CN_ratio_Cleaned*SS_Mask_5
		
	
	for (i=0;i<np;i+=1)
		if ((CCN_Concentration_Cleaned_5[i]) ==0) 
		CCN_Concentration_Cleaned_5[i]=nan	
		endif
		if ((CN_Concentration_5[i]) ==0) 
		CN_Concentration_5[i]=nan	
		endif
		if ((CCN_CN_ratio_Cleaned_5[i]) ==0) 
		CCN_CN_ratio_Cleaned_5[i]=nan	
		endif
	endfor

	setdatafolder sdf
end


macro NaN_bad_CCN()

	setdatafolder root:ccn:
	variable i
	
//Nan CCN_Concentration	
	string nan_CCN = ""
	i=0
	do
		CCN_Concentration[str2num(stringfromlist(i,nan_CCN,","))] =NaN
		i+=1
	while (i<(itemsinlist(nan_CCN,",")))
	
//Nan CCN_Concentration_Cleaned
	string nan_CCN_Cleaned = ""
	i=0
	do
		CCN_Concentration_Cleaned[str2num(stringfromlist(i,nan_CCN_Cleaned,","))] =NaN
		i+=1
	while (i<(itemsinlist(nan_CCN_Cleaned,",")))
	
	setdatafolder root:ccn:

End

Window AvgMaskGraph() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:ccn:
	Display /W=(138.75,96.5,806.25,578) mono_avg_plot_ratio vs mono_avg_plot_datetime as "AvgMaskGraph"
	AppendToGraph/R SS_setting vs ccn_datetime
	AppendToGraph/L=mask mono_avg_mask vs mono_avg_plot_datetime
	SetDataFolder fldrSav0
	ModifyGraph mode(mono_avg_plot_ratio)=8,mode(mono_avg_mask)=3
	ModifyGraph marker(mono_avg_plot_ratio)=19,marker(mono_avg_mask)=16
	ModifyGraph lSize(SS_setting)=1.5
	ModifyGraph rgb(SS_setting)=(0,0,0),rgb(mono_avg_mask)=(0,15872,65280)
	ModifyGraph lblPosMode(left)=1,lblPosMode(mask)=1
	ModifyGraph lblPos(left)=44
	ModifyGraph freePos(mask)=0
	ModifyGraph axisEnab(left)={0,0.75}
	ModifyGraph axisEnab(right)={0,0.75}
	ModifyGraph axisEnab(mask)={0.8,1}
	ModifyGraph dateInfo(bottom)={0,0,0}
	Label left "CCN / CN (mono)"
	Label bottom "Time"
	Label right "SS (%)"
	Label mask "Avg Mask"
EndMacro

Window ratio_vs_ss_from_avg_mask() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:ccn:
	Display /W=(306,87.5,903.75,473.75) mono_ratio_from_avg_mask[*][0] vs mono_ss_from_avg_mask as "ratio_vs_ss_from_avg_mask"
	AppendToGraph mono_ratio_from_avg_mask[*][1] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][2] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][3] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][4] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][5] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][6] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][7] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][8] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][9] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][10] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][11] vs mono_ss_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[*][12] vs mono_ss_from_avg_mask
	SetDataFolder fldrSav0
	ModifyGraph mode=4
	ModifyGraph marker(mono_ratio_from_avg_mask)=19,marker(mono_ratio_from_avg_mask#1)=16
	ModifyGraph marker(mono_ratio_from_avg_mask#2)=17,marker(mono_ratio_from_avg_mask#3)=23
	ModifyGraph marker(mono_ratio_from_avg_mask#4)=46,marker(mono_ratio_from_avg_mask#5)=49
	ModifyGraph marker(mono_ratio_from_avg_mask#6)=43,marker(mono_ratio_from_avg_mask#7)=12
	ModifyGraph marker(mono_ratio_from_avg_mask#8)=2,marker(mono_ratio_from_avg_mask#9)=15
	ModifyGraph marker(mono_ratio_from_avg_mask#10)=14,marker(mono_ratio_from_avg_mask#11)=39
	ModifyGraph marker(mono_ratio_from_avg_mask#12)=41
	ModifyGraph lSize=1.5
	ModifyGraph rgb(mono_ratio_from_avg_mask#1)=(65280,43520,0),rgb(mono_ratio_from_avg_mask#2)=(0,39168,0)
	ModifyGraph rgb(mono_ratio_from_avg_mask#3)=(0,65280,65280),rgb(mono_ratio_from_avg_mask#4)=(0,15872,65280)
	ModifyGraph rgb(mono_ratio_from_avg_mask#5)=(26368,0,52224),rgb(mono_ratio_from_avg_mask#6)=(65280,16384,55552)
	ModifyGraph rgb(mono_ratio_from_avg_mask#7)=(26112,26112,26112),rgb(mono_ratio_from_avg_mask#8)=(0,0,0)
	ModifyGraph rgb(mono_ratio_from_avg_mask#9)=(65280,65280,0),rgb(mono_ratio_from_avg_mask#10)=(16384,65280,16384)
	ModifyGraph rgb(mono_ratio_from_avg_mask#11)=(26112,17408,0),rgb(mono_ratio_from_avg_mask#12)=(0,39168,39168)
	Label left "CCN / CN (mono)"
	Label bottom "% SS"
	Legend/N=text0/J/A=MC/X=19.97/Y=20.55 "\\s(mono_ratio_from_avg_mask) 20 nm\r\\s(mono_ratio_from_avg_mask#1) 30 nm\r\\s(mono_ratio_from_avg_mask#2) 35 nm"
	AppendText "\\s(mono_ratio_from_avg_mask#3) 40 nm\r\\s(mono_ratio_from_avg_mask#4) 45 nm\r\\s(mono_ratio_from_avg_mask#5) 50 nm"
	AppendText "\\s(mono_ratio_from_avg_mask#6) 60 nm\r\\s(mono_ratio_from_avg_mask#7) 70 nm\r\\s(mono_ratio_from_avg_mask#8) 80 nm"
	AppendText "\\s(mono_ratio_from_avg_mask#9) 90 nm\r\\s(mono_ratio_from_avg_mask#10) 100 nm\r\\s(mono_ratio_from_avg_mask#11) 110 nm"
	AppendText "\\s(mono_ratio_from_avg_mask#12) 130 nm"
EndMacro

Window ratio_vs_dp_from_avg_mask() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:ccn:
	Display /W=(66,63.5,666,449.75) mono_ratio_from_avg_mask[0][*] vs mono_dp_from_avg_mask as "ratio_vs_dp_from_avg_mask"
	AppendToGraph mono_ratio_from_avg_mask[1][*] vs mono_dp_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[2][*] vs mono_dp_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[3][*] vs mono_dp_from_avg_mask
	AppendToGraph mono_ratio_from_avg_mask[4][*] vs mono_dp_from_avg_mask
	SetDataFolder fldrSav0
	ModifyGraph mode=4
	ModifyGraph marker(mono_ratio_from_avg_mask)=18,marker(mono_ratio_from_avg_mask#1)=23
	ModifyGraph marker(mono_ratio_from_avg_mask#2)=17,marker(mono_ratio_from_avg_mask#3)=16
	ModifyGraph marker(mono_ratio_from_avg_mask#4)=19
	ModifyGraph lSize=1.5
	ModifyGraph rgb(mono_ratio_from_avg_mask)=(65280,65280,0),rgb(mono_ratio_from_avg_mask#1)=(65280,43520,0)
	ModifyGraph rgb(mono_ratio_from_avg_mask#2)=(0,39168,0),rgb(mono_ratio_from_avg_mask#3)=(0,15872,65280)
	ModifyGraph gaps=0
	Label left "CCN / CN (mono)"
	Label bottom "D\\Bp\\M (nm)"
	Legend/N=text0/J/A=MC/X=25.37/Y=31.64 "\\s(mono_ratio_from_avg_mask) 0.2%\r\\s(mono_ratio_from_avg_mask#1) 0.3%\r\\s(mono_ratio_from_avg_mask#2) 0.4%"
	AppendText "\\s(mono_ratio_from_avg_mask#3) 0.5%\r\\s(mono_ratio_from_avg_mask#4) 1.0%"
EndMacro

Function ccn_load_plume_times_for_Dan()
	string sdf = getdatafolder(1)
	setdatafolder root:ccn_1sec_dan
	newdatafolder/o/s ship_plumes
	
	set_base_path()
	PathInfo loaddata_base_path
	LoadWave/J/D/N=plumetime/O/K=0/P=loaddata_base_path
	rename plumetime0, start_plume
	rename plumetime1, end_plume

	setdatafolder sdf
End

Function ccn_process_plumes_for_Dan()
	string sdf = getdatafolder(1)
	setdatafolder root:ccn_1sec_dan:ship_plumes

	wave start_plume
	wave end_plume
	
	wave dt = ::ccn_datetime
	wave conc = ::CCN_Concentration_Clean
	wave ss = ::SS_Settting
	
	duplicate/o dt ship_plume_flag
	wave flag = ship_plume_flag
	flag = NaN
	
	variable i
	for (i=0; i<numpnts(start_plume); i+=1)
		 variable starti = BinarySearch(dt,start_plume[i])
		 variable endi = BinarySearch(dt,end_plume[i])
		 
		 if (starti == -1)
		 	starti = 0
		 elseif (starti == -2)
		 	starti = numpnts(flag)
		 endif

		 if (endi == -1)
		 	endi = 0
		 elseif (endi == -2)
		 	endi = numpnts(flag)
		 endif
		 
		 flag[starti,endi] = 1
	endfor
	
	duplicate/o conc ::CCN_Concentration_plume
	wave plume = ::CCN_Concentration_plume
	plume = conc*flag
	
	setdatafolder sdf
End

Function ccn_load_1sec_for_Dan() // 1-sec data for Dan

	string sdf = getdatafolder(1)
	setdatafolder root:
	//newdatafolder/o root:ccn_1sec_dan
	newdatafolder/o/s :ccn_tmp_data_folder
	newdatafolder/o/s :ccn
	
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
	//LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path 
	
	// load all data into nativeXX waves
	//LoadWave/J/D/N=native/O/K=0/L={4,6,0,0,0}/P=loaddata_base_path 
	LoadWave/J/D/N=native/O/K=0/P=loaddata_base_path 
	NewPath/o/z path_to_ccn, S_path
	string ccn_file = S_filename
	//wave timewave = native0
	
	//get date from 2nd line of file
	//LoadWave/J/D/N=nativedate/K=0/L={0,1,1,1,1}/P=path_to_ccn ccn_file
	LoadWave/J/D/N=nativedate/K=0/L={0,0,0,0,1}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=path_to_ccn ccn_file 
	wave dtwave = nativedate0
	
	// create duplicate waves and clean Tstable and OverShoot
	wave ss_set = native3
	wave tstab = native4
	wave conc = native21
	duplicate/o conc conc_tstab, conc_clean
	wave conc_tstab
	wave conc_clean
	
	//conc_tstab= NaN
	conc_tstab = (tstab[p] > 0) ? conc[p] : NaN
	
	variable start_dt = dtwave[0]
	conc_clean = NaN
	variable i
	for (i=1; i < numpnts(conc_tstab); i+=1)
		if ( abs( (ss_set[i-1]-ss_set[i])/ss_set[i-1] ) > 0.05 ) // different ss
			start_dt = dtwave[i]
		endif
		
		if ( (dtwave[i]-start_dt) >= ccn_overshoot_sec)
			conc_clean[i] = conc_tstab[i]
		endif
	endfor		
		
	// create 1sec time wave
	WaveStats/Q dtwave
	setdatafolder ::
	make/o/D/n=(V_max-V_min+1) ccn_datetime
	wave tmp_ccn_dt = ccn_datetime
	tmp_ccn_dt[0] = V_min
	tmp_ccn_dt[1,] = tmp_ccn_dt[p-1] + 1
	duplicate/o tmp_ccn_dt SS_setting, TempStable, CCN_Concentration, CCN_Concentration_TStab, CCN_Concentration_Clean
 	wave tmp_SS_Setting = SS_Setting
 	wave tmp_TempStable = TempStable
 	wave tmp_CCN_Concentration = CCN_Concentration
 	wave tmp_CCN_Concentration_TStab = CCN_Concentration_TStab
 	wave tmp_CCN_Concentration_Clean = CCN_Concentration_Clean
 	
 	string wlist = "SS_Setting;TempStable;CCN_Concentration;CCN_Concentration_TStab;CCN_Concentration_Clean"
	for (i=0; i<itemsinlist(wlist); i+=1)
		wave w = $(stringfromlist(i,wlist))
		SetScale/P x V_min,1,"dat", w
		w = NaN
	endfor
	
	variable j
	for (j=0; j<numpnts(dtwave); j+=1)
		variable index = BinarySearch(tmp_ccn_dt,dtwave[j])
		if (index >=0)
			tmp_SS_Setting[index] = ss_set[j] 	
			tmp_TempStable[index] = tstab[j] 	
			tmp_CCN_Concentration[index] = conc[j] 	
			tmp_CCN_Concentration_TStab[index] = conc_tstab[j] 	
			tmp_CCN_Concentration_Clean[index] = conc_clean[j] 	
		endif
	endfor
	
	// combine with main dataset
	setdatafolder root:
	newdatafolder/o/s root:ccn_1sec_dan
	if (!waveexists(root:ccn_1sec_dan:ccn_datetime))
		duplicate/o tmp_ccn_dt ccn_datetime
	 	duplicate tmp_SS_Setting SS_Setting
	 	duplicate tmp_TempStable TempStable
	 	duplicate tmp_CCN_Concentration CCN_Concentration
	 	duplicate tmp_CCN_Concentration_TStab CCN_Concentration_TStab
	 	duplicate tmp_CCN_Concentration_Clean CCN_Concentration_Clean
	 	//make/o/n=(numpnts(tmp_ccn_dt)) ship_plume_flag
//	 	wave ship_plume_flag
//	 	ship_plume_flag = NaN
	else
		wave ccn_dt = :ccn_datetime
	 	wave SS_Setting
	 	wave TempStable
	 	wave CCN_Concentration
	 	wave CCN_Concentration_TStab
	 	wave CCN_Concentration_Clean
		duplicate/o  ccn_dt ccn_datetime_bak
	 	duplicate/o SS_Setting SS_Setting_bak
	 	duplicate/o TempStable TempStable_bak
	 	duplicate/o CCN_Concentration CCN_Concentration_bak
	 	duplicate/o CCN_Concentration_TStab CCN_Concentration_TStab_bak
	 	duplicate/o CCN_Concentration_Clean CCN_Concentration_Clean_bak
		
		wave bak_ccn_dt = ccn_datetime_bak				
	 	wave bak_SS_Setting = SS_Setting_bak
	 	wave bak_TempStable = TempStable_bak
	 	wave bak_CCN_Concentration = CCN_Concentration_bak
	 	wave bak_CCN_Concentration_TStab = CCN_Concentration_TStab_bak
	 	wave bak_CCN_Concentration_Clean = CCN_Concentration_Clean_bak
		
		WaveStats/Q bak_ccn_dt
		variable first_dt = V_min
		variable last_dt = V_max
		
		WaveStats/Q tmp_ccn_dt
		if (V_min < first_dt) 
			first_dt = V_min
		endif
		if (V_max >  last_dt) 
			last_dt = V_max
		endif
		
		make/o/D/n=(last_dt - first_dt + 1) ccn_datetime
		wave ccn_dt = :ccn_datetime
	 	duplicate/o ccn_dt SS_Setting
	 	duplicate/o ccn_dt TempStable
	 	duplicate/o ccn_dt CCN_Concentration
	 	duplicate/o ccn_dt CCN_Concentration_TStab
	 	duplicate/o ccn_dt CCN_Concentration_Clean
		
		wave ccn_dt = :ccn_datetime
		ccn_dt[0] = first_dt
		ccn_dt[1,] = ccn_dt[p-1] + 1
	 	wave SS_Setting
	 	wave TempStable
	 	wave CCN_Concentration
	 	wave CCN_Concentration_TStab
	 	wave CCN_Concentration_Clean

		for (i=0; i<itemsinlist(wlist); i+=1)
			wave w = $(stringfromlist(i,wlist))
			SetScale/P x first_dt,1,"dat", w
			w = NaN
		endfor
		
		index = BinarySearch(ccn_dt,bak_ccn_dt[0])
		SS_Setting[index,index+numpnts(bak_ccn_dt)-1] = bak_SS_Setting[p-index]
		TempStable[index,index+numpnts(bak_ccn_dt)-1] = bak_TempStable[p-index]
		CCN_Concentration[index,index+numpnts(bak_ccn_dt)-1] = bak_CCN_Concentration[p-index]
		CCN_Concentration_TStab[index,index+numpnts(bak_ccn_dt)-1] = bak_CCN_Concentration_TStab[p-index]
		CCN_Concentration_Clean[index,index+numpnts(bak_ccn_dt)-1] = bak_CCN_Concentration_Clean[p-index]
		
		index = BinarySearch(ccn_dt,tmp_ccn_dt[0])
		SS_Setting[index,index+numpnts(tmp_ccn_dt)-1] = tmp_SS_Setting[p-index]
		TempStable[index,index+numpnts(tmp_ccn_dt)-1] = tmp_TempStable[p-index]
		CCN_Concentration[index,index+numpnts(tmp_ccn_dt)-1] = tmp_CCN_Concentration[p-index]
		CCN_Concentration_TStab[index,index+numpnts(tmp_ccn_dt)-1] = tmp_CCN_Concentration_TStab[p-index]
		CCN_Concentration_Clean[index,index+numpnts(tmp_ccn_dt)-1] = tmp_CCN_Concentration_Clean[p-index]
	endif
	
//	//create Start_DateTime, AvePeriod and DOY
//	duplicate/O native0 Start_DateTime, AvePeriod
//	wave ccn_dt = Start_DateTime
//	ccn_dt = datewave[0] + timewave
//	AvePeriod[] = 1 // set to 1 second
//	datetime2doy_wave(ccn_dt,"DOY")
//	
//	// rename rest of waves
//	string list1 = "X1stStageVoltage;AbsolutePressure;ADC_Overflow;BinSetting;CCN_Concentration;"
//	string list2 = "LaserCurrnet;PropprtionalValveVolts;SampleFlow;SampleTemp;Sheath_Flow;SS_setting;"
//	string list3 = "T1;T2;T3;TempGradient;TempStable;T_inlet;T_Nafion;T_OPC"
//	string dslist = list1+list2+list3
//	
//	string nativeindex_list = "23;19;21;24;45;20;20;17;16;18;1;5;7;9;3;2;13;11;15"
//	
//	if (itemsinlist(dslist) != itemsinlist(nativeindex_list))
//		print "Error in stringlists!"
//		print "dslist = " + num2str(itemsinlist(dslist))
//		print "nativeindex_list = " + num2str(itemsinlist(nativeindex_list))
//		return -1
//	endif
//	
//	variable i
//	for (i=0; i<itemsinlist(dslist); i+=1)
//	
//		string ds = stringfromlist(i,dslist)
//		wave nat = $("native"+stringfromlist(i,nativeindex_list))
//		duplicate/o nat $ds 
//	
//	endfor
//	
//	//clean up	
//	for (i=0; i<47; i+=1)
//		killwaves/Z $("native"+num2str(i))
//	endfor
//	killwaves/Z nativedate0
	killpath/Z path_to_ccn
	setdatafolder root:
	//killdatafolder/Z "ccn_tmp_data_folder"
	setdatafolder sdf
	
	//done
End

Function ccn_filter_with_pfw(dfolder,key,out_wname)
	string dfolder
	string key
	string out_wname
	
	if (cmpstr(dfolder,"")==0)
		dfolder = ":"
	endif
	
	string sdf = getdatafolder(1)
	setdatafolder dfolder
	
	string wlist = acg_get_wave_list()
	
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		string wname = stringfromlist(i,wlist)

		if (!stringmatch(wname,"*datetime*") && !stringmatch(wname,"*date_time*"))
						
			print " working on ", wname
			print "     ", key
			//pfw_filter_wave($wname, key,0, 1)
			pfw_filter_wave($wname, key,out_wname, 1)
//			print "     SEASWEEP"
//			pfw_filter_wave($wname, "SEASWEEP",0, 1)
		endif
		
	endfor
	
	setdatafolder sdf
End
	
Function ccn_mono_generate_dp_vs_ss()
	print "generating dp vs. ss waves..."
	ccn_generate_dp_vs_ss_waves()
	print "generating dp vs. ss matrices..."
//	ccn_generate_dp_vs_ss_matrix(0)
	ccn_generate_dp_vs_ss_matrix()
	print "done."
End
	
Function ccn_generate_dp_vs_ss_waves()

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	// create folders
	newdatafolder/o/s dp_v_ss
	newdatafolder/o/s data
	
	// clean up any current waves as we will generate new values
	string wlist = acg_get_wave_list()
	ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list()
	ccn_reset_dp_v_ss_waves(wlist)
		
	wave dt = ::ccn_datetime
	wave ccn_clean = ::CCN_Concentration_Cleaned
	wave mono_cn = ::mono_cn_conc_shifted
//	wave mono_cn = ::mono_cn_conc
	duplicate/O mono_cn calc_ccn_cn_ratio
	wave ratio = calc_ccn_cn_ratio
	ratio = ccn_clean/mono_cn
	wave/T types = ::ccn_sample_type
	
	wave dp = ::zi_smps_dp_ccn_mono
	wave ss = ::SS_setting
	
	variable curr_dp = 0
	variable curr_dp_cnt = 0
	variable dp_cnt_thrshld = 3 // have to wait 30 seconds to let smps data "catch up"
	variable curr_ss = 0
	
	// create intermediate waves of dp,ss pairs
		
	variable dp_index, ss_index
	variable i,j,r
	make/o/d/n=0 tmp_datetime,tmp_ccn_conc, tmp_cn_conc, tmp_ccn_cn_ratio
	wave tmp_dt = tmp_datetime
	wave tmp_ccn = tmp_ccn_conc
	wave tmp_cn = tmp_cn_conc
	wave tmp_ratio = tmp_ccn_cn_ratio

	// process each dp,ss period for each sample type
	variable typ
	string samp_types=ccn_get_samp_type_list()	
	string curr_type
	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
		string sample_type = stringfromlist(typ,samp_types)
		for (i=0;i<numpnts(ratio); i+=1)			
//					if (ss[i] > 1.6)
//						variable/D test = 1.7
//						print "here " + num2str(ss[i])+num2str(ss[i])
//						print ss[i], str2num(num2str(ss[i]))
//						print (ss[i]==test)
//						print (str2num(num2str(ss[i]))==1.7)
//					endif

			if (ccn_valid_dp_ss_pair(dp[i], ss[i])) // if bad dp or ss skip altogether
	
				if (curr_dp == 0) 
					curr_dp = dp[i]
				endif
				
				if (curr_ss == 0)
					curr_ss = ss[i]
				endif
	
				if (curr_ss != ss[i]) // restart ss and dp
					
					// add current data to proper wave in :data
					if (i>0)
						ccn_append_dp_vs_ss_wave(curr_dp, curr_ss,tmp_dt, tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
						redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
					endif
					
					curr_type = types[i]
					curr_ss = ss[i]
					curr_dp = dp[i]
					curr_dp_cnt = 1
					if (curr_dp_cnt > dp_cnt_thrshld && cmpstr(sample_type,curr_type)==0)
//							if (cmpstr(curr_type,"NORMAL")==0)
//								print curr_type, i, r
//							endif
						r =0
						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
						tmp_dt[r] = dt[i]
						tmp_ccn[r] = ccn_clean[i]
						tmp_cn[r] = mono_cn[i]
						tmp_ratio[r] = ratio[i]
					endif
				else 
					if (curr_dp != dp[i])
						// add current data to proper wave in :data
						ccn_append_dp_vs_ss_wave(curr_dp, curr_ss,tmp_dt, tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
						redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
						
						curr_type = types[i]
						curr_dp = dp[i]
						curr_dp_cnt = 1
						if (curr_dp_cnt > dp_cnt_thrshld && cmpstr(sample_type,curr_type)==0)
//							if (cmpstr(curr_type,"NORMAL")==0)
//								print curr_type, i, r
//							endif
							r = 0
							redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
							tmp_dt[r] = dt[i]
							tmp_ccn[r] = ccn_clean[i]
							tmp_cn[r] = mono_cn[i]
							tmp_ratio[r] = ratio[i]
						endif
					else
						curr_type = types[i]
						curr_dp_cnt += 1
						if (curr_dp_cnt > dp_cnt_thrshld && cmpstr(sample_type,curr_type)==0)
//							if (cmpstr(curr_type,"NORMAL")==0)
//								print curr_type, i, r
//							endif
							
							r = numpnts(tmp_dt)
							redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
							tmp_dt[r] = dt[i]
							tmp_ccn[r] = ccn_clean[i]
							tmp_cn[r] = mono_cn[i]
							tmp_ratio[r] = ratio[i]
						endif
					endif
				endif				
			endif
		endfor
	endfor
	
	// create dp vs. SS matrix

	killwaves/Z ratio
	SetDataFolder dfr
End

// Set normalize = 1 to normalize ratio values by the max ratio in each Dp column. 
//       normalize = 0 for no normaliztion
//Function ccn_generate_dp_vs_ss_matrix(normalize)
//	variable normalize
//  *** changed 10/25/2017 to create seperate folder for normalized option. Also, changing normalized to an optional parameter
//         new way to call for normalizing: normalize="yes" or normalize="true"
Function ccn_generate_dp_vs_ss_matrix([normalize])
	string normalize

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss

	variable doNormalize = 0
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
	endif
	
	ccn_get_dp_list_as_wave("ccn_mono_dp")
	wave dp = $("ccn_mono_dp")
	string dp_list = ccn_mono_dp_list
//	make/T/o/n=(numpnts(dp)) ccn_mono_dp_txt_w
//	wave/T dp_txt = ccn_mono_dp_txt_w
//	make/o/n=(numpnts(dp)) ccn_mono_dp_index
//	wave dp_index = ccn_mono_dp_index
//	variable im
//	for (im=0; im<numpnts(dp); im+=1)
//		dp_txt[im] = stringfromlist(im,dp_list)
//		dp_index[im] = im
//	endfor
//	make/o/n=(numpnts(dp)+1) ccn_mono_dp_cnt_im
//	wave dp_cnt = ccn_mono_dp_cnt_im
//	dp_cnt[0] = -0.5
//	dp_cnt[,numpnts(dp_cnt)-1] = dp_cnt[p-1] + 1
	
	ccn_get_ss_list_as_wave("ccn_mono_ss")
	wave ss = $("ccn_mono_ss")
	string ss_list = ccn_mono_ss_list
//	make/T/o/n=(numpnts(ss)) ccn_mono_ss_txt_w
//	wave/T ss_txt = ccn_mono_ss_txt_w
//	make/o/n=(numpnts(ss)) ccn_mono_ss_index
//	wave ss_index = ccn_mono_ss_index
//	for (im=0; im<numpnts(ss); im+=1)
//		ss_txt[im] = stringfromlist(im,ss_list)
//		ss_index[im] = im
//	endfor
//	make/o/n=(numpnts(ss)+1) ccn_mono_ss_cnt_im
//	wave ss_cnt = ccn_mono_ss_cnt_im
//	ss_cnt[0] = -0.5
//	ss_cnt[,numpnts(ss_cnt)-1] = ss_cnt[p-1] + 1
	
	
	variable typ
	string samp_types=ccn_get_samp_type_list()	
	string curr_type
	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
		string sample_type = stringfromlist(typ,samp_types)

		if (doNormalize)
			newdatafolder/o/s :normalize
		endif

		string suffix
		if (cmpstr(sample_type,"")==0 || cmpstr(sample_type,"NORMAL")==0)
			suffix=""
		elseif (cmpstr(sample_type,"BAD")==0)
			continue
		else
			suffix="_"+sample_type
		endif

		make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
		wave ratio = $("ccn_cn_ratio"+suffix)
		wave ratio_sd = $("ccn_cn_ratio_sd"+suffix)
		ratio = nan
		ratio_sd=nan
		
		make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
		wave ccn = $("ccn_conc"+suffix)
		wave ccn_sd = $("ccn_conc_sd"+suffix)
		ccn = nan
		ccn_sd=nan
		
		make/o/n=(numpnts(ss),numpnts(dp)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
		wave cn = $("cn_conc"+suffix)
		wave cn_sd = $("cn_conc_sd"+suffix) 
		cn = nan
		cn_sd=nan

		if (doNormalize)
			setdatafolder "::"
		endif

		// get matrix values from data waves
		variable row,col
		for (row=0; row<numpnts(ss); row+=1)
			for (col=0; col<numpnts(dp); col+=1)
				string wname = ":data:" + ccn_generate_dp_vs_ss_name(dp[col],ss[row])
				wname+=suffix
				if (waveexists($wname))
					wave w_orig = $wname
					if (dimsize(w_orig,0) > 0)
						
						duplicate/o w_orig cgdvs_tmp_w
						ccn_clean_dp_v_ss_wave(cgdvs_tmp_w)
						wave w = cgdvs_tmp_w
						
						wavestats/Q w
						
						ccn[row][col] = util_matrix_wavestats_col(0,w,"V_avg") // ccn
						ccn_sd[row][col] =util_matrix_wavestats_col(1,w,"V_avg") // ccn_sd
						
						cn[row][col] = util_matrix_wavestats_col(2,w,"V_avg") // cn
						cn_sd[row][col] =util_matrix_wavestats_col(3,w,"V_avg") // cn_sd
	
						ratio[row][col] = util_matrix_wavestats_col(4,w,"V_avg") // ratio
						ratio_sd[row][col] =util_matrix_wavestats_col(5,w,"V_avg") // ratio_sd
	
	//					util_matrix_wavestats_col(2,w) // cn
	//					cn[row][col] = V_avg
	//					util_matrix_wavestats_col(3,w) // cn_sd
	//					cn_sd[row][col] = V_avg
	//
	//					util_matrix_wavestats_col(4,w) // cn
	//					ratio[row][col] = V_avg
	//					util_matrix_wavestats_col(5,w) // cn_sd
	//					ratio_sd[row][col] = V_avg
						
						killwaves/Z w
					endif
				endif
			endfor
		endfor
		wavestats/Q ratio
		if (V_npnts==0) // all nans
			killwaves/Z ratio,ratio_sd,ccn,ccn_sd,cn,cn_sd
		else
		
			// normalize ratio if "normalize=1"
//			if (normalize)
			if (doNormalize)
				make/o/n=(dimsize(ratio,0)) tmp_w
				for(col=0; col<dimsize(ratio,1); col+=1)
					tmp_w = ratio[p][col]
					wavestats/Q tmp_w
					variable wmax = V_max
					if (wmax > 0)
						tmp_w /= wmax
						ratio[][col] = tmp_w[p]
					endif
				endfor
				killwaves/Z tmp_w
			endif

		endif
	endfor
	
	// generate dp and ss waves for images
	wave w = $wname
	wave dp = ccn_mono_dp
	wave ss = ccn_mono_ss


	// leave all the dimension waves in the base directory to keep one version
//	if (doNormalize)
//		setdatafolder ":normalize"
//	endif

	make/o/n=(numpnts(dp)+1) ccn_mono_dp_im
	wave dp_im = ccn_mono_dp_im
	dp_im[0] = dp[0] - ( ((dp[0]+dp[1])/2) - dp[0] ) 
	dp_im[1,numpnts(dp_im)-2] = (dp[p-1] + dp[p])/2
	dp_im[numpnts(dp_im)-1] = dp[numpnts(dp)-1] + ( dp[numpnts(dp)-1] - ( (dp[numpnts(dp)-1] + dp[numpnts(dp)-2])/2) )
	
	//wave ss = ccn_mono_ss
	make/o/n=(numpnts(ss)+1) ccn_mono_ss_im
	wave ss_im = ccn_mono_ss_im
	ss_im[0] = ss[0] - ( ((ss[0]+ss[1])/2) - ss[0] ) 
	ss_im[1,numpnts(ss_im)-2] = (ss[p-1] + ss[p])/2
	ss_im[numpnts(ss_im)-1] = ss[numpnts(ss)-1] + ( ss[numpnts(ss)-1] - ( (ss[numpnts(ss)-1] + ss[numpnts(ss)-2])/2) )

	
	setdatafolder dfr
End

Function util_matrix_wavestats_col(col,w,param) 
	variable col
	wave w
	string param
	
	if (col >= dimsize(w,1))
		return 0
	endif
	
	make/o/n=(dimsize(w,0)) umwc_tmp_w
	wave tmp = umwc_tmp_w
	
	tmp = w[p][col]
	wavestats/Q tmp
	
	killwaves/Z tmp
	
	if (cmpstr(param,"V_avg")==0)
//		if (V_npnts == 0)
//			print "zero length"
//		endif
		return V_avg
	elseif (cmpstr(param,"V_sdev")==0)
		return V_sdev
	else
		return nan
	endif
	
End

Function ccn_clean_dp_v_ss_wave(w)
	wave w
		
	// the "user_nan" value is in the last column
	variable cols = dimsize(w,1)
	variable rows = dimsize(w,0)
	
	w[][0,cols-4] = (w[p][cols-1]>0) ? NaN : w[p][q]
		
	
End

Function ccn_get_dp_list_as_wave(wname)
	string wname // name of created wave
	string dp_list= ccn_mono_dp_list
	variable cnt = itemsinlist(dp_list)
	make/o/n=(cnt) $wname
	wave w = $wname
	
	variable i
	for (i=0; i<cnt; i+=1)
		w[i] = str2num(stringfromlist(i,dp_list))
	endfor
End

Function ccn_get_ss_list_as_wave(wname)
	string wname // name of created wave
	string ss_list= ccn_mono_ss_list
	variable cnt = itemsinlist(ss_list)
	make/o/n=(cnt) $wname
	wave w = $wname
	
	variable i
	for (i=0; i<cnt; i+=1)
		w[i] = str2num(stringfromlist(i,ss_list))
	endfor

End

Function ccn_valid_dp(dp)

	variable dp
	//string dp_list= "20;30;40;50;60;62;80"
	string dp_list= ccn_mono_dp_list
	variable response=0
	string dp_str = num2str(dp)
	
	if ( FindListItem(dp_str,dp_list) >= 0 ) 
		response = 1
	endif
	
	return response
End

Function ccn_fix_ss_to_standard(ss)
	wave ss
	string ss_list = ccn_mono_ss_list
	make/o/n=(ItemsInList(ss_list)) tmp_ss_vals
	wave tmp_ss = tmp_ss_vals
	variable r
	for (r=0; r<itemsinlist(ss_list); r+=1)
		tmp_ss[r] = str2num(stringfromlist(r,ss_list))
	endfor
		
	//ss*=100
	//ss=floor(ss)/100
	
	variable i,j
	for (j=0; j<numpnts(ss); j+=1)
		for (i=0; i<numpnts(tmp_ss); i+=1)
			if ( (ss[j]>=tmp_ss[i]-0.03) && (ss[j]<=tmp_ss[i]+0.03) )
				ss[j] = tmp_ss[i]
				continue
			endif
		endfor
	endfor
End
	

Function ccn_valid_ss(ss)
	variable ss
	//string ss_list = "0.1;0.2;0.3;0.4;0.5;0.6;0.7;0.8;0.9;1.0;1.1;1.2;1.3;1.4;1.5;1.6;1.7;1.8"
	string ss_list = ccn_mono_ss_list
//	make/o/n=(ItemsInList(ss_list)) tmp_ss_vals
//	wave tmp_ss = tmp_ss_vals
//	tmp_ss = str2num(stringfromlist(p,ss_list))
//	
	variable response=0
//	//ss*=100
//	//ss=floor(ss)/100
//	
//	variable i
//	for (i=0; i<numpnts(tmp_ss); i+=1)
//		if ( (ss>=tmp_ss[i]-0.03) && (ss<=tmp_ss[i]+0.03) )
//			return 1
//		endif
//	endfor
//	return 0
	
 	string ss_str = num2str(ss)
//	if (ss > 1.68)
//		print "here"
//	endif
	if ( FindListItem(ss_str,ss_list) >= 0 ) 
		response = 1
	endif
	
	return response
End

Function ccn_valid_dp_ss_pair(dp,ss)
	variable dp
	variable ss
	
	variable response=0
	
	response = ccn_valid_dp(dp) && ccn_valid_ss(ss)
	
	return response
End
	
Function ccn_append_dp_vs_ss_wave(dp, ss, dt, ccn, cn, ratio, [type])
	variable dp
	variable ss
	wave dt
	wave ccn
	wave cn
	wave ratio
	string type
	
	string suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		suffix=""
		type = "NORMAL"
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else		
		suffix="_"+type
	endif
	
	// changed from 8 to 10 to include start and stop times for each point 23May2014
	//variable cols = 8  // number of colums for each pair
	variable cols = 10 // number of colums for each pair
	
//	if (ss==1.7)
//		print ss, dp
//		print type
//	endif
		
	// check if valid again? Should not be possible but just in case
	if (!ccn_valid_dp_ss_pair(dp, ss))
		return 0
	endif
	
	if (numpnts(ratio)==0) // check if no data in tmp waves
		return 0
	endif
	
	// create wave if not present
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss:data
	
	string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	wname += suffix
	if (!waveexists($wname))
		make/D/n=(0,cols) $wname
		make/D/n=0 $(wname+"_dt")
	endif
	wave w = $wname
	wave w_dt = $(wname+"_dt")
	variable curr_row = dimsize(w,0)
	redimension/n=(curr_row+1,cols) w
	redimension/n=(curr_row+1) w_dt
	
	wavestats/Q dt
	w_dt[curr_row] = V_avg
	w[curr_row][7] = V_min  // start time
	if (V_max < V_min)
		w[curr_row][8] = V_avg
	else
		w[curr_row][8] = V_max // stop time
	endif
	//print V_avg, V_min, V_max

	wavestats/Q ccn
	w[curr_row][0] = V_avg
	w[curr_row][1] = V_sdev
		
	wavestats/Q cn
	w[curr_row][2] = V_avg
	w[curr_row][3] = V_sdev

	wavestats/Q ratio
	w[curr_row][4] = V_avg
	w[curr_row][5] = V_sdev
	w[curr_row][6] = V_npnts
	
	// set user_nan = 0 as default
	w[curr_row][9] = 0
	
	acg_wn_set_note_with_key(w,"SAMPLE_TYPE",type)
	
	setdatafolder dfr
End

Function ccn_reset_dp_v_ss_waves(list)
	string list
	
	variable i
	for (i=0; i<itemsinlist(list); i+=1)
		wave w = $(stringfromlist(i,list))
		variable c = dimsize(w,1)
		redimension/n=(0,c) w
	endfor
End

Function/S ccn_generate_dp_vs_ss_name(dp,ss)
	variable dp
	variable ss

	string wname = "dp_"+num2str(dp)+"_ss_"+num2str(ss)
	wname = replacestring(".",wname,"_")
	return wname
End

Function ccn_mono_shift_cn(init)
	variable init
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	variable default_offset = 0
	if (init)
		duplicate/o mono_cn_conc mono_cn_conc_shifted, mono_cn_offset, mono_ccn_cn_ratio_shifted
	endif
	
	wave cn = mono_cn_conc
	wave cn_shift = mono_cn_conc_shifted
	wave offset = mono_cn_offset
	wave ccn = CCN_Concentration_Cleaned
	wave ratio_shift = mono_ccn_cn_ratio_shifted
	
	if (init)
		offset = default_offset
	endif
	
	cn_shift = cn[p+offset[p]]
	cn_shift = (cn_shift[p] < mono_cn_lower_limit) ? NaN : cn_shift[p]
	ratio_shift = ccn/cn_shift
		
	setdatafolder dfr
End

Function ccn_set_mono_cn_oset_marq_cust()

	Variable offset=0
	Prompt offset, "Enter offset value: "
	DoPrompt "Enter Offset", offset
	if (V_Flag)
		return -1
	endif
	//ccn_set_mono_cn_offset_marquee(offset)
End

Function ccn_set_mono_cn_offset_marquee(offset,[isCustom])
	variable offset
	variable isCustom
	
	if (ParamIsDefault(isCustom))
		isCustom=0
	endif


	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	GetMarquee/K/Z bottom
	wave avg_dt= ccn_datetime
	print BinarySearchInterp(avg_dt,V_left)
	print BinarySearchInterp(avg_dt,V_right)
	variable starti = round(BinarySearchInterp(avg_dt,V_left))
	variable stopi = round(BinarySearchInterp(avg_dt,V_right))
	wave offset_w = mono_cn_offset

	if (isCustom)
		Prompt offset, "Enter offset value: "
		DoPrompt "Enter Offset", offset
		if (V_Flag)
			return -1
		endif
	endif

	offset_w[starti,stopi] = offset
	
	ccn_mono_shift_cn(0)
		
	setdatafolder dfr
End

Function ccn_toggle_dp_v_ss_nan_marquee(isNaN)
	variable isNaN  // 0 = reset, 1 =NaN

	GetMarquee/K/Z bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist

	dfref dfr = GetDataFolderDFR()	
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss:data

	variable dt_index
	variable i
	for (i=0; i<dimsize(wlist,0); i+=1)
		if (stringmatch(wlist[i][0],"*_dt"))
			dt_index = i
			break
		endif
	endfor
	
	variable w_index = (dt_index) ? 0 : 1
	
	wave w = $wlist[w_index][0]
	variable nan_col = dimsize(w,1)-1
	
	wave dt = $wlist[dt_index][0]	
	variable rows = numpnts(dt)

	
//	wave w = $wlist[0][0]
//	variable nan_col = dimsize(w,1)-1
//	
//	wave dt = $wlist[1][0]	
//	variable rows = numpnts(dt)
//	
//	variable i
	wave/T db = ccn_get_nan_db()
	for (i=0; i<rows; i+=1)
		if (dt[i] >= left && dt[i] <= right)
			w[i][nan_col] = isNaN
			ccn_sync_wave_nan_by_row(db,w,i,isNaN)
			
			// added to save NaN'd values as BAD
			if (isNan)
				ccn_set_range_type(w[i][7],w[i][8],"BAD")
			else
				ccn_set_range_type(w[i][7],w[i][8],acg_wn_get_note_with_key(w,"SAMPLE_TYPE"))
			endif
			
		endif
	endfor
	
	if (auto_update_matrix)
		ccn_generate_dp_vs_ss_matrix(normalize=default_normalize)
	endif
	
	setdatafolder dfr
End

Function ccn_set_range_type(start_dt,stop_dt,stype)
	variable start_dt
	variable stop_dt
	string stype
	
	dfref dfr = GetDataFolderDFR()
	
	setdatafolder ccn_data_folder
	wave dt = ccn_datetime
	
	variable starti = round(BinarySearchInterp(dt,start_dt))
	starti = (numtype(starti)>0) ? 0 : starti
	variable stopi = round(BinarySearchInterp(dt,stop_dt))
	stopi = (numtype(stopi)>0) ? numpnts(dt)-1 : stopi

	wave/T type = ccn_sample_type
	type[starti,stopi] = stype
	
	ccn_generate_samp_type_index(0)
	
	setdatafolder dfr
	
	ccn_set_range_type_dev(start_dt,stop_dt,stype)
	
End

Function ccn_set_sample_type_marquee()
	
	GetLastUserMenuInfo
	string stype = S_value
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	GetMarquee/K/Z bottom
	wave dt= ccn_datetime
	
//	print BinarySearchInterp(avg_dt,V_left)
//	print BinarySearchInterp(avg_dt,V_right)
	variable starti = round(BinarySearchInterp(dt,V_left))
	starti = (numtype(starti)>0) ? 0 : starti
	variable stopi = round(BinarySearchInterp(dt,V_right))
	stopi = (numtype(stopi)>0) ? numpnts(dt)-1 : stopi
	wave/T type = ccn_sample_type
	type[starti,stopi] = stype
	
	ccn_generate_samp_type_index(0)
	
	setdatafolder dfr
End

Function/S ccn_get_samp_type_list()
	String list = ""
	list = "BAD;NORMAL;"+ccn_samp_type_list // always prepend with BAD so bad values are index=0
	return list
End

Function ccn_init_samp_type_waves()

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder

	if (!waveexists(ccn_sample_type))

		string list = ccn_get_samp_type_list()
		wave ccn = CCN_Concentration_Cleaned
	
		make/T/n=(numpnts(ccn)) ccn_sample_type
		wave/T type = ccn_sample_type
		type=stringfromlist(1,list) // init to NORMAL
	
		ccn_generate_samp_type_index(0)

	endif

	setdatafolder dfr
	
End

Function/DF ccn_goto_conf_folder()

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	if (!datafolderexists("config"))
		newdatafolder/o/s config
	else
		setdatafolder :config
	endif
	
	return dfr
End

Function/S ccn_get_sample_type_groups()

	dfref dfr = ccn_goto_conf_folder()
	
	if (!exists("sample_type_group_list"))
		string/G sample_type_group_list = ""
	endif
	
	SVAR list = sample_type_group_list
	
	setdatafolder dfr	

	return list
	
End

Function ccn_set_sample_type_groups(group_list)
	string group_list
	
	dfref dfr = ccn_goto_conf_folder()
	
	if (!exists("sample_type_group_list"))
		string/G sample_type_group_list = group_list
	endif
	
	SVAR list = sample_type_group_list
	list = group_list
	
	setdatafolder dfr	
	
End

Function ccn_get_sample_type_group_keys()

End

Function ccn_print_sample_type_groups()

	string list = ccn_get_sample_type_groups()
	
End

Function ccn_add_sample_type_group(group_id, type_list, replace)
	string group_id
	string type_list
	variable replace // -1 dialog, 0 no, 1 yes
	
	string group_list = ccn_get_sample_type_groups()
	
	string test = stringbykey(group_id,group_list,":","%")
	if (cmpstr(test,"") != 0 ) // means a group specified by group_id already exists
		if (replace == 0)
			print "Group: " + group_id + " already exists. Aborted"
			return 0
		elseif (replace == 1)
			print "Group: " + group_id + " already exists. Replacing with new group."
			group_list = replacestringbykey(group_id,group_list,type_list,":","%")			
		endif
	else
		group_list = replacestringbykey(group_id,group_list,type_list,":","%")
	endif
	ccn_set_sample_type_groups(group_list)
	
End

// ***** ccn_change_samp_types *****
//
// Description: 
//    Helper function to change sample types and their indices after the fact. Original intent was to allow for underway
// types to be used and then change them after the fact as the picture becomes clearer.
//
// Steps:
// 	1) Need a delimited file with at least 6 columns: 
//		- Start (date time format) - start of defined period to change sample types
//		- Stop (date time format) - end of defined period to change sample types
//		- new_sample_type (string)
//		- new_index (integer) - first index value should be 2
//		- old_index (integer)
//  		- old_sample_type (string)
//	2) load waves into root:ccn:new_sample_types folder
//	3) copy current samp_type_list into: strconstant ccn_samp_type_list_old
//	4) create new: strconstant ccn_samp_type_list_new using sample types defined in delimited file
// 	5) run: ccn_change_samp_types()
//		- copies current sample_type and index waves into working folder
//		- creates new version of each wave and initializes to BAD
//		- sets each time period to new sample type and index
//		- resets all BAD types in those time periods based on old values
// 	6) archive current sample type and index waves (optional but suggested)
//	7) run: duplicate/o ccn_sample_type_new ::ccn_sample_type  ** this needs to be done manually after verifying changes are correct.
// 	8) change: strconstant ccn_samp_type_list to new list string containing new sample types
//	9) run: ccn_generate_samp_type_index(0) - this will generate index wave based on new sample types
// 	10) regenerate dp_vs_ss waves and matrices
//
// *****
Function ccn_change_samp_types()
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :new_sample_types
	
	duplicate/o/T ::ccn_sample_type ccn_sample_type_old
	wave/T old_types = ccn_sample_type_old
	duplicate/o/T ::ccn_sample_type ccn_sample_type_new
	wave/T new_types = ccn_sample_type_new
	
	duplicate/o ::ccn_sample_type_index ccn_sample_type_index_old
	wave old_indices = ccn_sample_type_index_old
	duplicate/o ::ccn_sample_type_index ccn_sample_type_index_new
	wave new_indices = ccn_sample_type_index_new

	// initialize new waves to BAD/0
	new_types = "BAD"
	new_indices = 0
	
	wave new_index_values = new_index
	wave/T new_sample_type_values = new_sample_type
	wave old_index_values = old_index
	wave/T old_sample_type_values = old_sample_type
	
	wave start_dt = Start
	wave stop_dt = Stop
	
	string new_sample_list = ccn_samp_type_list_new 
	
	variable i	
	for (i=0; i<numpnts(start_dt); i+=1)
		variable startx=x2pnt(old_types, start_dt[i] )
		variable stopx=x2pnt(old_types, stop_dt[i] )
	
		new_types[startx,stopx] = new_sample_type_values[i]
		new_indices[startx,stopx] = new_index_values[i]
		
	endfor
	
	// reapply all the old BAD values
	for (i=0; i<numpnts(new_indices); i+=1)
		if (old_indices[i] == 0)
			//print old_index[i]
			new_indices[i] = 0
			new_types[i] = "BAD"
		endif
	endfor
	
	setdatafolder dfr
End


Function ccn_generate_samp_type_index(force)
	variable force 
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	string list = ccn_get_samp_type_list()
	wave/T types = ccn_sample_type
	if (!waveexists(ccn_sample_type_index) || force)
		wave dt = ccn_datetime
		make/o/n=(numpnts(types)) ccn_sample_type_index
		wave tmp = ccn_sample_type_index
		SetScale/P x dt[0],ccn_avg_period,"dat", tmp
	endif
	wave index = ccn_sample_type_index
	variable i,j
//	for (j=2570; j<numpnts(types); j+=1)
	for (i=0; i<itemsinlist(list); i+=1)
//			print stringfromlist(i,list), types[j]
//			if (cmpstr(stringfromlist(i,list),types[j])==0)
//				if (cmpstr(stringfromlist(i,list),"CAL_SULF")==0)
//					print "here"
//				endif
//				index[j] = i
//			endif
//		endfor	
		index = (cmpstr(stringfromlist(i,list),types[p])==0) ? i : index[p]
	endfor	
	
	setdatafolder dfr
End

Function ccn_plot_dp_ss_pair(dp,ss,[type])
	variable dp
	variable ss
	string type
	
	string prefix, suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		prefix=""
		suffix=""
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else
		prefix=type+": "		
		suffix="_"+type
	endif
	
	variable def_max_conc = 1000
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss:data

	string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	wname += suffix
	wave w = $wname
	wave dt = $(wname+"_dt")
	
	if (!waveexists(w) || !waveexists(dt))
		return 0
	endif

	display w[][2] vs dt
	DelayUpdate
	ModifyGraph mode($wname)=3,marker($wname)=19
	ModifyGraph axisEnab(left)={0,0.3},lblPosMode(left)=1,freePos(left)=0
	ErrorBars $wname Y,wave=(w[*][3],w[*][3])
	Label left "CN"
	SetAxis left 0,def_max_conc

	AppendToGraph/L=ccn w[][0] vs dt
	ModifyGraph mode($(wname+"#1"))=3,marker($(wname+"#1"))=19,rgb($(wname+"#1"))=(0,15872,65280)
	ModifyGraph axisEnab(ccn)={0.35,0.65},lblPosMode(ccn)=1,freePos(ccn)=0
	ErrorBars $(wname+"#1") Y,wave=(w[*][1],w[*][1])
	Label ccn "CCN"
	SetAxis ccn 0,def_max_conc

	AppendToGraph/L=ratio w[][4] vs dt
	ModifyGraph mode($(wname+"#2"))=3,marker($(wname+"#2"))=19,rgb($(wname+"#2"))=(0,39168,0)
	ModifyGraph axisEnab(ratio)={0.7,1},lblPosMode(ratio)=1,freePos(ratio)=0
	ErrorBars $(wname+"#2") Y,wave=(w[*][5],w[*][5])
	Label ratio "CCN/CN"
	SetAxis ratio 0,1.2
	ModifyGraph grid(ratio)=1

	AppendToGraph/R=flag w[][9] vs dt
	ModifyGraph lblPosMode(flag)=1,freePos(flag)=0
	ModifyGraph mode=3
	ModifyGraph axisEnab(flag)={0,0.3}
	SetAxis flag 0.1,1
	ModifyGraph marker($(wname+"#3"))=16
	ModifyGraph rgb($(wname+"#3"))=(0,0,0)
	Label flag "User NaN"
	
	string txt = prefix + "Dp="+num2str(dp)+"nm, SS="+num2str(ss)+"%"
	TextBox/C/N=text1/H={0,10,10}/A=RC txt	
	
	DoUpdate
	
	setdatafolder dfr
End

Function ccn_plot_dp_ss_surface(param,[type,normalize])
	string param
	string type
	string normalize

	string prefix, suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		prefix=""
		suffix=""
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else
		prefix=type+": "		
		suffix="_"+type
	endif

	variable doNormalize = 0
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
	endif
		
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss

	string wname = "ccn_cn_ratio"
	string title = "CCN/CN ratio"
	variable cbar_range = 1
	if (cmpstr(param,"ccn")==0)
		wname = "ccn_conc"
		title = "CCN Concentration"
		cbar_range = 0
	elseif (cmpstr(param,"cn")==0)
		wname = "cn_conc"
		title = "CN Concentration"
		cbar_range = 0
	endif
	wname += suffix
	title = prefix + title
	
	if (doNormalize)
		setdatafolder $":normalize"
	endif
	
	if (!waveexists($wname))
		print "no matrix: " + wname + " exists!"
		return 0
	endif
	
	wave w = $wname

	if (doNormalize)
		setdatafolder ::
	endif
	
//	wave dp = ccn_mono_dp
//	make/o/n=(numpnts(dp)+1) ccn_mono_dp_im
//	wave dp_im = ccn_mono_dp_im
//	dp_im[0] = dp[0] - ( ((dp[0]+dp[1])/2) - dp[0] ) 
//	dp_im[1,numpnts(dp_im)-2] = (dp[p-1] + dp[p])/2
//	dp_im[numpnts(dp_im)-1] = dp[numpnts(dp)-1] + ( dp[numpnts(dp)-1] - ( (dp[numpnts(dp)-1] + dp[numpnts(dp)-2])/2) )
//	
//	wave ss = ccn_mono_ss
//	make/o/n=(numpnts(ss)+1) ccn_mono_ss_im
//	wave ss_im = ccn_mono_ss_im
//	ss_im[0] = ss[0] - ( ((ss[0]+ss[1])/2) - ss[0] ) 
//	ss_im[1,numpnts(ss_im)-2] = (ss[p-1] + ss[p])/2
//	ss_im[numpnts(ss_im)-1] = ss[numpnts(ss)-1] + ( ss[numpnts(ss)-1] - ( (ss[numpnts(ss)-1] + ss[numpnts(ss)-2])/2) )
	
	Display;AppendImage w vs {ccn_mono_ss_im,ccn_mono_dp_im}
	DelayUpdate
	if (cbar_range)
		ModifyImage $wname ctab= {0,1,Rainbow,1}
	else
		ModifyImage $wname ctab= {*,*,Rainbow,1}
	endif
	Label left "Dp (nm)"
	Label bottom "SS (%)"
	ModifyGraph minor(bottom)=1
	
	ColorScale/C/N=cbar/H={0,10,10}/A=RC image=$wname
	ColorScale/C/N=cbar/X=5.00/Y=0.00
	
	TextBox/C/N=text1/H={0,10,10} title
	
	DoUpdate
	
	setdatafolder dfr
End

Function ccn_plot_dp_activation(diam,[normalize])
	variable diam
	string normalize
		
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss

	variable doNormalize = 0
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
	endif

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {19,16,17,14,60, 2}

	string samp_type = ccn_get_samp_type_list()
	//string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	//wname += suffix
	variable i
	variable curve_cnt = 0
	for (i=1; i<itemsinlist(samp_type); i+=1)
		string suffix = stringfromlist(i,samp_type)
		if (cmpstr(suffix,"NORMAL")==0)
			suffix = ""
		else
			suffix = "_"+suffix
		endif
		string wname = "ccn_cn_ratio"+suffix
		string wname_sd = "ccn_cn_ratio_sd"+suffix
		if (waveexists($wname)) 

			if (doNormalize)
				setdatafolder $":normalize"
			endif

			wave w = $wname
			wave w_sd = $wname_sd

			if (doNormalize)
				setdatafolder ::
			endif
			
			wave dp = ccn_mono_dp
			wave ss = ccn_mono_ss
			
			// find proper column
			variable j
			variable dp_col = -1
			for (j=0; j<numpnts(dp); j+=1)
				if (dp[j] == diam)
					dp_col = j
					break
				endif
			endfor
			if (dp_col<0 || dp_col>=dimsize(w,1))
				return 0
			endif
			
			if (curve_cnt == 0)
				display w[][dp_col] vs ss
			else
				AppendToGraph w[][dp_col] vs ss
			endif
			DelayUpdate
			ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
			ModifyGraph marker($wname)=mrk[curve_cnt]
			SetAxis left 0,1
			ModifyGraph grid(left)=1
			ModifyGraph grid=1
			ModifyGraph gaps($wname)=0
			Legend/C/N=text0/H={0,10,10}/A=LT
			string title = "D\\Bp\\M = " + num2str(diam) + "nm"
			if (doNormalize)
				title += " (normalized)"
			endif
			TextBox/C/N=text1/H={0,10,10} title
			Label left "CCN/CN Ratio"
			Label bottom "SS (%)"
			
			ErrorBars $wname Y,wave=(w_sd[*][dp_col],w_sd[*][dp_col])
			
			DoUpdate		
			curve_cnt+=1

		endif
	endfor		

	setdatafolder dfr
End

Function ccn_plot_ss_activation(supersat,[normalize])
	variable supersat
	string normalize
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :dp_v_ss

	variable doNormalize = 0
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
	endif

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {39168,39168,39168}, {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {2,19,16,17,14,60}

	string samp_type = ccn_get_samp_type_list()
	//string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	//wname += suffix
	variable i
	variable curve_cnt = 0
	for (i=1; i<itemsinlist(samp_type); i+=1)
		string suffix = stringfromlist(i,samp_type)
		if (cmpstr(suffix,"NORMAL")==0)
			suffix = ""
		else
			suffix = "_"+suffix
		endif
		string wname = "ccn_cn_ratio"+suffix
		string wname_sd = "ccn_cn_ratio_sd"+suffix
		if (waveexists($wname)) 

			if (doNormalize)
				setdatafolder $":normalize"
			endif

			wave w = $wname
			wave w_sd = $wname_sd

			if (doNormalize)
				setdatafolder ::
			endif
			
			wave dp = ccn_mono_dp
			wave ss = ccn_mono_ss
			
			// find proper row
			variable j
			variable ss_row = -1
			for (j=0; j<numpnts(ss); j+=1)
				if (str2num(num2str(ss[j]))==str2num(num2str(supersat)))
					ss_row = j
					break
				endif
			endfor
			if (ss_row<0 || ss_row>=dimsize(w,0))
				return 0
			endif
			
			if (curve_cnt == 0)
				display w[ss_row][] vs dp
			else
				AppendToGraph w[ss_row][] vs dp
			endif
			DelayUpdate
			ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
			ModifyGraph marker($wname)=mrk[curve_cnt]
			SetAxis left 0,1
			ModifyGraph grid(left)=1
			ModifyGraph grid=1
			ModifyGraph gaps($wname)=0
			Legend/C/N=text0/H={0,10,10}/A=LT
			string title = "SS = " + num2str(supersat) + "%"
			if (doNormalize)
				title += " (normalized)"
			endif
			TextBox/C/N=text1/H={0,10,10} title
			Label left "CCN/CN Ratio"
			Label bottom "D\\Bp\\M (nm)"
			
			ErrorBars $wname Y,wave=(w_sd[ss_row][*],w_sd[ss_row][*])
			
			DoUpdate		
			curve_cnt+=1

		endif
	endfor		

	setdatafolder dfr
End

Function ccn_mono_save_cleaned()
	variable init
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder

	wave dt = ccn_datetime
	wave ratio_shift = mono_ccn_cn_ratio_shifted
	wave dp = zi_smps_dp_ccn_mono
	wave ss = SS_setting
	wave/T type = ccn_sample_type
	wave index = ccn_sample_type_index
	
	variable refNum
	Open/D refNum
	print "filename = ", S_fileName
	if (cmpstr(S_fileName,"")==0)
		return 0 // user cancelled
	endif
	
	string fname = S_fileName
	Open/Z refNum as fname
	variable err = V_flag
	if (err != 0)
		Close/A
		Open refNum as fname
	endif
	
	fprintf refNum, "DateTime, ccn_cn_ratio, ss_setting, sample_type, sample_type_index\r\n"
	
	variable i
	for (i=0; i<numpnts(dt); i+=1)
//	for (i=0; i<200; i+=1)

		if (ccn_valid_dp_ss_pair(dp[i],ss[i]) && (cmpstr(type[i],"BAD") !=0) )  
			string dt_str =  secs2date(dt[i],-2) + " " + secs2time(dt[i],3)
			fprintf refNum, "%s, %g, %g, %s, %d\r\n", dt_str, ratio_shift[i], ss[i], type[i], index[i]
		endif
	endfor 
	Close refNum
	 
	setdatafolder dfr
End

// Spectra functions

Function ccn_spectra_generate_ss_waves()

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	// create folders
	newdatafolder/o/s spectra_ss
	newdatafolder/o/s data
	
	// clean up any current waves as we will generate new values
	string wlist = acg_get_wave_list()
	ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list()
	ccn_reset_dp_v_ss_waves(wlist)


	wave dt = ::ccn_datetime
	wave ccn_clean = ::CCN_Concentration_Cleaned
	wave/T types = ::ccn_sample_type

// added 9 Nov 2015 - use cn_residual for H cases

      variable use_cn_residual = 1
      string cn_mono_name = "::mono_cn_conc_shifted"
      if (use_cn_residual)
      		make/o/n=(numpnts(dt)) $("::cn_mono_res_combo")
      		wave cn_combo = $("::cn_mono_res_combo")
      		string st=ccn_get_samp_type_list()
      		string st_H = ""
      		variable t
      		
      		// get H types indicated by _H in the name
      		for (t=0; t<itemsinlist(st); t+=1)
      			string st_name = stringfromlist(t,st)
      			If (stringmatch(st_name,"*_H")==1)
      				st_H = addlistitem(st_H,st_name)
      			endif
      		endfor
      		
      		wave cn_U = ::mono_cn_conc_shifted
      		wave cn_H = root:cn_residual:avg_10:cn_residual_cpc_ccn
      		for (t=0; t<numpnts(dt); t+=1)
//      			string curr_st = stringfromlist(types[i],st)
      			if (FindListItem(types[t],st_H) >= 0)
      			 	cn_combo[t] = cn_H[t]
      			else
      				cn_combo[t] = cn_U[t]
      			endif
      		endfor
      		
      		cn_mono_name = "::cn_mono_res_combo"
      	endif
      		
	//wave mono_cn = ::mono_cn_conc_shifted
	wave mono_cn = $cn_mono_name



//	wave mono_cn = ::mono_cn_conc
	duplicate/O mono_cn calc_ccn_cn_ratio
	wave ratio = calc_ccn_cn_ratio
	ratio = ccn_clean/mono_cn
	
	//wave dp = ::zi_smps_dp_ccn_mono
	wave ss = ::SS_setting
	
	//variable curr_dp = 0
	//variable curr_dp_cnt = 0
	//variable dp_cnt_thrshld = 3 // have to wait 30 seconds to let smps data "catch up"
	variable curr_ss = 0
	
	// create intermediate waves of ss by type
		
	//variable dp_index, ss_index
	variable ss_index
	variable i,j,r
	make/o/d/n=0 tmp_datetime,tmp_ccn_conc, tmp_cn_conc, tmp_ccn_cn_ratio
	wave tmp_dt = tmp_datetime
	wave tmp_ccn = tmp_ccn_conc
	wave tmp_cn = tmp_cn_conc
	wave tmp_ratio = tmp_ccn_cn_ratio

	// process each ss period for each sample type
	variable typ
	string samp_types=ccn_get_samp_type_list()	
	string curr_type = ""
	variable has_data = 0
	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
		string sample_type = stringfromlist(typ,samp_types)
		for (i=0;i<numpnts(ratio); i+=1)			
//					if (ss[i] > 1.6)
//						variable/D test = 1.7
//						print "here " + num2str(ss[i])+num2str(ss[i])
//						print ss[i], str2num(num2str(ss[i]))
//						print (ss[i]==test)
//						print (str2num(num2str(ss[i]))==1.7)
//					endif
			
//			if (ss[i] == 0.2 && cmpstr(sample_type,types[i])==0 && cmpstr(sample_type,"NaCl_U")==0)
			if (i==127577)
				print ss[i], types[i], sample_type, typ
			endif


			//if (ccn_valid_dp_ss_pair(dp[i], ss[i])) // if bad dp or ss skip altogether
			if (ccn_valid_ss(ss[i])) // if bad ss skip altogether
					
				if (curr_ss == 0)
					curr_ss = ss[i]
				endif
				if (cmpstr(curr_type,"")==0)
					curr_type = types[i]
				endif
	
				if (curr_ss != ss[i] || cmpstr(curr_type,types[i])!=0) // restart ss
					
					// add current data to proper wave in :data
					if (i>0)
						ccn_spectra_append_ss_wave(curr_ss,tmp_dt, tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
						redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
						has_data=0
					endif
					
					curr_type = types[i]
					curr_ss = ss[i]
					if (cmpstr(sample_type,curr_type)==0)
						r =0
						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
						tmp_dt[r] = dt[i]
						tmp_ccn[r] = ccn_clean[i]
						tmp_cn[r] = mono_cn[i]
						tmp_ratio[r] = ratio[i]
					endif
				else 
					curr_type = types[i]
					if (cmpstr(sample_type,curr_type)==0)
						r = numpnts(tmp_dt)
						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
						tmp_dt[r] = dt[i]
						tmp_ccn[r] = ccn_clean[i]
						tmp_cn[r] = mono_cn[i]
						tmp_ratio[r] = ratio[i]
						has_data = 1
					endif
				endif				
			else
				if (has_data)
					ccn_spectra_append_ss_wave(curr_ss,tmp_dt, tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
					redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
					has_data = 0
				endif
			endif
		endfor
	endfor
	
	// create dp vs. SS matrix

	killwaves/Z ratio
	SetDataFolder dfr
End

//Function ccn_spectra_generate_ss_waves()
//
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
//	
//	// create folders
//	newdatafolder/o/s spectra_ss
//	newdatafolder/o/s data
//	
//	// clean up any current waves as we will generate new values
//	string wlist = acg_get_wave_list()
//	ccn_reset_dp_v_ss_waves(wlist)
//	setdatafolder ::
//	wlist = acg_get_wave_list()
//	ccn_reset_dp_v_ss_waves(wlist)
//		
//	wave dt = ::ccn_datetime
//	wave ccn_clean = ::CCN_Concentration_Cleaned
//	wave mono_cn = ::mono_cn_conc_shifted
////	wave mono_cn = ::mono_cn_conc
//	duplicate/O mono_cn calc_ccn_cn_ratio
//	wave ratio = calc_ccn_cn_ratio
//	ratio = ccn_clean/mono_cn
//	wave/T types = ::ccn_sample_type
//	
//	//wave dp = ::zi_smps_dp_ccn_mono
//	wave ss = ::SS_setting
//	
//	//variable curr_dp = 0
//	//variable curr_dp_cnt = 0
//	//variable dp_cnt_thrshld = 3 // have to wait 30 seconds to let smps data "catch up"
//	variable curr_ss = 0
//	
//	// create intermediate waves of ss by type
//		
//	//variable dp_index, ss_index
//	variable ss_index
//	variable i,j,r
//	make/o/d/n=0 tmp_datetime,tmp_ccn_conc, tmp_cn_conc, tmp_ccn_cn_ratio
//	wave tmp_dt = tmp_datetime
//	wave tmp_ccn = tmp_ccn_conc
//	wave tmp_cn = tmp_cn_conc
//	wave tmp_ratio = tmp_ccn_cn_ratio
//
//	// process each ss period for each sample type
//	variable typ
//	string samp_types=ccn_get_samp_type_list()	
//	string curr_type
//	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
//		string sample_type = stringfromlist(typ,samp_types)
//		for (i=0;i<numpnts(ratio); i+=1)			
////					if (ss[i] > 1.6)
////						variable/D test = 1.7
////						print "here " + num2str(ss[i])+num2str(ss[i])
////						print ss[i], str2num(num2str(ss[i]))
////						print (ss[i]==test)
////						print (str2num(num2str(ss[i]))==1.7)
////					endif
//
//			//if (ccn_valid_dp_ss_pair(dp[i], ss[i])) // if bad dp or ss skip altogether
//			if (ccn_valid_ss(ss[i])) // if bad ss skip altogether
//					
//				if (curr_ss == 0)
//					curr_ss = ss[i]
//				endif
//	
//				if (curr_ss != ss[i]) // restart ss
//					
//					// add current data to proper wave in :data
//					if (i>0)
//						ccn_spectra_append_ss_wave(curr_ss,tmp_dt, tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
//						redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//					endif
//					
//					curr_type = types[i]
//					curr_ss = ss[i]
//					if (cmpstr(sample_type,curr_type)==0)
//						r =0
//						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//						tmp_dt[r] = dt[i]
//						tmp_ccn[r] = ccn_clean[i]
//						tmp_cn[r] = mono_cn[i]
//						tmp_ratio[r] = ratio[i]
//					endif
//				else 
//					curr_type = types[i]
//					if (cmpstr(sample_type,curr_type)==0)
//						r = numpnts(tmp_dt)
//						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//						tmp_dt[r] = dt[i]
//						tmp_ccn[r] = ccn_clean[i]
//						tmp_cn[r] = mono_cn[i]
//						tmp_ratio[r] = ratio[i]
//					endif
//				endif				
//			endif
//		endfor
//	endfor
//	
//	// create dp vs. SS matrix
//
//	killwaves/Z ratio
//	SetDataFolder dfr
//End

//Function ccn_spectra_generate_ss_matrix(normalize)
//	variable normalize
// Changed like the mono version...
Function ccn_spectra_generate_ss_matrix([normalize])
	string normalize

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :spectra_ss

	variable doNormalize = 0
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
	endif
	
////	ccn_get_dp_list_as_wave("ccn_mono_dp")
////	wave dp = $("ccn_mono_dp")
////	string dp_list = ccn_mono_dp_list
//	make/T/o/n=(numpnts(dp)) ccn_mono_dp_txt_w
//	wave/T dp_txt = ccn_mono_dp_txt_w
//	make/o/n=(numpnts(dp)) ccn_mono_dp_index
//	wave dp_index = ccn_mono_dp_index
//	variable im
//	for (im=0; im<numpnts(dp); im+=1)
//		dp_txt[im] = stringfromlist(im,dp_list)
//		dp_index[im] = im
//	endfor
//	make/o/n=(numpnts(dp)+1) ccn_mono_dp_cnt_im
//	wave dp_cnt = ccn_mono_dp_cnt_im
//	dp_cnt[0] = -0.5
//	dp_cnt[,numpnts(dp_cnt)-1] = dp_cnt[p-1] + 1
	
	ccn_get_ss_list_as_wave("ccn_spectra_ss")
	wave ss = $("ccn_spectra_ss")
	string ss_list = ccn_mono_ss_list
//	make/T/o/n=(numpnts(ss)) ccn_mono_ss_txt_w
//	wave/T ss_txt = ccn_mono_ss_txt_w
//	make/o/n=(numpnts(ss)) ccn_mono_ss_index
//	wave ss_index = ccn_mono_ss_index
//	for (im=0; im<numpnts(ss); im+=1)
//		ss_txt[im] = stringfromlist(im,ss_list)
//		ss_index[im] = im
//	endfor
//	make/o/n=(numpnts(ss)+1) ccn_mono_ss_cnt_im
//	wave ss_cnt = ccn_mono_ss_cnt_im
//	ss_cnt[0] = -0.5
//	ss_cnt[,numpnts(ss_cnt)-1] = ss_cnt[p-1] + 1
	
	if (doNormalize)
		newdatafolder/o/s :normalize
	endif
	
	variable typ
	string samp_types=ccn_get_samp_type_list()	
	string curr_type
	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
		string sample_type = stringfromlist(typ,samp_types)

		string suffix
		if (cmpstr(sample_type,"")==0 || cmpstr(sample_type,"NORMAL")==0)
			suffix=""
		elseif (cmpstr(sample_type,"BAD")==0)
			continue
		else
			suffix="_"+sample_type
		endif

		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
		make/o/n=(numpnts(ss)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
		wave ratio = $("ccn_cn_ratio"+suffix)
		wave ratio_sd = $("ccn_cn_ratio_sd"+suffix)
		ratio = nan
		ratio_sd=nan
		
		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
		make/o/n=(numpnts(ss)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
		wave ccn = $("ccn_conc"+suffix)
		wave ccn_sd = $("ccn_conc_sd"+suffix)
		ccn = nan
		ccn_sd=nan
		
		//make/o/n=(numpnts(ss),numpnts(dp)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
		make/o/n=(numpnts(ss)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
		wave cn = $("cn_conc"+suffix)
		wave cn_sd = $("cn_conc_sd"+suffix) 
		cn = nan
		cn_sd=nan
	
		// get matrix values from data waves
		variable row,col
		for (row=0; row<numpnts(ss); row+=1)
			//for (col=0; col<numpnts(dp); col+=1)
			string wname = ":data:" + ccn_spectra_generate_ss_name(ss[row])
			wname+=suffix
			if (waveexists($wname))
				wave w_orig = $wname
				if (dimsize(w_orig,0) > 0)
					
					duplicate/o w_orig cgdvs_tmp_w
					ccn_clean_dp_v_ss_wave(cgdvs_tmp_w)
					wave w = cgdvs_tmp_w
					
					wavestats/Q w
					
					ccn[row] = util_matrix_wavestats_col(0,w,"V_avg") // ccn
					ccn_sd[row] =util_matrix_wavestats_col(1,w,"V_avg") // ccn_sd
					
					cn[row] = util_matrix_wavestats_col(2,w,"V_avg") // cn
					cn_sd[row] =util_matrix_wavestats_col(3,w,"V_avg") // cn_sd

					ratio[row] = util_matrix_wavestats_col(4,w,"V_avg") // ratio
					ratio_sd[row] =util_matrix_wavestats_col(5,w,"V_avg") // ratio_sd

//					util_matrix_wavestats_col(2,w) // cn
//					cn[row][col] = V_avg
//					util_matrix_wavestats_col(3,w) // cn_sd
//					cn_sd[row][col] = V_avg
//
//					util_matrix_wavestats_col(4,w) // cn
//					ratio[row][col] = V_avg
//					util_matrix_wavestats_col(5,w) // cn_sd
//					ratio_sd[row][col] = V_avg
					
					killwaves/Z w
				endif
			endif
			//endfor
		endfor
		wavestats/Q ratio
		if (V_npnts==0) // all nans
			killwaves/Z ratio,ratio_sd,ccn,ccn_sd,cn,cn_sd
		else		// added 9Dec2014 - copied from mono version
			// normalize ratio if "normalize=1"
//			if (normalize)
			if (doNormalize)
				make/o/n=(dimsize(ratio,0)) tmp_w
				//for(col=0; col<dimsize(ratio,1); col+=1)
					//tmp_w = ratio[p][col]
					tmp_w = ratio[p]
					wavestats/Q tmp_w
					variable wmax = V_max
					if (wmax > 0)
						tmp_w /= wmax
						ratio = tmp_w[p]
					endif
				//endfor
				killwaves/Z tmp_w
			endif

		endif
	endfor


	
//	// generate dp and ss waves for images
//	wave w = $wname
//	wave dp = ccn_mono_dp
//	make/o/n=(numpnts(dp)+1) ccn_mono_dp_im
//	wave dp_im = ccn_mono_dp_im
//	dp_im[0] = dp[0] - ( ((dp[0]+dp[1])/2) - dp[0] ) 
//	dp_im[1,numpnts(dp_im)-2] = (dp[p-1] + dp[p])/2
//	dp_im[numpnts(dp_im)-1] = dp[numpnts(dp)-1] + ( dp[numpnts(dp)-1] - ( (dp[numpnts(dp)-1] + dp[numpnts(dp)-2])/2) )
//	
//	wave ss = ccn_mono_ss
//	make/o/n=(numpnts(ss)+1) ccn_mono_ss_im
//	wave ss_im = ccn_mono_ss_im
//	ss_im[0] = ss[0] - ( ((ss[0]+ss[1])/2) - ss[0] ) 
//	ss_im[1,numpnts(ss_im)-2] = (ss[p-1] + ss[p])/2
//	ss_im[numpnts(ss_im)-1] = ss[numpnts(ss)-1] + ( ss[numpnts(ss)-1] - ( (ss[numpnts(ss)-1] + ss[numpnts(ss)-2])/2) )

	
	setdatafolder dfr
End

Function ccn_spectra_append_ss_wave(ss, dt, ccn, cn, ratio, [type])
	variable ss
	wave dt
	wave ccn
	wave cn
	wave ratio
	string type
	
	string suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		suffix=""
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else		
		suffix="_"+type
	endif
	
	// changed from 8 to 10 to include start and stop times for each point 23May2014
	//variable cols = 8  // number of colums for each pair
	variable cols = 10 // number of colums for each pair
	
//	if (ss==1.7)
//		print ss, dp
//		print type
//	endif
		
	// check if valid again? Should not be possible but just in case
	if (!ccn_valid_ss(ss))
		return 0
	endif
	
	if (numpnts(ratio)==0) // check if no data in tmp waves
		return 0
	endif
	
	// create wave if not present
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :spectra_ss:data
	
	string wname = ccn_spectra_generate_ss_name(ss)
	wname += suffix
	if (!waveexists($wname))
		make/n=(0,cols) $wname
		make/n=0 $(wname+"_dt")
	endif
	wave w = $wname
	wave w_dt = $(wname+"_dt")
	variable curr_row = dimsize(w,0)
	redimension/n=(curr_row+1,cols) w
	redimension/n=(curr_row+1) w_dt
	
	wavestats/Q dt
	w_dt[curr_row] = V_avg
	w[curr_row][7] = V_min  // start time
	if (V_max < V_min)
		w[curr_row][8] = V_avg
	else
		w[curr_row][8] = V_max // stop time
	endif

	wavestats/Q ccn
	w[curr_row][0] = V_avg
	w[curr_row][1] = V_sdev
		
	wavestats/Q cn
	w[curr_row][2] = V_avg
	w[curr_row][3] = V_sdev

	wavestats/Q ratio
	w[curr_row][4] = V_avg
	w[curr_row][5] = V_sdev
	w[curr_row][6] = V_npnts
	
	// set user_nan = 0 as default
	//w[curr_row][7] = 0
	w[curr_row][9] = 0
	
	//acg_wn_set_note_with_key(w,"SAMPLE_TYPE",type)

	setdatafolder dfr
End

Function/S ccn_spectra_generate_ss_name(ss)
	variable ss

	string wname = "ss_"+num2str(ss)
	wname = replacestring(".",wname,"_")
	return wname
End

Function ccn_spectra_plot_activation([normalize])
	string normalize
		
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :spectra_ss

	variable doNormalize = 0
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
	endif

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {19,16,17,14,60, 2}

	string samp_type = ccn_get_samp_type_list()
	//string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	//wname += suffix
	variable i
	variable curve_cnt = 0
	for (i=1; i<itemsinlist(samp_type); i+=1)
		string suffix = stringfromlist(i,samp_type)
		if (cmpstr(suffix,"NORMAL")==0)
			suffix = ""
		else
			suffix = "_"+suffix
		endif
		string wname = "ccn_cn_ratio"+suffix
		string wname_sd = "ccn_cn_ratio_sd"+suffix
		if (waveexists($wname)) 
		
			if (doNormalize)
				setdatafolder $":normalize"
			endif
			
			wave w = $wname
			wave w_sd = $wname_sd
			
			if (doNormalize)
				setdatafolder ::
			endif
			
			//wave dp = ccn_mono_dp
			wave ss = ccn_spectra_ss
			
			if (curve_cnt == 0)
				display w[] vs ss
			else
				AppendToGraph w[] vs ss
			endif
			DelayUpdate
			ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
			ModifyGraph marker($wname)=mrk[curve_cnt]
			SetAxis left 0,1
			ModifyGraph grid(left)=1
			ModifyGraph grid=1
			ModifyGraph gaps($wname)=0
			Legend/C/N=text0/H={0,10,10}/A=LT
			//string title = "D\\Bp\\M = " + num2str(diam) + "nm"
			//TextBox/C/N=text1/H={0,10,10} title
			Label left "CCN/CN Ratio"
			Label bottom "SS (%)"
			
			ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
			
			DoUpdate		
			curve_cnt+=1

		endif
	endfor		

	setdatafolder dfr
End

Function ccn_spectra_plot_ss_wave(ss,[type])
	variable ss
	string type
	
	string prefix, suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		prefix=""
		suffix=""
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else
		prefix=type+": "		
		suffix="_"+type
	endif
	
	variable def_max_conc = 10000
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :spectra_ss:data

	string wname = ccn_spectra_generate_ss_name(ss)
	wname += suffix
	wave w = $wname
	wave dt = $(wname+"_dt")
	
	if (!waveexists(w) || !waveexists(dt))
		return 0
	endif

	display w[][2] vs dt
	DelayUpdate
	ModifyGraph mode($wname)=3,marker($wname)=19
	ModifyGraph axisEnab(left)={0,0.3},lblPosMode(left)=1,freePos(left)=0
	ErrorBars $wname Y,wave=(w[*][3],w[*][3])
	Label left "CN"
	SetAxis left 0,def_max_conc

	AppendToGraph/L=ccn w[][0] vs dt
	ModifyGraph mode($(wname+"#1"))=3,marker($(wname+"#1"))=19,rgb($(wname+"#1"))=(0,15872,65280)
	ModifyGraph axisEnab(ccn)={0.35,0.65},lblPosMode(ccn)=1,freePos(ccn)=0
	ErrorBars $(wname+"#1") Y,wave=(w[*][1],w[*][1])
	Label ccn "CCN"
	SetAxis ccn 0,def_max_conc

	AppendToGraph/L=ratio w[][4] vs dt
	ModifyGraph mode($(wname+"#2"))=3,marker($(wname+"#2"))=19,rgb($(wname+"#2"))=(0,39168,0)
	ModifyGraph axisEnab(ratio)={0.7,1},lblPosMode(ratio)=1,freePos(ratio)=0
	ErrorBars $(wname+"#2") Y,wave=(w[*][5],w[*][5])
	Label ratio "CCN/CN"
	SetAxis ratio 0,1.2
	ModifyGraph grid(ratio)=1

	AppendToGraph/R=flag w[][9] vs dt
	ModifyGraph lblPosMode(flag)=1,freePos(flag)=0
	ModifyGraph mode=3
	ModifyGraph axisEnab(flag)={0,0.3}
	SetAxis flag 0.1,1
	ModifyGraph marker($(wname+"#3"))=16
	ModifyGraph rgb($(wname+"#3"))=(0,0,0)
	Label flag "User NaN"
	
	string txt = prefix + "SS="+num2str(ss)+"%"
	TextBox/C/N=text1/H={0,10,10}/A=RC txt	
	
	DoUpdate
	
	setdatafolder dfr
End

Function ccn_spectra_toggle_ss_nan_marq(isNaN)
	variable isNaN  // 0 = reset, 1 =NaN

	GetMarquee/K/Z bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	setdatafolder :spectra_ss:data
	
	variable dt_index
	variable i
	for (i=0; i<dimsize(wlist,0); i+=1)
		if (stringmatch(wlist[i][0],"*_dt"))
			dt_index = i
			break
		endif
	endfor
	
	variable w_index = (dt_index) ? 0 : 1
	
	wave w = $wlist[w_index][0]
	variable nan_col = dimsize(w,1)-1
	
	wave dt = $wlist[dt_index][0]	
	variable rows = numpnts(dt)
	
	//variable i
	for (i=0; i<rows; i+=1)
		if (dt[i] >= left && dt[i] <= right)
			w[i][nan_col] = isNaN
			
			// added to save NaN'd values as BAD
			if (isNan)
				ccn_set_range_type(w[i][7],w[i][8],"BAD")
			else
				ccn_set_range_type(w[i][7],w[i][8],acg_wn_get_note_with_key(w,"SAMPLE_TYPE"))
			endif
			
		endif
	endfor
	
	if (auto_update_matrix)
		ccn_spectra_generate_ss_matrix(normalize=default_normalize)
	endif

	setdatafolder dfr
End

Function ccn_kappa_generate_ss_waves()

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	
	variable kappa_tb = kappa_TimeBase
	setdatafolder $(":avg_"+num2str(kappa_tb))

	
	if (kappa_tb == ccn_avg_period)
		ccn_init_samp_type_waves()
		duplicate/T/o ::ccn_sample_type ccn_sample_type
		duplicate/o ::ccn_sample_type_index ccn_sample_type_index		
	else 
		// fix "averaged" sample_type wave
		killwaves/Z ccn_sample_type
		make/o/T/n=(numpnts(ccn_sample_type_index)) ccn_sample_type
	endif
	
	wave/T types = ccn_sample_type
	wave index = ccn_sample_type_index

	index = (mod(index[p],1) != 0) ? 0 : index[p]
	string samp_types=ccn_get_samp_type_list()	
	types = stringfromlist(index[p],samp_types)

	setdatafolder :Dcrit	
	// create folders
	newdatafolder/o/s kappa_ss
	newdatafolder/o/s data
	
	// clean up any current waves as we will generate new values
	string wlist = acg_get_wave_list()
	ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list()
	ccn_reset_dp_v_ss_waves(wlist)
		
	wave dt = ::date_time
	wave kappa = ::ccn_kappa
	wave dp = ::ccn_crit_dp
	
	//wave ccn_clean = ::CCN_Concentration_Cleaned
	//wave mono_cn = ::mono_cn_conc_shifted
//	wave mono_cn = ::mono_cn_conc
	//duplicate/O mono_cn calc_ccn_cn_ratio
	//wave ratio = calc_ccn_cn_ratio
	//ratio = ccn_clean/mono_cn
	//wave/T types = ::ccn_sample_type
	
	//wave dp = ::zi_smps_dp_ccn_mono
	wave ss = :::SS_setting
	//ss*=100
	//ss=floor(ss)/100
	ccn_fix_ss_to_standard(ss)
	
	//variable curr_dp = 0
	//variable curr_dp_cnt = 0
	//variable dp_cnt_thrshld = 3 // have to wait 30 seconds to let smps data "catch up"
	variable curr_ss = 0
	
	// create intermediate waves of ss by type
		
	//variable dp_index, ss_index
	variable ss_index
	variable i,j,r
	make/o/d/n=1 tmp_datetime,tmp_kappa, tmp_dp
	wave tmp_dt = tmp_datetime
	wave tmp_kappa = tmp_ccn_conc
	wave tmp_dp= tmp_cn_conc

	// process each ss period for each sample type
	variable typ
	//string samp_types=ccn_get_samp_type_list()	
	string curr_type

	// change this to simply append all "good" values to waves without worrying about averaging
	for (i=0;i<numpnts(kappa); i+=1)			
		if (ccn_valid_ss(ss[i]) && cmpstr(types[i],"BAD")!=0) // if bad ss or BAD type skip altogether
			tmp_dt[0] = dt[i]
			tmp_kappa[0] = kappa[i]
			tmp_dp[0] = dp[i]
			ccn_kappa_append_ss_wave(ss[i],tmp_dt, tmp_kappa,tmp_dp,type=types[i])
		endif
	endfor

//	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
//		string sample_type = stringfromlist(typ,samp_types)
//		for (i=0;i<numpnts(kappa); i+=1)			
//					if (ss[i] > 1.6)
//						variable/D test = 1.7
//						print "here " + num2str(ss[i])+num2str(ss[i])
//						print ss[i], str2num(num2str(ss[i]))
//						print (ss[i]==test)
//						print (str2num(num2str(ss[i]))==1.7)
//					endif
//
//			//if (ccn_valid_dp_ss_pair(dp[i], ss[i])) // if bad dp or ss skip altogether
//			if (ccn_valid_ss(ss[i])) // if bad ss skip altogether
//					
//				if (curr_ss == 0)
//					curr_ss = ss[i]
//				endif
//	
//				if (curr_ss != ss[i]) // restart ss
//					
//					// add current data to proper wave in :data
//					if (i>0)
//						ccn_kappa_append_ss_wave(curr_ss,tmp_dt, tmp_kappa,tmp_dp,type=curr_type)
//						redimension/n=0 tmp_dt, tmp_kappa, tmp_dp
//					endif
//					
//					curr_type = types[i]
//					curr_ss = ss[i]
//					if (cmpstr(sample_type,curr_type)==0)
//						r =0
//						redimension/n=(r+1) tmp_dt, tmp_kappa, tmp_dp
//						tmp_dt[r] = dt[i]
//						tmp_kappa[r] = kappa[i]
//						tmp_dp[r] = dp[i]
//					endif
//				else 
//					curr_type = types[i]
//					if (cmpstr(sample_type,curr_type)==0)
//						r = numpnts(tmp_dt)
//						redimension/n=(r+1) tmp_dt, tmp_kappa, tmp_dp
//						tmp_dt[r] = dt[i]
//						tmp_kappa[r] = kappa[i]
//						tmp_dp[r] = dp[i]
//					endif
//				endif				
//			endif
//		endfor
//	endfor
	
	// create dp vs. SS matrix

	SetDataFolder dfr
End

Function ccn_kappa_append_ss_wave(ss, dt, kappa, dcrit, [type])
	variable ss
	wave dt
	wave kappa
	wave dcrit
	string type
	
	string suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		suffix=""
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else		
		suffix="_"+type
	endif
	
	variable cols = 6  // number of colums for each pair
	
//	if (ss==1.7)
//		print ss, dp
//		print type
//	endif
		
	// check if valid again? Should not be possible but just in case
	if (!ccn_valid_ss(ss))
		return 0
	endif
	
	if (numpnts(kappa)==0) // check if no data in tmp waves
		return 0
	endif
	
	// commenting this out for now...not sure what I am looking for in kappa wrt NaNs
//	if (numtype(kappa)>0 || numtype(dcrit)>0)
//		return 0
//	endif
	
	// create wave if not present
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	variable kappa_tb = kappa_TimeBase
	string data_folder = ":avg_"+num2str(kappa_tb)+":Dcrit:kappa_ss:data"
	//setdatafolder :avg_300:Dcrit:kappa_ss:data
	setdatafolder data_folder
	
	string wname = ccn_spectra_generate_ss_name(ss)
	wname += suffix
	if (!waveexists($wname))
		make/n=(0,cols) $wname
		make/d/n=0 $(wname+"_dt")
	endif
	wave w = $wname
	wave w_dt = $(wname+"_dt")
	variable curr_row = dimsize(w,0)
	redimension/n=(curr_row+1,cols) w
	redimension/d/n=(curr_row+1) w_dt
	
	wavestats/Q dt
	w_dt[curr_row] = V_avg
	//w_dt[curr_row] = dt

	wavestats/Q kappa
	w[curr_row][0] = V_avg
	w[curr_row][1] = V_sdev
	//w[curr_row][0] = kappa
	//w[curr_row][1] = 0
		
	wavestats/Q dcrit
	w[curr_row][2] = V_avg
	w[curr_row][3] = V_sdev
	w[curr_row][4] = V_npnts
	
	// set user_nan = 0 as default
	w[curr_row][5] = 0
	
	setdatafolder dfr
End

Function ccn_kappa_generate_ss_matrix()

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder

	variable kappa_tb = kappa_TimeBase
	setdatafolder $(":avg_"+num2str(kappa_tb)+":Dcrit:kappa_ss")
	//setdatafolder :avg_300:Dcrit:kappa_ss
		
	ccn_get_ss_list_as_wave("ccn_kappa_ss")
	wave ss = $("ccn_kappa_ss")
	string ss_list = ccn_mono_ss_list
//	make/T/o/n=(numpnts(ss)) ccn_mono_ss_txt_w
//	wave/T ss_txt = ccn_mono_ss_txt_w
//	make/o/n=(numpnts(ss)) ccn_mono_ss_index
//	wave ss_index = ccn_mono_ss_index
//	for (im=0; im<numpnts(ss); im+=1)
//		ss_txt[im] = stringfromlist(im,ss_list)
//		ss_index[im] = im
//	endfor
//	make/o/n=(numpnts(ss)+1) ccn_mono_ss_cnt_im
//	wave ss_cnt = ccn_mono_ss_cnt_im
//	ss_cnt[0] = -0.5
//	ss_cnt[,numpnts(ss_cnt)-1] = ss_cnt[p-1] + 1
	
	variable typ
	string samp_types=ccn_get_samp_type_list()	
	string curr_type
	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
		string sample_type = stringfromlist(typ,samp_types)

		string suffix
		if (cmpstr(sample_type,"")==0 || cmpstr(sample_type,"NORMAL")==0)
			suffix=""
		elseif (cmpstr(sample_type,"BAD")==0)
			continue
		else
			suffix="_"+sample_type
		endif

		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
		make/o/n=(numpnts(ss)) $("ccn_kappa"+suffix), $("ccn_kappa_sd"+suffix)
		wave kappa = $("ccn_kappa"+suffix)
		wave kappa_sd = $("ccn_kappa_sd"+suffix)
		kappa = nan
		kappa_sd=nan
		
		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
		make/o/n=(numpnts(ss)) $("ccn_dcrit"+suffix), $("ccn_dcrit_sd"+suffix)
		wave dcrit = $("ccn_dcrit"+suffix)
		wave dcrit_sd = $("ccn_dcrit_sd"+suffix)
		dcrit = nan
		dcrit_sd=nan
			
		// get matrix values from data waves
		variable row,col
		for (row=0; row<numpnts(ss); row+=1)
			//for (col=0; col<numpnts(dp); col+=1)
			string wname = ":data:" + ccn_spectra_generate_ss_name(ss[row])
			wname+=suffix
			if (waveexists($wname))
				wave w_orig = $wname
				if (dimsize(w_orig,0) > 0)
					
					duplicate/o w_orig cgdvs_tmp_w
					ccn_clean_dp_v_ss_wave(cgdvs_tmp_w)
					wave w = cgdvs_tmp_w
					
					wavestats/Q w
					
					kappa[row] = util_matrix_wavestats_col(0,w,"V_avg") // ccn
					kappa_sd[row] =util_matrix_wavestats_col(0,w,"V_sdev") // ccn_sd
					
					dcrit[row] = util_matrix_wavestats_col(2,w,"V_avg") // cn
					dcrit_sd[row] =util_matrix_wavestats_col(2,w,"V_sdev") // cn_sd
					
					killwaves/Z w
				endif
			endif
			//endfor
		endfor
		
		wavestats/Q kappa
		if (V_npnts==0) // all nans
			killwaves/Z kappa,kappa_sd,dcrit,dcrit_sd
		endif
	endfor
	
//	// generate dp and ss waves for images
//	wave w = $wname
//	wave dp = ccn_mono_dp
//	make/o/n=(numpnts(dp)+1) ccn_mono_dp_im
//	wave dp_im = ccn_mono_dp_im
//	dp_im[0] = dp[0] - ( ((dp[0]+dp[1])/2) - dp[0] ) 
//	dp_im[1,numpnts(dp_im)-2] = (dp[p-1] + dp[p])/2
//	dp_im[numpnts(dp_im)-1] = dp[numpnts(dp)-1] + ( dp[numpnts(dp)-1] - ( (dp[numpnts(dp)-1] + dp[numpnts(dp)-2])/2) )
//	
//	wave ss = ccn_mono_ss
//	make/o/n=(numpnts(ss)+1) ccn_mono_ss_im
//	wave ss_im = ccn_mono_ss_im
//	ss_im[0] = ss[0] - ( ((ss[0]+ss[1])/2) - ss[0] ) 
//	ss_im[1,numpnts(ss_im)-2] = (ss[p-1] + ss[p])/2
//	ss_im[numpnts(ss_im)-1] = ss[numpnts(ss)-1] + ( ss[numpnts(ss)-1] - ( (ss[numpnts(ss)-1] + ss[numpnts(ss)-2])/2) )

	
	setdatafolder dfr
End

Function ccn_spectra_plot_kappa_dcrit()
		
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	variable kappa_tb = kappa_TimeBase
	setdatafolder $(":avg_"+num2str(kappa_tb)+":Dcrit:kappa_ss")
	//setdatafolder :avg_300:Dcrit:kappa_ss

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {19,16,17,14,60, 2}

	string samp_type = ccn_get_samp_type_list()
	//string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	//wname += suffix
	variable i
	variable curve_cnt = 0
	for (i=1; i<itemsinlist(samp_type); i+=1)
		string suffix = stringfromlist(i,samp_type)
		if (cmpstr(suffix,"NORMAL")==0)
			suffix = ""
		else
			suffix = "_"+suffix
		endif
		string wname = "ccn_kappa"+suffix
		string wname_sd = "ccn_kappa_sd"+suffix

		string wname2 = "ccn_dcrit"+suffix
		string wname2_sd = "ccn_dcrit_sd"+suffix
		
		if (waveexists($wname) && waveexists($wname2)) 
			wave w = $wname
			wave w_sd = $wname_sd
			wave w2 = $wname2
			wave w2_sd = $wname2_sd
			
			//wave dp = ccn_mono_dp
			wave ss = ccn_kappa_ss
			
			if (curve_cnt == 0)
				display w[] vs ss
				AppendToGraph/R w2[] vs ss
			else
				AppendToGraph w[] vs ss
				AppendToGraph/R w2[] vs ss
			endif
			DelayUpdate
			ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
			ModifyGraph marker($wname)=mrk[curve_cnt]
			SetAxis left 0,1
			ModifyGraph grid(left)=1
			ModifyGraph grid=1
			ModifyGraph gaps($wname)=0
			Legend/C/N=text0/H={0,10,10}/A=LT
			//string title = "D\\Bp\\M = " + num2str(diam) + "nm"
			//TextBox/C/N=text1/H={0,10,10} title
			Label left "kappa"
			Label bottom "SS (%)"
			
			ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
			
			DoUpdate		
			curve_cnt+=1

		endif
	endfor		

	setdatafolder dfr
End

Function ccn_spectra_plot_kappa_standard()
		
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	variable kappa_tb = kappa_TimeBase
	setdatafolder $(":avg_"+num2str(kappa_tb)+":Dcrit:kappa_ss")
	//setdatafolder :avg_300:Dcrit:kappa_ss

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // circle, square, triangle(up), hourglass triangle, 4pt star, asterisk
	mrk = {19,16,17,14,60, 2}

	// generate standard plot
	ccn_make_standard_kappa_plot()

	string samp_type = ccn_get_samp_type_list()
	//string wname = ccn_generate_dp_vs_ss_name(dp,ss)
	//wname += suffix
	variable i
	variable curve_cnt = 0
	for (i=1; i<itemsinlist(samp_type); i+=1)
		string suffix = stringfromlist(i,samp_type)
		if (cmpstr(suffix,"NORMAL")==0)
			suffix = ""
		else
			suffix = "_"+suffix
		endif
		//string wname = "ccn_dcrit"+suffix
		//string wname_sd = "ccn_dcrit_sd"+suffix

		string wname = "ccn_dcrit"+suffix
		string wname_sd = "ccn_dcrit_sd"+suffix
		
		DoUpdate		
		if (waveexists($wname)) 
			string wname_ss = wname+"_ss"
			duplicate/o ccn_kappa_ss, $wname_ss
			wave ss = $wname_ss
			
			duplicate/o $wname, $(wname+"_um")
			wname = wname+"_um"
			wave w = $wname
			w /= 1000
			
			duplicate/o $wname_sd, $(wname_sd+"_um")
			wname_sd = wname_sd+"_um"
			wave w_sd = $wname_sd
			w_sd /= 1000
			
			//wave dp = ccn_mono_dp
			//wave ss = ccn_kappa_ss
			
			AppendToGraph/L ss vs w[]

			DelayUpdate
			ModifyGraph mode($wname_ss)=3,rgb($wname_ss)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
			ModifyGraph marker($wname_ss)=mrk[curve_cnt]
			//SetAxis left 0,1
			//ModifyGraph grid(left)=1
			//ModifyGraph grid=1
			//ModifyGraph gaps($wname)=0
			//Legend/C/N=text0/H={0,10,10}/A=LT
			//string title = "D\\Bp\\M = " + num2str(diam) + "nm"
			//TextBox/C/N=text1/H={0,10,10} title
			Label left "SS (%)"
			Label bottom "D\Bp\M (um)"
			
			ErrorBars $wname_ss X,wave=(w_sd[*],w_sd[*])
			
			DoUpdate		
			curve_cnt+=1

		endif
	endfor		

	setdatafolder dfr
End

Function ccn_kappa_plot_ss_wave(ss,[type])
	variable ss
	string type
	
	string prefix, suffix
	if (ParamIsDefault(type) || cmpstr(type,"NORMAL")==0)
		prefix=""
		suffix=""
	elseif (cmpstr(type,"BAD")==0)
		return 0
	else
		prefix=type+": "		
		suffix="_"+type
	endif
	
	variable def_max_dp = 500
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	variable kappa_tb = kappa_TimeBase
	setdatafolder $(":avg_"+num2str(kappa_tb)+":Dcrit:kappa_ss:data")
	//setdatafolder :avg_300:Dcrit:kappa_ss:data

	string wname = ccn_spectra_generate_ss_name(ss)
	wname += suffix
	wave w = $wname
	wave dt = $(wname+"_dt")
	
	if (!waveexists(w) || !waveexists(dt))
		return 0
	endif

	display w[][0] vs dt
	DelayUpdate
	ModifyGraph mode($wname)=3,marker($wname)=19
	ModifyGraph axisEnab(left)={0,0.48},lblPosMode(left)=1,freePos(left)=0
	//ErrorBars $wname Y,wave=(w[*][3],w[*][3])
	Label left "kappa"
	//SetAxis left 0,def_max_conc

	AppendToGraph/L=dp w[][2] vs dt
	ModifyGraph mode($(wname+"#1"))=3,marker($(wname+"#1"))=19,rgb($(wname+"#1"))=(0,15872,65280)
	ModifyGraph axisEnab(dp)={0.52,1},lblPosMode(dp)=1,freePos(dp)=0
	//ErrorBars $(wname+"#1") Y,wave=(w[*][1],w[*][1])
	Label dp "Dcrit"
	//SetAxis dp 0,def_max_conc

//	AppendToGraph/L=ratio w[][4] vs dt
//	ModifyGraph mode($(wname+"#2"))=3,marker($(wname+"#2"))=19,rgb($(wname+"#2"))=(0,39168,0)
//	ModifyGraph axisEnab(ratio)={0.7,1},lblPosMode(ratio)=1,freePos(ratio)=0
//	ErrorBars $(wname+"#2") Y,wave=(w[*][5],w[*][5])
//	Label ratio "CCN/CN"
//	SetAxis ratio 0,1.2
//	ModifyGraph grid(ratio)=1

	AppendToGraph/R=flag w[][5] vs dt
	ModifyGraph lblPosMode(flag)=1,freePos(flag)=0
	ModifyGraph mode=3
	ModifyGraph axisEnab(flag)={0,0.3}
	SetAxis flag 0.1,1
	ModifyGraph marker($(wname+"#2"))=16
	ModifyGraph rgb($(wname+"#2"))=(0,0,0)
	Label flag "User NaN"
	
	string txt = prefix + "SS="+num2str(ss)+"%"
	TextBox/C/N=text1/H={0,10,10}/A=RC txt	
	
	DoUpdate
	
	setdatafolder dfr
End

Function ccn_kappa_toggle_ss_nan_marq(isNaN)
	variable isNaN  // 0 = reset, 1 =NaN

	GetMarquee/K/Z bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist

	dfref dfr = GetDataFolderDFR()
	setdatafolder ccn_data_folder
	variable kappa_tb = kappa_TimeBase
	setdatafolder $(":avg_"+num2str(kappa_tb)+":Dcrit:kappa_ss:data")
	//setdatafolder :avg_300:Dcrit:kappa_ss:data
	
	wave w = $wlist[0][0]
	variable nan_col = dimsize(w,1)-1
	
	wave dt = $wlist[1][0]	
	variable rows = numpnts(dt)
	
	variable i
	for (i=0; i<rows; i+=1)
		if (dt[i] >= left && dt[i] <= right)
			w[i][nan_col] = isNaN
		endif
	endfor
	
	setdatafolder dfr
End

Function ccn_make_standard_kappa_plot()

	dfref dfr = GetDataFolderDFR()
	newdatafolder/o/s root:ccn
	newdatafolder/o/s model
	newdatafolder/o/s kappa
		
	variable R = 8.314 
	variable T = 293 // K
	variable sigma = 0.073 // J/m2
	
	//variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)  * 1e-4
	variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)
	print A
	
	
	// make Ddry, kappa matrix. Value is SS

	variable/D level001 = 0.001
	variable/D level01 = 0.01
	variable/D level1 = 0.1
	variable/D level10 = 1.0

	// make Ddry wave	
	variable Ddry_low = 0.01	
	variable Ddry_high = 1.0
	
	make/d/o/n=1 Ddry
	wave dd = Ddry
	dd = Ddry_low

	//print (Ddry_low == dd[0])
		
	variable inc= 0.01
	variable cnt = 1
	dd[cnt-1] = Ddry_low
	variable tol = 1e-6
	do
		redimension/d/n=(cnt+1) dd
		if (dd[cnt-1] > 1-tol)
			inc = 0.01
		elseif (dd[cnt-1] > 0.1-tol)
			inc = 0.01
		else 
			inc = 0.01
		endif
		
		dd[cnt] = dd[cnt-1] + inc
		cnt +=1
		
		//print dd[cnt-1], Ddry_high, (dd[cnt-1] == Ddry_high)
	while (dd[cnt-1] < Ddry_high-tol)


	// make kappa wave
	variable kappa_low = 0.001
	variable kappa_high = 1.0
	
	make/d/o/n=1 kappa
	wave k = kappa
	
	cnt = 1
	k[cnt-1] = kappa_low
	do
		redimension/d/n=(cnt+1) k
		if (k[cnt-1] > 0.1-tol)
			inc = 0.1
		elseif (k[cnt-1] >= 0.01-tol)
			inc = 0.01
		else
			inc = 0.001
		endif
		
		k[cnt] = k[cnt-1] + inc
		cnt +=1
		
	while (k[cnt-1] < kappa_high-tol)
		
	// create matrix
	make/o/n=(numpnts(dd),numpnts(k)) SS_crit
	wave ss = SS_crit
	
	ss = NaN
	
	variable Dhigh=2.0
	variable Dlow = Ddry_low
	variable Dinc = 0.01
	variable size = (Dhigh-Dlow)/Dinc+1
	
	
	variable row, col, i
	for (col=0; col<numpnts(k); col+=1)
		for (row=0; row<numpnts(dd); row+=1)
		
		make/o/n=(size) D_hyd
		wave D = D_hyd
	
		make/o/n=(size) tmp_SScrit
		wave tmp_ss = tmp_SScrit

			for (i=0; i<size; i+=1)
				D[i] = Dlow + (i*Dinc)
				if (D[i] < dd[row])
					tmp_ss[i] = NaN
				else
					tmp_ss[i] = (D[i]^3 - dd[row]^3)/(D[i]^3 - dd[row]^3*(1-k[col])) * exp(A/D[i])
					tmp_ss[i] -= 1
					tmp_ss[i] *= 100
					if (tmp_ss[i] <= 0)
						tmp_ss[i] = NaN
					endif
				endif			
			endfor
			wavestats/Q tmp_ss
			ss[row][col] = (V_max>0) ? V_max : NaN
			killwaves/Z tmp_ss, D
		endfor
	endfor
	
	//create plot
	for (col=0; col<numpnts(k); col+=1)
		//print k[col]
		if (col==0)
			display ss[][col] vs dd
		else
			AppendToGraph ss[][col] vs dd
		endif
	endfor
	ModifyGraph log(bottom)=1
	ModifyGraph log(left)=1
	SetAxis left 0.08,1.8
	SetAxis bottom 0.01,1
	ModifyGraph rgb=(39168,39168,39168)
	Label left "SS (%)"
	Label bottom "D\\Bp,dry\\M (\\F'Symbol'm\\F]0m)"
	
	setdatafolder dfr	

End

Function ccn_calc_error_matrix(src,pct)
	wave src
	variable pct // in pct units, not fraction, no decimal
	//string out_name
	
	//wave input = src
	//string wn = nameofwave(src) + "_plus"+num2str(pct)
	//print wn
	//duplicate/o src, $wn
	//wave dest = $wn
	string error = "p;m"
	
	variable err,col
	for (err=0; err<itemsinlist(error); err+=1)
		string wn = nameofwave(src) + "_"+stringfromlist(err,error)+num2str(pct)
		print wn
		duplicate/o src, $wn
		wave dest = $wn
		
		if (err==0)
			dest[][] = src[p][q]+(src[p][q]*pct/100)
		else
			dest[][] = src[p][q]-(src[p][q]*pct/100)
		endif
		
		//for (col=0; col<dimsize(src,1); col+=1)
			
			//make/o/n=(dimsize(src,0)) working
			//wave work = working
			//work = src[p][col]
			//print work
			//wavestats/Q work
		
	endfor
	
	
End

Function ccn_parse_ss_crit_file()

	string samp_types_cal= "NaCl_m;NaCl_th;Ammsulf_m;Ammsulf_th"
	string samp_types_sea_sweep = "Sea_Sweep_1;Sea_Sweep_2;Sea_Sweep_3;Sea_Sweep_4;Sea_Sweep_5"
	string samp_types_sea_sweep_heated = "Sea_Sweep_4_H;Sea_Sweep_5_H"
	string diam_list = "30;50;70;90;110"


// ** cal	

	wave/T type = :cal:Sample_Type
	wave diam_dry = :cal:diameter_dry
	wave crit = :cal:ss_crit

	make/o/n=(1,5) ss_crit_NaCl_m
	wave nacl_meas = ss_crit_NaCl_m
	make/o/n=(1,5) ss_crit_NaCl_th
	wave nacl_theory = ss_crit_NaCl_th
	make/o/n=(1,5) ss_crit_AmmSulf_m
	wave as_meas = ss_crit_AmmSulf_m
	make/o/n=(1,5) ss_crit_AmmSulf_th
	wave as_theory = ss_crit_AmmSulf_th

	nacl_meas[0][] = crit[q]
	nacl_theory[0][] = crit[q+5]
	as_meas[0][] = crit[q+10]
	as_theory[0][] = crit[q+15]


// ** sea_sweep
	variable type_cnt = itemsinlist(samp_types_sea_sweep)
	variable diam_cnt = itemsinlist(diam_list)
	
	wave/T type = :sea_sweep:Sample_Type
	wave diam_dry = :sea_sweep:diameter_dry
	wave crit = :sea_sweep:ss_crit

	make/o/n=(type_cnt,diam_cnt) ss_crit_Sea_Sweep
	wave seasweep = ss_crit_Sea_Sweep

	variable i
	variable row=0
	for (i=0;i<numpnts(type); i+=diam_cnt)
		variable col
		for (col=0; col<diam_cnt; col+=1)
			seasweep[row][col] = crit[col+i]
		endfor
		row +=1
	endfor

	// add wave note to desribe what rows (SAMPLE_TYPES) and cols (DIAM_LIST)
	string msg = ""
	msg = replacestringbykey("SAMPLE_TYPES",msg,samp_types_sea_sweep,":","%")
	msg = replacestringbykey("DIAM_LIST",msg,diam_list,":","%")	
	Note/NOCR seasweep, msg


// ** sea_sweep_heated
	type_cnt = itemsinlist(samp_types_sea_sweep_heated)
	diam_cnt = itemsinlist(diam_list)

	wave/T type = :sea_sweep_heated:Sample_Type
	wave diam_dry = :sea_sweep_heated:diameter_dry
	wave crit = :sea_sweep_heated:ss_crit

	make/o/n=(2,5) ss_crit_Sea_Sweep_heated
	wave seasweep_h = ss_crit_Sea_Sweep_heated

	row=0
	for (i=0;i<numpnts(type); i+=diam_cnt)
		for (col=0; col<diam_cnt; col+=1)
			seasweep_h[row][col] = crit[col+i]
		endfor
		row +=1
	endfor
	
	// add wave note to desribe what rows (SAMPLE_TYPES) and cols (DIAM_LIST)
	msg = ""
	msg = replacestringbykey("SAMPLE_TYPES",msg,samp_types_sea_sweep_heated,":","%")
	msg = replacestringbykey("DIAM_LIST",msg,diam_list,":","%")	
	Note/NOCR seasweep_h, msg
	
End


Function ccn_parse_ss_crit_file_amb()

	string samp_types_cal= "NaCl_m;NaCl_th;Ammsulf_m;Ammsulf_th"
	string samp_types_sea_sweep = "Sea_Sweep_1;Sea_Sweep_2;Sea_Sweep_3;Sea_Sweep_4;Sea_Sweep_5"
	string samp_types_sea_sweep_heated = "Sea_Sweep_4_H;Sea_Sweep_5_H"
	string samp_types_ambient = "AMB_5_24;AMB_5_31;AMB_6_2;AMB_6_3"
	string samp_types_ambient_heated = "AMB_5_25_H;AMB_5_29_H;AMB_5_31_H;AMB_6_3_H;AMB_6_4_H"
	string diam_list = "30;50;70;90;110"


// ** cal	

	wave/T type = :cal:Sample_Type
	wave diam_dry = :cal:diameter_dry
	wave crit = :cal:ss_crit

// do not re-make these waves right now...already created in sea_sweep version of this function.
//     uncomment if needed at a later date.

//	make/o/n=(1,5) ss_crit_NaCl_m
	wave nacl_meas = ss_crit_NaCl_m
//	make/o/n=(1,5) ss_crit_NaCl_th
	wave nacl_theory = ss_crit_NaCl_th
//	make/o/n=(1,5) ss_crit_AmmSulf_m
	wave as_meas = ss_crit_AmmSulf_m
//	make/o/n=(1,5) ss_crit_AmmSulf_th
	wave as_theory = ss_crit_AmmSulf_th

//	nacl_meas[0][] = crit[q]
//	nacl_theory[0][] = crit[q+5]
//	as_meas[0][] = crit[q+10]
//	as_theory[0][] = crit[q+15]


// ** ambient
	variable type_cnt = itemsinlist(samp_types_ambient)
	variable diam_cnt = itemsinlist(diam_list)
	
	wave/T type = :ambient:Sample_Type
	wave diam_dry = :ambient:diameter_dry
	wave crit = :ambient:ss_crit

	make/o/n=(type_cnt,diam_cnt) ss_crit_Ambient
	wave ambient = ss_crit_Ambient

	variable i
	variable row=0
	for (i=0;i<numpnts(type); i+=diam_cnt)
		variable col
		for (col=0; col<diam_cnt; col+=1)
			ambient[row][col] = crit[col+i]
		endfor
		row +=1
	endfor

	// add wave note to desribe what rows (SAMPLE_TYPES) and cols (DIAM_LIST)
	string msg = ""
	msg = replacestringbykey("SAMPLE_TYPES",msg,samp_types_ambient,":","%")
	msg = replacestringbykey("DIAM_LIST",msg,diam_list,":","%")	
	Note/NOCR ambient, msg


// ** ambient_heated
	type_cnt = itemsinlist(samp_types_ambient_heated)
	diam_cnt = itemsinlist(diam_list)

	wave/T type = :ambient_heated:Sample_Type
	wave diam_dry = :ambient_heated:diameter_dry
	wave crit = :ambient_heated:ss_crit

	make/o/n=(type_cnt,diam_cnt) ss_crit_Ambient_heated
	wave ambient_h = ss_crit_Ambient_heated

	row=0
	for (i=0;i<numpnts(type); i+=diam_cnt)
		for (col=0; col<diam_cnt; col+=1)
			ambient_h[row][col] = crit[col+i]
		endfor
		row +=1
	endfor
	
	// add wave note to desribe what rows (SAMPLE_TYPES) and cols (DIAM_LIST)
	msg = ""
	msg = replacestringbykey("SAMPLE_TYPES",msg,samp_types_ambient_heated,":","%")
	msg = replacestringbykey("DIAM_LIST",msg,diam_list,":","%")	
	Note/NOCR ambient_h, msg
	
End

Function ccn_find_org_vol_fractions(type,use_theory,[error,useAS])
	string type
	variable use_theory // 1 = theory, 0 = measured
	string error
	variable useAS // use amm sulf instead of nacl in calculations
	
	dfref dfr = GetDataFolderDFR()
	setdatafolder root:org_fraction
	
	string suffix = "_m"
	if (use_theory)
		suffix = "_th"
	endif
	
	string error_suffix = ""
	if ( ParamIsDefault(error))
		error_suffix = ""
	elseif (cmpstr(error,"") != 0)
		error_suffix = "_"+error
	endif

	string kappa_type = ""
	if ( ParamIsDefault(useAS) || useAS == 0)
		// no changes to suffix
		kappa_type = "nacl"
		useAS = 0
	else
		suffix += "_as"
		kappa_type = "as"
		useAS = 1
	endif
	
	
	wave crit = $(":ss_crit:ss_crit_"+type+error_suffix)
	
	string test2 = (":ss_crit:ss_crit_NaCl"+suffix)
	//wave crit_nacl = :$(":ss_crit:ss_crit_NaCl"+suffix)
	
	string nacl_type = ""
	if (useAS)
		nacl_type = "root:org_fraction:ss_crit:ss_crit_AmmSulf_m"+error_suffix
	else
		nacl_type = "root:org_fraction:ss_crit:ss_crit_NaCl_m"+error_suffix
	endif
	if (use_theory)
		//nacl_type = "root:org_fraction:ss_crit:ss_crit_NaCl_th"+error_suffix
		if (useAS)
			nacl_type = "root:org_fraction:ss_crit:ss_crit_AmmSulf_th"
		else
			nacl_type = "root:org_fraction:ss_crit:ss_crit_NaCl_th"
		endif

		//nacl_type = "root:org_fraction:ss_crit:ss_crit_NaCl_th"
	endif
	wave crit_nacl = $nacl_type
	
	string meta = note(crit)
	string sample_types = stringbykey("SAMPLE_TYPES",meta,":","%")
	string diam_list = stringbykey("DIAM_LIST",meta,":","%")
	
	make/o/n=(itemsinlist(diam_list)) diam_dry
	wave d_dry = diam_dry
	
	d_dry = str2num(stringfromlist(p,diam_list))
	
	duplicate/o crit, $("kappa_"+type+suffix+error_suffix), $("org_f_"+type+suffix+error_suffix), $("diam_w_"+type+suffix+error_suffix)
	wave kappa = $("kappa_"+type+suffix+error_suffix)
	wave org_f = $("org_f_"+type+suffix+error_suffix)
	wave diam_wet_w = $("diam_w_"+type+suffix+error_suffix)

	//duplicate/o kappa, $("kappa_nacl"+suffix+error_suffix)
	duplicate/o kappa, $("kappa_"+kappa_type+suffix+error_suffix)
	//print ("kappa_nacl"+suffix+error_suffix)
	//wave kappa_nacl_w = $("kappa_nacl"+suffix+error_suffix)
	wave kappa_nacl_w = $("kappa_"+kappa_type+suffix+error_suffix)
	
	//duplicate/o crit, $("vol_"+type+suffix+error_suffix),$("vol_nacl"+suffix+error_suffix)
	duplicate/o crit, $("vol_"+type+suffix+error_suffix),$("vol_"+kappa_type+suffix+error_suffix)
	wave volumes = $("vol_"+type+suffix+error_suffix)
	//wave volumes_nacl = $("vol_nacl"+suffix+error_suffix)
	wave volumes_nacl = $("vol_"+kappa_type+suffix+error_suffix)
	
	variable vol_frac
	variable samp_index, diam_index
	for (samp_index=0; samp_index<dimsize(crit,0); samp_index+=1)
		for (diam_index=0; diam_index<dimsize(crit,1); diam_index+=1)
			if (samp_index==3)
				print "3"
			endif

		      print "** Dp, dry = " + num2str(d_dry[diam_index])

			print "	nacl"
			variable diam_nacl = ccn_find_diam_wet(d_dry[diam_index]/1000, crit_nacl[0][diam_index],"kappa_val")
			wave kv = $("kappa_val")
			variable kappa_nacl = kv[0]
			kappa_nacl_w[samp_index][diam_index] = kv[0]

			if (numtype(crit[samp_index][diam_index])==0)
			      print "    	seasweep " + num2str(samp_index)
				variable diam_wet = ccn_find_diam_wet(d_dry[diam_index]/1000, crit[samp_index][diam_index],"kappa_val")
				wave kv = $("kappa_val")
				kappa[samp_index][diam_index] = kv[0]
				diam_wet_w[samp_index][diam_index] =diam_wet*1000
				
				
				variable vol = 4/3*pi*(diam_wet/2)^3
				variable vol_nacl = 4/3*pi*(diam_nacl/2)^3
				volumes[samp_index][diam_index] =  vol
				volumes_nacl[samp_index][diam_index] =  vol_nacl
				
				vol_frac = 1-(vol/vol_nacl)
				variable vol_nacl_meas = vol*(1-vol_frac)
				variable vol_frac_nacl = 1 - (vol_nacl_meas/vol)
				
				vol_frac = vol_frac_nacl
				//if (vol_frac == 0)
				
				//variable vol_ss_meas = vol_tot*(1-vol_frac_ss)
				//vol_frac_ss = 1 - (vol_ss_meas/vol_tot)
				//variable vol_frac_ss = (vol_ss/vol_tot) -1
				//variable vol_frac_as = (vol_as/vol_tot) - 1
				print "Organic volume fraction at "+num2str(diam_dry[diam_index])+"nm = ", vol_frac
			else
				vol_frac = NaN
			endif
			
			org_f[samp_index][diam_index] = vol_frac
		endfor
	endfor
			
	setdatafolder dfr

End

Function ccn_find_org_vol_fractions_old()

	make/o/n=5 diameter_dry  = {40,50,60,80,100}
	wave d_dry = diameter_dry
	
	make/o/T/n=3 labels = {"NaCl", "SargassoSea", "SeaSweep"}
	wave/T labels
	
	make/o/n=(numpnts(d_dry),numpnts(labels)) diameter_wet, kappa
	wave d_wet = diameter_wet
	wave kappa
	d_wet = nan
	kappa = nan
	
	make/o/n=(numpnts(d_dry)) org_fraction_with_nacl, org_fraction_with_ammsulf
	wave org_f_nacl = org_fraction_with_nacl
	wave org_f_as = org_fraction_with_ammsulf
	org_f_nacl = nan
	org_f_as = nan
	
	// as = sargasso sea
	// 40 0.44 50 0.36 60 0.26 80 0.15 100 0.13 100...
	// 40nm
	variable diam_ss = ccn_find_diam_wet(0.040, .435,"kappa_val") //paper
	//variable diam_ss = ccn_find_diam_wet(0.040, .41,"kappa_val")
	wave kv = $("kappa_val")
	kappa[0][0] = kv[0]
	variable diam_as = ccn_find_diam_wet(0.040, .44,"kappa_val")
	wave kv = $("kappa_val")
	kappa[0][1] = kv[0]
	//variable diam_tot = ccn_find_diam_wet(0.040, .76-(0.76*0),"kappa_val") // paper
	variable diam_tot = ccn_find_diam_wet(0.040, .78-(0.76*0),"kappa_val")
	wave kv = $("kappa_val")
	kappa[0][2] = kv[0]

	variable vol_ss = 4/3*pi*(diam_ss/2)^3
	variable vol_as = 4/3*pi*(diam_as/2)^3
	variable vol_tot = 4/3*pi*(diam_tot/2)^3
	variable vol_frac_ss = 1-(vol_tot)/vol_ss
	variable vol_frac_as = 1-(vol_tot)/vol_as
	variable vol_ss_meas = vol_tot*(1-vol_frac_ss)
	vol_frac_ss = 1 - (vol_ss_meas/vol_tot)
	//variable vol_frac_ss = (vol_ss/vol_tot) -1
	//variable vol_frac_as = (vol_as/vol_tot) - 1
	print "Organic volume fraction at 40nm = ", vol_frac_ss
	print "Organic volume fraction (using NH4_2_SO4) at 40nm = ", vol_frac_as
	
	d_wet[0][0] = diam_ss 
	d_wet[0][1] = diam_as
	d_wet[0][2] = diam_tot

	org_f_nacl[0] = vol_frac_ss	
	org_f_as[0] = vol_frac_as	

	// 50nm
	diam_ss = ccn_find_diam_wet(0.050, .31,"kappa_val")
	//diam_ss = ccn_find_diam_wet(0.050, .29,"kappa_val")
	wave kv = $("kappa_val")
	kappa[1][0] = kv[0]
	diam_as = ccn_find_diam_wet(0.050, .36,"kappa_val")
	wave kv = $("kappa_val")
	kappa[1][1] = kv[0]
	//diam_tot = ccn_find_diam_wet(0.050, .46-(0.46*0),"kappa_val") // paper
	diam_tot = ccn_find_diam_wet(0.050, .47-(0.46*0),"kappa_val")
	wave kv = $("kappa_val")
	kappa[1][2] = kv[0]

	vol_ss = 4/3*pi*(diam_ss/2)^3
	vol_as = 4/3*pi*(diam_as/2)^3
	vol_tot = 4/3*pi*(diam_tot/2)^3
	vol_frac_ss = 1-(vol_tot)/vol_ss
	vol_frac_as = 1-(vol_tot)/vol_as
	vol_ss_meas = vol_tot*(1-vol_frac_ss)
	vol_frac_ss = 1 - (vol_ss_meas/vol_tot)
	print "Organic volume fraction at 50nm = ", vol_frac_ss
	print "Organic volume fraction (using NH4_2_SO4) at 50nm = ", vol_frac_as
	
	d_wet[1][0] = diam_ss 
	d_wet[1][1] = diam_as
	d_wet[1][2] = diam_tot

	org_f_nacl[1] = vol_frac_ss	
	org_f_as[1] = vol_frac_as	

	// 60nm
	diam_ss = ccn_find_diam_wet(0.060, .237,"kappa_val")
	//diam_ss = ccn_find_diam_wet(0.060, .22,"kappa_val")
	wave kv = $("kappa_val")
	kappa[2][0] = kv[0]
	diam_as = ccn_find_diam_wet(0.060, .26,"kappa_val")
	wave kv = $("kappa_val")
	kappa[2][1] = kv[0]
	//diam_tot = ccn_find_diam_wet(0.060, .33-(0.33*0),"kappa_val") // paper
	diam_tot = ccn_find_diam_wet(0.060, .35-(0.33*0),"kappa_val")
	wave kv = $("kappa_val")
	kappa[2][2] = kv[0]

	vol_ss = 4/3*pi*(diam_ss/2)^3
	vol_as = 4/3*pi*(diam_as/2)^3
	vol_tot = 4/3*pi*(diam_tot/2)^3
	vol_frac_ss = 1-(vol_tot)/vol_ss
	vol_frac_as = 1-(vol_tot)/vol_as
	vol_ss_meas = vol_tot*(1-vol_frac_ss)
	vol_frac_ss = 1 - (vol_ss_meas/vol_tot)
	print "Organic volume fraction at 60nm = ", vol_frac_ss
	print "Organic volume fraction (using NH4_2_SO4) at 60nm = ", vol_frac_as
	
	d_wet[2][0] = diam_ss 
	d_wet[2][1] = diam_as
	d_wet[2][2] = diam_tot

	org_f_nacl[2] = vol_frac_ss	
	org_f_as[2] = vol_frac_as	

	// 80nm
	diam_ss = ccn_find_diam_wet(0.080, .153,"kappa_val")
	//diam_ss = ccn_find_diam_wet(0.080, .14,"kappa_val")
	wave kv = $("kappa_val")
	kappa[3][0] = kv[0]
	diam_as = ccn_find_diam_wet(0.080, .15,"kappa_val")
	wave kv = $("kappa_val")
	kappa[3][1] = kv[0]
	//diam_tot = ccn_find_diam_wet(0.080, .2-(0.2*0),"kappa_val")
	diam_tot = ccn_find_diam_wet(0.080, .215-(0.2*0),"kappa_val")
	wave kv = $("kappa_val")
	kappa[3][2] = kv[0]

	vol_ss = 4/3*pi*(diam_ss/2)^3
	//vol_as = 4/3*pi*(diam_as/2)^3
	vol_tot = 4/3*pi*(diam_tot/2)^3
	vol_frac_ss = 1-(vol_tot)/vol_ss
	//vol_frac_as = 1-(vol_tot)/vol_as
	vol_ss_meas = vol_tot*(1-vol_frac_ss)
	vol_frac_ss = 1 - (vol_ss_meas/vol_tot)
	print "Organic volume fraction at 50nm = ", vol_frac_ss
	//print "Organic volume fraction (using NH4_2_SO4) at 50nm = ", vol_frac_as
	
	d_wet[3][0] = diam_ss 
	//d_wet[2][1] = diam_as
	d_wet[3][2] = diam_tot

	org_f_nacl[3] = vol_frac_ss	
	//org_f_as[2] = vol_frac_as	

	// 100nm
	diam_ss = ccn_find_diam_wet(0.100, .11,"kappa_val")
	//diam_ss = ccn_find_diam_wet(0.100, .1,"kappa_val")
	wave kv = $("kappa_val")
	kappa[4][0] = kv[0]
	diam_as = ccn_find_diam_wet(0.100, .13,"kappa_val")
	wave kv = $("kappa_val")
	kappa[4][1] = kv[0]
	//diam_tot = ccn_find_diam_wet(0.100, .13-(0.13*0),"kappa_val")
	diam_tot = ccn_find_diam_wet(0.100, .15-(0.13*0),"kappa_val")
	wave kv = $("kappa_val")
	kappa[4][2] = kv[0]

	vol_ss = 4/3*pi*(diam_ss/2)^3
	vol_as = 4/3*pi*(diam_as/2)^3
	vol_tot = 4/3*pi*(diam_tot/2)^3
	vol_frac_ss = 1-(vol_tot)/vol_ss
	vol_frac_as = 1-(vol_tot)/vol_as
	vol_ss_meas = vol_tot*(1-vol_frac_ss)
	vol_frac_ss = 1 - (vol_ss_meas/vol_tot)
	print "Organic volume fraction at 100nm = ", vol_frac_ss, vol_ss, vol_tot, diam_ss, diam_tot
	print "Organic volume fraction (using NH4_2_SO4) at 50nm = ", vol_frac_as
	
	d_wet[4][0] = diam_ss 
	d_wet[4][1] = diam_as
	d_wet[4][2] = diam_tot

	org_f_nacl[4] = vol_frac_ss	
	org_f_as[4] = vol_frac_as	

	

End

Function ccn_find_diam_wet(diam_dry, ss_crit,kappa_wn)
	variable diam_dry
	variable ss_crit
	string kappa_wn

	make/o/n=1 $kappa_wn
	wave kappa_w = $kappa_wn
	
//	dfref dfr = GetDataFolderDFR()
//	newdatafolder/o/s root:ccn
//	newdatafolder/o/s model
//	newdatafolder/o/s kappa
		
	variable R = 8.314 
	variable T = 293 // K
	variable sigma = 0.073 // J/m2
	
	//variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)  * 1e-4
	variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)
	//print A
	
	
	variable kappa = ccn_find_kappa(SS_crit, diam_dry*1000, sigma)
	variable diam_wet = diam_dry
	variable tmp_ss
	variable diam_wet_max = 0
	variable tmp_ss_max = 0
	do
		tmp_ss = (diam_wet^3 - diam_dry^3)/(diam_wet^3 - diam_dry^3*(1-kappa)) * exp(A/diam_wet)
		tmp_ss -= 1
		tmp_ss *= 100
		if (tmp_ss > tmp_ss_max)
			tmp_ss_max = tmp_ss
			diam_wet_max = diam_wet
		endif
		
		diam_wet *= 1.0001		
		//print diam_dry, diam_wet, kappa, tmp_ss, SS_crit
	while (diam_wet < 10.0)
	print kappa, diam_wet_max, tmp_ss_max, diam_wet_max/diam_dry
	
	kappa_w[0] = kappa
	return diam_wet_max
	

//	setdatafolder dfr	

End

Function ccn_find_growth_factor(SS,diam_dry,composition)
	variable SS           // Supersaturation in %
	variable diam_dry // Dry diameter in um
	string composition  // "Seasalt", ??
	
	variable R = 8.314 
	variable T = 293 // K
	variable sigma = 0.073 // J/m2
	
	//variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)  * 1e-4
	variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)
	
	variable ions
	variable dens_solute
	variable MW_solute
	if (cmpstr(composition, "Seasalt")==0)
		ions = 2 
		dens_solute = 2.165
		MW_solute = 58.44
	else
		return 0
	endif
	
	variable B = (ions*MW_h2o*dens_solute) / (DENSITY_h2o * MW_solute)
	variable r_dry = diam_dry/2
	
	variable rad = r_dry
	do
		variable tmp_ss = A/rad - B*(r_dry^3 / rad^3)
		//print A, B, rad*2, A/rad, B*(r_dry^3 / rad^3), ((tmp_ss*100)), (1-B*(r_dry^3/rad^3))*exp(A/rad)
		variable kappa = 1.33
		tmp_ss = ((rad*2)^3 - diam_dry^3)/((rad*2)^3 - diam_dry^3*(1-kappa)) * exp(A/(rad*2))
		print rad*2, diam_dry, kappa,  tmp_ss
		rad *= 1.01
	while (tmp_ss<.90) 
	//while (rad*2<=1000) 
	
	//print (D[i]^3 - dd[row]^3)/(D[i]^3 - dd[row]^3*(1-k[col])) * exp(A/D[i])
	
	
End

// From CCN Model.ipf

Function ccn_find_critical_diam(SS, mw_solute, dens_solute,ions, non_sol_frac)
	variable SS
	variable mw_solute
	variable dens_solute
	variable ions
	variable non_sol_frac
	
	variable B = ions*(1-non_sol_frac)*dens_solute*MW_h2o / (DENSITY_h2o * MW_solute)
//	variable A = 0.00106656 
	variable A =22.9893
//	variable A = 38.1132

	// from JG Hudson, GRL, vol 34, L08801, 2007
	// 	Sc = (4A^3 / 27B)^(1/2) * rd^(-3/2)
	// solving for rd:
	//	rd = Sc^(2/3) / (4A^3 / 27B)^3
	
	// A = 2 sigma / (dens_h2o * Rv * T)
	// sigma = 72.8 dynes/cm = (g cm s-2) cm-1 = g s-2 -or- .0.072 J m-2 = 0.072 kg s-2
	// dens = 1.0 g cm-3 -or - 1000 kg m-3
	// Rv = 461.5 J kg-1 K-1 = 461.5 (kg m2 s-2) kg-1 K-1
	// T = K
	// 1)
	// 2) ( kg s-2 ) / ( (kg m-3) (m2 s-2 K-1) (K) )= () / (kg m-1)  need MW in kg
	
	//print "SS=",SS, "nos_sol_frac=",non_sol_frac
	//print 4*A^3, 27*B
	//print ( (4*A^3)/(27*B) )
	//print ( (4*A^3)/(27*B) )^(1/2)
	

	variable rd = ( (4*(A^3)) / (27*B))^(1/3) * SS^(-2/3)
	//print "	A=", 1/A, ",	B=", B
	//print "	rd = ", rd
	return rd*2/1000 // return microns
End

// see parameters below
Function ccn_find_kappa_wave(SS, Dcrit_w, sfc_tension,kappa_wn)
	//variable SS
	wave SS
	wave Dcrit_w
	variable sfc_tension
	string kappa_wn

	duplicate/o Dcrit_w, $kappa_wn
	wave kappa_w = $kappa_wn
	
	kappa_w = ccn_find_kappa(SS[p], Dcrit_w[p], sfc_tension)

End

//  ccn_find_critical_diam_SandP
//	Rewrite of function above using equations from Seinfeld and Pandis to calculate
//	critical diameter. Requires a little more information:
//		density and molecular weight of  insoluble fraction 
//		surface tension
//		Temperature ? // for now, leave it at 20C
//	Arguments:
//		SS -- supersaturation -- % (e.g., .15%)
//		mw_solute -- Mw of solute -- g/mol (e.g., NaCl = 58.44 g/mol )
//		dens_solute -- density of solute -- g/cm3 (e.g., NaCl = 2.165 g/cm3)
//		ions -- number of ions when dissociated -- # (e.g., NaCl = 2, (NH4)2SO4 = 3)
// 		non_sol_fract -- non-soluble fraction -- 0 <= non_sol_frac <= 1
//		mw_non_sol -- Mw of non-soluble fraction - g/mol
//		dens_non_sol -- density of non-soluble fraction -- g/cm3
//		sfc_tension -- surface tension between liquid and gas -- J/m2 -- (normal air/water = 0.073 J/m2) 
//		 
//
Function ccn_find_kappa(SS, Dcrit, sfc_tension)
	variable SS
	variable Dcrit // nm
	variable sfc_tension
	
	variable R = 8.314 
	variable T = 293 // K
	
	variable A = (4*MW_h2o*sfc_tension) / (R*T*DENSITY_h2o)  * 1e-4
	
	variable B1 = 4 * (A)^3
		
	SS /= 100
	SS += 1
	variable B2 = 27 * (Dcrit/1e7)^3 * (ln(SS))^2
	
	variable kappa = B1/B2
	return kappa
	
	
	//variable B = ions*(1-non_sol_frac)*dens_solute*MW_h2o / (DENSITY_h2o * MW_solute)
//	variable A = 0.00106656 
//	variable A =22.9893
//	variable A = 38.1132

	// from JG Hudson, GRL, vol 34, L08801, 2007
	// 	Sc = (4A^3 / 27B)^(1/2) * rd^(-3/2)
	// solving for rd:
	//	rd = Sc^(2/3) / (4A^3 / 27B)^3
	
	// A = 2 sigma / (dens_h2o * Rv * T)
	// sigma = 72.8 dynes/cm = (g cm s-2) cm-1 = g s-2 -or- .0.072 J m-2 = 0.072 kg s-2
	// dens = 1.0 g cm-3 -or - 1000 kg m-3
	// Rv = 461.5 J kg-1 K-1 = 461.5 (kg m2 s-2) kg-1 K-1
	// T = K
	// 1)
	// 2) ( kg s-2 ) / ( (kg m-3) (m2 s-2 K-1) (K) )= () / (kg m-1)  need MW in kg
	
	//print "SS=",SS, "nos_sol_frac=",non_sol_frac
	//print 4*A^3, 27*B
	//print ( (4*A^3)/(27*B) )
	//print ( (4*A^3)/(27*B) )^(1/2)
	

	//variable rd = ( (4*(A^3)) / (27*B))^(1/3) * SS^(-2/3)
	//print "	A=", 1/A, ",	B=", B
	//print "	rd = ", rd
	//return rd*2/1000 // return microns
End


//  ccn_find_critical_diam_SandP
//	Rewrite of function above using equations from Seinfeld and Pandis to calculate
//	critical diameter. Requires a little more information:
//		density and molecular weight of  insoluble fraction 
//		surface tension
//		Temperature ? // for now, leave it at 20C
//	Arguments:
//		SS -- supersaturation -- % (e.g., .15%)
//		mw_solute -- Mw of solute -- g/mol (e.g., NaCl = 58.44 g/mol )
//		dens_solute -- density of solute -- g/cm3 (e.g., NaCl = 2.165 g/cm3)
//		ions -- number of ions when dissociated -- # (e.g., NaCl = 2, (NH4)2SO4 = 3)
// 		non_sol_fract -- non-soluble fraction -- 0 <= non_sol_frac <= 1
//		mw_non_sol -- Mw of non-soluble fraction - g/mol
//		dens_non_sol -- density of non-soluble fraction -- g/cm3
//		sfc_tension -- surface tension between liquid and gas -- J/m2 -- (normal air/water = 0.073 J/m2) 
//		 
//
Function ccn_find_critical_diam_SandP(SS, mw_solute, dens_solute,ions, non_sol_frac, mw_non_sol, dens_non_sol,sfc_tension)
	variable SS
	variable mw_solute
	variable dens_solute
	variable ions
	variable non_sol_frac
	variable mw_non_sol
	variable dens_non_sol
	variable sfc_tension
	
	variable R = 8.314 
	variable T = 293 // K
	variable sol_frac = 1-non_sol_frac //SandP use sol fraction in their eqns
	
	variable A = (4*MW_h2o*sfc_tension) / (R*T*DENSITY_h2o)
	
	variable B1A = 4 * mw_solute * DENSITY_h2o * A^3
	
	variable B1B = (sol_frac/dens_solute) + ( (1-sol_frac)/dens_non_sol )
	SS /= 100
	SS += 1
	variable B2 = 27 * ions * sol_frac * MW_h2o * (ln(SS))^2
	
	variable dcrit = ( B1A * B1B / B2)^(1/3)
	return dcrit
	
	
	//variable B = ions*(1-non_sol_frac)*dens_solute*MW_h2o / (DENSITY_h2o * MW_solute)
//	variable A = 0.00106656 
//	variable A =22.9893
//	variable A = 38.1132

	// from JG Hudson, GRL, vol 34, L08801, 2007
	// 	Sc = (4A^3 / 27B)^(1/2) * rd^(-3/2)
	// solving for rd:
	//	rd = Sc^(2/3) / (4A^3 / 27B)^3
	
	// A = 2 sigma / (dens_h2o * Rv * T)
	// sigma = 72.8 dynes/cm = (g cm s-2) cm-1 = g s-2 -or- .0.072 J m-2 = 0.072 kg s-2
	// dens = 1.0 g cm-3 -or - 1000 kg m-3
	// Rv = 461.5 J kg-1 K-1 = 461.5 (kg m2 s-2) kg-1 K-1
	// T = K
	// 1)
	// 2) ( kg s-2 ) / ( (kg m-3) (m2 s-2 K-1) (K) )= () / (kg m-1)  need MW in kg
	
	//print "SS=",SS, "nos_sol_frac=",non_sol_frac
	//print 4*A^3, 27*B
	//print ( (4*A^3)/(27*B) )
	//print ( (4*A^3)/(27*B) )^(1/2)
	

	//variable rd = ( (4*(A^3)) / (27*B))^(1/3) * SS^(-2/3)
	//print "	A=", 1/A, ",	B=", B
	//print "	rd = ", rd
	//return rd*2/1000 // return microns
End

//  ccn_find_critical_SS_SandP
//	Rewrite of function above using equations from Seinfeld and Pandis to calculate
//	critical SS. Requires a little more information:
//		density and molecular weight of  insoluble fraction 
//		surface tension
//		Temperature ? // for now, leave it at 20C
//	Arguments:
//		Dcrit -- critical diameter -- um (e.g., 0.035)
//		mw_solute -- Mw of solute -- g/mol (e.g., NaCl = 58.44 g/mol )
//		dens_solute -- density of solute -- g/cm3 (e.g., NaCl = 2.165 g/cm3)
//		ions -- number of ions when dissociated -- # (e.g., NaCl = 2, (NH4)2SO4 = 3)
// 		non_sol_fract -- non-soluble fraction -- 0 <= non_sol_frac <= 1
//		mw_non_sol -- Mw of non-soluble fraction - g/mol
//		dens_non_sol -- density of non-soluble fraction -- g/cm3
//		sfc_tension -- surface tension between liquid and gas -- J/m2 -- (normal air/water = 0.073 J/m2) 
//		 
//
Function ccn_find_critical_SS_SandP(Dcrit, mw_solute, dens_solute,ions, non_sol_frac, mw_non_sol, dens_non_sol,sfc_tension)
	variable Dcrit
	variable mw_solute
	variable dens_solute
	variable ions
	variable non_sol_frac
	variable mw_non_sol
	variable dens_non_sol
	variable sfc_tension
	
	variable R = 8.314 
	variable T = 293 // K
	variable sol_frac = 1-non_sol_frac //SandP use sol fraction in their eqns
	
	variable A = (4*MW_h2o*sfc_tension) / (R*T*DENSITY_h2o)
	print "A = ", A
	variable B1A = 4 * mw_solute * DENSITY_h2o * A^3
	//print B1A
	
	variable B1B = (sol_frac/dens_solute) + ( (1-sol_frac)/dens_non_sol )
	//print B1B

	variable kappa = (ions  * MW_h2o * dens_solute) / (mw_solute* DENSITY_h2o)
	print "kappa = ", kappa 
	//SS /= 100
	//SS += 1
	//variable B2 = 27 * ions * sol_frac * MW_h2o * (ln(SS))^2
	
	variable SS;
	//SS = exp( sqrt( (4 * A^3 * mw_solute* DENSITY_h2o) / (27 * ions  * MW_h2o * dens_solute * Dcrit^3) ) )
	SS = exp( sqrt( (4 * A^3) / (27 * kappa * Dcrit^3) ) )
	
	SS -= 1
	SS *= 100
	//variable dcrit = ( B1A * B1B / B2)^(1/3)
	//return dcrit
	return SS
End

Function ccn_mono_calc()
	
	string sdf = getdatafolder(1)
	setdatafolder root:
	newdatafolder/O/S ccn_mono
	
	make/o/n=6 ss_levels
	wave ss = ss_levels
	//ss = {.05,.1,.15,.2,.25,.3,.35,.4,.45,.5,.55,.6,.65,.7,.75,.8,.85,.9,.95,1.0}
	ss = {.15,.25,.5,.75,1.0}
	
	make/o/n=(numpnts(ss)) diam_crit_100, diam_crit_50
	wave dc_100 = diam_crit_100
	wave dc_50 = diam_crit_50

	make/o/n=(numpnts(ss),5)  diam_ccn
	wave dp_ccn = diam_ccn
	

	variable i,j
	variable ions = 3
	for (i=0; i<numpnts(ss); i+=1)
		dc_100[i] = ccn_find_critical_diam(ss[i],MW_nh4_2_so4,DENSITY_nh4_2_so4,ions,0.0)
		dc_50[i] = ccn_find_critical_diam(ss[i],MW_nh4_2_so4,DENSITY_nh4_2_so4,ions,0.5)
		
		for (j=0; j<5; j+=1)
			if (j==0) 
				dp_ccn[j][i] = dc_50[i] / 1.2
			elseif (j==1)
				dp_ccn[j][i] = dc_50[i]
			else 
				dp_ccn[j][i] = dp_ccn[j-1][i] * 1.2
			endif
		endfor	
	endfor

  

End

// 
Function ccn_find_POM_mf(SS, mw_solute, dens_solute,ions,B)
	variable SS
	variable mw_solute
	variable dens_solute
	variable ions
	variable B
	
//	variable B = ions*(1-non_sol_frac)*dens_solute*MW_h2o / (DENSITY_h2o * MW_solute)
	variable pom_mf =  B*(DENSITY_h2o * MW_solute) / (ions*dens_solute*MW_h2o)
	pom_mf  = 1-pom_mf
	pom_mf = (pom_mf < 0) ? 0 : pom_mf
	return pom_mf

//	variable A = 0.00106656 
	variable A =22.9893
//	variable A = 38.1132

	// from JG Hudson, GRL, vol 34, L08801, 2007
	// 	Sc = (4A^3 / 27B)^(1/2) * rd^(-3/2)
	// solving for rd:
	//	rd = Sc^(2/3) / (4A^3 / 27B)^3
	
	// A = 2 sigma / (dens_h2o * Rv * T)
	// sigma = 72.8 dynes/cm = (g cm s-2) cm-1 = g s-2 -or- .0.072 J m-2 = 0.072 kg s-2
	// dens = 1.0 g cm-3 -or - 1000 kg m-3
	// Rv = 461.5 J kg-1 K-1 = 461.5 (kg m2 s-2) kg-1 K-1
	// T = K
	// 1)
	// 2) ( kg s-2 ) / ( (kg m-3) (m2 s-2 K-1) (K) )= () / (kg m-1)  need MW in kg
	
	//print "SS=",SS, "nos_sol_frac=",non_sol_frac
	//print 4*A^3, 27*B
	//print ( (4*A^3)/(27*B) )
	//print ( (4*A^3)/(27*B) )^(1/2)
	

	variable rd = ( (4*(A^3)) / (27*B))^(1/3) * SS^(-2/3)
	//print "	A=", 1/A, ",	B=", B
	//print "	rd = ", rd
	return rd*2/1000 // return microns
End


Function test_functions()
	
	variable i, j, k
	variable ss
	variable pom_mf = 0
	variable ions = 3
	variable dcrit
	variable mf 
	
	for (i=2; i<=10; i+=2)
		ss = i/10
		//print ss
		dcrit = ccn_find_critical_diam(ss,MW_nh4_2_so4,DENSITY_nh4_2_so4,ions,pom_mf)
		//print "Crit Diameter = ", dcrit
		mf = ccn_find_POM_mf(ss,MW_nh4_2_so4,DENSITY_nh4_2_so4,ions,1.23)
		print "mf = ", mf
	endfor
		

End


Function ccn_generate_size_dist(meanDp, model_dp, out_dist_name)
	variable meanDp
	wave model_dp
	string out_dist_name
	
//m4[i] = (total[j][3]/(sqrt(2.*PI)*log10(sigma[j][3]))) * (exp(-(pow(log10(Dp[i]/mean[j][3]),2.)) / (2.*pow(log10(sigma[j][3]),2.))));

//	variable meanDp = 0.060
	variable totN = 3000
	variable sigma = 1.5
	
	// create merged waves on standard diameter step
//	variable dp_cols = 96
//	variable start_dp = .02
//	variable stop_dp = 1
//	make/o/n=(dp_cols) model_dp
//	SetScale/I x log(start_dp),log(stop_dp),"um" model_dp	
//
//	model_dp[0] = start_dp
//	model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1))

	make/o/D/n=(numpnts(model_dp)) $(out_dist_name)
	wave dndlogdp = $(out_dist_name)
	
	dndlogdp= ( totN/ (sqrt(2*PI)*log(sigma)) ) * ( exp( -(log(model_dp[p]/meanDp)^2) / (2*(log(sigma)^2)) ) )
	
	//killwaves/Z model_dp
End

Function ccn_get_ccn_conc(critDp, dp, dndlogdp)
	variable critDp
	wave dp
	wave dndlogdp
	
	// find dlogDp
	make/O/D/N=(numpnts(dp)) dlogDp_w
	wave dlogDp = dlogDp_w
	
	dlogDp = log(dp[p+1]/dp[p])
	dlogDp[numpnts(dlogDp)-1] = dlogDp[numpnts(dlogDp)-2]

	//convert to dN
	duplicate/o dndlogdp dn
	dn = dndlogdp * dlogDp
	
	
	// find CCN for critDp
	variable i
	variable ccn = 0
	for (i=numpnts(dn)-1; i>=0; i-=1)
		if (dp[i] >= critDp)
			ccn += dn[i]
		endif
	endfor
	return ccn
	
End

Function ccn_model_sens_by_chem()

	// SS range
	make/o/N=5 SS_range
	SS_range = {.2,.4,.6,.8,1.0}
	wave SS = SS_range

	// POM mass fraction range
	make/o/N=6 POM_mf_range
	// 12 July 2007 add extra steps to account for range seen in TexAQS
//	POM_mf_range = {0,.2,.4,.6,.8,1.0}
	POM_mf_range = {0,.1,.2,.3,.4,.5,.6,.7,.8,.9,1.0}
	wave pom_mf = POM_mf_range
	
	// output results
	make/O/N=(numpnts(pom_mf),numpnts(SS)) ccn_change_with_chemistry
	wave results = ccn_change_with_chemistry

//	make/O/N=(numpnts(pom_mf)-1,numpnts(SS)) d_ccn_change_with_chemistry
	make/O/N=(numpnts(pom_mf),numpnts(SS)) d_ccn_change_with_chemistry
	wave dresults = d_ccn_change_with_chemistry
	dresults = NaN

	// sensitivity results from TexAQS
	make/O/N=(2,numpnts(SS)) texaqs_d_ccn_chemistry_pmel
	wave texaqs_dresults_pmel = texaqs_d_ccn_chemistry_pmel
	texaqs_dresults_pmel=NaN

	make/O/N=(2,numpnts(SS)) texaqs_d_ccn_chemistry_dusek
	wave texaqs_dresults_dusek = texaqs_d_ccn_chemistry_dusek
	texaqs_dresults_dusek=NaN

	make/o/n=(2) pmel_pom_range
	wave pmel_pom_r = pmel_pom_range
//	pmel_pom_r = {0.1, 0.9}
	pmel_pom_r = {0.2, 0.6}
	
	make/o/n=(2) dusek_pom_range
	wave dusek_pom_r = dusek_pom_range
	dusek_pom_r = {0.6, 0.8}
	
	variable meanDp = 0.060
	// create merged waves on standard diameter step
	variable dp_cols = 200
	variable start_dp = .001
	variable stop_dp = 1
	make/o/n=(dp_cols) model_dp
	SetScale/I x log(start_dp),log(stop_dp),"um" model_dp	

	model_dp[0] = start_dp
	model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1))

	// generate dp and size dist
	ccn_generate_size_dist(meanDp, model_dp, "dNdlogDp_for_chem")
	wave dndlogDp = $("dNdlogDp_for_chem")
	
	// add intN for differential 
	variable intN = ccn_get_ccn_conc(0, model_dp, dndlogDp)
	
	variable i,j
	for (i=0; i<numpnts(pom_mf); i+=1)
		for (j=0; j<numpnts(SS); j+=1)
			
			// find critDp using Kohler eqn
			variable critDp = ccn_find_critical_diam(SS[j], MW_nh4_2_so4, DENSITY_nh4_2_so4,3, pom_mf[i])
			
			// get conc based on critDp and dndlogDp
			results[i][j] = ccn_get_ccn_conc(critDp, model_dp, dndlogDp)
		endfor
	endfor

	for (j=0; j<numpnts(SS); j+=1)
		// change to ratio of pct changed values 26 June 2007 - we are now looking at pct diff ccn / pct of full scale pom_mf
//		dresults[][j] = (results[p+1][j] - results[p][j]) / (pom_mf[p+1] - pom_mf[p])
		dresults[][j] = ( ( (results[p+1][j] - results[p][j])/(intN)) / ( (pom_mf[p+1] - pom_mf[p])/(pom_mf[numpnts(pom_mf)-1]-pom_mf[0]) ) )

//		texaqs_dresults_pmel[0,1][j] = -( ( (results[9][j] - results[1][j])/(intN)) / ( (pom_mf[9] - pom_mf[1])/(pom_mf[numpnts(pom_mf)-1]-pom_mf[0]) ) )
//		texaqs_dresults_dusek[0,1][j] = -( ( (results[8][j] - results[6][j])/(intN)) / ( (pom_mf[8] - pom_mf[6])/(pom_mf[numpnts(pom_mf)-1]-pom_mf[0]) ) )

		texaqs_dresults_pmel[0,1][j] = -( ( (results[6][j] - results[2][j])/intN) / (  ((0.39+0.23)-(0.39-0.23)) / (  (0.84-0.04) ) ) )
		texaqs_dresults_dusek[0,1][j] = -( ( (results[8][j] - results[6][j])/intN) / ( .2/ (0.84-0.04) ) )

	endfor
	dresults[numpnts(pom_mf)-1][] = dresults[numpnts(pom_mf)-2][q] 

End

//Function ccn_model_sens_by_size()
//
//	// SS range
//	make/o/N=5 SS_range
//	SS_range = {.2,.4,.6,.8,1.0}
//	wave SS = SS_range
//
//	// mean diameter range
//	make/o/N=9 meanDp_range
//	// 12 July 2007 change range based on variability seen in TexAQS
////	meanDp_range = {0.030,0.045,0.060,0.075,0.090,0.105,0.120,0.066,0.083}
//	meanDp_range = {0.020,0.042,0.060,0.075,0.080,0.100,0.120,0.066,0.083}
//	wave meanDp = meanDp_range
//	
//	// output results
//	make/O/N=(numpnts(meanDp),numpnts(SS)) ccn_change_with_meanDp
//	wave results = ccn_change_with_meanDp
//
//
//	make/O/N=(numpnts(meanDp)-1,numpnts(SS)) d_ccn_change_with_meanDp
//	wave dresults = d_ccn_change_with_meanDp
//	dresults = NaN
//
//	// sensitivity results from TexAQS
//	make/O/N=(2,numpnts(SS)) texaqs_d_ccn_meanDp_pmel
//	wave texaqs_dresults_pmel = texaqs_d_ccn_meanDp_pmel
//	texaqs_dresults_pmel=NaN
//	
//	make/O/N=(2,numpnts(SS)) texaqs_d_ccn_meanDp_dusek
//	wave texaqs_dresults_dusek = texaqs_d_ccn_meanDp_dusek
//	texaqs_dresults_dusek=NaN
//
//	make/o/n=(2) pmel_meanDp_range
//	wave pmel_meanDp_r = pmel_meanDp_range
////	pmel_meanDp_r = {0.020, 0.120}
//	pmel_meanDp_r = {0.042, 0.100}
//	
//	make/o/n=(2) dusek_meanDp_range
//	wave dusek_meanDp_r = dusek_meanDp_range
//	dusek_meanDp_r = {0.066, 0.083}
//
//	//variable meanDp = 0.060
//	// create merged waves on standard diameter step
//	variable dp_cols = 200
//	variable start_dp = .001
//	variable stop_dp = 1
//	make/o/n=(dp_cols) model_dp
//	SetScale/I x log(start_dp),log(stop_dp),"um" model_dp	
//
//	model_dp[0] = start_dp
//	model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1))
//
//	// add intN for differential 
//	make/o/n=(numpnts(meanDp)) intN_w
//	wave intN = intN_w
//	
//	variable i,j
//	for (i=0; i<numpnts(meanDp); i+=1)
//
//		ccn_generate_size_dist(meanDp[i], model_dp, "dNdlogDp_for_meanDp")
//		wave dndlogDp = $("dNdlogDp_for_meanDp")
//
//		for (j=0; j<numpnts(SS); j+=1)
//						
//			// find critDp using Kohler eqn
//			variable critDp = ccn_find_critical_diam(SS[j], MW_nh4_2_so4, DENSITY_nh4_2_so4,3, 0)
//						
//			// get conc based on critDp and dndlogDp
//			results[i][j] = ccn_get_ccn_conc(critDp, model_dp, dndlogDp)
//		endfor
//		
//		intN[i] = ccn_get_ccn_conc(0, model_dp, dndlogDp)
//		
//	endfor
//
//	for (j=0; j<numpnts(SS); j+=1)
//		// change to ratio of pct changed values 26 June 2007 - we are now looking at pct diff ccn / pct of full scale dp
////		dresults[][j] = (results[p+1][j] - results[p][j]) / (meanDp[p+1]*1000 - meanDp[p]*1000)
//		// our diameter steps
////		dresults[0,5][j] = ( ( (results[p+1][j] - results[p][j])/(intN) ) /  ( (meanDp[p+1] - meanDp[p])/(meanDp[6]-meanDp[0]) ) )
//		dresults[0,5][j] = ( ( (results[p+1][j]/intN[p+1] - results[p][j]/intN[p]) ) /  ( (meanDp[p+1] - meanDp[p])/(meanDp[6]-meanDp[0]) ) )
//		// comparison diameters
////		dresults[7][j] = ( ( (results[p+1][j] - results[p][j])/(intN) ) /  ( (meanDp[p+1]*1000 - meanDp[p])/(meanDp[6]-meanDp[0]) ) )
//		dresults[7][j] = ( ( (results[p+1][j]/intN[p+1] - results[p][j]/intN[p]) ) /  ( (meanDp[p+1] - meanDp[p])/(meanDp[6]-meanDp[0]) ) )
//		
////		texaqs_dresults_pmel[0,1][j] = ( ( (results[6][j]/intN[6] - results[0][j]/intN[0]) ) /  ( (meanDp[6] - meanDp[0])/(meanDp[6]-meanDp[0]) ) )
////		texaqs_dresults_dusek[0,1][j] = ( ( (results[8][j]/intN[8] - results[7][j]/intN[7]) ) /  ( (meanDp[8] - meanDp[7])/(meanDp[6]-meanDp[0]) ) )
//
//		texaqs_dresults_pmel[0,1][j] = ( ( (results[5][j] - results[1][j])/intN[i] ) /  ( ( (71.1+28.7)-(71.1-28.7) ) / (130-17.5) ) )
//		texaqs_dresults_dusek[0,1][j] = ( ( (results[8][j] - results[7][j])/intN[i] ) /  ( 17/ (130-17.5) ) )
//
//		dresults[6][] = dresults[5][q] 
//
//	endfor
//
//End

Function ccn_get_pct_change()

	// SS range
	make/o/N=5 SS_range
	SS_range = {.2,.4,.6,.8,1.0}
	wave SS = SS_range
	
	// testing 26 June 2007
//	wave ccn = ccn_change_with_chemistry
	wave ccn = ccn_change_with_chemistry
	wave pom_mf = POM_mf_range
	wave meanDp = meanDp_range
	
	make/o/n=(2) large_pom_range
	wave large_pom_r = large_pom_range
	large_pom_r = {0.2, 0.8}
	
	make/o/n=(2) small_pom_range
	wave small_pom_r = small_pom_range
	small_pom_r = {0.6, 0.8}
	
	make/o/n=(2,numpnts(SS)) pct_change_large_pom_range
	wave large_pom = pct_change_large_pom_range

	make/o/n=(2,numpnts(SS)) pct_change_small_pom_range
	wave small_pom = pct_change_small_pom_range

	variable i
	for (i=0; i<numpnts(SS); i+=1)
		large_pom[][i] = -(ccn[9][i] - ccn[1][i])/ccn[1][i] * 100
		small_pom[][i] = -(ccn[4][i] - ccn[3][i])/ccn[3][i] * 100
//		large_pom[][i] = (results[1][i]/results[4][i]) * 100
//		small_pom[0,][i] = (results[3][i]/results[4][i]) * 100
	endfor


	// testing 26 June 2007
//	wave ccn = ccn_change_with_meanDp
	wave ccn = ccn_change_with_meanDp
	
	make/o/n=(2) large_meanDp_range
	wave large_meanDp_r = large_meanDp_range
	large_meanDp_r = {0.045, 0.075}
	
	make/o/n=(2) small_meanDp_range
	wave small_meanDp_r = small_meanDp_range
	small_meanDp_r = {0.066, 0.083}

	make/o/n=(2,numpnts(SS)) pct_change_large_meanDp_range
	wave large_meanDp = pct_change_large_meanDp_range
	
	make/o/n=(2,numpnts(SS)) pct_change_small_meanDp_range
	wave small_meanDp = pct_change_small_meanDp_range

	for (i=0; i<numpnts(SS); i+=1)
		large_meanDp[][i] = (ccn[3][i] - ccn[1][i])/ccn[3][i] * 100
		small_meanDp[][i] = (ccn[8][i] - ccn[7][i])/ccn[8][i] * 100
//		large_pom[][i] = (results[1][i]/results[4][i]) * 100
//		small_pom[0,][i] = (results[3][i]/results[4][i]) * 100
	endfor

End

Function ccn_difference_matrix()

	// SS range
	make/O/D/N=3 SS_range
	// added .44 to compare with the rest of Trish's TexAQS data
	//SS_range = {.2,.4,.44,.6,.8,1.0}
	SS_range = {.22,.44,1.0}
	wave SS = SS_range

	variable Dim_conc = 201
	
	
	variable first_dp = .020
	variable first_dp_nm = first_dp*1000
//	variable last_dp = 0.120
	variable last_dp = 0.140
	variable last_dp_nm = last_dp*1000
//	variable last_dp = 0.260
	make/o/D/n=(Dim_conc) ccn_conc_dp
	wave conc_dp = ccn_conc_dp
	conc_dp[0] = first_dp
	conc_dp[1,] = conc_dp[p-1] + ( (last_dp-first_dp)/(numpnts(conc_dp)-1) )
	
	variable first_pom = 0
	variable last_pom = 1.0
	make/o/D/n=(Dim_conc) ccn_conc_pom_mf
	wave conc_pom = ccn_conc_pom_mf
	conc_pom[0] = first_pom
	conc_pom[1,] = conc_pom[p-1] + ( (last_pom-first_pom)/(numpnts(conc_pom)-1) )

//	make/o/D/n=(Dim_conc,Dim_conc) ccn_conc_matrix
//	wave conc_mat = ccn_conc_matrix
//	SetScale/P x first_dp,(  (last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" conc_mat	
//	SetScale/P y first_pom,(  (last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" conc_mat	
//	conc_mat = NaN
//
//	variable dDim_conc = (Dim_conc-1)/2
//	make/o/D/n=(dDim_conc,dDim_conc) ccn_dconc_matrix_pom
//	wave dconc_mat_pom = ccn_dconc_matrix_pom
//	SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_pom	
//	SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_pom	
//	dconc_mat_pom = NaN
//
//	make/o/D/n=(dDim_conc,dDim_conc) ccn_dconc_matrix_dp
//	wave dconc_mat_dp = ccn_dconc_matrix_dp
//	SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_dp	
//	SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_dp	
//	dconc_mat_dp = NaN
//
//	make/o/D/n=(dDim_conc,dDim_conc) ccn_dconc_matrix
//	wave dconc_mat = ccn_dconc_matrix
//	SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat	
//	SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat	
//	dconc_mat = NaN

	//variable meanDp = 0.060
	// create merged waves on standard diameter step
	variable dp_cols = 10000
	variable start_dp = .001
	variable stop_dp = 1
	make/o/D/n=(dp_cols) model_dp_w
	wave model_dp = model_dp_w
	variable model_range = 1.5 * 4 // = 4 sigma of lognormal generation
//	model_dp[0] = start_dp
//	model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1))

	
	variable i,j,k
	for (i=0; i<numpnts(SS); i+=1) // 0.2% only for now

		make/o/D/n=(Dim_conc,Dim_conc) $("ccn_conc_matrix_"+num2str(SS[i]))
		wave conc_mat = $("ccn_conc_matrix_"+num2str(SS[i]))
		SetScale/P x first_dp,(  (last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" conc_mat	
		SetScale/P y first_pom,(  (last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" conc_mat	
		conc_mat = NaN
	
		variable dDim_conc = (Dim_conc-1)/2
		make/o/D/n=(dDim_conc,dDim_conc) $("ccn_dconc_matrix_pom_"+num2str(SS[i]))
		wave dconc_mat_pom = $("ccn_dconc_matrix_pom_"+num2str(SS[i]))
		SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_pom	
		SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_pom	
		dconc_mat_pom = NaN
	
		make/o/D/n=(dDim_conc,dDim_conc) $("ccn_dconc_matrix_dp_"+num2str(SS[i]))
		wave dconc_mat_dp = $("ccn_dconc_matrix_dp_"+num2str(SS[i]))
		SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_dp	
		SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_dp	
		dconc_mat_dp = NaN
	
		make/o/D/n=(dDim_conc,dDim_conc) $("ccn_dconc_matrix_"+num2str(SS[i]))
		wave dconc_mat = $("ccn_dconc_matrix_"+num2str(SS[i]))
		SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat	
		SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat	
		dconc_mat = NaN




		for (j=0; j<numpnts(conc_dp); j+=1)

			// model size dist is +/- 4 sigma (=6)
			start_dp = conc_dp[j]/model_range
			stop_dp = conc_dp[j]*model_range
			model_dp[0] = start_dp
			model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1)) 

			ccn_generate_size_dist(conc_dp[j], model_dp, "dNdlogDp_for_meanDp")
			wave dndlogDp = $("dNdlogDp_for_meanDp")
			
			for (k=0; k<numpnts(conc_pom); k+=1)
			
				// find critDp using Kohler eqn
				variable critDp = ccn_find_critical_diam(SS[i], MW_nh4_2_so4, DENSITY_nh4_2_so4,3, conc_pom[k])
			
				// get conc based on critDp and dndlogDp
				conc_mat[j][k] = ccn_get_ccn_conc(critDp, model_dp, dndlogDp)
				
			endfor						
		
		endfor

		variable incj, inck
		incj=0
		for (j=1; j<numpnts(conc_dp)-1; j+=2)
				
			inck=0
			for (k=1; k<numpnts(conc_pom)-1; k+=2)
			
				// get dconc of pom and dp 
				//dconc_mat_dp[incj][inck] = conc_mat[j+1][k] - conc_mat[j-1][k]
				dconc_mat_pom[incj][inck] = conc_mat[j][k-1] - conc_mat[j][k+1]
//				dconc_mat[incj][inck] = dconc_mat_pom[incj][inck] / dconc_mat_dp[incj][inck]
				inck += 1
			endfor
						
			incj += 1
		endfor

				
		inck=0
		for (k=1; k<numpnts(conc_pom)-1; k+=2)
			
			incj=0
			for (j=1; j<numpnts(conc_dp)-1; j+=2)

				// get dconc of pom and dp 
				dconc_mat_dp[incj][inck] = conc_mat[j+1][k] - conc_mat[j-1][k]
//				dconc_mat_pom[incj][inck] = conc_mat[j][k-1] - conc_mat[j][k+1]
				//dconc_mat[incj][inck] = dconc_mat_pom[incj][inck] / dconc_mat_dp[incj][inck]
			incj += 1
			endfor
						
			inck += 1
		endfor

		dconc_mat = dconc_mat_pom / dconc_mat_dp

	endfor
End

Function ccn_conc_matrix_dgn_dcrit()

	string sdf = getdatafolder(1)
	setdatafolder root:
	newdatafolder/O/S dgn_v_dcrit
	
//	// SS range
//	make/O/D/N=3 SS_range
//	// added .44 to compare with the rest of Trish's TexAQS data
//	//SS_range = {.2,.4,.44,.6,.8,1.0}
//	SS_range = {.22,.4,.44,1.0}
//	wave SS = SS_range

	variable Dim_conc = 201
	
	
	variable first_dp = .020
	variable first_dp_nm = first_dp*1000
//	variable last_dp = 0.120
	variable last_dp = 0.140
	variable last_dp_nm = last_dp*1000
//	variable last_dp = 0.260
	make/o/D/n=(Dim_conc) ccn_conc_dp
	wave conc_dp = ccn_conc_dp
	conc_dp[0] = first_dp
	conc_dp[1,] = conc_dp[p-1] + ( (last_dp-first_dp)/(numpnts(conc_dp)-1) )
	
	variable first_dcrit = 0.050
	variable last_dcrit = 0.150
	make/o/D/n=(Dim_conc) ccn_conc_dcrit
	wave conc_dcrit = ccn_conc_dcrit
	conc_dcrit[0] = first_dcrit
	conc_dcrit[1,] = conc_dcrit[p-1] + ( (last_dcrit-first_dcrit)/(numpnts(conc_dcrit)-1) )

//	make/o/D/n=(Dim_conc,Dim_conc) ccn_conc_matrix
//	wave conc_mat = ccn_conc_matrix
//	SetScale/P x first_dp,(  (last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" conc_mat	
//	SetScale/P y first_pom,(  (last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" conc_mat	
//	conc_mat = NaN
//
//	variable dDim_conc = (Dim_conc-1)/2
//	make/o/D/n=(dDim_conc,dDim_conc) ccn_dconc_matrix_pom
//	wave dconc_mat_pom = ccn_dconc_matrix_pom
//	SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_pom	
//	SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_pom	
//	dconc_mat_pom = NaN
//
//	make/o/D/n=(dDim_conc,dDim_conc) ccn_dconc_matrix_dp
//	wave dconc_mat_dp = ccn_dconc_matrix_dp
//	SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_dp	
//	SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_dp	
//	dconc_mat_dp = NaN
//
//	make/o/D/n=(dDim_conc,dDim_conc) ccn_dconc_matrix
//	wave dconc_mat = ccn_dconc_matrix
//	SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat	
//	SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat	
//	dconc_mat = NaN

	//variable meanDp = 0.060
	// create merged waves on standard diameter step
	variable dp_cols = 10000
	variable start_dp = .001
	variable stop_dp = 1
	make/o/D/n=(dp_cols) model_dp_w
	wave model_dp = model_dp_w
	variable model_range = 1.5 * 4 // = 4 sigma of lognormal generation
//	model_dp[0] = start_dp
//	model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1))

	
	variable i,j,k
//	for (i=0; i<numpnts(SS); i+=1) // 0.2% only for now

		make/o/D/n=(Dim_conc,Dim_conc) $("ccn_conc_matrix_dgn_v_dcrit")
		wave conc_mat = $("ccn_conc_matrix_dgn_v_dcrit")
		SetScale/P x first_dp*1000,(  (last_dp*1000-first_dp*1000)/(numpnts(conc_dp)-1) ),"nm" conc_mat	
		SetScale/P y first_dcrit*1000,(  (last_dcrit*1000-first_dcrit*1000)/(numpnts(conc_dcrit)-1) ),"nm" conc_mat	
		conc_mat = NaN
	
//		variable dDim_conc = (Dim_conc-1)/2
//		make/o/D/n=(dDim_conc,dDim_conc) $("ccn_dconc_matrix_pom_"+num2str(SS[i]))
//		wave dconc_mat_pom = $("ccn_dconc_matrix_pom_"+num2str(SS[i]))
//		SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_pom	
//		SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_pom	
//		dconc_mat_pom = NaN
//	
//		make/o/D/n=(dDim_conc,dDim_conc) $("ccn_dconc_matrix_dp_"+num2str(SS[i]))
//		wave dconc_mat_dp = $("ccn_dconc_matrix_dp_"+num2str(SS[i]))
//		SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat_dp	
//		SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat_dp	
//		dconc_mat_dp = NaN
//	
//		make/o/D/n=(dDim_conc,dDim_conc) $("ccn_dconc_matrix_"+num2str(SS[i]))
//		wave dconc_mat = $("ccn_dconc_matrix_"+num2str(SS[i]))
//		SetScale/P x conc_dp[1],(  2*(last_dp-first_dp)/(numpnts(conc_dp)-1) ),"um" dconc_mat	
//		SetScale/P y conc_pom[1],(  2*(last_pom-first_pom)/(numpnts(conc_pom)-1) ),"POM_mf" dconc_mat	
//		dconc_mat = NaN




		for (j=0; j<numpnts(conc_dp); j+=1)

			// model size dist is +/- 4 sigma (=6)
			start_dp = conc_dp[j]/model_range
			stop_dp = conc_dp[j]*model_range
			model_dp[0] = start_dp
			model_dp[1,] = model_dp[p-1]*10^(log(stop_dp/start_dp)/(dp_cols-1)) 

			ccn_generate_size_dist(conc_dp[j], model_dp, "dNdlogDp_for_meanDp")
			wave dndlogDp = $("dNdlogDp_for_meanDp")
			
			for (k=0; k<numpnts(conc_dcrit); k+=1)
			
				// find critDp using Kohler eqn
//				variable critDp = ccn_find_critical_diam(SS[i], MW_nh4_2_so4, DENSITY_nh4_2_so4,3, conc_pom[k])
				variable critDp = conc_dcrit[k]
				// get conc based on critDp and dndlogDp
				conc_mat[j][k] = ccn_get_ccn_conc(critDp, model_dp, dndlogDp)
				
			endfor						
		
		endfor

//		variable incj, inck
//		incj=0
//		for (j=1; j<numpnts(conc_dp)-1; j+=2)
//				
//			inck=0
//			for (k=1; k<numpnts(conc_pom)-1; k+=2)
//			
//				// get dconc of pom and dp 
//				//dconc_mat_dp[incj][inck] = conc_mat[j+1][k] - conc_mat[j-1][k]
//				dconc_mat_pom[incj][inck] = conc_mat[j][k-1] - conc_mat[j][k+1]
////				dconc_mat[incj][inck] = dconc_mat_pom[incj][inck] / dconc_mat_dp[incj][inck]
//				inck += 1
//			endfor
//						
//			incj += 1
//		endfor
//
//				
//		inck=0
//		for (k=1; k<numpnts(conc_pom)-1; k+=2)
//			
//			incj=0
//			for (j=1; j<numpnts(conc_dp)-1; j+=2)
//
//				// get dconc of pom and dp 
//				dconc_mat_dp[incj][inck] = conc_mat[j+1][k] - conc_mat[j-1][k]
////				dconc_mat_pom[incj][inck] = conc_mat[j][k-1] - conc_mat[j][k+1]
//				//dconc_mat[incj][inck] = dconc_mat_pom[incj][inck] / dconc_mat_dp[incj][inck]
//			incj += 1
//			endfor
//						
//			inck += 1
//		endfor
//
//		dconc_mat = dconc_mat_pom / dconc_mat_dp

//	endfor


	setdatafolder sdf

End


Function ccn_find_error_matrix()

	wave SS = SS_range
	wave conc_dp = ccn_conc_dp	
	variable first_dp = conc_dp[0]*1000
	variable last_dp = conc_dp[ numpnts(conc_dp)-1 ]*1000
	
	variable i,j,k
	for (i=0; i<numpnts(SS); i+=1) // 0.2% only for now

		wave conc_mat = $("ccn_conc_matrix_"+num2str(SS[i]))
		
		make/D/o/n=(dimsize(conc_mat,0)) $("ccn_dconc_dgn_only_"+num2str(SS[i]))
		wave dgn_only = $("ccn_dconc_dgn_only_"+num2str(SS[i]))
		dgn_only = conc_mat[p][0]
		
		duplicate/o conc_mat $("ccn_conc_error_matrix_"+num2str(SS[i]))
		wave conc_error_mat = $("ccn_conc_error_matrix_"+num2str(SS[i]))
		SetScale/P x first_dp,(  (last_dp - first_dp )/(numpnts(conc_dp)-1) ),"nm" conc_error_mat	
		
		
		conc_error_mat = (dgn_only[p] - conc_mat[p][q]) * 100 / dgn_only[p]
		
//		for (j=0; j<dimsize(conc_mat,1); j+=1)
//			for (k=0; k<dimsize(conc_mat,0); k+=1)
//				conc_error_mat[k][j] = conc_mat[k][j] / dgn_only[k]
//			endfor
//		endfor
		
	endfor
	
End

Function ccn_find_error_matrix_from_mean()

	string sdf = getdatafolder(1)
	setdatafolder root:
	newdatafolder/O/S error_from_mean

	wave SS = ::SS_range
	wave conc_dp = ::ccn_conc_dp	
	variable first_dp = conc_dp[0]*1000
	variable last_dp = conc_dp[ numpnts(conc_dp)-1 ]*1000
	
	variable i,j,k
	for (i=0; i<numpnts(SS); i+=1) // 0.2% only for now

		wave conc_mat = ::$("ccn_conc_matrix_"+num2str(SS[i]))
		
		make/D/o/n=(dimsize(conc_mat,0)) $("ccn_dconc_dgn_only_"+num2str(SS[i]))
		wave dgn_only = $("ccn_dconc_dgn_only_"+num2str(SS[i]))
		dgn_only = conc_mat[p][80]
		
		duplicate/o conc_mat $("ccn_conc_error_matrix_"+num2str(SS[i]))
		wave conc_error_mat = $("ccn_conc_error_matrix_"+num2str(SS[i]))
		SetScale/P x first_dp,(  (last_dp - first_dp )/(numpnts(conc_dp)-1) ),"nm" conc_error_mat	
		
		
		conc_error_mat = (dgn_only[p] - conc_mat[p][q]) * 100 / dgn_only[p]
		
//		for (j=0; j<dimsize(conc_mat,1); j+=1)
//			for (k=0; k<dimsize(conc_mat,0); k+=1)
//				conc_error_mat[k][j] = conc_mat[k][j] / dgn_only[k]
//			endfor
//		endfor
		
	endfor
	
End

Function ccn_find_mf_from_B_Hudson()

	make/o/n=10 Hudson_B
	wave B = Hudson_B
	B = {0.19, 0.58, 0.38, 0.16, 0.37, 0.42, 0.53, 0.40, 0.12, 0.36}

	make/o/n=(numpnts(B)) Hudson_POM_mf
	wave mf = Hudson_POM_mf
	
	variable ions = 3
	
	variable i
	for (i=0; i<numpnts(B); i+=1)
		mf[i] = ccn_find_POM_mf(0.4,MW_nh4_2_so4,DENSITY_nh4_2_so4,ions,B[i])
	endfor
End

Function ccn_find_variability()

	wave SS = SS_range

	wave pom_mf = ccn_conc_pom_mf
	wave dgn = ccn_conc_dp	
	
	make/O/n=(2,2) PMEL_corners
	wave pmel = PMEL_corners
	pmel = { {0.042,0.1}, {0.2,0.6} }

	make/O/n=(2,2) Dusek_corners
	wave dusek = Dusek_corners
	dusek = { {0.066,0.083}, {0.6,0.8} }

	make/O/n=(2,2) Hudson_corners
	wave hudson = Hudson_corners
	hudson = { {0.06,0.06}, {0.3,0.72} }
	

	variable i,j,k
	for (i=0; i<numpnts(SS); i+=1) // 0.2% only for now

		print SS[i]
		wave conc_error_mat = $("ccn_conc_error_matrix_"+num2str(SS[i]))

		make/O/n=(2,2) $("PMEL_variability_"+num2str(SS[i]))
		wave pmel_var = $("PMEL_variability_"+num2str(SS[i]))
		
		make/O/n=(2,2) $("Dusek_variability_"+num2str(SS[i]))
		wave dusek_var = $("Dusek_variability_"+num2str(SS[i]))
	
		make/O/n=(2,2) $("Hudson_variability_"+num2str(SS[i]))
		wave hudson_var = $("Hudson_variability_"+num2str(SS[i]))
		hudson_var = NaN

		variable i1,j1, i2, j2
		i1 = round( BinarySearchInterp(dgn,pmel[0][0]) )
		i2 = round( BinarySearchInterp(dgn,pmel[1][0]) )
		
		j1 = round( BinarySearchInterp(pom_mf,pmel[0][1]) )
		j2 = round( BinarySearchInterp(pom_mf,pmel[1][1]) )
		
		pmel_var[0][0] = conc_error_mat[i1][j1]
		pmel_var[1][0] = conc_error_mat[i1][j2]
		pmel_var[0][1] = conc_error_mat[i2][j1]
		pmel_var[1][1] = conc_error_mat[i2][j2]
		

		i1 = round( BinarySearchInterp(dgn,dusek[0][0]) )
		i2 = round( BinarySearchInterp(dgn,dusek[1][0]) )
		
		j1 = round( BinarySearchInterp(pom_mf,dusek[0][1]) )
		j2 = round( BinarySearchInterp(pom_mf,dusek[1][1]) )
		
		dusek_var[0][0] = conc_error_mat[i1][j1]
		dusek_var[1][0] = conc_error_mat[i1][j2]
		dusek_var[0][1] = conc_error_mat[i2][j1]
		dusek_var[1][1] = conc_error_mat[i2][j2]
		

		i1 = round( BinarySearchInterp(dgn,hudson[0][0]) )
		i2 = round( BinarySearchInterp(dgn,hudson[1][0]) )
		
		j1 = round( BinarySearchInterp(pom_mf,hudson[0][1]) )
		j2 = round( BinarySearchInterp(pom_mf,hudson[1][1]) )
		
		hudson_var[0][0] = conc_error_mat[i1][j1]
		hudson_var[1][0] = conc_error_mat[i1][j2]
		
	endfor
	
End

Function ccn_avg_pom_mf_regions(dgm_fit)
	string dgm_fit // "old" = orig fit; "big" = fit of larger modes; "little" fit of smaller modes
	
	variable dp_low = 20
	variable dp_high = 140
//	variable dp_high = 260
	
	string sdf = getdatafolder(1)
	setdatafolder root:fromTrish
	
	string prefix = ""
	string meanDp_name = "MeanDp"
	if (cmpstr(dgm_fit,"big") == 0)
		setdatafolder big_dgm
		prefix = "::"
		meanDp_name = "MeanDp_Big"
	elseif (cmpstr(dgm_fit,"little") == 0)
		setdatafolder little_dgm
		prefix = "::"
		meanDp_name = "MeanDp_Little"
	endif
	
	string region_list = "BC;Free;GB;GulfMar;HSC;Jac;Gulf_SFlow;Land_SFlow;Land_NFlow;Marine;Marine_44"
	
	wave dgm = $MeanDp_name

	make/o/n=( (dp_high-dp_low)/5 + 1) Dgm_bin
	wave bins = Dgm_bin
	
	variable j,k,inc
	inc=0
	for (j=dp_low; j<=dp_high; j+=5)
		bins[inc] = j
		inc+=1
	endfor

	variable i
	for (i=0; i<itemsinlist(region_list); i+=1)
	
		wave pom = $(prefix + "TOF_HOA_mf_"+stringfromlist(i,region_list))
		
		duplicate/o bins  $("TOF_HOA_mf_"+stringfromlist(i,region_list)+"_avg")
		wave avg = $("TOF_HOA_mf_"+stringfromlist(i,region_list)+"_avg")
		avg = NaN
		setscale/P x, 20, 5, "nm", avg

		duplicate/o bins  $("TOF_HOA_mf_"+stringfromlist(i,region_list)+"_count")
		wave cnt = $("TOF_HOA_mf_"+stringfromlist(i,region_list)+"_count")
		cnt = NaN
		setscale/P x, 20, 5, "nm", cnt
		
		for (j=0; j<numpnts(bins); j+=1)
			duplicate/o pom tmp_copy
			wave copy = tmp_copy
			copy = ( (dgm[p] >= (bins[j]-2.5)) && (dgm[p] < (bins[j]+2.5)) ) ? copy[p] : NaN
			wavestats/Q copy
			avg[j] = V_avg			
			cnt[j] = V_npnts	
		endfor
		
		
		// Manually remove from avg and cnt waves after this is run:
		//	GulfMar: 13085
		// 	Marine: 145, 186
			
	endfor
	
	//bins /= 1000
	setdatafolder sdf

End

Function ccn_ts_pom_mf_regions(dgm_fit,region,bin_dp)
	string dgm_fit // "old" = orig fit; "big" = fit of larger modes; "little" fit of smaller modes
	string region
	variable bin_dp
	
	variable dp_low = 20
	variable dp_high = 140
//	variable dp_high = 260
	
	string sdf = getdatafolder(1)
	setdatafolder root:fromTrish
	
	string prefix = ""
	string meanDp_name = "MeanDp"
	if (cmpstr(dgm_fit,"big") == 0)
		setdatafolder big_dgm
		prefix = "::"
		meanDp_name = "MeanDp_Big"
	elseif (cmpstr(dgm_fit,"little") == 0)
		setdatafolder little_dgm
		prefix = "::"
		meanDp_name = "MeanDp_Little"
	endif
	
	string region_list = "BC;Free;GB;GulfMar;HSC;Jac;Gulf_SFlow;Land_SFlow;Land_NFlow;Marine;Marine_44"
	
	wave dgm = $MeanDp_name

	//make/o/n=( (dp_high-dp_low)/5 + 1) Dgm_bin
	wave dt = ::ams_t_start
	wave bins = Dgm_bin
	
	
	
//	variable j,k,inc
//	inc=0
//	for (j=dp_low; j<=dp_high; j+=5)
//		bins[inc] = j
//		inc+=1
//	endfor

	variable i
//	for (i=0; i<itemsinlist(region_list); i+=1)
	
		wave pom = $(prefix + "TOF_HOA_mf_"+region)
		duplicate/o pom 	$(prefix + "TOF_HOA_mf_"+region+"_at_"+num2str(bin_dp))
		wave pom_at_dp = $(prefix + "TOF_HOA_mf_"+region+"_at_"+num2str(bin_dp))
		pom_at_dp = NaN
		
		pom_at_dp = ( (dgm[p] >= bin_dp-2.5) && (dgm[p] < bin_dp+2.5) ) ? pom[p] : NaN
				
			
//	endfor
	
	//bins /= 1000
	setdatafolder sdf

End

// Calculate SScrit values from Dcrit values. The output wave ($sscrit_wname)
// 	will be in the current working folder
Function ccn_calc_Scrit_from_Dcrit(dcrit, kappa, sscrit_wname,[type_w, type])
	wave dcrit
	variable kappa
	string sscrit_wname
	wave/T type_w // sample_types wave
	string type   // desired sample type

	variable useFilter = 1	
	if ( ParamIsDefault(type_w) || ParamIsDefault(type_w) )
		useFilter = 0
	endif

//	dfref dfr = GetDataFolderDFR()
//	newdatafolder/o/s root:ccn
//	newdatafolder/o/s model
//	newdatafolder/o/s kappa
		
	variable R = 8.314 
	variable T = 293 // K
	variable sigma = 0.073 // J/m2
	
	//variable A = (4*MW_h2o*sigma) / (R*T*DENSITY_h2o)  * 1e-4
	variable A = (4*MW_h2o*sigma) / (3*R*T*DENSITY_h2o)
	//print A
	
	duplicate/o dcrit, $sscrit_wname
	wave sscrit = $sscrit_wname
	
	sscrit = sqrt( (4.0/kappa) * ( 1 / (dcrit[p]/1000)^3)  * A^3 ) *100
	
	if (useFilter && (numpnts(sscrit)==numpnts(type_w)))
		sscrit = (cmpstr(type_w[p],type)==0) ? sscrit[p] : NaN
	endif

	//setdatafolder dfr	

End

// This is a kludge for the moment:
//	- creates waves at nominal SS values
Function ccn_create_s_s0_waves()

	// operates in currect folder...up to user to set
	wave sscrit_as = sscrit_calc_ammsulf
	duplicate/o sscrit_as s_s0_as_0_1
	wave s_s0_0_1 = s_s0_as_0_1
	duplicate/o sscrit_as s_s0_as_0_3
	wave s_s0_0_3 = s_s0_as_0_3
	duplicate/o sscrit_as s_s0_as_0_5
	wave s_s0_0_5 = s_s0_as_0_5
	
	s_s0_0_1 = NaN
	s_s0_0_3 = NaN
	s_s0_0_5 = NaN
	
	// these indices are for avg_300 values
	s_s0_0_3[3,34] = sscrit_as[p]
	s_s0_0_1[251,291] = sscrit_as[p]
	s_s0_0_5[294,322] = sscrit_as[p]
	
	s_s0_0_1 /= 0.132
	s_s0_0_3 /= 0.33
	s_s0_0_5 /= 0.45
	
End

Function ccn_ttdma_load_valve()

	DFREF sdf = getdatafolderdfr()

	newdatafolder/o/s root:valve
	acg_load_dchart_itx_format(1)
	
	// do something with the data
	
	//ttdma_filter_with_valve("smps",120,0)

	ccn_create_valve_flag()
	setdatafolder sdf
	
	//ttdma_update() //comment out if it is easier to do this manually
	
End

Function ccn_create_valve_flag()

	variable nan_secs_after_switch = 20 // seconds

	wave valve_dt = $"date_time"
	wave valve = $"zi_tthdma_valve"
	
	// create valve wave to remove transition points
	duplicate/o valve , $"valve_flag"
	wave vlv_flag = $"valve_flag"
	
//	vlv_flag = (valve[p] < 1.0 || valve[p] > 3.8) ? 1 : 0
	vlv_flag = 1
	variable i
	for (i=0; i<numpnts(valve); i+=1)
		if ( valve[i] < 1.0 || valve[i] > 3.8) 
			if (vlv_flag[i]) 
				vlv_flag[i] = 1
			endif
		else
			vlv_flag[i,i+nan_secs_after_switch] = 0
		endif
	endfor

//	variable i
//	variable index = 0
//	for (i=0; i<numpnts(valve); i+=1)
//		if (vlv_flag)
//			index = i
//			break
//		endif
//	endfor
//	
//	variable last = valve[index]
//	index+=1
//	for (i=index; i<numpnts(valve); i+=1)
//		
//	endfor
	
	

End

Function ccn_filter_on_types([sample_type_list, export_fld])
	string sample_type_list
	string export_fld
	
	variable use_st_list=0
	if (!ParamIsDefault(sample_type_list))
		use_st_list=1
	endif
	
	if (ParamIsDefault(export_fld))
		export_fld="UNKNOWN"
	endif
	
	string sdf = ccn_goto_ccn_folder()
	
	wave/T types = ccn_sample_type
	
	string typelist = ccn_samp_type_list
	string mart_list = ""
	string ss_list = ""
	
	variable i
	for (i=0; i<itemsinlist(typelist); i+=1)
		string typ = stringfromlist(i,typelist)
		if (stringmatch(typ,"MART_*") > 0 || stringmatch(typ,"Mart_*") > 0)
			mart_list=addlistitem(typ,mart_list,";",Inf)
		elseif (stringmatch(typ,"SS_*") > 0)
			ss_list=addlistitem(typ,ss_list,";",Inf)
		endif		
	endfor
	
	string var_list = "CCN_Concentration_Cleaned;mono_cn_conc_shifted;CCN_CN_ratio_Cleaned;SS_setting;zi_smps_dp_ccn_mono"

	
	variable vari
	for (vari=0; vari<itemsinlist(var_list); vari+=1)
		string var = stringfromlist(vari,var_list)
		wave src = $var

		
		if (use_st_list)

			newdatafolder/o/s $"exports"
			newdatafolder/o/s $export_fld
			duplicate/o src $var
			wave w = $var
			ccn_goto_ccn_folder()

			for (i=0; i<numpnts(types); i+=1)
				if (whichlistitem(types[i],sample_type_list)<0)
					w[i] = NaN
				endif
			endfor
		
		else
		
			newdatafolder/o/s $"exports"
			newdatafolder/o/s $"MART"
			duplicate/o src $var
			wave w = $var
			ccn_goto_ccn_folder()

			for (i=0; i<numpnts(types); i+=1)
				if (whichlistitem(types[i],mart_list)<0)
					w[i] = NaN
				endif
			endfor
	
			newdatafolder/o/s $"exports"
			newdatafolder/o/s $"SeaSweep"
			duplicate/o src $var
			wave w = $var
			ccn_goto_ccn_folder()
			
			for (i=0; i<numpnts(types); i+=1)
				if (whichlistitem(types[i],ss_list)<0)
					w[i] = NaN
				endif
			endfor
			
			endif
		
	endfor
		
			

End

// ** ccn_export_waves_using_filter **
// Description: generate time series of cn, ccn and ratio for given sample types and flags
//
// Input: 
//	data_type: "spectra" or "mono"
//	sample_type_list: string list of sample types (if excluded, the flags will be searched over all types)
//	flag_list: string list of flags (if excluded, no flags will be included)
//
// Output:
//	Function will create new datafolders in the ccn folder. The structure will look like
//		<sample_type>
//			- ccn, cn, ratio, dt, ss, [dp]
///
//	The function will step through sample_types and then flags. In each folder, the time series will contain data if
//	the sample type or sample type&flag (not all flags) are present. Bad data will not be included.
//
Function ccn_export_waves_using_filter(data_type,[sample_type_list, combine_types])
	string data_type
	string sample_type_list
	string combine_types
	
	if (cmpstr(data_type,"spectra")!=0 && cmpstr(data_type,"mono")!=0)
		print "Bad data_type. Allowed types: spectra or mono"
		return 0
	endif
		
	variable all_sample_types = 0
	if (ParamIsDefault(sample_type_list) || cmpstr(sample_type_list,"")==0)
		sample_type_list = "ALL_TYPES"
		all_sample_types = 1
	endif
	
	variable do_combine=1
	if (!ParamIsDefault(combine_types))
		if (cmpstr(combine_types,"false")==0)
			do_combine=0
		endif
	endif

////	variable require_flags=0
//	if (ParamIsDefault(flag_list))
//		flag_list = ""
//	endif
//
//	// get wave nan db
//	wave/T db = ccn_get_nan_db() 
//	
////	dfref dfr = GetDataFolderDFR()
////	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	

	wave dt = ccn_datetime
	wave all_ccn = CCN_Concentration_Cleaned
	wave/T types = ccn_sample_type
//	wave/T flags = ccn_flag_dev
	wave all_cn = mono_cn_conc_shifted

	wave dp = zi_smps_dp_ccn_mono
	wave ss = SS_setting

	// create folders
	newdatafolder/o/s exports
	
	duplicate/O all_cn calc_ccn_cn_ratio
	wave all_ratio = calc_ccn_cn_ratio
	all_ratio = all_ccn/all_cn
	
	newdatafolder/o/s $data_type

	variable typei
	for (typei=0; typei<itemsinlist(sample_type_list); typei+=1)
		string type = stringfromlist(typei,sample_type_list)
		newdatafolder/o/s $type
		
		duplicate/o dt, $("ccn_datetime")
		duplicate/o ss, $("ss")
		if (cmpstr(data_type,"mono")==0)
			duplicate/o dp $("dp")
		endif
		
		if (!all_sample_types)
			duplicate/o all_ccn, $("cn"), $("ccn"), $("ratio")
			wave cn = $"cn"
			wave ccn = $"ccn"
			wave ratio = $"ratio"
			cn = NaN
			ccn = NaN
			ratio = NaN
			
			variable row
			for (row=0; row<numpnts(all_cn); row+=1)
				if (cmpstr(types[row],type) == 0)
					cn[row] = all_cn[row]
					ccn[row] = all_ccn[row]
					ratio[row] = all_ratio[row]
				endif
			endfor
		endif
				
		variable flagi 
//		for (flagi=0; flagi<itemsinlist(flag_list); flagi+=1)
//			string flag = stringfromlist(flagi,flag_list)
//			newdatafolder/o/s $flag
//			
//			duplicate/o all_ccn, $("cn"), $("ccn"), $("ratio")
//			wave cn = $"cn"
//			wave ccn = $"ccn"
//			wave ratio = $"ratio"
//			cn = NaN
//			ccn = NaN
//			ratio = NaN
//
//			for (row=0; row<numpnts(all_cn); row+=1)
//				if (ccn_flag_is_set(flag, row))
////				if (whichlistitem(flag,flags[row]) >= 0)
//					if (all_sample_types || cmpstr(types[row],type) == 0) 
//						cn[row] = all_cn[row]
//						ccn[row] = all_ccn[row]
//						ratio[row] = all_ratio[row]
//					endif
//				endif
//			endfor
//	
//			setdatafolder ::
//		endfor
		
		setdatafolder ::
	endfor
	killwaves/Z all_ratio
			
//			if (whichlistitem(flag,flags[row]) >= 0)
//	
//	
//	// major change: 04 March 2018 - redo entire logic to geneate waves for flexibility
//	
//	variable row
//	for (row=0; row<numpnts(ccn_clean); row+=1)
//		
//		string stype = types[row]
//		if (whichlistitem(stype,sample_type_list) < 0 ) // not a valid type
//			continue
//		endif
//		
//		string sflag = flags[row]
//		if (require_flags) // if user requires a specific set of flags then only process if all present
//			variable has_all_flags = 0
//			if (cmpstr(required_flag_list,"")==0 && itemsinlist(sflag)==0)
//				has_all_flags = 1
//			else
//				variable flg_cnt = 0
//				variable flgi
//				for (flgi=0; flgi<itemsinlist(required_flag_list); flgi+=1)
//					if (whichlistitem(stringfromlist(flgi,required_flag_list),sflag) > -1)
//						flg_cnt +=1
//					endif
//				endfor
//				if (flg_cnt == itemsinlist(required_flag_list))
//					has_all_flags = 1
//				endif
//			endif
//			if (!has_all_flags)
//				continue
//			endif
//		endif				
//		
//		// if we've made it this far, process point
//		if (ccn_valid_ss(ss[row])) // temp check for valid ss...need to fix original
//			ccn_add_to_working_ss_wave("spectra",dt[row],ss=ss[row],sample_type=stype,flag_list=sflag)
//		endif
//	endfor
//	
//	// process working waves into ss_waves
//	variable cols = 10 // number of columns in data wave
//	
//	setdatafolder :data:working
//	wlist = acg_get_wave_list(filter="ss_*")
//	setdatafolder :: // df = <>:data
//	
//	variable wi
//	for (wi=0; wi<itemsinlist(wlist); wi+=1)
//		string wn = stringfromlist(wi,wlist)
//		
//		wave work = $(":working:"+wn)
//		if (numpnts(work) == 0) // skip if wave has no data
//			continue
//		endif
//		
//		if (!waveexists($(wn+"_dt")))
//			make/o/n=0 $(wn+"_dt")
//		endif
//		wave data_dt= $(wn+"_dt")
//
//		if (!waveexists($wn))
//			make/o/n=(0,cols) $wn
//		endif
//		wave data = $wn
//		
//		variable deltaT = 300 // valve timing
//		ccn_process_working_wave(work,data_dt,data,dt,ccn_clean,mono_cn,ratio,deltaT)
//		
//		// set wavenote with metadata from working wave
//		string meta = note(work)
//		note/k data
//		note data, meta
//		
//		ccn_set_wave_nans(db,data)
//		
//	endfor
	

// start comment of old code
//	
//	//variable curr_dp = 0
//	//variable curr_dp_cnt = 0
//	//variable dp_cnt_thrshld = 3 // have to wait 30 seconds to let smps data "catch up"
//	variable curr_ss = 0
//	
//	// create intermediate waves of ss by type
//		
//	//variable dp_index, ss_index
//	variable ss_index
//	variable i,j,r
//	make/o/d/n=0 tmp_datetime,tmp_ccn_conc, tmp_cn_conc, tmp_ccn_cn_ratio
//	wave tmp_dt = tmp_datetime
//	wave tmp_ccn = tmp_ccn_conc
//	wave tmp_cn = tmp_cn_conc
//	wave tmp_ratio = tmp_ccn_cn_ratio
//
//	// process each ss period for each sample type
//	variable typ
//	string samp_types=ccn_get_samp_type_list()	
//	string curr_type = ""
//	variable has_data = 0
//	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
//		string sample_type = stringfromlist(typ,samp_types)
//		for (i=0;i<numpnts(ratio); i+=1)			
////					if (ss[i] > 1.6)
////						variable/D test = 1.7
////						print "here " + num2str(ss[i])+num2str(ss[i])
////						print ss[i], str2num(num2str(ss[i]))
////						print (ss[i]==test)
////						print (str2num(num2str(ss[i]))==1.7)
////					endif
//			
////			if (ss[i] == 0.2 && cmpstr(sample_type,types[i])==0 && cmpstr(sample_type,"NaCl_U")==0)
//			if (i==127577)
//				print ss[i], types[i], sample_type, typ
//			endif
//
//
//			//if (ccn_valid_dp_ss_pair(dp[i], ss[i])) // if bad dp or ss skip altogether
//			if (ccn_valid_ss(ss[i])) // if bad ss skip altogether
//					
//				if (curr_ss == 0)
//					curr_ss = ss[i]
//				endif
//				if (cmpstr(curr_type,"")==0)
//					curr_type = types[i]
//				endif
//	
//				if (curr_ss != ss[i] || cmpstr(curr_type,types[i])!=0) // restart ss
//					
//					// add current data to proper wave in :data
//					if (i>0)
//						ccn_spectra_append_ss_wave(curr_ss,tmp_dt, tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
//						redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//						has_data=0
//					endif
//					
//					curr_type = types[i]
//					curr_ss = ss[i]
//					if (cmpstr(sample_type,curr_type)==0)
//						r =0
//						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//						tmp_dt[r] = dt[i]
//						tmp_ccn[r] = ccn_clean[i]
//						tmp_cn[r] = mono_cn[i]
//						tmp_ratio[r] = ratio[i]
//					endif
//				else 
//					curr_type = types[i]
//					if (cmpstr(sample_type,curr_type)==0)
//						r = numpnts(tmp_dt)
//						redimension/n=(r+1) tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//						tmp_dt[r] = dt[i]
//						tmp_ccn[r] = ccn_clean[i]
//						tmp_cn[r] = mono_cn[i]
//						tmp_ratio[r] = ratio[i]
//						has_data = 1
//					endif
//				endif				
//			else
//				if (has_data)
//					ccn_spectra_append_ss_wave(curr_ss,tmp_dt[row], tmp_ccn,tmp_cn,tmp_ratio,type=curr_type)
//					redimension/n=0 tmp_dt, tmp_ccn, tmp_cn, tmp_ratio
//					has_data = 0
//				endif
//			endif
//		endfor
//	endfor
//
// end comment of old code
	
	// create dp vs. SS matrix

//	killwaves/Z ratio
	setdatafolder sdf
	//SetDataFolder dfr
End

