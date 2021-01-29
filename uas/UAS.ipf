#pragma rtGlobals=1		// Use modern global access method.

constant acg_uas_version=1.2

// --- Changes from 1.1 to 1.2 --- 25 March, 2015
//    - added piccolo parameters (pitch, roll, yaw)
//    - added plotting functionality from menus/marquee
//          - added "standard time series plot
//          - add marquee plotting from standard: profiles, absorption, offset view
//    - set scaling to allow datetime axes to default to proper format
//
// --- Changes from 1.0 to 1.1 --- 25 March, 2015
// 	- merged changes made my Jim

strconstant uas_tmp_data_folder = "root:uas_tmp_data_folder"
strconstant uas_data_folder = "root:uas"
strconstant uas_flight_info_folder = "flight_info"
strconstant uas_inst_abs = "absorption"
strconstant uas_inst_cn = "cn"
strconstant uas_inst_chem = "chemistry"
strconstant uas_inst_nav_folder = "navigation"
strconstant uas_raw_corrections_folder = "corrections"
strconstant uas_raw_datetime_orig = "date_time_orig"
strconstant uas_gui_new_flight_string = "<create new flight>"
strconstant uas_gui_cancel_string = "_CANCEL_"
strconstant uas_dataselector_format = "dataselector"
strconstant uas_dataselector_format_2 = "dataselector2"  // ICEALOT format
strconstant uas_dchart_itx_format = "dchart_itx"

constant uas_tb = 1 // second(s)

constant uas_calc_piccolo_params = 1  // 1=true, 0=false...use 1 for normal flight ops
constant uas_bad_piccolo_data_year_limit = 2010

//strconstant cn_cpc_list = "CN_Direct;CN_stack;CN_Direct2"
//strconstant cn_ucpc_list = "UFCN;WCPC" // WCPC here?
//
//strconstant cn_default_cpc_inst= "CN_Direct"
//strconstant cn_default_ucpc_inst = "UFCN"


//menu "CN"
menu "ACG Data"
	submenu "UAS"
		submenu "Load Data"
			"payload data", uas_load_card_data("payload")
			"rf payload data", uas_load_card_data("rf")
			"rf piccolo data", uas_load_piccolo_data("rf")
			"iridium piccolo data", uas_load_piccolo_data("iridium")
		end
		submenu "Set Correction Factors"
			submenu "DateTime Offset"
				"payload data", uas_set_corrections("payload")
				"rf payload data", uas_set_corrections("payload_rf")
				"rf piccolo data", uas_set_corrections("piccolo_rf")
				"iridium piccolo data", uas_set_corrections("piccolo_iridium")
			end
		end
		"Process flight", uas_process_flight("")
		submenu "Plots"
			 "Plot Standard TS",uas_plot_std_ts("")
			 "-"
			 "Plot Absorption TS", uas_plot_absorption("")
			 "Plot Offset view", uas_plot_offset_view("")
		end
	end
end

Menu "GraphMarquee"
	"-"
	submenu "UAS"
		"Plot profile", uas_plot_from_marquee("profile")
		"Plot absorption", uas_plot_from_marquee("abs")
		"Plot profile and absorption", uas_plot_from_marquee("prof_and_abs")
		"Plot offset view", uas_plot_from_marquee("offset")
	end

	"-"
	submenu "UAS-Cloud"
		"Plot Average Distributions", cloud_plot_avg_from_marquee(30)
		submenu "Plot Comparison Averages"
			"Jan 24",  uas_comp_avg_from_marquee("Jan24")
			"Jan 31",  uas_comp_avg_from_marquee("Jan31")
		end
	end
	
//	"Plot Average Distribution", plot_avg_dist_from_marquee(0)
//	"Plot Average Distribution with Edit window", plot_avg_dist_from_marquee(1)
//	"-"
////	"SMPS: nan selection", smps_nan_selection_from_marquee()
////	"SMPS: reset selection", smps_reset_sel_from_marquee()
//	submenu "SMPS"
//		"nan range", smps_toggle_nans_from_marquee(1,1)
//		"reset range", smps_toggle_nans_from_marquee(1,0)
//		"nan points in selection", smps_toggle_nans_from_marquee(0,1)
//		"reset points in selection", smps_toggle_nans_from_marquee(0,0)
//	end
//	"-"
//	submenu "DMPS"
//		"nan range", dmps_toggle_nans_from_marquee(1,1)
//		"reset range", dmps_toggle_nans_from_marquee(1,0)
//		"nan points in selection", dmps_toggle_nans_from_marquee(0,1)
//		"reset points in selection", dmps_toggle_nans_from_marquee(0,0)
//	end
//	submenu "APS"
//		"nan range", aps_toggle_nans_from_marquee(1,1)
//		"reset range", aps_toggle_nans_from_marquee(1,0)
//		"nan points in selection", aps_toggle_nans_from_marquee(0,1)
//		"reset points in selection", aps_toggle_nans_from_marquee(0,0)
//	end
End

Function/S uas_get_flight_num()

	string flight_num
	Prompt flight_num, "Enter Flight Number: "
	DoPrompt "Enter Flight Number", flight_num
	
	return flight_num

End

Function/S uas_get_flight_num_pu(allow_new_flight)
	variable allow_new_flight // 0=not allowed, 1=allowed
	string flight_num

	string flight_list =  uas_get_flights_list()
	if (allow_new_flight)
		flight_list = uas_gui_new_flight_string + ";" + flight_list
	endif
	
	Prompt flight_num,"Flight Number",popup,flight_list
//	Prompt flight_num, "Enter Flight Number: "
	DoPrompt "Choose Flight Number", flight_num
	
	if (V_flag==1)
		return uas_gui_cancel_string
	endif
	return flight_num

End

Function/S uas_goto_datafolder()
	string sdf = getdatafolder(1)
	
	if (!datafolderexists(uas_data_folder))
		newdatafolder/o $uas_data_folder
	endif
	setdatafolder $uas_data_folder
	
	return sdf
End

Function/S uas_goto_flight_datafolder(flight_num)
	string flight_num
	string sdf = uas_goto_datafolder()
	
	if (!datafolderexists(flight_num))
		print "Flight number: " + flight_num + " does not exist! Cancel operation."
		return uas_gui_cancel_string
	else
		setdatafolder $flight_num
	endif
		
	return sdf
End

Function/S uas_create_new_flight() 
	string flight_num
	string helpStr = "Enter flight number as YY-XXX where YY is the last 2 digits of the year and XXX is a 3 digit ID (E.g., Flight 3 of 2011 is 11-003" 
	Prompt flight_num, "New Flight Number: "
	DoPrompt/HELP=helpStr "Enter new flight number", flight_num
	if (V_flag==1)
		return uas_gui_cancel_string
	endif
	
	flight_num = "flight_"+flight_num
	flight_num = replacestring("-",flight_num,"_")
	
	string sdf = uas_goto_datafolder()	
	newdatafolder/o/s $flight_num
	newdatafolder/o/s $uas_flight_info_folder
	
	// create absorption parameters
	newdatafolder/o/s $uas_inst_abs
	variable/G Tr_init_blue = 1
	variable/G Tr_init_green = 1
	variable/G Tr_init_red = 1 
	variable/G gap_limit = 6 // seconds
	variable/G spot_area = 19.79 // 
	variable/G cleaning_limit = 0.0001
	variable/G avg_time = 60
	variable/G first_index = 0
	setdatafolder :::

	// newdatafolder/o $uas_flight_info_nav_folder
	
	setdatafolder sdf
	return flight_num
	

End

Function uas_load_card_data(type)
	string type

//	string flight_num = "flight_"+uas_get_flight_num() 
//	flight_num = replacestring("-",flight_num,"_")

	
	string flight_num = uas_get_flight_num_pu(1)
	if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
		return 0
	elseif (cmpstr(flight_num,uas_gui_new_flight_string) == 0)
		flight_num = uas_create_new_flight()
	endif
	
	string sdf = uas_goto_flight_datafolder(flight_num)

	string card_type_name = ""
	if (cmpstr(type,"rf") == 0)
		card_type_name = "payload_rf"
	else
		card_type_name = "payload"
	endif
	
//	string sdf = getdatafolder(1)
//	newdatafolder/o/s $uas_data_folder
//	newdatafolder/o/s $flight_num
	newdatafolder/o/s raw
	newdatafolder/o/s $card_type_name
	
	// create corrections folder for user definable variables
	newdatafolder/o/s $uas_raw_corrections_folder
	variable/G dt_offset = 0
	setdatafolder ::
	
//	string dfolder = uas_data_folder+":"+flight_num+":raw:"+card_type_name
	string dfolder = getdatafolder(1)
	
	if (datafolderexists(uas_tmp_data_folder))
		killdatafolder/Z $uas_tmp_data_folder
	endif
	
	newdatafolder/o/s $uas_tmp_data_folder
	newdatafolder/o/s raw
	
	set_base_path()
	LoadWave/J/D/A/W/O/K=0/L={0,0,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
	//LoadWave/J/D/W/K=0/R={English,2,2,2,2,"Year-Month-DayOfMonth",40} "Y:Data:UAS:flight_15_003:mSDcard-p1_15-003.dat"

	// preprocessed data has corrected timewave
	if (waveexists(DateTime_corr))
	//if (waveexists(DT_card_corr1))
		rename DateTimeW, DateTimeW_preCorr
		//rename DT_card_corr1, DateTimeW
		rename DateTime_corr, DateTimeW
	endif
	
	//variable tb = 1	
	uas_same_timebase_and_move(uas_tb,dfolder)
					
	setdatafolder sdf
	killdatafolder/Z $uas_tmp_data_folder
End

Function uas_load_piccolo_data(type)
	string type

//	string flight_num = "flight_"+uas_get_flight_num() 
//	flight_num = replacestring("-",flight_num,"_")

	string flight_num = uas_get_flight_num_pu(1)
	if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
		return 0
	elseif (cmpstr(flight_num,uas_gui_new_flight_string) == 0)
		flight_num = uas_create_new_flight()
	endif
	
	string sdf = uas_goto_flight_datafolder(flight_num)

	string piccolo_type_name = ""
	if (cmpstr(type,"rf") == 0)
		piccolo_type_name = "piccolo_rf"
	else
		piccolo_type_name = "piccolo_iridium"
	endif
	
//	string sdf = getdatafolder(1)
//	newdatafolder/o/s $uas_data_folder
//	newdatafolder/o/s $flight_num
	newdatafolder/o/s raw
	newdatafolder/o/s $piccolo_type_name

	// create corrections folder for user definable variables
	newdatafolder/o/s $uas_raw_corrections_folder
	variable/G dt_offset = 0
	setdatafolder ::
	
//	string dfolder = uas_data_folder+":"+flight_num+":raw:"+piccolo_type_name
	string dfolder = getdatafolder(1)
	
	if (datafolderexists(uas_tmp_data_folder))
		killdatafolder/Z $uas_tmp_data_folder
	endif
	
	newdatafolder/o/s $uas_tmp_data_folder
	newdatafolder/o/s raw
	
	set_base_path()
	LoadWave/J/D/A/W/O/K=0/V={"\t "," $",0,0}/L={0,0,0,0,110}/P=loaddata_base_path
	
	//create datetime wave	
	wave y = Year_
	wave mo = Month_
	wave day = Day_

	wave hh = Hours_
	wave mm = Minutes_
	wave ss = Seconds_

	make/D/o/n=(numpnts(y)) DateTimeW
	wave dt = DateTimeW
	
	dt = date2secs(y[p],mo[p],day[p])
	dt += hh*60*60 + mm*60 + ss
	
	//list of wanted params
	string keeplist_1 = "DateTimeW;Lat__rad_;Lon__rad_;GroundSpeed__m_s_;Height__m_;TAS__m_s_;Static__Pa_;LeftRPM_;"
	string keeplist_2 = "VNorth__m_s_;VEast__m_s_;VDown__m_s_;WindSouth__m_s_;WindWest__m_s_;Direction__rad_;"
	string keeplist_3 = "Pitch__rad_;Roll__rad_;Yaw__rad_"
	string keeplist = keeplist_1+keeplist_2+keeplist_3
	
	// remove unneeded waves
	string wlist = acg_get_wlist_from_folder(":")
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		if(whichlistitem(stringfromlist(i,wlist),keeplist) < 0)
			killwaves/Z $(stringfromlist(i,wlist))
		endif
	endfor
	
	// remove rows with bad time values
	make/o/n=(numpnts(dt)) bad_index
	wave bad_ind = bad_index
	wave lat = Lat__rad_
	wave lon = Lon__rad_
	bad_ind  = ( (dt[p] < date2secs(uas_bad_piccolo_data_year_limit,1,1)) || (sqrt((lat[p]^2 + lon[p]^2)<0.017)) ) ? 1 : 0
	
	variable par 
	for (i=numpnts(bad_ind)-1; i>=0; i-=1)
		for (par=0; par<itemsinlist(keeplist); par+=1)
			wave param = $(stringfromlist(par,keeplist))
			if (bad_ind[i])
				deletepoints i,1,param
			endif
		endfor
	endfor
	
	variable row=0
	variable npts = numpnts(dt)
	do 
		if (dt[row+1] < dt[row])
			for (par=0; par<itemsinlist(keeplist); par+=1)
				wave param = $(stringfromlist(par,keeplist))
				deletepoints row+1,1,param
			endfor
			npts-=1
		else
			row+=1
		endif
		
	while (row<(npts-1))
		
	
	//variable tb = 1	
	uas_same_timebase_and_move(uas_tb,dfolder)

	setdatafolder sdf
	killdatafolder/Z $uas_tmp_data_folder
End

Function uas_same_timebase_and_move(tb,dfolder)
	variable tb
	string dfolder
	string sdf = getdatafolder(1)
	setdatafolder $uas_tmp_data_folder
	
	// make sure dfolder has a trailing colon
	if (cmpstr(dfolder[strlen(dfolder)-1],":") != 0)
		dfolder += ":"
	endif
	
	wave old_dt = :raw:DateTimeW
	old_dt += 0.5
	
	wavestats/Q old_dt
	variable mintime=floor(V_min)
	variable maxtime=ceil(V_max)
	variable time_periods = (maxtime-mintime+1)/uas_tb
	
	make/O/N=(time_periods)/d date_time
	wave dt = date_time
	dt[0] = mintime
	dt[1,]  = dt[p-1]+uas_tb
	
	string wlist = acg_get_wlist_from_folder(":raw")
	
	get_timebase_index(dt,old_dt,1,"time_index")
	wave time_index = $("time_index")
	
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		if (cmpstr("DateTimeW",stringfromlist(i,wlist)) != 0)
		
			duplicate/o dt, $(stringfromlist(i,wlist))
			wave w = $(stringfromlist(i,wlist))
			SetScale/P x dt[0],uas_tb,"dat", w
			w = NaN
			wave raw_w = $(":raw:"+stringfromlist(i,wlist))
			
			variable idx			
			variable j
			variable last_idx = -1 // to use first occurrence in higher freq data
			for (j=0; j<numpnts(raw_w); j+=1)
				idx = time_index[j]
				if (idx > -1)
					if (last_idx != idx)  // only use first occurrence
						w[idx] = raw_w[j]
						last_idx = idx
					endif
				endif
			endfor
			duplicate/o w $(dfolder+stringfromlist(i,wlist))
		endif
	endfor
	duplicate/o dt $(dfolder+"date_time"), $(dfolder+uas_raw_datetime_orig)
				
	setdatafolder sdf
End

// uses new DFREF...requires igor 6.1 or greater
Function/S uas_get_flights_list()

	DFREF dfr = $uas_data_folder
	string flist = get_dfr_list(dfr)
	
	// check to make sure they are all flights
	string flight_list = ""
	variable i
	for (i=0; i<itemsinlist(flist); i+=1)
		if (stringmatch(stringfromlist(i,flist),"flight_*"))
			flight_list += stringfromlist(i,flist) + ";"
		endif
	endfor
	return flight_list
End

Function uas_process_flight(flight_num)
	string flight_num
	
//	if (cmpstr(flight_num,"")==0)
//		flight_num = "flight_"+uas_get_flight_num() 
//		flight_num = replacestring("-",flight_num,"_")
//	endif

	if (cmpstr(flight_num,"")==0)
		 flight_num = uas_get_flight_num_pu(0)
		if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
			return 0
		endif
	endif
	string sdf = uas_goto_flight_datafolder(flight_num)

	
//	string sdf = getdatafolder(1)	
//	setdatafolder $uas_data_folder
//	setdatafolder $flight_num
	
	newdatafolder/o payload
	newdatafolder/o piccolo
	
	// add data folders
//	newdatafolder/o $uas_inst_abs_folder
//	newdatafolder/o $uas_inst_cn_folder
//	newdatafolder/o $uas_inst_chem_folder
		
	

	// find min/max times for main datetime wave
	DFREF dfr = :raw
	string flist = get_dfr_list(dfr)
	
	print flist
	
	variable mintime = -1
	variable maxtime = -1
	variable i
	for (i=0; i<itemsinlist(flist); i+=1)
		wave dt = $(":raw:"+stringfromlist(i,flist)+":date_time")
		wavestats/Q dt
		if (mintime < 0 || V_min < mintime)
			mintime = V_min
		endif
		if (maxtime < 0 || V_max > maxtime)
			maxtime = V_max
		endif
	endfor
	variable time_periods = (maxtime-mintime+1)/uas_tb
	
	make/O/N=(time_periods)/d uas_datetime
	wave dt = uas_datetime
	dt[0] = mintime
	dt[1,]  = dt[p-1]+uas_tb


	// format as DateTime using modifytable
	//string wlist = winlist("timeformat_process*",";","WIN:2")
	//variable twin
	//for (twin=0; twin<itemsinlist(wlist); twin+=1)
	//	killwindow $(stringfromlist(twin,wlist))
	//endfor
	//variable whichlistitem
	//edit/hide=0/N=timeformat_process uas_datetime
	//modifytable format(uas_datetime)=8
 	//killwindow timeformat

	// duplicate all waves to correct folders on constant time base and combine RF and Irridium/local versions
	
	// ...payload	
	uas_raw_to_working_waves("payload_rf","payload")	
	uas_raw_to_working_waves("payload","payload")	
	
	// ...piccolo
	uas_raw_to_working_waves("piccolo_rf","piccolo")	
	uas_raw_to_working_waves("piccolo_iridium","piccolo")		
		
	// calculate desired parameters
	// ...piccolo
	if (uas_calc_piccolo_params)
		uas_calculate_piccolo_params()
	endif
	
	uas_convert_flows_stp(uas_inst_abs)
	uas_convert_flows_stp(uas_inst_cn)
	uas_convert_flows_stp(uas_inst_chem)
	
	uas_calculate_absorption()
	uas_calculate_cn()


	// do this last so all waves do not inherit "dat" 
	SetScale d, dt[0], dt[numpnts(dt)-1],"dat", dt //need this to set the units on a datetime wave. Not really documented.
	//SetScale/P x, dt[0], uas_tb,"dat", dt

	setdatafolder sdf
End

Function uas_raw_to_working_waves(raw_type, working_type)
	string raw_type
	string working_type

	string rawfolder = ":raw:"+raw_type
	string correctionsfolder = rawfolder+":corrections"
	string workingfolder = ":"+working_type
	string dt_orig = "date_time_orig"
	string wlist
	if (datafolderexists(rawfolder))
	
		// make adjustments to raw data
		if (datafolderexists(correctionsfolder))

			// adjust date_time
			if (exists(correctionsfolder+":dt_offset")==2)
				NVAR offset = $(correctionsfolder+":dt_offset")
				wave orig_dt = $(rawfolder+":"+uas_raw_datetime_orig)
				wave adjust_dt = $(rawfolder+":date_time")
				adjust_dt = orig_dt + offset
			endif

		endif
		
		wlist = acg_get_wlist_from_folder(rawfolder)
		wlist = removefromlist("date_time",wlist)
		//wlist = removefromlist("DateTimeW_preCorr",wlist)
		wave old_dt = $(rawfolder+":date_time")
		wave dt = uas_datetime
		SetScale/P x dt[0],uas_tb,"dat", dt
			
				
		
		variable i
		variable wave_is_new=0
		for (i=0; i<itemsinlist(wlist); i+=1)
			wave oldw = $(rawfolder+":"+stringfromlist(i,wlist))
			if ( waveexists($(workingfolder+":"+stringfromlist(i,wlist))) )
				if ( numpnts(dt) != numpnts($(workingfolder+":"+stringfromlist(i,wlist))) ) 
					duplicate/o dt $(":payload:"+stringfromlist(i,wlist))
					wave_is_new = 1
				endif
			else
				duplicate/o dt $(workingfolder+":"+stringfromlist(i,wlist))
				wave_is_new = 1
			endif
			wave w = $(workingfolder+":"+stringfromlist(i,wlist))
			if (wave_is_new)
				w=NaN
			endif
			SetScale/P x dt[0],uas_tb,"dat", w
			
			variable j
			for (j=0; j<numpnts(oldw); j+=1)
				if (numtype(oldw[j]) == 0)
					w[x2pnt(w,old_dt[j])] = oldw[j]
				endif
			endfor
		endfor
			
	endif
End	

Function uas_set_corrections(data_type)
	string data_type

	string flight_num = uas_get_flight_num_pu(0)
	if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
		return 0
	endif
	
	string sdf = uas_goto_flight_datafolder(flight_num)
	setdatafolder $(":raw:"+data_type+":corrections")
	
	NVAR offset = dt_offset
	variable val = offset
	string helpStr = "DateTime offset in seconds: -N to shift back in time, +N shift forward\n\n"
	Prompt val, "DateTime offset (sec): "
	DoPrompt/HELP=helpStr "Enter corrections", val
	if (V_flag==0)
		offset = val
	endif
	
 	setdatafolder sdf
End

Function uas_calculate_piccolo_params()

	string new_w
	// lat/lon
	duplicate/o $(":piccolo:"+"Lat__rad_") Lat
	wave w = Lat
	w *=180/PI
	new_w="Lat_cont"
	if (WaveExists($new_w) == 1 )
		KillWaves $new_w
	endif
	uas_despike(0,uas_datetime,w,10,120,new_w)
	
	duplicate/o $(":piccolo:"+"Lon__rad_") Lon
	wave w = Lon
	w *=180/PI
	new_w="Lon_cont"
	if (WaveExists($new_w) == 1 )
		KillWaves $new_w
	endif
	uas_despike(0,uas_datetime,w,10,120,new_w)
		
	// altitude
	duplicate/o $(":piccolo:"+"Height__m_") Alt_m
	wave w = Alt_m
	new_w="Alt_m_cont"
	if (WaveExists($new_w) == 1 )
		KillWaves/Z $new_w
	endif
	uas_despike(0,uas_datetime,w,10,120,new_w)
	
	duplicate/o w Alt_ft
	wave w = Alt_ft
	w *= 3.28084
	
	// speed
	duplicate/o $(":piccolo:"+"GroundSpeed__m_s_") GndSp_knts
	wave w = GndSp_knts
	w *=1.9438
	w*=1.0001
	
	duplicate/o $(":piccolo:"+"TAS__m_s_") AirSp_knts
	wave w = AirSp_knts
	w *=1.9438

	// Nav
	duplicate/o $(":piccolo:"+"Direction__rad_") Direction
	wave w = Direction
	w *=180/PI

	duplicate/o $(":piccolo:"+"LeftRPM_") RPM
	duplicate/o $(":piccolo:"+"VNorth__m_s_") Vnorth
	duplicate/o $(":piccolo:"+"VEast__m_s_") Veast
	duplicate/o $(":piccolo:"+"VDown__m_s_") Vdown
	
	// met
	duplicate/o $(":piccolo:"+"Static__Pa_") StaticP
	wave w = StaticP
	w /= 100
	new_w="StaticP_cont"
	if (WaveExists($new_w) == 1 )
		KillWaves/Z $new_w
	endif
	uas_despike(0,uas_datetime,w,10,120,new_w)
	
	duplicate/o $(":piccolo:"+"WindSouth__m_s_") WindSouth
	duplicate/o $(":piccolo:"+"WindWest__m_s_") WindWest
	
	// 26 March 2015: added new parameters
	duplicate/o $(":piccolo:"+"Pitch__rad_") Pitch
	wave w = Pitch
	w *=180/PI
	
	duplicate/o $(":piccolo:"+"Roll__rad_") Roll
	wave w = Roll
	w *=180/PI

	duplicate/o $(":piccolo:"+"Yaw__rad_") Yaw
	wave w = Yaw
	w *=180/PI


	

End

Function uas_convert_flows_stp(inst)
	string inst
	
	newdatafolder/o $inst
	
	string Pa_name = "StaticP_cont"
	string Ta_name = ":payload:INLTT"
	string Q_name
	string Q_stp_name
	variable Ts = 273.15   // K
	variable Ps = 1013.25 //mb

	if (cmpstr(inst,uas_inst_abs)==0)
		Q_name = ":payload:ABSFL"
		Q_stp_name = "abs_flow_stp"
	elseif (cmpstr(inst,uas_inst_cn)==0)
		Q_name = ":payload:SMPFL"
		Q_stp_name = "cn_flow_stp"
	elseif (cmpstr(inst,uas_inst_chem)==0)
		Q_name = ":payload:CHMFL"
		Q_stp_name = "chem_flow_stp"
	endif
	
	wave Pa = $Pa_name
	wave Ta = $Ta_name
	wave Q = $Q_name
	duplicate/O Q $(":"+inst+":"+Q_stp_name)
	wave Q_stp = $(":"+inst+":"+Q_stp_name)
		
	Q_stp = Q*(Ts / (Ta+273.15))*( Pa / Ps)
End

Function uas_calculate_absorption()
	
	wave dt = uas_datetime;
	
	NVAR Tr_init = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":Tr_init_red")
	NVAR Tg_init = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":Tr_init_green")
	NVAR Tb_init = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":Tr_init_blue")
	NVAR gap_limit = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":gap_limit")
	NVAR cleaning_limit = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":cleaning_limit")
	NVAR spot_area = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":spot_area")
	NVAR  first_index = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":first_index")
	NVAR  avg_time = $(":"+uas_flight_info_folder+":"+uas_inst_abs+":avg_time")
	
	setdatafolder $uas_inst_abs
	
	wave flow = abs_flow_stp

	string rawA_name
	string rawB_name
	string wl_color
	string wl_list = "450;525;624"

	variable i
	for (i=0; i<itemsinlist(wl_list); i+=1)
		string wl = stringfromlist(i,wl_list)
		
		if (cmpstr(wl,"450")==0)
			rawA_name = "::payload:ABSBA"
			rawB_name = "::payload:ABSBB"
			wl_color = "blue"
		elseif (cmpstr(wl,"525")==0)
			rawA_name = "::payload:ABSGA"
			rawB_name = "::payload:ABSGB"
			wl_color = "green"
		elseif (cmpstr(wl,"624")==0)
			rawA_name = "::payload:ABSRA"
			rawB_name = "::payload:ABSRB"
			wl_color = "red"
		else
			return 0
		endif

		wave rawA = $rawA_name
		wave rawB = $rawB_name

		duplicate/o rawA $("Tr_"+wl)
		wave Tr = $("Tr_"+wl)
		
		NVAR Tr_init = $("::"+uas_flight_info_folder+":"+uas_inst_abs+":Tr_init_"+wl_color)
		
//	wave RA = :payload:ABSRA
//	wave RB = :payload:ABSRB
//	wave GA = :payload:ABSGA
//	wave GB = :payload:ABSGB
//	wave BA = :payload:ABSBA
//	wave BB = :payload:ABSBB
		
//	
//	duplicate/o RA Tr_624 // red
//	wave Tr  = Tr_red
//	
//	duplicate/o GA Tr_
//	wave Tg  = Tr_green
//
//	duplicate/o BA Tr_blue
//	wave Tb  = Tr_blue

//	Tr = RA/RB/Tr_init
//	Tg = GA/BB/Tg_init
//	Tb = BA/BB/Tb_init
	
		Tr = rawA/rawB/Tr_init
	
//	string dswave= "Tr_tmp"
//	uas_despike(first_index,dt,Tr,cleaning_limit,gap_limit,dswave)
//	wave tmp = $"Tr_tmp"
//	Tr = tmp
//	
//	uas_despike(first_index,dt,Tg,cleaning_limit,gap_limit,dswave)
//	wave tmp = $"Tr_tmp"
//	Tg = tmp
//
//	uas_despike(first_index,dt,Tb,cleaning_limit,gap_limit,dswave)
//	wave tmp = $"Tr_tmp"
//	Tb = tmp

		string dswave= "Tr_tmp"
		uas_despike(first_index,dt,Tr,cleaning_limit,gap_limit,dswave)
		wave tmp = $"Tr_tmp"
		Tr = tmp
		killwaves/Z tmp
		
		string bap_name = "Bap_"+wl
		uas_calc_absorption(dt,flow,Tr,avg_time,spot_area,bap_name)
		
	endfor
	
	setdatafolder ::

End

function uas_despike(start_i,xwave,ywave,dlim,gaplimit,finalwavename)

	wave xwave
	wave ywave
	variable start_i
	variable dlim
	variable gaplimit
	
	string finalwavename
	variable ix
	variable ii
	variable nbad=0
	variable dydx
	variable ilastgood
	variable np
	
     	np=numpnts(ywave)
	make/O/N=(np)/d  $finalwavename
	wave yy =$finalwavename
	yy=ywave
	ilastgood=start_i
	
	for (ix= start_i + 1; ix<np; ix+=1)
		dydx= (ywave[ix]- ywave[ilastgood])/(xwave[ix]-xwave[ilastgood])
		if (abs(dydx) < dlim) 
			if (nbad > 0) 
				if (nbad >= gaplimit)
	  				for (ii=(ix-nbad); ii<ix; ii+=1)
	  					yy[ii]= NaN
	  				endfor		
				else
					for (ii=(ix-nbad); ii<ix; ii+=1)
						yy[ii] = ywave[ilastgood] + dydx* (xwave[ii] - xwave[ilastgood])
					endfor
				endif
				nbad=0
			endif
			ilastgood=ix
		else
			nbad+=1
		endif
	       //yy[ix]=xwave[ix]
	endfor
	
	//duplicate/o yy $(finalwavename)	
			
end			

Function uas_calc_absorption(dt,flow,Tr,avg_time,spot_area,bap_name)
	wave dt
	wave flow
	wave Tr
	variable avg_time
	variable spot_area
	string bap_name
	
	newdatafolder/o/s $("avg_"+num2str(avg_time)+"sec")
	duplicate/o Tr, $bap_name
	wave bap = $bap_name
	bap = NaN
	
	variable index = BinarySearch(dt,dt[0]+(2*avg_time))
	if (index < 0)
		return 0
	endif
	
	variable Tr1, Tr2, avg1, avg2, flow_avg
	duplicate/o dt, dt_tmp
	wave dt_tmp
	dt_tmp = (numtype(Tr[p]) == 0) ? dt[p] : NaN
	
//	variable idx1, idx2
	variable i
	for (i=index; i<numpnts(bap); i+=1)
//		idx1 = BinarySearch(dt,dt[i]-(2*avg_time))
//		idx2 = BinarySearch(dt,dt[i]-(avg_time))
	
//		WaveStats/Q/M=1/R=(dt[i]-(2*avg_time), dt[i]-avg_time) Tr
//		Tr1 = V_avg
//		WaveStats/Q/M=1/R=(dt[i]-(avg_time), dt[i]) Tr
//		Tr2 = V_avg
		WaveStats/Q/M=1/R=[i-(2*avg_time), i-avg_time] Tr
		Tr1 = V_avg
		WaveStats/Q/M=1/R=[i-avg_time, i] Tr
		Tr2 = V_avg
		
//		WaveStats/Q/M=1/R=(dt[i]-(2*avg_time), dt[i]-avg_time) dt_tmp
//		avg1 = V_avg
//		WaveStats/Q/M=1/R=(dt[i]-(avg_time), dt[i]) dt_tmp
//		avg2 = V_avg
		WaveStats/Q/M=1/R=[i-(2*avg_time), i-avg_time] dt_tmp
		avg1 = V_avg
		WaveStats/Q/M=1/R=[i-avg_time, i] dt_tmp
		avg2 = V_avg
		
//		WaveStats/Q/M=1/R=(dt[i]-(2*avg_time), dt[i]) flow
//		flow_avg = V_avg
		WaveStats/Q/M=1/R=[i-(2*avg_time), i] flow
		flow_avg = V_avg
		flow_avg /= 60
		// must convert flow from cc/min to cc/sec
		
		variable new_avg_time = avg2 - avg1

		variable ba = ln(Tr1/Tr2)*spot_area/flow_avg/new_avg_time
		ba *= 0.873/(1.317*Tr2+0.866)  // Is this correct??
		ba *= 1e6
		bap[i] = ba
		
	endfor
	killwaves/Z dt_tmp
	
	setdatafolder ::
End

Function uas_calculate_cn()
	string counts_name= "::payload:COUNT"
	setdatafolder $uas_inst_cn
	
	wave flow = cn_flow_stp
	wave counts =  $counts_name
	
	duplicate/o counts cn_stp
	
	cn_stp = counts/flow*60
	
	setdatafolder ::
End

//Window Alt_t_rh_cn_1() : Graph
Function uas_plot_std_ts(flight_num)
	string flight_num

	if (cmpstr(flight_num,"")==0)
		 flight_num = uas_get_flight_num_pu(0)
		if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
			return 0
		endif
	endif
	string sdf = uas_goto_flight_datafolder(flight_num)
	string win_name = flight_num+"_TS"
	
	PauseUpdate; Silent 1		// building window...
//	String fldrSav0= GetDataFolder(1)
//	SetDataFolder root:uas:flight_1239:
	Display /W=(35.25,42.5,527.25,527)/N=$win_name :payload:CONCN vs uas_datetime
	AppendToGraph/L=AirT :payload:PROBT vs uas_datetime
	AppendToGraph/R :payload:PRBRH vs uas_datetime
	AppendToGraph/L=Alt Alt_m_cont vs uas_datetime
	NewFreeAxis/O/R Alt_feet
	SetDataFolder sdf
	ModifyGraph rgb(PROBT)=(32768,65280,0),rgb(PRBRH)=(0,15872,65280),rgb(Alt_m_cont)=(0,0,0)
	ModifyGraph sep(Alt_feet)=1
	ModifyGraph lblMargin(right)=6
	ModifyGraph lblPos(left)=66,lblPos(AirT)=70,lblPos(right)=47,lblPos(Alt)=68,lblPos(Alt_feet)=39
	ModifyGraph lblLatPos(Alt)=-6,lblLatPos(Alt_feet)=-2
	ModifyGraph freePos(AirT)=0
	ModifyGraph freePos(Alt)=0
	ModifyGraph freePos(Alt_feet)=0
	ModifyGraph axisEnab(left)={0,0.3}
	ModifyGraph axisEnab(AirT)={0.35,0.65}
	ModifyGraph axisEnab(right)={0.35,0.65}
	ModifyGraph axisEnab(Alt)={0.7,1}
	ModifyGraph axisEnab(Alt_feet)={0.7,1}
	ModifyGraph manTick(Alt_feet)={0,2,0,0},manMinor(Alt_feet)={1,0}
	ModifyGraph dateInfo(bottom)={0,1,0}
	Label left "CN"
	Label AirT "Air Temp"
	Label right "RH, %"
	Label Alt "Alititude, m"
	Label Alt_feet "Altitude, kft"
	SetAxis left 0,6000
	SetAxis Alt 0,3048
	SetAxis Alt_feet 0,10
	//TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 "Flight 11-013"
	//TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 flight_name
	Legend/C/N=text1/J/F=0/A=MC/X=1.01/Y=20.33 "\\s(PROBT) Air Temp  \\s(PRBRH) RH"
	string flt_str = replacestring("flight_",flight_num,"Flight ")
//	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 "Flight 11-010"
	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 flt_str
End

function uas_plot_profile(flight_num,[starti,stopi])
	string flight_num 
	variable starti,stopi

	if (cmpstr(flight_num,"")==0)
		 flight_num = uas_get_flight_num_pu(0)
		if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
			return 0
		endif
	endif
	string sdf = uas_goto_flight_datafolder(flight_num)
	
	wave dt = uas_datetime
	variable is_def1=0, is_def2=0
	if (ParamIsDefault(starti)) 
		starti=0
		is_def1=1
	endif
	if (ParamIsDefault(stopi)) 
		stopi=numpnts(dt)-1
		is_def2=1
	endif

	string win_name = replacestring("flight_",flight_num,"f")
	if (is_def1 && is_def2)
		win_name += "_profile"
	else
		win_name += "_pfl_" + num2str(starti) + "_" + num2str(stopi)
	endif
	
	PauseUpdate; Silent 1		// building window...
//	String fldrSav0= GetDataFolder(1)
//	//SetDataFolder root:uas:flight_11_018:
//	SetDataFolder $("root:uas:"+flight_name+":")
	Display /W=(255,135.5,717.75,481.25)/N=$win_name :payload:PROBT[starti,stopi] vs Alt_m_cont[starti,stopi]
	AppendToGraph/R :payload:PRBRH[starti,stopi] vs Alt_m_cont[starti,stopi]
	AppendToGraph/L=CN :cn:cn_stp[starti,stopi] vs Alt_m_cont[starti,stopi]
	AppendToGraph/L=Bap :absorption:avg_60sec:Bap_450[starti,stopi],:absorption:avg_60sec:Bap_525[starti,stopi],:absorption:avg_60sec:Bap_624[starti,stopi] vs Alt_m_cont[starti,stopi]
	SetDataFolder sdf
	ModifyGraph rgb(PRBRH)=(0,15872,65280),rgb(cn_stp)=(4352,4352,4352),rgb(Bap_450)=(0,15872,65280)
	ModifyGraph rgb(Bap_525)=(16384,65280,16384)
	ModifyGraph lblPos(left)=48,lblPos(bottom)=52,lblPos(CN)=34,lblPos(Bap)=33
	ModifyGraph lblLatPos(CN)=-2,lblLatPos(Bap)=-5
	ModifyGraph freePos(CN)=0
	ModifyGraph freePos(Bap)=0
	ModifyGraph axisEnab(left)={0,0.3}
	ModifyGraph axisEnab(right)={0,0.3}
	ModifyGraph axisEnab(CN)={0.35,0.65}
	ModifyGraph axisEnab(Bap)={0.7,1}
	ModifyGraph grid(Bap)=1
	ModifyGraph grid(CN)=1
	Label left "T, Deg C"
	Label bottom "Altitude, meters"
	Label right "RH, %"
	Label CN "CN, num/cm3"
	Label Bap "Bap, Mm-1"
	SetAxis bottom 0,3000
	SetAxis right 0,100
	SetAxis CN 0,8000
	SetAxis Bap -1,4
//	TextBox/C/N=text0/F=0/A=MC/X=0.19/Y=59.05 flight_name
	Legend/C/N=text1/J/F=0/A=MC/X=-26.55/Y=32.03 "\\s(PROBT) Temp\r\\s(PRBRH) RH\r\\s(cn_stp) CN\r\\s(Bap_450) Bap_450\r\\s(Bap_525) Bap_525\r\\s(Bap_624) Bap_624"
	ModifyGraph swapXY=1
	string flt_str = replacestring("flight_",flight_num,"Flight ")
//	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 "Flight 11-010"
	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 flt_str
End

function uas_plot_absorption(flight_num,[starti,stopi])
	string flight_num 
	variable starti,stopi

	if (cmpstr(flight_num,"")==0)
		 flight_num = uas_get_flight_num_pu(0)
		if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
			return 0
		endif
	endif
	string sdf = uas_goto_flight_datafolder(flight_num)
	
	wave dt = uas_datetime
	variable is_def1=0, is_def2=0
	if (ParamIsDefault(starti)) 
		starti=0
		is_def1=1
	endif
	if (ParamIsDefault(stopi)) 
		stopi=numpnts(dt)-1
		is_def2=1
	endif

	string win_name = replacestring("flight_",flight_num,"f")
	if (is_def1 && is_def2)
		win_name += "_abs"
	else
		win_name += "_abs_" + num2str(starti) + "_" + num2str(stopi)
	endif

//	string win_name
//	if (is_def1 && is_def2)
//		win_name = flight_num + "_abs"
//	else
//		win_name = flight_num + "_abs_" + num2str(starti) + "_" + num2str(stopi)
//	endif
	
	PauseUpdate; Silent 1		// building window...
	//String fldrSav0= GetDataFolder(1)
	//SetDataFolder root:uas:flight_11_018:
	//SetDataFolder $("root:uas:"+flight_name+":")
	Display /W=(263.25,104,744,447.5)/N=$win_name :absorption:Tr_450[starti,stopi],:absorption:Tr_525[starti,stopi],:absorption:Tr_624[starti,stopi] vs uas_datetime[starti,stopi]
	AppendToGraph/L=Alt Alt_m_cont[starti,stopi] vs uas_datetime[starti,stopi]
	AppendToGraph/L=ABS :absorption:avg_60sec:Bap_450[starti,stopi],:absorption:avg_60sec:Bap_525[starti,stopi],:absorption:avg_60sec:Bap_624[starti,stopi] vs uas_datetime[starti,stopi]
	SetDataFolder sdf
	ModifyGraph rgb(Tr_450)=(16384,16384,65280),rgb(Tr_525)=(0,65280,0),rgb(Alt_m_cont)=(4352,4352,4352)
	ModifyGraph rgb(Bap_450)=(0,0,65280),rgb(Bap_525)=(16384,65280,16384)
	ModifyGraph grid(left)=1,grid(ABS)=1
	ModifyGraph lblPos(left)=51,lblPos(bottom)=49,lblPos(Alt)=50,lblPos(ABS)=39
	ModifyGraph lblLatPos(Alt)=-3
	ModifyGraph freePos(Alt)=0
	ModifyGraph freePos(ABS)=0
	ModifyGraph axisEnab(left)={0.35,0.65}
	ModifyGraph axisEnab(Alt)={0.7,1}
	ModifyGraph axisEnab(ABS)={0,0.3}
	ModifyGraph dateInfo(bottom)={0,1,0}
	Label left "working Tr"
	Label Alt "Altitude, meters"
	//Label ABS "Bap, Mm-1"
//	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 flight_name
	string flt_str = replacestring("flight_",flight_num,"Flight ")
//	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 "Flight 11-010"
	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 flt_str
End

//Window check_offset() : Graph
Function uas_plot_offset_view(flight_num,[starti,stopi])
	string flight_num 
	variable starti,stopi

	if (cmpstr(flight_num,"")==0)
		 flight_num = uas_get_flight_num_pu(0)
		if (cmpstr(flight_num,uas_gui_cancel_string) == 0)
			return 0
		endif
	endif
	string sdf = uas_goto_flight_datafolder(flight_num)
	
	wave dt = uas_datetime
	variable is_def1=0, is_def2=0
	if (ParamIsDefault(starti)) 
		starti=0
		is_def1=1
	endif
	if (ParamIsDefault(stopi)) 
		stopi=numpnts(dt)-1
		is_def2=1
	endif


	string win_name = replacestring("flight_",flight_num,"f")
	if (is_def1 && is_def2)
		win_name += "_offset"
	else
		win_name += "_off_" + num2str(starti) + "_" + num2str(stopi)
	endif

//	string win_name
//	if (is_def1 && is_def2)
//		win_name = flight_num + "_abs"
//	else
//		win_name = flight_num + "_abs_" + num2str(starti) + "_" + num2str(stopi)
//	endif

	PauseUpdate; Silent 1		// building window...
	//String fldrSav0= GetDataFolder(1)
	//SetDataFolder root:uas:flight_1239:
	Display /W=(45.75,56.75,909.75,492.5) StaticP[starti,stopi],:payload:PRESS[starti,stopi] vs uas_datetime[starti,stopi]
	AppendToGraph/R GndSp_knts[starti,stopi] vs uas_datetime[starti,stopi]
	SetDataFolder sdf
	ModifyGraph lsize(StaticP)=1.5
	ModifyGraph rgb(PRESS)=(0,39168,0)
	ModifyGraph rgb(GndSp_knts)=(16384,16384,65280)
	ModifyGraph dateInfo(bottom)={0,1,0}
	string flt_str = replacestring("flight_",flight_num,"Flight ")
//	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 "Flight 11-010"
	TextBox/C/N=text0/F=0/A=MC/X=-37.38/Y=47.12 flt_str
EndMacro

Function uas_plot_from_marquee(type)
	string type // "profile", "abs", "both"
	GetMarquee/K/Z bottom
	variable left=V_left, right=V_right, top=V_top, bottom=V_bottom
	string win_name = S_marqueeWin
	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

	string flight_num = replacestring("_TS",win_name,"")
	string sdf = uas_goto_flight_datafolder(flight_num)

	wave dw = uas_datetime	
	
	variable starti, stopi
	print x2pnt(dw,V_left), x2pnt(dw,V_right)
	starti = round(x2pnt(dw,left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti > dimsize(dw,0)) ? dimsize(dw,0) : starti
	stopi = round(x2pnt(dw,right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi > dimsize(dw,0)) ? dimsize(dw,0) : stopi
	print starti, stopi	
	
	if (cmpstr(type,"profile")==0 || cmpstr(type,"prof_and_abs")==0)
		uas_plot_profile(flight_num,starti=starti,stopi=stopi)
	endif
	if (cmpstr(type,"abs")==0 || cmpstr(type,"prof_and_abs")==0)
		uas_plot_absorption(flight_num,starti=starti,stopi=stopi)
	endif
	if (cmpstr(type,"offset")==0)
		uas_plot_offset_view(flight_num,starti=starti,stopi=stopi)
	endif
	
	
	setdatafolder sdf
	

End

Function cloud_msems_process(tb)
	variable tb
	
	// go to flight
	// function ph
	
	string sdf = getdatafolder(1)
	
	string wlist = "sheath_flw_avg;mcpc_smpf_avg;press_avg;temp_avg;total_conc;"
//	wlist += "pressure;sample_flow;temperature_board;temperature_laser"
	
	string wlist_2d = "conc;counts;bindia;bin_size_limits"
	
	newdatafolder/o/s $("data_"+num2str(tb)+"sec")
		
	wave flt_dt = $"::inverted:datetimes"
//	wave flt_dn = $"::raw:bin_concentration"
	wavestats/Q flt_dt
	variable mintime = V_min
	variable maxtime = V_max
	
	variable first_starttime=mintime - mod(mintime,tb)
	variable last_starttime=maxtime - mod(maxtime,tb) + tb

	variable time_periods = (last_starttime-first_starttime)/(tb) + 1

	if ((last_starttime-maxtime) > tb)
		time_periods -= 1
	endif
	
	make/D/o/n=(time_periods) $"msems_datetime"
	wave dt = $"msems_datetime"

	make/D/o/n=(time_periods) $"stop_datetime"
	wave stop_dt = $"stop_datetime"
	
	dt[0] = first_starttime
	dt[1,] = dt[p-1] + tb
	stop_dt = dt[p]+tb
	
	variable i
	for (i=0; i<itemsinlist(wlist_2d); i+=1)
		string wname = stringfromlist(i, wlist_2d)
		print("working on " + wname)
		string flt_wname = "::inverted:"+wname
		if (cmpstr(wname, "conc")==0)
			wname = "msems_dNdlogDp"
		endif
		acg_avg_using_time_index_2d(dt, stop_dt, flt_dt, $flt_wname, wname)
		SetScale/P x dt[0],tb,"dat", $wname
	endfor

	for (i=0; i<itemsinlist(wlist); i+=1)
		wname = stringfromlist(i, wlist)
		print("working on " + wname)
		flt_wname = "::inverted:"+wname
		if (cmpstr(wname, "total_conc")==0)
			wname = "msems_intN"
		endif
		acg_avg_using_time_index(dt, stop_dt, flt_dt, $flt_wname, wname)
		SetScale/P x dt[0],tb,"dat", $wname
	endfor
	
//	variable cols = dimsize(flt_dn, 1)
//	make/o/n=(time_periods, cols) $"pops_dNdlogDp"
//	wave dndlogdp = $"pops_dNdlogDp"
	setdatafolder ::
	setdatafolder $("data_"+num2str(tb)+"sec")
	
	wave msems_dp = $"bindia"
	wave msems_dp_im = $"bin_size_limits"
	
	// make dp waves
	make/o/n=(dimsize(msems_dp, 1)) $"msems_dp_um"
	wave dp = $"msems_dp_um"
	dp = msems_dp[0][p] / 1000.0 // convert to um
	
	make/o/n=(dimsize(msems_dp_im, 1)) $"msems_dp_um_im"
	wave dp_im = $"msems_dp_um_im"
	dp_im = msems_dp_im[0][p]/ 1000.0 // convert to um
	
//	wave dp_um = $"diameter_um"
//	make/o/n=(dimsize(dp_um, 1)) $"pops_dp_um"
//	wave dp = $"pops_dp_um"
//	dp = dp_um[0][p]
//	
//	uas_getDpBounds(dp, "pops_dp_um_im")
//	wave dp_bounds = $"pops_dp_um_im"
//	duplicate/o dp, dlogdp
//	dlogdp = log(dp_bounds[p+1]/dp_bounds[p])
	
	make/D/o/n=(numpnts(dt)+1) $"msems_datetime_im"
	wave dt_bounds = $"msems_datetime_im"
	
	dt_bounds = dt[p]
	dt_bounds[numpnts(dt)] = dt_bounds[numpnts(dt)-1] + tb 
	
//	duplicate/o $"bin_concentration" $"pops_dNdlogDp"
//	wave dndlogdp = $"pops_dNdlogDp"
//	dndlogdp /= dlogdp
	
	setdatafolder sdf
End


Function cloud_pops_process(tb, [fix_dp])
	variable tb
	variable fix_dp
	
	variable use_handix_dp = 0
	if (!ParamIsDefault(fix_dp))
		use_handix_dp = fix_dp
	endif
	
	if (use_handix_dp)
		wave handix_dp = $"root:uas:cloudy:pops:updated_params:diameter_um_handix"
		wave old_dp = $":raw:diameter_um"
		if (!waveexists($":raw:diameter_um_bad"))
			duplicate old_dp, $":raw:diameter_um_bad"
		endif
		old_dp = handix_dp[q]
	endif
	
	// go to flight
	// function ph
	
	string sdf = getdatafolder(1)
	
	string wlist = "det_baseline;det_baseline_sd;integral_concentration;integral_counts;monitor_laser;"
	wlist += "pressure;sample_flow;temperature_board;temperature_laser"
	
	string wlist_2d = "bin_concentration;bin_counts;diameter_um"
	
	newdatafolder/o/s $("data_"+num2str(tb)+"sec")
		
	wave flt_dt = $"::raw:StartDateTime"
	wave flt_dn = $"::raw:bin_concentration"
	wavestats/Q flt_dt
	variable mintime = V_min
	variable maxtime = V_max
	
	variable first_starttime=mintime - mod(mintime,tb)
	variable last_starttime=maxtime - mod(maxtime,tb) + tb

	variable time_periods = (last_starttime-first_starttime)/(tb) + 1

	if ((last_starttime-maxtime) > tb)
		time_periods -= 1
	endif
	
	make/D/o/n=(time_periods) $"pops_datetime"
	wave dt = $"pops_datetime"

	make/D/o/n=(time_periods) $"stop_datetime"
	wave stop_dt = $"stop_datetime"
	
	dt[0] = first_starttime
	dt[1,] = dt[p-1] + tb
	stop_dt = dt[p]+tb
	
	variable i
	for (i=0; i<itemsinlist(wlist_2d); i+=1)
		string wname = stringfromlist(i, wlist_2d)
		print("working on " + wname)
		string flt_wname = "::raw:"+wname
		wave flt_w = $flt_wname
		acg_avg_using_time_index_2d(dt, stop_dt, flt_dt, flt_w, wname)
		SetScale/P x dt[0],tb,"dat", $wname
	endfor

	for (i=0; i<itemsinlist(wlist); i+=1)
		wname = stringfromlist(i, wlist)
		print("working on " + wname)
		flt_wname = "::raw:"+wname
		wave flt_w = $flt_wname
		acg_avg_using_time_index(dt, stop_dt, flt_dt, flt_w, wname)
		SetScale/P x dt[0],tb,"dat", $wname
	endfor
	
//	variable cols = dimsize(flt_dn, 1)
//	make/o/n=(time_periods, cols) $"pops_dNdlogDp"
//	wave dndlogdp = $"pops_dNdlogDp"
	setdatafolder ::
	setdatafolder $("data_"+num2str(tb)+"sec")
	
	wave dp_um = $"diameter_um"
	make/o/n=(dimsize(dp_um, 1)) $"pops_dp_um"
	wave dp = $"pops_dp_um"
	dp = dp_um[0][p]
	
	uas_getDpBounds(dp, "pops_dp_um_im")
	wave dp_bounds = $"pops_dp_um_im"
	duplicate/o dp, dlogdp
	dlogdp = log(dp_bounds[p+1]/dp_bounds[p])
	
	make/D/o/n=(numpnts(dt)+1) $"pops_datetime_im"
	wave dt_bounds = $"pops_datetime_im"
	
	dt_bounds = dt[p]
	dt_bounds[numpnts(dt)] = dt_bounds[numpnts(dt)-1] + tb 
	
	duplicate/o $"bin_concentration" $"pops_dNdlogDp"
	wave dndlogdp = $"pops_dNdlogDp"
	dndlogdp = dndlogdp[p][q] / dlogdp[q]
	
	SetScale/P x dt[0],tb,"dat", dndlogdp
	
	wave conc = $"bin_concentration"
	duplicate/o $"integral_concentration", $"integral_concentration_140"
	wave int140 = $"integral_concentration_140"
	
	// integrate skipping first channel
	for (i=0; i<numpnts(int140); i+=1)
		variable tot = 0
		variable j
		for (j=1; j<dimsize(conc,1); j+=1)
			tot += conc[i][j]
		endfor
		int140[i] = tot
	endfor
	
	setdatafolder sdf
End

Function uas_getDpBounds(diam,diam_bounds_name)
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

Function cloud_plot_avg_from_marquee(tb)
//	string inst
	variable tb
//	string moment
//	string type
//	variable isFilter
	//variable withEditWin
	GetMarquee/Z  bottom

	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

//	print V_flag, V_left, V_right, V_top, V_bottom
	variable left = V_left
	variable right = V_right
	//string graphname = S_marqueeWin
//	print AxisList("")
//	print (secs2date(left,-2)+" "+secs2time(left,3))
	
	string sdf = getdatafolder(1)
	setdatafolder root:
	
	GetWindow $S_marqueeWin wavelist
	wave/T wlist = W_WaveList
	variable ii, jj
	string flight_num = ""
	for (ii=0; ii<dimsize(wlist,0); ii+=1)
//		for (jj=0; jj<dimsize(wlist,1); jj+=1)
//			print wlist[ii][jj]
//		endfor
		
//		variable use_msems = 1
//		if (strsearch(wlist[ii][0], "pops", 0) > 0)
//			use_msems = 0
//		endif
		
		if (strsearch(wlist[ii][0], "dNdlogDp", 0) > 0)
			variable index = strsearch(wlist[ii][1], ":data_", 0)
			variable firsti = index-8
			variable lasti = index-1
			string s = wlist[ii][1]
//			print (flt_num[firsti, lasti])
			flight_num = s[firsti, lasti]
			break
		endif
	endfor
	setdatafolder sdf
		
	if (cmpstr(flight_num, "")==0)
		print("no dNdlogDp waves found")
		return 0
	endif

	// start tmp comment

//	string types = ""
//	if (cmpstr(type,"BOTH")==0)
//		types = "UNHEATED;HEATED"
//	else
//		types = type
//	endif
//	

	sdf = getdatafolder(1)

	string sys_list = "cloudy;clear"
	string inst_list = "msems;pops"
//	string inst_list = "msems"
//	string inst_list = "pops"

	setdatafolder root:uas:cloudy
	newdatafolder/o/s plots
	newdatafolder/o/s averages
	
//	string index_inst = "pops"
//	if (use_msems)
//		index_inst = "msems"
//	endif
//	
//	string index_path = "root:uas:cloudy:msems:cloud_"
//	index_path += index_inst + "_"
//	index_path += flight_num + ":"
//	index_path += "data_"+num2str(tb)+"sec:"
//	
//	wave index_dt = $(index_path+index_inst+"_datetime")
//	wave index_dw = $(index_path+index_inst+"_dNdlogDp")
	
	string legend_text	
	variable insti, sysi
	variable plot_num = 0
	for (sysi=0; sysi<itemsinlist(sys_list); sysi+=1)
		string system = stringfromlist(sysi, sys_list)
		for (insti=0; insti<itemsinlist(inst_list); insti+=1)
		
			string inst = stringfromlist(insti, inst_list)
			
//			string path = "root:uas:cloudy:"+inst+":cloud_"
			string prefix = "cloud"
			if (cmpstr(system, "clear")==0)
				prefix = "clear"
			endif
			string path = "root:uas:"+system+":"+inst+":"+prefix+"_"
			path += inst + "_"
			path += flight_num + ":"
			path += "data_"+num2str(tb)+"sec:"
			
			string dt_name = inst+"_datetime"
			string dn_name = inst+"_dNdlogDp"
			string dp_name = inst+"_dp_um"
			
			wave dt  = $(path+dt_name)
			if (!waveexists(dt))
				continue
			endif
			wave dp =  $(path+dp_name)
			
//			if (insti == 0)
			if (plot_num == 0)
				NVAR/Z gindex = graph_index
				if (!nvar_exists(gindex))
					variable/G graph_index = -1
				endif
				nvar gindex = graph_index
				gindex += 1 // increment graph index to create unique waves and graph
			endif			
	
	//	variable tindex
	//	string legend_text
	//	for (tindex=0; tindex<itemsinlist(types); tindex+=1)
	//		
	//		string df
	//		if (isFilter)
	//			df = "root:"+inst+":data_"+num2str(tb)+"sec:filter"
	//		else
	//			df = "root:"+inst+":data_"+num2str(tb)+"sec"
	//		endif
	//		setdatafolder $df
	//		
	//		wave dt = $(inst+"_datetime")
	//		wave dp = $(inst+"_dp")
	//		
	//		if (tindex == 0)
	//			NVAR/Z gindex = graph_index
	//			if (!nvar_exists(gindex))
	//				variable/G graph_index = -1
	//			endif
	//			nvar gindex = graph_index
	//			gindex += 1 // increment graph index to create unique waves and graph
	//		endif			
	//		
	//		
	//		string wn
	//		if (cmpstr(moment,"NUMBER")==0)
	//			wn = inst+"_dNdlogDp"
	//		elseif (cmpstr(moment,"SURFACE")==0)
	//			wn = inst+"_dSdlogDp"
	//		elseif (cmpstr(moment,"VOLUME")==0)
	//			wn = inst+"_dVdlogDp"
	//		else
	//			print moment + " not implemented yet"
	//			setdatafolder sdf
	//			return 0
	//		endif
	//		
	//		string phase = stringfromlist(tindex,types)
	//		
	//		if (!waveexists($(":"+phase+":"+wn)))
	//			wave orig = $wn
	//			pfw_filter_wave(orig, phase,wn,0, subfld=phase)
	//		endif
	//		
	//		setdatafolder $(":"+phase)
	//		wave dw = $wn
	//
	//		newdatafolder/o/s plots
	//		newdatafolder/o/s averages
	
			wave dw = $(path+dn_name)
	
			// for now...all average data in one folder
			variable starti, stopi
	//	FindValue/T=(smps_defaultTimeBase/2)/V=(V_left) t
	//	starti = V_value>-1 ? V_value : 0
	//	FindValue/T=(smps_defaultTimeBase/2)/V=(V_right) t
	//	stopi = V_value>-1 ? V_value : numpnts(t)-1
	//	print starti, stopi		
		//starti = round(x2pnt(dw,V_left))
	//		starti = round(x2pnt(index_dw,left))
	//		starti = (starti < 0) ? 0 : starti
	//		starti = (starti > dimsize(index_dw,0)) ? dimsize(index_dw,0) : starti
	//		//stopi = round(x2pnt(dw,V_right))
	//		stopi = round(x2pnt(index_dw,right))
	//		stopi = (stopi < 0) ? 0 : stopi
	//		stopi = (stopi > dimsize(index_dw,0)) ? dimsize(index_dw,0) : stopi
			//print starti, stopi	
			
			string wn = dn_name
	
			variable/D start_dt = round(left)
			variable/D stop_dt = round(right)
			
	
			string wnote = ""
	//		wnote += replacestringbykey("DT_START",wn,(secs2date(index_dt[starti],-2)+" "+secs2time(index_dt[starti],3)))
	//		wnote += replacestringbykey("DT_STOP",wn,(secs2date(index_dt[stopi],-2)+" "+secs2time(index_dt[stopi],3)))
			wnote += replacestringbykey("DT_START",wn,(secs2date(start_dt,-2)+" "+secs2time(start_dt,3)))
			wnote += replacestringbykey("DT_STOP",wn,(secs2date(stop_dt,-2)+" "+secs2time(stop_dt,3)))
			print wnote
			//note
		
			variable inst_starti = BinarySearch(dt, start_dt)
			if (inst_starti < 0 && inst_starti == -1)
				inst_starti = 0
			elseif (inst_starti < 0 && inst_starti == -2)
				inst_starti = dimsize(dw,0) - 1
			elseif (inst_starti < 0)
				setdatafolder sdf
				return 1
			endif
	
			variable inst_stopi = BinarySearch(dt, stop_dt)
			if (inst_stopi < 0 && inst_stopi == -1)
				inst_stopi = 0
			elseif (inst_stopi < 0 && inst_stopi == -2)
				inst_stopi = dimsize(dw,0) - 1
			elseif (inst_stopi < 0)
				setdatafolder sdf
				return 1
			endif
			
			string gn = system+"_"+wn+"_"+num2str(gindex)
			make/o/n=(numpnts(dp))/D $gn
			wave dWdlogDp = $gn
			dWdlogDp = NaN
			duplicate/o dp $(system+"_"+dp_name)
			wave dp = $(system+"_"+dp_name)
	
			note dWdlogDp, wnote
	//	if (withEditWin)
	//		// create subset 2d wave for "Edit Average Distribution" window
	//		make/o/n=(stopi-starti+1,dimsize(dw,1)) root:gui:ADE:editAvgDist_w
	//		wave editAvg = root:gui:ADE:editAvgDist_w
	//		editAvg = dw[p+starti][q]
	//		SetScale/I x pnt2x(dw,starti),pnt2x(dw,stopi),"dat", editAvg
	//
	//		duplicate/o d root:gui:ADE:editDp_w
	//	
	//		nvar startIndex = root:gui:ADE:avg_start_index
	//		startIndex = starti
	//		nvar stopIndex = root:gui:ADE:avg_stop_index
	//		stopIndex = stopi
	//		nvar currentIndex = root:gui:ADE:avg_current_index
	//		currentIndex = starti		
	//		
	//		sizing_single_from_avg()
	//		
	//		Execute "sizing_EditAvgDist()"
	//		
	//	endif
		
			variable avg, cnt, j, i
			for (j=0;j<dimsize(dw,1); j+=1)
		
				avg=0
				cnt=0
				for (i=inst_starti; i<=inst_stopi; i+=1)
					if (numtype(dw[i][j]) == 0)
						avg+=dw[i][j]
						cnt+=1
					endif
				endfor
				dWdlogDp[j] = avg / cnt
			endfor	
			
			//string legend_text = ""
//			if (insti == 0)
			if (plot_num == 0)
				Display dWdlogDp vs dp
				ModifyGraph log(bottom)=1;DelayUpdate
				Label left "dN / dlogDp";DelayUpdate
				
				Label bottom "D\\Bp\\M (nm)"
				ModifyGraph rgb=(0,0,65280); DelayUpdate
				//Legend/C/N=text0/J/A=MC "\\s("+wn+") "+ stringfromlist(tindex,types)
				legend_text = "\\s("+gn+") "+ system+"_"+inst
				
				string wave_note = note(dWdlogDp)
				string dt_start = stringbykey("DT_START",wave_note)
				string dt_stop = stringbykey("DT_STOP",wave_note)
				TextBox/C/N=text1/A=MC ("Time Range: " + dt_start + " - " + dt_stop)
				plot_num += 1
			else
				AppendToGraph dWdlogDp vs dp
				//Legend/C/N=text0/J/A=MC "\\s("+wn+") "+ stringfromlist(tindex,types)
	//			legend_text += "\r\\s("+gn+"#"+num2str(insti)+") "+ inst
				legend_text += "\r\\s("+gn+") "+ system+"_"+inst
				
			endif
			Legend/C/N=text0/J/A=MC legend_text
			
		endfor
	endfor
	setdatafolder sdf

	// end tmp comment
	

	//endfor		
End

// Quick and Dirty for looking at comparison during ATOMIC
Function uas_comp_avg_from_marquee(flight_id)
	string flight_id // name of folder holding data
//	string inst
//	variable tb
//	string moment
//	string type
//	variable isFilter
	//variable withEditWin
	GetMarquee/Z  bottom

	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif

//	print V_flag, V_left, V_right, V_top, V_bottom
	variable left = V_left
	variable right = V_right
	//string graphname = S_marqueeWin
//	print AxisList("")
//	print (secs2date(left,-2)+" "+secs2time(left,3))
		
	string sdf = getdatafolder(1)
	setdatafolder root:uas

	if (!DataFolderExists(flight_id))
		print "No flight of that name: " + flight_id
		return 1
	endif
	
	string leg_id = "Leg1"
	if (cmpstr(flight_id, "Jan31") == 0)
		leg_id = "Leg2"
	endif
	
//	string payload_list = "clear_sky;cloudy_sky"
//	string inst_map = "
//	string dp_map = "clear_sky:Dp_start;cloudy_sky;
	
	string inst_list = "clear_pops;cloudy_pops;cloudy_msems;dmps_aps;clear_pops_hk"				
	string dt_map = "clear_pops=root:uas:FLIGHT_ID:clear_sky:pops:ave_30:StartDateTime;"
	dt_map = addlistitem("cloudy_pops=root:uas:FLIGHT_ID:cloudy_sky:pops:data_30sec:pops_datetime", dt_map, ";",Inf)
	dt_map = addlistitem("cloudy_msems=root:uas:FLIGHT_ID:cloudy_sky:msems:data_30sec:msems_datetime", dt_map, ";",Inf)
	dt_map = addlistitem("dmps_aps=root:sizing:LEG_ID:dmps_aps:data_300sec:dmps_aps_datetime", dt_map, ";",Inf)
	dt_map = addlistitem("clear_pops_hk=root:uas:FLIGHT_ID:clear_sky:pops:hk:avg_30:date_time", dt_map, ";",Inf)

	string dp_map = "clear_pops=root:uas:FLIGHT_ID:clear_sky:pops:ave_30:Dp_start_um;"
	dp_map = addlistitem("cloudy_pops=root:uas:FLIGHT_ID:cloudy_sky:pops:data_30sec:pops_dp_um", dp_map, ";",Inf)
	dp_map = addlistitem("cloudy_msems=root:uas:FLIGHT_ID:cloudy_sky:msems:data_30sec:msems_dp_um", dp_map, ";",Inf)
	dp_map = addlistitem("dmps_aps=root:sizing:LEG_ID:dmps_aps:data_300sec:dmps_aps_dp_um", dp_map, ";",Inf)
	dp_map = addlistitem("clear_pops_hk=root:uas:FLIGHT_ID:clear_sky:pops:hk:avg_30:dp_um", dp_map, ";",Inf)

	string dn_map = "clear_pops=root:uas:FLIGHT_ID:clear_sky:pops:ave_30:dNdlogDp_all;"
	dn_map = addlistitem("cloudy_pops=root:uas:FLIGHT_ID:cloudy_sky:pops:data_30sec:pops_dNdlogDp", dn_map, ";",Inf)
	dn_map = addlistitem("cloudy_msems=root:uas:FLIGHT_ID:cloudy_sky:msems:data_30sec:msems_dNdlogDp", dn_map, ";",Inf)
	dn_map = addlistitem("dmps_aps=root:sizing:LEG_ID:dmps_aps:data_300sec:dmps_aps_dNdlogDp", dn_map, ";",Inf)
	dn_map = addlistitem("clear_pops_hk=root:uas:FLIGHT_ID:clear_sky:pops:hk:avg_30:pops_dNdlogDp_hk", dn_map, ";",Inf)


//	setdatafolder root:uas:cloudy
	setdatafolder $flight_id
	newdatafolder/o/s plots
	newdatafolder/o/s averages

	string legend_text	
	
	variable insti
	for (insti=0; insti<itemsinlist(inst_list); insti+=1)

		string inst = stringfromlist(insti, inst_list)
		
		string dt_name = stringbykey(inst, dt_map,"=")
		dt_name = replaceString("FLIGHT_ID", dt_name, flight_id)
		dt_name = replaceString("LEG_ID", dt_name, leg_id)
		
		string dp_name = stringbykey(inst, dp_map,"=")
		dp_name = replaceString("FLIGHT_ID", dp_name, flight_id)
		dp_name = replaceString("LEG_ID", dp_name, leg_id)
		
		string dn_name = stringbykey(inst, dn_map,"=")
		dn_name = replaceString("FLIGHT_ID", dn_name, flight_id)
		dn_name = replaceString("LEG_ID", dn_name, leg_id)

		
//		string path = "root:uas:cloudy:"+inst+":cloud_"
//		path += inst + "_"
//		path += flight_num + ":"
//		path += "data_"+num2str(tb)+"sec:"
//		
//		string dt_name = inst+"_datetime"
//		string dn_name = inst+"_dNdlogDp"
//		string dp_name = inst+"_dp_um"
		
		wave dt  = $(dt_name)
		if (!waveexists(dt))
			continue
		endif
		wave dp =  $(dp_name)
		
		if (insti == 0)
			NVAR/Z gindex = graph_index
			if (!nvar_exists(gindex))
				variable/G graph_index = -1
			endif
			nvar gindex = graph_index
			gindex += 1 // increment graph index to create unique waves and graph
		endif			

		wave dw = $(dn_name)

		// for now...all average data in one folder
		variable starti, stopi
		string wn = NameOfwave(dw)

		variable/D start_dt = round(left)
		variable/D stop_dt = round(right)
		

		string wnote = ""
//		wnote += replacestringbykey("DT_START",wn,(secs2date(index_dt[starti],-2)+" "+secs2time(index_dt[starti],3)))
//		wnote += replacestringbykey("DT_STOP",wn,(secs2date(index_dt[stopi],-2)+" "+secs2time(index_dt[stopi],3)))
		wnote += replacestringbykey("DT_START",wn,(secs2date(start_dt,-2)+" "+secs2time(start_dt,3)))
		wnote += replacestringbykey("DT_STOP",wn,(secs2date(stop_dt,-2)+" "+secs2time(stop_dt,3)))
		print wnote
		//note
	
		variable inst_starti = BinarySearch(dt, start_dt)
		if (inst_starti < 0 && inst_starti == -1)
			inst_starti = 0
		elseif (inst_starti < 0 && inst_starti == -2)
			inst_starti = dimsize(dw,0) - 1
		elseif (inst_starti < 0)
			setdatafolder sdf
			return 1
		endif

		variable inst_stopi = BinarySearch(dt, stop_dt)
		if (inst_stopi < 0 && inst_stopi == -1)
			inst_stopi = 0
		elseif (inst_stopi < 0 && inst_stopi == -2)
			inst_stopi = dimsize(dw,0) - 1
		elseif (inst_stopi < 0)
			setdatafolder sdf
			return 1
		endif
		
		string gn = wn+"_"+num2str(gindex)
		make/o/n=(numpnts(dp))/D $gn
		wave dWdlogDp = $gn
		dWdlogDp = NaN
		string dp_gn = NameOfWave(dp) +"_"+num2str(gindex)
		duplicate/o dp $(dp_gn)
		wave dp = $(dp_gn)

		note dWdlogDp, wnote
//	if (withEditWin)
//		// create subset 2d wave for "Edit Average Distribution" window
//		make/o/n=(stopi-starti+1,dimsize(dw,1)) root:gui:ADE:editAvgDist_w
//		wave editAvg = root:gui:ADE:editAvgDist_w
//		editAvg = dw[p+starti][q]
//		SetScale/I x pnt2x(dw,starti),pnt2x(dw,stopi),"dat", editAvg
//
//		duplicate/o d root:gui:ADE:editDp_w
//	
//		nvar startIndex = root:gui:ADE:avg_start_index
//		startIndex = starti
//		nvar stopIndex = root:gui:ADE:avg_stop_index
//		stopIndex = stopi
//		nvar currentIndex = root:gui:ADE:avg_current_index
//		currentIndex = starti		
//		
//		sizing_single_from_avg()
//		
//		Execute "sizing_EditAvgDist()"
//		
//	endif
	
		variable avg, cnt, j, i
		for (j=0;j<dimsize(dw,1); j+=1)
	
			avg=0
			cnt=0
			for (i=inst_starti; i<=inst_stopi; i+=1)
				if (numtype(dw[i][j]) == 0)
					avg+=dw[i][j]
					cnt+=1
				endif
			endfor
			dWdlogDp[j] = avg / cnt
		endfor	
		
		//string legend_text = ""
		if (insti == 0)
			Display dWdlogDp vs dp
			ModifyGraph log(bottom)=1;DelayUpdate
			Label left "dN / dlogDp";DelayUpdate
			
			Label bottom "D\\Bp\\M (nm)"
			ModifyGraph rgb=(0,0,65280); DelayUpdate
			//Legend/C/N=text0/J/A=MC "\\s("+wn+") "+ stringfromlist(tindex,types)
			legend_text = "\\s("+gn+") "+ inst
			
			string wave_note = note(dWdlogDp)
			string dt_start = stringbykey("DT_START",wave_note)
			string dt_stop = stringbykey("DT_STOP",wave_note)
			TextBox/C/N=text1/A=MC ("Time Range: " + dt_start + " - " + dt_stop)
		else
			AppendToGraph dWdlogDp vs dp
			//Legend/C/N=text0/J/A=MC "\\s("+wn+") "+ stringfromlist(tindex,types)
//			legend_text += "\r\\s("+gn+"#"+num2str(insti)+") "+ inst
			legend_text += "\r\\s("+gn+") "+ inst
			
		endif
		Legend/C/N=text0/J/A=MC legend_text
		
	endfor

	setdatafolder sdf

	// end tmp comment
	

	//endfor		
End

Function pops_int140_quick()

	wave conc = $"bin_concentration"
	duplicate/o $"integral_concentration", $"integral_concentration_140"
	wave int140 = $"integral_concentration_140"

	// integrate skipping first channel
	variable i
	for (i=0; i<numpnts(int140); i+=1)
		variable tot = 0
		variable j
		for (j=1; j<dimsize(conc,1); j+=1)
			tot += conc[i][j]
		endfor
		int140[i] = tot
	endfor


End