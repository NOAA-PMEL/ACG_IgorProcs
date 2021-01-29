#pragma rtGlobals=1		// Use modern global access method.

//User defined variables====
	//Path to local data source

constant acg_cn_version=1.0

strconstant cn_tmp_data_folder = "root:cn_tmp_data_folder"
strconstant cn_data_folder = "root:cn"
strconstant cn_dataselector_format = "dataselector"
strconstant cn_dataselector_format_2 = "dataselector2"  // ICEALOT format
strconstant cn_dchart_itx_format = "dchart_itx"

strconstant cn_cpc_list = "CN_Direct;CN_stack;CN_Direct2"
strconstant cn_ucpc_list = "UFCN;WCPC;CN_mart" // WCPC here?

strconstant cn_default_cpc_inst= "CN_Direct"
strconstant cn_default_ucpc_inst = "UFCN"

// ProjectFlagWave 
constant cn_auto_include_PFW = 0 // if true, automatically use PFW to filter along with user_nans

//menu "CN"
menu "ACG Data"
	submenu "CN"
		submenu "Load Data"
			"from DChart - igor text", load_cn_data(cn_dchart_itx_format)
			"from DataSelector", load_cn_data(cn_dataselector_format_2)
		end
		"Re-calculate cpc waves", cn_recalc_cpc_waves()
	end
end

Menu "GraphMarquee"
	"-"
	submenu "CPC and UCPC"
		"nan range", cn_toggle_nans_from_marquee("cpc",1); cn_toggle_nans_from_marquee("ucpc",1)
		"reset range", cn_toggle_nans_from_marquee("cpc",0);cn_toggle_nans_from_marquee("ucpc",0)
		"nan dropouts",n_nan_dropouts_from_marquee("cpc");cn_nan_dropouts_from_marquee("ucpc")
	end
	submenu "CPC"
		"nan range", cn_toggle_nans_from_marquee("cpc",1)
		"reset range", cn_toggle_nans_from_marquee("cpc",0)
		"nan dropouts",cn_nan_dropouts_from_marquee("cpc")
		submenu "select instrument"
			"default", cn_set_inst_flag("cpc","default") 
			"CN_Direct", cn_set_inst_flag("cpc","CN_Direct") 
			"CN_stack", cn_set_inst_flag("cpc","CN_stack") 
		end
	end
	submenu "UCPC"
		"nan range", cn_toggle_nans_from_marquee("ucpc",1)
		"reset range", cn_toggle_nans_from_marquee("ucpc",0)
		"nan dropouts",cn_nan_dropouts_from_marquee("ucpc")
		submenu "select instrument"
			"default", cn_set_inst_flag("ucpc","default") 
			"UFCN", cn_set_inst_flag("ucpc","UFCN") 
			"WCPC", cn_set_inst_flag("ucpc","WCPC") 
			"CN_mart", cn_set_inst_flag("ucpc","CN_mart") 
		end			
	end
	
End

Function cn_rename_waves()

	string wlist = acg_get_wave_list()
	
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		string name = stringfromlist(i,wlist)
		// check if wave contains CCN_mono_ or CCN_spectra_ and remove
//		if (strsearch(name,"CCN_mono_",0) >=0 )
//			name = ReplaceString("CCN_mono_", name, "")
//			
//			if (cmpstr(name, "Concentration") == 0)
//				Rename $stringfromlist(i,wlist), $("CCN_Concentration")
//			elseif (cmpstr(name, "1stStageVoltage") == 0)
//				Rename $stringfromlist(i,wlist), $("X1stStageVoltage")
//			else
//				Rename $stringfromlist(i,wlist), $name
//			endif
//		elseif (strsearch(name,"CCN_spectra_",0) >=0 )
//			name = ReplaceString("CCN_spectra_", name, "")
//			
//			if (cmpstr(name, "Concentration") == 0)
//				Rename $stringfromlist(i,wlist), $("CCN_Concentration")
//			elseif (cmpstr(name, "1stStageVoltage") == 0)
//				Rename $stringfromlist(i,wlist), $("X1stStageVoltage")
//			else
//				Rename $stringfromlist(i,wlist), $name
//			endif
//		endif
		

		// handle new DateTime label
		if (cmpstr(name, "DateTimeW") == 0)
			Rename $name, $("Start_DateTime")
		elseif (cmpstr(name, "CN_water") == 0)
			Rename $name, $("WCPC")
		endif
	endfor
	
	
End

Function cn_rename_itx_waves()
	string cn_label = "Start_DateTime;UFCN;WCPC;CN_Direct;CN_Direct2;CN_stack;CN_mart"
	string cn_long_names = "StartDateTime;cn_ultrafine;cn_water;cn_direct;cn_direct2;cn_stack;cn_mart"
	
	string wlist = acg_get_wave_list()
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		string name = stringfromlist(i,wlist)
		variable index = whichlistitem(name,cn_long_names)
		if (index >=0)
			rename $name, $stringfromlist(index,cn_label)
		endif
	endfor
	

End

Function load_cn_data(file_format)
	string file_format
	string sdf = getdatafolder(1)
	
	newdatafolder/o $cn_data_folder            // create main cn data folder

	if (datafolderexists(cn_tmp_data_folder))
		killdatafolder/Z $cn_tmp_data_folder
	endif
	newdatafolder/o/s $cn_tmp_data_folder  // create temporary data folder

	// Load and correct CN data
	newdatafolder/o/s :cn
	print "Starting on CN data:"
	print "	loading..."
	
	if (cmpstr(file_format,cn_dataselector_format) == 0)
		load_data_selector_format()
	elseif (cmpstr(file_format,cn_dataselector_format_2) == 0)
		load_data_selector_format_v2()
		cn_rename_waves();
	elseif (cmpstr(file_format,cn_dchart_itx_format) == 0)
		load_data_dchart_itx_format()
		cn_rename_itx_waves()		
	endif

	// load_data_selector_format()
//	// copy user selected CN data to CN_Concentration
//	if (ccn_use_this_cpc == 0) // use CN_AMS
//		duplicate/o CN_AMS CN_Concentration
//	elseif (ccn_use_this_cpc == 1) // use WCPC
//		duplicate/o WCPC CN_Concentration
//	else
//		print "unknown cpc to use!"
//		Abort "unkown cpc type!"
//	endif
//	killwaves/Z CN_AMS, WCPC	
//	correct_cn_data((ccn_tmp_data_folder+":cn"))
	setdatafolder $cn_tmp_data_folder


	// "Converting new data to constant time base and averaging into " + num2str(avg_period) + " sec periods"
	cn_same_timebase_tmp()
	
	// "Adding new data to main data"
	cn_combine_data_from_tmp()
	
	// remove tmp folders and waves
	//cn_clean_up()
	
	print "Done."
	setdatafolder sdf	
End
Function cn_clean_up()
	print "Cleaning up..."
	killdatafolder/Z $cn_tmp_data_folder
	killwaves/Z root:cn:main_wave_list
End

Function cn_same_timebase_tmp()
	string sdf = getdatafolder(1)
	setdatafolder $cn_tmp_data_folder

	print "Putting new data on constant 1s  time base"
	
	wave cn_tw = :cn:Start_DateTime
	
	// get timebase limits
	wavestats/Q cn_tw
	variable mintime=V_min
	variable maxtime=V_max
	//wavestats/Q cn_tw
	//mintime=(mintime>V_min) ? V_min : mintime
	//maxtime=(maxtime<V_max) ? V_max : maxtime

	variable/G first_starttime=mintime
	variable/G last_starttime=maxtime
	variable time_periods = last_starttime-first_starttime+1
	string dset_list = "cn"
	variable i,j,k
	make/O/N=(time_periods)/d date_time
	
	date_time[0] = first_starttime
	date_time[1,]  = date_time[p-1]+1
	
	string wname_list = acg_get_wlist_from_folder(":cn")

//	// create string wave to hold list of waves to combine
//	//make/O/T/N=(itemsinlist(dset_list)) root:main_wave_list
//	string mwl = ccn_data_folder + ":main_wave_list"
//	make/O/T/N=(itemsinlist(dset_list)) $(mwl)
//	//wave/T wavlist = root:main_wave_list
//	wave/T wavlist = $(mwl)
	
	string wlist=""
	// put all 1sec waves into date_time base
	for (i=0; i<itemsinlist(dset_list); i+=1)

		print "	working on " + stringfromlist(i,dset_list) + " data"	
		//string wname=""
		variable index=0
		do
			string ds=":"+stringfromlist(i,dset_list)
			string wname = stringfromlist(index,wname_list)
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
		//wavlist[i] = wlist

		// do time base once because it takes awhile
		print "		creating time index for constant time base (may take awhile)..."
		wave dst = $(ds+":Start_DateTime")
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
	endfor
	
	setdatafolder sdf	
End

Function cn_combine_data_from_tmp()
	string sdf = getdatafolder(1)
	//setdatafolder $ccn_tmp_data_folder
	//setdatafolder root:
	setdatafolder cn_data_folder

	print "Adding new data to main data"
	
	if (!waveexists(cn_datetime))
		cn_first_data_copy()
		return(0)
	endif 
	//wave main_tw = root:ccn_datetime
	wave new_tw = $(cn_tmp_data_folder + ":date_time")
	duplicate/o cn_datetime cn_datetime_bak
	wave bak_tw = cn_datetime_bak

	duplicate/o cn_cpc_user_nan cn_cpc_user_nan_bak
	//wave cpc_user_nan_bak = cn_cpc_user_nan_bak
	duplicate/o cn_ucpc_user_nan cn_ucpc_user_nan_bak
	//wave ucpc_user_nan_bak = cn_ucpc_user_nan_bak
	duplicate/o cn_cpc_inst_flag cn_cpc_inst_flag_bak
	//wave cpc_inst_flag_bak = cn_cpc_inst_flag_bak
	duplicate/o cn_ucpc_inst_flag cn_ucpc_inst_flag_bak
	//wave ucpc_inst_flag_bak = cn_ucpc_inst_flag_bak
		
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
	
	variable time_periods = (last_starttime-first_starttime) + 1

	make/o/n=(time_periods)/d cn_datetime
	wave main_tw = cn_datetime
	
	// create main timewave
	main_tw[0] = first_starttime
	main_tw[1,] = main_tw[p-1] + 1
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
	string wlist = acg_get_wlist_from_folder(cn_tmp_data_folder)
	string list = ""
	for (j=0; j<itemsinlist(wlist); j+=1)
		string wname = stringfromlist(j,wlist)
		if (cmpstr(wname,"date_time") != 0)
			list += wname + ";"
		endif
	endfor
	for (j=0; j<itemsinlist(list); j+=1)
		print "		adding " + stringfromlist(j,list)
		duplicate/o $(stringfromlist(j,list)) $(stringfromlist(j,list)+"_bak")
		duplicate/o main_tw $(stringfromlist(j,list))
		wave main = $(stringfromlist(j,list))
		wave bak = $(stringfromlist(j,list)+"_bak")
		wave new = $(cn_tmp_data_folder + ":" + stringfromlist(j,list))

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

	string aux_list = "cn_cpc_user_nan;cn_ucpc_user_nan;cn_cpc_inst_flag;cn_ucpc_inst_flag"
	for (i=0; i<itemsinlist(aux_list); i+=1)
		//duplicate/o cn_datetime cn_cpc_user_nan, cn_ucpc_user_nan, cn_cpc_inst_flag, cn_ucpc_inst_flag
		duplicate/o cn_datetime $(stringfromlist(i,aux_list))
		wave main = $(stringfromlist(i,aux_list))
		wave bak = $(stringfromlist(i,aux_list)+"_bak")

		SetScale/P x cn_datetime[0],1,"dat", main

		if (cmpstr(stringfromlist(i,aux_list),"cn_cpc_inst_flag") == 0)
			main = cn_get_inst_flag("cpc","default")
		elseif (cmpstr(stringfromlist(i,aux_list),"cn_ucpc_inst_flag") == 0)
			main = cn_get_inst_flag("ucpc","default")
		else
			main = 0
		endif

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

	
	
End

Function cn_first_data_copy()
	string sdf = getdatafolder(1)
	setdatafolder $cn_tmp_data_folder
	
	
	print "	First time...move new data to main"
	duplicate/o date_time root:cn:cn_datetime
	
	variable i,j,k
	//wave/T wavlist = root:main_wave_list
	//wave/T wavlist = $(ccn_data_folder + ":main_wave_list")
	string wlist = acg_get_wlist_from_folder(cn_tmp_data_folder)
	string list = ""
	for (j=0; j<itemsinlist(wlist); j+=1)
		string wname = stringfromlist(j,wlist)
		if (cmpstr(wname,"date_time") != 0)
			list += wname + ";"
		endif
	endfor
	for (j=0; j<itemsinlist(list); j+=1)
		//duplicate/o $(stringfromlist(j,wlist)+"_avg") root:ccn:$(stringfromlist(j,wlist))
		duplicate/o $(stringfromlist(j,list)) $(cn_data_folder+":"+stringfromlist(j,list))
	endfor
	
	setdatafolder $cn_data_folder
	wave dt = cn_datetime
	datetime2doy_wave(dt,"DOY")
	
	duplicate dt cn_cpc_user_nan, cn_ucpc_user_nan, cn_cpc_inst_flag, cn_ucpc_inst_flag
	wave cpc_user_nan = cn_cpc_user_nan
	wave ucpc_user_nan = cn_ucpc_user_nan
	cpc_user_nan = 0 
	ucpc_user_nan = 0
	wave cpc_inst_flag = cn_cpc_inst_flag
	wave ucpc_inst_flag = cn_ucpc_inst_flag
	cpc_inst_flag = cn_get_inst_flag("cpc","default")
	ucpc_inst_flag = cn_get_inst_flag("ucpc","default")
		 
	SetScale/P x dt[0],1,"dat", cpc_user_nan
	SetScale/P x dt[0],1,"dat", ucpc_user_nan
	SetScale/P x dt[0],1,"dat", cpc_inst_flag
	SetScale/P x dt[0],1,"dat", ucpc_inst_flag
	
	setdatafolder sdf	
End

function cn_get_inst_flag(inst, inst_label)
	string inst
	string inst_label

//strconstant cn_cpc_list = "CN_Direct;CN_AMS; CN_stack"
//strconstant cn_ucpc_list = "UFCN;WCPC" // WCPC here?
//
//strconstant cn_default_cpc_inst = "CN_Direct"
//strconstant cn_default_ucpc_inst = "UFCN"
	
	if (cmpstr(inst,"cpc") == 0)
		if (cmpstr(inst_label,"default")==0)
			inst_label = cn_default_cpc_inst
		endif
		//inst_label = (cmpstr(inst_label,"default")==0) ? cn_default_cpc_inst : inst_label
		return whichlistitem(inst_label,cn_cpc_list)
	elseif (cmpstr(inst,"ucpc") == 0)
		if (cmpstr(inst_label,"default")==0)
			inst_label = cn_default_ucpc_inst
		endif
		//inst_label = (cmpstr(inst_label,"default")==0) ? cn_default_ucpc_inst : inst_label
		return whichlistitem(inst_label,cn_ucpc_list)	
	else
		print "cn_get_inst_flag: unknown instrument -> " + inst
		return -1
	endif
end

function cn_toggle_nans_from_marquee(inst, isNaN)
	string inst
	variable isNaN
	
	//GetMarquee/K/Z left, bottom
	GetMarquee/K/Z bottom
	
	string sdf = getdatafolder(1)
	setdatafolder $cn_data_folder
	variable starti, stopi
	if (cmpstr(inst,"cpc") == 0)
		
		wave user_nan = cn_cpc_user_nan
		wave cpc = CN_Direct
		starti = round(x2pnt(cpc,V_left))
		starti = (starti < 0) ? 0 : starti
		starti = (starti >= numpnts(cpc)) ? numpnts(cpc)-1 : starti
		stopi = round(x2pnt(cpc,V_right))
		stopi = (stopi < 0) ? 0 : stopi
		stopi = (stopi >= numpnts(cpc)) ? numpnts(cpc)-1 : stopi
		
		user_nan[starti,stopi] = isNaN
		
	elseif (cmpstr(inst,"ucpc") == 0)
		
		wave user_nan = cn_ucpc_user_nan
		wave cpc = UFCN
		starti = round(x2pnt(cpc,V_left))
		starti = (starti < 0) ? 0 : starti
		starti = (starti >= numpnts(cpc)) ? numpnts(cpc)-1 : starti
		stopi = round(x2pnt(cpc,V_right))
		stopi = (stopi < 0) ? 0 : stopi
		stopi = (stopi >= numpnts(cpc)) ? numpnts(cpc)-1 : stopi
		
		user_nan[starti,stopi] = isNaN
		
	else
		print "unknown instrument: " + inst
		return 0
	endif
	
	cn_reprocess_data(inst)
	
	setdatafolder sdf
end

function cn_nan_dropouts_from_marquee(inst)
	string inst
	variable isNaN = 1 
	
	variable nan_threshhold = 0.01
	
	GetMarquee/K/Z left, bottom
//	GetMarquee/K/Z bottom
	
	string sdf = getdatafolder(1)
	setdatafolder $cn_data_folder
	variable starti, stopi
	if (cmpstr(inst,"cpc") == 0)
		
		wave user_nan = cn_cpc_user_nan
		wave inst_flag = cn_cpc_inst_flag

		wave cpc = CN_Direct
		
		string cpc_list = cn_cpc_list
		
		starti = round(x2pnt(cpc,V_left))
		starti = (starti < 0) ? 0 : starti
		starti = (starti >= numpnts(cpc)) ? numpnts(cpc)-1 : starti
		stopi = round(x2pnt(cpc,V_right))
		stopi = (stopi < 0) ? 0 : stopi
		stopi = (stopi >= numpnts(cpc)) ? numpnts(cpc)-1 : stopi
		
		variable i
		for (i=starti; i<=stopi; i+=1)
			
			wave cpc = $(stringfromlist(inst_flag[i],cpc_list))
//			if (numtype(cpc[i]) == 0 && cpc[i]<nan_threshhold)
			if (numtype(cpc[i]) == 0  && cpc[i] >= V_bottom && cpc[i]<=V_top)
				user_nan[i] = isNaN
			endif
		endfor		
	elseif (cmpstr(inst,"ucpc") == 0)
		
		wave user_nan = cn_ucpc_user_nan
		wave inst_flag = cn_ucpc_inst_flag
		
		wave cpc = UFCN

		cpc_list = cn_ucpc_list

		starti = round(x2pnt(cpc,V_left))
		starti = (starti < 0) ? 0 : starti
		starti = (starti >= numpnts(cpc)) ? numpnts(cpc)-1 : starti
		stopi = round(x2pnt(cpc,V_right))
		stopi = (stopi < 0) ? 0 : stopi
		stopi = (stopi >= numpnts(cpc)) ? numpnts(cpc)-1 : stopi
		
		for (i=starti; i<=stopi; i+=1)	
			wave cpc = $(stringfromlist(inst_flag[i],cpc_list))
//			if (numtype(cpc[i]) == 0 && cpc[i]<nan_threshhold)
			if (numtype(cpc[i]) == 0  && cpc[i] >= V_bottom && cpc[i]<=V_top)
				user_nan[i] = isNaN
			endif
		endfor		

		
	else
		print "unknown instrument: " + inst
		return 0
	endif
	
	cn_reprocess_data(inst)
	
	setdatafolder sdf
end

function cn_set_inst_flag(inst, inst_label)
	string inst
	string inst_label

	GetMarquee/K/Z left, bottom

	string sdf = getdatafolder(1)
	setdatafolder $cn_data_folder
	
	string inst_list = (SelectString((cmpstr(inst,"cpc") != 0),cn_cpc_list,cn_ucpc_list)) 
	wave inst_flag = $(SelectString((cmpstr(inst,"cpc") != 0),"cn_cpc_inst_flag","cn_ucpc_inst_flag")) 
	wave cpc = $(SelectString((cmpstr(inst,"cpc") != 0),"CN_Direct","UFCN")) 
	variable starti, stopi
	starti = round(x2pnt(cpc,V_left))
	starti = (starti < 0) ? 0 : starti
	starti = (starti >= numpnts(cpc)) ? numpnts(cpc)-1 : starti
	stopi = round(x2pnt(cpc,V_right))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi >= numpnts(cpc)) ? numpnts(cpc)-1 : stopi
	
	variable item = cn_get_inst_flag(inst, inst_label)
	if (item >= 0) 
		inst_flag[starti,stopi] = item
	endif
	
	cn_reprocess_data(inst)

	setdatafolder sdf

end

function cn_recalc_cpc_waves()
	cn_reprocess_data("cpc")
	cn_reprocess_data("ucpc")
end

function cn_reprocess_data(inst)
	string inst

	string sdf = getdatafolder(1)
	setdatafolder $cn_data_folder
	
	string inst_list = (SelectString((cmpstr(inst,"cpc") != 0),cn_cpc_list,cn_ucpc_list)) 
	//wave default_inst = $(SelectString((cmpstr(inst,"cpc") == 0),cn_default_cpc_inst,cn_default_ucpc_inst)) 
	wave default_inst = $(SelectString((cmpstr(inst,"cpc") != 0),cn_default_cpc_inst,cn_default_ucpc_inst)) 
	variable default_inst_flag = cn_get_inst_flag(inst, "default")
	wave default_inst = $(stringfromlist(default_inst_flag,inst_list)) 
	wave user_nan = $(SelectString((cmpstr(inst,"cpc") != 0),"cn_cpc_user_nan","cn_ucpc_user_nan")) 
	wave inst_flag = $(SelectString((cmpstr(inst,"cpc") != 0),"cn_cpc_inst_flag","cn_ucpc_inst_flag")) 
	
	if (cmpstr(inst,"cpc")==0)
		duplicate/o default_inst best_cn
	elseif (cmpstr(inst,"ucpc")==0)
		duplicate/o default_inst best_ufcn
	endif
	wave best = $(SelectString((cmpstr(inst,"cpc") != 0),"best_cn","best_ufcn")) 
	wave dt = cn_datetime
	
	SetScale/P x dt[0],1,"dat", best
	
	// use the best data from all available instruments
	variable i
	variable non_def_factor = 1.0
	for (i=0; i<numpnts(inst_flag); i+=1)
//		if (inst_flag[i] != default_inst_flag) 
			wave cpc = $(stringfromlist(inst_flag[i],inst_list))
			if (cmpstr(inst, "cpc")==0)
				variable dir_flag = cn_get_inst_flag(inst, "CN_Direct")
				non_def_factor = 1.0
				if (inst_flag[i] == 0)
					non_def_factor = 0.85 // atomic leg 1
				endif
			elseif (cmpstr(inst,"ucpc")==0)
				//non_def_factor = 1.5  // why do I do this?
//				non_def_factor = 1.08
				non_def_factor = 1.0  // why do I do this?
			endif
			best[i] = cpc[i] * non_def_factor
//		endif
	endfor
	
	if (cn_auto_include_PFW && acg_project_is_set())
		// if ProjectInfo is set, clean with ProjectFlag
		//pfw_filter_wave(best, "SEASWEEP",0, 1)
		pfw_filter_wave(best, "SEASWEEP",nameofwave(best), 1, subfld="SEASWEEP")
	endif	
	
	// NaN the wave
	best = (user_nan[p] == 1) ? NaN : best[p]
	
	if (cn_auto_include_PFW && acg_project_is_set())
		// if ProjectInfo is set, clean with ProjectFlag
		//pfw_filter_wave(best, "NORMAL",0, 1)
		pfw_filter_wave(best, "AMBIENT",nameofwave(best), 1, subfld="AMBIENT")
	endif	
	
	setdatafolder sdf
	
end

Function cn_write_best_data()

	variable refNum 
	
	string prefex = "root:cn:project_tb_60:"
	
	Open/D refNum 
	string outfile_name = S_filename
	
	wave dt = root:cn:avg_60:date_time
	wave cn = root:cn:avg_60:best_cn
	wave ufcn = root:cn:avg_60:best_ufcn
	
	
	variable i
	for (i=0; i<numpnts(dt); i+=1)
		string dt_str = secs2date(dt[i], -2) + secs2time(dt[i], 3)
	endfor
End

Window bestCN_Graph() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:cn:
	Display /W=(45.75,70.25,648.75,410.75) best_cn as "bestCN Edit Graph"
	AppendToGraph/L=left2 CN_Direct,CN_stack
	SetDataFolder fldrSav0
	ModifyGraph lSize(best_cn)=2
	ModifyGraph rgb(CN_stack)=(0,39168,0)
	ModifyGraph lblPos(left)=42,lblPos(left2)=42
	ModifyGraph freePos(left2)=0
	ModifyGraph axisEnab(left)={0.5,1}
	ModifyGraph axisEnab(left2)={0,0.45}
	ModifyGraph dateInfo(bottom)={0,0,0}
	Legend/N=text0/J/A=MC/X=44.51/Y=37.03 "\\s(best_cn) best_cn\r\\s(CN_Direct) CN_Direct\r\\s(CN_stack) CN_stack"
EndMacro

Window bestUFCN_Graph() : Graph
	PauseUpdate; Silent 1		// building window...
	String fldrSav0= GetDataFolder(1)
	SetDataFolder root:cn:
	Display /W=(46.5,265.25,646.5,605) best_ufcn as "bestUFCN Edit Graph"
	AppendToGraph/L=left2 UFCN,WCPC
	SetDataFolder fldrSav0
	ModifyGraph lSize(best_ufcn)=2
	ModifyGraph rgb(WCPC)=(0,12800,52224)
	ModifyGraph lblPos(left)=42,lblPos(left2)=42
	ModifyGraph freePos(left2)=0
	ModifyGraph axisEnab(left)={0.55,1}
	ModifyGraph axisEnab(left2)={0,0.45}
	ModifyGraph dateInfo(bottom)={0,0,0}
	Legend/N=text0/J/A=MC/X=41.63/Y=40.11 "\\s(best_ufcn) best_ufcn\r\\s(UFCN) UFCN\r\\s(WCPC) WCPC"
EndMacro

function cn_calc_fast_dist()

	string sdf = getdatafolder(1)
	setdatafolder $cn_data_folder
	
	newdatafolder/o/s :fast_sizing
	
	duplicate/o ::cn_datetime cn_datetime
	wave dt = cn_datetime
	
	wave cn_stack = ::CN_stack
	wave cn_direct2= ::CN_Direct2
	wave cn_direct = ::CN_Direct
	wave cn_water = ::WCPC
	wave cn_ultrafine = ::UFCN
	
//	duplicate/o cn_stack diff_uf_stack, diff_direct_stack, diff_direct2_stack
	duplicate/o cn_stack diff_uf_direct, diff_direct_direct2, diff_direct2_stack
//	duplicate/o cn_stack ratio_uf_stack, ratio_direct_stack, ratio_direct2_stack
	duplicate/o cn_stack ratio_uf_stack, ratio_direct_stack, ratio_direct2_stack
	
	wave diff1 = diff_uf_direct
	wave diff2 = diff_direct_direct2
	wave diff3 = diff_direct2_stack

	wave ratio1 = ratio_uf_stack
	wave ratio2 = ratio_direct_stack
	wave ratio3 = ratio_direct2_stack
	
	diff1 = cn_ultrafine - cn_direct
	diff1 = (diff1[p] < 0 ) ? nan : diff1[p]
	ratio1 = cn_ultrafine/cn_stack

	diff2 = cn_direct - cn_direct2
	ratio2 = cn_direct/cn_stack
	diff2 = (diff2[p] < 0 ) ? nan : diff2[p]

	diff3 = cn_direct2 - cn_stack
	ratio3 = cn_direct2/cn_stack
	diff3 = (diff3[p] < 0 ) ? nan : diff3[p]
	
	setdatafolder sdf
End
	
Function cn_combine_legs()

	string leg_cn_list = "best_cn;best_ufcn"
	string final_cn_list = "cn;ufcn"

//	variable listi
//	for (listi=0; listi<itemsinlist(final_cn_list); listi+=1)
//		leg_cn_name = stringfromlist(listi,leg_cn_list)
//		final_cn_name = stringfromlist(listi,final_cn_list)
		
	// leg1
	wave leg1_dt = root:cn_leg1:date_time
	wave leg1_cn = root:cn_leg1:best_cn
	wave leg1_ufcn = root:cn_leg1:best_ufcn
	wave leg1_lat = root:cn_leg1:Latitude
	wave leg1_lon = root:cn_leg1:Longitude
	
	// leg2
	wave leg2_dt = root:cn_leg2:date_time
	wave leg2_cn = root:cn_leg2:best_cn
	wave leg2_ufcn = root:cn_leg2:best_ufcn
	wave leg2_lat = root:cn_leg2:Latitude
	wave leg2_lon = root:cn_leg2:Longitude

	setdatafolder root:cn
	
	variable first_dt = wavemin(leg1_dt)
	variable last_dt = wavemax(leg2_dt)
	variable total_pnts = (last_dt-first_dt)/60 + 1
	
	make/d/o/n=(total_pnts) $("cn_datetime")
	wave dt = $("cn_datetime")
	
	dt[0] = first_dt
	dt[1,] = dt[p-1]+60
	
	make/o/n=(numpnts(dt)) $("cn")
	wave cn = $("cn")
	
	make/o/n=(numpnts(dt)) $("ufcn")
	wave ufcn = $("ufcn")

	make/o/n=(numpnts(dt)) $("Latitude")
	wave lat = $("Latitude")

	make/o/n=(numpnts(dt)) $("Longitude")
	wave lon = $("Longitude")
	
	variable i
	for (i=0; i<numpnts(dt); i+=1)
		variable leg_index = binarysearch(leg1_dt, dt[i])
		if (leg_index >= 0)
			cn[i] = leg1_cn[leg_index]
			ufcn[i] = leg1_ufcn[leg_index]
			lat[i] = leg1_lat[leg_index]
			lon[i] = leg1_lon[leg_index]
			continue
		endif
		leg_index = binarysearch(leg2_dt, dt[i])
		if (leg_index >= 0)
			cn[i] = leg2_cn[leg_index]
			ufcn[i] = leg2_ufcn[leg_index]
			lat[i] = leg2_lat[leg_index]
			lon[i] = leg2_lon[leg_index]
		endif
	endfor
	
	SetScale/P x dt[0],60,"dat", cn
	SetScale/P x dt[0],60,"dat", ufcn
	SetScale/P x dt[0],60,"dat", lat
	SetScale/P x dt[0],60,"dat", lon
				
End