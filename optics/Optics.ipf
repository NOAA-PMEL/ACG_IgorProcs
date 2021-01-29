#pragma rtGlobals=1		// Use modern global access method.


//User defined variables====
	//Path to local data source

constant acg_optics_version=1.00

strconstant optics_tmp_data_folder = "root:optics_tmp_data_folder"
strconstant optics_data_folder = "root:optics"
strconstant optics_orig_folder = "orig"
strconstant optics_native_format = "native"
strconstant optics_dataselector_format = "dataselector"
strconstant optics_dataselector_format_2 = "dataselector2"  // ICEALOT  and beyond format
//strconstant optics_labview_acf_format = "labview_acf"  

constant optics_avg_period = 1 		// nominal avg period
constant optics_data_is_averaged = 1	// flag: is data being loaded already averaged to 60s?
constant optics_tb = 1 				// nominal timebase of working data

constant optics_do_mask = 0
strconstant icealot_mask_list = "arc_mask;Eur_mask;LI_mask;NAt_mask;NA_mask"

constant optics_init_checks_to_zero = 0 // force the initial neph check values to be "perfect"

constant optics_nominal_fRH_hi_value = 85
constant optics_valid_range_fRH_hi_value = 1 // +/- value

constant optics_apply_pfw = 1 // apply project flag wave if availiable when processing data

menu "ACG Data"
	submenu "Optics"
		submenu "Load Data"
			submenu "RH60"
				"Sub 1 Neph", load_optics_data("rh60","neph_sub1",optics_dataselector_format_2,0)
				"Sub 10 Neph", load_optics_data("rh60","neph_sub10",optics_dataselector_format_2,0)
				"Sub 1 PSAP", load_optics_data("rh60","psap_sub1",optics_dataselector_format_2,0)
				"Sub 10 PSAP", load_optics_data("rh60","psap_sub10",optics_dataselector_format_2,0)
			end
			submenu "fRH"
				"low RH neph", load_optics_data("fRH","neph_lo",optics_dataselector_format_2,0)
				"high RH neph", load_optics_data("fRH","neph_hi",optics_dataselector_format_2,0)
				"low RH psap", load_optics_data("fRH","psap_lo",optics_dataselector_format_2,0)
			end
		end
		submenu "Process Data"
			submenu "RH60"
				"Sub 1 Neph", optics_process_data("rh60","neph_sub1")
				"Sub 10 Neph", optics_process_data("rh60","neph_sub10")
				"Sub 1 PSAP", optics_process_data("rh60","psap_sub1")
				"Sub 10 PSAP", optics_process_data("rh60","psap_sub10")
			end
			submenu "fRH"
				"low RH neph", optics_process_data("fRH","neph_lo")
				"high RH neph", optics_process_data("fRH","neph_hi")
				"low RH psap", optics_process_data("fRH","psap_lo")
			end
		end
	end
end


Menu "GraphMarquee"
	"-"
	submenu "RH60"
		submenu "all"
			"nan range", optics_toggle_nans_from_marquee("rh60","neph_sub1",1,1) ;optics_toggle_nans_from_marquee("rh60","neph_sub10",1,1)
			//"reset range", optics_toggle_nans_from_marquee("rh60","neph_sub1",0); optics_toggle_nans_from_marquee("rh60","neph_sub10",0)
		end
		submenu "Sub1 Neph"
			"nan range", optics_toggle_nans_from_marquee("rh60","neph_sub1",1,1) 
			"reset range", optics_toggle_nans_from_marquee("rh60","neph_sub1",1,0)
			"nan dropouts", optics_toggle_nans_from_marquee("rh60","neph_sub1",0,1) 
			"reset dropouts", optics_toggle_nans_from_marquee("rh60","neph_sub1",0,0)
			"-"
			"set check period", optics_toggle_chek_from_marquee("rh60","neph_sub1",1) 
			"reset check period", optics_toggle_chek_from_marquee("rh60","neph_sub1",0)
			submenu "Check Period Type"
				"Zero",optics_toggle_chek_type_from_mq("rh60","neph_sub1",1,"zero")			
				"CO2",optics_toggle_chek_type_from_mq("rh60","neph_sub1",1,"co2")			
				"Reset",optics_toggle_chek_type_from_mq("rh60","neph_sub1",1,"")
			end		
		end		
		submenu "Sub10 Neph"
			"nan range", optics_toggle_nans_from_marquee("rh60","neph_sub10",1,1) 
			"reset range", optics_toggle_nans_from_marquee("rh60","neph_sub10",1,0)
			"nan dropouts", optics_toggle_nans_from_marquee("rh60","neph_sub10",0,1) 
			"reset dropouts", optics_toggle_nans_from_marquee("rh60","neph_sub10",0,0)
			"-"
			"set check period", optics_toggle_chek_from_marquee("rh60","neph_sub10",1) 
			"reset check period", optics_toggle_chek_from_marquee("rh60","neph_sub10",0)			
			submenu "Check Period Type"
				"Zero",optics_toggle_chek_type_from_mq("rh60","neph_sub10",1,"zero")			
				"CO2",optics_toggle_chek_type_from_mq("rh60","neph_sub10",1,"co2")			
				"Reset",optics_toggle_chek_type_from_mq("rh60","neph_sub10",1,"")
			end		
		end		
		submenu "Sub1 PSAP"
			"nan range", optics_toggle_nans_from_marquee("rh60","psap_sub1",1,1) 
			"reset range", optics_toggle_nans_from_marquee("rh60","psap_sub1",1,0)
			"nan dropouts", optics_toggle_nans_from_marquee("rh60","psap_sub1",0,1) 
			"reset dropouts", optics_toggle_nans_from_marquee("rh60","psap_sub1",0,0)
		end		
		submenu "Sub10 PSAP"
			"nan range", optics_toggle_nans_from_marquee("rh60","psap_sub10",1,1) 
			"reset range", optics_toggle_nans_from_marquee("rh60","psap_sub10",1,0)
			"nan dropouts", optics_toggle_nans_from_marquee("rh60","psap_sub10",0,1) 
			"reset dropouts", optics_toggle_nans_from_marquee("rh60","psap_sub10",0,0)
		end		
	end
	
	submenu "fRH"
		submenu "all"
			//"nan range", optics_toggle_nans_from_marquee("fRH","neph_lo",1) //; cn_toggle_nans_from_marquee("ucpc",1)
			"nan range", optics_toggle_nans_from_marquee("fRH","neph_lo",1,1) ;optics_toggle_nans_from_marquee("fRH","neph_hi",1,1)
			"reset range", optics_toggle_nans_from_marquee("fRH","neph_lo",0) // ;cn_toggle_nans_from_marquee("ucpc",0)
		end
		submenu "Low RH Neph"
			"nan range", optics_toggle_nans_from_marquee("fRH","neph_lo",1,1) 
			"reset range", optics_toggle_nans_from_marquee("fRH","neph_lo",1,0)
			"nan dropouts", optics_toggle_nans_from_marquee("fRH","neph_lo",0,1) 
			"reset dropouts", optics_toggle_nans_from_marquee("fRH","neph_lo",0,0)
			"-"
			"set check period", optics_toggle_chek_from_marquee("fRH","neph_lo",1) 
			"reset check period", optics_toggle_chek_from_marquee("fRH","neph_lo",0)			
			submenu "Check Period Type"
				"Zero",optics_toggle_chek_type_from_mq("fRH","neph_lo",1,"zero")			
				"CO2",optics_toggle_chek_type_from_mq("fRH","neph_lo",1,"co2")			
				"Reset",optics_toggle_chek_type_from_mq("fRH","neph_lo",1,"")
			end		
		end		
		submenu "High RH Neph"
			"nan range", optics_toggle_nans_from_marquee("fRH","neph_hi",1,1) 
			"reset range", optics_toggle_nans_from_marquee("fRH","neph_hi",1,0)
			"nan dropouts", optics_toggle_nans_from_marquee("fRH","neph_hi",0,1) 
			"reset dropouts", optics_toggle_nans_from_marquee("fRH","neph_sub10",0,0)
			"-"
			"set check period", optics_toggle_chek_from_marquee("fRH","neph_hi",1) 
			"reset check period", optics_toggle_chek_from_marquee("fRH","neph_hi",0)			
			submenu "Check Period Type"
				"Zero",optics_toggle_chek_type_from_mq("fRH","neph_hi",1,"zero")			
				"CO2",optics_toggle_chek_type_from_mq("fRH","neph_hi",1,"co2")			
				"Reset",optics_toggle_chek_type_from_mq("fRH","neph_hi",1,"")
			end		
		end		
		submenu "Low RH PSAP"
			"nan range", optics_toggle_nans_from_marquee("fRH","psap_lo",1,1) 
			"reset range", optics_toggle_nans_from_marquee("fRH","psap_lo",1,0)
		end		

	end
//	submenu "CPC"
//		"nan range", cn_toggle_nans_from_marquee("cpc",1)
//		"reset range", cn_toggle_nans_from_marquee("cpc",0)
//		submenu "select instrument"
//			"default", cn_set_inst_flag("cpc","default") 
//			"CN_Direct", cn_set_inst_flag("cpc","CN_Direct") 
//			"CN_AMS", cn_set_inst_flag("cpc","CN_AMS") 
//			"CN_stack", cn_set_inst_flag("cpc","CN_stack") 
//		end
//	end
End

Function load_optics_data(sys,inst,file_format,doBatch)
	string sys
	string inst
	string file_format
	variable doBatch 
	string sdf = getdatafolder(1)
	
	newdatafolder/o/s $optics_data_folder           // create main optics data folder
	newdatafolder/o/s $sys					// system: rh60, fRH
	newdatafolder/o/s $inst					// inst: neph_sub1, psap_lo, etc
	newdatafolder/o/s $optics_orig_folder		// inst: neph_sub1, psap_lo, etc
	
	variable num_files = 0
	if (doBatch)
		string file_list = acg_get_file_list_batch()
		num_files = itemsinlist(file_list)
	endif
	
	if (num_files <= 0) 
		num_files = 1
	endif
	
	variable findex
	for (findex=0; findex<num_files; findex+=1)
		
		if (datafolderexists(optics_tmp_data_folder))
			killdatafolder/Z $optics_tmp_data_folder
		endif
		newdatafolder/o/s $optics_tmp_data_folder  // create temporary data folder
		newdatafolder/o/s $sys					
		newdatafolder/o/s $inst						
	
		// Load and correct Optics data
		print "Starting on Optics data:"
		print "	loading " + sys + ":" + inst + "..."
		
		if (cmpstr(file_format,optics_dataselector_format) == 0)
			load_data_selector_format()
		elseif (cmpstr(file_format,optics_dataselector_format_2) == 0)
			if (doBatch)
				string fn = stringfromlist(findex,file_list)
				load_data_selector_v2_byname(fn)
			else
				load_data_selector_format_v2()
			endif
			optics_rename_waves(sys,inst,file_format)
		elseif (cmpstr(file_format,optics_native_format) == 0)
			//optics_load_native_format()  // native format has changed
			load_data_labview_acf_format()
			optics_rename_waves(sys,inst,file_format)
		endif
	
		// load_data_selector_format()
	//	// copy user selected CN data to optics_Concentration
	//	if (coptics_use_this_cpc == 0) // use optics_AMS
	//		duplicate/o optics_AMS optics_Concentration
	//	elseif (coptics_use_this_cpc == 1) // use WCPC
	//		duplicate/o WCPC optics_Concentration
	//	else
	//		print "unknown cpc to use!"
	//		Abort "unkown cpc type!"
	//	endif
	//	killwaves/Z optics_AMS, WCPC	
	//	correct_optics_data((coptics_tmp_data_folder+":cn"))
		setdatafolder $optics_tmp_data_folder
	
	
		// "Converting new data to constant time base and averaging into " + num2str(avg_period) + " sec periods"
		optics_same_timebase_tmp(sys,inst)
		
		// Avg to 1 minute
	//	if (optics_data_is_averaged) 
	//		optics_avg_new_data();
	//	endif
		
		//"Adding new data to main data"
		optics_combine_data_from_tmp(sys,inst)
		
		// remove tmp folders and waves
		optics_clean_up()
		
	endfor
	
	print "Done."
	setdatafolder sdf	
End

Function load_uintah_data(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	
	newdatafolder/o/s $optics_data_folder           // create main optics data folder
	newdatafolder/o/s $sys					// system: rh60, fRH
	newdatafolder/o/s $inst					// inst: neph_sub1, psap_lo, etc
	newdatafolder/o/s $optics_orig_folder		// inst: neph_sub1, psap_lo, etc
	
	variable num_files = 0
	
	if (num_files <= 0) 
		num_files = 1
	endif
	
	variable findex
	for (findex=0; findex<num_files; findex+=1)
		
//		if (datafolderexists(optics_tmp_data_folder))
//			killdatafolder/Z $optics_tmp_data_folder
//		endif
//		newdatafolder/o/s $optics_tmp_data_folder  // create temporary data folder
//		newdatafolder/o/s $sys					
//		newdatafolder/o/s $inst						
	
		// Load and correct Optics data
		print "Starting on Optics data:"
		print "	loading " + sys + ":" + inst + "..."
		
//		if (cmpstr(file_format,optics_dataselector_format) == 0)
//			load_data_selector_format()
//		elseif (cmpstr(file_format,optics_dataselector_format_2) == 0)
//			if (doBatch)
//				string fn = stringfromlist(findex,file_list)
//				load_data_selector_v2_byname(fn)
//			else
//				load_data_selector_format_v2()
//			endif
//			optics_rename_waves(sys,inst,file_format)
//		elseif (cmpstr(file_format,optics_native_format) == 0)
//			//optics_load_native_format()  // native format has changed
//			load_data_labview_acf_format()
//			optics_rename_waves(sys,inst,file_format)
//		endif
	
		// load_data_selector_format()
	//	// copy user selected CN data to optics_Concentration
	//	if (coptics_use_this_cpc == 0) // use optics_AMS
	//		duplicate/o optics_AMS optics_Concentration
	//	elseif (coptics_use_this_cpc == 1) // use WCPC
	//		duplicate/o WCPC optics_Concentration
	//	else
	//		print "unknown cpc to use!"
	//		Abort "unkown cpc type!"
	//	endif
	//	killwaves/Z optics_AMS, WCPC	
	//	correct_optics_data((coptics_tmp_data_folder+":cn"))
		setdatafolder $optics_tmp_data_folder
	
	
		// "Converting new data to constant time base and averaging into " + num2str(avg_period) + " sec periods"
		optics_same_timebase_tmp(sys,inst)
		
		// Avg to 1 minute
	//	if (optics_data_is_averaged) 
	//		optics_avg_new_data();
	//	endif
		
		//"Adding new data to main data"
		optics_combine_data_from_tmp(sys,inst)
		
		// remove tmp folders and waves
		//optics_clean_up()
		
	endfor
	
	print "Done."
	setdatafolder sdf	
End

// for dataselector format during ICEALOT
Function optics_load_native_format()
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path 
	//LoadWave/J/D/A/W/O/K=0/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
	LoadWave/J/D/A=optics/K=0/L={1,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40} /P=loaddata_base_path
	
	// rename waves

End

Function optics_rename_waves(sys,inst,file_format)
	string sys
	string inst
	string file_format
	string wname_list=""
	string wname_prefix = ""
	string wname_key = ""
	string wname_value = ""
	// if file_format == native
	//    make them look like data_selector names

	//string sdf = getdatafolder(1)
	
	variable i
	if (cmpstr(file_format,optics_native_format) == 0)
		

		if (cmpstr(sys,"rh60") == 0)
			if (cmpstr(inst,"psap_sub1") == 0)
				wname_key = "absorption_467;absorption_530;absorption_660;transmission_467;transmission_530;transmission_660;flow_stp"
				wname_value = "Absorb_467;Absorb_530;Absorb_660;Tr_467;Tr_530;Tr_660;PSAPflow"
				wname_prefix = "Sub1_"
			endif
		elseif (cmpstr(sys,"fRH") == 0)
//			if (cmpstr(inst,"neph_lo") == 0)
//				wname_list = "Start_DateTime;Scattering_450;Scattering_550;Scattering_700;Backscattering_450;Backscattering_550;Backscattering_700;BaroP;SampleT;InletT;RH;LampV;LampI;Status;NephDateTime;SampleMode;Connection;ValvePosition"	
//				wname_prefix = "f_lo__"
//			elseif (cmpstr(inst,"neph_hi") == 0)
//				wname_list = "Start_DateTime;Scattering_450;Scattering_550;Scattering_700;Backscattering_450;Backscattering_550;Backscattering_700;BaroP;SampleT;InletT;RH;LampV;LampI;Status;NephDateTime;SampleMode;Connection;ValvePosition"			
//				wname_prefix = "f_hi__"
//			elseif (cmpstr(inst,"aux") == 0)
//			
//			endif
//		endif
		endif
		
		// create key string
		string wname_hash = stringfromlist(0,wname_key)+":"+stringfromlist(0,wname_value)
		for (i=1; i<itemsinlist(wname_key); i+=1)
			wname_hash += ";"+stringfromlist(i,wname_key)+":"+stringfromlist(i,wname_value)
		endfor
		wname_list = acg_get_wlist_from_folder(":")

		for (i=0; i<itemsinlist(wname_list); i+=1)
			string wn = stringfromlist(i,wname_list)
			string wn_new = stringbykey(wn,wname_hash)
			if (cmpstr(wn,"Start_DateTime")==0)
				rename Start_DateTime, DateTimeW
				
			elseif (cmpstr(wn_new,"")==0)
				killwaves/Z $wn
			else
				wave oldw = $(wn)
				if (waveexists(oldw))
					duplicate/o oldw, $(wname_prefix+wn_new)
				endif
				killwaves/Z oldw				
			endif
		endfor
		

	elseif (cmpstr(file_format,optics_dataselector_format_2) == 0)
		if (cmpstr(sys,"fRH") == 0)
			//setdatafolder $(sys+":"+inst)
			wname_list = acg_get_wlist_from_folder(":")
			string old_str = ""
			string new_str = ""
			if (cmpstr(inst,"neph_hi")==0)
				old_str = "f_hi__"
				new_str = "neph_hi_"
			elseif (cmpstr(inst,"neph_lo")==0)
				old_str = "f_lo__"
				new_str = "neph_lo_"
			elseif (cmpstr(inst,"psap_lo")==0)
				old_str = "f_lo__"
				new_str = "psap_lo_"
			endif				
			
			for (i=0; i<itemsinlist(wname_list); i+=1)
				string wname = stringfromlist(i,wname_list)
				wave oldw = $(wname)
				string wname_new = replacestring(old_str,wname,new_str)
				if (cmpstr(wname, wname_new) != 0)
					duplicate/o oldw $wname_new
					killwaves/Z oldw
				endif
			endfor
		endif
	endif

	//setdatafolder sdf
	
End

// neph

// remove bad values
// correct based on "checks"
// smooth? and calc Ang
	// clean Ang
// truncation correction
// STP correction
// final Ang with corrected values

// psap

// scattering correction
// wavelength adjustment

// fRH lo
// drier corrections
	// loss
	// water vapor loss
// same neph corrections above

// fRH hi
// drier/humidifier correctionss
// same as neph above


Function optics_clean_up()
	print "Cleaning up..."
	killdatafolder/Z $optics_tmp_data_folder
	killdatafolder/Z root:acg_tmp_dataload

End

Function optics_same_timebase_tmp(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder $optics_tmp_data_folder

	//variable tb_index = (optics_data_is_averaged) ? 60 : 1
	variable tb_index = 1
	
	print "Putting new data on constant 1s  time base"
	
//	wave optics_tw = $(":"+sys+":"+inst+":Start_DateTime")
	wave optics_tw = $(":"+sys+":"+inst+":DateTimeW")
	
	// get timebase limits
	wavestats/Q optics_tw
	variable mintime=V_min
	variable maxtime=V_max
	//wavestats/Q optics_tw
	//mintime=(mintime>V_min) ? V_min : mintime
	//maxtime=(maxtime<V_max) ? V_max : maxtime

	variable/G first_starttime=mintime - mod(mintime,tb_index)
	variable/G last_starttime=maxtime - mod(maxtime,tb_index)
	variable time_periods = (last_starttime-first_starttime)/tb_index+1
	string dset_list = "optics"
	variable i,j,k
	make/O/N=(time_periods)/d date_time
	
	date_time[0] = first_starttime
	date_time[1,]  = date_time[p-1]+tb_index
	
	string wname_list = acg_get_wlist_from_folder(":"+sys+":"+inst)

//	// create string wave to hold list of waves to combine
//	//make/O/T/N=(itemsinlist(dset_list)) root:main_wave_list
//	string mwl = coptics_data_folder + ":main_wave_list"
//	make/O/T/N=(itemsinlist(dset_list)) $(mwl)
//	//wave/T wavlist = root:main_wave_list
//	wave/T wavlist = $(mwl)
	
	string wlist=""
	// put all 1sec waves into date_time base
//	for (i=0; i<itemsinlist(dset_list); i+=1)

//		print "	working on " + stringfromlist(i,dset_list) + " data"	
		print "	working on " + sys + ":" + inst + " data"	
		//string wname=""
		variable index=0
		do
			//string ds=":"+stringfromlist(i,dset_list)
			string ds=":"+sys+":"+inst
			string wname = stringfromlist(index,wname_list)
			if (strlen(wname) == 0)
				break
			endif
				
			//Print wname
			if ( (cmpstr(wname,"DateTimeW") !=0) && (cmpstr(wname,"DOY") !=0) && (cmpstr(wname,"AvePeriod") !=0) ) 
				wlist += wname + ";"
			endif
			index += 1
		while(1)
		//print wlist
		//wavlist[i] = wlist

		// do time base once because it takes awhile
		print "		creating time index for constant time base (may take awhile)..."
//		wave dst = $(ds+":Start_DateTime")
		wave dst = $(ds+":DateTimeW")
		get_timebase_index(date_time,dst,1,"time_index")
		wave time_index = $("time_index")
//		duplicate/o dst time_index
//		time_index = -1
//		for (k=0; k<numpnts(dst); k+=1)
//			FindValue/T=(0.2)/V=(dst[k]) date_time
//			time_index[k]=V_value
//		endfor

	
		for (j=0; j<itemsinlist(wlist); j+=1)
			duplicate/o date_time $(stringfromlist(j,wlist))
			wave w = $(stringfromlist(j,wlist))
			SetScale/P x date_time[0],1,"dat", w
			wave dsw = $(ds+":"+stringfromlist(j,wlist))
			variable idx
			
			print "			processing " + stringfromlist(j,wlist)
			
			w = NaN
			
			// insert missing values
			for (k=0; k<numpnts(dsw); k+=1)
				//FindValue/V=(dst[k]) date_time
				//idx=V_value
				idx = time_index[k]
				if (idx > -1)
					w[idx] = dsw[k]
				endif
			endfor
			
		endfor
//	endfor
	
	setdatafolder sdf	
End

Function optics_avg_new_data()
	string sdf = getdatafolder(1)
	setdatafolder $optics_tmp_data_folder
	newdatafolder/o avg
	
	string wname_list = acg_get_wlist_from_folder(":")
	string wlist=""

	variable index=0
	do
		//string ds=":"+sys+":"+inst
		string wname = stringfromlist(index,wname_list)
		if (strlen(wname) == 0)
			break
		endif
			
		//Print wname
		if ( (cmpstr(wname,"date_time") !=0)  && (cmpstr(wname,"time_index") !=0) && (cmpstr(wname,"DateTimeW") !=0) ) 
			wlist += wname + ";"
		endif
		index += 1
	while(1)
	
	// make sure working tb folder exists
	newdatafolder/o/s $acg_tmp_dataload_folder
	if (datafolderexists("input"))
		killdatafolder/Z :input
	endif
	newdatafolder/o/s :input
	
	duplicate/o $(optics_tmp_data_folder+":date_time") Start_DateTime
	
	variable i
	string w
	for (i=0; i<itemsinlist(wlist); i+=1)
		w = stringfromlist(i,wlist)
		duplicate/o $(optics_tmp_data_folder+":"+w) $w
	endfor
	
	// set global var for existing function
	newdatafolder/o root:gui
	if (!waveexists(root:gui:last_avgtime))
		variable/G root:gui:last_avgtime = 0
	endif
	NVAR last_avg = root:gui:last_avgtime
	last_avg = 60
	
	// run avg function
	acg_average_loaded_data()

	newdatafolder/o $(optics_tmp_data_folder+":avg")
	duplicate/o avg_tw $(optics_tmp_data_folder+":avg:date_time")
	for (i=0; i<itemsinlist(wlist); i+=1)
		w = stringfromlist(i,wlist)
		duplicate/o $(w+"_avg") $(optics_tmp_data_folder+":avg:"+w)
	endfor
	
	

	setdatafolder sdf
End

Function optics_apply_pfw(sys,inst)
	string sys
	string inst
	string flag_key // filter to use
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst

//	duplicate/o :orig:optics_datetime optics_datetime
//	duplicate/o :orig:DOY DOY
//
//	wave user_nan = $(":"+optics_orig_folder+":"+inst+"_user_nan")
//	wave check_per = $(":"+optics_orig_folder+":"+inst+"_check_per")	
	
	if (optics_apply_pfw && acg_project_is_set())

		string prefix = ""
		if ( (cmpstr(inst,"neph_sub1")==0) || (cmpstr(inst,"psap_sub1")==0) )
			prefix = "Sub1"		
		elseif ( (cmpstr(inst,"neph_sub10")==0) || (cmpstr(inst,"psap_sub10")==0) )
			prefix = "Sub10"
		elseif (cmpstr(inst,"neph_lo")==0)
			prefix = "neph_lo"
		elseif (cmpstr(inst,"neph_hi")==0)
			prefix = "neph_hi"
		elseif (cmpstr(inst,"psap_lo")==0)
			prefix = "psap_lo"
		else
			return 0
		endif

		prefix += "_*"
		string wlist = acg_get_wlist_from_folder(":",filter_str=prefix)
		string list = ""
		variable j
		for (j=0; j<itemsinlist(wlist); j+=1)
			string wname = stringfromlist(j,wlist)
			if (cmpstr(wname,"optics_datetime") != 0 && cmpstr(wname,"DOY") != 0 && !stringmatch(wname,"*user_nan*")  && !stringmatch(wname,"*check_per*") )
				
				list += wname + ";"
			endif
		endfor
		for (j=0; j<itemsinlist(list); j+=1)
	//		print "		adding " + stringfromlist(j,list)
	//		duplicate/o $(":orig:"+stringfromlist(j,list)) $(stringfromlist(j,list))
			wave main = $(stringfromlist(j,list))
	//		wave orig = $(":orig:"+stringfromlist(j,list))
			
			// 25 March 2009 - Changed to >0 to accomodate check period types (zero, co2)
	//		main = ( (user_nan[p] > 0) || (check_per[p] > 0) ) ? NaN : orig[p]
	
			print "applying project flag wave: ", nameofwave(main)
			print "    SEASWEEP"
			//pfw_filter_wave(main, "SEASWEEP",0, 1)
			pfw_filter_wave(main, "SEASWEEP",nameofwave(main),1, subfld="SEASWEEP")
			// NORMAL has to be last as it replaces main
			print "    NORMAL"
			//pfw_filter_wave(main, "NORMAL",1, 1)
			pfw_filter_wave(main, "AMBIENT",nameofwave(main),1, subfld="AMBIENT")
			//pfw_filter_wave(main, "AMBIENT;AMBIENT_DRY",nameofwave(main),1, subfld="AMBIENT")
			
		endfor

	endif

	setdatafolder sdf

End

// Helper function to filter all waves in an TBM averaged folder. Must set folder to current workding
//     folder
Function optics_apply_pfw_to_avgfolder(filter,[suffix])
	string filter // filter label to apply. Will save all waves in folder named <filter>
	string suffix // suffix to add to all waves names in filtered folder
	
	if (ParamIsDefault(suffix))
		suffix = ""
	else
		suffix = "_"+suffix
	endif
	
	string wlist = acg_get_wlist_from_folder(":")

	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		if (cmpstr(stringfromlist(i,wlist),"date_time") != 0)
			wave w = $(stringfromlist(i,wlist))
			string outname = nameofwave(w)+suffix
			pfw_filter_wave(w, filter ,outname,1, subfld=filter)
		endif
	endfor
	
End

Function optics_create_working_waves(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst

	duplicate/o :orig:optics_datetime optics_datetime
	duplicate/o :orig:DOY DOY

	wave user_nan = $(":"+optics_orig_folder+":"+inst+"_user_nan")
	wave check_per = $(":"+optics_orig_folder+":"+inst+"_check_per")	
	
	
	string wlist = acg_get_wlist_from_folder(":orig")
	string list = ""
	variable j
	for (j=0; j<itemsinlist(wlist); j+=1)
		string wname = stringfromlist(j,wlist)
		if (cmpstr(wname,"optics_datetime") != 0 && cmpstr(wname,"DOY") != 0 && !stringmatch(wname,"*user_nan*")  && !stringmatch(wname,"*check_per*") )
			
			list += wname + ";"
		endif
	endfor
	for (j=0; j<itemsinlist(list); j+=1)
//		print "		adding " + stringfromlist(j,list)
		duplicate/o $(":orig:"+stringfromlist(j,list)) $(stringfromlist(j,list))
		wave main = $(stringfromlist(j,list))
		wave orig = $(":orig:"+stringfromlist(j,list))
		
		// 25 March 2009 - Changed to >0 to accomodate check period types (zero, co2)
		main = ( (user_nan[p] > 0) || (check_per[p] > 0) ) ? NaN : orig[p]
		
	endfor

	if (stringmatch(inst,"neph_*"))
		optics_calc_neph_chek_corr(sys,inst)
	endif	

	// filter using pfw
	//optics_apply_pfw(sys,inst)

	setdatafolder sdf
End

Function optics_combine_data_from_tmp(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	//setdatafolder $ccn_tmp_data_folder
	//setdatafolder root:
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder optics_orig_folder

	print "Adding new data to main data"
	
	if (!waveexists(optics_datetime))
		optics_first_data_copy(sys,inst)
		//optics_create_working_waves(sys,inst)
		optics_init_flag_waves(sys,inst)
		return(0)
	endif 
	
	string dfolder = optics_tmp_data_folder
//	if (!optics_data_is_averaged)
//		dfolder = dfolder + ":avg"
//	endif
	
	//wave main_tw = root:ccn_datetime
	wave new_tw = $(dfolder + ":date_time")
	duplicate/o optics_datetime optics_datetime_bak
	wave bak_tw = optics_datetime_bak

	if (!waveexists($(inst+"_user_nan")))
		optics_init_flag_waves(sys,inst)
	endif
	
	duplicate/o $(inst+"_user_nan") $(inst+"_user_nan_bak")
	wave user_nan =  $(inst+"_user_nan_bak")

	duplicate/o $(inst + "_check_per") $(inst+"_check_per_bak")
	wave check_per =  $(inst+"_check_per_bak")
	
//	duplicate/o cn_cpc_user_nan cn_cpc_user_nan_bak
//	//wave cpc_user_nan_bak = cn_cpc_user_nan_bak
//	duplicate/o cn_ucpc_user_nan cn_ucpc_user_nan_bak
//	//wave ucpc_user_nan_bak = cn_ucpc_user_nan_bak
//	duplicate/o cn_cpc_inst_flag cn_cpc_inst_flag_bak
//	//wave cpc_inst_flag_bak = cn_cpc_inst_flag_bak
//	duplicate/o cn_ucpc_inst_flag cn_ucpc_inst_flag_bak
//	//wave ucpc_inst_flag_bak = cn_ucpc_inst_flag_bak
		
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
	
	variable time_periods = (last_starttime-first_starttime)/optics_tb + 1

	make/o/n=(time_periods)/d optics_datetime
	wave main_tw = optics_datetime
	
	// create main timewave
	main_tw[0] = first_starttime
	main_tw[1,] = main_tw[p-1] + optics_tb
	// create doy wave for convenience
	datetime2doy_wave(main_tw,"DOY")
	
//	// create time_index for main data
	print "	creating main time index for constant time base (may take awhile)..."
	duplicate/o bak_tw bak_time_index
	bak_time_index = -1
	for (k=0; k<numpnts(bak_tw); k+=1)
//		FindValue/T=(0.2)/V=(bak_tw[k]) main_tw
//		bak_time_index[k]=V_value
		bak_time_index[k] = BinarySearch(main_tw,bak_tw[k])
	endfor
//		
//	// create time_index for new data
	print "	creating new time index for constant time base (may take awhile)..."
	duplicate/o new_tw new_time_index
	new_time_index = -1
	for (k=0; k<numpnts(new_tw); k+=1)
//		FindValue/T=(0.2)/V=(new_tw[k]) main_tw
//		new_time_index[k]=V_value
		new_time_index[k]=BinarySearch(main_tw, new_tw[k])
	endfor
		
	// create combine the data: main first and overwrite with new
	//wave/T wlist = main_wave_list
	variable idx
	print "	starting to add..."
	//for (i=0; i<numpnts(main_wave_list); i+=1)
	//string list = wlist[i]
	string wlist = acg_get_wlist_from_folder(dfolder)
	string list = ""
	for (j=0; j<itemsinlist(wlist); j+=1)
		string wname = stringfromlist(j,wlist)
		if (cmpstr(wname,"date_time") != 0 && cmpstr(wname,"time_index") != 0)
			list += wname + ";"
		endif
	endfor
	for (j=0; j<itemsinlist(list); j+=1)
		print "		adding " + stringfromlist(j,list)
		duplicate/o $(stringfromlist(j,list)) $(stringfromlist(j,list)+"_bak")
		duplicate/o main_tw $(stringfromlist(j,list))
		wave main = $(stringfromlist(j,list))
		wave bak = $(stringfromlist(j,list)+"_bak")
		wave new = $(dfolder + ":" + stringfromlist(j,list))

		SetScale/P x main_tw[0],1,"dat", main
		main = NaN

		// remove for now...try using BinarySearch method cf CCN
//		variable starti = x2pnt(main,bak_tw[0])
//		main[starti,starti+numpnts(bak_tw)] = bak[p-starti]
//		starti = x2pnt(main,new_tw[0])
//		main[starti,starti+numpnts(new_tw)] = new[p-starti]
		
		// and add this with a change
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
	//endfor

//	string aux_list = "_user_nan;cn_ucpc_user_nan;cn_cpc_inst_flag;cn_ucpc_inst_flag"
	string aux_list = ""
	aux_list += inst+"_user_nan;"
	aux_list += inst+"_check_per"
	
	wave dt = optics_datetime
	for (i=0; i<itemsinlist(aux_list); i+=1)
		//duplicate/o cn_datetime $(stringfromlist(i,aux_list))
		make/o/n=(numpnts(dt)) $(stringfromlist(i,aux_list))
		wave main = $(stringfromlist(i,aux_list))
		wave bak = $(stringfromlist(i,aux_list)+"_bak")

		SetScale/P x dt[0],1,"dat", main

		main = 0
		
//		starti = x2pnt(main,bak_tw[0])
//		main[starti,starti+numpnts(bak_tw)] = bak[p-starti]
		for (k=0; k<numpnts(bak); k+=1)
			//FindValue/V=(dst[k]) date_time
			//idx=V_value
			idx = bak_time_index[k]
			if (idx > -1)
				main[idx] = bak[k]
			endif
		endfor
	
		killwaves/Z bak
	endfor

//		wave cpc_user_nan = cn_cpc_user_nan
//	wave ucpc_user_nan = cn_ucpc_user_nan
//	cpc_user_nan = ucpc_user_nan = 0
//	wave cpc_inst_flag = cn_cpc_inst_flag
//	wave ucpc_inst_flag = cn_ucpc_inst_flag
//	cpc_inst_flag = cn_get_inst_flag("cpc","default")
//	ucpc_inst_flag = cn_get_inst_flag("ucpc","default")
//		 
//	SetScale/P x cn_datetime[0],1,"dat", cpc_user_nan
//	SetScale/P x cn_datetime[0],1,"dat", ucpc_user_nan
//	SetScale/P x cn_datetime[0],1,"dat", cpc_inst_flag
//	SetScale/P x cn_datetime[0],1,"dat", ucpc_inst_flag

	optics_create_working_waves(sys,inst)
	
	setdatafolder sdf
	
End

Function optics_first_data_copy(sys, inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder $optics_tmp_data_folder
//	string dfolder = optics_tmp_data_folder
//	if (!optics_data_is_averaged)
//		setdatafolder avg
////		dfolder = dfolder +":avg"
//	endif
	
	print "	First time...move new data to main"
	duplicate/o date_time $(optics_data_folder+":"+sys+":"+inst+":"+optics_orig_folder+":optics_datetime")
	
	variable i,j,k
	//wave/T wavlist = root:main_wave_list
	//wave/T wavlist = $(ccn_data_folder + ":main_wave_list")
	//string dfolder = optics_tmp_data_folder
	string wlist = acg_get_wlist_from_folder(":")
	string list = ""
	for (j=0; j<itemsinlist(wlist); j+=1)
		string wname = stringfromlist(j,wlist)
		if (cmpstr(wname,"date_time") != 0  && cmpstr(wname,"time_index") != 0)
			list += wname + ";"
		endif
	endfor
	for (j=0; j<itemsinlist(list); j+=1)
		//duplicate/o $(stringfromlist(j,wlist)+"_avg") root:ccn:$(stringfromlist(j,wlist))
		duplicate/o $(stringfromlist(j,list)) $(optics_data_folder+":"+sys+":"+inst+":"+optics_orig_folder+":"+stringfromlist(j,list))
	endfor
	
	setdatafolder $optics_data_folder
	setdatafolder $sys
	setdatafolder $inst
	setdatafolder $optics_orig_folder
	wave dt = optics_datetime
	datetime2doy_wave(dt,"DOY")
	
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder optics_orig_folder
	
	duplicate/o optics_datetime ::optics_datetime
	for (j=0; j<itemsinlist(list); j+=1)
		duplicate/o $(stringfromlist(j,list)) $("::"+stringfromlist(j,list)) 
	endfor	
	duplicate/o DOY ::DOY
	
//	duplicate dt cn_cpc_user_nan, cn_ucpc_user_nan, cn_cpc_inst_flag, cn_ucpc_inst_flag
//	wave cpc_user_nan = cn_cpc_user_nan
//	wave ucpc_user_nan = cn_ucpc_user_nan
//	cpc_user_nan = 0 
//	ucpc_user_nan = 0
//	wave cpc_inst_flag = cn_cpc_inst_flag
//	wave ucpc_inst_flag = cn_ucpc_inst_flag
//	cpc_inst_flag = cn_get_inst_flag("cpc","default")
//	ucpc_inst_flag = cn_get_inst_flag("ucpc","default")
//		 
//	SetScale/P x dt[0],1,"dat", cpc_user_nan
//	SetScale/P x dt[0],1,"dat", ucpc_user_nan
//	SetScale/P x dt[0],1,"dat", cpc_inst_flag
//	SetScale/P x dt[0],1,"dat", ucpc_inst_flag
	
	
	setdatafolder sdf	
End


Function optics_init_flag_waves(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder optics_orig_folder

	wave dt = optics_datetime
	make/o/n=(numpnts(dt)) $(inst+"_user_nan")
	wave user_nan = $(inst+"_user_nan")
	user_nan = 0
	duplicate/o user_nan $(inst+"_check_per")
	
	setdatafolder sdf
End

Function optics_process_data(sys,inst)
	string sys
	string inst
//	string sdf = getdatafolder(1)
//	setdatafolder optics_data_folder
//	setdatafolder sys
//	setdatafolder inst
//	setdatafolder optics_orig_folder

	optics_create_working_waves(sys,inst)

	if (!datafolderexists(optics_data_folder+":"+sys+":"+inst))
		return 0
	endif

	if (stringmatch(inst,"neph_*"))
		optics_process_neph(sys,inst)
	elseif (stringmatch(inst,"psap_*"))
		optics_process_psap(sys,inst)
	endif

	variable do_filter = 0
	if (do_filter)
		// filter using pfw
		optics_apply_pfw(sys,inst)
	endif
	
	//setdatafolder sdf
End

Function optics_process_neph(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
//	setdatafolder optics_orig_folder

	optics_create_inst_const(sys,inst)
	wave tr_a_cut = trunc_a_cut
	wave tr_b_cut = trunc_b_cut
	wave tr_a_nc = trunc_a_nc
	wave tr_b_nc = trunc_b_nc
	wave scatmin1 = scatmin_1
	wave scatmin60 = scatmin_60
	
	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"		
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif
	
	wave scat450 = $(prefix+"_Scatter_450")
	wave scat550 = $(prefix+"_Scatter_550")
	wave scat700 = $(prefix+"_Scatter_700")
	
	// create waves for psap correction
	duplicate/o scat450 $(prefix+"_Scatter_467_psap")
	wave scat467 = $(prefix+"_Scatter_467_psap")
	duplicate/o scat550 $(prefix+"_Scatter_530_psap")
	wave scat530 = $(prefix+"_Scatter_530_psap")
	duplicate/o scat700 $(prefix+"_Scatter_660_psap")
	wave scat660 = $(prefix+"_Scatter_660_psap")
	
	
	wave bscat450 = $(prefix+"_BackScatter_450")
	wave bscat550 = $(prefix+"_BackScatter_550")
	wave bscat700 = $(prefix+"_BackScatter_700")
	
	wave dt = optics_datetime
	
	duplicate/o scat550 system_cor_factor
	wave sys_cor = system_cor_factor
	sys_cor = 1.0
	
	// calculate fRH corrections
	if (cmpstr(sys,"fRH") == 0)
		// particle loss through system up to lo

		sys_cor = 1.0 / 0.987

		wave T_in = ::neph_lo:neph_lo_NephT_in
		duplicate/o T_in RH_in_tmp
		wave RH_in = RH_in_tmp 
		RH_in = 58.0 // constant for now
		wave P_in = ::neph_lo:neph_lo_NephPressure
		wave RH_out = ::neph_lo:neph_lo_NephRH
		sys_cor *= optics_fRH_vapor_cor(T_in, RH_in, P_in, RH_out)
		//sys_cor *= optics_fRH_vapor_cor()	 
		killwaves RH_in
		
		if (cmpstr(inst,"neph_hi")==0) 
			// should this be changed to drier cor? or should drier cor be added?
			sys_cor *= (1.0 / 0.986) 
			
			wave T_in = ::neph_hi:neph_hi_HumidT
//			wave T_in = ::neph_hi:neph_hi_HygroAT
			wave RH_in = ::neph_lo:neph_lo_NephRH
			wave P_in = ::neph_hi:neph_hi_NephPressure
			wave RH_out = ::neph_hi:neph_hi_HumidRH
//			wave RH_out = ::neph_hi:neph_hi_HygroRH
			sys_cor *= optics_fRH_vapor_cor(T_in, RH_in, P_in, RH_out)
		endif
	endif

	// apply system corrections
		scat450 *= sys_cor
		scat550 *= sys_cor
		scat700 *= sys_cor
	
		bscat450 *= sys_cor
		bscat550 *= sys_cor
		bscat700 *= sys_cor
	
	// apply zero/co2 check corrections
	optics_correct_for_drift(sys,inst,"450",dt,scat450)
	optics_correct_for_drift(sys,inst,"550",dt,scat550)
	optics_correct_for_drift(sys,inst,"700",dt,scat700)

	optics_correct_for_drift(sys,inst,"450",dt,bscat450)
	optics_correct_for_drift(sys,inst,"550",dt,bscat550)
	optics_correct_for_drift(sys,inst,"700",dt,bscat700)
	
	// apply zero/co2 check correction for psap_correction data
	optics_correct_for_drift(sys,inst,"450",dt,scat467)
	optics_correct_for_drift(sys,inst,"550",dt,scat530)
	optics_correct_for_drift(sys,inst,"700",dt,scat660)

	
	// smooth scattering 
	duplicate/o scat450 scat450_smth
	wave smth450 = scat450_smth
	Smooth/B 59, smth450
	//Smooth/B 239, smth450

	duplicate/o scat550 scat550_smth
	wave smth550 = scat550_smth
	Smooth/B 59, smth550
	//Smooth/B 239, smth550

	duplicate/o scat700 scat700_smth
	wave smth700 = scat700_smth
	Smooth/B 59, smth700
	//Smooth/B 239, smth700

	duplicate/o smth450 smth450_59
	duplicate/o smth550 smth550_59
	duplicate/o smth700 smth700_59

	duplicate/o scatmin60 angscatlim 
	wave ascatlim = angscatlim
	
	ascatlim = sqrt(30/60)*(scatmin60)

	// first iteration of Angstrom for trunc cor
	duplicate/o scat450 ang450_550_raw
	wave a450_550_raw = ang450_550_raw
	a450_550_raw = -1*( log( (smth450)/(smth550))) / log(450/550)
	a450_550_raw = ( (smth450[p]<ascatlim[0]) || (smth550[p]<ascatlim[1]) ) ? 1 : a450_550_raw[p]
	a450_550_raw = (a450_550_raw[p] < -1) ? -1 : a450_550_raw[p]
	a450_550_raw = (a450_550_raw[p] > 3) ? 3 : a450_550_raw[p]
	
	duplicate/o scat450 ang450_700_raw
	wave a450_700_raw = ang450_700_raw
	a450_700_raw = -1*( log( (smth450)/(smth700))) / log(450/700)
	a450_700_raw = ( (smth450[p]<ascatlim[0]) || (smth700[p]<ascatlim[2]) ) ? 1 : a450_700_raw[p]
	a450_700_raw = (a450_700_raw[p] < -1) ? -1 : a450_700_raw[p]
	a450_700_raw = (a450_700_raw[p] > 3) ? 3 : a450_700_raw[p]

	duplicate/o scat550 ang550_700_raw
	wave a550_700_raw = ang550_700_raw
	a550_700_raw = -1*( log( (smth550)/(smth700))) / log(550/700)
	a550_700_raw = ( (smth550[p]<ascatlim[1]) || (smth700[p]<ascatlim[2]) ) ? 1 : a550_700_raw[p]
	a550_700_raw = (a550_700_raw[p] < -1) ? -1 : a550_700_raw[p]
	a550_700_raw = (a550_700_raw[p] > 3) ? 3 : a550_700_raw[p]
	

	if (cmpstr(inst,"neph_sub1")==0)
		scat450 = tr_b_cut[0]*a450_550_raw + tr_a_cut[0]*scat450
		scat550 = tr_b_cut[1]*a450_700_raw + tr_a_cut[1]*scat550
		scat700 = tr_b_cut[2]*a550_700_raw + tr_a_cut[2]*scat700
	
		bscat450 = tr_b_cut[3]*bscat450
		bscat550 = tr_b_cut[4]*bscat550
		bscat700 = tr_b_cut[5]*bscat700
		
	elseif (cmpstr(inst,"neph_sub10")==0)
		scat450 = tr_b_nc[0]*a450_550_raw + tr_a_nc[0]*scat450
		scat550 = tr_b_nc[1]*a450_700_raw + tr_a_nc[1]*scat550
		scat700 = tr_b_nc[2]*a550_700_raw + tr_a_nc[2]*scat700
	
		bscat450 = tr_b_nc[3]*bscat450
		bscat550 = tr_b_nc[4]*bscat550
		bscat700 = tr_b_nc[5]*bscat700

	elseif (cmpstr(inst,"neph_lo")==0)
		scat450 = tr_b_cut[0]*a450_550_raw + tr_a_cut[0]*scat450
		scat550 = tr_b_cut[1]*a450_700_raw + tr_a_cut[1]*scat550
		scat700 = tr_b_cut[2]*a550_700_raw + tr_a_cut[2]*scat700
	
		bscat450 = tr_b_cut[3]*bscat450
		bscat550 = tr_b_cut[4]*bscat550
		bscat700 = tr_b_cut[5]*bscat700
	elseif (cmpstr(inst,"neph_fRH_hi")==0)
		scat450 = tr_b_cut[0]*a450_550_raw + tr_a_cut[0]*scat450
		scat550 = tr_b_cut[1]*a450_700_raw + tr_a_cut[1]*scat550
		scat700 = tr_b_cut[2]*a550_700_raw + tr_a_cut[2]*scat700
	
		bscat450 = tr_b_cut[3]*bscat450
		bscat550 = tr_b_cut[4]*bscat550
		bscat700 = tr_b_cut[5]*bscat700
	endif

	// commented 01May2013
//	// Correction according to Anderson and Ogren, 1998
//	scat450 = tr_b_cut[0]*a450_550_raw + tr_a_cut[0]*scat450
//	scat550 = tr_b_cut[1]*a450_700_raw + tr_a_cut[1]*scat550
//	scat700 = tr_b_cut[2]*a550_700_raw + tr_a_cut[2]*scat700
//
//	bscat450 = tr_b_cut[3]*bscat450
//	bscat550 = tr_b_cut[4]*bscat550
//	bscat700 = tr_b_cut[5]*bscat700

	killwaves/Z smth450, smth550, smth700, a450_550_raw, a450_700_raw, a550_700_raw
	killwaves/Z tr_a_cut, tr_b_cut, tr_a_nc, tr_b_nc 
	// STP Corrections
	wave nephP = $(prefix+"_NephPressure")
	wave nephT = $(prefix+"_NephT_samp")
	
	duplicate/o nephT stp
	wave stp
	stp = (1013.2/nephP)*(nephT/273.2)
	scat450 *= stp
	scat550 *= stp
	scat700 *= stp
	bscat450 *= stp
	bscat550 *= stp
	bscat700 *= stp
	
	// Final Angstrom
	// smooth scattering 
	duplicate/o scat450 scat450_smth
	wave smth450 = scat450_smth
	Smooth/B 59, smth450
	//Smooth/B 239, smth450

	duplicate/o scat550 scat550_smth
	wave smth550 = scat550_smth
	Smooth/B 59, smth550
	//Smooth/B 239, smth550

	duplicate/o scat700 scat700_smth
	wave smth700 = scat700_smth
	Smooth/B 59, smth700
	//Smooth/B 239, smth700

	// first iteration of Angstrom for trunc cor
	duplicate/o scat450 $(prefix+ "_Angstrom_450_550")
	wave a450_550_raw = $(prefix+ "_Angstrom_450_550")
	a450_550_raw = -1*( log( (smth450)/(smth550))) / log(450/550)
	//a450_550_raw = (a450_550_raw[p] < -1) ? -1 : a450_550_raw[p]
	//a450_550_raw = (a450_550_raw[p] > 3) ? 3 : a450_550_raw[p]
	
	duplicate/o scat450 $(prefix+ "_Angstrom_450_700")
	wave a450_700_raw = $(prefix+ "_Angstrom_450_700")
	a450_700_raw = -1*( log( (smth450)/(smth700))) / log(450/700)
	//a450_700_raw = (a450_700_raw[p] < -1) ? -1 : a450_700_raw[p]
	//a450_700_raw = (a450_700_raw[p] > 3) ? 3 : a450_700_raw[p]

	duplicate/o scat550 $(prefix+ "_Angstrom_550_700")
	wave a550_700_raw = $(prefix+ "_Angstrom_550_700")
	a550_700_raw = -1*( log( (smth550)/(smth700))) / log(550/700)
	//a550_700_raw = (a550_700_raw[p] < -1) ? -1 : a550_700_raw[p]
	//a550_700_raw = (a550_700_raw[p] > 3) ? 3 : a550_700_raw[p]

	a450_550_raw = ( (scat450[p]<ascatlim[0]) || (scat550[p]<ascatlim[1]) || (scat700[p]<ascatlim[1]) ) ? NaN : a450_550_raw[p]
	a450_700_raw = ( (scat450[p]<ascatlim[0]) || (scat550[p]<ascatlim[1]) || (scat700[p]<ascatlim[1]) ) ? NaN : a450_700_raw[p]
	a550_700_raw = ( (scat450[p]<ascatlim[0]) || (scat550[p]<ascatlim[1]) || (scat700[p]<ascatlim[1]) ) ? NaN : a550_700_raw[p]

	scat467 = scat467*stp * (450/467)^a450_550_raw
	scat530 = scat530*stp * (550/530)^a450_700_raw
	scat660 = scat660*stp * (700/630)^a550_700_raw


	killwaves/Z ascatlim, smth450, smth550, smth700 //, stp
	
	setdatafolder sdf	
End


Function optics_process_psap(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	//setdatafolder optics_orig_folder  ** do not uncomment this...it will change orig waves ***

	optics_create_inst_const(sys,inst)

	string prefix = ""
	if (cmpstr(inst,"psap_sub1")==0)
		prefix = "Sub1"
		
	elseif (cmpstr(inst,"psap_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"psap_lo")==0)
		prefix = "psap_lo"
	else
			return 0;
	endif

	wave absmin1 = absmin_1
	wave absmin60 = absmin_60

	// STP correction
	variable pressure = 840
	//variable pressure = 1013.2
	variable temp_in = 296
	//variable stp_corr = (1013.2/pressure)*(temp_in/273.2)
	variable stp_corr = 1.0
	
	//  flow correction
	//variable flow_corr = 1.00/0.75
	variable flow_corr = 1.00

	//duplicate/o psap467 psap_flow_corr	
	//wave flow_corr = psap_flow_corr
	//flow_corr = 1.0
	//wave psap_flow = $(prefix+"_PSAPflow")
	
	//flow_corr[0,1683646] = 
	
	//string neph_wave_prefix = ":fRH:neph_lo:neph_lo_"
	string neph_wave_prefix = ":rh60:neph_sub1:Sub1_"
	// scattering data for correction - use fRH_lo (since psap is low RH)
	wave scat467 = $(optics_data_folder+neph_wave_prefix+"Scatter_467_psap")
	print "Using " + neph_wave_prefix+"Scatter_467_psap for correction"
	if (!waveexists(scat467))
		print "*** need low fRH neph data to do PSAP correction ***"
		return 0
	endif
	duplicate/o scat467 $(optics_data_folder+neph_wave_prefix+"Scatter_467_psap_smth")
	wave scat467 = $(optics_data_folder+neph_wave_prefix+"Scatter_467_psap_smth")
	
	wave scat530 = $(optics_data_folder+neph_wave_prefix+"Scatter_530_psap")
	duplicate/o scat530 $(optics_data_folder+neph_wave_prefix+"Scatter_530_psap_smth")
	wave scat530 = $(optics_data_folder+neph_wave_prefix+"Scatter_530_psap_smth")

	wave scat660 = $(optics_data_folder+neph_wave_prefix+"Scatter_660_psap")
	duplicate/o scat660 $(optics_data_folder+neph_wave_prefix+"Scatter_660_psap_smth")
	wave scat660 = $(optics_data_folder+neph_wave_prefix+"Scatter_660_psap_smth")
	
	Smooth/B 59, scat467
	Smooth/B 59, scat530
	Smooth/B 59, scat660
	
	// psap data
	wave psap467 = $(prefix+"_Absorb_467")
	wave psap530 = $(prefix+"_Absorb_530")
	wave psap660 = $(prefix+"_Absorb_660")
	
	psap467 = (psap467*flow_corr - 0.013*scat467) * stp_corr
	psap530 = (psap530*flow_corr - 0.016*scat530) * stp_corr
	psap660 = (psap660*flow_corr - 0.021*scat660) * stp_corr

	Smooth/B 239, psap467
	Smooth/B 239, psap530
	Smooth/B 239, psap660
	
	// going to deviate from Berko's method here to calc Anstrom
	// Berko: avg psap to 1min and then calc
	// here: mimic neph and smooth psap
	
	duplicate/o psap467 psap467_smth
	wave smth467 = psap467_smth
	Smooth/B 59, smth467
	//Smooth/B 239, smth467

	duplicate/o psap530 psap530_smth
	wave smth530 = psap530_smth
	Smooth/B 59, smth530
	//Smooth/B 239, smth530
	
	duplicate/o psap660 psap660_smth
	wave smth660 = psap660_smth
	Smooth/B 59, smth660
	//Smooth/B 239, smth660

	duplicate/o psap467 $(prefix+ "_Angstrom_467_530")
	wave a467_530_raw = $(prefix+ "_Angstrom_467_530")
	a467_530_raw = -1*( log( (smth467)/(smth530))) / log(467/530)
	a467_530_raw = ( (smth467[p]<absmin1[0]) || (smth530[p]<absmin1[0]) ) ? NaN : a467_530_raw[p] // switched positive from 1 to NaN
	//a467_530_raw = (a467_530_raw[p] < -1) ? -1 : a467_530_raw[p]
	//a467_530_raw = (a467_530_raw[p] > 3) ? 3 : a467_530_raw[p]
	
	duplicate/o psap467 $(prefix+ "_Angstrom_467_660")
	wave a467_660_raw = $(prefix+ "_Angstrom_467_660")
	a467_660_raw = -1*( log( (smth467)/(smth660))) / log(467/660)
	a467_660_raw = ( (smth467[p]<absmin1[0]) || (smth660[p]<absmin1[2]) ) ? NaN : a467_660_raw[p] // switched positive from 1 to NaN
	//a467_660_raw = (a467_660_raw[p] < -1) ? -1 : a467_660_raw[p]
	//a467_660_raw = (a467_660_raw[p] > 3) ? 3 : a467_660_raw[p]
	
	duplicate/o psap530 $(prefix+ "_Angstrom_530_660")
	wave a530_660_raw = $(prefix+ "_Angstrom_530_660")
	a530_660_raw = -1*( log( (smth530)/(smth660))) / log(530/660)
	a530_660_raw = ( (smth530[p]<absmin1[1]) || (smth660[p]<absmin1[2]) ) ? NaN : a530_660_raw[p] // switched positive from 1 to NaN
	//a530_660_raw = (a530_660_raw[p] < -1) ? -1 : a530_660_raw[p]
	//a530_660_raw = (a530_660_raw[p] > 3) ? 3 : a530_660_raw[p]
	
	killwaves/Z 	smth467, smth530, smth660
	setdatafolder sdf
End	


Function optics_create_inst_const(sys,inst)
	string sys
	string inst
	
	// this function requires you be in the proper folder

	if (stringmatch(inst,"neph_*"))
		make/o/n=3 trunc_a_cut = {1.165, 1.152, 1.120}
		make/o/n=6 trunc_b_cut = {-0.046, -0.044, -0.035, 0.951, 0.947, 0.952}
	
		make/o/n=3 trunc_a_nc = {1.365, 1.337, 1.297}
		make/o/n=6 trunc_b_nc = {-0.156, -0.138, -0.113, 0.981, 0.982, 0.985}
		
		
		if (cmpstr(inst,"neph_sub1")==0)
			make/o/n=3 scatmin_1 = {3.72, 1.64, 3.26} 
			make/o/n=3 scatmin_60 = {0.48, 0.21, 0.42}
		elseif (cmpstr(inst,"neph_sub10")==0)
			make/o/n=3 scatmin_1 = {4.46, 2.24, 3.9}
			make/o/n=3 scatmin_60 = {0.58, 0.29, 0.5}
		elseif (cmpstr(inst,"neph_lo")==0)
			make/o/n=3 scatmin_1 = {3.72, 1.64, 3.26} 
			make/o/n=3 scatmin_60 = {0.48, 0.21, 0.42}
		elseif (cmpstr(inst,"neph_hi")==0)
			make/o/n=3 scatmin_1 = {3.72, 1.64, 3.26} 
			make/o/n=3 scatmin_60 = {0.48, 0.21, 0.42}
		endif
	elseif (stringmatch(inst,"psap_*"))
		make/o/n=3 absmin_1 = {1.26, 1.26, 1.26}
		make/o/n=3 absmin_60 = {0.16, 0.16, 0.16}
	endif
	
End

Function optics_fRH_vapor_cor(T_in, RH_in, P_in, RH_out)
	variable T_in
	variable RH_in
	variable P_in
	variable RH_out
	
	//% Berko Sierau
	//% 08/03/2006
	//
	//% Program to correct neph volume flows for water vapor extraction (drier, neph_lo) 
	//% and water vapor addition (humidifier,neph_hi) in fRH_system
	//
	//% Clausius Clapyron eqn constants
	//
	variable C2 = 2.53e11 // J/kg
	variable L = 2.50e06 //J/K/kg
	variable Rw = 461.5
	//
	//%%%%% low RH neph / drier %%%%%
	//
	//RH_in = 58;              % inlet RH set, otherwise have to exchange values with RH60 system
	//
	//T_in = Neph_t1_temp;          % inlet temp drier = inlet neph_lo
	//P_in = Neph_p_temp;           % inlet press drier = press neph_lo
	//RH_drier = Neph_RH_temp;
	//
	//delta_RH = RH_drier-RH_in;
	variable delta_RH = RH_out - RH_in
	//
	//% vapor pressure [mb]
	variable e_H20 = (C2/100)*exp((-L/Rw)/T_in)
	//
	//% H20 volume fraction extracted from flow
	//
	variable delta_Q = (e_H20/P_in)*(delta_RH/100);
	//
	//% Correction factor
	//
	//Corr_3 = 1.+delta_Q;
	//Corr_drier = Corr_3
	variable vapor_cor = 1.0 + delta_Q
	return vapor_cor
End

function optics_toggle_nans_from_marquee(sys,inst, allPoints, isNaN)
	string sys
	string inst
	variable allPoints
	variable isNaN

	GetMarquee/K/Z left, bottom

	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder optics_orig_folder
	
	string prefix = ""
	if ( (cmpstr(inst,"neph_sub1")==0) || (cmpstr(inst,"psap_sub1")==0) )
		prefix = "Sub1"
	elseif ( (cmpstr(inst,"neph_sub10")==0)  || (cmpstr(inst,"psap_sub10")==0) )
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	elseif (cmpstr(inst,"psap_lo")==0)
		prefix = "psap_lo"
	endif
	
	wave user_nan = $(inst+"_user_nan")
	variable starti, stopi
	starti = round(x2pnt(user_nan,V_left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti >= numpnts(user_nan)) ? numpnts(user_nan)-1 : starti
	stopi = round(x2pnt(user_nan,V_right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi >= numpnts(user_nan)) ? numpnts(user_nan)-1 : stopi
	
	if (!allPoints)
		wave dt = optics_datetime
		string wname = ""
		if (cmpstr(inst,"neph_sub1")==0 )
			wname = "Sub1_Scatter_550"
		elseif (cmpstr(inst,"neph_sub10")==0 )
			wname = "Sub10_Scatter_550"
		elseif (cmpstr(inst,"psap_sub1")==0 )
			wname = "Sub1_Absorb_530"
		elseif (cmpstr(inst,"psap_sub10")==0 )
			wname = "Sub10_Absorb_530"
		elseif (cmpstr(inst,"neph_lo")==0 )
			wname = "neph_lo_Scatter_550"
		elseif (cmpstr(inst,"neph_hi")==0 )
			wname = "neph_hi_Scatter_550"
		endif
		wave d = $wname
		
//		print V_top, V_bottom
//		
//		variable i, j
//		for (i=0; i<numpnts(dt); i+=1)
//			if (dt[i] >= V_left && dt[i]<=V_right)
//				print "in dt", i, secs2time(dt[i],3), d[i]
//				if (d[i] >= V_bottom && d[i] <=V_top)
//					print "in d", i, dt[i], d[i]
//				endif
//			endif
//		endfor

//		variable startyi, stopyi
//		startyi = BinarySearch(d,V_bottom)
//		startyi = (startyi < 0 || startyi == -1)  ? 0 : startyi
		user_nan = ( (dt[p] >= V_left) && (dt[p] <= V_right) && (d[p] >= V_bottom) && (d[p] <= V_top) )? isNan : user_nan[p]
		
//		stopyi = BinarySearch(d,V_top)
//		stopyi = (stopyi > dimsize(dw,1) || stopyi == -2) ? dimsize(dw,1) : stopyi
//	
//		print V_bottom, V_top, startyi, stopyi
//		user_nan[starti,stopi][startyi,stopyi] = isNaN
	else			
		user_nan[starti,stopi] = isNaN
	endif
	
	//cn_reprocess_data(inst)
	//optics_create_working_waves(sys,inst)
	setdatafolder sdf
end

function optics_toggle_chek_from_marquee(sys,inst, isCheck)
	string sys
	string inst
	variable isCheck

	GetMarquee/K/Z bottom

	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder optics_orig_folder
	
	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif
	
	wave user_check = $(inst+"_check_per")
	variable starti, stopi
	starti = round(x2pnt(user_check,V_left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti >= numpnts(user_check)) ? numpnts(user_check)-1 : starti
	stopi = round(x2pnt(user_check,V_right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi >= numpnts(user_check)) ? numpnts(user_check)-1 : stopi
	
	user_check[starti,stopi] = isCheck
	
	
	//cn_reprocess_data(inst)
	//optics_create_working_waves(sys,inst)
	setdatafolder sdf
end

function optics_toggle_chek_type_from_mq(sys,inst, isCheck,typ)
	string sys
	string inst
	variable isCheck
	string typ  // "zero", "co2", 

	if (cmpstr(typ,"zero")==0)
		isCheck = 2
	elseif (cmpstr(typ,"co2")==0)
		isCheck = 3
	else
		isCheck = 1  // reset to check period but unused for correction
	endif
	
	GetMarquee/K/Z bottom

	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder optics_orig_folder
	
	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif
	
	wave user_check = $(inst+"_check_per")
	variable starti, stopi
	starti = round(x2pnt(user_check,V_left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti >= numpnts(user_check)) ? numpnts(user_check)-1 : starti
	stopi = round(x2pnt(user_check,V_right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi >= numpnts(user_check)) ? numpnts(user_check)-1 : stopi
	
	user_check[starti,stopi] = isCheck
	
	
	//cn_reprocess_data(inst)
	//optics_create_working_waves(sys,inst)
	setdatafolder sdf
end

Function optics_create_ICEALOT_masks()

	wave dt = root:optics:fRH:neph_lo:avg_60:date_time
	wave scat = root:optics:fRH:neph_lo:avg_60:neph_lo_Scatter_550

	string sdf = getdatafolder(1)
	setdatafolder root:chemistry
	
		
	wave start_imp = imp_starttime
	wave stop_imp = imp_stoptime
	
	variable i,j
	for (i=0; i<itemsinlist(icealot_mask_list); i+=1)
		string name = stringfromlist(i,icealot_mask_list)
		wave chem_mask = $(name)
		duplicate/o scat $("optics_"+name)
		wave opt_mask = $("optics_"+name)
		opt_mask = NaN
		
		for (j=0; j<numpnts(chem_mask); j+=1)
			variable starti = binarysearch(dt,start_imp[j])
			variable stopi = binarysearch(dt,stop_imp[j])
			
			if (starti>=0 || stopi >=0)
				if (starti == -1)
					starti = 0
				elseif (stopi == -2) 
					stopi = numpnts(dt) - 1
				endif
				
				opt_mask[starti+1,stopi-1] = chem_mask[j]
			endif
		endfor
	endfor
		
	setdatafolder sdf
	
End

Function optics_calc_fRH([filterName])
	string filterName
	
	if (ParamIsDefault(filterName))
		filterName = ""
	endif
		
	string sdf = getdatafolder(1)
	setdatafolder root:optics:fRH
	
	newdatafolder/o/s calc
	if (cmpstr(filterName,"") != 0)
		newdatafolder/o/s $filterName
		filterName += ":"
	endif
	
	make/o/n=3 neph_noise
	wave noise = neph_noise
	noise = {0.69, 0.35, 0.24} // std dev of zero meas from icealot f_lo 
	
	wave RH_hi = $("root:optics:fRH:neph_hi:"+filterName+"avg_60:neph_hi_HumidRH")
//	wave RH_hi = $("root:optics:fRH:neph_hi:"+filterName+"avg_60:neph_hi_HygroRH")
	wave RH_lo = $("root:optics:fRH:neph_lo:"+filterName+"avg_60:neph_lo_NephRH")
	duplicate/o RH_hi rh_data
	wave rh = rh_data
	// filter results to exclude periods when high RH was < 80%??
//	rh = -ln( 1 - ( RH_hi/100) ) / ( 1 - (RH_lo/100) ) 
	rh = ( 100 - RH_lo ) / ( 100 - RH_hi ) 

	variable rh_hi_nom = optics_nominal_fRH_hi_value
	variable rh_hi_range = optics_valid_range_fRH_hi_value
	rh = ( (RH_hi[p] < (rh_hi_nom-rh_hi_range)) || (RH_hi[p] > (rh_hi_nom+rh_hi_range)) ) ? NaN : rh[p]
	
	string wl_list = "450;550;700"
	variable i,j
	for (i=0; i<itemsinlist(wl_list); i+=1)
//	for (i=1; i<itemsinlist(wl_list); i+=3)
		string wl = "Scatter_"+stringfromlist(i,wl_list)
		
		duplicate/o $("root:optics:fRH:neph_hi:"+filterName+"avg_60:neph_hi_"+wl) hi_scattering
		wave hi_scat = hi_scattering
		duplicate/o $("root:optics:fRH:neph_lo:"+filterName+"avg_60:neph_lo_"+wl) lo_scattering
		wave lo_scat = lo_scattering
		
		// filter out all data where signal < 3*noise
		hi_scat = (hi_scat[p] < 3*noise[i]) ? NaN : hi_scat
		lo_scat = (lo_scat[p] < 3*noise[i]) ? NaN : lo_scat
		
		
		//duplicate/o hi_scat y_data //, gamma_fit
		duplicate/o hi_scat $("gamma_fn_"+stringfromlist(i,wl_list))
		duplicate/o hi_scat $("fRH_"+stringfromlist(i,wl_list))
		//wave y = y_data
		//wave g_fit = gamma_fit
		wave g_fn = $("gamma_fn_"+stringfromlist(i,wl_list))
		g_fn = NaN
		wave frh = $("fRH_"+stringfromlist(i,wl_list))
		frh = NaN
		
		frh =  hi_scat/lo_scat
		
		g_fn = ln(frh)/ln(rh)
		//g_fn = (g_fn[p] < 0 || g_fn[p] > 1) ? NaN : g_fn[p]
		//g_fn = y / rh
		
		//duplicate/o g_fn $("gamma_fn_"+stringfromlist(i,wl_list))
		if (optics_do_mask)
			// create masked waves and average
			string mask_list = icealot_mask_list
			
			if (i==0)
				make/o/T/n=(itemsinlist(mask_list)) mask_labels
				wave/T labels = mask_labels
				for (j=0; j<itemsinlist(mask_list); j+=1)
					labels[j] = stringfromlist(j,mask_list)
				endfor
			endif
			make/o/n=(itemsinlist(mask_list)) $("fRH_avg_"+stringfromlist(i,wl_list))
			wave frh_avg = $("fRH_avg_"+stringfromlist(i,wl_list))
			frh_avg = NaN
			duplicate/o frh_avg $("fRH_sd_"+stringfromlist(i,wl_list))
			wave frh_sd = $("fRH_sd_"+stringfromlist(i,wl_list))
			duplicate/o frh_avg $("gamma_fn_avg_"+stringfromlist(i,wl_list))
			wave g_fn_avg = $("gamma_fn_avg_"+stringfromlist(i,wl_list))
			duplicate/o frh_avg $("gamma_fn_sd_"+stringfromlist(i,wl_list))
			wave g_fn_sd = $("gamma_fn_sd_"+stringfromlist(i,wl_list))
			
			for (j=0; j<itemsinlist(mask_list); j+=1)
				string region = stringfromlist(j,mask_list)
				duplicate/o frh $("fRH_"+stringfromlist(i,wl_list)+"_"+region)
				duplicate/o g_fn $("gamma_fn_"+stringfromlist(i,wl_list)+"_"+region)
				
				wave frh_mask = $("fRH_"+stringfromlist(i,wl_list)+"_"+region)
				wave g_fn_mask = $("gamma_fn_"+stringfromlist(i,wl_list)+"_"+region)
				
				wave mask = $("root:chemistry:optics_"+region)
				
				frh_mask = frh*mask
				g_fn_mask = g_fn*mask
			
				duplicate/o frh agg_mask
				wave agg = agg_mask
				agg = NaN
				agg =  (g_fn_mask[p] < 0  ||  g_fn_mask[p] > 1 || frh[p] < 1) ? NaN : 1
				frh_mask *= agg
				g_fn_mask *= agg
				 
				//frh_mask = (g_fn_mask[p] < 0  ||  g_fn_mask[p] > 1 || frh) ? NaN : frh_mask[p]
				//g_fn_mask = (g_fn_mask[p] < 0  ||  g_fn_mask[p] > 1) ? NaN : g_fn_mask[p]
				
				WaveStats/Q frh_mask
				frh_avg[j] = V_avg
				frh_sd[j] = V_sdev
			 	WaveStats/Q g_fn_mask
				g_fn_avg[j] = V_avg
				g_fn_sd[j] = V_sdev
			endfor
		endif
		//optics_mask_fRH(...)
		
		
//		for (j=0; j<itemsinlist(icealot_mask_list); j+=1)			
//			
//			wave mask = $("root:chemistry:optics_"+stringfromlist(j,icealot_mask_list))
//			duplicate/o hi_scat x_data
//			wave x = x_data 
//			x = rh*mask
//			
//			duplicate/o hi_scat y_data
//			wave y = y_data
//			y = (hi_scat/lo_scat)*mask
//			
//			variable/G $("gamma_"+mask)
//			NVAR gam = $("gamma_"+mask)
//			
//			gam = optics_find_gamma_fit(x, y)
//			print "gamma_"+mask+" = ", gam
//		endfor
	endfor	
	
	setdatafolder sdf
End

Function optics_find_gamma_fit(xdata, ydata)
	wave xdata
	wave ydata
		
	CurveFit/NTHR=1 line  ydata /X=xdata/D 
	//variable c1 = W_coef[1]
	//return c1

End


//Function optics_get_noise_icealot(dat, zero,wl)
//Function optics_get_noise_icealot(inst,dat,wl)
Function optics_get_noise_icealot(inst,wl,smth)
	string inst
//	wave dat
//	wave zero
	variable wl 
	variable smth
	
//	zero = NaN
	
	//variable starti = 427213
	//variable stopi = 427637
	//zero = ( (p>=427213 && p<=427637) || (p>=1264129 && p<=1264360) || 
	//             (p>=1879481 && p<=1880310) || (p>=2487510 && p<=2488320) ) ? dat[p] : NaN
	//zero = (p>=1264129 && p<=1264360) ? dat[p] : NaN
	//zero = (p>=1879481 && p<=1880310) ? dat[p] : NaN
	//zero = (p>=2487510 && p<=2488320) ? dat[p] : NaN
//	zero[427213,427637] = dat[p]
//	zero[1264129,1264360] = dat[p]
//	zero[1879481,1880310] = dat[p]
//	zero[2487510,2488320] = dat[p]
	
	wave user_check = $(":orig:"+inst+"_check_per")

	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif

	wave dat =  $(":orig:"+prefix+"_Scatter_"+num2str(wl))
	duplicate/o dat zero_data_smth
	wave dat_smth = zero_data_smth
	
	if (smth>1)
		Smooth/B (smth-1), dat_smth
		 duplicate/o dat_smth $("zero_for_noise_" + num2str(wl))
	else
		duplicate/o dat_smth $("zero_for_noise_" + num2str(wl))
	endif
	wave zero = $("zero_for_noise_" + num2str(wl))
	
	zero = (user_check[p] == 2) ? dat_smth[p] : NaN
	
	variable idx 
	if (wl == 450)
		idx = 0
	elseif (wl == 550)
		idx = 1
	elseif (wl == 700)
		idx = 2
	else
		return -999
	endif
	
	zero = (abs(zero[p]) > 10) ? NaN : zero[p]
	WaveStats/Q zero
	
	if (!waveexists(noise_results))
		make/n=(3,2) noise_results
	endif
	wave results = noise_results
	results[idx][0] = V_avg
	results[idx][1] = V_sdev

	variable dev3= V_sdev
	print "3 * stdev = ", dev3
	return dev3
	
End

Function optics_get_noise_icealot_600(inst,wl)
	string inst
//	wave dat
//	wave zero
	variable wl 
//	variable smth
	
//	zero = NaN
	
	//variable starti = 427213
	//variable stopi = 427637
	//zero = ( (p>=427213 && p<=427637) || (p>=1264129 && p<=1264360) || 
	//             (p>=1879481 && p<=1880310) || (p>=2487510 && p<=2488320) ) ? dat[p] : NaN
	//zero = (p>=1264129 && p<=1264360) ? dat[p] : NaN
	//zero = (p>=1879481 && p<=1880310) ? dat[p] : NaN
	//zero = (p>=2487510 && p<=2488320) ? dat[p] : NaN
//	zero[427213,427637] = dat[p]
//	zero[1264129,1264360] = dat[p]
//	zero[1879481,1880310] = dat[p]
//	zero[2487510,2488320] = dat[p]
	
	wave user_check = $(":orig:"+inst+"_check_per")

	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif

	wave dat =  $(":orig:"+prefix+"_Scatter_"+num2str(wl))

	newdatafolder/o/s noise_600sec
	
	duplicate/o dat $("zero_for_noise_" + num2str(wl))
	wave zero = $("zero_for_noise_" + num2str(wl))
	
	//zero = (user_check[p] == 2) ? dat[p] : NaN
	
	zero = NaN
	//zero[1986868,2004320] = dat[p]
	zero[2467460,2479170] = dat[p]
	zero[2484376,2496595] = dat[p]

//	variable idx 
//	if (wl == 450)
//		idx = 0
//	elseif (wl == 550)
//		idx = 1
//	elseif (wl == 700)
//		idx = 2
//	else
//		return -999
//	endif
//	
//	zero = (abs(zero[p]) > 10) ? NaN : zero[p]
//	WaveStats/Q zero
//	
//	if (!waveexists(noise_results))
//		make/n=(3,2) noise_results
//	endif
//	wave results = noise_results
//	results[idx][0] = V_avg
//	results[idx][1] = V_sdev
//
//	variable dev3= V_sdev
//	print "3 * stdev = ", dev3
//	return dev3
	
	setdatafolder ::
End

Function optics_psap_noise_icealot_600(inst,wl)
	string inst
//	wave dat
//	wave zero
	variable wl 
//	variable smth
	
//	zero = NaN
	
	//variable starti = 427213
	//variable stopi = 427637
	//zero = ( (p>=427213 && p<=427637) || (p>=1264129 && p<=1264360) || 
	//             (p>=1879481 && p<=1880310) || (p>=2487510 && p<=2488320) ) ? dat[p] : NaN
	//zero = (p>=1264129 && p<=1264360) ? dat[p] : NaN
	//zero = (p>=1879481 && p<=1880310) ? dat[p] : NaN
	//zero = (p>=2487510 && p<=2488320) ? dat[p] : NaN
//	zero[427213,427637] = dat[p]
//	zero[1264129,1264360] = dat[p]
//	zero[1879481,1880310] = dat[p]
//	zero[2487510,2488320] = dat[p]
	
	wave user_check = $(":orig:"+inst+"_check_per")

	string prefix = ""
	if (cmpstr(inst,"psap_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"psap_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"psap_lo")==0)
		prefix = "psap_lo"
	endif

	wave dat =  $(":orig:"+prefix+"_Absorb_"+num2str(wl))

	newdatafolder/o/s noise_600sec
	
	duplicate/o dat $("zero_for_noise_" + num2str(wl))
	wave zero = $("zero_for_noise_" + num2str(wl))
	
	//zero = (user_check[p] == 2) ? dat[p] : NaN
	
	zero = NaN
	//zero[1986868,2004320] = dat[p]
	zero[2467460,2479170] = dat[p]
	zero[2484376,2496595] = dat[p]

//	variable idx 
//	if (wl == 450)
//		idx = 0
//	elseif (wl == 550)
//		idx = 1
//	elseif (wl == 700)
//		idx = 2
//	else
//		return -999
//	endif
//	
//	zero = (abs(zero[p]) > 10) ? NaN : zero[p]
//	WaveStats/Q zero
//	
//	if (!waveexists(noise_results))
//		make/n=(3,2) noise_results
//	endif
//	wave results = noise_results
//	results[idx][0] = V_avg
//	results[idx][1] = V_sdev
//
//	variable dev3= V_sdev
//	print "3 * stdev = ", dev3
//	return dev3
	
	setdatafolder ::
End

Function optics_calc_bsf(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder avg_60

	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
		
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif

	make/o/n=3 neph_noise
	wave noise = neph_noise
	noise = {0.69, 0.35, 0.24} // std dev of zero meas from icealot f_lo 


//	// now do the same for the mask regions
//	newdatafolder/o/s masks

	string wl_list = "450;550;700"
	variable i,j
	for (i=0; i<itemsinlist(wl_list); i+=1)
		string wl = stringfromlist(i,wl_list)

		duplicate/o $(prefix+"_Scatter_"+wl) tmp_scat
		wave scat = tmp_scat
		duplicate/o $(prefix+"_BackScatter_"+wl) tmp_bscat
		wave bscat = tmp_bscat

		// filter out all data where signal < 3*noise
		scat = (scat[p] < 3*noise[i]) ? NaN : scat[p]
		bscat = (scat[p] < 3*noise[i]) ? NaN : bscat[p]

		duplicate/o scat $(prefix+"_BSF_"+wl)
		wave bsf = $(prefix+"_BSF_"+wl)
		
		bsf = bscat/scat
		
		
		// create masked waves and average
		string mask_list = icealot_mask_list
		
		if (i==0)
			make/o/T/n=(itemsinlist(mask_list)) mask_labels
			wave/T labels = mask_labels
			for (j=0; j<itemsinlist(mask_list); j+=1)
				labels[j] = stringfromlist(j,mask_list)
			endfor
		endif
		make/o/n=(itemsinlist(mask_list)) $(prefix+"_BSF_avg_"+stringfromlist(i,wl_list))
		wave bsf_avg = $(prefix+"_BSF_avg_"+stringfromlist(i,wl_list))
		bsf_avg = NaN
		duplicate/o bsf_avg $(prefix+"_BSF_sd_"+stringfromlist(i,wl_list))
		wave bsf_sd = $(prefix+"_BSF_sd_"+stringfromlist(i,wl_list))
		
		if (optics_do_mask)
			for (j=0; j<itemsinlist(mask_list); j+=1)
				string region = stringfromlist(j,mask_list)
				duplicate/o bsf $(prefix+"_BSF_"+stringfromlist(i,wl_list)+"_"+region)
							
				wave bsf_mask = $(prefix+"_BSF_"+stringfromlist(i,wl_list)+"_"+region)
				
				wave mask = $("root:chemistry:optics_"+region)
				
				bsf_mask = bsf*mask
			
	//			duplicate/o bsf agg_mask
	//			wave agg = agg_mask
	//			agg = NaN
	//			agg =  (g_fn_mask[p] < 0  ||  g_fn_mask[p] > 1 || frh[p] < 1) ? NaN : 1
	//			frh_mask *= agg
	//			g_fn_mask *= agg
				 
				//frh_mask = (g_fn_mask[p] < 0  ||  g_fn_mask[p] > 1 || frh) ? NaN : frh_mask[p]
				//g_fn_mask = (g_fn_mask[p] < 0  ||  g_fn_mask[p] > 1) ? NaN : g_fn_mask[p]
				
				bsf_mask = (bsf_mask[p]<0 || bsf_mask[p]>1) ? NaN : bsf_mask[p] 
				
				WaveStats/Q bsf_mask
				bsf_avg[j] = V_avg
				bsf_sd[j] = V_sdev
			endfor	
		endif	
	endfor	
	
	setdatafolder sdf
	
End


Function optics_calc_ssa(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	
	string prefix
	string neph_prefix=""
	string psap_prefix=""
	if ( (cmpstr(inst,"neph_sub1")==0) || (cmpstr(inst,"psap_sub1")==0) )
		prefix = "Sub1"
		// had to use project_tb_60 for Uintah dataset
//		neph_prefix="neph_sub1:avg_60:project_tb_60:Sub1"
//		psap_prefix = "psap_sub1:avg_60:project_tb_60:Sub1"
		neph_prefix="neph_sub1:avg_60:Sub1"
		psap_prefix = "psap_sub1:avg_60:Sub1"
	elseif ( (cmpstr(inst,"neph_sub10")==0) || (cmpstr(inst,"psap_sub10")==0) )
		prefix = "Sub10"
		neph_prefix="neph_sub10:avg_60:Sub10"
		psap_prefix = "psap_sub10:avg_60:Sub10"
	elseif ( (cmpstr(inst,"neph_lo")==0) || (cmpstr(inst,"psap_lo")==0) )
		prefix = "fRH_lo"
		neph_prefix="neph_lo:avg_60:neph_lo"
		psap_prefix = "psap_lo:avg_60:psap_lo"
	endif
	
	wave neph450 = $(":"+neph_prefix+"_Scatter_450")
	wave neph550 = $(":"+neph_prefix+"_Scatter_550")
	wave neph700 = $(":"+neph_prefix+"_Scatter_700")

	wave neph_ang_450_550 = $(":"+neph_prefix+"_Angstrom_450_550")
	wave neph_ang_450_700 = $(":"+neph_prefix+"_Angstrom_450_700")
	wave neph_ang_550_700 = $(":"+neph_prefix+"_Angstrom_550_700")

	wave psap467 = $(":"+psap_prefix+"_Absorb_467")
	wave psap530 = $(":"+psap_prefix+"_Absorb_530")
	wave psap660 = $(":"+psap_prefix+"_Absorb_660")

	newdatafolder/o/s calc

	duplicate/o neph450 $(prefix+"_SSA_467")
	wave ssa_467 = $(prefix+"_SSA_467")
	duplicate/o neph550 $(prefix+"_SSA_530")
	wave ssa_530 = $(prefix+"_SSA_530")
	duplicate/o neph700 $(prefix+"_SSA_660")
	wave ssa_660 = $(prefix+"_SSA_660")

	duplicate/o neph450 scatter_467
	wave neph467 = scatter_467
	duplicate/o neph550 scatter_530
	wave neph530 = scatter_530
	duplicate/o neph700 scatter_660
	wave neph660 = scatter_660

	neph467 = neph450 * (450/467)^neph_ang_450_550
	neph530 = neph550 * (550/530)^neph_ang_450_700
	neph660 = neph700 * (700/660)^neph_ang_550_700

	ssa_467 = neph467 / (neph467 + psap467)
	ssa_530 = neph530 / (neph530 + psap530)
	ssa_660 = neph660 / (neph660 + psap660)

	ssa_467 = (ssa_467[p] < 0 || ssa_467[p] > 1) ? NaN : ssa_467[p]
	ssa_530 = (ssa_530[p] < 0 || ssa_530[p] > 1) ? NaN : ssa_530[p]
	ssa_660 = (ssa_660[p] < 0 || ssa_660[p] > 1) ? NaN : ssa_660[p]

	//killwaves/Z neph467, neph530, neph660	
	setdatafolder sdf
	
End

Function optics_calc_fmf(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	
	string prefix
	string neph1_prefix=""
	string neph10_prefix=""
	string psap_prefix=""
	if ( (cmpstr(inst,"neph_sub1")==0) || (cmpstr(inst,"neph_sub10")==0) )
		prefix = "rh60"
		neph1_prefix="neph_sub1:avg_60:Sub1"
		neph10_prefix = "neph_sub10:avg_60:Sub10"
//	elseif ( (cmpstr(inst,"neph_sub10")==0) || (cmpstr(inst,"psap_sub10")==0) )
//		prefix = "Sub10"
//		neph_prefix="neph_sub10:avg_60:Sub10"
//		psap_prefix = "psap_sub10:avg_60:Sub10"
//	elseif ( (cmpstr(inst,"neph_lo")==0) || (cmpstr(inst,"psap_lo")==0) )
//		prefix = "fRH_lo"
//		neph_prefix="neph_lo:avg_60:neph_lo"
//		psap_prefix = "psap_lo:avg_60:psap_lo"
	endif
	
	wave neph450_1 = $(":"+neph1_prefix+"_Scatter_450")
	wave neph550_1 = $(":"+neph1_prefix+"_Scatter_550")
	wave neph700_1 = $(":"+neph1_prefix+"_Scatter_700")

	wave neph450_10 = $(":"+neph10_prefix+"_Scatter_450")
	wave neph550_10 = $(":"+neph10_prefix+"_Scatter_550")
	wave neph700_10 = $(":"+neph10_prefix+"_Scatter_700")

	newdatafolder/o/s calc

	duplicate/o neph450_1 $(prefix+"_FMF_450")
	wave fmf_450 = $(prefix+"_FMF_450")
	duplicate/o neph550_1 $(prefix+"_FMF_550")
	wave fmf_550 = $(prefix+"_FMF_550")
	duplicate/o neph700_1 $(prefix+"_FMF_700")
	wave fmf_700 = $(prefix+"_FMF_700")

	fmf_450 = neph450_1 / neph450_10
	fmf_550 = neph550_1 / neph550_10
	fmf_700 = neph700_1 / neph700_10

	fmf_450 = (fmf_450[p] < 0 || fmf_450 > 1) ? NaN : fmf_450[p]
	fmf_550 = (fmf_550[p] < 0 || fmf_550 > 1) ? NaN : fmf_550[p]
	fmf_450 = (fmf_700[p] < 0 || fmf_700 > 1) ? NaN : fmf_700[p]

	killwaves/Z neph467, neph530, neph660	
	setdatafolder sdf
	
End


Function optics_calc_neph_chek_corr(sys,inst)
	string sys
	string inst
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
//	setdatafolder orig
	
	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif

//	wave scat450 = $(prefix+"_Scatter_450")
//	wave scat550 = $(prefix+"_Scatter_550")
//	wave scat700 = $(prefix+"_Scatter_700")
//
//	wave bscat450 = $(prefix+"_BackScatter_450")
//	wave bscat550 = $(prefix+"_BackScatter_550")
//	wave bscat700 = $(prefix+"_BackScatter_700")

	wave dt = $(":orig:"+"optics_datetime")
	wave nephP = $(":orig:"+prefix+"_NephPressure")
	wave nephT = $(":orig:"+prefix+"_NephT_samp")

	wave user_check = $(":orig:"+inst+"_check_per")

	newdatafolder/o/s neph_check

	make/o/n=2 $(prefix+"_check_dt_avg")
	wave chk_dt = $(prefix+"_check_dt_avg")
	chk_dt[0] = dt[0]
	chk_dt[1] = dt[numpnts(dt)-1]

	string wl_list = "450;550;700"
	variable i,j,k
	for (i=0; i<itemsinlist(wl_list); i+=1)
		string wl = stringfromlist(i,wl_list)
		wave scat = $("::orig:"+prefix+"_Scatter_"+wl)
//		wave bscat = $("::orig:"+prefix+"_BackScatter_"+wl)
		
//		duplicate/o scat $(prefix+"_check_zero_"+wl)
//		duplicate/o scat $(prefix+"_check_co2_"+wl)
//		make/o/n=(numpnts(scat),2) $(prefix+"_check_val_"+wl)
//		make/o/n=(numpnts(scat),2) $(prefix+"_check_val_"+wl)
//		make/o/n=(numpnts(scat),2) $(prefix+"_check_corr_"+wl)
//		//duplicate/o scat $(prefix+"_Scatter_"+wl+"_co2")
//		wave val = $(prefix+"_check_val_"+wl) 
//		wave corr = $(prefix+"_check_corr_"+wl) 
//		wave zero_val = $(prefix+"_check_zero_"+wl)
//		wave co2_val = $(prefix+"_check_co2_"+wl)

			
		// create initial wave with data for start and stop of data
		make/o/n=2 $(prefix+"_check_zero_"+wl+"_avg")
		make/o/n=2 $(prefix+"_check_co2_"+wl+"_avg")
		wave chk_zero = $(prefix+"_check_zero_"+wl+"_avg")
		wave chk_co2 = $(prefix+"_check_co2_"+wl+"_avg")


		make/o/n=2 $(prefix+"_check_O_"+wl+"_avg")
		make/o/n=2 $(prefix+"_check_S_"+wl+"_avg")
		wave chk_O = $(prefix+"_check_O_"+wl+"_avg")
		wave chk_S = $(prefix+"_check_S_"+wl+"_avg")
		 
		 // init 
		 chk_zero = 0
		 chk_co2 = NaN
		chk_O = 0
		chk_S = 1.0
		
//		val = NaN
//		corr = NaN
//		
//		zero_val = NaN
//		co2_val = NaN
		
		variable starti, stopi, haveBoth, curr_size
		stopi = -1
		starti = -1
		haveBoth = 0
		j=0
		curr_size = 2
		do
			if (user_check[j] > 0)
				if (starti < 0)
					starti = j
				else
					stopi = j
				endif
			else
				if (starti>=0 && stopi>=0)
					if  ( optics_find_neph_check_avg(starti, stopi, user_check,scat,"check_avg_w") )
						wave avg = check_avg_w
						
	//					val[starti,stopi][0] = avg[0]
	//					val[starti,stopi][1] = avg[1]
	//
	//					zero_val[starti,stopi] = avg[0]
	//					co2_val[starti,stopi] = avg[1]
						
						duplicate/o avg chk_vals
						//variable zero = avg[0]
						//variable co2 = avg[1]
						
						chk_zero[numpnts(chk_zero)-1] = avg[0]
						redimension/n=(curr_size+1) chk_zero
						chk_zero[numpnts(chk_zero)-1] = avg[0]
						
						chk_co2[numpnts(chk_co2)-1] = avg[1]
						redimension/n=(curr_size+1) chk_co2
						chk_co2[numpnts(chk_co2)-1] = avg[1]
						
						
						optics_find_neph_check_TandP(starti, stopi, user_check,nephT,"check_avg_w")
						wave avg = check_avg_w
						duplicate/o avg Tchk
						//variable Tzero = avg[0]
						//variable Tco2 = avg[1]
						
						optics_find_neph_check_TandP(starti, stopi, user_check,nephP,"check_avg_w")
						wave avg = check_avg_w
						duplicate/o avg Pchk
						//variable Pzero = avg[0]
						//variable Pco2 = avg[1]
						
						// calc O and S for this period
						optics_calc_corr_coef(chk_vals, str2num(wl), Tchk, Pchk, "coef_w")
						wave coef = coef_w
	
						chk_O[numpnts(chk_O)-1] = coef[0]
						redimension/n=(curr_size+1) chk_O
						chk_O[numpnts(chk_O)-1] = coef[0]
						
						chk_S[numpnts(chk_S)-1] = coef[1]
						redimension/n=(curr_size+1) chk_S
						chk_S[numpnts(chk_S)-1] = coef[1]
						
						if (str2num(wl) == 450)
							wavestats/Q/R=[starti,stopi] dt
							chk_dt[numpnts(chk_dt)-1] = V_avg
							redimension/n=(curr_size+1) chk_dt
							chk_dt[numpnts(chk_dt)-1] = dt[numpnts(dt)-1]
						endif
						
						curr_size += 1
							
						starti = -1
						stopi = -1
						
						killwaves/Z avg, chk_vals, Tchk, Pchk, coef
				
					else
						starti = -1
						stopi = -1
					endif
				endif
			endif
			
			j+=1
			
		while (j<numpnts(user_check))


//		if (optics_init_checks_to_zero)

//		// interpolate all points all val
//		// start with ends
//		j=0
//		starti = -1
//		do
//			if (numtype(zero_val[j]) == 0)
//				starti = j
//			endif
//			j+=1
//		while (j<numpnts(zero_val) && starti < 0)
//		zero_val[0,starti] = zero_val[starti] 
//		co2_val[0,starti] = co2_val[starti] 
//		
//		j=numpnts(zero_val)-1
//		starti = -1
//		do
//			if (numtype(zero_val[j]) == 0)
//				starti = j
//			endif
//			j-=1
//		while (j>=0 && starti < 0)
//		zero_val[starti,numpnts(zero_val)-1] = zero_val[starti] 
//		co2_val[starti,numpnts(zero_val)-1] = co2_val[starti] 

		// set initial values of coeffiecients to first "real"
		if (numpnts(chk_O) > 2)
			chk_O[0] = chk_O[1]
			chk_S[0] = chk_S[1]

			chk_zero[0] = chk_zero[1]
			chk_co2[0] = chk_co2[1]
		endif
	endfor
	
	setdatafolder sdf
End

Function optics_find_neph_check_TandP(starti, stopi, user_check,param,avg_result_name)
	variable starti
	variable stopi
	wave user_check
	wave param
	string avg_result_name
	
	make/o/n=2 $avg_result_name
	wave avg_result = $avg_result_name
	avg_result = NaN
	
	// check to see if this is a valid check period (i.e., has both zero and co2)
	variable i
	variable hasZERO =  0
	variable hasCO2 = 0
	variable hasBOTH = 0
	for (i=starti; i<=stopi; i+=1)
		if (user_check[i] == 2)
			hasZERO = 1
		elseif (user_check[i] == 3)
			hasCO2 = 1
		endif
		
		if (hasZERO && hasCO2)
			hasBOTH = 1
			break
		endif
	endfor
	
	if (!hasBOTH)
		return 0
	endif
	
	make/o/n=(stopi-starti+1) avg_zero
	wave avg_zero
	avg_zero = NaN
	
	make/o/n=(stopi-starti+1) avg_co2
	wave avg_co2
	
	avg_zero = (user_check[p+starti] == 2) ? param[p+starti] : NaN
	avg_co2 = (user_check[p+starti] == 3) ? param[p+starti] : NaN
	
	wavestats/Q avg_zero
	avg_result[0] = V_avg

	wavestats/Q avg_co2
	avg_result[1] = V_avg
	
	killwaves/Z avg_zero, avg_co2
		
End


Function optics_find_neph_check_avg(starti, stopi, user_check,scat,avg_result_name)
	variable starti
	variable stopi
	wave user_check
	wave scat
	string avg_result_name
	
	make/o/n=2 $avg_result_name
	wave avg_result = $avg_result_name
	avg_result = NaN
	
	// check to see if this is a valid check period (i.e., has both zero and co2)
	variable i
	variable hasZERO =  0
	variable hasCO2 = 0
	variable hasBOTH = 0
	for (i=starti; i<=stopi; i+=1)
		if (user_check[i] == 2)
			hasZERO = 1
		elseif (user_check[i] == 3)
			hasCO2 = 1
		endif
		
		if (hasZERO && hasCO2)
			hasBOTH = 1
			break
		endif
	endfor
	
	if (!hasBOTH)
		return 0
	endif
	
	make/o/n=(stopi-starti+1) avg_zero
	wave avg_zero
	avg_zero = NaN
	
	make/o/n=(stopi-starti+1) avg_co2
	wave avg_co2
	
	avg_zero = (user_check[p+starti] == 2) ? scat[p+starti] : NaN
	avg_co2 = (user_check[p+starti] == 3) ? scat[p+starti] : NaN
	
	wavestats/Q avg_zero
	avg_result[0] = V_avg

	wavestats/Q avg_co2
	avg_result[1] = V_avg
	
	killwaves/Z avg_zero, avg_co2
	
	return 1
	
End

Function optics_calc_corr_coef(vals, wl, T, P, output_wave)
	wave vals
	variable wl
	wave T
	wave P
	string output_wave
	
	make/o/n=2 $(output_wave)
	wave coef = $(output_wave)
	coef = NaN
	
	// Calculate O and S where:
	//	scat_best = O + S*scat_meas
	// 	O = offset and S = slope 
	//	result wave: 
	//   		coef[0] = O, coef[1] = S
	// Scattering ratio of CO2 = 2.59 +/- 0.9%
	//
	// Scattering of air @ 273K and 1013mb  = {27.61, 12.125, 4.549} +/- 0.24%	
	//
	//	(from Anderson & Ogren, AS&T, 1998)
	
	variable CO2_scat_ratio = 2.59

	variable air_scat
	if (wl == 450)
		air_scat = 27.61
	elseif (wl == 550)
		air_scat = 12.125		
	elseif (wl == 700)
		air_scat = 4.549		
	else
		return 0
	endif		
	
	variable co2_scat = (CO2_scat_ratio * air_scat)
	
	// convert to measurement T & P
	air_scat = air_scat * (273.2 / T[0]) * (P[0] / 1013.2)
	co2_scat = co2_scat * (273.2 / T[1]) * (P[1] / 1013.2)
	
	// calculate S = (scat_k_co2 - scat_k_air) / (scat_m_co2 - scat_m_air) 
	coef[1] = (co2_scat - air_scat) / (vals[1] - vals[0])
	
	//Calculate O = -S*scat_m_air
	coef[0] = -1* coef[1]*vals[0]
	
End

Function optics_correct_for_drift(sys,inst,wl,dt,dat)
	string sys
	string inst
	string wl
	wave dt
	wave dat
	
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder neph_check

	string prefix = ""
	if (cmpstr(inst,"neph_sub1")==0)
		prefix = "Sub1"
	elseif (cmpstr(inst,"neph_sub10")==0)
		prefix = "Sub10"
	elseif (cmpstr(inst,"neph_lo")==0)
		prefix = "neph_lo"
	elseif (cmpstr(inst,"neph_hi")==0)
		prefix = "neph_hi"
	endif

//	wave scat450 = $(prefix+"_Scatter_450")
//
	
	wave dt_avg = $(prefix+"_check_dt_avg")
	wave O_avg = $(prefix+"_check_O_"+wl+"_avg")
	wave S_avg = $(prefix+"_check_S_"+wl+"_avg")
	
	if (!waveexists(O_avg) || !waveexists(S_avg)) 
		return 0
	endif
	
	variable i
	for (i=0; i<numpnts(dt); i+=1)
		variable O = interp(dt[i],dt_avg,O_avg)
		variable S = interp(dt[i],dt_avg,S_avg)
		dat[i] = dat[i]*S + O
	endfor
	
	setdatafolder sdf 
End

Function optics_merge_ext_nans(sys,inst,ext_nan)
	string sys
	string inst
	wave ext_nan
		
	string sdf = getdatafolder(1)
	setdatafolder optics_data_folder
	setdatafolder sys
	setdatafolder inst
	setdatafolder orig
	
	wave opt_nan = $(inst+"_user_nan")
	
	if (!waveexists($(inst+"_user_nan_bak")))
		duplicate opt_nan $(inst+"_user_nan_bak")
	endif
	
	variable i
	for (i=0; i<numpnts(opt_nan); i+=1)
		variable dt = pnt2x(opt_nan,i)
		variable pnt = x2pnt(ext_nan,dt)
		if ( (pnt >= 0) && (pnt<numpnts(ext_nan)) && (ext_nan[pnt]==1) ) 
			opt_nan[i] = 1
		endif
	endfor
	
	setdatafolder sdf
End

Function optics_combine_legs([system])
	string system // "rh60" or "fRH"
	
//	string leg_cn_list = "best_cn;best_ufcn"
//	string final_cn_list = "cn;ufcn"

	if (ParamIsDefault(system))
		system = "rh60"
	endif


	variable tb = 60
	string leg_list = "optics_leg1;optics_leg2"

	string rh60_folder_list = "calc;neph_sub1;neph_sub10;psap_sub1;psap_sub10"
	string fRH_folder_list = "calc;neph_lo;neph_hi"
	
	string folder_list = ""
	if (cmpstr(system, "rh60")==0)
		folder_list = rh60_folder_list
	elseif (cmpstr(system, "fRH")==0)
		folder_list = fRH_folder_list
	else
		print ("Unknown system type: " + system + ". Must be rh60 or fRH")
	endif
	
	if (!acg_project_is_set())
		print "set project_info"
		return 1
	endif
	
	variable/D dt_min = acg_get_project_start_dt()
	variable/D dt_max = acg_get_project_stop_dt()
	variable obs = (dt_max-dt_min)/tb + 1
	
	string sdf = getdatafolder(1)
	setdatafolder root:
	
	string wave_map = ""
	variable legi, fi
//	for (legi=0; legi<itemsinlist(leg_list); legi+=1)
	// get list of waves for each folder - assumes each leg has the same waves in each folder and all based on same date_time
	string leg = stringfromlist(0, leg_list)
	setdatafolder leg
	for (fi=0; fi<itemsinlist(folder_list); fi+=1)
		string folder = stringfromlist(fi, folder_list)

		string wlist = acg_get_wlist_from_folder(folder, filter_str="!date_time")
		wave_map = replaceStringByKey(folder, wave_map, wlist, ":", "%")
	endfor

	setdatafolder root:
	newdatafolder/o/s optics
//	make/D/o/n=(obs) $"date_time"
//	wave dt = $"date_time"
//	dt[0] = dt_min
//	dt[1,] = dt[p-1] + tb
	
	string optics_folder = getdatafolder(1)
	setdatafolder root:
	
	for (fi=0; fi<itemsinlist(folder_list); fi+=1)
		folder = stringfromlist(fi, folder_list)
		wlist = stringbykey(folder, wave_map, ":", "%")

		for (legi=0; legi<itemsinlist(leg_list); legi+=1)
			leg = stringfromlist(legi, leg_list)
			setdatafolder $("root:"+leg+":"+folder)
//			setdatafolder leg
//			setdatafolder folder
			string leg_folder = getdataFolder(1)
			
			wave leg_dt = $"date_time"
			variable wi
			for (wi=0; wi<itemsinlist(wlist); wi+=1)
				setdatafolder leg_folder
				string wname = stringfromlist(wi, wlist)
				wave legw = $wname
				setdatafolder optics_folder
				newdatafolder/o/s $folder
				if (legi==0)
					if (wi==0)
						make/D/o/n=(obs) $"date_time"
						wave dt = $"date_time"
						dt[0] = dt_min
						dt[1,] = dt[p-1] + tb
					endif
					make/o/n=(obs) $wname
					wave tmp = $wname
					tmp=NaN
					SetScale/P x dt[0],tb,"dat", tmp
				endif
				wave dt = $"date_time"
				wave w = $wname
				
				variable i
				for (i=0; i<numpnts(leg_dt); i+=1)
					variable dt_index = binarysearch(dt, leg_dt[i])
					if (dt_index >= 0)
						w[dt_index] = legw[i]
					endif
				endfor
			endfor
		endfor
	endfor
	
			
			
	

//	variable listi
//	for (listi=0; listi<itemsinlist(final_cn_list); listi+=1)
//		leg_cn_name = stringfromlist(listi,leg_cn_list)
//		final_cn_name = stringfromlist(listi,final_cn_list)
	// leg1
//	wave leg1_dt = root:cn_leg1:date_time
//	wave leg1_cn = root:cn_leg1:best_cn
//	wave leg1_ufcn = root:cn_leg1:best_ufcn
//	wave leg1_lat = root:cn_leg1:Latitude
//	wave leg1_lon = root:cn_leg1:Longitude
//	
//	// leg2
//	wave leg2_dt = root:cn_leg2:date_time
//	wave leg2_cn = root:cn_leg2:best_cn
//	wave leg2_ufcn = root:cn_leg2:best_ufcn
//	wave leg2_lat = root:cn_leg2:Latitude
//	wave leg2_lon = root:cn_leg2:Longitude
//
//	setdatafolder root:cn
//	
//	variable first_dt = wavemin(leg1_dt)
//	variable last_dt = wavemax(leg2_dt)
//	variable total_pnts = (last_dt-first_dt)/60 + 1
//	
//	make/d/o/n=(total_pnts) $("cn_datetime")
//	wave dt = $("cn_datetime")
//	
//	dt[0] = first_dt
//	dt[1,] = dt[p-1]+60
//	
//	make/o/n=(numpnts(dt)) $("cn")
//	wave cn = $("cn")
//	
//	make/o/n=(numpnts(dt)) $("ufcn")
//	wave ufcn = $("ufcn")
//
//	make/o/n=(numpnts(dt)) $("Latitude")
//	wave lat = $("Latitude")
//
//	make/o/n=(numpnts(dt)) $("Longitude")
//	wave lon = $("Longitude")
//	
//	variable i
//	for (i=0; i<numpnts(dt); i+=1)
//		variable leg_index = binarysearch(leg1_dt, dt[i])
//		if (leg_index >= 0)
//			cn[i] = leg1_cn[leg_index]
//			ufcn[i] = leg1_ufcn[leg_index]
//			lat[i] = leg1_lat[leg_index]
//			lon[i] = leg1_lon[leg_index]
//			continue
//		endif
//		leg_index = binarysearch(leg2_dt, dt[i])
//		if (leg_index >= 0)
//			cn[i] = leg2_cn[leg_index]
//			ufcn[i] = leg2_ufcn[leg_index]
//			lat[i] = leg2_lat[leg_index]
//			lon[i] = leg2_lon[leg_index]
//		endif
//	endfor
//	
//	SetScale/P x dt[0],60,"dat", cn
//	SetScale/P x dt[0],60,"dat", ufcn
//	SetScale/P x dt[0],60,"dat", lat
//	SetScale/P x dt[0],60,"dat", lon
				
End