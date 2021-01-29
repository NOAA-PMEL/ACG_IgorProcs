#pragma rtGlobals=1		// Use modern global access method.

constant particle_sizing_version = 2.10

// ---- Changes ----
// from 2.9 to 2.10 -- 23 July 2010
//  - added: code to fix scaling for bad initial datetime
// from 2.8 to 2.9 -- 25 May 2010
//  - fixed "bugs" in load functions. I think they came from upgrade.
/// from 2.7 to 2.8 -- 2 June 2009
//  - fixed bug in integration (only 1d funcs, 2d were fine)
// from 2.6 to 2.7 -- 14 May 2009
//  - ??? - probably lots of stuff I've forgotten
//  - added sizing_reprocess_inst_data function
//     - will process unfiltered data and filtered data if cn filtering data exists
//  - cleaned up some typos
//  - added functionality to save nsd data based on ProjectInfo
// from 2.5 to 2.6 -- 17 Feb 2009
//  - ???
// from 2.4 to 2.5 -- ?? Oct 2008
//  - ???
// from 2.3 to 2.4 -- 12 Sept 2007
//  - added shape factor and ultra-stokesian corrections to APS
// from 2.2 to 2.3 -- 27 April 2007
//  - added function to calculate and save parameters from a lognormal fit using the avg size dist edit window
// from 2.1 to 2.2 -- 27 March 2007
//  - added function to write dWdlogDp waves to ascii file for dataserver
//  - fixed plot_average_dist_from_marquee to handle 2d
// from 2.0 to 2.1 -- 14 March 2007
//  - added functions to handle calculated density waves
// 	- these waves and functions are designated with a _2d suffix
//  - added function to shift from sample RH to ambient RH using calculated growth factors and ambient density
//  - added function to shift DMPS from DMPS RH to imp sample RH using calculated growth factors 
// from 1.9 to 2.0 -- 6 December 2006
//  - Added functions to calculate intN > Dp where Dp is based on SS of ammonium sulfate
//  - Added functions to mask the intN > Dp waves with regional, SS, and ship masking waves (from Trish)
//  - Added functions to calculate avg (and stdev) size distribution based on same masking criteria as above.
// from 1.8 to 1.9 -- 3 November 2006
//  - Added functions to "fix" nan sync using 2-d user_nan waves
// from 1.7 to 1.8 -- 14 September 2006
//  - Added functions to merge dmps and aps data 
// from 1.6 to 1.7 -- 01 September 2006
//  - Bug fix: fixed problem where user_nan info was lost when adding new datasets
// from 1.5 to 1.6 -- 29 August 2006
//  - Added window to "step though" the individual distributions of an average plot
// from 1.4 to 1.5 -- 26 August 2006
//  - Changed the user_nan wave from 1D to 2D
//  - Added functions to remove selected points from the distribution
//
// from 1.3 to 1.4 -- 26 August 2006
//  - added function to integrate portions of a given moment from a given instrument
//		this is command line only at the moment
//  - reconciled all changes from Tim and Trish
//
// from 1.2 to 1.3
//  - added dmps/aps functions
//		you can load, nan/reset, change density and plot avgs
//		TODO: combine dmps and aps matrices to form complete size dist
//
// from 1.1 to 1.2
//  - added marquees to nan/reset user selected regions
//		** if upgrading to this version without loading a new dataset:
//			1. Switch to data folder (e.g., data_300sec)
//			2. Create new waves:
//				duplicate/o smps_dNdlogDp smps_dNdlogDp_raw
//				duplicate/o smps_datetime smps_datetime_bak
//				make/o/n=(dimsize(smps_dNdlogDp,0)) smps_user_nan
//				smps_user_nan=0
//				duplicate/o smps_user_nan smps_user_nan_bak


strconstant sizing_tmp_data_folder = "root:sizing_tmp_data_folder"
strconstant smps_datasets_folder = "root:smps:datasets"
strconstant smps_parameter_folder="root:smps:parameters"
strconstant dmps_datasets_folder = "root:dmps:datasets"
strconstant dmps_parameter_folder="root:dmps:parameters"
strconstant aps_datasets_folder = "root:aps:datasets"
strconstant aps_parameter_folder="root:aps:parameters"
strconstant dmps_aps_parameter_folder = "root:dmps_aps:parameter"

constant general_defaultTimeBase = 300 // seconds -- for process_2d, dmps_aps, etc
constant smps_defaultTimeBase = 300 // seconds
constant dmps_defaultTimeBase = 300 // seconds
constant aps_defaultTimeBase = 300 // seconds

constant smps_nominalDensity = 1.5
constant dmps_nominalDensity = 1.5
constant aps_nominalDensity = 1.5

strconstant ammsulf_sat_levels = "as_0_22_SS;as_0_44_SS;as_0_65_SS;as_0_84_SfS;as_1_00_SS"
strconstant ammsulf_sat_Dp = "0.075;0.047;0.036;0.0305;0.027"

// integration variable
constant integration_tb_for_menu = 300

// --- gui variables ---
strconstant sizing_gui_folder = "root:gui"
strconstant sizing_gui_ADE_folder = "ADE"
strconstant sizing_gui_ADE_fp_folder = "fit_params"

strconstant sizing_instTypes = "SMPS;DMPS;APS"
strconstant sizing_distTypes = "dN/dlogDp;dS/dlogDp;dV/dlogDp;dM/dlogDp"
strconstant sizing_diamTypes = "Geometric;Aerodynamic;Vacuum Aerodynamic"

//string sizing_mask_folder = "Masks_5m"
strconstant sizing_mask_folder = "Masks_1m" // switched to 1m mask data
strconstant sizing_HSC_mask_list = "HSC:HSC_mask;HSC_low_mask;HSC_N_mask;HSC_S_mask"
strconstant sizing_TB_mask_list = "TB:TB_mask_1"
strconstant sizing_Jacinto_mask_list = "Jacinto:Jacinto_mask"
strconstant sizing_BC_mask_list = "BC:BC_low_mask;BC_N_mask;BC_S_mask"
strconstant sizing_Free_mask_list = "Free:Free_mask"
strconstant sizing_Mat_mask_list = "Mat:Mat_mask"
strconstant sizing_GB_mask_list = "GB:GB_low_mask;GB_mask;GB_N_mask;GB_S_mask"
strconstant sizing_PA_mask_list = "PA:PA_mask;PA_mask_1;PA_mask_2"
strconstant sizing_SE_US_mask_list = "SE_US:SE_US_mask"
strconstant sizing_Dust_mask_list = "Dust:Dust_mask"
strconstant sizing_Gulf_mask_list = "Gulf:Gulf_mar_mask;Gulf_N_flow_mask;Gulf_N_mask;Gulf_N_recirc_mask;Gulf_S_mask;Gulf_S_recirc_mask;Gulf_var_recirc_mask"

//string sizing_RHB_mask = "RHB_mask_5m"
strconstant sizing_RHB_mask = "RHB_mask_1m"


strconstant sizing_ss_levels = "0_22;0_44;0_65;0_84;1_00"
strconstant sizing_ss_levels_real = "0.22;0.44;0.65;0.84;1.00"

// filtering constants
strconstant sizing_cn_filter_folder = "root:cn_10sec"
constant sizing_cn_filter_tb = 10 //seconds
strconstant sizing_cn_filter_name = "cn"
strconstant sizing_dt_filter_name = "cn_datetime"
constant sizing_cn_filter_threshold = 20.0 // max allowable percentage of standard deviation from cn avg

// thermo constants
strconstant sizing_thermo_folder = "root:thermo"

// position constants
//strconstant sizing_position_label_list = "

// ProjectFlagWave 
constant sizing_auto_include_PFW = 0  // if true, automatically use PFW to filter along with user_nans

Menu "ACG Data"
	submenu "CN"
		"Load CN-MART", sizing_load_cn_mart()
	end
	submenu "Particle Sizing"
		submenu "SMPS"
			submenu "Load Data..."
				"from Rows", load_smps_rows()
			end
			"Change density", smps_change_density()
			"Reprocess data", sizing_reprocess_all_data("smps")
			"integrate N, S, V and M - all", integrate_NSVM("smps",integration_tb_for_menu,0)
			submenu "integrate N, S, V and M - fraction"
				"ammonium sulfate @ 0.22% SS", integrate_NSVM_fraction("smps",integration_tb_for_menu,"as_0_22_SS",0,0)
				"ammonium sulfate @ 0.44% SS", integrate_NSVM_fraction("smps",integration_tb_for_menu,"as_0_44_SS",0,0)
				"ammonium sulfate @ 0.65% SS", integrate_NSVM_fraction("smps",integration_tb_for_menu,"as_0_65_SS",0,0)
				"ammonium sulfate @ 0.84% SS", integrate_NSVM_fraction("smps",integration_tb_for_menu,"as_0_84_SS",0,0)
				"ammonium sulfate @ 1.00% SS", integrate_NSVM_fraction("smps",integration_tb_for_menu,"as_1_00_SS",0,0)
				"\\M0Dp < 1um,aero", integrate_NSVM_fraction("smps",integration_tb_for_menu,"sub1",1,0)
				"\\M01um < Dp < 10um,aero", integrate_NSVM_fraction("smps",integration_tb_for_menu,"super1sub10",1,0)
				"\\M00.5um < Dp < 1um,aero", integrate_NSVM_fraction("smps",integration_tb_for_menu,"super0.5sub1",1,0)
				"\\M00.03um < Dp, geom", integrate_NSVM_fraction("smps",integration_tb_for_menu,"super0.03",0,0) // for thermal smps comparisons, use geometric
				
			end
		end
		submenu "DMPS & APS"
			submenu "Load Data..."
				"from AeroSizing", load_dmps_from_AS()
			end
			"Change density", dmps_change_density()
			"Reprocess data", sizing_reprocess_all_data("dmps");sizing_reprocess_all_data("aps")
			submenu "DMPS"
				"integrate N, S, V and M - all", integrate_NSVM("dmps",integration_tb_for_menu,0)
				submenu "integrate N, S, V and M - fraction"
					"ammonium sulfate @ 0.22% SS", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"as_0_22_SS",0,0)
					"ammonium sulfate @ 0.44% SS", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"as_0_44_SS",0,0)
					"ammonium sulfate @ 0.65% SS", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"as_0_65_SS",0,0)
					"ammonium sulfate @ 0.84% SS", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"as_0_84_SS",0,0)
					"ammonium sulfate @ 1.00% SS", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"as_1_00_SS",0,0)
					"\\M0Dp < 1um,aero", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"sub1",1,0)
					"\\M01um < Dp < 10um,aero", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"super1sub10",1,0)
					"\\M00.5um < Dp < 1um,aero", integrate_NSVM_fraction("dmps",integration_tb_for_menu,"super0.5sub1",1,0)
				end
			end
			submenu "APS"
				"integrate N, S, V and M - all", integrate_NSVM("aps",integration_tb_for_menu,0)
				submenu "integrate N, S, V and M - fraction"
					"\\M0Dp < 1um,aero", integrate_NSVM_fraction("aps",integration_tb_for_menu,"sub1",1,0)
					"\\M01um < Dp < 10um,aero", integrate_NSVM_fraction("aps",integration_tb_for_menu,"super1sub10",1,0)
					"\\M00.5um < Dp < 1um,aero", integrate_NSVM_fraction("aps",integration_tb_for_menu,"super0.5sub1",1,0)
				end
			end
			"Merge DMPS and APS - assumed density",sizing_merge_dmps_aps_both(integration_tb_for_menu)
			"Merge DMPS and APS - calculated density",sizing_merge_dmps_aps_2d(integration_tb_for_menu)
			"Shift merged DMPS APS to ambient- calculated density",sizing_shift_to_ambient("dmps_aps",integration_tb_for_menu,0) 
		end
	end
end

Menu "GraphMarquee"
	"-"
	"Plot Average Distribution", plot_avg_dist_from_marquee(0)
	"Plot Average Distribution with Edit window", plot_avg_dist_from_marquee(1)
	"-"
//	"SMPS: nan selection", smps_nan_selection_from_marquee()
//	"SMPS: reset selection", smps_reset_sel_from_marquee()
	submenu "SMPS"
		"nan range", smps_toggle_nans_from_marquee(1,1)
		"reset range", smps_toggle_nans_from_marquee(1,0)
		"nan points in selection", smps_toggle_nans_from_marquee(0,1)
		"reset points in selection", smps_toggle_nans_from_marquee(0,0)
	end
	"-"
	submenu "DMPS"
		"nan range", dmps_toggle_nans_from_marquee(1,1)
		"reset range", dmps_toggle_nans_from_marquee(1,0)
		"nan points in selection", dmps_toggle_nans_from_marquee(0,1)
		"reset points in selection", dmps_toggle_nans_from_marquee(0,0)
	end
	submenu "APS"
		"nan range", aps_toggle_nans_from_marquee(1,1)
		"reset range", aps_toggle_nans_from_marquee(1,0)
		"nan points in selection", aps_toggle_nans_from_marquee(0,1)
		"reset points in selection", aps_toggle_nans_from_marquee(0,0)
	end
//	"-"
//	"DMPS: nan selection", dmps_toggle_nans_from_marquee(1)
//	"DMPS: reset selection", dmps_toggle_nans_from_marquee(0)
//	"APS: nan selection", aps_toggle_nans_from_marquee(1)
//	"APS: reset selection", aps_toggle_nans_from_marquee(0)
	
End

function load_smps_rows()
	string sdf = getdatafolder(1)
	newdatafolder/O/S $sizing_tmp_data_folder
	//newdatafolder/O/S :raw

	variable/G smps_timebase = smps_defaultTimeBase

	set_base_path()
	PathInfo loaddata_base_path

	variable i,j,k
	
	// load meta data
	
	// load datetime
	//LoadWave/J/D/N=dt/O/K=0/L={13,14,0,1,2}/P=loaddata_base_path
	//LoadWave/J/D/N=dt/O/K=0/L={16,17,0,1,2}/P=loaddata_base_path  // ICEALOT
	//LoadWave/J/D/N=dt/O/K=0/L={13,14,0,1,2}/P=loaddata_base_path
	LoadWave/J/D/N=dt/O/K=0/L={18,19,0,1,2}/P=loaddata_base_path
	NewPath/o/z path_to_smps, S_path
	string smps_file = S_filename
	wave dt0, dt1
	duplicate/o dt0 smps_datetime
	smps_datetime = dt0+dt1
	killwaves dt0, dt1
		
	// load diameters
	//LoadWave/J/M/D/N=dp/O/K=0/L={12,14,1,4,0}/P=path_to_smps smps_file
	//LoadWave/J/M/D/N=dp/O/K=0/L={16,16,1,4,0}/P=path_to_smps smps_file  // ICEALOT
	//LoadWave/J/M/D/N=dp/O/K=0/L={13,13,1,4,0}/P=path_to_smps smps_file  // ICEALOT
	LoadWave/J/M/D/N=dp/O/K=0/L={18,18,1,8,0}/P=path_to_smps smps_file  // ICEALOT
	wave dp0
	make/o/n=1 smps_dp0
	smps_dp0[0] = dp0[0][0]
	for (i=1; i<dimsize(dp0,1); i+=1)
		if (numtype(dp0[0][i]) == 0) 
			insertpoints numpnts(smps_dp0), 1, smps_dp0
			smps_dp0[i] = dp0[0][i]
		endif
	endfor
	killwaves dp0			
			
	// load dN/dlogDp as matrix
//	LoadWave/J/M/D/N=smps/O/K=0/L={12,14,0,4,numpnts(smps_dp)}/P=path_to_smps smps_file
	//LoadWave/J/M/D/N=smps/O/K=0/L={16,17,0,4,numpnts(smps_dp0)}/P=path_to_smps smps_file  // ICEALOT
	//LoadWave/J/M/D/N=smps/O/K=0/L={13,14,0,4,numpnts(smps_dp0)}/P=path_to_smps smps_file  // ICEALOT
	LoadWave/J/M/D/N=smps/O/K=0/L={18,19,0,8,numpnts(smps_dp0)}/P=path_to_smps smps_file  // ICEALOT
	killpath/Z path_to_smps
	// create (or add to) dataset
	string/G smps_dataset_name
	newdatafolder/o root:smps
	newdatafolder/o/s $smps_datasets_folder
	sscanf smps_file, "%[^.]S80", smps_dataset_name
	smps_dataset_name += "_"+num2str(smps_timebase)
	newdatafolder/o/s $(smps_dataset_name)
	variable/G timebase = smps_timebase	
	
	
	// at some point, have function look at "current_timebase" and if
	//     the new timebase is different, copy all data to backup folder?
	// each dataset will have a "native" timebase - any concat routine can look 
	//      for datasets with matching timebase?
	
	// Each time a file is read it will overwrite the corresponding dataset as each
	//     file needs to be complete for a proper read
	
	// get datetime limits
	wave new_dt = $(sizing_tmp_data_folder+":"+"smps_datetime")
	wave new_dp = $(sizing_tmp_data_folder+":"+"smps_dp0")
	wave new_smps =  $(sizing_tmp_data_folder+":"+"smps0")
	
	variable mintime, maxtime
	wavestats/Q new_dt
	mintime = V_min
	maxtime = V_max

	variable/G first_starttime=mintime - mod(mintime,smps_timebase)
	variable/G last_starttime=maxtime - mod(maxtime,smps_timebase) + smps_timebase

	variable time_periods = (last_starttime-first_starttime)/(smps_timebase) + 1

	if ((last_starttime-maxtime) > smps_timebase)
		time_periods -= 1
	endif
	
	make/o/n=(time_periods)/d dataset_datetime
	variable cols = dimsize(new_smps,1)
	make/o/n=(time_periods,cols)/d smps_dNdlogDp
	
	wave ds_smps = smps_dNdlogDp
	ds_smps = NaN
	duplicate/o new_dp smps_dp
	string timebase_index = "timebase_index"
	dataset_datetime[0] = first_starttime
	for (i=0; i<time_periods; i+=1)
		dataset_datetime[i] = dataset_datetime[i-1]+smps_timebase
	endfor
	
	// put dataset on constant time base
	get_timebase_index_FindValue(dataset_datetime, new_dt, (smps_timebase/2),timebase_index)
	wave tb_index = $timebase_index
	for (i=0; i<numpnts(tb_index); i+=1)
		for (k=0; k<dimsize(ds_smps,1); k+=1)
			ds_smps[(tb_index[i])][k] = new_smps[i][k]
		endfor
	endfor
	killwaves/Z tb_index
	
//	SetScale/P x dataset_datetime[0],smps_timebase,"dat", ds_smps
	SetScale/P x dataset_datetime[0],smps_timebase,"dat", smps_dNdlogDp
	
	//string ds_wavelist="date_time;dp;smps"
	//for (i=0; i<itemsinlist(ds_wavelist); i+=1)
	//	if (waveexists($stringfromlist(i,ds_wavelist)))
	//		make/n=0/d $(stringfromlist(i,ds_wavelist))
	//	endif	
	//endfor
				
	// insert new dataset into main data
	smps_concatenate_datasets(smps_timebase)

	// clean user selected values
	smps_clean_user_times(smps_timebase)
		
	// add extra parameters for convenience
	add_aero_diams("smps",smps_timebase,0)
	convert_NtoSVM("smps",smps_timebase,0)
	integrate_NSVM("smps",smps_timebase,0)	
	create_im_plot_params("smps",smps_timebase,0)
	
	
	setdatafolder sdf
	killdatafolder $sizing_tmp_data_folder
End

	
Function init_smps_parameters()
	if (!datafolderexists(smps_parameter_folder))
		string sdf=getdatafolder(1)
		newdatafolder/s $smps_parameter_folder
		
		variable/G density=smps_nominalDensity
		variable/G tmp_density=smps_nominalDensity
		
		setdatafolder sdf
	endif
End		

Function init_dmps_parameters()
	if (!datafolderexists(dmps_parameter_folder))
		string sdf=getdatafolder(1)
		newdatafolder/s $dmps_parameter_folder
		
		variable/G density=dmps_nominalDensity
		variable/G tmp_density=dmps_nominalDensity
		
		setdatafolder sdf
	endif
End		
		
Function init_aps_parameters()
	if (!datafolderexists(aps_parameter_folder))
		string sdf=getdatafolder(1)
		newdatafolder/s $aps_parameter_folder
		
		variable/G density=aps_nominalDensity
		variable/G tmp_density=aps_nominalDensity
		
		setdatafolder sdf
	endif
End		
		
		
		
Function smps_concatenate_datasets(tb)
	variable tb
	
	init_smps_parameters()

	newdatafolder/o/s root:smps:$("data_"+num2str(tb)+"sec")
	
	string dset_list = get_dataset_list("smps")
	string tb_list=""
	variable i,j,k
	for (i=0; i<itemsinlist(dset_list); i+=1)
		NVAR ds_tb = root:smps:datasets:$(stringfromlist(i,dset_list)):timebase
		if (ds_tb == tb)
			tb_list = AddListItem(stringfromlist(i,dset_list),tb_list,";",999)
		endif
	endfor	
	
	// copy existing waves to backup
	if (waveexists(smps_datetime))
		duplicate/o smps_datetime smps_datetime_bak
	else
		killwaves/Z smps_datetime_bak
	endif
		if (waveexists(smps_user_nan))
		duplicate/o smps_user_nan smps_user_nan_bak
	else
		killwaves/Z smps_user_nan_bak
	endif
	
	variable mintime, maxtime
	for (i=0; i<itemsinlist(tb_list); i+=1)
		wave ds_dt = root:smps:datasets:$(stringfromlist(i,tb_list)):dataset_datetime
		wavestats/Q ds_dt
		if (i==0)		
			mintime = V_min
			maxtime = V_max
		else
			mintime = (V_min < mintime) ? V_min : mintime
			maxtime = (V_max > maxtime) ? V_max : maxtime
		endif
	endfor

	variable time_periods = (maxtime-mintime)/(tb) + 1
	make/o/n=(time_periods)/d smps_datetime

	smps_datetime[0] = mintime
	for (i=0; i<time_periods; i+=1)
		smps_datetime[i] = smps_datetime[i-1]+tb
	endfor
	
	
	for (i=0; i<itemsinlist(tb_list); i+=1)
		if (i==0) // use first dataset to set dp and matrix width
			duplicate/o root:smps:datasets:$(stringfromlist(i,tb_list)):smps_dp smps_dp smps_dp_native
			wave smps = root:smps:datasets:$(stringfromlist(i,tb_list)):smps_dNdlogDp			
			variable cols = dimsize(smps,1)
			make/o/n=(time_periods,cols)/d smps_dNdlogDp
			smps_dNdlogDp=NaN
			sizing_make_density_w("smps",time_periods,cols)
			wave main_smps_density = smps_density_w
		endif
		
		wave main_dt = smps_datetime
		wave main_smps = smps_dNdlogDp
		
		wave ds_dt = root:smps:datasets:$(stringfromlist(i,tb_list)):dataset_datetime
		wave ds_smps = root:smps:datasets:$(stringfromlist(i,tb_list)):smps_dNdlogDp	

		string timebase_index = "timebase_index"
		get_timebase_index(main_dt, ds_dt, 5, timebase_index)
		wave tb_index = $timebase_index

		for (j=0; j<numpnts(tb_index); j+=1)
			for (k=0; k<dimsize(main_smps,1); k+=1)
				if (tb_index[j] > -1)
					main_smps[(tb_index[j])][k] = ds_smps[j][k]
					//print i, j, k, tb_index[j], main_smps[(tb_index[j])][k], ds_smps[j][k]
				endif
			endfor
		endfor

		killwaves/Z tb_index		
		
		
	endfor

	// make a copy of main_smps to work from
	wave main_dt = smps_datetime
	wave main_smps = smps_dNdlogDp
	
	SetScale/P x main_dt[0],tb,"dat", main_smps
	duplicate/o main_smps smps_dNdlogDp_raw
	//make/o/d/n=(dimsize(main_smps,0)) smps_user_nan
	duplicate/o main_smps smps_user_nan
	wave user_nan = smps_user_nan
	user_nan = 0
	// copy backup copy to new user_nan wave
	if (waveexists(smps_user_nan_bak))
		print "		copying old user_selections into new working wave"
		wave user_nan_bak = smps_user_nan_bak
		// check if old, 1D user nan		
		if (dimsize(user_nan_bak,1) == 0) // old...need to convert
			duplicate/o user_nan_bak smps_user_nan_bak_1d
			wave user_nan_bak_1d = smps_user_nan_bak_1d
			duplicate/o main_smps smps_user_nan_bak
			wave user_nan_bak = smps_user_nan_bak
			user_nan_bak = user_nan_bak_1d[p]
		endif
		wave user_nan_bak = smps_user_nan_bak

		wave dt = smps_datetime
		wave dt_bak = smps_datetime_bak
		for (i=0; i<numpnts(dt_bak); i+=1)
			//FindValue/T=(0.2)/V=(dt_bak[i]) dt
			//user_nan[V_Value]=user_nan_bak[i]
			variable index = BinarySearch(dt,dt_bak[i])
			user_nan[index][] = user_nan_bak[i][q]
		endfor
	endif


			
end

Function	smps_clean_user_times(tb)
	variable tb
	string sdf = getdatafolder(1)
	setdatafolder root:smps:$("data_"+num2str(tb)+"sec")
	
	wave smps_main = smps_dNdlogDp
	wave smps_raw = smps_dNdlogDp_raw
	wave user_nan = smps_user_nan
	smps_main = (user_nan[p][q] ==1) ? NaN : smps_raw[p][q]
	
	setdatafolder sdf		
End

Function create_im_plot_params(inst,tb,isFilter)
	string inst
	variable tb
	variable isFilter
	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	// add datetime_im wave
	wave dt = $(inst+"_datetime")
	variable np = numpnts(dt)
	duplicate/o dt $(inst+"_datetime_im")
	wave dt_im = $(inst+"_datetime_im")
	insertpoints numpnts(dt_im), 1, dt_im
	variable imnp =  numpnts(dt_im)
	dt_im[imnp-1] = dt[np-1]+tb
	
	// add diameter_im waves
	wave gdp = $(inst+"_dp")
	wave gdp_um = $(inst+"_dp_um")
	getDpBounds(gdp,(inst+"_dp_im"))
	getDpBounds(gdp_um,(inst+"_dp_um_im"))
	
	wave dpa =  $(inst+"_dpa")
	wave dpa_um =  $(inst+"_dpa_um")
	getDpBounds(dpa,(inst+"_dpa_im"))
	getDpBounds(dpa_um,(inst+"_dpa_um_im"))
	
	wave dpva =  $(inst+"_dpva")
	wave dpva_um =  $(inst+"_dpva_um")
	getDpBounds(dpva,(inst+"_dpva_im"))
	getDpBounds(dpva_um,(inst+"_dpva_um_im"))
	
	setdatafolder sdf	
End

//Function create_im_plot_params_2d(inst,tb,isFilter)
//	string inst
//	variable tb
//	variable isFilter
//	string sdf = getdatafolder(1)
//	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
//	if (isFilter)
//		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
//	else
//		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
//	endif
//
//	wave dt = $(inst+"_datetime")
//	if (cmpstr(inst,"aps") == 0)
//		
//		wave dp_um = $(inst+"_dpa_um_2d")
//		wave dp_um_2d = $(inst+"_dpa_um_2d")
//	else
//		wave dp_um = $(inst+"_dp_um_2d")
//		wave dp_um_2d = $(inst+"_dp_um_2d")
//	
//	setdatafolder sdf	
//End

// Adapted to handle smps, dmps and aps
//   some name were left as smps_X because I was too lazy to change them
Function convert_NtoSVM(inst,tb,isFilter)
	string inst
	variable tb
	variable isFilter
	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	
	//wave smpsN = smps_dNdlogDp
	wave smpsN = $(inst+"_dNdlogDp")
	//wave dp = smps_dp
	wave dp = $(inst+"_dp")
	//duplicate/o dp smps_dp_um
	//duplicate/o dp $(inst+"_dp_um")
	//wave dp_um = smps_dp_um
	wave dp_um = $(inst+"_dp_um")
	//if (cmpstr(inst,"smps")==0)
	//	dp_um=dp_um/1000.0  // smps program save as nm
	//else
	//	dp=dp_um*1000.0       // AeroSizing saves diameters as um
	//endif


	// added 23 July 2010 to fix datetime being off by 7 hours
	wave dt = $(inst+"_datetime")

	variable start_dt = DimOffset(smpsN,0)
	if (dt[0] != start_dt)
		variable smps_timebase = dmps_defaultTimeBase
		if (cmpstr(inst,"smps") == 0) 
			smps_timebase = smps_defaultTimeBase
		elseif (cmpstr(inst,"aps") == 0)
			smps_timebase = aps_defaultTimeBase
		endif
		
		SetScale/P x dt[0],smps_timebase,"dat", smpsN
		
	endif
	
	//duplicate/o smpsN smps_dSdlogDp, smps_dVdlogDp, smps_dMdlogDp
	duplicate/o smpsN $(inst+"_dSdlogDp"), $(inst+"_dVdlogDp"), $(inst+"_dMdlogDp")
//	wave smpsS = smps_dSdlogDp
//	wave smpsV = smps_dVdlogDp
//	wave smpsM = smps_dMdlogDp
	wave smpsS = $(inst+"_dSdlogDp")
	wave smpsV = $(inst+"_dVdlogDp")
	wave smpsM = $(inst+"_dMdlogDp")

	string pf
	if (cmpstr(inst,"smps") == 0)
		pf = smps_parameter_folder
	elseif (cmpstr(inst,"dmps") == 0)
		pf = dmps_parameter_folder
	elseif (cmpstr(inst,"aps") == 0)
		pf = aps_parameter_folder
	elseif (cmpstr(inst,"dmps_aps") == 0)
		//pf = dmps_aps_parameter_folder  // for now, use just the aps density
		pf = aps_parameter_folder
	endif
	
	//NVAR smps_density = $(smps_parameter_folder+":density")
	NVAR smps_density = $(pf+":density")




	smpsS = 4*PI*(dp_um[q]/2)^2*smpsN[p][q]
	smpsV = 4/3*PI*(dp_um[q]/2)^3*smpsN[p][q]
	smpsM = smpsV*smps_density
	//killwaves/Z dp_um
	
//	duplicate/o smpsN smps_dNdlogDp_tr
//	duplicate/o smpsS smps_dSdlogDp_tr
//	duplicate/o smpsV smps_dVdlogDp_tr
//	duplicate/o smpsM smps_dMdlogDp_tr
	duplicate/o smpsN $(inst+"_dNdlogDp_tr")
	duplicate/o smpsS $(inst+"_dSdlogDp_tr")
	duplicate/o smpsV $(inst+"_dVdlogDp_tr")
	duplicate/o smpsM $(inst+"_dMdlogDp_tr")
		
//	MatrixTranspose smps_dNdlogDp_tr
//	MatrixTranspose smps_dSdlogDp_tr
//	MatrixTranspose smps_dVdlogDp_tr
//	MatrixTranspose smps_dMdlogDp_tr
	MatrixTranspose $(inst+"_dNdlogDp_tr")
	MatrixTranspose $(inst+"_dSdlogDp_tr")
	MatrixTranspose $(inst+"_dVdlogDp_tr")
	MatrixTranspose $(inst+"_dMdlogDp_tr")
		
//	variable i,j
//	for (i=0; i<dimsize(smpsN,0); i+=1)
//		for (j=0; j<dimsize(smpsN,1); j+=1)
//			smpsS[i][j] = 4.0*PI*(dp_um[i]/2.0)^2*smpsN[i][j]
//			//smpsV[i][j] = 4.0/3.0*PI*(dp_um[i]/2.0)^3*smpsN[i][j]
//			smpsM[i][j] = smpsV[i][j]*smps_density
//		endfor
//	endfor	
	setdatafolder sdf
End

Function convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	string inst					// inst: the instrument in question ("dmps", "aps","smps","dmps_aps")
	variable tb					// tb : timebase in seconds
	variable isFilter				// isFilter: use the CN filtered values (0 = no, 1 = yes)
	variable isAmbient 			// isAmbient: use the ambient distributions (0 = no, 1 = yes)
	variable isModified			// isModified: a little generic here...if this is true then the function will use the sizedist "as is" (0 = no, 1 = yes)
	string shape
	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	string ambstr
	if (isAmbient)
		ambstr = "_amb"
	else
		//duplicate/o $(inst+"_dNdlogDp") $(inst+"_dNdlogDp_2d")
		ambstr = ""
	endif
//	ambstr = (isAmbient) ? "_amb" : ""
	
//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
		
	
	if (!isModified && !isAmbient)
//		duplicate/o $(inst+"_dNdlogDp") $(inst+"_dNdlogDp"+shapestr+"_2d")
		duplicate/o $(inst+"_dNdlogDp") $(inst+"_dNdlogDp_2d")
	endif
	
	//wave smpsN = smps_dNdlogDp
//	wave smpsN = $(inst+"_dNdlogDp"+shapestr+ambstr+"_2d")
	wave smpsN = $(inst+"_dNdlogDp"+ambstr+"_2d")
	//wave dp = smps_dp
	wave dp = $(inst+"_dp")
	//duplicate/o dp smps_dp_um
	//duplicate/o dp $(inst+"_dp_um")
	//wave dp_um = smps_dp_um
	wave dp_um = $(inst+"_dp_um_2d") // <-- change back to orig
	//wave dp_um = $(inst+"_dp_um"+shapestr+ambstr+"_2d")   //* change to shape and amb
	//if (cmpstr(inst,"smps")==0)
	//	dp_um=dp_um/1000.0  // smps program save as nm
	//else
	//	dp=dp_um*1000.0       // AeroSizing saves diameters as um
	//endif
	
	
	//duplicate/o smpsN smps_dSdlogDp, smps_dVdlogDp, smps_dMdlogDp
//	duplicate/o smpsN $(inst+"_dSdlogDp"+shapestr+ambstr+"_2d"), $(inst+"_dVdlogDp"+shapestr+ambstr+"_2d"), $(inst+"_dMdlogDp"+shapestr+ambstr+"_2d")
	duplicate/o smpsN $(inst+"_dSdlogDp"+ambstr+"_2d"), $(inst+"_dVdlogDp"+ambstr+"_2d"), $(inst+"_dMdlogDp"+ambstr+"_2d")
//	wave smpsS = smps_dSdlogDp
//	wave smpsV = smps_dVdlogDp
//	wave smpsM = smps_dMdlogDp
//	wave smpsS = $(inst+"_dSdlogDp"+shapestr+ambstr+"_2d")
//	wave smpsV = $(inst+"_dVdlogDp"+shapestr+ambstr+"_2d")
//	wave smpsM = $(inst+"_dMdlogDp"+shapestr+ambstr+"_2d")
	wave smpsS = $(inst+"_dSdlogDp"+ambstr+"_2d")
	wave smpsV = $(inst+"_dVdlogDp"+ambstr+"_2d")
	wave smpsM = $(inst+"_dMdlogDp"+ambstr+"_2d")

	string pf
	if (cmpstr(inst,"smps") == 0)
		pf = smps_parameter_folder
	elseif (cmpstr(inst,"dmps") == 0)
		pf = dmps_parameter_folder
	elseif (cmpstr(inst,"aps") == 0)
		pf = aps_parameter_folder
	elseif (cmpstr(inst,"dmps_aps") == 0)
		pf = dmps_aps_parameter_folder
	endif
	
	//NVAR smps_density = $(smps_parameter_folder+":density")
	//NVAR smps_density = $(pf+":density")


//	sizing_get_density_2d(inst,tb,dp_um,"geom",(inst+"_density"+shapestr+ambstr+"_2d"),isFilter,isAmbient)
	sizing_get_density_2d(inst,tb,dp_um,"geom",(inst+"_density"+ambstr+"_2d"),isFilter,isAmbient,shape)
//	wave smps_density = $(inst+"_density"+shapestr+ambstr+"_2d")
	wave smps_density = $(inst+"_density"+ambstr+"_2d")
	
	smpsS = 4*PI*(dp_um/2)^2*smpsN
	smpsV = 4/3*PI*(dp_um/2)^3*smpsN
	smpsM = smpsV*smps_density
	//killwaves/Z dp_um
	//killwaves smps_density
	
//	duplicate/o smpsN smps_dNdlogDp_tr
//	duplicate/o smpsS smps_dSdlogDp_tr
//	duplicate/o smpsV smps_dVdlogDp_tr
//	duplicate/o smpsM smps_dMdlogDp_tr
//	duplicate/o smpsN $(inst+"_dNdlogDp"+ambstr+"_2d_tr")
//	duplicate/o smpsS $(inst+"_dSdlogDp"+ambstr+"_2d_tr")
//	duplicate/o smpsV $(inst+"_dVdlogDp"+ambstr+"_2d_tr")
//	duplicate/o smpsM $(inst+"_dMdlogDp"+ambstr+"_2d_tr")
		
//	MatrixTranspose smps_dNdlogDp_tr
//	MatrixTranspose smps_dSdlogDp_tr
//	MatrixTranspose smps_dVdlogDp_tr
//	MatrixTranspose smps_dMdlogDp_tr
//	MatrixTranspose $(inst+"_dNdlogDp"+ambstr+"_2d_tr")
//	MatrixTranspose $(inst+"_dSdlogDp"+ambstr+"_2d_tr")
//	MatrixTranspose $(inst+"_dVdlogDp"+ambstr+"_2d_tr")
//	MatrixTranspose $(inst+"_dMdlogDp"+ambstr+"_2d_tr")
		
//	variable i,j
//	for (i=0; i<dimsize(smpsN,0); i+=1)
//		for (j=0; j<dimsize(smpsN,1); j+=1)
//			smpsS[i][j] = 4.0*PI*(dp_um[i]/2.0)^2*smpsN[i][j]
//			//smpsV[i][j] = 4.0/3.0*PI*(dp_um[i]/2.0)^3*smpsN[i][j]
//			smpsM[i][j] = smpsV[i][j]*smps_density
//		endfor
//	endfor	

	killwaves/Z smps_density
	setdatafolder sdf
End

Function add_aero_diams(inst,tb,isFilter)
	string inst
	variable tb
	variable isFilter
	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	//NVAR smps_density = $($(inst+"_parameter_folder")+":density")
	//print $(inst+"_param_folder")
	
	wave dp = $(inst+"_dp")
	if (!exists(inst+"_dpa"))
		duplicate/o dp $(inst+"_dpa")
	endif
	wave dpa = $(inst+"_dpa")
	wave dp_native = $(inst+"_dp_native")
	duplicate/o dp_native $(inst+"_dp_um"), $(inst+"_dpa_um"), $(inst+"_dpva_um")
	wave dp_um = $(inst+"_dp_um")
	wave dpa_um = $(inst+"_dpa_um")
	wave dpva_um = $(inst+"_dpva_um")
	if ( (cmpstr(inst,"smps")==0) || (cmpstr(inst,"dmps_aps")==0) ) // add case for merged data set
		dp_um=dp_native/1000.0  // smps program save as nm
	elseif (cmpstr(inst,"aps")==0)
		dpa = dp_native*1000
	else
		dp=dp_native*1000.0       // AeroSizing saves diameters as um
	endif
	
//	// 5March2007 - add 2d density and dp waves to hold "real" densities
//	wave dndlogdp = $(inst+"_dNdlogDp")
//	duplicate/o dndlogdp $(inst+"_density_2d")
//	wave density_2d = $(inst+"_density_2d")
	
	if (cmpstr(inst,"aps") == 0)
		NVAR smps_density = $(aps_parameter_folder+":density")		
		wave adp = $(inst+"_dpa")
		duplicate/o adp $(inst+"_dp") $(inst+"_dpva")
		wave smps_dp = $(inst+"_dp")
		wave smps_dpva = $(inst+"_dpva")
		smps_dp = adp/sqrt(smps_density)
		smps_dpva = adp*sqrt(smps_density)
		dp_um = smps_dp/1000.	
		dpa_um = adp/1000.		
		dpva_um = smps_dpva/1000.		
	else
		string pf
		if (cmpstr(inst,"smps") == 0)
			pf = smps_parameter_folder
		elseif (cmpstr(inst,"dmps") == 0)
			pf = dmps_parameter_folder
		elseif (cmpstr(inst,"dmps_aps") == 0)
			//pf = dmps_aps_parameter_folder
			pf = aps_parameter_folder
		endif
		NVAR smps_density = $(pf+":density")		
		wave gdp = $(inst+"_dp")
		duplicate/o gdp $(inst+"_dpa") $(inst+"_dpva")
		wave smps_dpa = $(inst+"_dpa")
		wave smps_dpva = $(inst+"_dpva")
		smps_dpa = gdp*sqrt(smps_density)
		smps_dpva = gdp*smps_density	
		dp_um = gdp/1000.	
		dpa_um = smps_dpa/1000.		
		dpva_um = smps_dpva/1000.		
	endif
	
	//killwaves density_2d
	
	setdatafolder sdf
End

Function sizing_get_gf_1d(inst, tb, dt, dp,dp_type,gf_type,dest_wavename,isFilter,shape)
	string inst
	variable tb
	wave dt
	wave dp
	string dp_type // "geom", "aero", "vaero"
	string gf_type // "samp_amb", "dmps_samp"	
	string dest_wavename
	variable isFilter
	string shape

	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	// create 2d dp wave
	make/o/n=(numpnts(dt),numpnts(dp)) tmp_dp_2d
	wave tmp_dp = tmp_dp_2d
	tmp_dp[][] = dp[q]
	sizing_get_gf_2d(inst,tb,tmp_dp_2d,dp_type,gf_type,dest_wavename,isFilter,shape)
	killwaves tmp_dp_2d
	setdatafolder sdf
		
End

Function sizing_get_gf_2d(inst, tb, dp,dp_type,gf_type,dest_wavename,isFilter,shape)
	string inst
	variable tb
//	wave dt
	wave dp
	string dp_type // "geom", "aero", "vaero"
	string gf_type // "samp_amb", "dmps_samp"
	string dest_wavename
	variable isFilter
	string shape

	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
//	make/o/n=(numpnts(dt),numpnts(dp)) $dest_wavename
	duplicate/o dp  $dest_wavename
	wave out_gf = $dest_wavename
	out_gf=NaN

	wave dens = root:thermo:density_time_fit
	
	string gfwavename
	if (cmpstr(gf_type,"samp_amb") == 0)
		gfwavename = "root:thermo:gf_samp_amb_time_fit"
	elseif (cmpstr(gf_type,"dmps_samp") == 0)
		gfwavename = "root:thermo:gf_dmps_samp_time_fit"
	endif
	wave gf = $(gfwavename)
	
	duplicate/o root:thermo:midpoint_diameters midpt_diam
	wave midpt = midpt_diam
	if (cmpstr(dp_type,"geom")==0) // need to add case for vac aero
		midpt /= sqrt(dens)
	endif
	
	make/o/n=(dimsize(gf,1)) tmp_gf
	wave tgf = tmp_gf
	make/o/n=(dimsize(dp,1)) tmp_dp
	wave tdp = tmp_dp
	
	variable i
	for (i=0; i<dimsize(dp,0); i+=1)
		tgf = gf[i][p]
		tdp = dp[i][p]
		sizing_interp_nan_gap(tdp, midpt, tgf, "tmp_gf_fit")	
		wave tgf_fit = $("tmp_gf_fit")
		out_gf[i][] = tgf_fit[q]
	endfor
	
	setdatafolder sdf
End

Function sizing_get_density_1d(inst, tb, dt, dp,dp_type,dest_wavename,isFilter,isAmbient,shape)
	string inst
	variable tb
	wave dt
	wave dp
	string dp_type // "geom", "aero", "vaero"
	string dest_wavename
	variable isFilter
	variable isAmbient
	string shape
	
	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	// create 2d dp wave
	make/o/n=(numpnts(dt),numpnts(dp)) tmp_dp_2d
	wave tmp_dp = tmp_dp_2d
	tmp_dp[][] = dp[q]
	sizing_get_density_2d(inst,tb,tmp_dp_2d,dp_type,dest_wavename,isFilter,isAmbient,shape)
	killwaves tmp_dp_2d
	setdatafolder sdf
		
End

Function sizing_get_density_2d(inst, tb, dp,dp_type,dest_wavename,isFilter,isAmbient,shape)
	string inst
	variable tb
//	wave dt
	wave dp
	string dp_type // "geom", "aero", "vaero"
	string dest_wavename
	variable isFilter
	variable isAmbient
	string shape
	
	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
//	make/o/n=(numpnts(dt),numpnts(dp)) $dest_wavename
	duplicate/o dp  $dest_wavename
	wave out_dens = $dest_wavename
	out_dens=NaN
	
	string density_name
	if (isAmbient)
		density_name="root:thermo:density_amb_time_fit"
	else
		density_name="root:thermo:density_time_fit"
	endif
		
	wave dens = $density_name

	duplicate/o root:thermo:midpoint_diameters midpt_diam
	wave midpt = midpt_diam
	if (cmpstr(dp_type,"geom")==0) // need to add case for vac aero
		midpt /= sqrt(dens)
	endif
	
	make/o/n=(dimsize(dens,1)) tmp_dens
	wave tdens = tmp_dens
	make/o/n=(dimsize(dp,1)) tmp_dp
	wave tdp = tmp_dp
	
	variable i
	for (i=0; i<dimsize(dp,0); i+=1)
		tdens = dens[i][p]
		tdp = dp[i][p]
		sizing_interp_nan_gap(tdp, midpt, tdens, "tmp_dens_fit")	
		wave tdens_fit = $("tmp_dens_fit")
		out_dens[i][] = tdens_fit[q]
	endfor
	
	setdatafolder sdf
End

Function sizing_create_shape_subfolder(inst,shape)
	string inst
	string shape
	
	newdatafolder/O/S $shape
	
	// copy all of the necessary files to this new folder
	duplicate/o ::$(inst+"_datetime") $(inst+"_datetime") 
	duplicate/o ::$(inst+"_dp") $(inst+"_dp")
	duplicate/o ::$(inst+"_dpa") $(inst+"_dpa")
	duplicate/o ::$(inst+"_dp_native") $(inst+"_dp_native")

	duplicate/o ::$(inst+"_dNdlogDp") $(inst+"_dNdlogDp")
	duplicate/o ::$(inst+"_dNdlogDp_2d") $(inst+"_dNdlogDp_2d")
	
End

// 5March2007 - add 2d density and dp waves to hold "real" densities
Function add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)
	string inst
	variable tb
	variable isFilter
	variable isAmbient
	string shape

	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	//NVAR smps_density = $($(inst+"_parameter_folder")+":density")
	//print $(inst+"_param_folder")
	
	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	string ambstr
	if (isAmbient)
		ambstr = "_amb"
	else
		ambstr = ""
	endif
	
//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
	
	wave inst_dt = $(inst+"_datetime")
		
	wave dp = $(inst+"_dp")
	wave dpa = $(inst+"_dpa")
	wave dp_native = $(inst+"_dp_native")

	duplicate/o dp_native $(inst+"_dp_um"), $(inst+"_dpa_um"), $(inst+"_dpva_um")
	wave dp_um = $(inst+"_dp_um")
	wave dpa_um = $(inst+"_dpa_um")
	wave dpva_um = $(inst+"_dpva_um")
	if ( (cmpstr(inst,"smps")==0) || (cmpstr(inst,"dmps_aps")==0) ) // add case for merged data set
		dp_um=dp_native/1000.0  // smps program save as nm
	elseif (cmpstr(inst,"aps")==0)
		dpa = dp_native*1000
	else
		dp=dp_native*1000.0       // AeroSizing saves diameters as um
	endif
	
	
	if (cmpstr(inst,"aps") == 0)
	
		sizing_get_density_1d(inst, tb, inst_dt, dpa_um,"aero",(inst+"_density"+ambstr+"_2d"),isFilter,isAmbient,shape)
		wave density_2d = $(inst+"_density"+ambstr+"_2d")
//		duplicate/o density_2d $(inst+"_dpa_um"+shapestr+ambstr+"_2d"), $(inst+"_dp_um"+shapestr+ambstr+"_2d"), $(inst+"_dpva_um"+shapestr+ambstr+"_2d")
		duplicate/o density_2d $(inst+"_dpa_um"+ambstr+"_2d"), $(inst+"_dp_um"+ambstr+"_2d"), $(inst+"_dpva_um"+ambstr+"_2d")
		//create dpa_um_2d
//		wave dpa_um_2d =  $(inst+"_dpa_um"+shapestr+ambstr+"_2d")
		wave dpa_um_2d =  $(inst+"_dpa_um"+ambstr+"_2d")
		dpa_um_2d = dpa_um[q]
		
		//create dp_um_2d
		wave dp_um_2d =  $(inst+"_dp_um"+ambstr+"_2d")
		//dp_um_2d = dpa_um[q] / sqrt(density_2d[p][q])

		//** change to calculate stokes diam based on ultra-stokesian and shape corrections
		sizing_convert_aps_to_stokes(dpa_um_2d, density_2d, shape, "tmp_aps_dp_stokes")
		wave tmp_Dp = $("tmp_aps_dp_stokes")
		dp_um_2d = tmp_Dp
		killwaves/Z tmp_Dp

		//create dpva_um_2d
//		wave dpva_um_2d =  $(inst+"_dpva_um"+shapestr+ambstr+"_2d")
		wave dpva_um_2d =  $(inst+"_dpva_um"+ambstr+"_2d")
		//dpva_um_2d = dpa_um[q] * sqrt(density_2d[p][q])
		dpva_um_2d = dp_um_2d[p][q] * density_2d[p][q]

		//re-create dpa_um_2d from the new stokes diam
//		wave dpa_um_2d =  $(inst+"_dpa_um"+shapestr+ambstr+"_2d")
		wave dpa_um_2d =  $(inst+"_dpa_um"+ambstr+"_2d")
		//dpva_um_2d = dpa_um[q] * sqrt(density_2d[p][q])
		dpa_um_2d = dp_um_2d[p][q] * sqrt(density_2d[p][q])

		killwaves/Z density_2d

//		NVAR smps_density = $(aps_parameter_folder+":density")		
//		wave adp = $(inst+"_dpa")
//		duplicate/o adp $(inst+"_dp") $(inst+"_dpva")
//		wave smps_dp = $(inst+"_dp")
//		wave smps_dpva = $(inst+"_dpva")
//		smps_dp = adp/sqrt(smps_density)
//		smps_dpva = adp*sqrt(smps_density)
//		dp_um = smps_dp/1000.	
//		dpa_um = adp/1000.		
//		dpva_um = smps_dpva/1000.		
	else
		string pf
	
		// for the 

		sizing_get_density_1d(inst, tb, inst_dt, dp_um,"geom",(inst+"_density"+ambstr+"_2d"),isFilter,isAmbient,shape)
		wave density_2d = $(inst+"_density"+ambstr+"_2d")
//		duplicate/o density_2d $(inst+"_dp_um"+shapestr+ambstr+"_2d"), $(inst+"_dpa_um"+shapestr+ambstr+"_2d"), $(inst+"_dpva_um"+shapestr+ambstr+"_2d")
		duplicate/o density_2d $(inst+"_dp_um"+ambstr+"_2d"), $(inst+"_dpa_um"+ambstr+"_2d"), $(inst+"_dpva_um"+ambstr+"_2d")
		//create dp_um_2d
//		wave dp_um_2d =  $(inst+"_dp_um"+shapestr+ambstr+"_2d")
		wave dp_um_2d =  $(inst+"_dp_um"+ambstr+"_2d")
		if (cmpstr(inst,"dmps_aps")==0)
			//wave dmps_aps_dp_um = $(inst+"_dp_um_2d")
			wave dmps_aps_dp_um = $(inst+"_dp_um")
			//dp_um_2d = dmps_aps_dp_um  // <-- switch back to original...not sure which to use here.
			dp_um_2d = dmps_aps_dp_um[q]
		else
			dp_um_2d = dp_um[q]
		endif
			
		//create dpa_um_2d
//		wave dpa_um_2d =  $(inst+"_dpa_um"+shapestr+ambstr+"_2d")
		wave dpa_um_2d =  $(inst+"_dpa_um"+ambstr+"_2d")
		dpa_um_2d = dp_um[q] * sqrt(density_2d[p][q])

		//create dpva_um_2d
//		wave dpva_um_2d =  $(inst+"_dpva_um"+shapestr+ambstr+"_2d")
		wave dpva_um_2d =  $(inst+"_dpva_um"+ambstr+"_2d")
		dpva_um_2d = dp_um[q] * density_2d[p][q]

		killwaves/Z density_2d

//		if (cmpstr(inst,"smps") == 0)
//			pf = smps_parameter_folder
//		elseif (cmpstr(inst,"dmps") == 0)
//			pf = dmps_parameter_folder
//		elseif (cmpstr(inst,"dmps_aps") == 0)
//			pf = dmps_aps_parameter_folder
//		endif
//		NVAR smps_density = $(pf+":density")		
//		wave gdp = $(inst+"_dp")
//		duplicate/o gdp $(inst+"_dpa") $(inst+"_dpva")
//		wave smps_dpa = $(inst+"_dpa")
//		wave smps_dpva = $(inst+"_dpva")
//		smps_dpa = gdp*sqrt(smps_density)
//		smps_dpva = gdp*smps_density	
//		dp_um = gdp/1000.	
//		dpa_um = smps_dpa/1000.		
//		dpva_um = smps_dpva/1000.		
	endif
	
	setdatafolder sdf
End

Function sizing_integrate_7stage_imp(inst,tb,isFilter)
	string inst
	variable tb
	variable isFilter

	integrate_NSVM_fraction(inst,tb,"stage1",1,isFilter)
	integrate_NSVM_fraction(inst,tb,"stage2",2,isFilter)
	integrate_NSVM_fraction(inst,tb,"stage3",3,isFilter)
	integrate_NSVM_fraction(inst,tb,"stage4",4,isFilter)
	integrate_NSVM_fraction(inst,tb,"stage5",5,isFilter)
	integrate_NSVM_fraction(inst,tb,"stage6",6,isFilter)
	integrate_NSVM_fraction(inst,tb,"stage7",7,isFilter)

End

Function sizing_integrate_7stage_imp_2d(inst,tb,isFilter,isAmbient,shape)
	string inst
	variable tb
	variable isFilter
	variable isAmbient
	string shape

	integrate_NSVM_fraction_2d(inst,tb,"stage1",1,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"stage2",1,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"stage3",1,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"stage4",1,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"stage5",1,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"stage6",1,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"stage7",1,isFilter,isAmbient,shape)

End

Function integrate_NSVM(inst,tb,isFilter)
	string inst
	variable tb
	variable isFilter
	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	//wave smps = smps_dNdlogDp
	wave smps = $(inst+"_dNdlogDp")
	//wave dp = smps_dp
	wave dp = $(inst+"_dp")
	wave dt = $(inst+"_datetime")
	//duplicate/o smps smps_dN, smps_dS, smps_dV, smps_dM, smps_dlogDp 
	duplicate/o smps $(inst+"_dN"), $(inst+"_dS"), $(inst+"_dV"), $(inst+"_dM") 
	//duplicate/o dp smps_dlogDp 
	duplicate/o dp $(inst+"_dlogDp") 
	wave dndlogdp = $(inst+"_dNdlogDp")
	wave dn = $(inst+"_dN")
	wave dsdlogdp = $(inst+"_dSdlogDp")
	wave ds = $(inst+"_dS")
	wave dvdlogdp = $(inst+"_dVdlogDp")
	wave dv = $(inst+"_dV")
	wave dmdlogdp = $(inst+"_dMdlogDp")
	wave dm = $(inst+"_dM")
	
	wave dlogDp = $(inst+"_dlogDp")
	string DpBounds_name = "dp_bounds"
	//getDpBounds(dp,DpBounds_name)
	//wave bounds = $DpBounds_name
	dlogDp = log(dp[p+1]/dp[p])
	dlogDp[numpnts(dlogDp)-1] = dlogDp[numpnts(dlogDp)-2]
	
	variable rows = dimsize(dn,0)
	variable cols = dimsize(dn,1)
	dn = dndlogdp[p][q]*dlogDp[q]
	make/o/n=(rows)/d $(inst+"_intN")
	
	ds = dsdlogdp[p][q]*dlogDp[q]
	make/o/n=(rows)/d $(inst+"_intS")

	dv = dvdlogdp[p][q]*dlogDp[q]
	make/o/n=(rows)/d $(inst+"_intV")

	dm = dmdlogdp[p][q]*dlogDp[q]
	make/o/n=(rows)/d $(inst+"_intM")
	
	wave intN = $(inst+"_intN")
	SetScale/P x dt[0],tb,"dat", intN
	wave intS = $(inst+"_intS")
	SetScale/P x dt[0],tb,"dat", intS
	wave intV = $(inst+"_intV")
	SetScale/P x dt[0],tb,"dat", intV
	wave intM = $(inst+"_intM")
	SetScale/P x dt[0],tb,"dat", intM
	variable i,j
	for (i=0; i<rows; i+=1)
		intN[i]=0
		intS[i]=0
		intV[i]=0
		intM[i]=0
		for (j=0; j<cols; j+=1)
			if (numtype(dN[i][j]) == 0)
				//if (j<11)
				//	intN[i] += dN[i][j]*0.85
				//else
					intN[i] += dN[i][j]
				//endif
				intS[i] += dS[i][j]
				intV[i] += dV[i][j]
				intM[i] += dM[i][j]
			endif
		endfor
	endfor 
	
	
	//killwaves/Z dn, ds, dv, dm, dlogDp
	setdatafolder sdf
End	

// calculate integral values for sub1, super1, sub10, etc using aerodynamic diameters
Function integrate_NSVM_fraction(inst,tb,fraction,diam_type,isFilter)
	string inst
	variable tb
	string fraction
	variable diam_type // 0=geom, 1=aero, 2=vac aero
	variable isFilter
	diam_type = (diam_type <0 || diam_type>2) ? 1 : diam_type // set to aero if diam_type not of known type
	string sdf = getdatafolder(1)
	setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	//wave smps = smps_dNdlogDp
	wave smps = $(inst+"_dNdlogDp")
	//wave dp = smps_dp
	wave dp = $(inst+"_dp")
	
	string dplist = "_dp_um;_dpa_um;_dpva_um"
	//wave dpa = $(inst+"_dpa_um")
	wave dpa = $(inst+stringfromlist(diam_type,dplist))
	
	
	wave dt = $(inst+"_datetime")
	//duplicate/o smps smps_dN, smps_dS, smps_dV, smps_dM, smps_dlogDp 
	duplicate/o smps $(inst+"_dN"), $(inst+"_dS"), $(inst+"_dV"), $(inst+"_dM") 
	//duplicate/o dp smps_dlogDp 
	duplicate/o dp $(inst+"_dlogDp") 
	wave dndlogdp = $(inst+"_dNdlogDp")
	wave dn = $(inst+"_dN")
	wave dsdlogdp = $(inst+"_dSdlogDp")
	wave ds = $(inst+"_dS")
	wave dvdlogdp = $(inst+"_dVdlogDp")
	wave dv = $(inst+"_dV")
	wave dmdlogdp = $(inst+"_dMdlogDp")
	wave dm = $(inst+"_dM")
	
	wave dlogDp = $(inst+"_dlogDp")
	string DpBounds_name = "dp_bounds"
	//getDpBounds(dp,DpBounds_name)
	//wave bounds = $DpBounds_name
	dlogDp = log(dp[p+1]/dp[p])
	dlogDp[numpnts(dlogDp)-1] = dlogDp[numpnts(dlogDp)-2]
	
	variable rows = dimsize(dn,0)
	variable cols = dimsize(dn,1)
	dn = dndlogdp[p][q]*dlogDp[p]
	make/o/n=(rows)/d $(inst+"_intN_"+fraction)
	
	ds = dsdlogdp[p][q]*dlogDp[p]
	make/o/n=(rows)/d $(inst+"_intS_"+fraction)

	dv = dvdlogdp[p][q]*dlogDp[p]
	make/o/n=(rows)/d $(inst+"_intV_"+fraction)

	dm = dmdlogdp[p][q]*dlogDp[p]
	make/o/n=(rows)/d $(inst+"_intM_"+fraction)
	
	wave intN = $(inst+"_intN_"+fraction)
	SetScale/P x dt[0],tb,"dat", intN
	wave intS = $(inst+"_intS_"+fraction)
	SetScale/P x dt[0],tb,"dat", intS
	wave intV = $(inst+"_intV_"+fraction)
	SetScale/P x dt[0],tb,"dat", intV
	wave intM = $(inst+"_intM_"+fraction)
	SetScale/P x dt[0],tb,"dat", intM
	variable i,j
	for (i=0; i<rows; i+=1)
		intN[i]=0
		intS[i]=0
		intV[i]=0
		intM[i]=0
		for (j=0; j<cols; j+=1)
			if ( cmpstr(fraction,"sub1")==0 ) // Dp < 1um
				if (dpa[j] <= 1.0)
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super1sub10")==0 ) // 1um < Dp < 10um
				if ( (dpa[j] > 1.0) && (dpa[j] <= 10.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"sub2.5")==0 ) // Dp < 2.5um
				if ( dpa[j] <= 2.5 )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super2.5sub10")==0 ) // 2.5um < Dp < 10um
				if ( (dpa[j] > 2.5) && (dpa[j] <= 10.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super0.5sub1")==0 ) // 0.5um < Dp < 1um
				if ( (dpa[j] > 0.5) && (dpa[j] <= 1.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super0.03")==0 ) // 0.03um < Dp
				if ( (dpa[j] > 0.03)  )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage1")==0 ) // 0.24um <= Dp
				if ( (dpa[j] <= 0.24)  )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage2")==0 ) // 0.24um < Dp <= 0.31um
				if ( (dpa[j] > 0.24) && (dpa[j] <= 0.31) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage3")==0 ) // 0.31um < Dp <= 0.54um
				if ( (dpa[j] > 0.31) && (dpa[j] <= 0.54) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage4")==0 ) // 0.54um < Dp <= 1.06um
				if ( (dpa[j] > 0.54) && (dpa[j] <= 1.06) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage5")==0 ) // 1.06um < Dp <= 2.02um
				if ( (dpa[j] > 1.06) && (dpa[j] <= 2.02) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage6")==0 ) // 2.02um < Dp <= 4.13um
				if ( (dpa[j] > 2.02) && (dpa[j] <= 4.13) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage7")==0 ) // 4.13um < Dp <= 10.27um
				if ( (dpa[j] > 4.13) && (dpa[j] <= 10.27) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			else
				variable ss = 0
				for (ss=0; ss<itemsinlist(ammsulf_sat_levels); ss+=1)
					if (cmpstr(fraction, stringfromlist(ss,ammsulf_sat_levels)) == 0) 
						variable low_dp = str2num(stringfromlist(ss,ammsulf_sat_Dp))
						if ( dpa[j] > low_dp  )
							intN[i] += dN[i][j]
							intS[i] += dS[i][j]
							intV[i] += dV[i][j]
							intM[i] += dM[i][j]
						endif
					endif
				endfor
				
			endif
		endfor
	endfor 
	
	
	killwaves/Z dn, ds, dv, dm, dlogDp
	setdatafolder sdf
End	

Function integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	string inst
	variable tb
	variable isFilter
	variable isAmbient
	string shape
	
	string sdf = getdatafolder(1)
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	string ambstr
	if (isAmbient)
		ambstr = "_amb"
	else
		ambstr = ""
	endif
	
//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
		
	//wave smps = smps_dNdlogDp
//	wave smps = $(inst+"_dNdlogDp"+shapestr+ambstr+"_2d")
	wave smps = $(inst+"_dNdlogDp"+ambstr+"_2d")
	//wave dp = smps_dp
//	wave dp = $(inst+"_dp_um"+shapestr+ambstr+"_2d")
	wave dp = $(inst+"_dp_um"+ambstr+"_2d")
	wave dt = $(inst+"_datetime")
	//duplicate/o smps smps_dN, smps_dS, smps_dV, smps_dM, smps_dlogDp 
//	duplicate/o smps $(inst+"_dN"+shapestr+ambstr+"_2d"), $(inst+"_dS"+shapestr+ambstr+"_2d"), $(inst+"_dV"+shapestr+ambstr+"_2d"), $(inst+"_dM"+shapestr+ambstr+"_2d") 
	duplicate/o smps $(inst+"_dN"+ambstr+"_2d"), $(inst+"_dS"+ambstr+"_2d"), $(inst+"_dV"+ambstr+"_2d"), $(inst+"_dM"+ambstr+"_2d") 
	//duplicate/o dp smps_dlogDp 
//	duplicate/o dp $(inst+"_dlogDp"+shapestr+ambstr+"_2d") 
	duplicate/o dp $(inst+"_dlogDp"+ambstr+"_2d") 
//	wave dndlogdp = $(inst+"_dNdlogDp"+shapestr+ambstr+"_2d")
//	wave dn = $(inst+"_dN"+shapestr+ambstr+"_2d")
//	wave dsdlogdp = $(inst+"_dSdlogDp"+shapestr+ambstr+"_2d")
//	wave ds = $(inst+"_dS"+shapestr+ambstr+"_2d")
//	wave dvdlogdp = $(inst+"_dVdlogDp"+shapestr+ambstr+"_2d")
//	wave dv = $(inst+"_dV"+shapestr+ambstr+"_2d")
//	wave dmdlogdp = $(inst+"_dMdlogDp"+shapestr+ambstr+"_2d")
//	wave dm = $(inst+"_dM"+shapestr+ambstr+"_2d")
	wave dndlogdp = $(inst+"_dNdlogDp"+ambstr+"_2d")
	wave dn = $(inst+"_dN"+ambstr+"_2d")
	wave dsdlogdp = $(inst+"_dSdlogDp"+ambstr+"_2d")
	wave ds = $(inst+"_dS"+ambstr+"_2d")
	wave dvdlogdp = $(inst+"_dVdlogDp"+ambstr+"_2d")
	wave dv = $(inst+"_dV"+ambstr+"_2d")
	wave dmdlogdp = $(inst+"_dMdlogDp"+ambstr+"_2d")
	wave dm = $(inst+"_dM"+ambstr+"_2d")
	
//	wave dlogDp = $(inst+"_dlogDp"+shapestr+ambstr+"_2d")
	wave dlogDp = $(inst+"_dlogDp"+ambstr+"_2d")
	string DpBounds_name = "dp_bounds"
	//getDpBounds(dp,DpBounds_name)
	//wave bounds = $DpBounds_name
	dlogDp = log(dp[p][q+1]/dp[p][q])
	dlogDp[][dimsize(dlogDp,1)-1] = dlogDp[p][dimsize(dlogDp,1)-2]
	
	variable rows = dimsize(dn,0)
	variable cols = dimsize(dn,1)
	dn = dndlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intN"+shapestr+ambstr+"_2d")
	make/o/n=(rows)/d $(inst+"_intN"+ambstr+"_2d")
	
	ds = dsdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intS"+shapestr+ambstr+"_2d")
	make/o/n=(rows)/d $(inst+"_intS"+ambstr+"_2d")

	dv = dvdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intV"+shapestr+ambstr+"_2d")
	make/o/n=(rows)/d $(inst+"_intV"+ambstr+"_2d")

	dm = dmdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intM"+shapestr+ambstr+"_2d")
	make/o/n=(rows)/d $(inst+"_intM"+ambstr+"_2d")
	
//	wave intN = $(inst+"_intN"+shapestr+ambstr+"_2d")
//	SetScale/P x dt[0],tb,"dat", intN
//	wave intS = $(inst+"_intS"+shapestr+ambstr+"_2d")
//	SetScale/P x dt[0],tb,"dat", intS
//	wave intV = $(inst+"_intV"+shapestr+ambstr+"_2d")
//	SetScale/P x dt[0],tb,"dat", intV
//	wave intM = $(inst+"_intM"+shapestr+ambstr+"_2d")
//	SetScale/P x dt[0],tb,"dat", intM
	wave intN = $(inst+"_intN"+ambstr+"_2d")
	SetScale/P x dt[0],tb,"dat", intN
	wave intS = $(inst+"_intS"+ambstr+"_2d")
	SetScale/P x dt[0],tb,"dat", intS
	wave intV = $(inst+"_intV"+ambstr+"_2d")
	SetScale/P x dt[0],tb,"dat", intV
	wave intM = $(inst+"_intM"+ambstr+"_2d")
	SetScale/P x dt[0],tb,"dat", intM

	variable i,j
	for (i=0; i<rows; i+=1)
		intN[i]=0
		intS[i]=0
		intV[i]=0
		intM[i]=0
		for (j=0; j<cols; j+=1)
			if (numtype(dN[i][j]) == 0)
				//if (j<11)
				//	intN[i] += dN[i][j]*0.85
				//else
					intN[i] += dN[i][j]
				//endif
				intS[i] += dS[i][j]
				intV[i] += dV[i][j]
				intM[i] += dM[i][j]
			endif
		endfor
	endfor 
	
	
	//killwaves/Z dn, ds, dv, dm, dlogDp_2d
	setdatafolder sdf
End	

// calculate integral values for sub1, super1, sub10, etc using aerodynamic diameters
Function integrate_NSVM_fraction_2d(inst,tb,fraction,diam_type,isFilter,isAmbient,shape)
	string inst
	variable tb
	string fraction
	variable diam_type // 0=geom, 1=aero, 2=vac aero
	variable isFilter
	variable isAmbient
	string shape
	diam_type = (diam_type <0 || diam_type>2) ? 1 : diam_type // set to aero if diam_type not of known type
	string sdf = getdatafolder(1)
	setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	string ambstr
	if (isAmbient)
		ambstr = "_amb"
	else
		ambstr = ""
	endif
	
//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
		
	string fraction2 = fraction
//	if (cmpstr(shape,"sphere") != 0)
//		if (cmpstr(fraction2,"super1sub10") == 0)
//			fraction2 = "sup1sub10"
//		endif
//	endif
	
	//wave smps = smps_dNdlogDp
//	wave smps = $(inst+"_dNdlogDp"+shapestr+ambstr+"_2d")
	wave smps = $(inst+"_dNdlogDp"+ambstr+"_2d")
	//wave dp = smps_dp
	//wave dp = $(inst+"_dp")
	//wave dp = $(inst+"_dp_um_2d")	
//	wave dp = $(inst+"_dp_um"+shapestr+ambstr+"_2d")
	wave dp = $(inst+"_dp_um"+ambstr+"_2d")
	
//	string dplist = "_dp_um"+shapestr+ambstr+"_2d;_dpa_um"+shapestr+ambstr+"_2d;_dpva_um"+shapestr+ambstr+"_2d"
	string dplist = "_dp_um"+ambstr+"_2d;_dpa_um"+ambstr+"_2d;_dpva_um"+ambstr+"_2d"
	//wave dpa = $(inst+"_dpa_um")
	wave dpa = $(inst+stringfromlist(diam_type,dplist))
	
	
	wave dt = $(inst+"_datetime")
	//duplicate/o smps smps_dN, smps_dS, smps_dV, smps_dM, smps_dlogDp 
//	duplicate/o smps $(inst+"_dN"+shapestr+ambstr+"_2d"), $(inst+"_dS"+shapestr+ambstr+"_2d"), $(inst+"_dV"+shapestr+ambstr+"_2d"), $(inst+"_dM"+shapestr+ambstr+"_2d") 
	duplicate/o smps $(inst+"_dN"+ambstr+"_2d"), $(inst+"_dS"+ambstr+"_2d"), $(inst+"_dV"+ambstr+"_2d"), $(inst+"_dM"+ambstr+"_2d") 
	//duplicate/o dp smps_dlogDp 
//	duplicate/o dp $(inst+"_dlogDp"+shapestr+ambstr+"_2d") 
	duplicate/o dp $(inst+"_dlogDp"+ambstr+"_2d") 
//	wave dndlogdp = $(inst+"_dNdlogDp"+shapestr+ambstr+"_2d")
//	wave dn = $(inst+"_dN"+shapestr+ambstr+"_2d")
//	wave dsdlogdp = $(inst+"_dSdlogDp"+shapestr+ambstr+"_2d")
//	wave ds = $(inst+"_dS"+shapestr+ambstr+"_2d")
//	wave dvdlogdp = $(inst+"_dVdlogDp"+shapestr+ambstr+"_2d")
//	wave dv = $(inst+"_dV"+shapestr+ambstr+"_2d")
//	wave dmdlogdp = $(inst+"_dMdlogDp"+shapestr+ambstr+"_2d")
//	wave dm = $(inst+"_dM"+shapestr+ambstr+"_2d")
	wave dndlogdp = $(inst+"_dNdlogDp"+ambstr+"_2d")
	wave dn = $(inst+"_dN"+ambstr+"_2d")
	wave dsdlogdp = $(inst+"_dSdlogDp"+ambstr+"_2d")
	wave ds = $(inst+"_dS"+ambstr+"_2d")
	wave dvdlogdp = $(inst+"_dVdlogDp"+ambstr+"_2d")
	wave dv = $(inst+"_dV"+ambstr+"_2d")
	wave dmdlogdp = $(inst+"_dMdlogDp"+ambstr+"_2d")
	wave dm = $(inst+"_dM"+ambstr+"_2d")
	
//	wave dlogDp = $(inst+"_dlogDp"+shapestr+ambstr+"_2d")
	wave dlogDp = $(inst+"_dlogDp"+ambstr+"_2d")
	string DpBounds_name = "dp_bounds"
	//getDpBounds(dp,DpBounds_name)
	//wave bounds = $DpBounds_name
	dlogDp = log(dp[p][q+1]/dp[p][q])
	dlogDp[][dimsize(dlogDp,1)-1] = dlogDp[p][dimsize(dlogDp,1)-2]
	
	// have to change prefix when adding "amb" because it makes the name too long. Stupid limitation
	string inst2 = inst
	if (cmpstr(inst,"dmps_aps")==0)
		inst2 = "d_a"
	endif
	
	variable rows = dimsize(dn,0)
	variable cols = dimsize(dn,1)
	dn = dndlogdp*dlogDp
//	make/o/n=(rows)/d $(inst2+"_intN"+shapestr+ambstr+"_2d_"+fraction2)
	make/o/n=(rows)/d $(inst2+"_intN"+ambstr+"_2d_"+fraction2)
	
	ds = dsdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst2+"_intS"+shapestr+ambstr+"_2d_"+fraction2)
	make/o/n=(rows)/d $(inst2+"_intS"+ambstr+"_2d_"+fraction2)

	dv = dvdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst2+"_intV"+shapestr+ambstr+"_2d_"+fraction2)
	make/o/n=(rows)/d $(inst2+"_intV"+ambstr+"_2d_"+fraction2)

	dm = dmdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst2+"_intM"+shapestr+ambstr+"_2d_"+fraction2)
	make/o/n=(rows)/d $(inst2+"_intM"+ambstr+"_2d_"+fraction2)
	
//	wave intN = $(inst2+"_intN"+shapestr+ambstr+"_2d_"+fraction2)
//	SetScale/P x dt[0],tb,"dat", intN
//	wave intS = $(inst2+"_intS"+shapestr+ambstr+"_2d_"+fraction2)
//	SetScale/P x dt[0],tb,"dat", intS
//	wave intV = $(inst2+"_intV"+shapestr+ambstr+"_2d_"+fraction2)
//	SetScale/P x dt[0],tb,"dat", intV
//	wave intM = $(inst2+"_intM"+shapestr+ambstr+"_2d_"+fraction2)
//	SetScale/P x dt[0],tb,"dat", intM

	wave intN = $(inst2+"_intN"+ambstr+"_2d_"+fraction2)
	SetScale/P x dt[0],tb,"dat", intN
	wave intS = $(inst2+"_intS"+ambstr+"_2d_"+fraction2)
	SetScale/P x dt[0],tb,"dat", intS
	wave intV = $(inst2+"_intV"+ambstr+"_2d_"+fraction2)
	SetScale/P x dt[0],tb,"dat", intV
	wave intM = $(inst2+"_intM"+ambstr+"_2d_"+fraction2)
	SetScale/P x dt[0],tb,"dat", intM

	variable i,j
	for (i=0; i<rows; i+=1)
		intN[i]=0
		intS[i]=0
		intV[i]=0
		intM[i]=0
		for (j=0; j<cols; j+=1)
			if ( cmpstr(fraction,"sub1")==0 ) // Dp < 1um
				if (dpa[i][j] <= 1.0)
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"all")==0 ) // Dp > 0um
				if (dpa[i][j] > 0)
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super1sub10")==0 ) // 1um < Dp < 10um
				if ( (dpa[i][j] > 1.0) && (dpa[i][j] <= 10.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super0.5sub1")==0 ) // 0.5um < Dp < 1um
				if ( (dpa[i][j] > 0.5) && (dpa[i][j] <= 1.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super2sub10")==0 ) // 2um < Dp < 10um
				if ( (dpa[i][j] >= 2.0) && (dpa[i][j] <= 10.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"sub2.5")==0 ) // Dp < 2.5um
				if ( dpa[j] <= 2.5 )
					intN[i][j] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"super2.5sub10")==0 ) // 2.5um < Dp < 10um
				if ( (dpa[i][j] > 2.5) && (dpa[j] <= 10.0) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"pm2_5")==0 ) // Dp < 2.5um
				if (dpa[i][j] <= 2.5)
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"sub700nm")==0 ) // Dp < 0.7um
				if ( dpa[i][j] <= 0.7 )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"sub180nm")==0 ) // Dp < 0.180um
				if ( dpa[i][j] <= 0.180 )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"accum")==0 ) // 0.1um < Dp < 0.7um
				if ( (dpa[i][j] >= 0.1) && (dpa[i][j] <= 0.7) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage1")==0 ) // 0.24um <= Dp
				if ( (dpa[i][j] <= 0.24)  )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage2")==0 ) // 0.24um < Dp <= 0.31um
				if ( (dpa[i][j] > 0.24) && (dpa[i][j] <= 0.31) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage3")==0 ) // 0.31um < Dp <= 0.54um
				if ( (dpa[i][j] > 0.31) && (dpa[i][j] <= 0.54) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage4")==0 ) // 0.54um < Dp <= 1.06um
				if ( (dpa[i][j] > 0.54) && (dpa[i][j] <= 1.06) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage5")==0 ) // 1.06um < Dp <= 2.02um
				if ( (dpa[i][j] > 1.06) && (dpa[i][j] <= 2.02) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage6")==0 ) // 2.02um < Dp <= 4.13um
				if ( (dpa[i][j] > 2.02) && (dpa[i][j] <= 4.13) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			elseif ( cmpstr(fraction,"stage7")==0 ) // 4.13um < Dp <= 10.27um
				if ( (dpa[i][j] > 4.13) && (dpa[i][j] <= 10.27) )
					intN[i] += dN[i][j]
					intS[i] += dS[i][j]
					intV[i] += dV[i][j]
					intM[i] += dM[i][j]
				endif
			else
				variable ss = 0
				for (ss=0; ss<itemsinlist(ammsulf_sat_levels); ss+=1)
					if (cmpstr(fraction, stringfromlist(ss,ammsulf_sat_levels)) == 0) 
						variable low_dp = str2num(stringfromlist(ss,ammsulf_sat_Dp))
						if ( dpa[i][j] > low_dp  )
							intN[i] += dN[i][j]
							intS[i] += dS[i][j]
							intV[i] += dV[i][j]
							intM[i] += dM[i][j]
						endif
					endif
				endfor
				
			endif
		endfor
	endfor 
	
	
	killwaves/Z dn, ds, dv, dm, dlogDp_2d
	setdatafolder sdf
End	

Function getDpBounds(diam,diam_bounds_name)
	wave diam
	string diam_bounds_name

	make/o/n=(numpnts(diam)+1)/d $diam_bounds_name
	wave bounds = $diam_bounds_name
	
	variable i
	for (i=1; i<numpnts(diam); i+=1)
		bounds[i] = sqrt(diam[i-1]*diam[i])
		//print i, bounds[i], diam[i-1], diam[i]
	endfor
	bounds[0] = diam[0] - (bounds[1] - diam[0])
	variable np = numpnts(bounds)
	bounds[np-1] = diam[numpnts(diam)-1] + (diam[numpnts(diam)-1] - bounds[np-2])
End

Function/S get_dataset_list(inst)
	string inst
	string wlist=""
	string dset_folder = "root:"+inst+":datasets"
	string wname=""
	variable index=0
	do
		wname = GetIndexedObjName(dset_folder,4, index)
		if (strlen(wname) == 0)
			break
		endif
			
		//Print wname
		wlist += wname + ";"
		index += 1
	while(1)
	//print wlist, itemsinlist(wlist)
	return SortList(wlist)
End

Function smps_change_density()
	display_smps_change_density()
End

Function dmps_change_density()
	display_dmps_change_density()
End

Function sizing_reprocess_all_data(inst)
	string inst
	variable i,tbase
	string tb, tb_list
	tb_list = sizing_get_timebase_list(inst)
  	print tb_list
	for (i=0; i<itemsinlist(tb_list); i+=1)
		tbase = str2num(stringfromlist(i,tb_list))
		//sizing_reprocess_data(inst,tbase,0)
		sizing_reprocess_inst_data(inst,tbase)
	endfor	
End

Function sizing_reprocess_inst_data(inst,tb)
	string inst
	variable tb
	
	sizing_reprocess_data(inst,tb,0)
	if (sizing_filter_with_cn(inst,tb))
		sizing_reprocess_data(inst,tb,1)
	endif
End

// 7 Dec 2006 - add argument to specify filtered or non-filtered
Function sizing_reprocess_data(inst,tb,isFilter)
	string inst
	variable tb
	variable isFilter // 0=non, 1=filter
	//print "tb = ", tb
	
	// removed with the addition of sizing_reprocess_inst_data
//	// filter data to get latest user_nans etc
//	if (isFilter)
//		sizing_filter_with_cn(inst,tb)
//	endif
	
	add_aero_diams(inst,tb,isFilter)
	convert_NtoSVM(inst,tb,isFilter)
	integrate_NSVM(inst,tb,isFilter)	
	create_im_plot_params(inst,tb,isFilter)
	
End

Function/S sizing_get_timebase_list(inst)
	string inst
	string wlist=""
	string tb_folder = "root:"+inst
	string wname=""
	variable index=0
	do
		wname = GetIndexedObjName(tb_folder,4, index)
		if (strlen(wname) == 0)
			break
		endif
		print tb_folder, wname
		if (stringmatch(wname,"data_*sec"))
			variable starti = strsearch(wname,"_",Inf,1)+1
			variable stopi = strsearch(wname,"sec",Inf,1)-1
			wlist += wname[starti,stopi]+";"
		endif
		index += 1
	while(1)
	//print wlist, itemsinlist(wlist)
	return SortList(wlist)
End

Function plot_avg_dist_from_marquee(withEditWin)
	variable withEditWin
	GetMarquee/K/Z left, bottom

	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	print V_flag, V_left, V_right, V_top, V_bottom
	variable left = V_left
	variable right = V_right
	//string graphname = S_marqueeWin
	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	print wlist
	variable i,j
	string dfolder
	
	// ---- old stuff ----//
	//string wname=wlist[0][1]
	//variable index = strsearch(wlist[0][1],":",Inf,1)
	//print index
	//folder = wlist[0][1]
	//print folder[0,index]
	//print folder

	//for (i=0; i<dimsize(wlist,0); i+=1)
	
	// find waves by name
	variable dwi, dpi
	dwi = -1
	dpi = -1
	for (i=0; i<dimsize(wlist,0); i+=1)
		variable jj
		for (jj=0; jj<dimsize(wlist,1); jj+=1)
			print i, jj, wlist[i][jj]
		endfor
		string s = wlist[i][1]
		variable res = strsearch(s,"dlog",2)
		//print i, s, res
		if (res >= 0)
			dwi = i

			if (withEditWin)
				// if strsearch(s,"dN",2) // look to see if dN, dS, dV, dM  diams? how far should we take this
				// set current moment for saving fit params
				sizing_init_ADE_fit_params()
				SVAR curr_mom = $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":" + sizing_gui_ADE_fp_folder + ":current_moment")
				NVAR save_params = $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":" + sizing_gui_ADE_fp_folder + ":save_params")
	
				save_params=0
				variable moment = strsearch(s,"dNdlogDp",2)
				if (moment >= 0)
					curr_mom = "dNdlogDp"
					save_params= 1
				endif
	
				moment = strsearch(s,"dSdlogDp",2)
				if (moment >= 0)
					curr_mom = "dSdlogDp"
					save_params= 1
				endif
												
				moment = strsearch(s,"dVdlogDp",2)
				if (moment >= 0)
					curr_mom = "dVdlogDp"
					save_params= 1
				endif
												
				moment = strsearch(s,"dMdlogDp",2)
				if (moment >= 0)
					curr_mom = "dMdlogDp"
					save_params= 1
				endif
				
				if ( !waveExists($(curr_mom +"_fp")) )
					wave tmp = $(wlist[dwi][1])
					make/n=(dimsize(tmp,0),4) $(curr_mom + "_fp")
					wave fp = $(curr_mom + "_fp")
					fp = NaN
				endif
			endif
											
		endif
		res = strsearch(s,"_dp",2)
		//print i, s, res
		if (res >= 0)
			dpi = i
		endif
	endfor
	print "dwi = ", dwi, " 	dpi = ", dpi
	if (dpi < 0 || dwi < 0)
		print "Can't find proper waves to plot"
		return 0
	endif
	print "Plotting: 	dw = ", wlist[dwi][1]
	print "			dp = ", wlist[dpi][1]
	
	string dw_name = wlist[dwi][1]
	dw_name = replacestring(" ",dw_name,"")
//	wave dw = $(wlist[dwi][1])  // dWdlogDp matrix
	wave dw = $(dw_name)  // dWdlogDp matrix
//	wave t = $(wlist[dpi][1])     // datetime wave
	variable idx = strsearch(wlist[dpi][1],"_",Inf,1)
	string dpname = wlist[dpi][1]
	//print "dpname = " , dpname[0,idx-1]
	wave d = $(dpname[0,idx-1])    // diameter wave
	// get datafolder for avg plot data
	print wlist[dwi][1]
	dfolder = getwavesdatafolder(dw,1)
	string sdf = getdatafolder(1)
	setdatafolder dfolder

	newdatafolder/o/s plots
	newdatafolder/o/s averages

	// for now...all average data in one folder
	variable starti, stopi
//	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
//	starti = V_value>-1 ? V_value : 0
//	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
//	stopi = V_value>-1 ? V_value : numpnts(t)-1
//	print starti, stopi		
	//starti = round(x2pnt(dw,V_left))
	starti = round(x2pnt(dw,left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti > dimsize(dw,0)) ? dimsize(dw,0) : starti
	//stopi = round(x2pnt(dw,V_right))
	stopi = round(x2pnt(dw,right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi > dimsize(dw,0)) ? dimsize(dw,0) : stopi
	print starti, stopi	
	
	make/o/n=(numpnts(d))/D dWdlogDp
	dWdlogDp = NaN
	duplicate/o d dp

	if (withEditWin)
		// create subset 2d wave for "Edit Average Distribution" window
		make/o/n=(stopi-starti+1,dimsize(dw,1)) root:gui:ADE:editAvgDist_w
		wave editAvg = root:gui:ADE:editAvgDist_w
		editAvg = dw[p+starti][q]
		SetScale/I x pnt2x(dw,starti),pnt2x(dw,stopi),"dat", editAvg

		duplicate/o d root:gui:ADE:editDp_w
	
		nvar startIndex = root:gui:ADE:avg_start_index
		startIndex = starti
		nvar stopIndex = root:gui:ADE:avg_stop_index
		stopIndex = stopi
		nvar currentIndex = root:gui:ADE:avg_current_index
		currentIndex = starti		
		
		sizing_single_from_avg()
		
		Execute "sizing_EditAvgDist()"
		
	endif
	
	variable avg, cnt
	for (j=0;j<dimsize(dw,1); j+=1)

		avg=0
		cnt=0
		for (i=starti; i<=stopi; i+=1)
			if (numtype(dw[i][j]) == 0)
				avg+=dw[i][j]
				cnt+=1
			endif
		endfor
		dWdlogDp[j] = avg / cnt
	endfor	

	Display dWdlogDp vs dp
	ModifyGraph log(bottom)=1;DelayUpdate
	Label left "dW / dlogD\\Bp\\M";DelayUpdate
	Label bottom "D\\Bp\\M (nm)"


	setdatafolder sdf
	//endfor		
End


Function smps_ChangeDensityProc(ctrlName) : ButtonControl
	String ctrlName

	//print ctrlName
	if (cmpstr(ctrlName,"done_button") == 0)
		NVAR tmprho = $(smps_parameter_folder+":tmp_density")
		NVAR rho = $(smps_parameter_folder+":density")
		if (tmprho != rho)
			rho = tmprho
			//smps_reprocess_all_data()
			sizing_reprocess_all_data("smps")
		endif
		killwindow smps_density_panel
	
	elseif (cmpstr(ctrlName,"apply_button") == 0)
		NVAR tmprho = $(smps_parameter_folder+":tmp_density")
		NVAR rho = $(smps_parameter_folder+":density")
		if (tmprho != rho)
			rho = tmprho
			sizing_reprocess_all_data("smps")
		endif
	elseif (cmpstr(ctrlName,"cancel_button") == 0)
		killwindow smps_density_panel
	endif 	
End

Function dmps_ChangeDensityProc(ctrlName) : ButtonControl
	String ctrlName

	variable recalc = 0

	//print ctrlName
	if (cmpstr(ctrlName,"done_button") == 0)
		NVAR tmprho = $(dmps_parameter_folder+":tmp_density")
		NVAR rho = $(dmps_parameter_folder+":density")
		NVAR aps_rho = $(aps_parameter_folder+":density")
		
		if (datafolderexists(dmps_aps_parameter_folder))
		
			NVAR dmps_aps_density = root:dmps_aps:parameter:density
			NVAR dmps_aps_tmp_density = root:dmps_aps:parameter:tmp_density
			dmps_aps_density = aps_rho
			dmps_aps_tmp_density = aps_rho
		endif
		
		if (tmprho != rho)
			rho = tmprho
			//smps_reprocess_all_data()
			sizing_reprocess_all_data("dmps")
			aps_rho = tmprho
			sizing_reprocess_all_data("aps")
			recalc = 1
		endif
		
		if (datafolderexists(dmps_aps_parameter_folder))
		
			NVAR dmps_aps_rho = root:dmps_aps:parameter:density
			NVAR dmps_aps_tmp_rho = root:dmps_aps:parameter:tmp_density
			dmps_aps_rho= aps_rho
			dmps_aps_tmp_rho = aps_rho
			if (recalc)
				sizing_reprocess_all_data("dmps_aps")
			endif
		endif
		
		killwindow dmps_density_panel
	
	elseif (cmpstr(ctrlName,"apply_button") == 0)
		NVAR tmprho = $(dmps_parameter_folder+":tmp_density")
		NVAR rho = $(dmps_parameter_folder+":density")
		NVAR aps_rho = $(aps_parameter_folder+":density")
		
		if (tmprho != rho)
			rho = tmprho
			sizing_reprocess_all_data("dmps")
			aps_rho = tmprho
			sizing_reprocess_all_data("aps")
			recalc = 1
		endif

		if (datafolderexists(dmps_aps_parameter_folder))
		
			NVAR dmps_aps_rho = root:dmps_aps:parameter:density
			NVAR dmps_aps_tmp_rho = root:dmps_aps:parameter:tmp_density
			dmps_aps_rho= aps_rho
			dmps_aps_tmp_rho = aps_rho
			if (recalc)
				sizing_reprocess_all_data("dmps_aps")
			endif
		endif

	elseif (cmpstr(ctrlName,"cancel_button") == 0)
		killwindow dmps_density_panel
	endif 	
End

Function smps_toggle_nans_from_marquee(allPoints,isNaN)
	variable allPoints
	variable isNaN  // 0 = reset, 1 =NaN
	// also nan's the aps

	GetMarquee/K/Z left, bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist
	
	variable i,j
	string dfolder
	
	wave dw = $(wlist[0][1])  // dWdlogDp matrix
	wave t = $(wlist[1][1])     // datetime wave
	variable idx = strsearch(wlist[2][1],"_",Inf,1)
	string dpname = wlist[2][1]
	//print "dpname = " , dpname[0,idx-1]
	wave d = $(dpname[0,idx-1])    // diameter wave
	
	// get datafolder for avg plot data
	dfolder = getwavesdatafolder($wlist[i][1],1)
	string sdf = getdatafolder(1)
	setdatafolder dfolder

	// for now...all average data in one folder
	variable starti, stopi, startyi, stopyi
	//FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
	//starti = V_value>-1 ? V_value : 0
	//FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
	//stopi = V_value>-1 ? V_value : numpnts(t)-1
	//print starti, stopi		
	print x2pnt(dw,V_left), x2pnt(dw,V_right)
	starti = round(x2pnt(dw,left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti > dimsize(dw,0)) ? dimsize(dw,0) : starti
	stopi = round(x2pnt(dw,right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi > dimsize(dw,0)) ? dimsize(dw,0) : stopi
	print starti, stopi	
	
	wave user_nan = smps_user_nan
	if (!allPoints) 
//		startyi = round( (V_bottom - DimOffset(dw, 1))/DimDelta(dw,1) )
//		startyi = (startyi < 0)  ? 0 : startyi
//		stopyi = round( (V_top - DimOffset(dw, 1))/DimDelta(dw,1) )
//		startyi = (stopyi > dimsize(dw,1)) ? dimsize(dw,1) : stopyi
		
		startyi = BinarySearch(d,bottom)
		startyi = (startyi < 0 || startyi == -1)  ? 0 : startyi
		stopyi = BinarySearch(d,top)
		stopyi = (stopyi > dimsize(dw,1) || stopyi == -2) ? dimsize(dw,1) : stopyi
	
		print V_bottom, V_top, startyi, stopyi
		user_nan[starti,stopi][startyi,stopyi] = isNaN
	else
		user_nan[starti,stopi] = isNaN
	endif
	
	variable tb
	variable levels = itemsinlist(dfolder,":")
	string datafolder = stringfromlist(levels-1,dfolder,":")
	sscanf datafolder,"data_%dsec",tb

	smps_clean_user_times(tb)
	//wsoc_process_data()	
	//sizing_reprocess_data("smps",tb,0)
	sizing_reprocess_inst_data("smps",tb)
	setdatafolder sdf
End

Function smps_nan_selection_from_marquee()

	GetMarquee/K/Z left, bottom
	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist
	
	variable i,j
	string dfolder
	
	wave dw = $(wlist[0][1])  // dWdlogDp matrix
	wave t = $(wlist[1][1])     // datetime wave
	variable idx = strsearch(wlist[2][1],"_",Inf,1)
	string dpname = wlist[2][1]
	//print "dpname = " , dpname[0,idx-1]
	wave d = $(dpname[0,idx-1])    // diameter wave
	
	// get datafolder for avg plot data
	dfolder = getwavesdatafolder($wlist[i][1],1)
	string sdf = getdatafolder(1)
	setdatafolder dfolder

	// for now...all average data in one folder
	variable starti, stopi
	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
	starti = V_value>-1 ? V_value : 0
	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
	stopi = V_value>-1 ? V_value : numpnts(t)-1
	print starti, stopi		

	wave user_nan = smps_user_nan
	user_nan[starti,stopi] = 1
	
	variable tb
	variable levels = itemsinlist(dfolder,":")
	string datafolder = stringfromlist(levels-1,dfolder,":")
	sscanf datafolder,"data_%dsec",tb

	smps_clean_user_times(tb)
	//wsoc_process_data()	
	//sizing_reprocess_data("smps",tb,0)
	sizing_reprocess_inst_data("smps",tb)
	setdatafolder sdf
End

Function smps_reset_sel_from_marquee()

	GetMarquee/K/Z left, bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist
	
	variable i,j
	string dfolder
	
	wave dw = $(wlist[0][1])  // dWdlogDp matrix
	wave t = $(wlist[1][1])     // datetime wave
	variable idx = strsearch(wlist[2][1],"_",Inf,1)
	string dpname = wlist[2][1]
	//print "dpname = " , dpname[0,idx-1]
	wave d = $(dpname[0,idx-1])    // diameter wave
	
	// get datafolder for avg plot data
	dfolder = getwavesdatafolder($wlist[i][1],1)
	string sdf = getdatafolder(1)
	setdatafolder dfolder

	// for now...all average data in one folder
	variable starti, stopi
	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
	starti = V_value>-1 ? V_value : 0
	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
	stopi = V_value>-1 ? V_value : numpnts(t)-1
	print starti, stopi		

	wave user_nan = smps_user_nan
	user_nan[starti,stopi] = 0

	variable tb
	variable levels = itemsinlist(dfolder,":")
	string datafolder = stringfromlist(levels-1,dfolder,":")
	sscanf datafolder,"data_%dsec",tb

	smps_clean_user_times(tb)
	//sizing_reprocess_data("smps",tb,0)
	sizing_reprocess_inst_data("smps",tb)
	
	setdatafolder sdf
End

Function aps_toggle_user_nan_region(tb,starti, stopi, isNaN)
	variable tb
	variable starti, stopi
	variable isNaN
	wave user_nan =$("root:aps:data_"+num2str(tb)+"sec:aps_user_nan")
	user_nan[starti,stopi] = isNaN
	aps_clean_user_times(tb)
	//sizing_reprocess_data("aps",tb,0)
	sizing_reprocess_inst_data("aps",tb)
End

Function dmps_toggle_user_nan_region(tb,starti, stopi, isNaN)
	variable tb
	variable starti, stopi
	variable isNaN
	wave user_nan =$("root:dmps:data_"+num2str(tb)+"sec:dmps_user_nan")
	user_nan[starti,stopi] = isNaN
	dmps_clean_user_times(tb)
	//sizing_reprocess_data("dmps",tb,0)
	sizing_reprocess_inst_data("dmps",tb)
End

Function aps_sync_user_nans(tb)
	variable tb
	wave dmps_nans =$("root:dmps:data_"+num2str(tb)+"sec:dmps_user_nan")
	wave aps_nans =$("root:aps:data_"+num2str(tb)+"sec:aps_user_nan")
	aps_nans = dmps_nans
	aps_clean_user_times(tb)
	//wsoc_process_data()	
	//sizing_reprocess_data("aps",tb,0)
	sizing_reprocess_inst_data("aps",tb)
	
End

Function dmps_sync_user_nans(tb)
	variable tb
	wave dmps_nans =$("root:dmps:data_"+num2str(tb)+"sec:dmps_user_nan")
	wave aps_nans =$("root:aps:data_"+num2str(tb)+"sec:aps_user_nan")
	dmps_nans = aps_nans
	dmps_clean_user_times(tb)
	//wsoc_process_data()	
	//sizing_reprocess_data("dmps",tb,0)
	sizing_reprocess_inst_data("dmps",tb)
	
End


Function dmps_toggle_nans_from_marquee(allPoints,isNaN)
	variable allPoints
	variable isNaN  // 0 = reset, 1 =NaN
	// also nan's the aps

	GetMarquee/K/Z left, bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist
	
	variable i,j
	string dfolder
	
	wave dw = $(wlist[0][1])  // dWdlogDp matrix
	wave t = $(wlist[1][1])     // datetime wave
	variable idx = strsearch(wlist[2][1],"_",Inf,1)
	string dpname = wlist[2][1]
	//print "dpname = " , dpname[0,idx-1]
	wave d = $(dpname[0,idx-1])    // diameter wave
	
	// get datafolder for avg plot data
	dfolder = getwavesdatafolder($wlist[i][1],1)
	string sdf = getdatafolder(1)
	setdatafolder dfolder

	// for now...all average data in one folder
	variable starti, stopi, startyi, stopyi
	//FindValue/T=(dmps_defaultTimeBase/2)/V=(V_left) t
	//starti = V_value>-1 ? V_value : 0
	//FindValue/T=(dmps_defaultTimeBase/2)/V=(V_right) t
	//stopi = V_value>-1 ? V_value : numpnts(t)-1
	//print starti, stopi		
	//print x2pnt(dw,V_left), x2pnt(dw,V_right)
	starti = round(x2pnt(dw,left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti > dimsize(dw,0)) ? dimsize(dw,0) : starti
	stopi = round(x2pnt(dw,right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi > dimsize(dw,0)) ? dimsize(dw,0) : stopi
	print starti, stopi	
	
	wave user_nan = dmps_user_nan
	if (!allPoints) 
//		startyi = round( (V_bottom - DimOffset(dw, 1))/DimDelta(dw,1) )
//		startyi = (startyi < 0)  ? 0 : startyi
//		stopyi = round( (V_top - DimOffset(dw, 1))/DimDelta(dw,1) )
//		startyi = (stopyi > dimsize(dw,1)) ? dimsize(dw,1) : stopyi
		
		startyi = BinarySearch(d,bottom)
		startyi = (startyi < 0 || startyi == -1)  ? 0 : startyi
		stopyi = BinarySearch(d,top)
		stopyi = (stopyi > dimsize(dw,1) || stopyi == -2) ? dimsize(dw,1) : stopyi
	
		print startyi, stopyi
		user_nan[starti,stopi][startyi,stopyi] = isNaN
	else
		user_nan[starti,stopi] = isNaN
	endif
	
	variable tb
	variable levels = itemsinlist(dfolder,":")
	string datafolder = stringfromlist(levels-1,dfolder,":")
	sscanf datafolder,"data_%dsec",tb

	dmps_clean_user_times(tb)
	//wsoc_process_data()	
	//sizing_reprocess_data("dmps",tb,0)
	sizing_reprocess_inst_data("dmps",tb)
	if (allPoints)
		//aps_sync_user_nans(tb)
		aps_toggle_user_nan_region(tb,starti, stopi, isNaN)
	endif
	setdatafolder sdf
End

Function aps_toggle_nans_from_marquee(allPoints,isNaN)
	variable allPoints
	variable isNaN  // 0 = reset, 1 =NaN
	// also nan's the aps

	GetMarquee/K/Z left, bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	//print wlist
	
	variable i,j
	string dfolder
	
	wave dw = $(wlist[0][1])  // dWdlogDp matrix
	wave t = $(wlist[1][1])     // datetime wave
	variable idx = strsearch(wlist[2][1],"_",Inf,1)
	string dpname = wlist[2][1]
	//print "dpname = " , dpname[0,idx-1]
	wave d = $(dpname[0,idx-1])    // diameter wave
	
	// get datafolder for avg plot data
	dfolder = getwavesdatafolder($wlist[i][1],1)
	string sdf = getdatafolder(1)
	setdatafolder dfolder

	// for now...all average data in one folder
	variable starti, stopi, startyi, stopyi
//	FindValue/T=(aps_defaultTimeBase/2)/V=(V_left) t
//	starti = V_value>-1 ? V_value : 0
//	FindValue/T=(aps_defaultTimeBase/2)/V=(V_right) t
//	stopi = V_value>-1 ? V_value : numpnts(t)-1
//	print starti, stopi		
	starti = round(x2pnt(dw,left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti > dimsize(dw,0)) ? dimsize(dw,0) : starti
	stopi = round(x2pnt(dw,right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi > dimsize(dw,0)) ? dimsize(dw,0) : stopi
	print starti, stopi	

	wave user_nan = aps_user_nan
	if (!allPoints) 
//		startyi = round( (V_bottom - DimOffset(dw, 1))/DimDelta(dw,1) )
//		startyi = (startyi < 0)  ? 0 : startyi
//		stopyi = round( (V_top - DimOffset(dw, 1))/DimDelta(dw,1) )
//		startyi = (stopyi > dimsize(dw,1)) ? dimsize(dw,1) : stopyi
		
		startyi = BinarySearch(d,bottom)
		startyi = (startyi < 0 || startyi == -1)  ? 0 : startyi
		stopyi = BinarySearch(d,top)
		stopyi = (stopyi > dimsize(dw,1) || stopyi == -2) ? dimsize(dw,1) : stopyi
	
		print startyi, stopyi
		user_nan[starti,stopi][startyi,stopyi] = isNaN
	else
		user_nan[starti,stopi] = isNaN
	endif
	
	variable tb
	variable levels = itemsinlist(dfolder,":")
	string datafolder = stringfromlist(levels-1,dfolder,":")
	sscanf datafolder,"data_%dsec",tb

	aps_clean_user_times(tb)
	//wsoc_process_data()	
	//sizing_reprocess_data("aps",tb,0)
	sizing_reprocess_inst_data("aps",tb)
	if (allPoints) 
		//dmps_sync_user_nans(tb)
		dmps_toggle_user_nan_region(tb,starti, stopi, isNaN)
	endif
	setdatafolder sdf
End




Function display_smps_change_density()
	DoWindow/F smps_density_panel
	if (V_Flag != 0)
		return 0
	endif

	init_smps_parameters()
	Execute "smps_density_panel()"
End

Function display_dmps_change_density()
	DoWindow/F dmps_density_panel
	if (V_Flag != 0)
		return 0
	endif

	init_dmps_parameters()
	Execute "dmps_density_panel()"
End

Window smps_density_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(150,80,450,277)/K=1 as "SMPS Density"
	Button done_button,pos={221,166},size={50,20},proc=smps_ChangeDensityProc,title="Done"
	Button apply_button,pos={144,166},size={68,19},proc=smps_ChangeDensityProc,title="Apply"
	Button cancel_button,pos={20,166},size={50,20},proc=smps_ChangeDensityProc,title="Cancel"
	SetVariable set_smps_density,pos={84,86},size={109,19},title="Density",fSize=14
	SetVariable set_smps_density,limits={0.8,7,0.1},value= root:smps:parameters:tmp_density,bodyWidth= 60
EndMacro

Window dmps_density_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(150,80,450,277)/K=1 as "DMPS/APS Density"
	Button done_button,pos={221,166},size={50,20},proc=dmps_ChangeDensityProc,title="Done"
	Button apply_button,pos={144,166},size={68,19},proc=dmps_ChangeDensityProc,title="Apply"
	Button cancel_button,pos={20,166},size={50,20},proc=dmps_ChangeDensityProc,title="Cancel"
	SetVariable set_dmps_density,pos={84,86},size={109,19},title="Density",fSize=14
	SetVariable set_dmps_density,limits={0.8,7,0.1},value= root:dmps:parameters:tmp_density,bodyWidth= 60
EndMacro

// ---------- START DMPS -------- //

Function load_dmps_from_AS()
	string sdf = getdatafolder(1)
	newdatafolder/O/S $sizing_tmp_data_folder
	//newdatafolder/O/S :raw

	variable/G dmps_timebase = dmps_defaultTimeBase
	variable/G aps_timebase = aps_defaultTimeBase

	set_base_path()
	PathInfo loaddata_base_path

	variable i,j,k
	
	// load meta data
	
// Load date/time
	//LoadWave/J/D/N=time/K=1/V={"\t"," $",0,0}/L={0,0,0,0,6}/p=path_to_data
	LoadWave/J/D/N=time/K=1/V={"\t"," $",0,0}/L={106,109,0,0,6}/p=loaddata_base_path
	NewPath/o/z path_to_dmps, S_path
	wave time0,time1,time2,time3,time4,time5
	string dmps_file = S_filename
	string datafoldername = stringfromlist(0,S_filename,".")
	//newdatafolder/o $("root:dmps:"+datafoldername)
	Duplicate/o time0, dmps_datetime
	wave date_time = dmps_datetime
	date_time=date2secs(time0,time1,time2) + time3*3600 + time4*60 +time5
	KillWaves time0,time1,time2,time3,time4,time5
	//setdatafolder 	$("root:dmps:"+datafoldername)
//	Duplicate/o date_time, dmps_date_time_im
//	wave date_time_im
//	insertpoints (numpnts(date_time_im)),1,date_time_im
//	date_time_im[numpnts(date_time_im)-1] = date_time_im[numpnts(date_time_im)-2] + 300

// dmps diameter wave (just read one line for entire matrix)
	//LoadWave/J/M/D/N=dmps_diam/K=1/V={"\t"," $",0,0}/L={0,0,1,13,16}/p=path_to_data filename
	LoadWave/J/M/D/N=dmps_diam/K=1/V={"\t"," $",0,0}/L={106,109,1,13,16}/p=path_to_dmps dmps_file
	wave dmps_diam0
	MatrixTranspose dmps_diam0
	redimension/n=(dimsize(dmps_diam0,0),0) dmps_diam0
	//make/o/d/n=16 diameter={0.020000,0.025580,0.032710,0.041830,0.053490,0.068400,0.087470,0.111900,0.143000,0.182900,0.233900,0.299100,0.382500,0.489200,0.625600,0.800000}
	//make/o/d/n=17 diameter_im={0.0177,0.0226,0.0289,0.0370,0.0473,0.0605,0.0773,0.0989,0.1265,0.1617,0.2068,0.2645,0.3382,0.4326,0.5532,0.7074,0.9047}
	Duplicate/o dmps_diam0, dmps_dp0 
	//wave dmps_dp
	KillWaves dmps_diam0
//	diameter_im = (diameter[p-1]*diameter[p])^0.5
//	Redimension/N=(numpnts(diameter)+1) diameter_im
//	diameter_im[0] =  diameter[0] - (diameter_im[1]-diameter[0])
//	diameter_im[numpnts(diameter_im)-1] =  diameter[numpnts(diameter)-1] + (diameter[numpnts(diameter)-1] - diameter_im[numpnts(diameter_im)-2])

// load dN/dlogDp as matrix
	//LoadWave/J/M/D/N=dmps/K=1/V={"\t"," $",0,0}/L={0,0,0,29,16}/p=path_to_data filename
	LoadWave/J/M/D/N=dmps/K=1/V={"\t"," $",0,0}/L={106,109,0,29,16}/p=path_to_dmps dmps_file
	
	// replace -999 with NaN
	wave dw_w  =dmps0
	dw_w = (dw_w[p][q] == -999) ? NaN :  dw_w[p][q]
	
// Duplicate DMPS datetime wave
	duplicate/o date_time aps_datetime
	wave date_time = aps_datetime
// Load APS diameters	
	//LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={0,0,1,45,52}/p=path_to_data filename
	LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={106,109,1,45,52}/p=path_to_dmps dmps_file
	wave aps_diam0
	MatrixTranspose aps_diam0
	redimension/n=(dimsize(aps_diam0,0),0) aps_diam0
	//make/o/d/n=16 diameter={0.020000,0.025580,0.032710,0.041830,0.053490,0.068400,0.087470,0.111900,0.143000,0.182900,0.233900,0.299100,0.382500,0.489200,0.625600,0.800000}
	//make/o/d/n=17 diameter_im={0.0177,0.0226,0.0289,0.0370,0.0473,0.0605,0.0773,0.0989,0.1265,0.1617,0.2068,0.2645,0.3382,0.4326,0.5532,0.7074,0.9047}
	Duplicate/o aps_diam0, aps_dpa0
	//wave aps_dpa  // aps --> aerodynamic diameters --> dpa
	KillWaves aps_diam0

// Load APS dN/dlogDp as matrix
	//LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={0,0,0,97,52}/p=path_to_data filename
	LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={106,109,0,97,52}/p=path_to_dmps dmps_file

	// replace -999 with NaN
	wave dw_w  =aps0
	dw_w = (dw_w[p][q] == -999) ? NaN :  dw_w[p][q] 

	KillPath/Z path_to_dmps

	string/G dmps_dataset_name
	newdatafolder/o root:dmps

	string/G aps_dataset_name
	newdatafolder/o root:aps

	// work on dmps data
	newdatafolder/o/s $dmps_datasets_folder
	sscanf dmps_file, "%[^.]dat", dmps_dataset_name
	dmps_dataset_name += "_"+num2str(dmps_timebase)
	newdatafolder/o/s $(dmps_dataset_name)
	variable/G timebase = dmps_timebase	

	wave new_dt = $(sizing_tmp_data_folder+":"+"dmps_datetime")
	wave new_dp = $(sizing_tmp_data_folder+":"+"dmps_dp0")
	wave new_dmps =  $(sizing_tmp_data_folder+":"+"dmps0")

	variable mintime, maxtime
	wavestats/Q new_dt
	mintime = V_min
	maxtime = V_max

	variable/G first_starttime=mintime - mod(mintime,dmps_timebase)
	variable/G last_starttime=maxtime - mod(maxtime,dmps_timebase) + dmps_timebase

	variable time_periods = (last_starttime-first_starttime)/(dmps_timebase) + 1

	if ((last_starttime-maxtime) > dmps_timebase)
		time_periods -= 1
	endif
	
	make/o/n=(time_periods)/d dataset_datetime
	variable cols = dimsize(new_dmps,1)
	make/o/n=(time_periods,cols)/d dmps_dNdlogDp
	
	wave ds_dmps = dmps_dNdlogDp
	ds_dmps = NaN
	duplicate/o new_dp dmps_dp
	string timebase_index = "timebase_index"
	dataset_datetime[0] = first_starttime
	dataset_datetime[1, ] = dataset_datetime[p-1]+dmps_timebase
//	for (i=0; i<time_periods; i+=1)
//		dataset_datetime[i] = dataset_datetime[i-1]+smps_timebase
//	endfor

	// put dataset on constant time base
	get_timebase_index_FindValue(dataset_datetime, new_dt, (dmps_timebase/2),timebase_index)
	wave tb_index = $timebase_index
	for (i=0; i<numpnts(tb_index); i+=1)
		for (k=0; k<dimsize(ds_dmps,1); k+=1)
			ds_dmps[(tb_index[i])][k] = new_dmps[i][k]
		endfor
	endfor
	killwaves/Z tb_index
	SetScale/P x dataset_datetime[0],dmps_timebase,"dat", dmps_dNdlogDp

	// work on aps data
	newdatafolder/o/s $aps_datasets_folder
	sscanf dmps_file, "%[^.]dat", aps_dataset_name
	aps_dataset_name += "_"+num2str(aps_timebase)
	newdatafolder/o/s $(aps_dataset_name)
	variable/G timebase = aps_timebase	

	wave new_dt = $(sizing_tmp_data_folder+":"+"aps_datetime")
	wave new_dp = $(sizing_tmp_data_folder+":"+"aps_dpa0")
	wave new_aps =  $(sizing_tmp_data_folder+":"+"aps0")

	//variable mintime, maxtime
	wavestats/Q new_dt
	mintime = V_min
	maxtime = V_max

	variable/G first_starttime=mintime - mod(mintime,aps_timebase)
	variable/G last_starttime=maxtime - mod(maxtime,aps_timebase) + aps_timebase

	time_periods = (last_starttime-first_starttime)/(aps_timebase) + 1

	if ((last_starttime-maxtime) > aps_timebase)
		time_periods -= 1
	endif
	
	make/o/n=(time_periods)/d dataset_datetime
	cols = dimsize(new_aps,1)
	make/o/n=(time_periods,cols)/d aps_dNdlogDp
	
	wave ds_aps = aps_dNdlogDp
	ds_aps = NaN
	duplicate/o new_dp aps_dpa
	//string timebase_index = "timebase_index"
	dataset_datetime[0] = first_starttime
	dataset_datetime[1, ] = dataset_datetime[p-1]+aps_timebase
//	for (i=0; i<time_periods; i+=1)
//		dataset_datetime[i] = dataset_datetime[i-1]+smps_timebase
//	endfor

	// put dataset on constant time base
	get_timebase_index_FindValue(dataset_datetime, new_dt, (aps_timebase/2),timebase_index)
	wave tb_index = $timebase_index
	for (i=0; i<numpnts(tb_index); i+=1)
		for (k=0; k<dimsize(ds_aps,1); k+=1)
			ds_aps[(tb_index[i])][k] = new_aps[i][k]
		endfor
	endfor
	killwaves/Z tb_index
	SetScale/P x dataset_datetime[0],aps_timebase,"dat", aps_dNdlogDp

	// insert new dataset into main data
	dmps_concatenate_datasets(dmps_timebase)
	aps_concatenate_datasets(aps_timebase)

	// clean user selected values
	dmps_clean_user_times(dmps_timebase)
	aps_clean_user_times(aps_timebase)
		
	// add extra parameters for convenience
	add_aero_diams("dmps",dmps_timebase,0)
	convert_NtoSVM("dmps",dmps_timebase,0)
	integrate_NSVM("dmps",dmps_timebase,0)	
	create_im_plot_params("dmps",dmps_timebase,0)
	
	add_aero_diams("aps",dmps_timebase,0)
	convert_NtoSVM("aps",dmps_timebase,0)
	integrate_NSVM("aps",dmps_timebase,0)	
	create_im_plot_params("aps",dmps_timebase,0)
	
	setdatafolder sdf
	killdatafolder $sizing_tmp_data_folder

// -----------------------end------------------------
	
////	duplicate/o dmps0,dmps_Nmatrix,dmps_Smatrix,dmps_Vmatrix
////	wave dmps_Nmatrix,dmps_Smatrix,dmps_Vmatrix
////	Killwaves dmps0
////	dmps_Smatrix = pi*diameter[q]^2*dmps_Nmatrix[p][q]	
////	dmps_Vmatrix = pi/6*diameter[q]^3*dmps_Nmatrix[p][q]	
//
//	newdatafolder/o/s $("root:aps:"+datafoldername)
//// Copy date/time to aps folder
//	Duplicate/o date_time,$("root:aps:"+datafoldername+":date_time")
//	// since we are not using this, we don't need to declare it
//	//wave aps_date_time = $("root:aps:"+datafoldername+":date_time")
//	Duplicate/o date_time_im,$("root:aps:"+datafoldername+":date_time_im")
//	//wave aps_date_time_im = $("root:aps:"+datafoldername+":date_time_im")
//
//// Load APS diameters	
//	//LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={0,0,1,45,52}/p=path_to_data filename
//	LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={106,109,1,45,52}/p=path_to_data filename
//	wave aps_diam0
//	MatrixTranspose aps_diam0
//	redimension/n=(dimsize(aps_diam0,0),0) aps_diam0
//	Duplicate/o aps_diam0, adiameter,adiameter_im,geo_adiameter,geo_adiameter_im
//	KillWaves aps_diam0
//	wave adiameter,adiameter_im,geo_adiameter,geo_adiameter_im
//	geo_adiameter=adiameter/sqrt(density)
//	adiameter_im = (adiameter[p-1]*adiameter[p])^0.5
//	geo_adiameter_im = (geo_adiameter[p-1]*geo_adiameter[p])^0.5
//	Redimension/N=(numpnts(adiameter)+1) adiameter_im
//	Redimension/N=(numpnts(geo_adiameter)+1) geo_adiameter_im
//	adiameter_im[0] =  adiameter[0] - (adiameter_im[1]-adiameter[0])
//	adiameter_im[numpnts(adiameter_im)-1] =  adiameter[numpnts(adiameter)-1] + (adiameter[numpnts(adiameter)-1] - adiameter_im[numpnts(adiameter_im)-2])
//	geo_adiameter_im[0] =  geo_adiameter[0] - (geo_adiameter_im[1]-geo_adiameter[0])
//	geo_adiameter_im[numpnts(geo_adiameter_im)-1] =  geo_adiameter[numpnts(geo_adiameter)-1] + (geo_adiameter[numpnts(geo_adiameter)-1] - geo_adiameter_im[numpnts(geo_adiameter_im)-2])
//
//// Load APS N,S,V matrices
//	//LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={0,0,0,97,52}/p=path_to_data filename
//	LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={106,109,0,97,52}/p=path_to_data filename
//	wave aps0
//	Duplicate/o aps0,aps_Nmatrix,aps_Smatrix,aps_Vmatrix 
//	Killwaves aps0
//	wave aps_Nmatrix,aps_Smatrix,aps_Vmatrix 
//	aps_Smatrix = pi*adiameter[q]^2*aps_Nmatrix[p][q]	
//	aps_Vmatrix = pi/6*adiameter[q]^3*aps_Nmatrix[p][q]	
//
//	setdatafolder sdf
//// old stuff
//	//duplicate/o diameter,diameter_im
//	//redimension/n=17 diameter_im
//	//diameter_im[16] = .85
//	
end


/// For Uintah
Function load_dmps_from_Uintah()
	string sdf = getdatafolder(1)
	newdatafolder/O/S $sizing_tmp_data_folder
	//newdatafolder/O/S :raw

	//variable/G dmps_timebase = dmps_defaultTimeBase
	variable/G aps_timebase = aps_defaultTimeBase

	set_base_path()
	PathInfo loaddata_base_path

	variable i,j,k
	
	// load meta data
	
// Load date/time
	//LoadWave/J/D/N=time/K=1/V={"\t"," $",0,0}/L={0,0,0,0,6}/p=path_to_data
	LoadWave/J/D/N=time/K=1/V={"\t"," $",0,0}/L={0,1,0,0,1}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/p=loaddata_base_path
	NewPath/o/z path_to_dmps, S_path
	wave time0
	string dmps_file = S_filename
	string datafoldername = stringfromlist(0,S_filename,".")
	//newdatafolder/o $("root:dmps:"+datafoldername)
	Duplicate/o time0, aps_datetime
	wave date_time = aps_datetime
	//date_time=date2secs(time0,time1,time2) + time3*3600 + time4*60 +time5
	KillWaves time0
	//setdatafolder 	$("root:dmps:"+datafoldername)
//	Duplicate/o date_time, dmps_date_time_im
//	wave date_time_im
//	insertpoints (numpnts(date_time_im)),1,date_time_im
//	date_time_im[numpnts(date_time_im)-1] = date_time_im[numpnts(date_time_im)-2] + 300

//// dmps diameter wave (just read one line for entire matrix)
//	//LoadWave/J/M/D/N=dmps_diam/K=1/V={"\t"," $",0,0}/L={0,0,1,13,16}/p=path_to_data filename
//	LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={106,109,1,13,16}/p=path_to_dmps dmps_file
//	wave dmps_diam0
//	MatrixTranspose dmps_diam0
//	redimension/n=(dimsize(dmps_diam0,0),0) dmps_diam0
//	//make/o/d/n=16 diameter={0.020000,0.025580,0.032710,0.041830,0.053490,0.068400,0.087470,0.111900,0.143000,0.182900,0.233900,0.299100,0.382500,0.489200,0.625600,0.800000}
//	//make/o/d/n=17 diameter_im={0.0177,0.0226,0.0289,0.0370,0.0473,0.0605,0.0773,0.0989,0.1265,0.1617,0.2068,0.2645,0.3382,0.4326,0.5532,0.7074,0.9047}
//	Duplicate/o dmps_diam0, dmps_dp0 
//	//wave dmps_dp
//	KillWaves dmps_diam0
////	diameter_im = (diameter[p-1]*diameter[p])^0.5
////	Redimension/N=(numpnts(diameter)+1) diameter_im
////	diameter_im[0] =  diameter[0] - (diameter_im[1]-diameter[0])
////	diameter_im[numpnts(diameter_im)-1] =  diameter[numpnts(diameter)-1] + (diameter[numpnts(diameter)-1] - diameter_im[numpnts(diameter_im)-2])
//
//// load dN/dlogDp as matrix
//	//LoadWave/J/M/D/N=dmps/K=1/V={"\t"," $",0,0}/L={0,0,0,29,16}/p=path_to_data filename
//	LoadWave/J/M/D/N=dmps/K=1/V={"\t"," $",0,0}/L={106,109,0,29,16}/p=path_to_dmps dmps_file
//	
//	// replace -999 with NaN
//	wave dw_w  =dmps0
//	dw_w = (dw_w[p][q] == -999) ? NaN :  dw_w[p][q]
//	
//// Duplicate DMPS datetime wave
//	duplicate/o date_time aps_datetime
//	wave date_time = aps_datetime
// Load APS diameters	
	//LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={0,0,1,45,52}/p=path_to_data filename
	LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={0,1,1,1,52}/p=path_to_dmps dmps_file
	wave aps_diam0
	MatrixTranspose aps_diam0
	redimension/n=(dimsize(aps_diam0,0),0) aps_diam0
	//make/o/d/n=16 diameter={0.020000,0.025580,0.032710,0.041830,0.053490,0.068400,0.087470,0.111900,0.143000,0.182900,0.233900,0.299100,0.382500,0.489200,0.625600,0.800000}
	//make/o/d/n=17 diameter_im={0.0177,0.0226,0.0289,0.0370,0.0473,0.0605,0.0773,0.0989,0.1265,0.1617,0.2068,0.2645,0.3382,0.4326,0.5532,0.7074,0.9047}
	Duplicate/o aps_diam0, aps_dpa0
	//wave aps_dpa  // aps --> aerodynamic diameters --> dpa
	KillWaves aps_diam0

// Load APS dN/dlogDp as matrix
	//LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={0,0,0,97,52}/p=path_to_data filename
	LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={0,1,0,53,52}/p=path_to_dmps dmps_file

	// replace -999 with NaN
	wave dw_w  =aps0
	dw_w = (dw_w[p][q] == -999) ? NaN :  dw_w[p][q] 

	KillPath/Z path_to_dmps

//	string/G dmps_dataset_name
//	newdatafolder/o root:dmps

	string/G aps_dataset_name
	newdatafolder/o root:aps

//	// work on dmps data
//	newdatafolder/o/s $dmps_datasets_folder
//	sscanf dmps_file, "%[^.]dat", dmps_dataset_name
//	dmps_dataset_name += "_"+num2str(dmps_timebase)
//	newdatafolder/o/s $(dmps_dataset_name)
//	variable/G timebase = dmps_timebase	
//
//	wave new_dt = $(sizing_tmp_data_folder+":"+"dmps_datetime")
//	wave new_dp = $(sizing_tmp_data_folder+":"+"dmps_dp0")
//	wave new_dmps =  $(sizing_tmp_data_folder+":"+"dmps0")
//
	variable mintime, maxtime
//	wavestats/Q new_dt
//	mintime = V_min
//	maxtime = V_max
//
//	variable/G first_starttime=mintime - mod(mintime,dmps_timebase)
//	variable/G last_starttime=maxtime - mod(maxtime,dmps_timebase) + dmps_timebase
//
//	variable time_periods = (last_starttime-first_starttime)/(dmps_timebase) + 1
//
//	if ((last_starttime-maxtime) > dmps_timebase)
//		time_periods -= 1
//	endif
//	
//	make/o/n=(time_periods)/d dataset_datetime
//	variable cols = dimsize(new_dmps,1)
//	make/o/n=(time_periods,cols)/d dmps_dNdlogDp
//	
//	wave ds_dmps = dmps_dNdlogDp
//	ds_dmps = NaN
//	duplicate/o new_dp dmps_dp
	string timebase_index = "timebase_index"
//	dataset_datetime[0] = first_starttime
//	dataset_datetime[1, ] = dataset_datetime[p-1]+dmps_timebase
////	for (i=0; i<time_periods; i+=1)
////		dataset_datetime[i] = dataset_datetime[i-1]+smps_timebase
////	endfor
//
//	// put dataset on constant time base
//	get_timebase_index_FindValue(dataset_datetime, new_dt, (dmps_timebase/2),timebase_index)
//	wave tb_index = $timebase_index
//	for (i=0; i<numpnts(tb_index); i+=1)
//		for (k=0; k<dimsize(ds_dmps,1); k+=1)
//			ds_dmps[(tb_index[i])][k] = new_dmps[i][k]
//		endfor
//	endfor
//	killwaves/Z tb_index
//	SetScale/P x dataset_datetime[0],dmps_timebase,"dat", dmps_dNdlogDp

	// work on aps data
	newdatafolder/o/s $aps_datasets_folder
	sscanf dmps_file, "%[^.]dat", aps_dataset_name
	aps_dataset_name += "_"+num2str(aps_timebase)
	newdatafolder/o/s $(aps_dataset_name)
	variable/G timebase = aps_timebase	

	wave new_dt = $(sizing_tmp_data_folder+":"+"aps_datetime")
	wave new_dp = $(sizing_tmp_data_folder+":"+"aps_dpa0")
	wave new_aps =  $(sizing_tmp_data_folder+":"+"aps0")

	//variable mintime, maxtime
	wavestats/Q new_dt
	mintime = V_min
	maxtime = V_max

	variable/G first_starttime=mintime - mod(mintime,aps_timebase)
	variable/G last_starttime=maxtime - mod(maxtime,aps_timebase) + aps_timebase

	variable time_periods = (last_starttime-first_starttime)/(aps_timebase) + 1

	if ((last_starttime-maxtime) > aps_timebase)
		time_periods -= 1
	endif
	
	make/o/n=(time_periods)/d dataset_datetime
	variable cols = dimsize(new_aps,1)
	make/o/n=(time_periods,cols)/d aps_dNdlogDp
	
	wave ds_aps = aps_dNdlogDp
	ds_aps = NaN
	duplicate/o new_dp aps_dpa
	//string timebase_index = "timebase_index"
	dataset_datetime[0] = first_starttime
	dataset_datetime[1, ] = dataset_datetime[p-1]+aps_timebase
//	for (i=0; i<time_periods; i+=1)
//		dataset_datetime[i] = dataset_datetime[i-1]+smps_timebase
//	endfor

	// put dataset on constant time base
	get_timebase_index_FindValue(dataset_datetime, new_dt, (aps_timebase/2),timebase_index)
	wave tb_index = $timebase_index
	for (i=0; i<numpnts(tb_index); i+=1)
		for (k=0; k<dimsize(ds_aps,1); k+=1)
			ds_aps[(tb_index[i])][k] = new_aps[i][k]
		endfor
	endfor
	killwaves/Z tb_index
	SetScale/P x dataset_datetime[0],aps_timebase,"dat", aps_dNdlogDp

	// insert new dataset into main data
//	dmps_concatenate_datasets(dmps_timebase)
	aps_concatenate_datasets(aps_timebase)

	// clean user selected values
//	dmps_clean_user_times(dmps_timebase)
	aps_clean_user_times(aps_timebase)
		
	// add extra parameters for convenience
//	add_aero_diams("dmps",dmps_timebase,0)
//	convert_NtoSVM("dmps",dmps_timebase,0)
//	integrate_NSVM("dmps",dmps_timebase,0)	
//	create_im_plot_params("dmps",dmps_timebase,0)
	
	add_aero_diams("aps",aps_timebase,0)
	convert_NtoSVM("aps",aps_timebase,0)
	integrate_NSVM("aps",aps_timebase,0)	
	create_im_plot_params("aps",aps_timebase,0)
	
	setdatafolder sdf
	killdatafolder $sizing_tmp_data_folder

// -----------------------end------------------------
	
////	duplicate/o dmps0,dmps_Nmatrix,dmps_Smatrix,dmps_Vmatrix
////	wave dmps_Nmatrix,dmps_Smatrix,dmps_Vmatrix
////	Killwaves dmps0
////	dmps_Smatrix = pi*diameter[q]^2*dmps_Nmatrix[p][q]	
////	dmps_Vmatrix = pi/6*diameter[q]^3*dmps_Nmatrix[p][q]	
//
//	newdatafolder/o/s $("root:aps:"+datafoldername)
//// Copy date/time to aps folder
//	Duplicate/o date_time,$("root:aps:"+datafoldername+":date_time")
//	// since we are not using this, we don't need to declare it
//	//wave aps_date_time = $("root:aps:"+datafoldername+":date_time")
//	Duplicate/o date_time_im,$("root:aps:"+datafoldername+":date_time_im")
//	//wave aps_date_time_im = $("root:aps:"+datafoldername+":date_time_im")
//
//// Load APS diameters	
//	//LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={0,0,1,45,52}/p=path_to_data filename
//	LoadWave/J/M/D/N=aps_diam/K=1/V={"\t"," $",0,0}/L={106,109,1,45,52}/p=path_to_data filename
//	wave aps_diam0
//	MatrixTranspose aps_diam0
//	redimension/n=(dimsize(aps_diam0,0),0) aps_diam0
//	Duplicate/o aps_diam0, adiameter,adiameter_im,geo_adiameter,geo_adiameter_im
//	KillWaves aps_diam0
//	wave adiameter,adiameter_im,geo_adiameter,geo_adiameter_im
//	geo_adiameter=adiameter/sqrt(density)
//	adiameter_im = (adiameter[p-1]*adiameter[p])^0.5
//	geo_adiameter_im = (geo_adiameter[p-1]*geo_adiameter[p])^0.5
//	Redimension/N=(numpnts(adiameter)+1) adiameter_im
//	Redimension/N=(numpnts(geo_adiameter)+1) geo_adiameter_im
//	adiameter_im[0] =  adiameter[0] - (adiameter_im[1]-adiameter[0])
//	adiameter_im[numpnts(adiameter_im)-1] =  adiameter[numpnts(adiameter)-1] + (adiameter[numpnts(adiameter)-1] - adiameter_im[numpnts(adiameter_im)-2])
//	geo_adiameter_im[0] =  geo_adiameter[0] - (geo_adiameter_im[1]-geo_adiameter[0])
//	geo_adiameter_im[numpnts(geo_adiameter_im)-1] =  geo_adiameter[numpnts(geo_adiameter)-1] + (geo_adiameter[numpnts(geo_adiameter)-1] - geo_adiameter_im[numpnts(geo_adiameter_im)-2])
//
//// Load APS N,S,V matrices
//	//LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={0,0,0,97,52}/p=path_to_data filename
//	LoadWave/J/M/D/N=aps/K=1/V={"\t"," $",0,0}/L={106,109,0,97,52}/p=path_to_data filename
//	wave aps0
//	Duplicate/o aps0,aps_Nmatrix,aps_Smatrix,aps_Vmatrix 
//	Killwaves aps0
//	wave aps_Nmatrix,aps_Smatrix,aps_Vmatrix 
//	aps_Smatrix = pi*adiameter[q]^2*aps_Nmatrix[p][q]	
//	aps_Vmatrix = pi/6*adiameter[q]^3*aps_Nmatrix[p][q]	
//
//	setdatafolder sdf
//// old stuff
//	//duplicate/o diameter,diameter_im
//	//redimension/n=17 diameter_im
//	//diameter_im[16] = .85
//	
end
/// end Uintah



Function sizing_apply_flow_correction()

	variable dmps_timebase = dmps_defaultTimeBase
	variable aps_timebase = aps_defaultTimeBase

	string sdf = getdatafolder(1)
	setdatafolder root:dmps:$("data_"+num2str(dmps_timebase)+"sec")
	if (waveexists(dmps_flow_correction))
		wave w = dmps_dNdlogDp
		wave cor = dmps_flow_correction
		w *= cor
	endif

	setdatafolder root:aps:$("data_"+num2str(dmps_timebase)+"sec")
	if (waveexists(aps_flow_correction))
		wave w = aps_dNdlogDp
		wave cor = aps_flow_correction
		w *= cor
	endif
	
	
	// add extra parameters for convenience
	add_aero_diams("dmps",dmps_timebase,0)
	convert_NtoSVM("dmps",dmps_timebase,0)
	integrate_NSVM("dmps",dmps_timebase,0)	
	create_im_plot_params("dmps",dmps_timebase,0)
	
	add_aero_diams("aps",dmps_timebase,0)
	convert_NtoSVM("aps",dmps_timebase,0)
	integrate_NSVM("aps",dmps_timebase,0)	
	create_im_plot_params("aps",dmps_timebase,0)

	setdatafolder sdf
	
End


Function sizing_make_density_w(inst,rows,cols)
	string inst
	variable rows, cols

	string d_w = inst+"_density_w"
	string pf
	variable nom_dens
	if (cmpstr(inst,"dmps")==0)
		pf = dmps_parameter_folder
		nom_dens = dmps_nominalDensity
	elseif (cmpstr(inst,"aps")==0)
		pf = aps_parameter_folder
		nom_dens = aps_nominalDensity
	elseif (cmpstr(inst,"dmps_aps")==0)
		pf = dmps_aps_parameter_folder
		nom_dens = aps_nominalDensity
	elseif (cmpstr(inst,"smps")==0)
		pf = smps_parameter_folder
		nom_dens = smps_nominalDensity
	endif

	make/o/n=(rows,cols)/d $d_w			
	wave main_density = $d_w
	if (exists(pf+":density"))
		NVAR d = $(pf+":density")
		main_density = d
	else 
		main_density = nom_dens
	endif 

End

Function dmps_concatenate_datasets(tb)
	variable tb
	
	init_dmps_parameters()

	newdatafolder/o/s root:dmps:$("data_"+num2str(tb)+"sec")
	
	string dset_list = get_dataset_list("dmps")
	string tb_list=""
	variable i,j,k
	for (i=0; i<itemsinlist(dset_list); i+=1)
		NVAR ds_tb = root:dmps:datasets:$(stringfromlist(i,dset_list)):timebase
		if (ds_tb == tb)
			tb_list = AddListItem(stringfromlist(i,dset_list),tb_list,";",999)
		endif
	endfor	
	
	// copy existing waves to backup
	if (waveexists(dmps_datetime))
		duplicate/o dmps_datetime dmps_datetime_bak
	else
		killwaves/Z dmps_datetime_bak
	endif
	if (waveexists(dmps_user_nan))
		duplicate/o dmps_user_nan dmps_user_nan_bak
	else
		killwaves/Z dmps_user_nan_bak
	endif
	
	variable mintime, maxtime
	for (i=0; i<itemsinlist(tb_list); i+=1)
		wave ds_dt = root:dmps:datasets:$(stringfromlist(i,tb_list)):dataset_datetime
		wavestats/Q ds_dt
		if (i==0)		
			mintime = V_min
			maxtime = V_max
		else
			mintime = (V_min < mintime) ? V_min : mintime
			maxtime = (V_max > maxtime) ? V_max : maxtime
		endif
	endfor

	variable time_periods = (maxtime-mintime)/(tb) + 1
	make/o/n=(time_periods)/d dmps_datetime

	dmps_datetime[0] = mintime
	for (i=0; i<time_periods; i+=1)
		dmps_datetime[i] = dmps_datetime[i-1]+tb
	endfor
	
	for (i=0; i<itemsinlist(tb_list); i+=1)
		if (i==0) // use first dataset to set dp and matrix width
			duplicate/o root:dmps:datasets:$(stringfromlist(i,tb_list)):dmps_dp dmps_dp, dmps_dp_native
			wave smps = root:dmps:datasets:$(stringfromlist(i,tb_list)):dmps_dNdlogDp			
			variable cols = dimsize(smps,1)
			make/o/n=(time_periods,cols)/d dmps_dNdlogDp
			dmps_dNdlogDp=NaN
			// add a density wave (2d) 01 September 2006
//			make/o/n=(time_periods,cols)/d dmps_density_w			
			sizing_make_density_w("dmps",time_periods,cols)
			wave main_dmps_density = dmps_density_w
//			if (exists(dmps_parameter_folder+":density"))
//				NVAR d = $(dmps_parameter_folder+":density")
//				main_dmps_density = d
//			else 
//				main_dmps_density = 1.0
//			endif 
		endif
		SetScale/P x dmps_datetime[0],tb,"dat", dmps_dNdlogDp
		SetScale/P x dmps_datetime[0],tb,"dat", dmps_density_w
		
		wave main_dt = dmps_datetime
		wave main_dmps = dmps_dNdlogDp
		wave main_dmps_density = dmps_density_w
		
		wave ds_dt = root:dmps:datasets:$(stringfromlist(i,tb_list)):dataset_datetime
		wave ds_dmps = root:dmps:datasets:$(stringfromlist(i,tb_list)):dmps_dNdlogDp	

		//smps_main = (user_nan[p] ==1) ? NaN : smps_raw[p][q]

		variable starti = x2pnt(main_dmps,ds_dt[0])
		main_dmps[starti,starti+numpnts(ds_dmps)] = ds_dmps[p-starti][q]

//		string timebase_index = "timebase_index"
//		get_timebase_index(main_dt, ds_dt, 5, timebase_index)
//		wave tb_index = $timebase_index
//
//		for (j=0; j<numpnts(tb_index); j+=1)
//			for (k=0; k<dimsize(main_smps,1); k+=1)
//				if (tb_index[j] > -1)
//					main_smps[(tb_index[j])][k] = ds_smps[j][k]
//					//print i, j, k, tb_index[j], main_smps[(tb_index[j])][k], ds_smps[j][k]
//				endif
//			endfor
//		endfor
//
//		killwaves/Z tb_index		
		
		
	endfor

	// make a copy of main_smps to work from
	wave main_dt = dmps_datetime
	wave main_dmps = dmps_dNdlogDp
//	SetScale/P x main_dt[0],dmps_timebase,"dat", main_dmps
	duplicate/o main_dmps dmps_dNdlogDp_raw
	//make/o/d/n=(dimsize(main_dmps,0)) dmps_user_nan
	duplicate/o main_dmps dmps_user_nan
	wave user_nan = dmps_user_nan
	user_nan = 0
	// copy backup copy to new user_nan wave
	if (waveexists(dmps_user_nan_bak))
		print "		copying old user_selections into new working wave"
		wave user_nan_bak = dmps_user_nan_bak
		// check if old, 1D user nan		
		if (dimsize(user_nan_bak,1) == 0) // old...need to convert
			duplicate/o user_nan_bak dmps_user_nan_bak_1d
			wave user_nan_bak_1d = dmps_user_nan_bak_1d
			duplicate/o main_dmps dmps_user_nan_bak
			wave user_nan_bak = dmps_user_nan_bak
			user_nan_bak = user_nan_bak_1d[p]
		endif
		wave user_nan_bak = dmps_user_nan_bak

		wave dt = dmps_datetime
		wave dt_bak = dmps_datetime_bak
		for (i=0; i<numpnts(dt_bak); i+=1)
			//FindValue/T=(0.2)/V=(dt_bak[i]) dt
			//user_nan[V_Value]=user_nan_bak[i]
			variable index = BinarySearch(main_dt,dt_bak[i])
			user_nan[index][] = user_nan_bak[i][q]
		endfor
	endif
// can I do this in one line? no

			
end

Function aps_concatenate_datasets(tb)
	variable tb
	
	init_aps_parameters()

	newdatafolder/o/s root:aps:$("data_"+num2str(tb)+"sec")
	
	string dset_list = get_dataset_list("aps")
	string tb_list=""
	variable i,j,k
	for (i=0; i<itemsinlist(dset_list); i+=1)
		NVAR ds_tb = root:aps:datasets:$(stringfromlist(i,dset_list)):timebase
		if (ds_tb == tb)
			tb_list = AddListItem(stringfromlist(i,dset_list),tb_list,";",999)
		endif
	endfor	
	
	// copy existing waves to backup
	if (waveexists(aps_datetime))
		duplicate/o aps_datetime aps_datetime_bak
	else
		killwaves/Z aps_datetime_bak
	endif
		if (waveexists(aps_user_nan))
		duplicate/o aps_user_nan aps_user_nan_bak
	else
		killwaves/Z aps_user_nan_bak
	endif
	
	variable mintime, maxtime
	for (i=0; i<itemsinlist(tb_list); i+=1)
		wave ds_dt = root:aps:datasets:$(stringfromlist(i,tb_list)):dataset_datetime
		wavestats/Q ds_dt
		if (i==0)		
			mintime = V_min
			maxtime = V_max
		else
			mintime = (V_min < mintime) ? V_min : mintime
			maxtime = (V_max > maxtime) ? V_max : maxtime
		endif
	endfor

	variable time_periods = (maxtime-mintime)/(tb) + 1
	make/o/n=(time_periods)/d aps_datetime

	aps_datetime[0] = mintime
	for (i=0; i<time_periods; i+=1)
		aps_datetime[i] = aps_datetime[i-1]+tb
	endfor
	
	for (i=0; i<itemsinlist(tb_list); i+=1)
		if (i==0) // use first dataset to set dp and matrix width
			duplicate/o root:aps:datasets:$(stringfromlist(i,tb_list)):aps_dpa aps_dpa, aps_dp_native
			wave smps = root:aps:datasets:$(stringfromlist(i,tb_list)):aps_dNdlogDp			
			variable cols = dimsize(smps,1)
			make/o/n=(time_periods,cols)/d aps_dNdlogDp
			aps_dNdlogDp=NaN
			// add a density wave (2d) 26 May 2009
//			make/o/n=(time_periods,cols)/d aps_density_w			
			sizing_make_density_w("aps",time_periods,cols)
			wave main_aps_density = aps_density_w
//			//main_aps_density = 1.0
//			if (exists(dmps_parameter_folder+":density"))
//				NVAR d = $(aps_parameter_folder+":density")
//				main_aps_density = d
//			else 
//				main_aps_density = aps_nominalDensity
//			endif 

		endif
		SetScale/P x aps_datetime[0],tb,"dat", aps_dNdlogDp
		
		wave main_dt = aps_datetime
		wave main_aps = aps_dNdlogDp
		
		wave ds_dt = root:aps:datasets:$(stringfromlist(i,tb_list)):dataset_datetime
		wave ds_aps = root:aps:datasets:$(stringfromlist(i,tb_list)):aps_dNdlogDp	

		//smps_main = (user_nan[p] ==1) ? NaN : smps_raw[p][q]

		variable starti = x2pnt(main_aps,ds_dt[0])
		main_aps[starti,starti+numpnts(ds_aps)] = ds_aps[p-starti][q]

//		string timebase_index = "timebase_index"
//		get_timebase_index(main_dt, ds_dt, 5, timebase_index)
//		wave tb_index = $timebase_index
//
//		for (j=0; j<numpnts(tb_index); j+=1)
//			for (k=0; k<dimsize(main_smps,1); k+=1)
//				if (tb_index[j] > -1)
//					main_smps[(tb_index[j])][k] = ds_smps[j][k]
//					//print i, j, k, tb_index[j], main_smps[(tb_index[j])][k], ds_smps[j][k]
//				endif
//			endfor
//		endfor
//
//		killwaves/Z tb_index		
		
		
	endfor

	// make a copy of main_smps to work from
	wave main_dt = aps_datetime
	wave main_aps = aps_dNdlogDp
//	SetScale/P x main_dt[0],aps_timebase,"dat", main_aps
	duplicate/o main_aps aps_dNdlogDp_raw
	//make/o/d/n=(dimsize(main_aps,0)) aps_user_nan
	duplicate/o main_aps aps_user_nan
	wave user_nan = aps_user_nan
	user_nan = 0
	// copy backup copy to new user_nan wave
	if (waveexists(aps_user_nan_bak))
		print "		copying old user_selections into new working wave"
		wave user_nan_bak = aps_user_nan_bak
		// check if old, 1D user nan		
		if (dimsize(user_nan_bak,1) == 0) // old...need to convert
			duplicate/o user_nan_bak aps_user_nan_bak_1d
			wave user_nan_bak_1d = aps_user_nan_bak_1d
			duplicate/o main_aps aps_user_nan_bak
			wave user_nan_bak = aps_user_nan_bak
			user_nan_bak = user_nan_bak_1d[p]
		endif
		wave user_nan_bak = aps_user_nan_bak

		wave dt = aps_datetime
		wave dt_bak = aps_datetime_bak
		for (i=0; i<numpnts(dt_bak); i+=1)
			//FindValue/T=(0.2)/V=(dt_bak[i]) dt
			//user_nan[V_Value]=user_nan_bak[i]
			variable index = BinarySearch(main_dt,dt_bak[i])
			user_nan[index][] = user_nan_bak[i][q]
		endfor
	endif
// can I do this in one line? no

			
end

Function	dmps_clean_user_times(tb)
	variable tb
	string sdf = getdatafolder(1)
	setdatafolder root:dmps:$("data_"+num2str(tb)+"sec")
	
	wave dmps_main = dmps_dNdlogDp
	wave dmps_raw = dmps_dNdlogDp_raw
	wave user_nan = dmps_user_nan
	dmps_main = (user_nan[p][q] ==1) ? NaN : dmps_raw[p][q]
	
	// clean 2d if exists
	//if (waveexists(dmps_dNdlogDp_2d))
		//wave
	if (sizing_auto_include_PFW && acg_project_is_set())
		// if ProjectInfo is set, clean with ProjectFlag
		//pfw_filter_wave(dmps_main, "NORMAL",0, 1)
	endif
		
	setdatafolder sdf		
End

Function	aps_clean_user_times(tb)
	variable tb
	string sdf = getdatafolder(1)
	setdatafolder root:aps:$("data_"+num2str(tb)+"sec")
	
	wave aps_main = aps_dNdlogDp
	wave aps_raw = aps_dNdlogDp_raw
	wave user_nan = aps_user_nan
	aps_main = (user_nan[p][q] ==1) ? NaN : aps_raw[p][q]

	if (sizing_auto_include_PFW && acg_project_is_set())
		// if ProjectInfo is set, clean with ProjectFlag
		//pfw_filter_wave(aps_main, "NORMAL",0, 1)
	endif
	
	setdatafolder sdf		
End


// GUI stuff

// Average Distribution Explorer
//	allows user to:
// 		- see full time series image
//		- select and view avg distribtion
//		- step through individual distributions that make up average

Function sizing_init_gui()
	string sdf = getdatafolder(1)
	if (!datafolderexists(sizing_gui_folder))
		newdatafolder/o/s $(sizing_gui_folder)
	endif
	setdatafolder sdf
End

Function sizing_init_gui_ADE()
	string sdf = getdatafolder(1)
//	if (!datafolderexists(sizing_gui_folder+":"+sizing_gui_ADE_folder))
	
		sizing_init_gui()
		
		newdatafolder/o/s $(sizing_gui_folder+":"+sizing_gui_ADE_folder)
		
		variable dt_now = datetime
		// add needed variables
		string/G Dp_label = ""
		string/G distType_label = ""
		variable/G avg_start_index=0
		variable/G avg_stop_index=0
		String/G avg_start_datetime=secs2date(dt_now,0) + "  " +secs2time(dt_now,3)
		String/G avg_stop_datetime=secs2date(dt_now,0) + "  " +secs2time(dt_now,3)
		
		variable/G avg_current_index=0
		String/G avg_current_datetime = secs2date(dt_now,0) + " " + secs2time(dt_now,3)
		
//	endif
	setdatafolder sdf


End

Function sizing_init_ADE_fit_params()
	string sdf = getdatafolder(1)

	sizing_init_gui_ADE()
	newdatafolder/o/s $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":" + sizing_gui_ADE_fp_folder)

	if (exists("current_moment") != 2)
		string/G current_moment = "dNdlogDp"
	endif
	if (exists("save_params") != 2)
		variable/G save_params = 0
	endif
	setdatafolder sdf
End

Function sizing_single_from_avg()
	string sdf = getdatafolder(1)
	string folder =  (sizing_gui_folder+":"+sizing_gui_ADE_folder)
	setdatafolder  folder

	wave editAvg = editAvgDist_w
	wave dp = editDp_w

	make/o/n=(numpnts(dp)) edit_dWdlogDp_w
	wave dw = edit_dWdlogDp_w
		
	nvar start_index = avg_start_index
	nvar index = avg_current_index
	svar dt = avg_current_datetime
	
	dt = secs2date(pnt2x(editAvg,index-start_index),0) + " " + secs2time(pnt2x(editAvg,index-start_index),3)
	 
	variable i
	for (i=0; i<numpnts(dw); i+=1)
		dw[i] = editAvg[index-start_index][i]
	endfor
	
	
	setdatafolder sdf
End


Function SetEditAvgIndexProc(ctrlName) : ButtonControl
	String ctrlName
	string sdf = getdatafolder(1)
	string folder =  (sizing_gui_folder+":"+sizing_gui_ADE_folder)
	setdatafolder  folder
	nvar start_index = avg_start_index
	nvar stop_index = avg_stop_index
	nvar index = avg_current_index

	if (cmpstr(ctrlName,"nextIndex") == 0)
		index = (index<stop_index) ? index+1 : stop_index
	elseif (cmpstr(ctrlName,"prevIndex") == 0)
		index = (index>start_index) ? index-1 : start_index	
	else
		return 0
	endif
	
	sizing_single_from_avg()
	
	setdatafolder sdf
End

Function ChangeIndexVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName

	string sdf = getdatafolder(1)
	string folder =  (sizing_gui_folder+":"+sizing_gui_ADE_folder)
	setdatafolder  folder
	nvar start_index = avg_start_index
	nvar stop_index = avg_stop_index
	nvar index = avg_current_index

	if (cmpstr(ctrlName,"currentIndexVar")==0)
		if (index <= start_index) 
			index = start_index
		elseif (index >= stop_index)
			index = stop_index
		endif
	endif

	sizing_single_from_avg()

	setdatafolder sdf

End

Function CalculateLogNormalFit(ctrlName) : ButtonControl
	String ctrlName
	
	// switch to ADE folder
	// get current moment and assign fit param wave
	SVAR curr_mom = $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":" + sizing_gui_ADE_fp_folder + ":current_moment")
	NVAR save_params = $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":" + sizing_gui_ADE_fp_folder + ":save_params")
	NVAR index = $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":avg_current_index")

	if (save_params)
		wave fp = $(sizing_gui_folder + ":" + sizing_gui_ADE_folder + ":" + sizing_gui_ADE_fp_folder + ":" + curr_mom + "_fp")

		CurveFit/Q LogNormal  root:gui:ADE:edit_dWdlogDp_w[pcsr(A),pcsr(B)] /X=root:gui:ADE:editDp_w /D 
		wave W_coef
		variable meanDp = W_coef[2]
		variable totW = W_coef[1]
		variable sigma = W_coef[3]
		variable chiSq = V_chisq
		
		fp[index][0] = meanDp
		fp[index][1] = totW
		fp[index][2] = sigma
		fp[index][3] = chiSq
				
	else 
	
		CurveFit LogNormal  root:gui:ADE:edit_dWdlogDp_w[pcsr(A),pcsr(B)] /X=root:gui:ADE:editDp_w /D 
		wave W_coef
		meanDp = W_coef[2]
		totW = W_coef[1]
		sigma = W_coef[3]
		chiSq = V_chisq
		
		print "mean Dp = ", meanDp
		print "total Concentration = ", totW
		print "width =", sigma
		print "chi squared =", chiSq
		
	endif

	//CurveFit LogNormal  ::::gui:ADE:edit_dWdlogDp_w[pcsr(A),pcsr(B)] /X=::::gui:ADE:editDp_w /D 


End

Window sizing_EditAvgDist() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:gui:ADE:
	Display /W=(305.25,155.75,792.75,461.75) edit_dWdlogDp_w vs editDp_w as "Edit Average Distribution"
	SetDataFolder fldrSav0
	ModifyGraph log(bottom)=1
	Label left "dW / dlogD\\Bp\\M"
	Label bottom "D\\Bp\\M (nm)"
	ShowInfo
	ControlBar 25
	Button nextIndex,pos={316,2},size={50,20},proc=SetEditAvgIndexProc,title=">"
	Button prevIndex,pos={258,2},size={50,20},proc=SetEditAvgIndexProc,title="<"
	SetVariable startIndexVar,pos={3,3},size={91,19},disable=2,title="Start"
	SetVariable startIndexVar,limits={-inf,inf,0},value= root:gui:ADE:avg_start_index,bodyWidth= 60
	SetVariable endIndexVar,pos={109,3},size={85,19},disable=2,title="End"
	SetVariable endIndexVar,limits={-inf,inf,0},value= root:gui:ADE:avg_stop_index,bodyWidth= 60
	SetVariable currentIndexVar,pos={382,4},size={105,19},proc=ChangeIndexVarProc,title="Current"
	SetVariable currentIndexVar,limits={-inf,inf,0},value= root:gui:ADE:avg_current_index,bodyWidth= 60
	SetVariable currentTimeVar,pos={504,4},size={120,19},title=" "
	SetVariable currentTimeVar,value= root:gui:ADE:avg_current_datetime,bodyWidth= 120
	Button fitButton,pos={199,2},size={50,20},proc=CalculateLogNormalFit,title="Fit"
	Button fitButton,help={"Calculate Log Normal fit between cursors"}
EndMacro


Function dmps_aps_combine(tb)
	variable tb
	string sdf = getdatafolder(1)
	
	newdatafolder/o/s root:dmps_aps
	//newdatafolder/o/s $smps_datasets_folder

	// copy dmps and aps dN/dlogDp waves 
	

	setdatafolder sdf
End

Function sizing_interp_nan_gap(dp_main_w, dp_w, data_w, destname_str)
	wave dp_main_w, dp_w, data_w
	string destname_str
	
	Duplicate/O dp_w, ing_temp_dp_w
	Duplicate/O data_w, ing_temp_data_w
	
//	DoWindow my_debug
//	if( V_Flag != 1 )
//		Edit dt_w, data_w, ing_temp_time_w, ing_temp_data_w
//		DoWindow/C/T my_debug , "my_debug"
//	endif
	
	Variable idex = 0, count = numpnts( ing_temp_dp_w )
	do
		if( numtype( ing_temp_data_w[idex] ) != 0 )
			Deletepoints idex, 1, ing_temp_data_w, ing_temp_dp_w
			count = numpnts( ing_temp_dp_w )
		else
			idex += 1	
		endif
	while( idex < count )
	make/o/n=(numpnts(dp_main_w)) $(destname_str)
	//duplicate/o data_w, $(destname_str)
	wave dest_w = $destname_str
	dest_w = (dp_main_w[p] <= ing_temp_dp_w[numpnts(ing_temp_dp_w)-1] ) ? interp(dp_main_w[p], ing_temp_dp_w, ing_temp_data_w) : ing_temp_data_w[numpnts(ing_temp_data_w)-1]
	
	//make sure no values < 0
	dest_w = (dest_w[p] < 0) ? 0 : dest_w[p]
	
	KillWaves/Z ing_temp_dp_w, ing_temp_data_w
End

Function sizing_merge_dmps_aps_both(tb)
	variable tb
	
	// do non-filtered first
	sizing_merge_dmps_aps(tb,0)
	
	// if filtered exists, merge it
	string dmps_filter = "root:dmps:data_"+num2str(tb)+"sec:filter"
	string aps_filter = "root:aps:data_"+num2str(tb)+"sec:filter"
	if (datafolderexists(dmps_filter) && datafolderexists(aps_filter))
		sizing_merge_dmps_aps(tb,1)
	endif
	
End

Function sizing_merge_dmps_aps(tb,isFilter)
	variable tb
	variable isFilter
	
	init_dmps_aps_parameters()
	
	string sdf = getdatafolder(1)
	
	variable skipLastDMPS = 0
	
	newdatafolder/o/s root:dmps_aps
	newdatafolder/o/s $("data_"+num2str(tb)+"sec")
	if (isFilter)
		newdatafolder/o/s filter
	endif
	
	// copy dmps and aps waves to dmps_aps folder
//	duplicate/o root:dmps:data_300sec:dmps_datetime dmps_datetime
//	duplicate/o root:dmps:data_300sec:dmps_dp dmps_dp
//	duplicate/o root:dmps:data_300sec:dmps_dNdlogDp dmps_dNdlogDp
//
//	duplicate/o root:aps:data_300sec:aps_datetime aps_datetime
//	duplicate/o root:aps:data_300sec:aps_dp aps_dp
//	duplicate/o root:aps:data_300sec:aps_dNdlogDp aps_dNdlogDp

	string filter_string = ""
	if (isFilter)
		filter_string = ":filter"
	endif
		
	//duplicate/o  $("root:dmps:data_300sec"+filter_string+":dmps_datetime") dmps_aps_datetime 
	duplicate/o  $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_datetime") dmps_aps_datetime 
	wave dmps_datetime = $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_datetime") 
	wave dmps_dp = $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_dp") 
	wave dmps_dNdlogDp =  $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_dNdlogDp") 

	wave aps_datetime = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_datetime") 
	wave aps_dpa = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_dpa")
	wave aps_dNdlogDp = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_dNdlogDp") 
	
	wave dmps_density = $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_density_w")
//	
//	// for now...this is a kludge to create the aps density (2d) wave
//	duplicate/o aps_dNdlogDp $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_density_w")
	wave aps_density = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_density_w")
//	dmps_density = 1.5
//	aps_density = 1.5
//
//	// change to use user specified dmps and aps values from parameter folder
	NVAR dmps_rho = $(dmps_parameter_folder+":density")
	dmps_density = dmps_rho

	NVAR aps_rho = $(aps_parameter_folder+":density")
	aps_density = aps_rho


//	// 5 March 2007 - Change to use best 2d density values
//	


	// create merged waves on standard diameter step
	variable standard_merge_cols = 96
	variable start_dp = 20
	variable stop_dp = 10000
	variable first_aps_dp = 0.90
	make/o/n=(standard_merge_cols) dmps_aps_dp
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) dmps_aps_dNdlogDp
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) dmps_aps_density
	dmps_aps_dNdlogDp = NaN  // default
	dmps_aps_density = 1.0       // default
	
	SetScale/I x log(start_dp),log(stop_dp),"nm" dmps_aps_dp	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_dNdlogDp
	SetScale/I y log(start_dp),log(stop_dp),"nm" dmps_aps_dNdlogDp	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_density
	SetScale/I y log(start_dp),log(stop_dp),"nm" dmps_aps_density	

	dmps_aps_dp[0] = start_dp
	dmps_aps_dp[1,] = dmps_aps_dp[p-1]*10^(log(stop_dp/start_dp)/(standard_merge_cols-1))
	duplicate/o dmps_aps_dp dmps_aps_dpa, dmps_aps_dp_native
	dmps_aps_dpa /= aps_density  // create dpa wave for now
	
	variable i,j,k
	variable dmps_cols=dimsize(dmps_dNdlogDp,1)
	variable aps_cols=dimsize(aps_dNdlogDp,1)
	variable dmps_merge_cols, aps_merge_cols, aps_start_col
	dmps_merge_cols = (skipLastDMPS) ? dmps_cols-1 : dmps_cols
	aps_merge_cols = 0
	aps_start_col = 0
	for (i=0; i<dimsize(aps_dNdlogDp,0); i+=1)

		duplicate/o aps_dpa aps_dp
		aps_dp = aps_dpa / sqrt(aps_density[i][q])
		
		//wavestats dmps_aps_dNdlogDp[i][q]
		//print V_npts
		
		// create merged dmps/aps diam and dNdlogDp waves
		aps_merge_cols = 0
		for (j=aps_cols-1; j>=0; j-=1)
			if ( (aps_dp[j] > dmps_dp[dmps_merge_cols-1]) && (aps_dp[j] > first_aps_dp) )
//		aps_merge_cols = 0
//		do
				aps_merge_cols += 1
				aps_start_col = j
//		while ( (aps_dp[j] > dmps_dp[dmps_merge_cols-1]) && (aps_merge_cols <= aps_cols) )
			endif
		endfor			
			
		make/o/n=(dmps_merge_cols+aps_merge_cols) dp_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dn_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dens_w

		// add dmps 
		dp_w[0,dmps_merge_cols-1] = dmps_dp[p]
		for (j=0; j<dmps_merge_cols; j+=1)
			dn_w[j] = dmps_dNdlogDp[i][j]
			dens_w[j] = dmps_density[i][j]
		endfor
		// add aps
		dp_w[dmps_merge_cols,] = aps_dp[p-dmps_merge_cols+aps_start_col]
		for (j=aps_start_col; j<(aps_start_col+aps_merge_cols); j+=1)
			dn_w[j-aps_start_col+dmps_merge_cols] = aps_dNdlogDp[i][j]
			dens_w[j-aps_start_col+dmps_merge_cols] = aps_density[i][j]
		endfor			

		// interp onto standard dp wave using the above
		sizing_interp_nan_gap(dmps_aps_dp, dp_w, dn_w, "single_dn_w")
		wave out = $"single_dn_w"
		dmps_aps_dNdlogDp[i][] = out[q]
		// interp densities as well? Probably have to...
		sizing_interp_nan_gap(dmps_aps_dp, dp_w, dens_w, "single_dens_w")
		wave out_dens = $"single_dens_w"
		dmps_aps_density[i][] = out_dens[q]
				
//		if (aps_dp[i] > dmps_dp[dmps_merge_cols-1])
//			aps_merge_cols += 1
//			aps_start_col = i
//		endif
	endfor
//	make/o/n=(dmps_merge_cols+aps_merge_cols) dmps_aps_dp
//	dmps_aps_dp[0,dmps_merge_cols-1] = dmps_dp[p]
//	for (i=0; i<aps_merge_cols; i+=1)
//		dmps_merge_cols[i+dmps_merge_cols] = aps_dp[i+aps_start_col]
//	endfor
	
	killwaves/Z out, out_dens

	// add extra parameters for convenience
	add_aero_diams("dmps_aps",tb,isFilter)
	convert_NtoSVM("dmps_aps",tb,isFilter)
	integrate_NSVM("dmps_aps",tb,isFilter)	
	create_im_plot_params("dmps_aps",tb,isFilter)
	
	setdatafolder sdf
End

Function sizing_filter_bad_merge_dmps(tb,isFilter,dmpsIsSamp,skipLast,index_wn)
	variable tb
	variable isFilter
	variable dmpsIsSamp
	variable skipLast
	string index_wn

	string dmpsSamp
	if (dmpsIsSamp)
		dmpsSamp = "_samp"
	else
		dmpsSamp = ""
	endif

	string filter_string = ""
	if (isFilter)
		filter_string = ":filter"
	endif

	wave dn =  $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_dNdlogDp"+dmpsSamp+"_2d")
	
	make/o/n=(dimsize(dn,0)) $index_wn
	wave index = $index_wn
	index = 0
	
	variable dmps_cols = dimsize(dn,1)
	variable dmps_merge_cols = (skipLast) ? dmps_cols-1 : dmps_cols
	
	variable i,j
	for (i=0; i<dimsize(dn,0); i+=1)
		variable zero_cnt=0
		for (j=dmps_merge_cols-1; j>dmps_merge_cols-5; j-=1)
			if (dn[i][j] < 1)
				zero_cnt +=1
			endif
		endfor
		if (zero_cnt > 0)
			index[i] = 1
		endif
	endfor
End

Function sizing_merge_dmps_aps_2d(tb,isFilter,dmpsIsSamp, apsIsSamp,shape)
	variable tb
	variable isFilter
	variable dmpsIsSamp
	variable apsIsSamp
	string shape
	
	init_dmps_aps_parameters()
	
	string sdf = getdatafolder(1)
	
	variable skipLastDMPS = 1
	//variable numberToSkipDMPS = 2 // skip last 2 bins
	
	variable filter_merge_candidates = 1
	string bad_merge_name = "bad_dmps_merge"
	if (filter_merge_candidates)
		sizing_filter_bad_merge_dmps(tb,isFilter,dmpsIsSamp,skipLastDMPS,bad_merge_name)
	endif
	newdatafolder/o/s root:dmps_aps
	newdatafolder/o/s $("data_"+num2str(tb)+"sec")
	if (isFilter)
		newdatafolder/o/s filter
	endif
	
	string inst="dmps_aps"
	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	// copy dmps and aps waves to dmps_aps folder
//	duplicate/o root:dmps:data_300sec:dmps_datetime dmps_datetime
//	duplicate/o root:dmps:data_300sec:dmps_dp dmps_dp
//	duplicate/o root:dmps:data_300sec:dmps_dNdlogDp dmps_dNdlogDp
//
//	duplicate/o root:aps:data_300sec:aps_datetime aps_datetime
//	duplicate/o root:aps:data_300sec:aps_dp aps_dp
//	duplicate/o root:aps:data_300sec:aps_dNdlogDp aps_dNdlogDp

	variable isModified = 0

//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
	
	string dmpsSamp
	if (dmpsIsSamp)
		dmpsSamp = "_samp"
		isModified = 1
	else
		dmpsSamp = ""
	endif

	string filter_string = ""
	if (isFilter)
		filter_string = ":filter"
	endif
	
	//duplicate/o  $("root:dmps:data_300sec"+filter_string+":dmps_datetime") dmps_aps_datetime 
	duplicate/o  $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_datetime") dmps_aps_datetime 
	wave dmps_datetime = $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_datetime") 
//	wave dmps_dp = $("root:dmps:data_300sec"+filter_string+":dmps_dp_um"+shapestr+"_2d")
//	wave dmps_dNdlogDp =  $("root:dmps:data_300sec"+filter_string+":dmps_dNdlogDp"+dmpsSamp+shapestr+"_2d")
	wave dmps_dp = $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_dp_um"+"_2d")
	wave dmps_dNdlogDp =  $("root:dmps:data_"+num2str(tb)+"sec"+filter_string+":dmps_dNdlogDp"+dmpsSamp+"_2d")

	string apsSamp
	if (apsIsSamp)
		apsSamp = "_samp"
		isModified = 1
	else
		apsSamp = ""
	endif

//	wave aps_datetime = $("root:aps:data_300sec"+filter_string+":aps_datetime") 
//	wave aps_dp = $("root:aps:data_300sec"+filter_string+":aps_dp_um"+shapestr+"_2d")
//	wave aps_dpa = $("root:aps:data_300sec"+filter_string+":aps_dpa_um"+shapestr+"_2d")
//	wave aps_dNdlogDp = $("root:aps:data_300sec"+filter_string+":aps_dNdlogDp"+apsSamp+shapestr+"_2d") 
	
	string aps_path = "root:aps:data_"+num2str(tb)+"sec"+filter_string
	if (cmpstr(shape,"sphere") != 0)
		aps_path += ":"+shape
	endif

	wave aps_datetime = $(aps_path+":aps_datetime") 
	wave aps_dp = $(aps_path+":aps_dp_um"+"_2d")
	wave aps_dpa = $(aps_path+":aps_dpa_um"+"_2d")
	wave aps_dNdlogDp = $(aps_path+":aps_dNdlogDp"+apsSamp+"_2d") 
	
//	wave dmps_density = root:dmps:data_300sec:dmps_density_w
//	wave aps_density = root:aps:data_300sec:aps_density_w
//	dmps_density = 1.5
//	aps_density = 1.5

	// 5 March 2007 - Change to use best 2d density values
	sizing_get_density_2d("dmps_aps",tb,dmps_dp,"geom",("dmps_density_2d"),isFilter,0,shape)
	wave dmps_density = $("dmps_density_2d")

	sizing_get_density_2d("dmps_aps",tb,aps_dp,"aero",("aps_density_2d"),isFilter,0,shape)
//	sizing_get_density_2d("dmps_aps",tb,aps_dp,"geom",("aps_density_2d"),isFilter,0,shape)
	wave aps_density = $("aps_density_2d")


	// create merged waves on standard diameter step
	variable standard_merge_cols = 96
	variable start_dp = 0.020
	variable stop_dp = 10.000
	//variable first_aps_dp = 0.90 // original...all experiments have used this
	variable first_aps_dp = 1.00 // testing: 15June2015 for psa
	make/o/n=(standard_merge_cols) dmps_aps_dp_um_2d
//	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_dNdlogDp"+shapestr+"_2d")
//	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_density"+shapestr+"_2d")
//	wave dmps_aps_dNdlogDp_2d = $("dmps_aps_dNdlogDp"+shapestr+"_2d")
//	wave dmps_aps_density_2d =  $("dmps_aps_density"+shapestr+"_2d")
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_dNdlogDp"+"_2d")
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_density"+"_2d")
	wave dmps_aps_dNdlogDp_2d = $("dmps_aps_dNdlogDp"+"_2d")
	wave dmps_aps_density_2d =  $("dmps_aps_density"+"_2d")
	dmps_aps_dNdlogDp_2d = NaN  // default
	dmps_aps_density_2d = 1.0       // default
	
	SetScale/I x log(start_dp),log(stop_dp),"um" dmps_aps_dp_um_2d	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_dNdlogDp_2d
	SetScale/I y log(start_dp),log(stop_dp),"um" dmps_aps_dNdlogDp_2d	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_density_2d
	SetScale/I y log(start_dp),log(stop_dp),"um" dmps_aps_density_2d	

	dmps_aps_dp_um_2d[0] = start_dp
	dmps_aps_dp_um_2d[1,] = dmps_aps_dp_um_2d[p-1]*10^(log(stop_dp/start_dp)/(standard_merge_cols-1))
	duplicate/o dmps_aps_dp_um_2d dmps_aps_dpa_um_2d, dmps_aps_dp_native_2d
//	dmps_aps_dpa_um_2d /= aps_density  // create dpa wave for now
	
	variable i,j,k
	variable dmps_cols=dimsize(dmps_dNdlogDp,1)
	variable aps_cols=dimsize(aps_dNdlogDp,1)
	variable dmps_merge_cols, aps_merge_cols, aps_start_col

//	for (i=0; i<dimsize(aps_dNdlogDp,0); i+=1)

	dmps_merge_cols = (skipLastDMPS) ? dmps_cols-1 : dmps_cols
//	dmps_merge_cols = (skipLastDMPS) ? dmps_cols-numberToSkipDMPS : dmps_cols
//	variable dmc = dmps_merge_cols
//	variable last_is_bad = 0
//		if (i==3324)
//			print "here"
//		endif
//	do
//		variable dind = dmc-1
//		if (dmps_dNdlogDp[i][dind] < 1)
//			dmc-=1
//			last_is_bad = 1
//		else
//			last_is_bad = 0
//		endif
//	while (dmc>0 && last_is_bad)
//	dmps_merge_cols=dmc
		
	aps_merge_cols = 0
	aps_start_col = 0


	//duplicate/o aps_dpa aps_dp
	// ** removed these two lines 10 Sept 2007 since aps_dp is now calculated earlier using ultra-stokesian and shape corrections
	//wave aps_dp = $("root:aps:data_300sec"+filter_string+":aps_dp_um"+shapestr+"_2d")
	//aps_dp = aps_dpa / sqrt(aps_density)

	for (i=0; i<dimsize(aps_dNdlogDp,0); i+=1)

//		duplicate/o aps_dpa aps_dp
//		aps_dp = aps_dpa / sqrt(aps_density[i][q])
		
		//wavestats dmps_aps_dNdlogDp[i][q]
		//print V_npts
		
		/// stopped here: need to go through each dist
		//	1) create best merged data, fit and put back into new wave
		
		// create merged dmps/aps diam and dNdlogDp waves
		aps_merge_cols = 0
		for (j=aps_cols-1; j>=0; j-=1)
			if ( (aps_dp[i][j] > dmps_dp[i][dmps_merge_cols-1]) && (aps_dp[i][j] > first_aps_dp) )
//		aps_merge_cols = 0
//		do
				aps_merge_cols += 1
				aps_start_col = j
//		while ( (aps_dp[j] > dmps_dp[dmps_merge_cols-1]) && (aps_merge_cols <= aps_cols) )
			endif
		endfor			
			
		make/o/n=(dmps_merge_cols+aps_merge_cols) dp_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dn_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dens_w
		

		// add dmps 
		dp_w[0,dmps_merge_cols-1] = dmps_dp[i][p]
		for (j=0; j<dmps_merge_cols; j+=1)
			dn_w[j] = dmps_dNdlogDp[i][j]
			dens_w[j] = dmps_density[i][j]
		endfor
		// add aps
		dp_w[dmps_merge_cols,] = aps_dp[i][p-dmps_merge_cols+aps_start_col]
		for (j=aps_start_col; j<(aps_start_col+aps_merge_cols); j+=1)
			dn_w[j-aps_start_col+dmps_merge_cols] = aps_dNdlogDp[i][j]
			dens_w[j-aps_start_col+dmps_merge_cols] = aps_density[i][j]
		endfor			

		// interp onto standard dp wave using the above
		sizing_interp_nan_gap(dmps_aps_dp_um_2d, dp_w, dn_w, "single_dn_w")
		wave out = $"single_dn_w"
		
		if (filter_merge_candidates)
			wave bad_dmps = $bad_merge_name
			if (bad_dmps[i])
				dmps_aps_dNdlogDp_2d[i][] = NaN
			else 
				dmps_aps_dNdlogDp_2d[i][] = out[q]
			endif
		else
			dmps_aps_dNdlogDp_2d[i][] = out[q]
		endif
		
		// interp densities as well? Probably have to...
		sizing_interp_nan_gap(dmps_aps_dp_um_2d, dp_w, dens_w, "single_dens_w")
		wave out_dens = $"single_dens_w"
		dmps_aps_density_2d[i][] = out_dens[q]
//		if (i==3324)
//			print "here"
//		endif
				
//		if (aps_dp[i] > dmps_dp[dmps_merge_cols-1])
//			aps_merge_cols += 1
//			aps_start_col = i
//		endif
	endfor
//	make/o/n=(dmps_merge_cols+aps_merge_cols) dmps_aps_dp
//	dmps_aps_dp[0,dmps_merge_cols-1] = dmps_dp[p]
//	for (i=0; i<aps_merge_cols; i+=1)
//		dmps_merge_cols[i+dmps_merge_cols] = aps_dp[i+aps_start_col]
//	endfor
	
	killwaves/Z out, out_dens, dmps_density, aps_density

	isModified = 1
	
	// add extra parameters for convenience
	add_aero_diams_2d("dmps_aps",tb,isFilter,0,shape)
	convert_NtoSVM_2d("dmps_aps",tb,isFilter,0,isModified,shape)
	integrate_NSVM_2d("dmps_aps",tb,isFilter,0,shape)	

	//integrate_NSVM_2d("dmps_aps",tb,isFilter,0)	
	integrate_NSVM_fraction_2d("dmps_aps",tb,"sub1",1,isFilter,0,shape)	
	integrate_NSVM_fraction_2d("dmps_aps",tb,"super1sub10",1,isFilter,0,shape)	

//	create_im_plot_params("dmps_aps",tb,0)
	
	setdatafolder sdf
End


// **** new SMPS function **** //
Function sizing_merge_smps_aps(tb,isFilter)
	variable tb
	variable isFilter
	
	// leaving final as dmps_aps for now
	init_dmps_aps_parameters()
	
	string sdf = getdatafolder(1)
	
	variable skipLastDMPS = 0
	
	newdatafolder/o/s root:dmps_aps
	newdatafolder/o/s $("data_"+num2str(tb)+"sec")
	if (isFilter)
		newdatafolder/o/s filter
	endif
	
	// copy dmps and aps waves to dmps_aps folder
//	duplicate/o root:dmps:data_300sec:dmps_datetime dmps_datetime
//	duplicate/o root:dmps:data_300sec:dmps_dp dmps_dp
//	duplicate/o root:dmps:data_300sec:dmps_dNdlogDp dmps_dNdlogDp
//
//	duplicate/o root:aps:data_300sec:aps_datetime aps_datetime
//	duplicate/o root:aps:data_300sec:aps_dp aps_dp
//	duplicate/o root:aps:data_300sec:aps_dNdlogDp aps_dNdlogDp

	string filter_string = ""
	if (isFilter)
		filter_string = ":filter"
	endif
		
	//duplicate/o  $("root:dmps:data_300sec"+filter_string+":dmps_datetime") dmps_aps_datetime 
	duplicate/o  $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_datetime") dmps_aps_datetime 
	wave dmps_datetime = $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_datetime") 
	wave dmps_dp = $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_dp") 
	wave dmps_dNdlogDp =  $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_dNdlogDp") 

	wave aps_datetime = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_datetime") 
	wave aps_dpa = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_dpa")
	wave aps_dNdlogDp = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_dNdlogDp") 
	
	wave dmps_density = $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_density_w")
//	
//	// for now...this is a kludge to create the aps density (2d) wave
//	duplicate/o aps_dNdlogDp $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_density_w")
	wave aps_density = $("root:aps:data_"+num2str(tb)+"sec"+filter_string+":aps_density_w")
//	dmps_density = 1.5
//	aps_density = 1.5
//
//	// change to use user specified dmps and aps values from parameter folder
	NVAR dmps_rho = $(smps_parameter_folder+":density")
	dmps_density = dmps_rho

	NVAR aps_rho = $(aps_parameter_folder+":density")
	aps_density = aps_rho


//	// 5 March 2007 - Change to use best 2d density values
//	


	// create merged waves on standard diameter step
	variable standard_merge_cols = 96
	variable start_dp = 10
	variable stop_dp = 10000
	variable first_aps_dp = 550
	make/o/n=(standard_merge_cols) dmps_aps_dp
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) dmps_aps_dNdlogDp
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) dmps_aps_density
	dmps_aps_dNdlogDp = NaN  // default
	dmps_aps_density = 1.0       // default
	
	SetScale/I x log(start_dp),log(stop_dp),"nm" dmps_aps_dp	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_dNdlogDp
	SetScale/I y log(start_dp),log(stop_dp),"nm" dmps_aps_dNdlogDp	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_density
	SetScale/I y log(start_dp),log(stop_dp),"nm" dmps_aps_density	

	dmps_aps_dp[0] = start_dp
	dmps_aps_dp[1,] = dmps_aps_dp[p-1]*10^(log(stop_dp/start_dp)/(standard_merge_cols-1))
	duplicate/o dmps_aps_dp dmps_aps_dpa, dmps_aps_dp_native
	dmps_aps_dpa /= aps_density  // create dpa wave for now
	
	variable i,j,k
	variable dmps_cols=dimsize(dmps_dNdlogDp,1)
	variable aps_cols=dimsize(aps_dNdlogDp,1)
	variable dmps_merge_cols, aps_merge_cols, aps_start_col
	dmps_merge_cols = (skipLastDMPS) ? dmps_cols-1 : dmps_cols
	aps_merge_cols = 0
	aps_start_col = 0
	for (i=0; i<dimsize(aps_dNdlogDp,0); i+=1)

		if (i==9873)
			print "here"
		endif

		duplicate/o aps_dpa aps_dp
		aps_dp = aps_dpa / sqrt(aps_density[i][q])
		
		//wavestats dmps_aps_dNdlogDp[i][q]
		//print V_npts
		
		// create merged dmps/aps diam and dNdlogDp waves
		aps_merge_cols = 0
		for (j=aps_cols-1; j>=0; j-=1)
			if ( (aps_dp[j] > dmps_dp[dmps_merge_cols-1]) && (aps_dp[j] > first_aps_dp) )
//		aps_merge_cols = 0
//		do
				aps_merge_cols += 1
				aps_start_col = j
//		while ( (aps_dp[j] > dmps_dp[dmps_merge_cols-1]) && (aps_merge_cols <= aps_cols) )
			endif
		endfor			
			
		make/o/n=(dmps_merge_cols+aps_merge_cols) dp_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dn_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dens_w

		// add dmps 
		variable all_nans = 1
		dp_w[0,dmps_merge_cols-1] = dmps_dp[p]
		for (j=0; j<dmps_merge_cols; j+=1)
			dn_w[j] = dmps_dNdlogDp[i][j]
			if (all_nans && numtype(dn_w[j])==0)
				all_nans=0
			endif
			dens_w[j] = dmps_density[i][j]
		endfor
		// add aps
		dp_w[dmps_merge_cols,] = aps_dp[p-dmps_merge_cols+aps_start_col]
		for (j=aps_start_col; j<(aps_start_col+aps_merge_cols); j+=1)
			dn_w[j-aps_start_col+dmps_merge_cols] = (all_nans) ? NaN : aps_dNdlogDp[i][j]
			dens_w[j-aps_start_col+dmps_merge_cols] = aps_density[i][j]
		endfor			

		// interp onto standard dp wave using the above
		sizing_interp_nan_gap(dmps_aps_dp, dp_w, dn_w, "single_dn_w")
		wave out = $"single_dn_w"
		dmps_aps_dNdlogDp[i][] = out[q]
		// interp densities as well? Probably have to...
		sizing_interp_nan_gap(dmps_aps_dp, dp_w, dens_w, "single_dens_w")
		wave out_dens = $"single_dens_w"
		dmps_aps_density[i][] = out_dens[q]
				
//		if (aps_dp[i] > dmps_dp[dmps_merge_cols-1])
//			aps_merge_cols += 1
//			aps_start_col = i
//		endif
	endfor
//	make/o/n=(dmps_merge_cols+aps_merge_cols) dmps_aps_dp
//	dmps_aps_dp[0,dmps_merge_cols-1] = dmps_dp[p]
//	for (i=0; i<aps_merge_cols; i+=1)
//		dmps_merge_cols[i+dmps_merge_cols] = aps_dp[i+aps_start_col]
//	endfor
	
	killwaves/Z out, out_dens

	// add extra parameters for convenience
	add_aero_diams("dmps_aps",tb,isFilter)
	convert_NtoSVM("dmps_aps",tb,isFilter)
	integrate_NSVM("dmps_aps",tb,isFilter)	
	create_im_plot_params("dmps_aps",tb,isFilter)
	
	setdatafolder sdf
End

Function sizing_merge_smps_aps_2d(tb,isFilter,dmpsIsSamp, apsIsSamp,shape)
	variable tb
	variable isFilter
	variable dmpsIsSamp
	variable apsIsSamp
	string shape
	
	init_dmps_aps_parameters()
	
	string sdf = getdatafolder(1)
	
	variable skipLastDMPS = 0
	
	newdatafolder/o/s root:dmps_aps
	newdatafolder/o/s $("data_"+num2str(tb)+"sec")
	if (isFilter)
		newdatafolder/o/s filter
	endif
	
	string inst="dmps_aps"
	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
	// copy dmps and aps waves to dmps_aps folder
//	duplicate/o root:dmps:data_300sec:dmps_datetime dmps_datetime
//	duplicate/o root:dmps:data_300sec:dmps_dp dmps_dp
//	duplicate/o root:dmps:data_300sec:dmps_dNdlogDp dmps_dNdlogDp
//
//	duplicate/o root:aps:data_300sec:aps_datetime aps_datetime
//	duplicate/o root:aps:data_300sec:aps_dp aps_dp
//	duplicate/o root:aps:data_300sec:aps_dNdlogDp aps_dNdlogDp

	variable isModified = 0

//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
	
	string dmpsSamp
	if (dmpsIsSamp)
		dmpsSamp = "_samp"
		isModified = 1
	else
		dmpsSamp = ""
	endif

	string filter_string = ""
	if (isFilter)
		filter_string = ":filter"
	endif
	
	//duplicate/o  $("root:dmps:data_300sec"+filter_string+":dmps_datetime") dmps_aps_datetime 
	duplicate/o  $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_datetime") dmps_aps_datetime 
	wave dmps_datetime = $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_datetime") 
//	wave dmps_dp = $("root:dmps:data_300sec"+filter_string+":dmps_dp_um"+shapestr+"_2d")
//	wave dmps_dNdlogDp =  $("root:dmps:data_300sec"+filter_string+":dmps_dNdlogDp"+dmpsSamp+shapestr+"_2d")
	wave dmps_dp = $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_dp_um"+"_2d")
	wave dmps_dNdlogDp =  $("root:smps:data_"+num2str(tb)+"sec"+filter_string+":smps_dNdlogDp"+dmpsSamp+"_2d")

	string apsSamp
	if (apsIsSamp)
		apsSamp = "_samp"
		isModified = 1
	else
		apsSamp = ""
	endif

//	wave aps_datetime = $("root:aps:data_300sec"+filter_string+":aps_datetime") 
//	wave aps_dp = $("root:aps:data_300sec"+filter_string+":aps_dp_um"+shapestr+"_2d")
//	wave aps_dpa = $("root:aps:data_300sec"+filter_string+":aps_dpa_um"+shapestr+"_2d")
//	wave aps_dNdlogDp = $("root:aps:data_300sec"+filter_string+":aps_dNdlogDp"+apsSamp+shapestr+"_2d") 
	
	string aps_path = "root:aps:data_"+num2str(tb)+"sec"+filter_string
	if (cmpstr(shape,"sphere") != 0)
		aps_path += ":"+shape
	endif

	wave aps_datetime = $(aps_path+":aps_datetime") 
	wave aps_dp = $(aps_path+":aps_dp_um"+"_2d")
	wave aps_dpa = $(aps_path+":aps_dpa_um"+"_2d")
	wave aps_dNdlogDp = $(aps_path+":aps_dNdlogDp"+apsSamp+"_2d") 
	
//	wave dmps_density = root:dmps:data_300sec:dmps_density_w
//	wave aps_density = root:aps:data_300sec:aps_density_w
//	dmps_density = 1.5
//	aps_density = 1.5

	// 5 March 2007 - Change to use best 2d density values
	sizing_get_density_2d("dmps_aps",tb,dmps_dp,"geom",("dmps_density_2d"),isFilter,0,shape)
	wave dmps_density = $("dmps_density_2d")

	sizing_get_density_2d("dmps_aps",tb,aps_dp,"aero",("aps_density_2d"),isFilter,0,shape)
//	sizing_get_density_2d("dmps_aps",tb,aps_dp,"geom",("aps_density_2d"),isFilter,0,shape)
	wave aps_density = $("aps_density_2d")


	// create merged waves on standard diameter step
	variable standard_merge_cols = 96
	variable start_dp = 0.020
	variable stop_dp = 10.000
	variable first_aps_dp = 0.90
	make/o/n=(standard_merge_cols) dmps_aps_dp_um_2d
//	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_dNdlogDp"+shapestr+"_2d")
//	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_density"+shapestr+"_2d")
//	wave dmps_aps_dNdlogDp_2d = $("dmps_aps_dNdlogDp"+shapestr+"_2d")
//	wave dmps_aps_density_2d =  $("dmps_aps_density"+shapestr+"_2d")
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_dNdlogDp"+"_2d")
	make/o/n=(dimsize(dmps_dNdlogDp,0),standard_merge_cols) $("dmps_aps_density"+"_2d")
	wave dmps_aps_dNdlogDp_2d = $("dmps_aps_dNdlogDp"+"_2d")
	wave dmps_aps_density_2d =  $("dmps_aps_density"+"_2d")
	dmps_aps_dNdlogDp_2d = NaN  // default
	dmps_aps_density_2d = 1.0       // default
	
	SetScale/I x log(start_dp),log(stop_dp),"um" dmps_aps_dp_um_2d	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_dNdlogDp_2d
	SetScale/I y log(start_dp),log(stop_dp),"um" dmps_aps_dNdlogDp_2d	
	SetScale/P x dmps_datetime[0],tb,"dat" dmps_aps_density_2d
	SetScale/I y log(start_dp),log(stop_dp),"um" dmps_aps_density_2d	

	dmps_aps_dp_um_2d[0] = start_dp
	dmps_aps_dp_um_2d[1,] = dmps_aps_dp_um_2d[p-1]*10^(log(stop_dp/start_dp)/(standard_merge_cols-1))
	duplicate/o dmps_aps_dp_um_2d dmps_aps_dpa_um_2d, dmps_aps_dp_native_2d
//	dmps_aps_dpa_um_2d /= aps_density  // create dpa wave for now
	
	variable i,j,k
	variable dmps_cols=dimsize(dmps_dNdlogDp,1)
	variable aps_cols=dimsize(aps_dNdlogDp,1)
	variable dmps_merge_cols, aps_merge_cols, aps_start_col
	dmps_merge_cols = (skipLastDMPS) ? dmps_cols-1 : dmps_cols
	aps_merge_cols = 0
	aps_start_col = 0


	//duplicate/o aps_dpa aps_dp
	// ** removed these two lines 10 Sept 2007 since aps_dp is now calculated earlier using ultra-stokesian and shape corrections
	//wave aps_dp = $("root:aps:data_300sec"+filter_string+":aps_dp_um"+shapestr+"_2d")
	//aps_dp = aps_dpa / sqrt(aps_density)

	for (i=0; i<dimsize(aps_dNdlogDp,0); i+=1)

//		duplicate/o aps_dpa aps_dp
//		aps_dp = aps_dpa / sqrt(aps_density[i][q])
		
		//wavestats dmps_aps_dNdlogDp[i][q]
		//print V_npts
		
		/// stopped here: need to go through each dist
		//	1) create best merged data, fit and put back into new wave
		
		// create merged dmps/aps diam and dNdlogDp waves
		aps_merge_cols = 0
		for (j=aps_cols-1; j>=0; j-=1)
			if ( (aps_dp[i][j] > dmps_dp[i][dmps_merge_cols-1]) && (aps_dp[i][j] > first_aps_dp) )
//		aps_merge_cols = 0
//		do
				aps_merge_cols += 1
				aps_start_col = j
//		while ( (aps_dp[j] > dmps_dp[dmps_merge_cols-1]) && (aps_merge_cols <= aps_cols) )
			endif
		endfor			
			
		make/o/n=(dmps_merge_cols+aps_merge_cols) dp_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dn_w
		make/o/n=(dmps_merge_cols+aps_merge_cols) dens_w

		// add dmps 
		dp_w[0,dmps_merge_cols-1] = dmps_dp[i][p]
		for (j=0; j<dmps_merge_cols; j+=1)
			dn_w[j] = dmps_dNdlogDp[i][j]
			dens_w[j] = dmps_density[i][j]
		endfor
		// add aps
		dp_w[dmps_merge_cols,] = aps_dp[i][p-dmps_merge_cols+aps_start_col]
		for (j=aps_start_col; j<(aps_start_col+aps_merge_cols); j+=1)
			dn_w[j-aps_start_col+dmps_merge_cols] = aps_dNdlogDp[i][j]
			dens_w[j-aps_start_col+dmps_merge_cols] = aps_density[i][j]
		endfor			

		// interp onto standard dp wave using the above
		sizing_interp_nan_gap(dmps_aps_dp_um_2d, dp_w, dn_w, "single_dn_w")
		wave out = $"single_dn_w"
		dmps_aps_dNdlogDp_2d[i][] = out[q]
		// interp densities as well? Probably have to...
		sizing_interp_nan_gap(dmps_aps_dp_um_2d, dp_w, dens_w, "single_dens_w")
		wave out_dens = $"single_dens_w"
		dmps_aps_density_2d[i][] = out_dens[q]
				
//		if (aps_dp[i] > dmps_dp[dmps_merge_cols-1])
//			aps_merge_cols += 1
//			aps_start_col = i
//		endif
	endfor
//	make/o/n=(dmps_merge_cols+aps_merge_cols) dmps_aps_dp
//	dmps_aps_dp[0,dmps_merge_cols-1] = dmps_dp[p]
//	for (i=0; i<aps_merge_cols; i+=1)
//		dmps_merge_cols[i+dmps_merge_cols] = aps_dp[i+aps_start_col]
//	endfor
	
	killwaves/Z out, out_dens, dmps_density, aps_density

	// remove "bad" merge candidates

	// add extra parameters for convenience
	add_aero_diams_2d("dmps_aps",tb,isFilter,0,shape)
	convert_NtoSVM_2d("dmps_aps",tb,isFilter,0,isModified,shape)
	integrate_NSVM_2d("dmps_aps",tb,isFilter,0,shape)	

	//integrate_NSVM_2d("dmps_aps",tb,isFilter,0)	
	integrate_NSVM_fraction_2d("dmps_aps",tb,"sub1",1,isFilter,0,shape)	
	integrate_NSVM_fraction_2d("dmps_aps",tb,"super1sub10",1,isFilter,0,shape)	

//	create_im_plot_params("dmps_aps",tb,0)
	
	setdatafolder sdf
End



Function init_dmps_aps_parameters()
	if (!datafolderexists(dmps_aps_parameter_folder))
		string sdf=getdatafolder(1)
		newdatafolder/o root:dmps_aps
		newdatafolder/s $dmps_aps_parameter_folder
		
		// change to use user specified dmps and aps values in parameter folders if available
		NVAR aps_density = root:dmps_aps:parameter:density
		variable/G density=aps_density
		variable/G tmp_density=aps_density
		
		setdatafolder sdf
	endif
End		

Function/S sizing_init_mask_list()
	// combine mask lists into big list, seperated by keys
	string sizing_mask_list1 = sizing_HSC_mask_list + "," + sizing_TB_mask_list + "," + sizing_Jacinto_mask_list + "," + sizing_BC_mask_list 
	string sizing_mask_list2 = sizing_Free_mask_list + "," + sizing_Mat_mask_list + "," + sizing_GB_mask_list + "," + sizing_PA_mask_list
	string sizing_mask_list3 = sizing_SE_US_mask_list + "," + sizing_Dust_mask_list + "," + sizing_Gulf_mask_list
	string sizing_mask_list = sizing_mask_list1 + "," + sizing_mask_list2 + "," + sizing_mask_list3
	return sizing_mask_list	
End

Function/S sizing_init_mask_key_list()
	string sizing_mask_key_list = "HSC;TB;Jacinto;BC;Free;Mat;GB;PA;SE_US;Dust;Gulf"
	return sizing_mask_key_list
End

Function sizing_mask_intN(inst, tb)

	string inst
	variable tb
	
	string sizing_mask_list = sizing_init_mask_list()
	string sizing_mask_key_list = sizing_init_mask_key_list()
	
	
	string sdf = getdatafolder(1)
	//string fldr = inst + ":data_"+num2str(tb)+"sec" + ":filter"
	string fldr = inst + ":data_"+num2str(tb)+"sec"
	setdatafolder ("root:"+fldr)
	newdatafolder/o/s masked
	newdatafolder/o/s intN
	
	// this explicitly points to Trish's mask datetime wave - if you need to put it on a diff tb, change here.
	//wave maskdt_w = root:$(sizing_mask_folder):DL_starttime_5m
	wave maskdt_w = root:$(sizing_mask_folder):DL_starttime_1m
	variable startdt_mask = maskdt_w[0]
	variable stopdt_mask = maskdt_w[numpnts(maskdt_w)-1]
	
	// "correct" 1m SS_Setting data to actual SS values (not set points)
	wave ccn_dt = root:$(sizing_mask_folder):ccn:ccn_datetime
	wave ccn = root:$(sizing_mask_folder):ccn:CCN_1min
	duplicate/o root:$(sizing_mask_folder):ccn:SS_Setting root:$(sizing_mask_folder):ccn:SS_Setting_cleaned
	wave ccn_ss = root:$(sizing_mask_folder):ccn:SS_Setting_cleaned
	variable ccni
	for (ccni=0; ccni<numpnts(ccn_ss); ccni+=1)
		if ((ccn_ss[ccni] > 0.28) && (ccn_ss[ccni] < 0.32))
			ccn_ss[ccni] = 0.22
		elseif ((ccn_ss[ccni] > 0.54) && (ccn_ss[ccni] < 0.58))
			ccn_ss[ccni] = 0.44
		elseif ((ccn_ss[ccni] > 0.80) && (ccn_ss[ccni] < 0.84))
			ccn_ss[ccni] = 0.65
		elseif ((ccn_ss[ccni] > 1.07) && (ccn_ss[ccni] < 1.11))
			ccn_ss[ccni] = 0.84
		elseif ((ccn_ss[ccni] > 1.33) && (ccn_ss[ccni] < 1.37))
			ccn_ss[ccni] = 1.00
		else
			ccn_ss[ccni] = NaN
		endif
	endfor	
	variable i,j,k
	// copy the "latest" NH4SO4_SS_intN waves to our mask folder
	for (i=0; i<itemsinlist(sizing_ss_levels); i+=1)
		
		// for some reason, I had to put single quotes around the wave name in oldwave. ??
		string olddtwav = "root:"+fldr+ ":"+inst+"_datetime"
		string oldwav = "root:"+fldr+ ":"+inst+"_intN_as_"+stringfromlist(i,sizing_ss_levels)+"_SS"
		string newwav = inst+"_intN_as_"+stringfromlist(i,sizing_ss_levels)+"_SS"
		wave olddt = $olddtwav
		wave old = $oldwav
		//acg_adjust_wave_to_datetime(startdt_mask, stopdt_mask, tb, maskdt_w, old, "mask_datetime", newwav)
		acg_expand_wave_to_tb(startdt_mask, stopdt_mask, tb, 60, olddt, old, "mask_datetime", newwav,0)
		//duplicate/o $oldwav $newwav
		//print oldwav, newwav
	endfor 
	
	// create folders for each of the mask types
	for (i=0; i<itemsinlist(sizing_mask_key_list); i+=1)
		string mask_type = stringfromlist(i,sizing_mask_key_list)
		newdatafolder/o $mask_type
		string mask_list = stringbykey(mask_type, sizing_mask_list,":",",")
		//string mask_list = "sizing_"+mask_type+"_mask_list"
		for (j=0; j<itemsinlist(sizing_ss_levels); j+=1)
			string basewave = inst+"_intN_as_"+stringfromlist(j,sizing_ss_levels)+"_SS"
			variable sslevel = str2num(stringfromlist(j,sizing_ss_levels_real))
			for (k=0; k<itemsinlist(mask_list); k+=1)
				//string masked_wave = ":"+ mask_type+":"+inst+"_intN_as_"+stringfromlist(j,sizing_ss_levels)+"_SS_"+stringfromlist(k,mask_list)
				string masked_wave = ":"+ mask_type+":"+"as_"+stringfromlist(j,sizing_ss_levels)+"_SS_"+stringfromlist(k,mask_list)
				//string masked_wave = ":"+mask_type+":test_wave"
				//string masked_wave = inst+"_intN_as_"+stringfromlist(j,sizing_ss_levels)+"_SS_"+stringfromlist(i,mask_list)
				duplicate/o $basewave $(masked_wave)
				wave mw = $(masked_wave)
				wave mask = $("root:"+sizing_mask_folder+":"+stringfromlist(k,mask_list))  
				wave ship_mask = $("root:"+sizing_mask_folder+":"+sizing_RHB_mask)
				// need 5 minute SS level "mask" to complete this.
				mw = mw*ship_mask*mask
				mw = (ccn_ss[p] == sslevel) ? mw[p] : NaN
			endfor
		endfor
		//wave mw = root:$"sizing_mask_folder:"+stringfromlist(
	endfor		
	// duplicate base waves (in intN) for each of the mask types and their iterations
	// mask each wave
	
End

Function sizing_mask_dist(inst, tb)

	string inst
	variable tb

	string sizing_mask_list = sizing_init_mask_list()
	string sizing_mask_key_list = sizing_init_mask_key_list()
	
	
	string sdf = getdatafolder(1)
	string fldr = inst + ":data_"+num2str(tb)+"sec"
	setdatafolder ("root:"+fldr)
	newdatafolder/o/s masked
	newdatafolder/o/s avgDist
	
	// this explicitly points to Trish's mask datetime wave - if you need to put it on a diff tb, change here.
	//wave maskdt_w = root:$(sizing_mask_folder):DL_starttime_5m
	wave maskdt_w = root:$(sizing_mask_folder):DL_starttime_1m
	variable startdt_mask = maskdt_w[0]
	variable stopdt_mask = maskdt_w[numpnts(maskdt_w)-1]
	
	// "correct" 1m SS_Setting data to actual SS values (not set points)
	wave ccn_dt = root:$(sizing_mask_folder):ccn:ccn_datetime
	wave ccn = root:$(sizing_mask_folder):ccn:CCN_1min
	duplicate/o root:$(sizing_mask_folder):ccn:SS_Setting root:$(sizing_mask_folder):ccn:SS_Setting_cleaned
	wave ccn_ss = root:$(sizing_mask_folder):ccn:SS_Setting_cleaned
	variable ccni
	for (ccni=0; ccni<numpnts(ccn_ss); ccni+=1)
		if ((ccn_ss[ccni] > 0.28) && (ccn_ss[ccni] < 0.32))
			ccn_ss[ccni] = 0.22
		elseif ((ccn_ss[ccni] > 0.54) && (ccn_ss[ccni] < 0.58))
			ccn_ss[ccni] = 0.44
		elseif ((ccn_ss[ccni] > 0.80) && (ccn_ss[ccni] < 0.84))
			ccn_ss[ccni] = 0.65
		elseif ((ccn_ss[ccni] > 1.07) && (ccn_ss[ccni] < 1.11))
			ccn_ss[ccni] = 0.84
		elseif ((ccn_ss[ccni] > 1.33) && (ccn_ss[ccni] < 1.37))
			ccn_ss[ccni] = 1.00
		else
			ccn_ss[ccni] = NaN
		endif
	endfor	
	
	
	variable i,j,k
	// copy the "latest" NH4SO4_SS_intN waves to our mask folder
	//for (i=0; i<itemsinlist(sizing_ss_levels); i+=1)
		
		// for some reason, I had to put single quotes around the wave name in oldwave. ??
		string olddtwav = "root:"+fldr+ ":"+inst+"_datetime"
		//string oldwav = "root:"+fldr+ ":"+inst+"_intN_as_"+stringfromlist(i,sizing_ss_levels)+"_SS"
		//string newwav = inst+"_intN_as_"+stringfromlist(i,sizing_ss_levels)+"_SS"
		string oldwav = "root:"+fldr+ ":"+inst+"_dNdlogDp"
		string newwav = inst+"_dNdlogDp"
		wave olddt = $olddtwav
		wave old = $oldwav
		//acg_adjust_wave_to_datetime(startdt_mask, stopdt_mask, tb, maskdt_w, old, "mask_datetime", newwav)
		acg_expand_wave_to_tb(startdt_mask, stopdt_mask, tb, 60, olddt, old, "mask_datetime", newwav,0)
		//duplicate/o $oldwav $newwav
		//print oldwav, newwav
	//endfor 

	// create folders for each of the mask types
	for (i=0; i<itemsinlist(sizing_mask_key_list); i+=1)
		string mask_type = stringfromlist(i,sizing_mask_key_list)
		newdatafolder/o $mask_type
		string mask_list = stringbykey(mask_type, sizing_mask_list,":",",")
		//string mask_list = "sizing_"+mask_type+"_mask_list"
		string basewave = inst+"_dNdlogDp"
		string masked_wave = inst+"_dNdlogDp_mask"
		for (j=0; j<itemsinlist(sizing_ss_levels); j+=1)
			variable sslevel = str2num(stringfromlist(j,sizing_ss_levels_real))
			for (k=0; k<itemsinlist(mask_list); k+=1)
				//string masked_wave = ":"+ mask_type+":"+inst+"_intN_as_"+stringfromlist(j,sizing_ss_levels)+"_SS_"+stringfromlist(k,mask_list)
			//	string masked_wave = ":"+ mask_type+":"+"as_"+stringfromlist(j,sizing_ss_levels)+"_SS_"+stringfromlist(k,mask_list)
				//string masked_wave = ":"+mask_type+":test_wave"
				//string masked_wave = inst+"_intN_as_"+stringfromlist(j,sizing_ss_levels)+"_SS_"+stringfromlist(i,mask_list)
				duplicate/o $basewave $(masked_wave)
				wave mw = $(masked_wave)
				wave mask = $("root:"+sizing_mask_folder+":"+stringfromlist(k,mask_list))  
				wave ship_mask = $("root:"+sizing_mask_folder+":"+sizing_RHB_mask)
				// need 5 minute SS level "mask" to complete this.
				mw = mw[p][q]*ship_mask[p]*mask[p]
				mw = (ccn_ss[p] == sslevel) ? mw[p][q] : NaN
				string avgdist_wave = ":"+ mask_type+":"+"avg_"+stringfromlist(j,sizing_ss_levels)+"_"+stringfromlist(k,mask_list)
				make/o/n=(dimsize(mw,1)) $avgdist_wave
				wave avgdist = $avgdist_wave
				avgdist = NaN
				string stdevdist_wave = ":"+ mask_type+":"+"sd_"+stringfromlist(j,sizing_ss_levels)+"_"+stringfromlist(k,mask_list)
				make/o/n=(dimsize(mw,1)) $stdevdist_wave
				wave stdevdist = $stdevdist_wave
				stdevdist=NaN
				
				variable dpi=0
				for (dpi=0; dpi<dimsize(mw,1); dpi+=1)
					make/o/n=(dimsize(mw,0)) dpcol
					dpcol = mw[p][dpi]
					wavestats/Q dpcol
					avgdist[dpi] = V_avg
					stdevdist[dpi] = V_sdev
					killwaves/Z dpcol
				endfor
				killwaves/Z mw
			endfor
		endfor
		//wave mw = root:$"sizing_mask_folder:"+stringfromlist(
	endfor		

//	variable avg, cnt
//	for (j=0;j<dimsize(dw,1); j+=1)
//
//		avg=0
//		cnt=0
//		for (i=starti; i<=stopi; i+=1)
//			if (numtype(dw[i][j]) == 0)
//				avg+=dw[i][j]
//				cnt+=1
//			endif
//		endfor
//		dWdlogDp[j] = avg / cnt
//	endfor	

End

// <<<-- insert filter code from bak file -->>>
Function sizing_filter_with_cn(inst,tb)
	string inst
	variable tb

	if (!waveexists($(sizing_cn_filter_folder + ":" + sizing_dt_filter_name))	|| !waveexists($(sizing_cn_filter_folder + ":" + sizing_cn_filter_name))	)
		return 0
	endif

	// calculate cleaning nan_wave: <inst>_filter_nan
	wave cn_dt = $(sizing_cn_filter_folder + ":" + sizing_dt_filter_name)	
	wave cn = $(sizing_cn_filter_folder + ":" + sizing_cn_filter_name)

	string sdf = getdatafolder(1)
	setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	
	// create subfolder and copy all the base waves over
	newdatafolder/o/s filter
	duplicate/o ::$(inst+"_dp") $(inst+"_dp") 
	duplicate/o ::$(inst+"_dpa") $(inst+"_dpa") 
	duplicate/o ::$(inst+"_dp_native") $(inst+"_dp_native") 

	duplicate/o ::$(inst+"_datetime") $(inst+"_datetime") 
	wave dt = $(inst+"_datetime") 
	
	duplicate/o ::$(inst+"_density_w") $(inst+"_density_w") 

	duplicate/o ::$(inst+"_dNdlogDp") $(inst+"_dNdlogDp") 
	wave dndlogdp = $(inst+"_dNdlogDp") 
	
	make/o/n=(numpnts(dt)) $(inst+"_filter_nan") 
	wave filter_nan = $(inst+"_filter_nan") 
	SetScale/P x dt[0],tb,"dat", filter_nan
	filter_nan = 0

	
	variable offset = floor(tb/sizing_cn_filter_tb)
	make/o/n=(numpnts(dt)) $(inst+"_cn_avg")
	wave cn_avg = $(inst+"_cn_avg")
	cn_avg = NaN
	make/o/n=(numpnts(dt)) $(inst+"_cn_stdev")
	wave cn_stdev = $(inst+"_cn_stdev")
	cn_stdev = NaN
	
	variable i,j,k
	for (i=0; i<numpnts(dt); i+=1)
		variable index = x2pnt(cn,dt[i])
		if ( (index >=0) && (index < numpnts(cn)) )
			wavestats/q/R=[index,index+offset] cn
			cn_avg[i] = V_avg
			cn_stdev[i] = V_sdev
		endif
	endfor
	
	filter_nan = ( (cn_stdev[p]/cn_avg[p]*100 > sizing_cn_filter_threshold) || (numtype(cn_stdev[p]/cn_avg[p]) != 0) )? 1 : 0
	filter_nan = (numtype(cn_avg[p]) > 0) ? 1 : filter_nan[p]
	
	// filter the dNdlogDp
	dndlogdp[][] = (filter_nan[p] == 1) ? NaN : dndlogdp[p][q]

	// removed with the addition of sizing_reprocess_inst_data
//	// reprocess_data	
//	sizing_reprocess_data(inst,tb,1)
//	add_aero_diams(inst,tb,1)
//	convert_NtoSVM(inst,tb,1)
//	integrate_NSVM(inst,tb,1)	
//	create_im_plot_params(inst,tb,1)
	
	setdatafolder sdf

	return 1
	
End

// <<<-- end insert -->>>

// 
Function sizing_find_critical_dp(inst,tb,Conc_dt, Conc_crit,diam_type)
	string inst
	variable tb
	variable Conc_dt
	variable Conc_crit
	//string fraction
	variable diam_type // 0=geom, 1=aero, 2=vac aero
	diam_type = (diam_type <0 || diam_type>2) ? 1 : diam_type // set to aero if diam_type not of known type

	if ( (numtype(Conc_crit) != 0) || (Conc_crit <= 0) ) 
		return NaN
	endif 

	string sdf = getdatafolder(1)
//	setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	
	//wave smps = smps_dNdlogDp
	string twod_suffix = ""
	if (cmpstr(inst,"dmps_aps") == 0)
		twod_suffix="_2d"
	endif
	wave smps = $(inst+"_dNdlogDp"+twod_suffix)
	//wave dp = smps_dp
	wave dp = $(inst+"_dp")
	
	string dplist = "_dp_um;_dpa_um;_dpva_um"
	//wave dpa = $(inst+"_dpa_um")
	wave dpa = $(inst+stringfromlist(diam_type,dplist))
	
	
	wave dt = $(inst+"_datetime")
	//duplicate/o smps smps_dN, smps_dS, smps_dV, smps_dM, smps_dlogDp 
	//duplicate/o smps $(inst+"_dN"), $(inst+"_dS"), $(inst+"_dV"), $(inst+"_dM") 
	//duplicate/o dp smps_dlogDp 
	//duplicate/o dp $(inst+"_dlogDp") 
	wave dndlogdp = $(inst+"_dNdlogDp"+twod_suffix)

	//variable samp_index = x2pnt(dndlogdp,Conc_dt)
	variable samp_index =(Conc_dt - DimOffset(dndlogdp, 0))/DimDelta(dndlogdp,0) // have to use this to round down to the start time.
	samp_index = floor(samp_index)
	//print Conc_dt, Conc_crit, samp_index, floor(samp_index), samp_index2, floor(samp_index2)
	//return 0

	variable rows = dimsize(dndlogdp,0)
	variable cols = dimsize(dndlogdp,1)
	make/o/n=(cols)/d dndlogdp_1d
	wave oneD = dndlogdp_1d
	variable cnt
	for (cnt=0; cnt<cols; cnt+=1)
		oneD[cnt] = dndlogdp[samp_index][cnt]
	endfor
	
//	make/o/n=(rows)/d $(inst+"_intN_"+fraction)
	make/o/n=(cols*10)/d dndlogdp_1d_fit_dp
	wave oneD_fit_dp = dndlogdp_1d_fit_dp	

	variable start_dp = dp[0]
	variable stop_dp = dp[numpnts(dp)-1]
	oneD_fit_dp[0] = start_dp
	oneD_fit_dp[1,] = oneD_fit_dp[p-1]*10^(log(stop_dp/start_dp)/(cols*10))

	sizing_interp_nan_gap(oneD_fit_dp, dp, oneD, "dndlogdp_1d_fit")
	wave oneD_fit = dndlogdp_1d_fit
	//edit oneD_fit_dp, oneD_fit
	
	duplicate/o oneD_fit_dp $(inst+"_dlogDp_for_Dpcrit") 

//	wave dsdlogdp = $(inst+"_dSdlogDp")
//	wave ds = $(inst+"_dS")
//	wave dvdlogdp = $(inst+"_dVdlogDp")
//	wave dv = $(inst+"_dV")
//	wave dmdlogdp = $(inst+"_dMdlogDp")
//	wave dm = $(inst+"_dM")
	
	wave dlogDp = $(inst+"_dlogDp_for_Dpcrit")
	string DpBounds_name = "dp_bounds"
	//getDpBounds(dp,DpBounds_name)
	//wave bounds = $DpBounds_name
	dlogDp = log(oneD_fit_dp[p+1]/oneD_fit_dp[p])
	dlogDp[numpnts(dlogDp)-1] = dlogDp[numpnts(dlogDp)-2]
	
	duplicate/o oneD_fit $(inst+"_dN_for_Dpcrit") 
	wave dn = $(inst+"_dN_for_Dpcrit")
	dn = oneD_fit*dlogDp
	
	variable i, summ=0, crit_dp=NaN
	for (i=numpnts(dn)-1; i>=0; i-=1)
		if (summ+dn[i] > Conc_crit)
			crit_dp = ( (i>numpnts(dn)-1) || (i<0) ) ? NaN : oneD_fit_dp[i]
			break
		else
			summ+=dn[i]
		endif
	endfor

	// killwaves
	return crit_dp
	
	
//	ds = dsdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intS_"+fraction)
//
//	dv = dvdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intV_"+fraction)
//
//	dm = dmdlogdp*dlogDp
//	make/o/n=(rows)/d $(inst+"_intM_"+fraction)
//	
//	wave intN = $(inst+"_intN_"+fraction)
//	SetScale/P x dt[0],tb,"dat", intN
//	wave intS = $(inst+"_intS_"+fraction)
//	SetScale/P x dt[0],tb,"dat", intS
//	wave intV = $(inst+"_intV_"+fraction)
//	SetScale/P x dt[0],tb,"dat", intV
//	wave intM = $(inst+"_intM_"+fraction)
//	SetScale/P x dt[0],tb,"dat", intM
//	variable i,j
//	for (i=0; i<rows; i+=1)
//		intN[i]=0
//		intS[i]=0
//		intV[i]=0
//		intM[i]=0
//		for (j=0; j<cols; j+=1)
//			if ( cmpstr(fraction,"sub1")==0 ) // Dp < 1um
//				if (dpa[j] <= 1.0)
//					intN[i] += dN[i][j]
//					intS[i] += dS[i][j]
//					intV[i] += dV[i][j]
//					intM[i] += dM[i][j]
//				endif
//			elseif ( cmpstr(fraction,"super1sub10")==0 ) // 1um < Dp < 10um
//				if ( (dpa[j] > 1.0) && (dpa[j] <= 10.0) )
//					intN[i] += dN[i][j]
//					intS[i] += dS[i][j]
//					intV[i] += dV[i][j]
//					intM[i] += dM[i][j]
//				endif
//			elseif ( cmpstr(fraction,"super0.5sub1")==0 ) // 0.5um < Dp < 1um
//				if ( (dpa[j] > 0.5) && (dpa[j] <= 1.0) )
//					intN[i] += dN[i][j]
//					intS[i] += dS[i][j]
//					intV[i] += dV[i][j]
//					intM[i] += dM[i][j]
//				endif
//			else
//				variable ss = 0
//				for (ss=0; ss<itemsinlist(ammsulf_sat_levels); ss+=1)
//					if (cmpstr(fraction, stringfromlist(ss,ammsulf_sat_levels)) == 0) 
//						variable low_dp = str2num(stringfromlist(ss,ammsulf_sat_Dp))
//						if ( dpa[j] > low_dp  )
//							intN[i] += dN[i][j]
//							intS[i] += dS[i][j]
//							intV[i] += dV[i][j]
//							intM[i] += dM[i][j]
//						endif
//					endif
//				endfor
//				
//			endif
//		endfor
//	endfor 
	
	
	killwaves/Z dn, ds, dv, dm, dlogDp
	setdatafolder sdf
End	

Function sizing_ccn_critical_dp(ccn_tb, inst, inst_tb)
	variable ccn_tb // ccn timebase
	string inst // instrument to use to compute dcrit
	variable inst_tb // instrument timebase
	
	string sdf = getdatafolder(1)
	
	string df = "root:ccn:avg_"+num2str(ccn_tb)
	//setdatafolder root:Masks_1m:ccn
	//setdatafolder root:Masks_1m:ccn:avg_900
	//setdatafolder root:ccn
	setdatafolder df	
	
	// hard wired data for now
	//wave conc = CCN_1min
	//wave dt = ccn_datetime
	//wave conc = ccn_conc_300
	//wave dt = ccn_datetime_300
	//wave conc = CCN_Conc5_900
	//wave dt = sizing_dt
	wave conc = CCN_Concentration_Cleaned
	wave dt = date_time

	//duplicate/o conc ccn_crit_dp, ccn_crit_dp_0_5
	//wave crit_dp = ccn_crit_dp
	//wave crit_dp_0_5 = ccn_crit_dp_0_5
	//duplicate/o conc ccn5_crit_dp_900, ccn5_crit_dp_0_5_900
	//wave crit_dp = ccn5_crit_dp_900
	//wave crit_dp_0_5 = ccn5_crit_dp_0_5_900
	duplicate/o conc ccn_crit_dp, ccn_crit_dp_0_5
	wave crit_dp = ccn_crit_dp
	wave crit_dp_0_5 = ccn_crit_dp_0_5
	
	variable i
	for (i=0; i<numpnts(crit_dp); i+=1)
		//print i, " of ", numpnts(crit_dp)
		crit_dp[i] = sizing_find_critical_dp(inst,inst_tb,dt[i], conc[i],0)
		crit_dp_0_5[i] = sizing_find_critical_dp(inst,inst_tb,dt[i], conc[i]/2,0)
	endfor
	setdatafolder sdf
End

Function sizing_ccn_to_tb_by_ss(inst,tb)
	string inst
	variable tb
	
	string sdf = getdatafolder(1)
	setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	wave smps_dt = $(inst+"_datetime")

	setdatafolder root:Masks_1m:ccn
	
	wave ccn_conc = CCN_1min
	wave ccn_dt = ccn_datetime
	wave ccn_ss = SS_Setting_cleaned
	
	duplicate/o smps_dt $("ccn_datetime_"+num2str(tb))
	wave new_dt = $("ccn_datetime_"+num2str(tb))
	
	make/o/n=(numpnts(new_dt)) $("ccn_conc_"+num2str(tb)), $("ccn_SS_"+num2str(tb))
	wave new_conc = $("ccn_conc_"+num2str(tb))
	wave new_ss = $("ccn_SS_"+num2str(tb))
	new_conc = NaN
	new_ss = NaN
	
	variable i, starti, stopi
	for (i=0; i<numpnts(new_dt)-1; i+=1)
		starti = BinarySearch(ccn_dt,new_dt[i])
		stopi = BinarySearch(ccn_dt,new_dt[i+1])
		
		if (starti>=0 || stopi>=0)
		
			variable j, k, curr_ss, curr_ss_cnt, curr_ss_starti, curr_ss_stopi
			for (j=0; j<itemsinlist(sizing_ss_levels_real); j+=1)
				curr_ss = str2num(stringfromlist(j,sizing_ss_levels_real))
				curr_ss_cnt = 0
				for (k=starti; k<stopi; k+=1)
					if (ccn_ss[k] == curr_ss)
						if (curr_ss_cnt == 0)
							curr_ss_starti = k
						else
							curr_ss_stopi = k
						endif
						curr_ss_cnt+=1
					endif
					
					if (curr_ss_cnt >= 3)
						new_ss[i] = curr_ss
						wavestats/Q/R=[curr_ss_starti, curr_ss_stopi] ccn_conc
						new_conc[i] = V_avg
						break
					endif
				endfor
			endfor
		endif
	endfor
	setdatafolder sdf

End

Function sizing_adjust_aitken_channels()
	string inst = "dmps"
	variable tb = general_defaultTimeBase
	variable last_aitken_channel = 9 // 1 based
	string sdf = getdatafolder(1)
	string fldr = inst + ":data_"+num2str(tb)+"sec"
	setdatafolder ("root:"+fldr)
	
	wave dmps = $(inst+"_dNdlogDp")
	if (!waveexists($(inst+"_dNdlogDp_preFix")))
		duplicate/o dmps $(inst+"_dNdlogDp_preFix")
	endif
	wave dmps_preFix = $(inst+"_dNdlogDp_preFix")
	variable row,col
	for (row=0; row<dimsize(dmps,0); row+=1)
		for (col=0; col<last_aitken_channel; col+=1)
			dmps[row][col] =  dmps_preFix[row][col]*0.85
		endfor
	endfor
		
	setdatafolder sdf	
End

Function sizing_therm_clean(param)
	string param
	string sdf = getdatafolder(1)
	setdatafolder sizing_thermo_folder
	
	wave tparm = $param
	wave start_dt = start_datetime  // these two hardwired for now
	wave stop_dt = stop_datetime

	make/o/n=8 D50_diameters
	wave d50 = D50_diameters
	d50 = {0.01,0.144,0.297,0.543,1.059,2.022,4.128,10.272}
	make/o/n=7 midpoint_diameters
	wave midpt = midpoint_diameters
	midpt = sqrt(d50[p]*d50[p+1])
	
	tparm[][] = (tparm[p][q] == -999) ? NaN : tparm[p][q] 
	//tparm[][] = (numtype(tparm[p][q]) > 0) ? -999: tparm[p][q] 
	//tparm[][] = (numtype(tparm[p][q]) > 0) ? interp2D(tparm,p,q) : tparm[p][q] 
	//tparm[][] = (numtype(tparm[p][q]) > 0) ? -999 : tparm[p][q] 

	variable i,j,k,has_nan
	for (i=0; i<dimsize(tparm,0); i+=1)
		has_nan=0
		for (j=0; j<dimsize(tparm,1); j+=1)
			//print i,j, numtype(tparm[i][j])
			if (numtype(tparm[i][j])>0)
				has_nan = 1
			endif
		endfor
		if (has_nan > 0)
			make/o/n=(dimsize(tparm,1)) tmp_d
			wave tmpd = tmp_d
			tmpd = tparm[i][p]
			sizing_interp_nan_gap(midpt, midpt, tmpd, "fit_density")	
			wave tmp = $("fit_density")
			tparm[i][] = tmp[q]
			killwaves tmp, tmp_d
		endif
		
	endfor	
	
//	variable i,j,k
//	for (i=0; i<dimsize(tparm,0); i+=1)
//		for (j=0; j<dimsize(tparm,1); j+=1)
//			if (numtype(tparm[i][j]) > 0)
//				if (j==0) 
//					variable all_nan = 1
//					for (k=1; k<dimsize(tparm,1); k+=1)
//						if (numtype(tparm[i][k] == 0)
//							tparm[i][0,k-1] = tparm[i][k]
//							all_nan = 0
//						endif
//					endfor
//					if (all_nan)
//						tparm[i][0,dimsize(tparm,1)-1]	= 1.0
//					endif
//				elseif (j == dimsize(tparm,1) -1)
//					variable all_nan = 1
//					for (k=dimsize(tparm)-2; k>=0; k-=1)
//						if (numtype(tparm[i][k] == 0)
//							tparm[i][k+1,dimsize(tparm,1)-1] = tparm[i][k]
//							all_nan = 0
//						endif
//					endfor
//					if (all_nan)
//						tparm[i][0,dimsize(tparm,1)-1]	= 1.0
//					endif
//				else 
	
	
	print tparm[20][4], tparm(20)(4)
	setdatafolder sdf	
End

Function sizing_fit_thermo_to_time(tb,param)
	variable tb
	string param
	string sdf = getdatafolder(1)
	setdatafolder sizing_thermo_folder
	
	wave tparm = $param
	wave start_dt = start_datetime  // these two hardwired for now
	wave stop_dt = stop_datetime

	//wave inst_dt = root:dmps:data_300sec:dmps_datetime
	wave inst_dt = $("root:dmps:data_"+num2str(tb)+"sec:dmps_datetime")
	//wave inst_dt = $("root:smps:data_"+num2str(tb)+"sec:smps_datetime")
	
	variable i,j,k
	make/o/n=(numpnts(inst_dt),dimsize(tparm,1)) $(param+"_time_fit")
	wave tparm_fit = $(param+"_time_fit")
	tparm_fit = NaN
	make/o/n=(numpnts(inst_dt),2) time_index
	wave tindex = time_index 
	for (i=0; i<numpnts(inst_dt); i+=1)
		variable starti, stopi
		tindex[i][0] = BinarySearch(start_dt,inst_dt[i])
		tindex[i][1] = BinarySearch(stop_dt,inst_dt[i])
		starti = BinarySearch(start_dt,inst_dt[i])
		stopi = BinarySearch(stop_dt,inst_dt[i])
		
		if (starti==-1 && stopi==-1)
			tparm_fit[i][] = tparm[0][q]
		elseif (starti == -2)
			tparm_fit[i][] = tparm[dimsize(tparm,0)-1][q]
		elseif (starti != stopi)
			tparm_fit[i][] = tparm[starti][q]
		endif
	endfor
	
	for (i=0; i<dimsize(tparm_fit,1); i+=1)
		make/o/n=(dimsize(tparm_fit,0)) dens_col
		wave dcol = dens_col
		dcol = tparm_fit[p][i]
		sizing_interp_nan_gap(inst_dt, inst_dt, dcol, "fit_density_col")	
		wave tmp_col = fit_density_col
		tparm_fit[][i] = tmp_col[p]
		killwaves tmp_col, dens_col
	endfor
	
	setdatafolder sdf
End

Function sizing_shift_to_ambient(inst,tb,isFilter,instIsSamp,shape) // hardwired to inst=dmps_aps for now
	string inst
	variable tb
	variable isFilter
	variable instIsSamp
	string shape
	
	string sdf = getdatafolder(1)
	
	// hardwired for now:
	inst = "dmps_aps"
	
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif
	
//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
	
	wave inst_dt = $(inst+"_datetime")
	wave dp_um = $(inst+"_dp_um_2d")

	// find gf @ inst dp (geom)
	//sizing_get_gf_1d(inst, tb, inst_dt, dp_um,"geom",(inst+"_gf_2d"),0)
	sizing_get_gf_2d(inst, tb, dp_um,"geom","samp_amb",(inst+"_gf_2d"),isFilter,shape)
	wave gf_2d = $(inst+"_gf_2d")
	
	duplicate/o dp_um $(inst+"_dp_um_amb_2d")
	wave dp_um_amb_2d = $(inst+"_dp_um_amb_2d")
	// shift size dist
	dp_um_amb_2d *= gf_2d

//	duplicate/o $(inst+"_dNdlogDp"+shapestr+"_2d")  $(inst+"_dNdlogDp"+shapestr+"_amb_2d") 
//	wave dNdlogDp_2d = $(inst+"_dNdlogDp"+shapestr+"_2d") 
//	wave dNdlogDp_amb_2d = $(inst+"_dNdlogDp"+shapestr+"_amb_2d") 
	duplicate/o $(inst+"_dNdlogDp"+"_2d")  $(inst+"_dNdlogDp"+"_amb_2d") 
	wave dNdlogDp_2d = $(inst+"_dNdlogDp"+"_2d") 
	wave dNdlogDp_amb_2d = $(inst+"_dNdlogDp"+"_amb_2d") 
	wave dp_um_2d = dmps_aps_dp_um_2d
	
	variable i,j
	for (i=0; i<dimsize(dNdlogDp_2d,0); i+=1)

		
			
		make/o/n=(dimsize(dp_um_2d,1)) dp_w
		make/o/n=(dimsize(dp_um_2d,1)) dp_amb_w
		make/o/n=(dimsize(dp_um_2d,1)) dn_w
		make/o/n=(dimsize(dp_um_2d,1)) dens_w
		dp_w = dp_um_2d[i][p]
		dp_amb_w = dp_um_amb_2d[i][p]
		dn_w = dNdlogDp_2d[i][p]

		// interp onto standard dp wave using the above
		sizing_interp_nan_gap(dp_w, dp_amb_w, dn_w, "single_dn_amb_w")
		wave out = $"single_dn_amb_w"
		dNdlogDp_amb_2d[i][] = out[q]
				
	endfor

	// add extra parameters for convenience
	add_aero_diams_2d("dmps_aps",tb,isFilter,1,shape)
	convert_NtoSVM_2d("dmps_aps",tb,isFilter,1,1,shape)
	integrate_NSVM_2d("dmps_aps",tb,isFilter,1,shape)	

	integrate_NSVM_fraction_2d("dmps_aps",tb,"sub1",1,isFilter,1,shape)	
	integrate_NSVM_fraction_2d("dmps_aps",tb,"super1sub10",1,isFilter,1,shape)	

	setdatafolder sdf

End

Function sizing_shift_dmps_to_sample(inst,tb,isFilter,shape) // hardwired to inst=dmps for now
	string inst
	variable tb
	variable isFilter
	string shape
	
	string sdf = getdatafolder(1)
	
	// hardwired for now:
	inst = "dmps"
	
//	string shapestr
//	if (cmpstr(shape,"doublet") == 0)
//		shapestr = "_doub"
//	elseif (cmpstr(shape,"triplet") == 0)
//		shapestr = "_trip"
//	else
//		shapestr = ""
//	endif 
		
	convert_NtoSVM_2d(inst,tb,isFilter,0,0,shape)
	
	//setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	// new approach for doublet/triplets/etc
	if (cmpstr(shape,"sphere") != 0)
		if ( (cmpstr(inst,"aps")==0) || (cmpstr(inst,"dmps_aps")==0) )
			if (!datafolderexists(shape))
				sizing_create_shape_subfolder(inst,shape)
			else
				setdatafolder :$(shape)
			endif
		endif
	endif

	wave inst_dt = $(inst+"_datetime")
//	wave dp_um = $(inst+"_dp_um"+shapestr+"_2d")
	wave dp_um = $(inst+"_dp_um_2d")

	// find gf @ inst dp (geom)
	//sizing_get_gf_1d(inst, tb, inst_dt, dp_um,"geom",(inst+"_gf_2d"),0)
	sizing_get_gf_2d(inst, tb, dp_um,"geom","dmps_samp",(inst+"_gf_dmps_samp_2d"),isFilter,shape)
	wave gf_2d = $(inst+"_gf_dmps_samp_2d")
	
//	duplicate/o dp_um $(inst+"_dp_um_samp"+shapestr+"_2d")
	duplicate/o dp_um $(inst+"_dp_um_samp_2d")
//	wave dp_um_samp_2d = $(inst+"_dp_um_samp"+shapestr+"_2d")
	wave dp_um_samp_2d = $(inst+"_dp_um_samp_2d")
	// shift size dist
	dp_um_samp_2d *= gf_2d

//	duplicate/o $(inst+"_dNdlogDp_2d")  $(inst+"_dNdlogDp_samp"+shapestr+"_2d") 
	duplicate/o $(inst+"_dNdlogDp_2d")  $(inst+"_dNdlogDp_samp_2d") 
	wave dNdlogDp_2d = $(inst+"_dNdlogDp_2d") 
//	wave dNdlogDp_samp_2d = $(inst+"_dNdlogDp_samp"+shapestr+"_2d") 
	wave dNdlogDp_samp_2d = $(inst+"_dNdlogDp_samp_2d") 
//	wave dp_um_2d = $(inst+"_dp_um"+shapestr+"_2d")
	wave dp_um_2d = $(inst+"_dp_um_2d")
	
	variable i,j
	for (i=0; i<dimsize(dNdlogDp_2d,0); i+=1)

		
			
		make/o/n=(dimsize(dp_um_2d,1)) dp_w
		make/o/n=(dimsize(dp_um_2d,1)) dp_samp_w
		make/o/n=(dimsize(dp_um_2d,1)) dn_w
		make/o/n=(dimsize(dp_um_2d,1)) dens_w
		dp_w = dp_um_2d[i][p]
		dp_samp_w = dp_um_samp_2d[i][p]
		dn_w = dNdlogDp_2d[i][p]

		// interp onto standard dp wave using the above
		sizing_interp_nan_gap(dp_w, dp_samp_w, dn_w, "single_dn_samp_w")
		wave out = $"single_dn_samp_w"
		dNdlogDp_samp_2d[i][] = out[q]
				
	endfor

	//sizing_merge_dmps_aps_2d(tb,isFilter,1,0)

	// add extra parameters for convenience
//	add_aero_diams_2d("dmps_aps",tb,0,1)
//	convert_NtoSVM_2d("dmps_aps",tb,0,1)
//	integrate_NSVM_2d("dmps_aps",tb,0,1)	
//
//	integrate_NSVM_fraction_2d("dmps_aps",tb,"sub1",1,0,1)	
//	integrate_NSVM_fraction_2d("dmps_aps",tb,"super1sub10",1,0,1)	

	setdatafolder sdf

End

Function sizing_process_2d()

	// Note: for the 2d merge to work properly, run the assumed density merge first

	string sdf  = getdatafolder(1)

	variable tb = general_defaultTimeBase
	string inst
	variable isFilter=0
	variable isAmbient=0
	variable dmpsIsSamp=0
	variable apsIsSamp=0
	variable isModified=0
	string fraction
	variable diam_type
	string shape = "sphere"
	
	string inst_list = "dmps;aps;dmps_aps"	
	
	print ""
	print "-----------------------------------------------------------"
	print "Process 2d data - this will take a while..."
	print "-----------------------------------------------------------"
	print ""
	
if (1)
	print "--- UNFILTERED DISTRIBUTIONS ---"
	print ""
	isFilter = 0
	isAmbient = 0
	print "	merge dmps and aps (constant density)"
	sizing_merge_dmps_aps(tb,isFilter)

	inst = "dmps"
	print "    reprocess 1d data"
	//sizing_reprocess_data(inst,tb,isFilter)
	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape) // Add shape argument
	print "	shift dmps values from meas RH to imp sample RH"
	inst = "dmps"
	//sizing_shift_dmps_to_sample(inst,tb,isFilter,shape) 
	//dmpsIsSamp = 1
	//apsIsSamp = 0
	//isModified = 1

	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super1sub10",diam_type,isFilter,isAmbient,shape)
	
	inst = "aps"
	isModified=0
	print "    reprocess 1d data"
	//sizing_reprocess_data(inst,tb,isFilter)
	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)
	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super1sub10",diam_type,isFilter,isAmbient,shape)

	print "	merge dmps and aps (calculated density)"
	sizing_merge_dmps_aps_2d(tb,isFilter,dmpsIsSamp,apsIsSamp,shape)

endif

return 0

if (0)

	print "	shift dmps_aps to ambient RH"
	inst = "dmps_aps"
	sizing_shift_to_ambient(inst,tb,isFilter,(dmpsIsSamp || apsIsSamp),shape)

endif

if (0)
	print "--- FILTERED DISTRIBUTIONS ---"
	isFilter = 1
	isAmbient = 0
	
	print "	merge dmps and aps (constant density)"
	sizing_merge_dmps_aps(tb,isFilter)


	inst = "dmps"

	//sizing_filter_with_cn(inst,tb)

	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)

	print "	shift dmps values from meas RH to imp sample RH"
	inst = "dmps"
	//sizing_shift_dmps_to_sample(inst,tb,isFilter,shape)
	//dmpsIsSamp = 1
	//apsIsSamp = 0
	//isModified = 1

	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super1sub10",diam_type,isFilter,isAmbient,shape)

	inst = "aps"
	isModified = 0
	//isModified=0 // <-- removed this to go back to orig?

	//sizing_filter_with_cn(inst,tb)

	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)
	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super1sub10",diam_type,isFilter,isAmbient,shape)

	print "	merge dmps and aps (calculated density)"
	sizing_merge_dmps_aps_2d(tb,isFilter,dmpsIsSamp,apsIsSamp,shape)

endif

if (0)

	print "	shift dmps_aps to ambient RH"
	inst = "dmps_aps"
	sizing_shift_to_ambient(inst,tb,isFilter,(dmpsIsSamp || apsIsSamp),shape)

endif	

	print "Done."
	
	setdatafolder sdf
End	

Function sizing_get_dp_at_max(dt,dp,dw,dp_units,output_name)
	wave dt  // datetime
	wave dp // diameter
	wave dw // 2d distribution
	string dp_units // "nm" or "um"
	string output_name

	sizing_get_dp_at_max_fraction(dt,dp,dw,0,dp_units,output_name)
End
// find the diameter of the maximum of distribution dw
Function sizing_get_dp_at_max_fraction(dt,dp,dw,fraction,dp_units,output_name)
	wave dt  // datetime
	wave dp // diameter
	wave dw // 2d distribution
	variable fraction // portion of size distribution to consider...0=total, 1=sub1, 2=super1sub10
	string dp_units // "nm" or "um"
	string output_name
	
	make/o/n=(numpnts(dt)) $(output_name)
	wave maxdp = $(output_name)
	maxdp = NaN
	
	variable lower_dp, upper_dp
	if (fraction == 0)
		lower_dp=0
		upper_dp=1e12
	elseif (fraction == 1)
		lower_dp=0
		upper_dp=1
	elseif (fraction == 2)
		lower_dp = 1
		upper_dp = 1e12
	endif
	if (cmpstr(dp_units,"nm") == 0)
		lower_dp *= 1000
		upper_dp *= 1000
	endif
	
	variable i,j
	variable maxj, maxw
	for (i=0; i<numpnts(dt); i+=1)
		maxj=-1
		maxw=0
		for (j=0; j<numpnts(dp); j+=1)
			if (numtype(dw[i][j]) == 0 && dw[i][j] > maxw && dp[j]>lower_dp && dp[j] <= upper_dp)
				maxw=dw[i][j]
				maxj=j
			endif
		endfor
		if (maxj >= 0)
			maxdp[i] = dp[maxj]
		endif
	endfor
End

Function sizing_merge_as_waves(inst,tb,param_name,isFilter)
	string inst
	variable tb
	string param_name
	variable isFilter
	
	string sdf = getdatafolder(1)
	
	wave ss_level = root:Masks_1m:ccn:ccn_SS_300
	
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	//sizing_ss_levels_real

	variable leveli
	wave template = $(inst+"_"+param_name+"_"+stringfromlist(0,ammsulf_sat_levels)) 
	duplicate/o template $(inst+"_"+param_name+"_as_SS")
	wave merge =  $(inst+"_"+param_name+"_as_SS")
	merge = NaN
	variable i
	for (i=0; i<numpnts(ss_level); i+=1)
		if (numtype(ss_level[i]) == 0)  // make sure ss_level is not NaN
			string level_str
			sprintf level_str, "%4.2f", ss_level[i]
			leveli = whichlistitem(level_str, sizing_ss_levels_real)
			if (leveli >= 0)  // if ss_level is in list of allowed SS levels
				wave as = $(inst+"_"+param_name+"_"+stringfromlist(leveli,ammsulf_sat_levels)) 
			 	merge[i] = as[i]
			endif
		endif
	endfor
	
//	for (level=1; level<itemsinlist(ammsulf_sat_levels); level+=1)
//		
//		wave ss = $(inst+"_"+param_name+"_"+stringfromlist(level,ammsulf_sat_levels)) 
//		merge = (numtype(ss) == 0) ? ss[p] : merge[p]
//	endfor
				
	setdatafolder sdf
End


//Function sizing_write_nsd_file(fd,id_str,version_str,doy, dp, dw,start_i, stop_i)
Function sizing_write_nsd_file(fd,id_str,version_str,dt,doy, lat, lon, dp, dw,start_i, stop_i)
	variable fd
	string id_str
	string version_str
	wave dt
	wave doy
	wave lat
	wave lon
	wave dp
	wave dw
	variable start_i
	variable stop_i
	
	variable BAD = -999.0
	
	if (start_i==0 && stop_i==0)
		start_i = 0
		stop_i = numpnts(doy)
	endif
//	variable rows = numpnts(doy)
	variable cols = numpnts(dp)
	
	// print headers
	//fprintf fd, "TexAQS-GoMACCS: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "ICEALOT: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "VOCALS: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "CalNex: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "UBWOS: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "WACS: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "UBWOS: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "WACS2: size distribution (" + id_str +") data - v" + version_str
	//fprintf fd, "NAAMES: size distribution (" + id_str +") data - v" + version_str
	fprintf fd, "NAAMES2: size distribution (" + id_str +") data - v" + version_str
	variable i,j
	
	for (j=0; j<cols-1;j+=1)
		fprintf fd,","
	endfor
	if (fd == 1)
		fprintf fd, "\r"
	else
		fprintf fd, "\n"
	endif
	
	// print header and col index
	fprintf fd,"DateTime, DOY, LAT, LONGT,"  // print empty space
	for (j=0; j<cols-1;j+=1)
		fprintf fd,"%d,", j+1
	endfor
	if (fd == 1)
		fprintf fd, "%d\r",j+1
	else
		fprintf fd, "%d\n",j+1
	endif
	
	// print diameters
	fprintf fd,",,,1,"  // print place holder
	for (j=0; j<cols-1;j+=1)
		fprintf fd,"%f,", dp[j]
	endfor
	if (fd == 1)
		fprintf fd, "%f\r",dp[j]
	else
		fprintf fd, "%f\n",dp[j]
	endif
	
	// print data
	//rows = 100
//	for (i=0;i<rows;i+=1)
	for (i=start_i;i<stop_i;i+=1)
		
		string dt_str = secs2date(dt[i],-2) + " " + secs2time(dt[i],3)

		fprintf fd,"%s, %f, %f, %f,"  dt_str,doy[i],lat[i],lon[i] // print doy

		for (j=0; j<cols-1;j+=1)
			if (numtype(dw[i][j]) == 0 )
				fprintf fd,"%f,", dw[i][j]
			else
				fprintf fd,"%f,", BAD
			endif
		endfor
		if (fd == 1)
			if (numtype(dw[i][j]) == 0 )
				fprintf fd,"%f\r", dw[i][j]
			else
				fprintf fd,"%f\r", BAD
			endif
//			fprintf fd, "%f\r",dw[i][j]
		else
			if (numtype(dw[i][j]) == 0 )
				fprintf fd,"%f\n", dw[i][j]
			else
				fprintf fd,"%f\n", BAD
			endif
		
//			fprintf fd, "%f\n",dw[i][j]
		endif
	endfor

End


Function sizing_write_nsd()
	
	//string file_path = "/home/lorax/derek/Data/Cruises/texaqs2006/dmps/final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:texaqs2006:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:texaqs2006:dmps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:ICEALOT:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:ICEALOT:sizing:dmps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:vocals:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:vocals:sizing:dmps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:calnex:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:calnex:sizing:dmps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Stations:Uintah:sizing:smps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Stations:Uintah:sizing:smps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Stations:Uintah:sizing:smps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:wacs:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:wacs:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Stations:Uintah:Jan2013:sizing:smps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Stations:Uintah:Jan2013:sizing:smps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:wacs2:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:wacs2:sizing:dmps:final_data"
//	NewPath/O/Q save_path, "Y:Data:Cruises:naames:Leg1:sizing:dmps:final_data"
//	NewPath/O/Q save_path_filter, "Y:Data:Cruises:naames:Leg1:sizing:dmps:final_data"
	NewPath/O/Q save_path, "Y:Data:Cruises:naames:Leg2:sizing:dmps:final_data"
	NewPath/O/Q save_path_filter, "Y:Data:Cruises:naames:Leg2:sizing:dmps:final_data"

	variable refNum
	string id_str, version_str,dist_type
	string fileName
	variable isFilter
	variable isAmbient
	string shape
	string inst
	variable tb
	string dw_name
	//added 23 April 2013
	string extra_path = ""
	string extra_suffix = ""
	
	string sdf = getdatafolder(1)
	Close/A
		
	//string fileName_base = "TexAQS-GoMACCS_"
	//string fileName_base = "TEXAQS2006_"
	//string fileName_base = "ICEALOT_"
	//string fileName_base = "VOCALS_"
	//string fileName_base = "CalNex_"
	//string fileName_base = "UBWOS_"
	//string fileName_base = "WACS_"
	//string fileName_base = "UBWOS2013_"
	//string fileName_base = "WACS2_"
	//string fileName_base = "NAAMES_"
	string fileName_base = "NAAMES2_"

	variable useVersionString = 1
	variable useProjectInfo = 1
	variable convert2doy=1

	variable tb_value = general_defaultTimeBase
if (1)
	// Section: dmps_dNdlogDp
	// ------ make changes here ------ //
	inst = "aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "aps"
	version_str = "0"
	isFilter = 0
	isAmbient = 0
	//dw_name = "dNdlogDp_2d_seasweep"
	//dw_name = "dNdlogDp_2d"
	//dw_name = "dNdlogDp"
	dw_name = "dNdlogDp_SeaSweep"
	
	// add lat, lon to file
	wave lat = root:met:LAT_300sec
	wave lon = root:met:LONGT_300sec
	
	//extra_path = "AMBIENT"
	extra_path = "SEASWEEP"
	extra_suffix = "SEASWEEP"
	//extra_suffix = "rh60_20151126_1135"
	//extra_path = "AMBIENT_DRY"
	//extra_suffix = "dry_20151118_0425"
	//extra_path = "SEASWEEP"
	//extra_suffix = "rh60_seasweep_20151126_1135"
	//extra_path = "SEASWEEP_DRY"
	//extra_suffix = "dry_seasweep_20151118_0425"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (cmpstr(extra_suffix,"") != 0)
		fileName += "_" + extra_suffix
	endif
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	
	wave dt = $(inst+"_datetime")
	if (convert2doy)
		//wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	wave dp = $(inst+"_dp_um")

	// change to extra path 
	if (cmpstr(extra_path,"") != 0)
		setdatafolder :$(extra_path)
	endif

	//wave dw = $(inst+"_"+dw_name+"_seasweep")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	variable start_dt, stop_dt
	variable start_index = 0
	variable stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		//wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	sizing_write_nsd_file(refNum,id_str,version_str, dt, doy, lat, lon, dp, dw,start_index,stop_index)
	Close refNum	
endif

////// Stop here for now

return 0

//////

if (0)  // do all WACS saves here
	// Section: dmps_dNdlogDp
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "dmps_aps"
	version_str = "2"
	isFilter = 0
	isAmbient = 1
	dw_name = "dNdlogDp_amb_2d"
	
	//extra_path = "AMBIENT" // remove for UBWOS2013
	extra_suffix = ""
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (cmpstr(extra_suffix,"") != 0)
		fileName += "_" + extra_suffix
	endif
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (cmpstr(extra_path,"") != 0)
		setdatafolder :$(extra_path)
	endif
	
	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif



if (0)	
	// Section: dmps_dNdlogDp_filter
	// ------ make changes here ------ //
	inst = "dmps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "dmps"
	version_str = "1"
	isFilter = 1
	isAmbient = 0
	dw_name = "dNdlogDp"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
		
	wave doy = $(inst+"_doy")
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif
if (0)
	// Section: smps_dNdlogDp
	// ------ make changes here ------ //
	inst = "smps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "smps"
	version_str = "0"
	isFilter = 0
	isAmbient = 0
	dw_name = "dNdlogDp"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	//variable start_dt, stop_dt
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif

if (0)
	// Section: aps_dNdlogDp (Dpa)
	// ------ make changes here ------ //
	inst = "aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "aps"
	version_str = "0"
	isFilter = 0
	isAmbient = 0
	shape = "sphere"
	dw_name = "dNdlogDp"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dpa_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif

if (0)
	// Section: aps_dNdlogDp (Dpa)
	// ------ make changes here ------ //
	inst = "aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "aps"
	version_str = "1"
	isFilter = 1
	isAmbient = 0
	shape = "sphere"
	dw_name = "dNdlogDp"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dpa_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif	
	return 0


/// STOP HERE FOR NOW...

	// Section: dmps_aps_dNdlogDp_2d
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 0
	isAmbient = 0
	shape = "sphere"
	dw_name = "dNdlogDp_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")

	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
if (1)	
	// Section: dmps_aps_dNdlogDp_amb_2d
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 0
	isAmbient = 1
	shape = "sphere"
	dw_name = "dNdlogDp_amb_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif	
	// Section: dmps_aps_dNdlogDp_2d (filter)
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 1
	isAmbient = 0
	shape = "sphere"
	dw_name = "dNdlogDp_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	

if (1)	
	// Section: dmps_aps_dNdlogDp_amb_2d (filter)
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "nsd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 1
	isAmbient = 1
	shape = "sphere"
	dw_name = "dNdlogDp_amb_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum		
endif	

	// Section: dmps_aps_dMdlogDp_2d
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "msd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 0
	isAmbient = 0
	shape = "sphere"
	dw_name = "dMdlogDp_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
	
if (1)
	// Section: dmps_aps_dMdlogDp_amb_2d
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "msd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 0
	isAmbient = 1
	shape = "sphere"
	dw_name = "dMdlogDp_amb_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif
	
	// Section: dmps_aps_dMdlogDp_2d (filter)
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "msd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 1
	isAmbient = 0
	shape = "sphere"
	dw_name = "dMdlogDp_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	

if (1)	
	// Section: dmps_aps_dMdlogDp_amb_2d (filter)
	// ------ make changes here ------ //
	inst = "dmps_aps"
	tb = tb_value
	dist_type = "msd"
	id_str = "dmps_aps"
	version_str = "1"
	isFilter = 1
	isAmbient = 1
	shape = "sphere"
	dw_name = "dMdlogDp_amb_2d"
	// --- end changes --- //
	
	fileName = fileName_base + dist_type + "_" + id_str
	if (isAmbient) 
		fileName += "_ambient"
	endif
	if (isFilter)
		fileName += "_filter"
	endif 
	if (useVersionString)
		fileName += "_v" + version_str 
	endif
	fileName += ".csv"
	print "Saving " + filename + "."
	Open/P=save_path refNum as fileName

	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

	if (convert2doy)
		wave dt = $(inst+"_datetime")
		datetime2doy_wave(dt, (inst+"_doy"))
	endif
	
	wave doy = $(inst+"_doy")
	
	if (cmpstr(shape,"sphere") == 0) 
		// do nothing
	else
		setdatafolder $shape
	endif
	
	wave dp = $(inst+"_dp_um")
	wave dw = $(inst+"_"+dw_name)
	//print refNum, s_fileName
	
	start_index = 0
	stop_index = 0
	if (useProjectInfo && acg_project_is_set())
		print "	- using ProjectInfo"
		start_dt = acg_get_project_start_dt()
		stop_dt = acg_get_project_stop_dt()
		wave dt = $(inst+"_datetime")
		
		start_index = BinarySearch(dt,start_dt)
		if (start_index < 0)
			start_index = 0
		endif
		stop_index = BinarySearch(dt,stop_dt)
		if (stop_index < 0)
			stop_index = numpnts(dt)
		else
			stop_index +=1
		endif
	endif
	//sizing_write_nsd_file(refNum,id_str,version_str,doy, dp, dw,start_index,stop_index)
	Close refNum	
endif		
	
//	Open/D/T=".csv" refNum
//	
//	print refNum, s_fileName
//	
//	if (cmpstr(S_fileName,"") != 0)
//		Open refNum as S_fileName
//	
//		print refNum, s_fileName
//		
//		sizing_write_nsd_file(fd,id_str,version_str,doy, dp, dw)
//		
//		Close refNum
//	endif
//
//	Open/
End


Function sizing_mask_from_tim()

	variable tb=300
	string inst="dmps_aps"
	variable isFilter=1
	
	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

//	wave dndlogdp =  $(inst+"_dNdlogDp_2d")
//	wave dsdlogdp =  $(inst+"_dSdlogDp_2d")
//	wave dvdlogdp =  $(inst+"_dVdlogDp_2d")
//	wave dmdlogdp =  $(inst+"_dMdlogDp_2d")
//	
//	wave intN = $(inst+"_intN_2d")
//	wave intS = $(inst+"_intS_2d")
//	wave intV = $(inst+"_intV_2d")
//	wave intM = $(inst+"_intM_2d")

	string distribution_list = "dNdlogDp_2d;dSdlogDp_2d;dVdlogDp_2d;dMdlogDp_2d"
	string integral_list = "intN_2d;intS_2d;intV_2d;intM_2d"
//	string sub_fractional_integral_list = "intN_2d_sub1;intN_2d_super1sub10;intS_2d_sub1;intS_2d_super1sub10;intV_2d_sub1;intV_2d_super1sub10;intM_2d_sub1;intM_2d_super1sub10"
	string sub_fractional_integral_list = "intN_2d_sub1;intS_2d_sub1;intV_2d_sub1;intM_2d_sub1;"
	string sup_fractional_integral_list = "intN_2d_super1sub10;intS_2d_super1sub10;intV_2d_super1sub10;intM_2d_super1sub10"
	string mask_list = "gulf_Sflow;land_Sflow;Nflow"
	string rep_dist_list = "dust1;dust2;marine1;marine2;BC_N;BC_S;HSC_S;HSC_Spike;HSC_N"
	wave rep_index = $("root:masks_from_tim_300sec:rep_dist_index")
		
//	setdatafolder root:mask_from_tim_300sec
	
	variable i,j
	for (i=0; i<itemsinlist(distribution_list); i+=1)
		wave dist = $(inst + "_" + stringfromlist(i,distribution_list))
		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o dist $("root:masks_from_tim_300sec:" + inst + "_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list))
			wave mask_dist = $("root:masks_from_tim_300sec:" + inst + "_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $("root:masks_from_tim_300sec:" + stringfromlist(j,mask_list))
			mask_dist = dist[p][q] * mask[p]
	
			make/o/n=(dimsize(dist,1)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_avg")
			wave avg_dist = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_avg")
			make/o/n=(dimsize(dist,1)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_sd")
			wave sd_dist = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_sd")
			variable k
			for (k=0; k<dimsize(dist,1); k+=1)
				make/o/n=(dimsize(dist,0)) tmp_dist
				wave tmp = tmp_dist
				tmp = mask_dist[p][k]
				wavestats/Q tmp
				avg_dist[k] = V_avg
				sd_dist[k] = V_sdev
			endfor
			smooth 3, avg_dist
			smooth 3, sd_dist
			killwaves tmp
		endfor		

		for (j=0; j<itemsinlist(rep_dist_list); j+=1)
			make/o/n=(dimsize(dist,1)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_avg")
			wave avg_dist = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_avg")
			make/o/n=(dimsize(dist,1)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_sd")
			wave sd_dist = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_sd")
			//variable k
			for (k=0; k<dimsize(dist,1); k+=1)
//				make/o/n=(dimsize(dist,0)) tmp_dist
				make/o/n=(rep_index[j][1]  - rep_index[j][0] + 1) tmp_dist
				wave tmp = tmp_dist
				tmp = dist[p+rep_index[j][0]][k]
				wavestats/Q tmp
				avg_dist[k] = V_avg
				sd_dist[k] = V_sdev
			endfor
			smooth 3, avg_dist
			smooth 3, sd_dist
			killwaves tmp
		endfor		


	endfor

	return 0
	
	make/T/o/n=(itemsinlist(integral_list)) $("root:masks_from_tim_300sec:" + inst + "_integral_labels")
	wave/T int_labels = $("root:masks_from_tim_300sec:" + inst + "_integral_labels")
	make/T/o/n=(itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_mask_labels")
	wave/T mask_labels = $("root:masks_from_tim_300sec:" + inst + "_mask_labels")
	make/o/n=(itemsinlist(integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_integral_avg")
	wave int_avg = $("root:masks_from_tim_300sec:" + inst + "_integral_avg")
	make/o/n=(itemsinlist(integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_integral_sd")
	wave int_sd = $("root:masks_from_tim_300sec:" + inst + "_integral_sd")



	// submicron fraction integrals
	make/T/o/n=(itemsinlist(sub_fractional_integral_list)) $("root:masks_from_tim_300sec:" + inst + "_sub_int_labels")
	wave/T int_labels = $("root:masks_from_tim_300sec:" + inst + "_sub_int_labels")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sub_int_avg")
//	wave int_avg = $("root:masks_from_tim_300sec:" + inst + "_sub_int_avg")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sub_int_sd")
//	wave int_sd = $("root:masks_from_tim_300sec:" + inst + "_sub_int_sd")

	for (i=0; i<itemsinlist(sub_fractional_integral_list); i+=1)
		wave integral = $("d_a_" + stringfromlist(i,sub_fractional_integral_list))
		int_labels[i] = stringfromlist(i,sub_fractional_integral_list)

		make/o/n=(itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_avg")
		wave int_avg = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_avg")
		make/o/n=(itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_sd")
		wave int_sd = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_sd")

		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o integral $("root:masks_from_tim_300sec:" + stringfromlist(i,sub_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask_integral = $("root:masks_from_tim_300sec:" + stringfromlist(i,sub_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $("root:masks_from_tim_300sec:" + stringfromlist(j,mask_list))
			mask_integral = integral * mask
			WaveStats/Q mask_integral
			int_avg[j] = V_avg
			int_sd[j]  = V_sdev
		endfor
	endfor

	// supermicron fraction integrals
	make/T/o/n=(itemsinlist(sup_fractional_integral_list)) $("root:masks_from_tim_300sec:" + inst + "_sup_int_labels")
	wave/T int_labels = $("root:masks_from_tim_300sec:" + inst + "_sup_int_labels")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sup_int_avg")
//	wave int_avg = $("root:masks_from_tim_300sec:" + inst + "_sup_int_avg")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sup_int_sd")
//	wave int_sd = $("root:masks_from_tim_300sec:" + inst + "_sup_int_sd")

	for (i=0; i<itemsinlist(sup_fractional_integral_list); i+=1)
		wave integral = $("d_a_" + stringfromlist(i,sup_fractional_integral_list))
		int_labels[i] = stringfromlist(i,sup_fractional_integral_list)

		make/o/n=(itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_avg")
		wave int_avg = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_avg")
		make/o/n=(itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_sd")
		wave int_sd = $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_sd")

		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o integral $("root:masks_from_tim_300sec:" + stringfromlist(i,sup_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask_integral = $("root:masks_from_tim_300sec:" + stringfromlist(i,sup_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $("root:masks_from_tim_300sec:" + stringfromlist(j,mask_list))
			mask_integral = integral * mask
			WaveStats/Q mask_integral
			int_avg[j] = V_avg
			int_sd[j]  = V_sdev
		endfor
	endfor

	setdatafolder sdf
End


Function sizing_mask_from_trish_paper()

	variable tb=300
	string inst="dmps_aps"
	variable isFilter=1
	
	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif

//	wave dndlogdp =  $(inst+"_dNdlogDp_2d")
//	wave dsdlogdp =  $(inst+"_dSdlogDp_2d")
//	wave dvdlogdp =  $(inst+"_dVdlogDp_2d")
//	wave dmdlogdp =  $(inst+"_dMdlogDp_2d")
//	
//	wave intN = $(inst+"_intN_2d")
//	wave intS = $(inst+"_intS_2d")
//	wave intV = $(inst+"_intV_2d")
//	wave intM = $(inst+"_intM_2d")

	string distribution_list = "dNdlogDp_2d;dSdlogDp_2d;dVdlogDp_2d;dMdlogDp_2d"
	string integral_list = "intN_2d;intS_2d;intV_2d;intM_2d"
//	string sub_fractional_integral_list = "intN_2d_sub1;intN_2d_super1sub10;intS_2d_sub1;intS_2d_super1sub10;intV_2d_sub1;intV_2d_super1sub10;intM_2d_sub1;intM_2d_super1sub10"
	string sub_fractional_integral_list = "intN_2d_sub1;intS_2d_sub1;intV_2d_sub1;intM_2d_sub1;"
	string sup_fractional_integral_list = "intN_2d_super1sub10;intS_2d_super1sub10;intV_2d_super1sub10;intM_2d_super1sub10"

	string mask_list = "BC;Free;GB;GulfMar;HSC;Jac;Marine"
	string mask_list_Rn = "gulf_Sflow;land_Sflow;Nflow"
	string rep_dist_list = "dust1;dust2;marine1;marine2;BC_N;BC_S;HSC_S;HSC_Spike;HSC_N"
	wave rep_index = $("root:masks_from_tim_300sec:rep_dist_index")
		
//	setdatafolder root:mask_from_tim_300sec
	
	string basePath = "root:Masks_5m:for_paper:meanDp:"
	string basePath2 = "root:Masks_5m:for_paper:"
	string basePath_Rn = "root:masks_from_tim_300sec:"
	variable i,j


	// process MeanDp from Trish
	wave meanDp = $(basePath + "MeanDp")

	make/o/n=(itemsinlist(mask_list_Rn),4) $(basePath + "meanDp_" + stringfromlist(0,distribution_list) + "_stats_Rn")	
	wave meanDp_stats = $(basePath + "meanDp_" + stringfromlist(0,distribution_list) + "_stats_Rn")
	make/T/o/n=(itemsinlist(mask_list)) $(basePath + "mask_names_Rn")
	wave/T names = $(basePath + "mask_names_Rn")
	make/o/n=(itemsinlist(mask_list)) $(basePath + "mask_name_locations_Rn")
	wave name_loc = $(basePath + "mask_name_locations_Rn")
	for (j=0; j<itemsinlist(mask_list_Rn); j+=1)
		duplicate/o meanDp $(basePath + "mDp_" + stringfromlist(0,distribution_list) + "_" + stringfromlist(j,mask_list_Rn))
		wave mask_meanDp = $(basePath + "mDp_" + stringfromlist(0,distribution_list) + "_" + stringfromlist(j,mask_list_Rn))
		wave mask = $(basePath_Rn + stringfromlist(j,mask_list_Rn))
		mask_MeanDp = meanDp * mask
			
		wavestats/Q mask_MeanDp
		meanDp_stats[j][0] = V_avg
		meanDp_stats[j][1] = V_sdev
		meanDp_stats[j][2] = V_min
		meanDp_stats[j][3] = V_max

		names[j] = stringfromlist(j,mask_list_Rn)
		name_loc[j] = j
	endfor


	make/o/n=(itemsinlist(mask_list),4) $(basePath + "meanDp_" + stringfromlist(0,distribution_list) + "_stats")
	wave meanDp_stats = $(basePath + "meanDp_" + stringfromlist(0,distribution_list) + "_stats")
	make/T/o/n=(itemsinlist(mask_list)) $(basePath + "mask_names")
	wave/T names = $(basePath + "mask_names")
	make/o/n=(itemsinlist(mask_list)) $(basePath + "mask_name_locations")
	wave name_loc = $(basePath + "mask_name_locations")
	for (j=0; j<itemsinlist(mask_list); j+=1)
		duplicate/o meanDp $(basePath + "mDp_" + stringfromlist(0,distribution_list) + "_" + stringfromlist(j,mask_list))
		wave mask_meanDp = $(basePath + "mDp_" + stringfromlist(0,distribution_list) + "_" + stringfromlist(j,mask_list))
		wave mask = $(basePath2 + "CCN_periods_mask_"+stringfromlist(j,mask_list))
		mask_MeanDp = meanDp * mask
			
		wavestats/Q mask_MeanDp
		meanDp_stats[j][0] = V_avg
		meanDp_stats[j][1] = V_sdev
		meanDp_stats[j][2] = V_min
		meanDp_stats[j][3] = V_max

		names[j] = stringfromlist(j,mask_list)
		name_loc[j] = j
	endfor

// ---- 
	setdatafolder sdf
	return 0
// ----	

	for (i=0; i<itemsinlist(distribution_list); i+=1)
		wave dist = $(inst + "_" + stringfromlist(i,distribution_list))
		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o dist $(basePath + inst + "_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list))
			wave mask_dist = $(basePath + inst + "_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $(basePath + "CCN_periods_mask_"+stringfromlist(j,mask_list))
			mask_dist = dist[p][q] * mask[p]
	
			make/o/n=(dimsize(dist,1)) $(basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_avg")
			wave avg_dist = $(basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_avg")
			make/o/n=(dimsize(dist,1)) $(basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_sd")
			wave sd_dist = $(basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_sd")
			variable k
			for (k=0; k<dimsize(dist,1); k+=1)
				make/o/n=(dimsize(dist,0)) tmp_dist
				wave tmp = tmp_dist
				tmp = mask_dist[p][k]
				wavestats/Q tmp
				avg_dist[k] = V_avg
				sd_dist[k] = V_sdev
			endfor
			smooth 3, avg_dist
			smooth 3, sd_dist
			killwaves tmp
		endfor		

//		for (j=0; j<itemsinlist(rep_dist_list); j+=1)
//			make/o/n=(dimsize(dist,1)) $(basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_avg")
//			wave avg_dist = $(basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_avg")
//			make/o/n=(dimsize(dist,1)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_sd")
//			wave sd_dist = $basePath + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,rep_dist_list) + "_sd")
//			//variable k
//			for (k=0; k<dimsize(dist,1); k+=1)
////				make/o/n=(dimsize(dist,0)) tmp_dist
//				make/o/n=(rep_index[j][1]  - rep_index[j][0] + 1) tmp_dist
//				wave tmp = tmp_dist
//				tmp = dist[p+rep_index[j][0]][k]
//				wavestats/Q tmp
//				avg_dist[k] = V_avg
//				sd_dist[k] = V_sdev
//			endfor
//			smooth 3, avg_dist
//			smooth 3, sd_dist
//			killwaves tmp
//		endfor		


	endfor

// ---- 
	setdatafolder sdf
	return 0
// ----	
	make/T/o/n=(itemsinlist(integral_list)) $(basePath + inst + "_integral_labels")
	wave/T int_labels = $(basePath + inst + "_integral_labels")
	make/T/o/n=(itemsinlist(mask_list)) $(basePath + inst + "_mask_labels")
	wave/T mask_labels = $(basePath + inst + "_mask_labels")
	make/o/n=(itemsinlist(integral_list),itemsinlist(mask_list)) $(basePath + inst + "_integral_avg")
	wave int_avg = $(basePath + inst + "_integral_avg")
	make/o/n=(itemsinlist(integral_list),itemsinlist(mask_list)) $(basePath + inst + "_integral_sd")
	wave int_sd = $(basePath + inst + "_integral_sd")



	// submicron fraction integrals
	make/T/o/n=(itemsinlist(sub_fractional_integral_list)) $(basePath + inst + "_sub_int_labels")
	wave/T int_labels = $(basePath + inst + "_sub_int_labels")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sub_int_avg")
//	wave int_avg = $("root:masks_from_tim_300sec:" + inst + "_sub_int_avg")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sub_int_sd")
//	wave int_sd = $("root:masks_from_tim_300sec:" + inst + "_sub_int_sd")

	for (i=0; i<itemsinlist(sub_fractional_integral_list); i+=1)
		wave integral = $("d_a_" + stringfromlist(i,sub_fractional_integral_list))
		int_labels[i] = stringfromlist(i,sub_fractional_integral_list)

		make/o/n=(itemsinlist(mask_list)) $(basePath + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_avg")
		wave int_avg = $(basePath + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_avg")
		make/o/n=(itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_sd")
		wave int_sd = $(basePath + "d_a_" + stringfromlist(i,sub_fractional_integral_list) + "_sd")

		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o integral $(basePath + stringfromlist(i,sub_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask_integral = $(basePath + stringfromlist(i,sub_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $(basePath + stringfromlist(j,mask_list))
			mask_integral = integral * mask
			WaveStats/Q mask_integral
			int_avg[j] = V_avg
			int_sd[j]  = V_sdev
		endfor
	endfor

	// supermicron fraction integrals
	make/T/o/n=(itemsinlist(sup_fractional_integral_list)) $(basePath + inst + "_sup_int_labels")
	wave/T int_labels = $(basePath + inst + "_sup_int_labels")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sup_int_avg")
//	wave int_avg = $("root:masks_from_tim_300sec:" + inst + "_sup_int_avg")
//	make/o/n=(itemsinlist(sub_fractional_integral_list),itemsinlist(mask_list)) $("root:masks_from_tim_300sec:" + inst + "_sup_int_sd")
//	wave int_sd = $("root:masks_from_tim_300sec:" + inst + "_sup_int_sd")

	for (i=0; i<itemsinlist(sup_fractional_integral_list); i+=1)
		wave integral = $("d_a_" + stringfromlist(i,sup_fractional_integral_list))
		int_labels[i] = stringfromlist(i,sup_fractional_integral_list)

		make/o/n=(itemsinlist(mask_list)) $(basePath + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_avg")
		wave int_avg = $(basePath + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_avg")
		make/o/n=(itemsinlist(mask_list)) $(basePath + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_sd")
		wave int_sd = $(basePath + "d_a_" + stringfromlist(i,sup_fractional_integral_list) + "_sd")

		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o integral $(basePath + stringfromlist(i,sup_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask_integral = $(basePath + stringfromlist(i,sup_fractional_integral_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $(basePath + stringfromlist(j,mask_list))
			mask_integral = integral * mask
			WaveStats/Q mask_integral
			int_avg[j] = V_avg
			int_sd[j]  = V_sdev
		endfor
	endfor

	setdatafolder sdf
End

Function sizing_remove_nan_points(windd_w,dat_w,output_name)
	wave windd_w
	wave dat_w
	string output_name
	
	duplicate/o windd_w $(output_name+"_WD")
	wave out_windd_w = $(output_name+"_WD")
	duplicate/o dat_w $(output_name)
	wave out_w = $(output_name)
	variable i
	for (i=0; i<numpnts(out_w); i+=1)
		if (numtype(out_w[i]) > 0)
			deletepoints i,1,out_windd_w
			deletepoints i,1,out_w
			i-=1
		endif
	endfor
End

Function sizing_make_trish_masks()

	string sdf = getdatafolder(1)
	setdatafolder root:masks_from_trish
	
	wave dt = date_time
	wave/T reg = Region
	wave subreg = SubRegion
	wave start = StartTime
	wave stop = StopTime
	
	string region_list = "BC;GulfMarine;HSC;Freeport;GalvestonBay;SE_US;JacintoPt"
	variable i,j
	for (i=0; i<itemsinlist(region_list); i+=1)
		make/o/N=(numpnts(dt)) $("mask_"+stringfromlist(i,region_list))
		wave m = $("mask_"+stringfromlist(i,region_list))
		m = NaN
		SetScale/P x dt[0], 300, "dat", m
	endfor
	
	// clean region wave
	for (i=0; i<numpnts(reg); i+=1)
		reg[i] = ReplaceString("\"",reg[i],"")
	endfor	
	
	
	
	for (i=0; i<numpnts(start); i+=1)
		make/o/N=(numpnts(dt)) $( "mask_"+ reg[i] + "_" + num2str(subreg[i]) )
		wave mN = $( "mask_"+ reg[i] + "_" + num2str(subreg[i]) )
		mN = NaN
		SetScale/P x dt[0], 300, "dat", mN
		
		wave m =  $( "mask_"+ reg[i] )		
		for (j=0; j<numpnts(dt); j+=1)
			if ( (dt[j] >= start[i]) && (dt[j] < stop[i]) )
				mN[j] = 1
				m[j] = 1
			endif
		endfor
	endfor
	
	// --- mask various parameters ---
	// wind direction
	wave wd = root:met_300sec:WindD
	duplicate/o wd WindD
	// ccn_crit_dp
	wave crit_dp = ccn_crit_dp_300
	// max/mean Dp (Sfc Area)
	wave maxDp_S_sub1 = root:dmps_aps:data_300sec:filter:dSdlogDp_maxDp_sub1
	wave maxDp_S_super1sub10 = root:dmps_aps:data_300sec:filter:dSdlogDp_maxDp_super1sub10
	
	for (i=0; i<itemsinlist(region_list); i+=1)
		duplicate/o wd $("WindD_" + stringfromlist(i,region_list))
		wave mask_wd = 	$("WindD_" + stringfromlist(i,region_list))
	
		duplicate/o crit_dp $("ccn_crit_dp_300_" + stringfromlist(i,region_list))
		wave mask_crit_dp = 	$("ccn_crit_dp_300_" + stringfromlist(i,region_list))

		duplicate/o  maxDp_S_sub1 $("maxDp_S_sub1_" + stringfromlist(i,region_list))
		wave mask_maxDp_S_sub1 = 	$("maxDp_S_sub1_" + stringfromlist(i,region_list))
		duplicate/o  maxDp_S_super1sub10 $("maxDp_S_sup1_" + stringfromlist(i,region_list))
		wave mask_maxDp_S_super1sub10 = 	$("maxDp_S_sup1_" + stringfromlist(i,region_list))
	
		wave m = $("mask_"+stringfromlist(i,region_list))
		mask_wd = mask_wd*m
		mask_crit_dp = mask_crit_dp*m
		mask_maxDp_S_sub1 = mask_maxDp_S_sub1*m
		mask_maxDp_S_super1sub10 = mask_maxDp_S_super1sub10*m
	endfor


	// distributions
	variable tb=300
	string inst="dmps_aps"
	variable isFilter=1
	
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	string distribution_list = "dNdlogDp_2d;dSdlogDp_2d;dVdlogDp_2d;dMdlogDp_2d"
	string integral_list = "intN_2d;intS_2d;intV_2d;intM_2d"
//	string sub_fractional_integral_list = "intN_2d_sub1;intN_2d_super1sub10;intS_2d_sub1;intS_2d_super1sub10;intV_2d_sub1;intV_2d_super1sub10;intM_2d_sub1;intM_2d_super1sub10"
	string sub_fractional_integral_list = "intN_2d_sub1;intS_2d_sub1;intV_2d_sub1;intM_2d_sub1;"
	string sup_fractional_integral_list = "intN_2d_super1sub10;intS_2d_super1sub10;intV_2d_super1sub10;intM_2d_super1sub10"
	//string mask_list = "gulf_Sflow;land_Sflow;Nflow"
	string mask_list = region_list
	
	for (i=0; i<itemsinlist(distribution_list); i+=1)
		wave dist = $(inst + "_" + stringfromlist(i,distribution_list))
		for (j=0; j<itemsinlist(mask_list); j+=1)
			duplicate/o dist $("root:masks_from_trish:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list))
			wave mask_dist = $("root:masks_from_trish:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list))
			wave mask = $("root:masks_from_trish:mask_" + stringfromlist(j,mask_list))
			mask_dist = dist[p][q] * mask[p]
	
			make/o/n=(dimsize(dist,1)) $("root:masks_from_trish:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_avg")
			wave avg_dist = $("root:masks_from_trish:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_avg")
			make/o/n=(dimsize(dist,1)) $("root:masks_from_trish:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_sd")
			wave sd_dist = $("root:masks_from_trish:" + "d_a_" + stringfromlist(i,distribution_list) + "_" + stringfromlist(j,mask_list) + "_sd")
			variable k
			for (k=0; k<dimsize(dist,1); k+=1)
				make/o/n=(dimsize(dist,0)) tmp_dist
				wave tmp = tmp_dist
				tmp = mask_dist[p][k]
				wavestats/Q tmp
				avg_dist[k] = V_avg
				sd_dist[k] = V_sdev
			endfor
			smooth 3, avg_dist
			smooth 3,sd_dist
			killwaves tmp
		endfor		
	endfor

	
	setdatafolder sdf
	
End

Function sizing_24hr_average(dt, dat,output_name)
	wave dt
	wave dat
	string output_name
	
	variable isFilter = 1
	string inst = "dmps_aps"
	variable tb = general_defaultTimeBase
	string sdf = getdatafolder(1)
	if (isFilter)
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec"):filter
	else
		setdatafolder root:$(inst):$("data_"+num2str(tb)+"sec")
	endif
	
	duplicate/o dat $(output_name)
	wave out = $(output_name)
	out = NaN
		
	variable avg 
	variable inc = (86400/300)-1
	variable i
	for (i=0; i<numpnts(dt); i+=1)
		if (mod(dt[i],86400) == 0)
			WaveStats/Q/R=[i,i+inc] dat
			out[i,i+inc] = V_avg
			print i, secs2date(dt[i],0), secs2time(dt[i],3), " -- ", secs2date(dt[i+inc],0), secs2time(dt[i+inc],3),V_avg
		endif
	endfor
End

Function sizing_density_test()
	
	make/o/n=100 sqrt_fn
	wave sfn = sqrt_fn
	make/o/n=100 M_fn
	wave mfn = M_fn

	make/o/n=100 full_fn
	wave ffn = full_fn

	make/o/n=100 m_1_5_fn
	wave m15 = m_1_5_fn

	make/o/n=100 m_1_7_fn
	wave m17 = m_1_7_fn
	
	setscale/P x, 1.0, .01, "g cm-3", sfn 
	setscale/P x, 1.0, .01, "g cm-3", mfn 
	setscale/P x, 1.0, .01, "g cm-3", ffn 

	setscale/I x, .25, 2.5, "um", m15 
	setscale/I x, .25, 2.5, "um", m17 
	
	variable Dp = 2.5
	
	variable dens,i
	dens = 1.0
	for (i=0; i<100; i+=1)
		sfn[i] = Dp/sqrt(dens)
		mfn[i] = ((Dp/2)^3)*sqrt(dens)

		ffn[i] = ((sfn[i]/2)^3)*sqrt(dens)
		dens += 0.01
	endfor

	Dp = .25
	for (i=0; i<100; i+=1)
		m15[i] = 4/3*PI*((Dp/sqrt(1.5))/2)^3*1.5
		m17[i] = 4/3*PI*((Dp/sqrt(1.7))/2)^3*1.7
		Dp += 0.0225
	endfor
	duplicate m15 m_rat_fn
	wave mrat = m_rat_fn
	
	mrat = m17/m15
	
	
End

Function sizing_convert_aps_to_stokes(dpa, density, shape, dest_wave)
	wave dpa
	wave density
	string shape
	string dest_wave
	
//	duplicate/o dpa $("tmp_aps_dp_stokes")
//	wave tmp_Dp = $("tmp_aps_dp_stokes")
	duplicate/o dpa $dest_wave
	wave tmp_Dp = $dest_wave
	
	variable X0_psl=1.0, a_psl=0.15, b_psl=0.687; // calibration sphere: PSL rho=1.05
	variable X0, a, b
	
	if (cmpstr(shape,"sphere") == 0)
		 X0=X0_psl
		 a=a_psl
		 b=b_psl          // sphere
	elseif (cmpstr(shape,"doublet") == 0)
		X0=1.142 
		a=0.1998 
		b=0.6773			 // doublet
	elseif (cmpstr(shape,"triplet") == 0)
		X0=1.18 
		a=0.2141 
		b=0.6805			 // triplet
	endif
	//double X0=1.12, a=0.1998, b=0.6773			 // quad
	//double X0=1.19, a=0.8044, b=0.4960			 // natrojarocite (rho = 3.1)
	

	// Add non-Stokesian correction (from Steve Howell 12-March-2003)
	
	variable tperc = 4.e-9			// 4 ns per channel
	variable bdist = 0.01			// distance between beams, cm
//	double rhoair = 1.205e-3		// air density, 20C (Steve H.)
	variable rhoair = 1.05e-3		// air density, 20C (Dave C.)
	variable muair = 1.81e-4			// air viscosity, 20C

	// result of poly fit to cal data from Steve H.
	// y = a0 + a1x + a2x^2 + a3x^3 +a4x^4
	variable a0 = 159.674
	variable a1 = 65.4594
	variable a2 = -3.33349
	variable a3 = 0.177328
	variable a4 = -0.00379464

	variable cair = a0
	variable uair = bdist / (cair * tperc)


	variable doUltraStokesianCorrection = 1
	if (doUltraStokesianCorrection) 

		variable i,j
		for (i=0; i<dimsize(dpa,0); i+=1) 
			for (j=0; j<dimsize(dpa,1); j+=1)
				variable dm = tmp_Dp[i][j]
				// changed last term fro a4+() to a4*()
				variable cpart = a0 + (a1*dm) + (a2*(dm^2)) + (a3*(dm^3)) + (a4*(dm^4))
				variable upart = bdist / (cpart*tperc)
	
				dm /= 10000.0
				
				//* Method from Cheng et al. */
	
				variable R1 = rhoair * (uair-upart) * dm / (muair * sqrt(1.05))
				variable R2 = rhoair * (uair-upart) * dm / (muair * sqrt(density[i][j]))
				//print "R1, R2, density ", R1, R2, density[i][j]						
				variable top = 1.0 + (a*(R2^b))
				variable bottom = 1.0 + (a_psl*(R1^b_psl))
				
				//print "1:top, bottom ", top, bottom
				top *= X0
				//print "2:top, bottom ", top, bottom
				
				variable dc = dm * sqrt(top/bottom)
				
		//		double dc = dm * sqrt( X0*(1.0 + a*powf(R2,b)) / X0_psl*(1.0 + a_psl*powf(R1,b_psl)) )
				
				tmp_Dp[i][j] = dc*10000.
				tmp_Dp[i][j] /= sqrt(density[i][j])
				
				//string out = "Stokes correction["+num2str(i)+"] = " + num2str(dm*10000) + " --> " + num2str(dc*10000)
				//print out
				
				//* end Cheng method */		 	
		
//		/* TSI method (from Steve H.)
//			double lower = dm/dens.extdN()[i]
//			double upper = dm*dens.extdN()[i]
//
//			int steps = 100
//			double inc = (upper - lower) / (steps - 1.0)
//			double dc
//			double old_y, y
//			double old_dc
//			
//			for (int j=0 j<steps j++) {
//				if (j==0) dc = lower
//				else dc += inc
//
//				double R1 = rhoair * (uair-upart) * dm / (muair * sqrt(1.05))
//				double R2 = rhoair * (uair-upart) * dc / (muair * sqrt(dens.extdN()[i]))
//
//				/* TSI method (from Steve H.)
//				y = dm * sqrt( (6.0 + powf(R2,2./3.)) / (6.0 + powf(R1,2./3.)) ) - dc
//
//				if (j==0) {
//					old_y = y
//					old_dc = dc
//				}
//				
//				else {
//
//					if (old_y*y < 0) {
//						double m = (old_y - y) / (old_dc - dc)
//						double b = m * (0 - old_dc) + old_y
//						dc = (0 - b) / m
//						break
//					}
//
//					else if (old_y*y > 0) {
//						old_dc = dc
//						old_y = y
//					}
//
//				}
//		
//			
//
//			}
//				cout << "stokes correction[" << i << "] = " << dm*10000 << " --> " 
//					 << dc*10000 << endl
//				tmp_Dp[i] = dc*10000. * 1.00
//				/* end Steve Howell method */
				 
			endfor
		endfor			

	//	exit(1)

	endif //close doUltraStokesianCorrection section

End


Function sizing_mask_and_avg_dist(dist,mask,uses_nans,output_name)
	wave dist
	wave mask
	variable uses_nans // 1=mask uses 1's and nans, 0=value based (1=good, 0=bad) ... same as acg_utils:acg_mask_1D()
	string output_name
	
	make/O/n=(dimsize(dist,1)) $output_name
	wave avg = $output_name
	
	acg_mask_2D(dist,mask,uses_nans,"tmp_dist")
	wave tmp = $("tmp_dist")
	
	variable i
	for (i=0; i<dimsize(tmp,1); i+=1)
		make/o/n=(dimsize(tmp,0)) col
		col = tmp[p][i]
		wavestats/Q col
		avg[i] = V_avg
	endfor
	killwaves col, tmp
End	

Function sizing_mask_shape_data()

	string mask_list = "gulf_Sflow;land_Sflow;Nflow"
	string shape_list = "sphere;doublet;triplet"
	string moment_list = "N;M"
	string fraction_list = "sub1;super1sub10;pm2_5"
	
	string pstr = "root:dmps_aps:data_300sec:filter:"
	string wstr,dstr
	string ambstr
	
	string dat_name
	
	variable i,j,k,e,f
	for (i=0; i<itemsinlist(mask_list); i+=1)		
		wave mask = root:masks_from_tim_300sec:$stringfromlist(i,mask_list)
		for (j=0;j<itemsinlist(shape_list); j+=1)
			pstr = "root:dmps_aps:data_300sec:filter:"
			if (cmpstr("sphere",stringfromlist(j,shape_list)) != 0)
				pstr += stringfromlist(j,shape_list) + ":"
			endif
			//print "pstr = ", pstr
			for (k=0; k<itemsinlist(moment_list); k+=1)
				for (e=0; e<2; e+=1)
					ambstr = ""
					if (e>0)
						ambstr = "_amb"
					endif
					//wstr = "d_a_int" + stringfromlist(k,moment_list)+ambstr+"_2d_"
					dstr = "dmps_aps_d" + stringfromlist(k,moment_list)+"dlogDp"+ambstr+"_2d"
					//print "\tdstr = ", dstr
					wave dist = $(pstr+dstr)
					string dstr2 = "d" + stringfromlist(k,moment_list)+"dlogDp"+ambstr+"_2d"
					
					sizing_mask_and_avg_dist(dist,mask,1,(pstr+dstr2+"_" + stringfromlist(i,mask_list)+"_avg"))
					wave avg_dist = $(pstr+dstr2+"_" + stringfromlist(i,mask_list)+"_avg")
					smooth 3, avg_dist

					if (cmpstr("M", stringfromlist(k,moment_list)) == 0)
						for (f=0; f<itemsinlist(fraction_list); f+=1)
	
							string fractionstr = stringfromlist(f,fraction_list)
							if (cmpstr("super1sub10",stringfromlist(f,fraction_list)) == 0)
								fractionstr = "sup1"
							endif
	
	
							wstr = "d_a_int" + stringfromlist(k,moment_list)+ambstr+"_2d_" + stringfromlist(f,fraction_list)
							//print "\twstr = ", wstr
							wave dat = $(pstr+wstr)
							//dat_name = wstr + "_" + stringfromlist(i,mask_list)
							//print "\t\tdat_name = ", dat_name
							string outname = pstr+ "int" + stringfromlist(k,moment_list)+ambstr+"_2d_" + fractionstr + "_" + stringfromlist(i,mask_list)
							//print "\t\toutname = ", outname
							acg_mask_1D(dat,mask,1,outname)
							wave out = $outname
							wavestats/Q out
							//print V_avg
							variable/G $(outname+"_avg")
							nvar intavg = $(outname+"_avg")
							intavg = V_avg
						endfor
					endif
				endfor
			endfor
		endfor
	endfor	
End


Function sizing_mask_with_ship_plumes()

	string sdf = getdatafolder(1)
	setdatafolder root:ship_plumes
	
	wave start_dt = plumes_start_dt
	wave end_dt = plumes_end_dt
	
	wave dmps_dt = root:dmps_aps:data_300sec:filter:triplet:dmps_aps_datetime
	wave dmps_aps_dndlogdp = root:dmps_aps:data_300sec:filter:triplet:dmps_aps_dNdlogDp_2d
	
	duplicate/o dmps_aps_dndlogdp dmps_aps_dNdlogDp_2d
	wave dndlogdp = dmps_aps_dNdlogDp_2d
	make/o/n=(numpnts(dmps_dt)) plumes_dmps_aps_mask
	wave mask = plumes_dmps_aps_mask
	mask = NaN
	
	variable i,j
	for (i=0; i<numpnts(start_dt); i+=1)
		if ( (end_dt[i] - start_dt[i]) >= 300)
			print i, (end_dt[i] - start_dt[i])
			variable idx_start = ceil(BinarySearchInterp(dmps_dt,start_dt[i]))
			variable idx_end = floor(BinarySearchInterp(dmps_dt,end_dt[i]))
			if (idx_end > idx_start)
				mask[idx_start,idx_end] = 1
			endif			
		endif
	endfor
	
	dndlogdp = dndlogdp[p][q] * mask[p]
	
	setdatafolder sdf
	
End

Function transmission()
    setdatafolder root:dmps:data_300sec
    
    wave dmps_dp_im; wave dmps_intM; wave dmps_dMdlogDp
    
    setdatafolder root:from_lelia
    
    Make/o/d/n=(numpnts(dmps_dp_im)-1) dLogDp =log(dmps_dp_im[p+1]/dmps_dp_im[p])

    variable i
    duplicate/O dmps_dMdlogDP, dM
    
    make/o/d/n=(dimsize(dmps_dMdlogDp,1)) temp
    make/o/d/n=(dimsize(dmps_dMdlogDp,0)) M
    dM = dmps_dMdlogDp[p][q]*dlogDp[q]
    for(i=0;i<(dimsize(dmps_dMdlogDp,0)); i+=1)
        //dM[i][] = dmps_dMdlogDp[i][p]*dlogDP[p]
        temp = dM[i][p]
        if (i==1134)
        	print temp
        	print dlogDp
        endif
        wavestats/Q temp
        M[i] = V_sum
    endfor
    
    dowindow/k transmissionPlot
    display/N=transmissionPlot M vs dmps_intM
End

Function sizing_expand_to_faster_tb(inst,old_tb,new_tb,param,is_dt)
	string inst
	variable old_tb
	variable new_tb
	string param
	variable is_dt
	
	variable isFilter=0
	string sdf = getdatafolder(1)
	string df
	if (isFilter)
		df = "root:"+inst+":data_"+num2str(old_tb)+"sec:filter"
	else
		df = "root:"+inst+":data_"+num2str(old_tb)+"sec"
		//setdatafolder root:$(inst):$("data_"+num2str(old_tb)+"sec")
	endif
	setdatafolder $df
	
	if (!waveexists($param))
		return 0
	endif
	
	wave old_par = $param

	df = "root:"+inst+":data_"+num2str(new_tb)+"sec"
	newdatafolder/o/s $df
	if (isFilter)
		newdatafolder/o/s filter
	endif
	
	variable rows=0, cols=0
	variable mult = old_tb/new_tb
	rows = dimsize(old_par,0)*mult
	cols = dimsize(old_par,1)
	
	if (cols > 0)
		if (is_dt)
			make/d/o/n=(rows,cols) $param
		else
			make/o/n=(rows,cols) $param
		endif
	else
		if (is_dt)
			make/d/o/n=(rows) $param
		else
			make/o/n=(rows) $param
		endif
	endif
	wave new_par = $param
	
	variable new_inc=0
	variable i,c
	for (i=0; i<dimsize(old_par,0); i+=1)
		if (cols>0)
			for (c=0; c<cols; c+=1)
				new_par[new_inc][c] = old_par[i][c]
			endfor
		else
			new_par[new_inc] = old_par[i]
		endif
		new_inc+=1
		variable j
		for (j=1; j<mult; j+=1)
			if (cols>0)
				for (c=0; c<cols; c+=1)
					new_par[new_inc][c] = old_par[i][c]
				endfor
			else
				if (is_dt)
					new_par[new_inc] = old_par[i] + j*new_tb
				else
					new_par[new_inc] = old_par[i]
				endif
			endif
			new_inc+=1
		endfor
	endfor
	setdatafolder sdf
End

Function sizing_process_2d_Uintah()

	// Note: for the 2d merge to work properly, run the assumed density merge first

	string sdf  = getdatafolder(1)

	variable tb = general_defaultTimeBase
	string inst
	variable isFilter=0
	variable isAmbient=0
	variable dmpsIsSamp=0
	variable apsIsSamp=0
	variable isModified=0
	string fraction
	variable diam_type
	string shape = "sphere"
	
	string inst_list = "dmps;aps;dmps_aps"	
	
	print ""
	print "-----------------------------------------------------------"
	print "Process 2d data - this will take a while..."
	print "-----------------------------------------------------------"
	print ""
	
if (1)
	print "--- UNFILTERED DISTRIBUTIONS ---"
	print ""
	isFilter = 0
	isAmbient = 0
	print "	merge dmps and aps (constant density)"
	sizing_merge_smps_aps(tb,isFilter)

	inst = "smps"
	print "    reprocess 1d data"
	//sizing_reprocess_data(inst,tb,isFilter)
	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape) // Add shape argument
	print "	shift dmps values from meas RH to imp sample RH"
	inst = "smps"
	//sizing_shift_dmps_to_sample(inst,tb,isFilter,shape) 
	//dmpsIsSamp = 1
	//apsIsSamp = 0
	//isModified = 1

	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super2.5sub10",diam_type,isFilter,isAmbient,shape)
	
	inst = "aps"
	isModified=0
	print "    reprocess 1d data"
	//sizing_reprocess_data(inst,tb,isFilter)
	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)
	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super2.5sub10",diam_type,isFilter,isAmbient,shape)

	print "	merge dmps and aps (calculated density)"
	sizing_merge_smps_aps_2d(tb,isFilter,dmpsIsSamp,apsIsSamp,shape)

endif

if (1)

	print "	shift dmps_aps to ambient RH"
	inst = "dmps_aps"
	sizing_shift_to_ambient(inst,tb,isFilter,(dmpsIsSamp || apsIsSamp),shape)

endif

if (0)
	print "--- FILTERED DISTRIBUTIONS ---"
	isFilter = 1
	isAmbient = 0
	
	print "	merge dmps and aps (constant density)"
	sizing_merge_smps_aps(tb,isFilter)


	inst = "dmps"

	//sizing_filter_with_cn(inst,tb)

	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)

	print "	shift dmps values from meas RH to imp sample RH"
	inst = "dmps"
	//sizing_shift_dmps_to_sample(inst,tb,isFilter,shape)
	//dmpsIsSamp = 1
	//apsIsSamp = 0
	//isModified = 1

	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super1sub10",diam_type,isFilter,isAmbient,shape)

	inst = "aps"
	isModified = 0
	//isModified=0 // <-- removed this to go back to orig?

	//sizing_filter_with_cn(inst,tb)

	print "	add 2d params to " + inst
	add_aero_diams_2d(inst,tb,isFilter,isAmbient,shape)
	print "	convert N to SVM for " + inst
	convert_NtoSVM_2d(inst,tb,isFilter,isAmbient,isModified,shape)
	print "	integrate totals for " + inst
	integrate_NSVM_2d(inst,tb,isFilter,isAmbient,shape)
	print "	integrate sub/super fractions for " + inst
	diam_type = 1
	integrate_NSVM_fraction_2d(inst,tb,"sub1",diam_type,isFilter,isAmbient,shape)
	integrate_NSVM_fraction_2d(inst,tb,"super1sub10",diam_type,isFilter,isAmbient,shape)

	print "	merge dmps and aps (calculated density)"
	sizing_merge_dmps_aps_2d(tb,isFilter,dmpsIsSamp,apsIsSamp,shape)

endif

if (0)

	print "	shift dmps_aps to ambient RH"
	inst = "dmps_aps"
	sizing_shift_to_ambient(inst,tb,isFilter,(dmpsIsSamp || apsIsSamp),shape)

endif	

	print "Done."
	
	setdatafolder sdf
End	

Function sizing_load_cn_mart()

	DFREF sdf = getdatafolderdfr()

	newdatafolder/o/s root:cn
	acg_load_dchart_itx_format(1)
	
	// always duplicate final wave to make a cn_mart wave
	duplicate/o cn_bmi, cn_mart
	
	setdatafolder sdf
	
	//ttdma_update() //comment out if it is easier to do this manually
	
End

Function mart_load_cn()

	DFREF sdf = getdatafolderdfr()

	newdatafolder/o/s root:cn
	acg_load_dchart_itx_format(1)
	
	//ttdma_filter_with_valve("smps",120,0)
	duplicate/o cn_bmi, cn_mart

	setdatafolder sdf
	
	//ttdma_update() //comment out if it is easier to do this manually
	
End
