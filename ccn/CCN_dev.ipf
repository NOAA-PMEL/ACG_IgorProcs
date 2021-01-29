#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#pragma ModuleName = CCN_DEV

static strconstant namespace = "ccn_dev"

static constant ccn_dev_version=3.2
//static strconstant namespace = "ccn_dev"

// --- Changes from 3.x to3.2 --- 21 May 2018 
//  	- Change to make cleaning NaNs persist when making new ss_waves


strconstant ccn_config_folder = ":config"



Menu "GraphMarquee", dynamic
	"-"
//	"CCN mono: add selection to avg", ccn_add_sel_to_avg_from_marq()
//	"CCN mono: remove selection from avg", ccn_rem_sel_from_avg_from_marq()
////	submenu "CCN mono: set cn offset"
////		"custom", ccn_set_mono_cn_offset_marquee(0,isCustom=1)
////		"minus 10", ccn_set_mono_cn_offset_marquee(-10)
////		"minus 9", ccn_set_mono_cn_offset_marquee(-9)
////		"minus 9", ccn_set_mono_cn_offset_marquee(-8)
////		"minus 7", ccn_set_mono_cn_offset_marquee(-7)
////		"minus 6", ccn_set_mono_cn_offset_marquee(-6)
////		"minus 5", ccn_set_mono_cn_offset_marquee(-5)
////		"minus 4", ccn_set_mono_cn_offset_marquee(-4)
////		"minus 3", ccn_set_mono_cn_offset_marquee(-3)
////		"minus 2", ccn_set_mono_cn_offset_marquee(-2)
////		"minus 1", ccn_set_mono_cn_offset_marquee(-1)
////		"0", ccn_set_mono_cn_offset_marquee(0)
////		"1", ccn_set_mono_cn_offset_marquee(1)
////		"2", ccn_set_mono_cn_offset_marquee(2)
////		"3", ccn_set_mono_cn_offset_marquee(3)
////		"4", ccn_set_mono_cn_offset_marquee(4)
////		"5", ccn_set_mono_cn_offset_marquee(5)
////		"6", ccn_set_mono_cn_offset_marquee(6)
////		"7", ccn_set_mono_cn_offset_marquee(7)
////		"8", ccn_set_mono_cn_offset_marquee(8)
////		"9", ccn_set_mono_cn_offset_marquee(9)
////		"10", ccn_set_mono_cn_offset_marquee(10)
////	end
//	submenu "CCN mono: dp_v_ss_wave"
//		"NaN",ccn_toggle_dp_v_ss_nan_marquee(1)
//		"Reset",ccn_toggle_dp_v_ss_nan_marquee(0)
//	end
//	submenu "CCN spectra: ss_wave"
//		"NaN",ccn_spectra_toggle_ss_nan_marq(1)
//		"Reset",ccn_spectra_toggle_ss_nan_marq(0)
//	end
//	submenu "CCN kappa: ss_wave"
//		"NaN",ccn_kappa_toggle_ss_nan_marq(1)
//		"Reset",ccn_kappa_toggle_ss_nan_marq(0)
//	end
//	
//	
//
//	"-"
	submenu "CCN: set sample type DEV"
		ccn_get_samp_type_list_dev(),/Q,ccn_set_sample_type_marquee_dev()
	end
	submenu "CCN: sample flag DEV"
		submenu "add flag"
			ccn_get_flag_list_dev(),/Q,ccn_toggle_flag_marquee_dev(1)
		end
		submenu "remove flag"
			ccn_get_flag_list_dev(),/Q,ccn_toggle_flag_marquee_dev(0)
		end
	end
	
//	"PILS-IC: reset selection", pils_reset_sel_from_marquee()
//	"PILS-IC: mark selection as blank", pils_mark_blank_from_marquee()
//	"PILS-IC: unmark selection as blank", pils_unmark_blank_from_marquee()
End

Function ccn_init_all([force])
	string force // "true", "false"
	
	variable force_init = 0	
	if (!ParamIsDefault(force)) // force only if "true" or "yes"
		if (cmpstr(force,"true")==0 || cmpstr(force,"yes")==0)
			force_init = 1
		endif
	else
		force = "false"
	endif

	ccn_init_config(force=force)
End

Function/s ccn_goto_config([config_type])
	string config_type

//	ccn_init_config() // will not clear types if already initialized
	
	string sdf = ccn_goto_ccn_folder()
	//newdatafolder/o/s :config
	newdatafolder/o/s $ccn_config_folder
	
	if (!ParamIsDefault(config_type)) 
		if (datafolderexists(config_type))
			setdatafolder $(":"+config_type)
		endif
	endif
	
	return sdf
End

Function ccn_init_config([force])
	string force // "true", "false"
	
	variable force_init = 0	
	if (!ParamIsDefault(force)) // force only if "true" or "yes"
		if (cmpstr(force,"true")==0 || cmpstr(force,"yes")==0)
			force_init = 1
		endif
	endif
	
	string sdf = ccn_goto_ccn_folder()
	newdatafolder/o/s $ccn_config_folder
	
	if (!exists("config_is_set"))
		variable/G config_is_set = 0
	endif
	NVAR config_set = config_is_set
	
	if (force_init)
		config_set = 0
	endif

	if (!config_set) // do initial config
		// config constants
		// config sample_types
		ccn_init_sample_types()
		// config flags
		ccn_init_flags()
		
		config_set = 1
	endif
	
	setdatafolder sdf
End

Function ccn_init_sample_types()
	string sdf = ccn_goto_config()
	newdatafolder/o/s sample_type
	make/T/O/n=0 sample_types
	
	ccn_update_sample_type_dev("BAD")
	ccn_update_sample_type_dev("NORMAL")

	setdatafolder sdf
End

Function ccn_update_sample_type_dev(name,[active])
	string name
	variable active
		
	string sdf = ccn_goto_config(config_type="sample_type")
	wave/T stypes = sample_types
	
	variable update_active = 0
	if (!ParamIsDefault(active))
		update_active = 1
	else
		active = 1 // init to active
	endif

	string result = ccn_check_entry_by_name(stypes,name)
	string entry = ""
	
	if (numberbykey("found",result))
		if (update_active)
			variable index = numberbykey("index",result)
			entry = stypes[index]
			entry = replacenumberbykey("active",entry,active)
			stypes[index] = entry
		endif
	else // add new entry
	
		variable id = ccn_get_unique_id(stypes)
		
		entry = ""
		entry = replacestringbykey("name", entry,name)
		entry = replacenumberbykey("id", entry, id)
		entry = replacenumberbykey("active", entry, active)
		
		variable rows = numpnts(stypes)
		redimension/N=(rows+1) stypes
		stypes[rows] = entry
	endif
	
	setdatafolder sdf
	
	ccn_create_cheat_sheet()
	
End

Function ccn_init_flags()
	string sdf = ccn_goto_config()
	newdatafolder/o/s flag
	make/T/O/n=0 flags
	
	ccn_update_flag_dev("NO_FLAGS")
	
	//ccn_update_flag_dev("TH_DENUDER")
	ccn_update_flag_dev("TH_DENUDER",state_list="UNHEATED;HEATED")
	//ccn_update_flag_dev("NORMAL")

	setdatafolder sdf
End

Function ccn_update_flag_dev(name,[active,state_list]) // don't think we need active but will leave it in
	string name
	variable active
	//variable has_state
	string state_list
			
	string sdf = ccn_goto_config(config_type="flag")
	wave/T flgs = flags
	
	variable update_state = 0
//	if (!ParamIsDefault(has_state))
//		update_state = 1
//	endif

	variable has_state = 0
	if (!ParamIsDefault(state_list))
		if (itemsinlist(state_list) > 1) // number of states need to be 2 or more or just regular flag
			has_state = 1
		endif
		update_state = 1
	endif

	variable update_active = 0
	if (!ParamIsDefault(active))
		update_active = 1
	else
		active = 1 // init to active
	endif

	string result = ccn_check_entry_by_name(flgs,name)
	string entry = ""
	
	if (numberbykey("found",result))


		if (update_active)
			variable index = numberbykey("index",result)
			entry = flgs[index]
			entry = replacenumberbykey("active",entry,active)
			flgs[index] = entry
		endif
		
		if (update_state)
			index = numberbykey("index",result)
			entry = flgs[index]
			entry = replacenumberbykey("has_state",entry,has_state)
			entry = replacenumberbykey("state_count",entry,itemsinlist(state_list))
			// convert list delimiters to work with map
			state_list = replacestring(";",state_list,"%")
			entry = replacestringbykey("state_list",entry,state_list)
			flgs[index] = entry
		endif

	else // add new entry
	
		variable id = ccn_get_unique_id(flgs)
		
		entry = ""
		entry = replacestringbykey("name", entry,name)
		entry = replacenumberbykey("id", entry, id)
		entry = replacenumberbykey("active", entry, active)

		if (update_active)
			entry = replacenumberbykey("active",entry,active)
		endif
		
		if (update_state)
			entry = replacenumberbykey("has_state",entry,has_state)
			entry = replacenumberbykey("state_count",entry,itemsinlist(state_list))
			// convert list delimiters to work with map
			state_list = replacestring(";",state_list,"%")
			entry = replacestringbykey("state_list",entry,state_list)
		endif
		
		variable rows = numpnts(flgs)
		redimension/N=(rows+1) flgs
		flgs[rows] = entry
	endif
	
	setdatafolder sdf
	
	ccn_create_cheat_sheet()
	
End

Function/WAVE ccn_get_config(config_type)
	string config_type
	
	string sdf = ccn_goto_config(config_type=config_type)
	
	if (cmpstr("sample_type",config_type)==0)
		wave/T result = $("sample_types")
		setdatafolder sdf
		return result
	elseif (cmpstr("flag",config_type)==0)
		wave/T result = $("flags")
		setdatafolder sdf
		return result
	endif
	wave/T result = $""
	setdatafolder sdf
	return result
End

Function ccn_get_id_by_name(data,name)
	wave/T data
	string name
	
	string entry = ccn_get_entry(data,name=name)
	if (cmpstr(entry,"")==0)
		return -1 // not a vaild name
	endif
	return numberbykey("id",entry)
End

Function/S ccn_get_state_list_by_name(data,name)
	wave/T data
	string name
	
	string entry = ccn_get_entry(data,name=name)
	if (cmpstr(entry,"")==0)
		return "" // not a vaild name
	endif
	string state_list = stringbykey("state_list",entry)
//	state_list = replacestring("%",state_list,";") // convert back to standard list
	return ccn_get_state_list(entry)
End

Function/S ccn_get_state_list(flag_entry)
	string flag_entry

	string state_list = stringbykey("state_list",flag_entry)
	state_list = replacestring("%",state_list,";") // convert back to standard list
	return state_list
End

Function/S ccn_convert_list_to_map(list)
	string list
	
	 list = replacestring(";",list,"%")
	
	return list
End	

Function/S ccn_convert_list_from_map(list)
	string list
	
	 list = replacestring("%",list,";")
	
	return list
End	

Function/S ccn_get_name_by_id(data,id)
	wave/T data
	variable id
	
	string entry = ccn_get_entry(data,id=id)
	if (cmpstr(entry,"")==0)
		return "" // not a vaild name
	endif
	return stringbykey("name",entry)
End

Function/S ccn_get_entry_by_config(config_type,[name,id])
	string config_type
	string name
	variable id

	wave/T config = ccn_get_config(config_type)

	if (!ParamIsDefault(name))
		return ccn_get_entry(config,name=name)
	elseif (!ParamIsDefault(id))
		return ccn_get_entry(config,id=id)
	endif
	
	return ""
	
End

// Retrieve entry from specified config data
//	specify a name or an id. If both are specified, name will be used
//     if neither are specified an empty string is returned
Function/S ccn_get_entry(data,[name,id])
	wave/T data
	string name
	variable id
	
	variable use_name = 0
	if (!ParamIsDefault(name))
		use_name = 1		
	endif

	variable use_id = 0
	if (!ParamIsDefault(id))
		use_id = 1		
	endif
	
	variable row
	
	if (use_name)
		for (row=0; row<numpnts(data); row+=1)
			if (cmpstr(name,stringbykey("name",data[row]))==0)
				return data[row]
			endif
		endfor
	elseif (use_id)
		for (row=0; row<numpnts(data); row+=1)
			if (id == numberbykey("id",data[row]))
				return data[row]
			endif
		endfor
	endif
	
	// not found or poorly specified
	return ""
End

Function/S ccn_check_entry_by_name(sdata,name)
	wave/T sdata
	string name
	
	// init with "not found" version
	string result = replacenumberbykey("found","",0)
	
	variable i
	for (i=0; i<numpnts(sdata); i+=1)
		string n = stringbykey("name",sdata[i])
		if (cmpstr(name,n) == 0)
			variable id = numberbykey("id",sdata[i])
			result= replacenumberbykey("found",result,1)
			result = replacenumberbykey("id",result,id)
			result = replacenumberbykey("index",result,i)
			return result
		endif
	endfor
	
	return result	
	
End

Function ccn_get_unique_id(sdata)
	wave/T sdata
	
	variable i
	variable last = -1
	for (i=0; i<numpnts(sdata); i+=1)
		variable id = numberbykey("id",sdata[i])
		if (id > last)
			last = id
		endif
	endfor
	return last + 1
End

Function ccn_bulk_add_sample_types(sample_type_list)
	string sample_type_list
	
	variable i
	for (i=0; i<itemsinlist(sample_type_list); i+=1)
		string stype = stringfromlist(i,sample_type_list)
		ccn_update_sample_type_dev(stype)
	endfor
	
End

Function/S ccn_get_samp_type_list_dev([ignore_defaults,ignore_list])
	string ignore_defaults  // if "true/yes" will remove BAD and NORMAL from list
	string ignore_list
	
	string sdf = ccn_goto_config(config_type="sample_type")
	wave/T stypes= sample_types
	
	string list = ccn_get_stringlist(stypes,"name")

	if (ParamIsDefault(ignore_list))
		ignore_list = ""
	endif
	
	if (!ParamIsDefault(ignore_defaults))
		if (cmpstr(ignore_defaults,"true") == 0 || cmpstr(ignore_defaults,"yes")==0)
			//list = removelistitem(0,list)
			//list = removelistitem(0,list) // remove first 2 items BAD,NORMAL
			if (whichlistitem("BAD",ignore_list) < 0)
				ignore_list = addlistitem("BAD",ignore_list)
			endif
			if (whichlistitem("NORMAL",ignore_list) < 0)
				ignore_list = addlistitem("NORMAL",ignore_list)
			endif
		endif
	endif
	
	variable listi
	for (listi=0; listi<itemsinlist(ignore_list); listi+=1)
		list = removefromlist(stringfromlist(listi,ignore_list),list)
	endfor
	
	setdatafolder sdf
	return list
End

Function/S ccn_get_flag_list_dev()
	
	string sdf = ccn_goto_config(config_type="flag")
	wave/T flgs= flags
	
	string list = ccn_get_stringlist(flgs,"name")
	list = removelistitem(0,list)
	
	setdatafolder sdf
	return list
End

	
Function/S ccn_get_stringlist(data,param)
	wave/T data
	string param
	
	string list = ""
	
	variable i	
	for (i=0; i<numpnts(data); i+=1)
		if (numberbykey("active",data[i]))
			// check mark added
			//list = addlistitem((stringbykey("name",data[i])+"!"+num2char(18)), list,";",Inf)
			list = addlistitem(stringbykey("name",data[i]), list,";",Inf)
		endif
	endfor
	return list
End

Function ccn_set_sample_type_marquee_dev()
	
	GetLastUserMenuInfo
	string stype = S_value
	
	//dfref dfr = GetDataFolderDFR()
	//setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	
	GetMarquee/Z bottom
	wave dt= ccn_datetime
	
//	print BinarySearchInterp(avg_dt,V_left)
//	print BinarySearchInterp(avg_dt,V_right)
	variable starti = round(BinarySearchInterp(dt,V_left))
	starti = (numtype(starti)>0) ? 0 : starti
	variable stopi = round(BinarySearchInterp(dt,V_right))
	stopi = (numtype(stopi)>0) ? numpnts(dt)-1 : stopi
	wave/T type = ccn_sample_type_dev
	type[starti,stopi] = stype
	
//	ccn_generate_samp_type_index(0)
	ccn_update_sample_info_index(config_type="sample_type")
	
	setdatafolder sdf
End

Function ccn_toggle_flag_marquee_dev(set_flag)
	variable set_flag
	
	GetLastUserMenuInfo
	string stype = S_value
	
	//dfref dfr = GetDataFolderDFR()
	//setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	
	GetMarquee/Z bottom
	wave dt= ccn_datetime
	
//	print BinarySearchInterp(avg_dt,V_left)
//	print BinarySearchInterp(avg_dt,V_right)
	variable starti = round(BinarySearchInterp(dt,V_left))
	starti = (numtype(starti)>0) ? 0 : starti
	variable stopi = round(BinarySearchInterp(dt,V_right))
	stopi = (numtype(stopi)>0) ? numpnts(dt)-1 : stopi
	//wave/T type = ccn_flag_dev
	//type[starti,stopi] = stype
	ccn_toggle_flag(starti,stopi,stype,set_flag)
	
//	ccn_generate_samp_type_index(0)
	ccn_update_sample_info_index(config_type="flag")
	
	setdatafolder sdf

End

Function ccn_toggle_flag(start_index, stop_index, flag_name, set_flag)
	variable start_index
	variable stop_index
	string flag_name
	variable set_flag // 0=remove, 1=set

	string sdf = ccn_goto_ccn_folder()
	wave/T flags = ccn_flag_dev
	variable row
	for (row=start_index; row<=stop_index; row+=1)
		variable item = whichlistitem(flag_name,flags[row])
		if (set_flag == 1)
			if (item<0)
				flags[row] = addlistitem(flag_name,flags[row],";",Inf)
			endif
		else
			if (item > -1)
				flags[row] = removelistitem(item,flags[row])
			endif
		endif
	endfor
	
	setdatafolder sdf
End

Function ccn_init_sample_info_waves([force])
	string force 
	
	if (ParamIsDefault(force))
		force = "false"
	endif
	
	string sdf = ccn_goto_ccn_folder()

	wave dt = ccn_datetime
	
	// init sample_types
	if (!waveexists($"ccn_sample_type_dev") || cmpstr(force,"true")==0)
		make/O/T/o/n=(numpnts(dt)) ccn_sample_type_dev
		wave/T type = ccn_sample_type_dev
		type = "NORMAL" // init all to NORMAL

		ccn_update_sample_info_index(config_type="sample_type",force="true")
	endif
	
	// init sample_types
	if (!waveexists($"ccn_flag_dev") || cmpstr(force,"true")==0)
		make/O/T/n=(numpnts(dt)) ccn_flag_dev
		wave/T flag = ccn_flag_dev
		flag = "" // init all to empty

		ccn_update_sample_info_index(config_type="flag",force="true")
	endif
		
		
	setdatafolder sdf

End


Function ccn_update_sample_info_index([config_type, force])
	string config_type
	string force

	string index_list = ""
	if (ParamIsDefault(config_type))
		index_list = "sample_type;flag"
	else
		index_list = config_type
	endif
	
	variable force_update = 0
	if (!ParamIsDefault(force))
		if (cmpstr(force,"true")==0 || cmpstr(force,"yes")==0)
			force_update = 1
		endif
	endif

	string sdf = ccn_goto_ccn_folder()
	wave dt = ccn_datetime
		
	variable listi
	for (listi=0; listi<itemsinlist(index_list); listi+=1)
		
		newdatafolder/o/s run_config
		config_type = stringfromlist(listi,index_list)
		wave/T config = ccn_get_config(config_type)
		
		if (cmpstr("sample_type",stringfromlist(listi,index_list))==0) // sample_type
			
			if (!waveexists($"ccn_sample_type_index") || force_update)
				make/o/n=(numpnts(dt)) ccn_sample_type_index
				wave tmp = ccn_sample_type_index
				SetScale/P x dt[0],ccn_avg_period,"dat", tmp
			endif
			
			wave index = ccn_sample_type_index
			wave/T types = ::ccn_sample_type_dev
			
			
			variable row
			for (row=0; row<numpnts(types); row+=1)
				index[row] = ccn_get_id_by_name(config,types[row])
			endfor
			
			setdatafolder ::
			
		elseif (cmpstr("flag",stringfromlist(listi,index_list))==0) // flag
			
			string flag_list = ccn_get_flag_list_dev()
			
			variable flagi
			for (flagi=0; flagi<itemsinlist(flag_list); flagi+=1)
				string flag_name = stringfromlist(flagi,flag_list)
				
				string entry = ccn_get_entry(config,name=flag_name)
				if (cmpstr(entry,"") == 0)
					continue
				endif
				
				string wname = "ccn_flag_"+stringbykey("id",entry)+"_index"
				if (!waveexists($wname) || force_update)
					if (numberbykey("has_state",entry))
						make/o/n=(numpnts(dt),numberbykey("state_count",entry)) $wname
					else
						make/o/n=(numpnts(dt)) $wname
					endif
					wave tmp = $wname
					SetScale/P x dt[0],ccn_avg_period,"dat", tmp
					tmp = NaN
				endif
			
				wave index = $wname
				wave/T flags = ::ccn_flag_dev
				
				for (row=0; row<numpnts(flags); row+=1)

					//string flag_list = flags[row]
					//variable listi
					//for (listi=0; listi<itemsinlist(flag_list); listi+=1)
						variable is_set = ccn_flag_is_set(flag_name,row)
						if (numberbykey("has_state",entry))  // handle state flags specially
							ccn_update_state_flag_index(row,dt,entry,index,is_set)
						else // update 1d flags normally
							index[row] = (is_set) ? ccn_get_id_by_name(config,flag_name) : NaN
						endif				
					//endfor
				endfor
		
			endfor
			
			setdatafolder ::
		
		endif
		
		
	endfor
	
	setdatafolder sdf
End

Function ccn_flag_is_set(flag_name,index)
	string flag_name
	variable index
	
	if (stringmatch(flag_name, "*[*") && stringmatch(flag_name, "*]"))
		return ccn_flag_state_is_set(flag_name, index)
	else
		string sdf = ccn_goto_ccn_folder()
		wave/T flags = ccn_flag_dev
		variable result = 0
		if(whichlistitem(flag_name,flags[index]) > -1)
			// if flag_name contains "[" && "]"
			result = 1
		endif
		setdatafolder sdf
		return result
	endif
End

Function ccn_flag_state_is_set(flag_name, index)
	string flag_name
	variable index
	
	// parse flag_name
	flag_name = replacestring("]", flag_name, "[")
	string flag = stringfromlist(0, flag_name, "[")
	string state = stringfromlist(1, flag_name, "[")

	if (ccn_flag_is_set(flag, index))
		wave/T def = ccn_get_config("flag")
		string entry = ccn_get_entry(def,name=flag)
		variable id = numberbykey("id",entry)

		string states = ccn_get_state_list(entry)
		variable state_col = whichlistitem(state, states)
			
		string sdf = ccn_goto_ccn_folder()
//		wave ccn_dt = ccn_datetime
		setdatafolder :run_config
		wave flag_index = $("ccn_flag_"+num2str(id)+"_index")
		if (numtype(flag_index[index][state_col] )== 0 && flag_index[index][state_col]>0)
			setdatafolder sdf
			return 1
		endif
		setdatafolder sdf	
	endif
	
	return 0
//			if (numberbykey("state_count",entry) > 1)
//				string sdf = ccn_goto_ccn_folder()
//				wave ccn_dt = ccn_datetime
//				setdatafolder :run_config
//				wave flag_index = $("ccn_flag_"+num2str(id)+"_index")
//				variable row = binarysearch(ccn_dt,dt)
//				variable statecol = 0
//				variable col
//				for (col=0; col<(numberbykey("state_count",entry)); col+=1)
//					//print row, col, flag_index[row][col]
//					if (numtype(flag_index[row][col]) == 0)
//						statecol = col
//						break
//					endif
//				endfor
//				
//				setdatafolder sdf
//				wname += "f"+num2str(id)+"_"+num2str(statecol)
//				flist = addlistitem(stringbykey("name",entry) + "[" + stringfromlist(statecol,state_list) + "]", flist, ";",Inf)
	
End

// Use this function to handle special flags that have state (e.g., TH_DENUDER)
Function ccn_update_state_flag_index(row_index,dt,flag_entry,index,flag_set)
	variable row_index
	wave dt
	string flag_entry // definition
	wave index
	variable flag_set // 0 or 1 if flag is set
	
	string flag_name = stringbykey("name",flag_entry)
	
	if (cmpstr("TH_DENUDER",flag_name) == 0)
		
		if (!waveexists($"root:valve:zi_tthdma_valve"))
			return 0
		endif

		// Time range plumbing was switched/wrong
		// for ATOMIC: 2020-02-04 12:00:00 - 2020-02-08 19:50:00
		variable/D start_bad_atomic_dt = date2secs(2020, 2, 4) + 12*60*60
		variable/D stop_bad_atomic_dt = date2secs(2020, 2, 8) + 19*60*60 + 50*60
	
		variable/D start_bad_dl_atomic_dt = date2secs(2020, 2, 7) + 2*60*60 + 4*60
		variable/D stop_bad_dl_atomic_dt = date2secs(2020, 2, 7) + 11*60*60 + 14*60
		
		// use thermal denuder valve to parse
		wave valve = $"root:valve:zi_tthdma_valve"
		variable valve_index = x2pnt(valve,dt[row_index])
		
		if (valve_index > numpnts(valve)-1)
			return 0
		endif

		wave vlv_flag = $"root:valve:valve_flag"
						
		//string states = stringbykey("state_list",flag_entry)
		string states = ccn_get_state_list(flag_entry)
		variable U_col, H_col
		U_col = whichlistitem("UNHEATED",states)
		H_col = whichlistitem("HEATED",states)
		
		variable id = (flag_set) ? numberbykey("id",flag_entry) : NaN
		if (dt[row_index] >= start_bad_atomic_dt && dt[row_index] <= stop_bad_atomic_dt)
//		if ( (dt[row_index] >= start_bad_atomic_dt && dt[row_index]  <= start_bad_dl_atomic_dt) || (dt[row_index]  >= stop_bad_dl_atomic_dt && dt[row_index]  <= stop_bad_atomic_dt))

			if (valve[valve_index] < 2.5)
				index[row_index][U_col] = id
				index[row_index][H_col] = NaN
			else			
				index[row_index][U_col] = NaN
				index[row_index][H_col] = id
			endif
		else
		
			if (valve[valve_index] > 2.5)
				index[row_index][U_col] = id
				index[row_index][H_col] = NaN
			else			
				index[row_index][U_col] = NaN
				index[row_index][H_col] = id
			endif

		endif

		// NaN elements during transition
		if (!vlv_flag[valve_index])
			index[row_index][U_col] = NaN
			index[row_index][H_col] = NaN
		endif

	endif
	
//	killwaves/Z vlv_flag
	
End

Function ccn_mono_avg_matrix(output_name,samp_type_list,[normalize])
	string output_name // base name for output wave (should be short)
	string samp_type_list // sample type list
	string normalize // use normalized matrix

	if (ParamIsDefault(normalize))
		normalize = "no"
	endif

	string param_list = "ccn_conc;cn_conc;ccn_cn_ratio"
	variable pari
	for (pari=0; pari<itemsinlist(param_list); pari+=1)
		ccn_mono_avg_matrix_param(stringfromlist(pari,param_list),output_name,samp_type_list,normalize=normalize)
	endfor
End

Function ccn_mono_avg_matrix_param(param,output_name,samp_type_list,[normalize])
	string param // parameter to average: cn, ccn, ccn_cn_ratio
	string output_name // base name for output wave (should be short)
	string samp_type_list // sample type list
	string normalize // use normalized matrix
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss
	
//	if (ParamIsDefault(samp_type_list))
//		samp_type_list = ""
//	endif
		
	variable doNormalize = 0
	string fldr_prefix = ""
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
		fldr_prefix = ":normalize"
	endif

	if (doNormalize)
		setdatafolder $fldr_prefix
	endif
	
	variable listi

	// find list of waves meeting criteria
//	string wlist = acg_get_wave_list(filter=(param+"_st_*")) // get list of all param waves
//	string sdlist = replacestring("_st_",wlist,"_sd_st_",1)
	//string sdlist = acg_get_wave_list(filter=(param+"_sd_st_*")) // get list of all sd waves
	string avg_list = ""
	string sd_list = ""
//	for (listi=0; listi<itemsinlist(wlist); listi+=1)
//		wave w = $(stringfromlist(listi,wlist))
//		wn = note(w)
//		string st = stringbykey("sample_type",wn)
//		
//		if ((cmpstr(samp_type_list,"") == 0)
//			 avg_list = wlist
//			 sd_list = sdlist
//		else
//			for (sti=0; sti<itemsinlist(samp_type_list); sti+=1)
//		
//		string fl = ccn_convert_list_from_map(stringbykey("flag_list",wn))
//	endfor
	
	for (listi=0; listi<itemsinlist(samp_type_list); listi+=1)
		string st = stringfromlist(listi,samp_type_list)
		if (waveexists($(param+"_"+st)) && waveexists($(param+"_sd_"+st)))
			avg_list = addlistitem(param+"_"+st,avg_list,";",Inf)
			sd_list = addlistitem(param+"_sd_"+st,sd_list,";",Inf)
		endif
	endfor
	// filter waves for sample type(s)
//	if (cmpstr(samp_type_list,"") == 0) // include all sample types
//		avg_list = wlist
//		sd_list = sdlist
//	else
//		//variable sti
//		//for (sti=0; sti<itemsinlist(samp_type_list); sti+=1)
//		for (listi=0; listi<itemsinlist(wlist); listi+=1)
//			string wname = stringfromlist(listi,wlist)
//			string sdname = stringfromlist(listi,sdlist)
//			wave w = $(wname)
//			string wn = note(w)
//			string st = stringbykey("sample_type",wn)
//		
//			if (findlistitem(st,samp_type_list)>=0)
//				avg_list = addlistitem(wname,avg_list,";",Inf)
//				sd_list = addlistitem(sdname,sd_list,";",Inf)
//			endif
//		endfor
//	endif
			
	// filter waves for sample type(s)
//	if (cmpstr(flag_list,"") == 0) // include all flags
//		//avg_list = wlist
//		//sd_list = sdlist
//	else
//		variable fi
//		for (fi=0; fi<itemsinlist(flag_list); fi+=1)
//			string flag = stringfromlist(fi,flag_list)
//			for (listi=0; listi<itemsinlist(avg_list); listi+=1)
//				wname = stringfromlist(listi,wlist)
//				sdname = stringfromlist(listi,sdlist)
//				wave w = $(wname)
//				wn = note(w)
//				string fl = ccn_convert_list_from_map(stringbykey("flag_list",wn))
//			
//				if (findlistitem(flag,fl)>=0)
//					avg_list = addlistitem(wname,avg_list,";",Inf)
//					sd_list = addlistitem(sdname,sd_list,";",Inf)
//				endif
//			endfor
//		endfor
//	endif
	
	if (itemsinlist(avg_list) <= 0)
		return 0
	endif
	variable rows = dimsize($(stringfromlist(0,avg_list)),0)
	variable cols = dimsize($(stringfromlist(0,avg_list)),1)
	
	// average filtered lists
	newdatafolder/o/s :averages
	make/o/n=(rows,cols) $(param+"_"+output_name)
	wave avg = $(param+"_"+output_name)			
	avg = NaN
	
	make/o/n=(rows,cols) $(param+"_"+output_name+"_sd")
	wave sd = $(param+"_"+output_name+"_sd")
	sd = NaN
	setdatafolder ::
	
	make/o/n=(itemsinlist(avg_list)) avg_tmp
	wave tmp_avg = avg_tmp
	tmp_avg = NaN
	make/o/n=(itemsinlist(avg_list)) sd_tmp
	wave tmp_sd = sd_tmp
	tmp_sd = NaN
	
	variable i,j
	for (i=0; i<rows; i+=1)
		for (j=0; j<cols; j+=1)		

			for (listi=0; listi<itemsinlist(avg_list); listi+=1)
				wave par = $(stringfromlist(listi,avg_list))		
				wave std= $(stringfromlist(listi,sd_list))
				
				if (waveexists(par) && waveexists(std))
					tmp_avg[listi] = par[i][j]		
					tmp_sd[listi] = std[i][j]		
				endif
			endfor
			
			wavestats/Q/Z tmp_avg
			avg[i][j] = V_avg
	
			wavestats/Q/Z tmp_sd
			sd[i][j] = V_avg
			
			tmp_avg = NaN
			tmp_sd = NaN
		endfor
	endfor
	killwaves/Z tmp_avg, tmp_sd
	
	setdatafolder sdf
End


Function dev_mono_avg_matrix(output_name,[samp_type_list,flag_list,normalize])
	string output_name // base name for output wave (should be short)
	string samp_type_list // sample type list
	string flag_list // list of flags
	string normalize // use normalized matrix

	if (ParamIsDefault(normalize))
		normalize = "no"
	endif

	if (ParamIsDefault(samp_type_list))
		samp_type_list = ""
	endif

	if (ParamIsDefault(flag_list))
		flag_list = ""
	endif

	string param_list = "ccn_conc;cn_conc;ccn_cn_ratio"
	variable pari
	for (pari=0; pari<itemsinlist(param_list); pari+=1)
		dev_mono_avg_matrix_param(stringfromlist(pari,param_list),output_name,samp_type_list=samp_type_list,flag_list=flag_list,normalize=normalize)
	endfor
End

Function dev_mono_avg_matrix_param(param,output_name,[samp_type_list,flag_list,normalize])
	string param // parameter to average: cn, ccn, ccn_cn_ratio
	string output_name // base name for output wave (should be short)
	string samp_type_list // sample type list
	string flag_list // list of flags
	string normalize // use normalized matrix
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss
	
	if (ParamIsDefault(samp_type_list))
		samp_type_list = ""
	endif

	if (ParamIsDefault(flag_list))
		flag_list = ""
	endif
		
	variable doNormalize = 0
	string fldr_prefix = ""
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
		fldr_prefix = ":normalize"
	endif

	if (doNormalize)
		setdatafolder $fldr_prefix
	endif
	
	// find list of waves meeting criteria
	string wlist = acg_get_wave_list(filter=(param+"_st_*")) // get list of all param waves
	string sdlist = replacestring("_st_",wlist,"_sd_st_",1)
	//string sdlist = acg_get_wave_list(filter=(param+"_sd_st_*")) // get list of all sd waves
	variable listi
	string avg_list = ""
	string sd_list = ""
//	for (listi=0; listi<itemsinlist(wlist); listi+=1)
//		wave w = $(stringfromlist(listi,wlist))
//		wn = note(w)
//		string st = stringbykey("sample_type",wn)
//		
//		if ((cmpstr(samp_type_list,"") == 0)
//			 avg_list = wlist
//			 sd_list = sdlist
//		else
//			for (sti=0; sti<itemsinlist(samp_type_list); sti+=1)
//		
//		string fl = ccn_convert_list_from_map(stringbykey("flag_list",wn))
//	endfor
	
	// filter waves for sample type(s)
	if (cmpstr(samp_type_list,"") == 0) // include all sample types
		avg_list = wlist
		sd_list = sdlist
	else
		//variable sti
		//for (sti=0; sti<itemsinlist(samp_type_list); sti+=1)
		for (listi=0; listi<itemsinlist(wlist); listi+=1)
			string wname = stringfromlist(listi,wlist)
			string sdname = stringfromlist(listi,sdlist)
			wave w = $(wname)
			string wn = note(w)
			string st = stringbykey("sample_type",wn)
		
			if (findlistitem(st,samp_type_list)>=0)
				avg_list = addlistitem(wname,avg_list,";",Inf)
				sd_list = addlistitem(sdname,sd_list,";",Inf)
			endif
		endfor
	endif
			
	// filter waves for sample type(s)
	if (cmpstr(flag_list,"") == 0) // include all flags
		//avg_list = wlist
		//sd_list = sdlist
	else
		variable fi
		for (fi=0; fi<itemsinlist(flag_list); fi+=1)
			string flag = stringfromlist(fi,flag_list)
			for (listi=0; listi<itemsinlist(avg_list); listi+=1)
				wname = stringfromlist(listi,wlist)
				sdname = stringfromlist(listi,sdlist)
				wave w = $(wname)
				wn = note(w)
				string fl = ccn_convert_list_from_map(stringbykey("flag_list",wn))
			
				if (findlistitem(flag,fl)>=0)
					avg_list = addlistitem(wname,avg_list,";",Inf)
					sd_list = addlistitem(sdname,sd_list,";",Inf)
				endif
			endfor
		endfor
	endif
	
	if (itemsinlist(avg_list) <= 0)
		return 0
	endif
	variable rows = dimsize($(stringfromlist(0,avg_list)),0)
	variable cols = dimsize($(stringfromlist(0,avg_list)),1)
	
	// average filtered lists
	newdatafolder/o/s :averages
	make/o/n=(rows,cols) $(param+"_"+output_name)
	wave avg = $(param+"_"+output_name)			
	avg = NaN
	
	make/o/n=(rows,cols) $(param+"_"+output_name+"_sd")
	wave sd = $(param+"_"+output_name+"_sd")
	sd = NaN
	setdatafolder ::
	
	make/o/n=(itemsinlist(avg_list)) avg_tmp
	wave tmp_avg = avg_tmp
	tmp_avg = NaN
	make/o/n=(itemsinlist(avg_list)) sd_tmp
	wave tmp_sd = sd_tmp
	tmp_sd = NaN
	
	variable i,j
	for (i=0; i<rows; i+=1)
		for (j=0; j<cols; j+=1)		

			for (listi=0; listi<itemsinlist(avg_list); listi+=1)
				wave par = $(stringfromlist(listi,avg_list))		
				wave std= $(stringfromlist(listi,sd_list))
				
				if (waveexists(par) && waveexists(std))
					tmp_avg[listi] = par[i][j]		
					tmp_sd[listi] = std[i][j]		
				endif
			endfor
			
			wavestats/Q/Z tmp_avg
			avg[i][j] = V_avg
	
			wavestats/Q/Z tmp_sd
			sd[i][j] = V_avg
			
			tmp_avg = NaN
			tmp_sd = NaN
		endfor
	endfor
	killwaves/Z tmp_avg, tmp_sd
	
	setdatafolder sdf
End

//Function ccn_spectra_generate_ss_matrix(normalize)
//	variable normalize
// Changed like the mono version...
Function dev_mono_generate_ss_matrix([normalize])
	string normalize

//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss
	

	variable doNormalize = 0
	string fldr_prefix = ""
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
		fldr_prefix = ":normalize"
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
	
//	ccn_get_ss_list_as_wave("ccn_spectra_ss")
//	wave ss = $("ccn_spectra_ss")
//	string ss_list = ccn_mono_ss_list
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
		newdatafolder/o $fldr_prefix
	endif
	
	// redo logic - only create matrix waves for sample_types and flags that have been used
	setdatafolder :data
	string wlist = acg_get_wave_list(filter="!*_dt") // get list of ss_waves without _dt waves
	setdatafolder ::
	
	//  get list of dp values
	ccn_get_dp_list_as_wave("ccn_mono_dp")
	wave dp = $("ccn_mono_dp")
	string dp_list = ccn_mono_dp_list

	// get list of ss values
	ccn_get_ss_list_as_wave("ccn_mono_ss")
	wave ss = $("ccn_mono_ss")
	string ss_list = ccn_mono_ss_list

	variable listi
	for (listi=0; listi<itemsinlist(wlist); listi+=1)
		string ss_wname = stringfromlist(listi,wlist)
		wave ss_data = $(":data:"+ss_wname)
		string meta = note(ss_data)
		
		variable st_id = numberbykey("sample_type_id",meta)
		variable fl_id = numberbykey("flag_list_id",meta)
		
		string par_list = "ccn_conc;cn_conc;ccn_cn_ratio"
		variable pari
		for (pari=0; pari<itemsinlist(par_list); pari+=1)
			
			string par_name = stringfromlist(pari,par_list)
			
			string mat_wname = ""
			string mat_sd_wname = ""
			if (doNormalize)
				mat_wname += fldr_prefix + ":"
				mat_sd_wname += fldr_prefix + ":"
			endif
			mat_wname += par_name+"_st_"+num2str(st_id)+"_fl_"+num2str(fl_id)
			mat_sd_wname += par_name+"_sd_st_"+num2str(st_id)+"_fl_"+num2str(fl_id)

			if ( !waveexists($mat_wname) || dimsize($mat_wname,0) < itemsinlist(ss_list) || dimsize($mat_wname,1) < itemsinlist(dp_list) )
				make/o/n=(itemsinlist(ss_list),itemsinlist(dp_list)) $mat_wname
				wave tmp = $mat_wname
				tmp = NaN
			endif		
			wave par = $mat_wname

			if (!waveexists($mat_sd_wname) || dimsize($mat_sd_wname,0) < itemsinlist(ss_list) || dimsize($mat_sd_wname,1) < itemsinlist(dp_list))
				make/o/n=(itemsinlist(ss_list),itemsinlist(dp_list)) $mat_sd_wname
				wave tmp = $mat_sd_wname
				tmp = NaN
			endif		
			wave par_sd = $mat_sd_wname


			string mat_info = note(par)
			mat_info = replacenumberbykey("sample_type_id",mat_info,st_id)
	 		mat_info = replacestringbykey("sample_type",mat_info,stringbykey("sample_type",meta))
			mat_info = replacenumberbykey("flag_list_id",mat_info,fl_id)
	 		mat_info = replacestringbykey("flag_list",mat_info,stringbykey("flag_list",meta))
	 		mat_info = replacestringbykey("wavename",mat_info,mat_wname)
	 		note/k par
	 		note par, mat_info
			
			
			variable ss_index = whichlistitem(stringbykey("ss",meta),ss_list)
			variable dp_index = whichlistitem(stringbykey("dp",meta),dp_list)
			if (ss_index >= 0 && dp_index >= 0) 
				duplicate/o ss_data, tmp_ss_data
				wave tmp_ss = tmp_ss_data
				ccn_clean_dp_v_ss_wave(tmp_ss)
				
				variable avg,sd
				if (cmpstr(par_name,"ccn_conc") == 0)
					avg = 0
					sd = 1
				elseif (cmpstr(par_name,"cn_conc") == 0)
					avg = 2
					sd = 3
				elseif (cmpstr(par_name,"ccn_cn_ratio") == 0)
					avg = 4
					sd = 5
				endif
				
				par[ss_index][dp_index] = (dimsize(tmp_ss,0) > 0) ? util_matrix_wavestats_col(avg,tmp_ss,"V_avg") : NaN // avg
				par_sd[ss_index][dp_index] = (dimsize(tmp_ss,0) > 0) ? util_matrix_wavestats_col(sd,tmp_ss,"V_avg") : NaN // sd
					
				killwaves/Z tmp_ss
			endif

		endfor
		
	endfor
	
	if (doNormalize)
		setdatafolder $fldr_prefix
	endif
	
	 wlist = acg_get_wave_list(filter="*_st_*") 
	 string ratio_list = ""
	 for (listi=0; listi<itemsinlist(wlist); listi+=1)
	 	
	 	string wname = stringfromlist(listi,wlist)
	 	wave w = $(wname)
	 	wavestats/Q w
	 	if (V_npnts == 0)
	 		killwaves/Z w
	 	else
	 		if (stringmatch(wname,"ccn_cn_ratio_st_*"))
	 			ratio_list = addlistitem(wname,ratio_list,";",Inf)
	 		endif
	 	endif
	 endfor
	 if (doNormalize)
		for (listi=0; listi<itemsinlist(ratio_list); listi+=1)
			wave ratio = $(stringfromlist(listi,ratio_list))
		 	make/o/n=(dimsize(ratio,0)) tmp_w
			wave tw = tmp_w
			variable col
			for (col=0; col<dimsize(ratio,1); col+=1)
				tw = ratio[p][col]
				wavestats/Q tw
				variable rat_max = V_max
				if (rat_max > 0)
					ratio[][col] /= rat_max
				endif
			endfor
			killwaves/Z tw
		endfor
	endif

	
//	wlist = acg_get_wave_list(filter="*st_*")
	
//	variable typ
//	string samp_types=ccn_get_samp_type_list()	
//	string curr_type
//	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
//		string sample_type = stringfromlist(typ,samp_types)
//
//		string suffix
//		if (cmpstr(sample_type,"")==0 || cmpstr(sample_type,"NORMAL")==0)
//			suffix=""
//		elseif (cmpstr(sample_type,"BAD")==0)
//			continue
//		else
//			suffix="_"+sample_type
//		endif
//
//		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
//		make/o/n=(numpnts(ss)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
//		wave ratio = $("ccn_cn_ratio"+suffix)
//		wave ratio_sd = $("ccn_cn_ratio_sd"+suffix)
//		ratio = nan
//		ratio_sd=nan
//		
//		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
//		make/o/n=(numpnts(ss)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
//		wave ccn = $("ccn_conc"+suffix)
//		wave ccn_sd = $("ccn_conc_sd"+suffix)
//		ccn = nan
//		ccn_sd=nan
//		
//		//make/o/n=(numpnts(ss),numpnts(dp)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
//		make/o/n=(numpnts(ss)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
//		wave cn = $("cn_conc"+suffix)
//		wave cn_sd = $("cn_conc_sd"+suffix) 
//		cn = nan
//		cn_sd=nan
//	
//		// get matrix values from data waves
//		variable row,col
//		for (row=0; row<numpnts(ss); row+=1)
//			//for (col=0; col<numpnts(dp); col+=1)
//			string wname = ":data:" + ccn_spectra_generate_ss_name(ss[row])
//			wname+=suffix
//			if (waveexists($wname))
//				wave w_orig = $wname
//				if (dimsize(w_orig,0) > 0)
//					
//					duplicate/o w_orig cgdvs_tmp_w
//					ccn_clean_dp_v_ss_wave(cgdvs_tmp_w)
//					wave w = cgdvs_tmp_w
//					
//					wavestats/Q w
//					
//					ccn[row] = util_matrix_wavestats_col(0,w,"V_avg") // ccn
//					ccn_sd[row] =util_matrix_wavestats_col(1,w,"V_avg") // ccn_sd
//					
//					cn[row] = util_matrix_wavestats_col(2,w,"V_avg") // cn
//					cn_sd[row] =util_matrix_wavestats_col(3,w,"V_avg") // cn_sd
//
//					ratio[row] = util_matrix_wavestats_col(4,w,"V_avg") // ratio
//					ratio_sd[row] =util_matrix_wavestats_col(5,w,"V_avg") // ratio_sd
//
////					util_matrix_wavestats_col(2,w) // cn
////					cn[row][col] = V_avg
////					util_matrix_wavestats_col(3,w) // cn_sd
////					cn_sd[row][col] = V_avg
////
////					util_matrix_wavestats_col(4,w) // cn
////					ratio[row][col] = V_avg
////					util_matrix_wavestats_col(5,w) // cn_sd
////					ratio_sd[row][col] = V_avg
//					
//					killwaves/Z w
//				endif
//			endif
//			//endfor
//		endfor
//		wavestats/Q ratio
//		if (V_npnts==0) // all nans
//			killwaves/Z ratio,ratio_sd,ccn,ccn_sd,cn,cn_sd
//		else		// added 9Dec2014 - copied from mono version
//			// normalize ratio if "normalize=1"
////			if (normalize)
//			if (doNormalize)
//				make/o/n=(dimsize(ratio,0)) tmp_w
//				//for(col=0; col<dimsize(ratio,1); col+=1)
//					//tmp_w = ratio[p][col]
//					tmp_w = ratio[p]
//					wavestats/Q tmp_w
//					variable wmax = V_max
//					if (wmax > 0)
//						tmp_w /= wmax
//						ratio = tmp_w[p]
//					endif
//				//endfor
//				killwaves/Z tmp_w
//			endif
//
//		endif
//	endfor
//
//
//	
////	// generate dp and ss waves for images
////	wave w = $wname
////	wave dp = ccn_mono_dp
////	make/o/n=(numpnts(dp)+1) ccn_mono_dp_im
////	wave dp_im = ccn_mono_dp_im
////	dp_im[0] = dp[0] - ( ((dp[0]+dp[1])/2) - dp[0] ) 
////	dp_im[1,numpnts(dp_im)-2] = (dp[p-1] + dp[p])/2
////	dp_im[numpnts(dp_im)-1] = dp[numpnts(dp)-1] + ( dp[numpnts(dp)-1] - ( (dp[numpnts(dp)-1] + dp[numpnts(dp)-2])/2) )
////	
////	wave ss = ccn_mono_ss
////	make/o/n=(numpnts(ss)+1) ccn_mono_ss_im
////	wave ss_im = ccn_mono_ss_im
////	ss_im[0] = ss[0] - ( ((ss[0]+ss[1])/2) - ss[0] ) 
////	ss_im[1,numpnts(ss_im)-2] = (ss[p-1] + ss[p])/2
////	ss_im[numpnts(ss_im)-1] = ss[numpnts(ss)-1] + ( ss[numpnts(ss)-1] - ( (ss[numpnts(ss)-1] + ss[numpnts(ss)-2])/2) )
//
	
	setdatafolder sdf
//	setdatafolder dfr
End


//Function ccn_spectra_generate_ss_matrix(normalize)
//	variable normalize
// Changed like the mono version...
Function dev_spectra_generate_ss_matrix([normalize])
	string normalize

//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :spectra_ss
	

	variable doNormalize = 0
	string fldr_prefix = ""
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
		fldr_prefix = ":normalize"
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
	
//	ccn_get_ss_list_as_wave("ccn_spectra_ss")
//	wave ss = $("ccn_spectra_ss")
//	string ss_list = ccn_mono_ss_list
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
		newdatafolder/o $fldr_prefix
	endif
	
	// redo logic - only create matrix waves for sample_types and flags that have been used
	setdatafolder :data
	string wlist = acg_get_wave_list(filter="!*_dt") // get list of ss_waves without _dt waves
	setdatafolder ::
	
	// get list of ss values
	ccn_get_ss_list_as_wave("ccn_spectra_ss")
	wave ss = $("ccn_spectra_ss")
	string ss_list = ccn_mono_ss_list

	variable listi
	for (listi=0; listi<itemsinlist(wlist); listi+=1)
		string ss_wname = stringfromlist(listi,wlist)
		wave ss_data = $(":data:"+ss_wname)
		string meta = note(ss_data)
		
		variable st_id = numberbykey("sample_type_id",meta)
		variable fl_id = numberbykey("flag_list_id",meta)
		
		string par_list = "ccn_conc;cn_conc;ccn_cn_ratio"
		variable pari
		for (pari=0; pari<itemsinlist(par_list); pari+=1)
			
			string par_name = stringfromlist(pari,par_list)
			
			string mat_wname = ""
			string mat_sd_wname = ""
			if (doNormalize)
				mat_wname += fldr_prefix + ":"
			endif
			mat_wname += par_name+"_st_"+num2str(st_id)+"_fl_"+num2str(fl_id)
			mat_sd_wname += par_name+"_sd_st_"+num2str(st_id)+"_fl_"+num2str(fl_id)

			if (!waveexists($mat_wname) || numpnts($mat_wname) < itemsinlist(ss_list))
				make/o/n=(itemsinlist(ss_list)) $mat_wname
				wave tmp = $mat_wname
				tmp = NaN
			endif		
			wave par = $mat_wname

			if (!waveexists($mat_sd_wname) || numpnts($mat_sd_wname) < itemsinlist(ss_list))
				make/o/n=(itemsinlist(ss_list)) $mat_sd_wname
				wave tmp = $mat_sd_wname
				tmp = NaN
			endif		
			wave par_sd = $mat_sd_wname


			string mat_info = note(par)
			mat_info = replacenumberbykey("sample_type_id",mat_info,st_id)
	 		mat_info = replacestringbykey("sample_type",mat_info,stringbykey("sample_type",meta))
			mat_info = replacenumberbykey("flag_list_id",mat_info,fl_id)
	 		mat_info = replacestringbykey("flag_list",mat_info,stringbykey("flag_list",meta))
	 		mat_info = replacestringbykey("wavename",mat_info,mat_wname)
	 		note/k par
	 		note par, mat_info
			
			
			variable ss_index = whichlistitem(stringbykey("ss",meta),ss_list)
			if (ss_index >= 0) 
				duplicate/o ss_data, tmp_ss_data
				wave tmp_ss = tmp_ss_data
				ccn_clean_dp_v_ss_wave(tmp_ss)
				
				variable avg,sd
				if (cmpstr(par_name,"ccn_conc") == 0)
					avg = 0
					sd = 1
				elseif (cmpstr(par_name,"cn_conc") == 0)
					avg = 2
					sd = 3
				elseif (cmpstr(par_name,"ccn_cn_ratio") == 0)
					avg = 4
					sd = 5
				endif
				
				par[ss_index] = (dimsize(tmp_ss,0) > 0) ? util_matrix_wavestats_col(avg,tmp_ss,"V_avg") : NaN // avg
				par_sd[ss_index] = (dimsize(tmp_ss,0) > 0) ? util_matrix_wavestats_col(sd,tmp_ss,"V_avg") : NaN // sd
					
				killwaves/Z tmp_ss
			endif

		endfor
		
	endfor
	
	if (doNormalize)
		setdatafolder $fldr_prefix
	endif
	
	 wlist = acg_get_wave_list(filter="*_st_*") 
	 string ratio_list = ""
	 for (listi=0; listi<itemsinlist(wlist); listi+=1)
	 	
	 	string wname = stringfromlist(listi,wlist)
	 	wave w = $(wname)
	 	wavestats/Q w
	 	if (V_npnts == 0)
	 		killwaves/Z w
	 	else
	 		if (stringmatch(wname,"ccn_cn_ratio_st_*"))
	 			ratio_list = addlistitem(wname,ratio_list,";",Inf)
	 		endif
	 	endif
	 endfor
	 if (doNormalize)
		for (listi=0; listi<itemsinlist(ratio_list); listi+=1)
			wave ratio = $(stringfromlist(listi,ratio_list))
			wavestats/Q ratio
			variable rat_max = V_max
			if (rat_max > 0)
				ratio /= rat_max
			endif
		endfor
	endif

	
//	wlist = acg_get_wave_list(filter="*st_*")
	
//	variable typ
//	string samp_types=ccn_get_samp_type_list()	
//	string curr_type
//	for (typ=1;	typ<itemsinlist(samp_types); typ+=1) // skip 0=BAD case
//		string sample_type = stringfromlist(typ,samp_types)
//
//		string suffix
//		if (cmpstr(sample_type,"")==0 || cmpstr(sample_type,"NORMAL")==0)
//			suffix=""
//		elseif (cmpstr(sample_type,"BAD")==0)
//			continue
//		else
//			suffix="_"+sample_type
//		endif
//
//		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
//		make/o/n=(numpnts(ss)) $("ccn_cn_ratio"+suffix), $("ccn_cn_ratio_sd"+suffix)
//		wave ratio = $("ccn_cn_ratio"+suffix)
//		wave ratio_sd = $("ccn_cn_ratio_sd"+suffix)
//		ratio = nan
//		ratio_sd=nan
//		
//		//make/o/n=(numpnts(ss),numpnts(dp)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
//		make/o/n=(numpnts(ss)) $("ccn_conc"+suffix), $("ccn_conc_sd"+suffix)
//		wave ccn = $("ccn_conc"+suffix)
//		wave ccn_sd = $("ccn_conc_sd"+suffix)
//		ccn = nan
//		ccn_sd=nan
//		
//		//make/o/n=(numpnts(ss),numpnts(dp)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
//		make/o/n=(numpnts(ss)) $("cn_conc"+suffix), $("cn_conc_sd"+suffix) 
//		wave cn = $("cn_conc"+suffix)
//		wave cn_sd = $("cn_conc_sd"+suffix) 
//		cn = nan
//		cn_sd=nan
//	
//		// get matrix values from data waves
//		variable row,col
//		for (row=0; row<numpnts(ss); row+=1)
//			//for (col=0; col<numpnts(dp); col+=1)
//			string wname = ":data:" + ccn_spectra_generate_ss_name(ss[row])
//			wname+=suffix
//			if (waveexists($wname))
//				wave w_orig = $wname
//				if (dimsize(w_orig,0) > 0)
//					
//					duplicate/o w_orig cgdvs_tmp_w
//					ccn_clean_dp_v_ss_wave(cgdvs_tmp_w)
//					wave w = cgdvs_tmp_w
//					
//					wavestats/Q w
//					
//					ccn[row] = util_matrix_wavestats_col(0,w,"V_avg") // ccn
//					ccn_sd[row] =util_matrix_wavestats_col(1,w,"V_avg") // ccn_sd
//					
//					cn[row] = util_matrix_wavestats_col(2,w,"V_avg") // cn
//					cn_sd[row] =util_matrix_wavestats_col(3,w,"V_avg") // cn_sd
//
//					ratio[row] = util_matrix_wavestats_col(4,w,"V_avg") // ratio
//					ratio_sd[row] =util_matrix_wavestats_col(5,w,"V_avg") // ratio_sd
//
////					util_matrix_wavestats_col(2,w) // cn
////					cn[row][col] = V_avg
////					util_matrix_wavestats_col(3,w) // cn_sd
////					cn_sd[row][col] = V_avg
////
////					util_matrix_wavestats_col(4,w) // cn
////					ratio[row][col] = V_avg
////					util_matrix_wavestats_col(5,w) // cn_sd
////					ratio_sd[row][col] = V_avg
//					
//					killwaves/Z w
//				endif
//			endif
//			//endfor
//		endfor
//		wavestats/Q ratio
//		if (V_npnts==0) // all nans
//			killwaves/Z ratio,ratio_sd,ccn,ccn_sd,cn,cn_sd
//		else		// added 9Dec2014 - copied from mono version
//			// normalize ratio if "normalize=1"
////			if (normalize)
//			if (doNormalize)
//				make/o/n=(dimsize(ratio,0)) tmp_w
//				//for(col=0; col<dimsize(ratio,1); col+=1)
//					//tmp_w = ratio[p][col]
//					tmp_w = ratio[p]
//					wavestats/Q tmp_w
//					variable wmax = V_max
//					if (wmax > 0)
//						tmp_w /= wmax
//						ratio = tmp_w[p]
//					endif
//				//endfor
//				killwaves/Z tmp_w
//			endif
//
//		endif
//	endfor
//
//
//	
////	// generate dp and ss waves for images
////	wave w = $wname
////	wave dp = ccn_mono_dp
////	make/o/n=(numpnts(dp)+1) ccn_mono_dp_im
////	wave dp_im = ccn_mono_dp_im
////	dp_im[0] = dp[0] - ( ((dp[0]+dp[1])/2) - dp[0] ) 
////	dp_im[1,numpnts(dp_im)-2] = (dp[p-1] + dp[p])/2
////	dp_im[numpnts(dp_im)-1] = dp[numpnts(dp)-1] + ( dp[numpnts(dp)-1] - ( (dp[numpnts(dp)-1] + dp[numpnts(dp)-2])/2) )
////	
////	wave ss = ccn_mono_ss
////	make/o/n=(numpnts(ss)+1) ccn_mono_ss_im
////	wave ss_im = ccn_mono_ss_im
////	ss_im[0] = ss[0] - ( ((ss[0]+ss[1])/2) - ss[0] ) 
////	ss_im[1,numpnts(ss_im)-2] = (ss[p-1] + ss[p])/2
////	ss_im[numpnts(ss_im)-1] = ss[numpnts(ss)-1] + ( ss[numpnts(ss)-1] - ( (ss[numpnts(ss)-1] + ss[numpnts(ss)-2])/2) )
//
	
	setdatafolder sdf
//	setdatafolder dfr
End

Function/WAVE ccn_get_nan_db()
	string sdf = ccn_goto_ccn_folder()

	// add nan_db to run_config
	newdatafolder/o/s run_config
	if (!WaveExists($"nan_db"))
		make/T/n=0 $"nan_db"
	endif
	wave/T db = $"nan_db"
	setdatafolder sdf
	return db

End

Function dev_ccn_one_time_nan_save(sys_type)
	string sys_type // "mono" or "spectra"

	string sys_fld = "dp_v_ss"
	string sys_filter = "dp_*"
	if (cmpstr(sys_type,"spectra") ==0)
		sys_fld = "spectra_ss"
		sys_filter = "ss_*"
	endif

	wave/T db = ccn_get_nan_db()

	string sdf = ccn_goto_ccn_folder()
	// create folders
	newdatafolder/o/s $sys_fld
	newdatafolder/o/s data
		
	string wlist_all = acg_get_wave_list(filter="!*_dt") // get waves without _dt waves
	string wlist = ""
	variable j
	for (j=0; j<itemsinlist(wlist_all); j+=1)
		if ( stringmatch(stringfromlist(j,wlist_all),sys_filter) )
			wlist += stringfromlist(j,wlist_all) + ";"
		endif
	endfor
	
	variable listi
	for (listi=0; listi<itemsinlist(wlist); listi+=1)
		wave w = $(stringfromlist(listi,wlist))
		
		variable i
		for (i=0; i<dimsize(w,0); i+=1)
			if (w[i][9]) // nan col
				ccn_sync_wave_nan_by_row(db,w,i,1)
				//ccn_set_range_type(w[i][7],w[i][8],acg_wn_get_note_with_key(w,"SAMPLE_TYPE")) // removed by request from Trish
			endif
		endfor

	endfor
		
	setdatafolder sdf
End

Function ccn_wave_point_is_nan(db,name,start_dt,stop_dt)
	wave/T db
	string name
	variable start_dt
	variable stop_dt

	if (ccn_wave_point_nan_index(db,name,start_dt,stop_dt) >= 0)
		return 1
	endif
	return 0
End
		
Function ccn_wave_point_nan_index(db,name,start_dt,stop_dt)
	wave/T db
	string name
	variable start_dt
	variable stop_dt
	
	variable i
	for (i=0; i<numpnts(db); i+=1)
		string entry = db[i]
		variable check1 = numberbykey("START_DT",entry) >= start_dt && numberbykey("START_DT",entry) <= stop_dt
		variable check2 = numberbykey("STOP_DT",entry) >= start_dt && numberbykey("STOP_DT",entry) <= stop_dt
		
//		if ( cmpstr(stringbykey("NAME",entry),name)==0 && numberbykey("START_DT",entry)==start_dt && numberbykey("STOP_DT",entry)==stop_dt )
		if ( cmpstr(stringbykey("NAME",entry),name)==0 && (check1 || check2) ) // change to make the time check much more liberal
			return i
		endif
	endfor
	return -1

End

Function ccn_set_wave_nans(db,dat)
	wave/T db
	wave dat

	variable i
	for (i=0; i<dimsize(dat,0); i+=1)
		dat[i][9] = ccn_wave_point_is_nan(db,NameOfWave(dat),dat[i][7],dat[i][8])
	endfor

End


Function ccn_sync_wave_nan_by_row(db,dat,row,isNaN)
	wave/T db
	wave dat
	variable row
	variable isNaN
	
	string wn = NameOfWave(dat)
	variable start_dt = dat[row][7]
	variable stop_dt = dat[row][8]
	
	variable index = ccn_wave_point_nan_index(db,wn,start_dt,stop_dt)
	if (index >= 0)
		if (!isNaN)
				deletepoints index, 1, db
				return 1
		endif
		return 0
	elseif (!isNaN)
		return 0
	endif
	
//	variable i
//	for (i=0; i<numpnts(db); i+=1)
//		string entry = db[i]
//		if ( cmpstr(stringbykey("NAME",entry),wn)==0 && numberbykey("START_DT",entry)==start_dt && numberbykey("STOP_DT",entry)==stop_dt )
//			if (!isNaN)
//				deletepoints i, 1, db
//				return 1
//			endif
//			return 0 // nothing needed, already nan
//		endif
//	endfor
	
	variable cnt = numpnts(db)
	redimension/N=(cnt+1) db
	string entry = ""
	entry = replacestringbykey("NAME",entry,wn)
	entry = replacenumberbykey("START_DT",entry,start_dt)
	entry = replacenumberbykey("STOP_DT",entry,stop_dt)
	db[cnt] = entry
	return 1
End

Function dev_mono_generate_ss_waves([sample_type_list,required_flag_list])
	string sample_type_list
	string required_flag_list
	

	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable require_flags=0
	if (!ParamIsDefault(required_flag_list))
		require_flags=0
	endif

	// get wave nan db
	wave/T db = ccn_get_nan_db() 
	
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	
	// create folders
	newdatafolder/o/s dp_v_ss
	newdatafolder/o/s data
	// for now
	newdatafolder/o/s working
	
	// ** need to allow reset only the waves we are working on in data and normalize folders
	// 		- maybe do reset before working on a specific wave if stype or flags are not default
	
	// clean up any current waves as we will generate new values
	string wlist = acg_get_wave_list() // working
	killwaves/A
	//ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list() // data
	ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list() // spectra_ss
	ccn_reset_dp_v_ss_waves(wlist)
	
	if (datafolderexists(":normalize"))
		setdatafolder :normalize
		wlist = acg_get_wave_list() // spectra_ss:normalize
		ccn_reset_dp_v_ss_waves(wlist)
		setdatafolder ::
	endif


	wave dt = ::ccn_datetime
	wave ccn_clean = ::CCN_Concentration_Cleaned
	wave mono_cn = ::mono_cn_conc_shifted
	wave/T types = ::ccn_sample_type_dev
	wave/T flags = ::ccn_flag_dev

// added 9 Nov 2015 - use cn_residual for H cases

      variable use_cn_residual = 0 // turned off for the moment
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
	
	wave dp = ::zi_smps_dp_ccn_mono
	wave ss = ::SS_setting
	
	
	// major change: 04 March 2018 - redo entire logic to geneate waves for flexibility
	
	variable row
	for (row=0; row<numpnts(ccn_clean); row+=1)
		
		string stype = types[row]
		if (whichlistitem(stype,sample_type_list) < 0 ) // not a valid type
			continue
		endif
		
		string sflag = flags[row]
		if (require_flags) // if user requires a specific set of flags then only process if all present
			variable has_all_flags = 0
			if (cmpstr(required_flag_list,"")==0 && itemsinlist(sflag)==0)
				has_all_flags = 1
			else
				variable flg_cnt = 0
				variable flgi
				for (flgi=0; flgi<itemsinlist(required_flag_list); flgi+=1)
					if (whichlistitem(stringfromlist(flgi,required_flag_list),sflag) > -1)
						flg_cnt +=1
					endif
				endfor
				if (flg_cnt == itemsinlist(required_flag_list))
					has_all_flags = 1
				endif
			endif
			if (!has_all_flags)
				continue
			endif
		endif				
		
		// if we've made it this far, process point
		if (ccn_valid_dp_ss_pair(dp[row],ss[row])) // temp check for valid ss...need to fix original
			ccn_add_to_working_ss_wave("mono",dt[row],dp=dp[row],ss=ss[row],sample_type=stype,flag_list=sflag)
		endif
	endfor
	
	// process working waves into ss_waves
	variable cols = 10 // number of columns in data wave
	
	setdatafolder :data:working
	wlist = acg_get_wave_list(filter="dp_*_ss_*")
	setdatafolder :: // df = <>:data
	
	variable wi
	for (wi=0; wi<itemsinlist(wlist); wi+=1)
		string wn = stringfromlist(wi,wlist)
		
		//print "Working name: " + wn

		wave work = $(":working:"+wn)
		if (numpnts(work) == 0) // skip if wave has no data
			continue
		endif
		
		if (!waveexists($(wn+"_dt")))
			make/D/o/n=0 $(wn+"_dt")
		endif
		wave data_dt= $(wn+"_dt")

		if (!waveexists($wn))
			make/o/n=(0,cols) $wn
		endif
		wave data = $wn
		
		variable deltaT = 300 // valve timing
		ccn_process_working_wave(work,data_dt,data,dt,ccn_clean,mono_cn,ratio,deltaT)
		
		// set wavenote with metadata from working wave
		string meta = note(work)
		note/k data
		note data, meta
		
		ccn_set_wave_nans(db,data)
		
	endfor
	

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

Function dev_spectra_generate_ss_waves([sample_type_list,required_flag_list])
	string sample_type_list
	string required_flag_list
	

	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable require_flags=0
	if (!ParamIsDefault(required_flag_list))
		require_flags=0
	endif

	// get wave nan db
	wave/T db = ccn_get_nan_db() 
	
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	
	// create folders
	newdatafolder/o/s spectra_ss
	newdatafolder/o/s data
	// for now
	newdatafolder/o/s working
	
	// ** need to allow reset only the waves we are working on in data and normalize folders
	// 		- maybe do reset before working on a specific wave if stype or flags are not default
	
	// clean up any current waves as we will generate new values
	string wlist = acg_get_wave_list() // working
	killwaves/A
	//ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list() // data
	ccn_reset_dp_v_ss_waves(wlist)
	setdatafolder ::
	wlist = acg_get_wave_list() // spectra_ss
	ccn_reset_dp_v_ss_waves(wlist)
	
	if (datafolderexists(":normalize"))
		setdatafolder :normalize
		wlist = acg_get_wave_list() // spectra_ss:normalize
		ccn_reset_dp_v_ss_waves(wlist)
		setdatafolder ::
	endif


	wave dt = ::ccn_datetime
	wave ccn_clean = ::CCN_Concentration_Cleaned
	wave/T types = ::ccn_sample_type_dev
	wave/T flags = ::ccn_flag_dev

// added 9 Nov 2015 - use cn_residual for H cases

      variable use_cn_residual = 0 // turned off for the moment
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
	
	
	// major change: 04 March 2018 - redo entire logic to geneate waves for flexibility
	
	variable row
	for (row=0; row<numpnts(ccn_clean); row+=1)
		
		string stype = types[row]
		if (whichlistitem(stype,sample_type_list) < 0 ) // not a valid type
			continue
		endif
		
		string sflag = flags[row]
		if (require_flags) // if user requires a specific set of flags then only process if all present
			variable has_all_flags = 0
			if (cmpstr(required_flag_list,"")==0 && itemsinlist(sflag)==0)
				has_all_flags = 1
			else
				variable flg_cnt = 0
				variable flgi
				for (flgi=0; flgi<itemsinlist(required_flag_list); flgi+=1)
					if (whichlistitem(stringfromlist(flgi,required_flag_list),sflag) > -1)
						flg_cnt +=1
					endif
				endfor
				if (flg_cnt == itemsinlist(required_flag_list))
					has_all_flags = 1
				endif
			endif
			if (!has_all_flags)
				continue
			endif
		endif				
		
		// if we've made it this far, process point
		if (ccn_valid_ss(ss[row])) // temp check for valid ss...need to fix original
			ccn_add_to_working_ss_wave("spectra",dt[row],ss=ss[row],sample_type=stype,flag_list=sflag)
		endif
	endfor
	
	// process working waves into ss_waves
	variable cols = 10 // number of columns in data wave
	
	setdatafolder :data:working
	wlist = acg_get_wave_list(filter="ss_*")
	setdatafolder :: // df = <>:data
	
	variable wi
	for (wi=0; wi<itemsinlist(wlist); wi+=1)
		string wn = stringfromlist(wi,wlist)
		
		wave work = $(":working:"+wn)
		if (numpnts(work) == 0) // skip if wave has no data
			continue
		endif
		
		if (!waveexists($(wn+"_dt")))
			make/o/n=0 $(wn+"_dt")
		endif
		wave data_dt= $(wn+"_dt")

		if (!waveexists($wn))
			make/o/n=(0,cols) $wn
		endif
		wave data = $wn
		
		variable deltaT = 300 // valve timing
		ccn_process_working_wave(work,data_dt,data,dt,ccn_clean,mono_cn,ratio,deltaT)
		
		// set wavenote with metadata from working wave
		string meta = note(work)
		note/k data
		note data, meta
		
		ccn_set_wave_nans(db,data)
		
	endfor
	

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

Function ccn_process_working_wave(work,data_dt,data,dt,ccn,cn,ratio,deltaT)
	wave work
	wave data_dt
	wave data
	wave dt
	wave ccn
	wave cn
	wave ratio
	variable deltaT // criterion for separating data blocks in working waves (in seconds)
	
//	if (cmpstr(NameOfWave(work),"dp_50_ss_0_12_st_2_fl_18")==0)
//		print "here"
//	endif
	
	variable row
	variable dt_start_index
	variable dt_stop_index
		
	variable start_index = 0
	variable stop_index = 0
	variable/D last_dt = work[0]
	for (row=1; row<numpnts(work); row+=1)
		if ( (work[row] - last_dt) >= deltaT)
			// process block
			dt_start_index = binarysearch(dt,work[start_index])			
			dt_stop_index = binarysearch(dt,work[stop_index])		
			
			variable cnt = numpnts(data_dt)
			redimension/N=(cnt+1) data_dt
			redimension/N=(cnt+1,dimsize(data,1)) data
			
			wavestats/Q/R=[dt_start_index,dt_stop_index] dt
			data_dt[cnt] = V_avg
			data[cnt][7] = V_min  // start time
			if (V_max < V_min)
				data[cnt][8] = V_avg
			else
				data[cnt][8] = V_max // stop time
			endif
		
			wavestats/Q/R=[dt_start_index,dt_stop_index] ccn
			data[cnt][0] = V_avg
			data[cnt][1] = V_sdev
				
			wavestats/Q/R=[dt_start_index,dt_stop_index] cn
			data[cnt][2] = V_avg
			data[cnt][3] = V_sdev
		
			wavestats/Q/R=[dt_start_index,dt_stop_index] ratio
			data[cnt][4] = V_avg
			data[cnt][5] = V_sdev
			data[cnt][6] = V_npnts
			
			// set user_nan = 0 as default
			//w[cnt][7] = 0
			// ** CHANGE: 07 May 2018 **
			//	check to see if this time block is already set to BAD 
			//		- if 50% or more are BAD, set NaN param to 1
			
			data[cnt][9] = 0
			//variable set_nan = dev_working_block_is_bad(dt_start_index, dt_stop_index)
			//data[cnt][9] = dev_working_block_is_bad(dt_start_index, dt_stop_index)
			
			//acg_wn_set_note_with_key(data,"SAMPLE_TYPE",type)
			
			last_dt = work[row]
			start_index = row
			stop_index = row
	
	
		else
			last_dt = work[row]
			stop_index = row
		endif
	
	endfor
	
	if (start_index != stop_index)

		// process block
		dt_start_index = binarysearch(dt,work[start_index])			
		dt_stop_index = binarysearch(dt,work[stop_index])		
		
		cnt = numpnts(data_dt)
		redimension/N=(cnt+1) data_dt
		redimension/N=(cnt+1,dimsize(data,1)) data
		
		wavestats/Q/R=[dt_start_index,dt_stop_index] dt
		data_dt[cnt] = V_avg
		data[cnt][7] = V_min  // start time
		if (V_max < V_min)
			data[cnt][8] = V_avg
		else
			data[cnt][8] = V_max // stop time
		endif
	
		wavestats/Q/R=[dt_start_index,dt_stop_index] ccn
		data[cnt][0] = V_avg
		data[cnt][1] = V_sdev
			
		wavestats/Q/R=[dt_start_index,dt_stop_index] cn
		data[cnt][2] = V_avg
		data[cnt][3] = V_sdev
	
		wavestats/Q/R=[dt_start_index,dt_stop_index] ratio
		data[cnt][4] = V_avg
		data[cnt][5] = V_sdev
		data[cnt][6] = V_npnts
		
		// set user_nan = 0 as default
		//w[cnt][7] = 0
		data[cnt][9] = 0
		//data[cnt][9] = dev_working_block_is_bad(dt_start_index, dt_stop_index)
		//acg_wn_set_note_with_key(data,"SAMPLE_TYPE",type)
		
	endif				

End

Function dev_working_block_is_bad(dt_start_index, dt_stop_index)
	variable dt_start_index
	variable dt_stop_index
	
	variable deb = 0
//	if (dt_start_index == 189473)
//	if (dt_start_index > 189400)
//		print "here"
//		deb = 1
//	endif
	
	string sdf = ccn_goto_ccn_folder()
	
	wave/T types = ccn_sample_type_dev
	variable cnt=0, bad_cnt =0
	variable i
	for (i=dt_start_index; i<=dt_stop_index; i+=1)
		cnt+=1
		
		if (cmpstr(types[i],"BAD")==0)
			bad_cnt+=1
		endif

//		if (deb)
//			print types[i], cnt, bad_cnt, bad_cnt/cnt
//		endif

	endfor
	
	variable result = 0
	if (cnt > 0 && (bad_cnt/cnt >= 0.5) )
		result = 1
	endif
	return result
	
	setdatafolder sdf
	
End

Function ccn_add_to_working_ss_wave(sys_type,dt,[dp,ss,sample_type,flag_list])
	string sys_type // "spectra"||"poly", "mono"
	variable/D dt
	variable dp
	variable ss
	string sample_type
	string flag_list

	variable include_dp = 0
	if (!ParamIsDefault(dp))
		include_dp = 1
	endif

	variable include_ss = 0
	if (!ParamIsDefault(ss))
		include_ss = 1
	endif

	if (ParamIsDefault(sample_type))
		sample_type = ""
	endif
	
	if (ParamIsDefault(flag_list))
		flag_list = ""
	endif
	
	string data_fld = "spectra_ss"
	if (cmpstr(sys_type,"mono") == 0)
		data_fld = ":dp_v_ss"
	endif
	
	string sdf = ccn_goto_ccn_folder()
	newdatafolder/o/s $data_fld
	newdatafolder/o/s data
	newdatafolder/o/s working
	
	// get_workingwave name does the work of determining which state applies
	string meta = ccn_get_working_wavename(dt,include_dp,dp,include_ss,ss,sample_type,flag_list)
	string wname = stringbykey("wavename",meta)
	
	if (!waveexists($wname))
		make/D/o/n=0 $wname
		wave w = $wname
		note/k w
		note w, meta
	endif
	wave work =  $wname
	variable cnt = numpnts(work)
	redimension/N=(cnt+1) work
	work[cnt] = dt
	
	setdatafolder sdf
End

// return the name of proper working wave for given sample info criteria
//     - will name based on "state" for flags that have them defined
Function/S ccn_get_working_wavename(dt,include_dp,dp,include_ss,ss,sample_type,flag_list)
	variable/D dt
	variable include_dp
	variable dp
	variable include_ss
	variable ss
	string sample_type
	string flag_list
	
	string meta = ""
	
	string wname = ""
	if (include_dp)
		wname += "dp_"+num2str(dp)
		meta = replacenumberbykey("dp",meta,dp)
	endif
	if (include_ss)
		if (strlen(wname) > 0)
			wname += "_"
		endif
		wname +="ss_"+num2str(ss)
		meta = replacenumberbykey("ss",meta,ss)
	endif
	
	if (strlen(sample_type) > 0 && ccn_sample_type_is_valid(sample_type))
		wave/T def = ccn_get_config("sample_type")
		if (strlen(wname) > 0)
			wname += "_"
		endif
		variable st_id = ccn_get_id_by_name(def,sample_type)
		wname +="st_"+num2str(st_id)
		meta = replacenumberbykey("sample_type_id",meta,st_id)
		meta = replacestringbykey("sample_type",meta,sample_type)
	endif

	if (itemsinlist(flag_list) > 0)
		string result = ccn_generate_flag_list_id(dt, flag_list)
		//variable flag_list_id = ccn_generate_flag_list_id(dt, flag_list)
		variable flag_list_id = numberbykey("flag_list_id",result)
		if (numtype(flag_list_id) == 0)
			if (strlen(wname) > 0)
				wname += "_"
			endif
			wname +="fl_"+num2str(flag_list_id)
			meta = replacenumberbykey("flag_list_id",meta,flag_list_id)
			meta = replacestringbykey("flag_list",meta,stringbykey("flag_list",result))
		endif
	endif

	wname = replacestring(".",wname,"_")
	meta = replacestringbykey("wavename",meta,wname)	
	return meta 
End
	
Function/S ccn_parse_wavename(wname,[param_list])	
	string wname
	string param_list
	
	string par_list = "dp;ss;sample_type;flag_list"
	if (!ParamIsDefault(param_list))
		par_list = param_list
	endif

	string info = ""
	variable pari
	for (pari=0; pari<itemsinlist(par_list); pari+=1)
		string par = stringfromlist(pari,par_list)
		
		if (cmpstr(par,"dp")==0) // parse dp
			variable dpi =strsearch(wname,"dp_",0)
		endif
	endfor		
End

// ccn_generate_flag_list_id:
// 	allow for unknown number of flags by keeping a 'db' of flag_list combos to quickly check against
// 	schema:
//    		col 1: id
//    		col 2: flagid_string (same as used to create filename)
//    		col 3: ordered (by id) list of flags
//	arguments: 
//		dt: single date_time variable 
//		flag_list: stringlist of flags
//	return:
//		flag_id: cross_ref_id for given flag_list or NaN if not valid flags
//
//	** will create flag_id if all valid_flags but not contained in db
Function/S ccn_generate_flag_list_id(dt,flag_list)
	variable/D dt
	string flag_list
	
	string result = ""
	string flist = ""
	
	string flag_list_sorted
	if (itemsinlist(flag_list) > 0) // && ccn_sample_type_is_valid(sample_type))
		wave/T def = ccn_get_config("flag")
		
		// reorder flag_list by id
		make/o/n=(itemsinlist(flag_list)) sort_key
		wave key = sort_key
		variable k
		for (k=0; k<numpnts(key); k+=1)
			key[k] = ccn_get_id_by_name(def,stringfromlist(k,flag_list))
		endfor
		sort key,key
		flag_list_sorted = ""
		for (k=0; k<numpnts(key); k+=1)
			flag_list_sorted = addlistitem(ccn_get_name_by_id(def,key[k]),flag_list_sorted,";",Inf)
		endfor
		killwaves/Z key
		
		string wname = ""
		variable flagi
		for (flagi=0; flagi<itemsinlist(flag_list_sorted); flagi+=1)
			string flag = stringfromlist(flagi,flag_list_sorted)
			if (!ccn_flag_is_valid(flag))
				continue
			endif
			
			if (strlen(wname) > 0)
				wname += "_"
			endif

			string entry = ccn_get_entry(def,name=flag)
			variable id = numberbykey("id",entry)
			string state_list = ccn_get_state_list(entry)
			
			if (numberbykey("state_count",entry) > 1)
				string sdf = ccn_goto_ccn_folder()
				wave ccn_dt = ccn_datetime
				setdatafolder :run_config
				wave flag_index = $("ccn_flag_"+num2str(id)+"_index")
				variable row = binarysearch(ccn_dt,dt)
				variable statecol = 0
				variable col
				for (col=0; col<(numberbykey("state_count",entry)); col+=1)
					//print row, col, flag_index[row][col]
					if (numtype(flag_index[row][col]) == 0)
						statecol = col
						break
					endif
				endfor
				
				setdatafolder sdf
				wname += "f"+num2str(id)+"_"+num2str(statecol)
				flist = addlistitem(stringbykey("name",entry) + "[" + stringfromlist(statecol,state_list) + "]", flist, ";",Inf)
				
			
			else 
				wname += "f"+num2str(id)
				flist = addlistitem(stringbykey("name",entry), flist, ";",Inf)
			endif
		endfor
		
		result = replacestringbykey("flag_list",result,ccn_convert_list_to_map(flist))
				
		// lookup flag_id or create if not there
		sdf = ccn_goto_ccn_folder()
		setdatafolder :run_config
		if (!waveexists($"flag_list_id"))
			make/T/o/n=0 $"flag_list_id"
		endif
		wave/T db = $"flag_list_id"
		variable cnt = numpnts(db)
		
		variable dbi
		for (dbi=0; dbi<cnt; dbi+=1)
			string fl_id = stringbykey("flag_list_id",db[dbi])
			if (cmpstr(fl_id,wname) == 0)
				setdatafolder sdf
				
				result = replacenumberbykey("flag_list_id", result, numberbykey("id",db[dbi]))
				return result
				//return numberbykey("id",db[dbi])
			endif
		endfor
		
		// did not find id so create
		variable new_id = ccn_get_unique_id(db)
		cnt = numpnts(db)
		redimension/N=(cnt+1) db
		entry = ""
		entry = replacenumberbykey("id",entry,new_id)
		entry = replacestringbykey("flag_list_id",entry,wname)
		entry = replacestringbykey("flag_list",entry,ccn_convert_list_to_map(flag_list_sorted))
		db[cnt] = entry
		setdatafolder sdf
		
		
		result = replacenumberbykey("flag_list_id", result,new_id)
		return result
//		return new_id

	endif
	
		
End

Function ccn_sample_type_is_valid(sample_type)
	string sample_type
	if (whichlistitem(sample_type,ccn_get_samp_type_list_dev(ignore_defaults="true")) > -1)
		return 1
	endif
	return 0
End

Function ccn_flag_is_valid(flag)
	string flag
	if (whichlistitem(flag,ccn_get_flag_list_dev()) > -1)
		return 1
	endif
	return 0
End

Function ccn_is_nominal_SS_dev(ss_val)
	variable ss_val
	
	if (numtype(ss_val) != 0)
		return 0
	endif
	
	string nom_list = ""
	variable g = 0.1
	do
		nom_list = addlistitem(num2str(g),nom_list,";",Inf)
		g+=0.01
	while (g < 0.61)
	variable k
	for (k=0; k<itemsinlist(ccn_nom_ss_levels); k+=1)
		//nom_ss_val = str2num(stringfromlist(k,ccn_nom_ss_levels))
		if (whichlistitem(num2str(ss_val),nom_list) > -1)
//		if (ss_val == str2num(stringfromlist(k,nom_list)) )
			//nom_ss=1
			return 1
		endif
	endfor
	return 0
End

Function fake_valve()

	wave dt = $"root:valve:date_time"
	wave valve = $"root:valve:zi_tthdma_valve"
	
	variable row
	for (row=0; row<numpnts(dt); row+=1)
		string dts = secs2time(dt[row],2)
		string hrs = stringfromlist(0,dts,":")
		string ms = stringfromlist(1,dts,":")
		variable m = str2num(ms)
		//variable m = str2num(stringfromlist(1,secs2time(dt[row],2),":"))
	
		if (m>=0 && m<5)
			valve[row] = 0
		elseif (m>=10 && m<15)
			valve[row] = 0
		elseif (m>=20 && m<25)
			valve[row] = 0
		elseif (m>=30 && m<35)
			valve[row] = 0
		elseif (m>=40 && m<45)
			valve[row] = 0
		elseif (m>=50 && m<55) 
			valve[row] = 0
		else
			valve[row] = 5
		endif
	endfor		
End

Function/T acg_get_wave_as_list(input)
	wave input
	variable i
	string output = ""
	for (i=0; i<numpnts(input); i+=1)
		output = addlistitem(num2str(input[i]),output,";",Inf)
	endfor
	return output
End


Function dev_mono_plot_activation([dp,ss,normalize,sample_type_list,flag_list])
	variable dp
	variable ss
	string normalize
	string sample_type_list
	string flag_list

	variable use_dp =0
	variable valid_input = 0
	if (!ParamIsDefault(dp) && ccn_valid_dp(dp))
		use_dp = 1
		valid_input = 1
	endif
	
	if (!use_dp && ParamIsDefault(ss) && ccn_valid_ss(ss))
		use_dp =0
		valid_input = 1
	endif

	if (!valid_input)
		print "Invalid dp/ss input"
		return 0
	endif
	
	variable doNormalize = 0
	if (!ParamIsDefault(normalize))
		if (cmpstr(normalize,"true")==0 || cmpstr(normalize,"yes"))
			doNormalize = 1
		endif
	endif

	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable req_all_flags = 1
	if (ParamIsDefault(flag_list))
		flag_list = "*"
		req_all_flags=0
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss

	string x_name = ""
	if (use_dp)
		x_name = "ccn_mono_ss"
	else
		x_name = "ccn_mono_dp"
	endif
	wave x_axis = $x_name
	
	wave dp_w= ccn_mono_dp
	string dp_list = acg_get_wave_as_list(dp_w)
	wave ss_w = ccn_mono_ss
	string ss_list = acg_get_wave_as_list(ss_w)

	if (doNormalize)
		setdatafolder ":normalize"
	endif

	
		
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
//	setdatafolder :spectra_ss
//
//	variable doNormalize = 0
//	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
//		//suffix=""
//		doNormalize = 1
//	endif

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
	//for (i=1; i<itemsinlist(samp_type); i+=1)

	string legend_str = ""
	string title = ""
	
	for (i=0; i<itemsinlist(sample_type_list); i+=1)
		string suffix = stringfromlist(i,samp_type)
//		if (cmpstr(suffix,"NORMAL")==0)
//			suffix = ""
//		else
//			suffix = "_"+suffix
//		endif
		string sample_type = stringfromlist(i,sample_type_list)
		string ratio_list = ccn_find_wavelist_by_par(require_all=req_all_flags,sample_type=sample_type,flag_list=flag_list,filter="ccn_cn_ratio_st_*")
		
		variable listi
		for (listi=0; listi<itemsinlist(ratio_list); listi+=1)
			string wname = stringfromlist(listi,ratio_list)
			string wname_sd = replacestring("ccn_cn_ratio",wname,"ccn_cn_ratio_sd")
			
//		string wname = "ccn_cn_ratio"+suffix
//		string wname_sd = "ccn_cn_ratio_sd"+suffix
			if (waveexists($wname)) 
			
//				if (doNormalize)
//					setdatafolder $":normalize"
//				endif
			
				wave w = $wname
				wave w_sd = $wname_sd
				string meta = note(w)
				
				string fl_list = ccn_convert_list_from_map(stringbykey("flag_list",meta))
				if (cmpstr(";",fl_list[strlen(fl_list)-1]) == 0)
					fl_list = fl_list[0,strlen(fl_list)-2]
				endif
//			if (doNormalize)
//				setdatafolder ::
//			endif
			
//			//wave dp = ccn_mono_dp
//			wave ss = ccn_spectra_ss
				variable par_index = -1
				variable valid_trace = 0
				if (curve_cnt == 0)
					valid_trace = 0
					if (use_dp)
						par_index = whichlistitem(num2str(dp),dp_list) 
						if (par_index >= 0)
							display w[][par_index] vs x_axis
							valid_trace = 1
						endif
					else
						par_index = whichlistitem(num2str(ss),ss_list) 
						if (par_index >= 0)
							display w[par_index][] vs x_axis
							valid_trace = 1
						endif
					endif

					if (!valid_trace)
						continue
					endif				

					legend_str += "\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"			

				else
					valid_trace = 0
					if (use_dp)
						par_index = whichlistitem(num2str(dp),dp_list) 
						if (par_index >= 0)
							AppendToGraph w[][par_index] vs x_axis
							valid_trace = 1
						endif
					else
						par_index = whichlistitem(num2str(ss),ss_list) 
						if (par_index >= 0)
							AppendToGraph w[par_index][] vs x_axis
							valid_trace = 1
						endif
					endif

					if (!valid_trace)
						continue
					endif				

					legend_str += "\r\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"

				endif
				DelayUpdate
				ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
				ModifyGraph marker($wname)=mrk[curve_cnt]
				SetAxis left 0,1
				ModifyGraph grid(left)=1
				ModifyGraph grid=1
				ModifyGraph gaps($wname)=0
				//Legend/C/N=text0/H={0,10,10}/A=LT
				Label left "CCN/CN Ratio"
				if (use_dp)
					Label bottom "SS (%)"
					title = "D\\Bp\\M = " + num2str(dp) + "nm"
				else
					Label bottom "D\\Bp\\M (nm)"
					title = "SS = " + num2str(ss) + "%"
				endif
				ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
				
				DoUpdate		
				curve_cnt+=1
			endif
		endfor
	endfor		
	
	
	if (doNormalize)
		title += " (normalized)"
	endif
	TextBox/C/N=text1/H={0,10,10} title
	Legend/C/N=text0/H={0,10,10}/A=LT legend_str
	DoUpdate

	setdatafolder sdf
End


Function dev_spectra_plot_activation([normalize,sample_type_list,flag_list])
	string normalize
	string sample_type_list
	string flag_list

	variable doNormalize = 0
	if (!ParamIsDefault(normalize))
		if (cmpstr(normalize,"true")==0 || cmpstr(normalize,"yes"))
			doNormalize = 1
		endif
	endif

	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable req_all_flags = 1
	if (ParamIsDefault(flag_list))
		flag_list = "*"
		req_all_flags=0
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :spectra_ss

	wave ss = ccn_spectra_ss

	if (doNormalize)
		setdatafolder ":normalize"
	endif

	
		
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
//	setdatafolder :spectra_ss
//
//	variable doNormalize = 0
//	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
//		//suffix=""
//		doNormalize = 1
//	endif

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
	//for (i=1; i<itemsinlist(samp_type); i+=1)

	string legend_str = ""
	
	for (i=0; i<itemsinlist(sample_type_list); i+=1)
		string suffix = stringfromlist(i,samp_type)
//		if (cmpstr(suffix,"NORMAL")==0)
//			suffix = ""
//		else
//			suffix = "_"+suffix
//		endif
		string sample_type = stringfromlist(i,sample_type_list)
		string ratio_list = ccn_find_wavelist_by_par(require_all=req_all_flags,sample_type=sample_type,flag_list=flag_list,filter="ccn_cn_ratio_st*")
		
		variable listi
		for (listi=0; listi<itemsinlist(ratio_list); listi+=1)
			string wname = stringfromlist(listi,ratio_list)
			string wname_sd = replacestring("ccn_cn_ratio",wname,"ccn_cn_ratio_sd")
			
//		string wname = "ccn_cn_ratio"+suffix
//		string wname_sd = "ccn_cn_ratio_sd"+suffix
			if (waveexists($wname)) 
			
//				if (doNormalize)
//					setdatafolder $":normalize"
//				endif
			
				wave w = $wname
				wave w_sd = $wname_sd
				string meta = note(w)
				
				string fl_list = ccn_convert_list_from_map(stringbykey("flag_list",meta))
				if (cmpstr(";",fl_list[strlen(fl_list)-1]) == 0)
					fl_list = fl_list[0,strlen(fl_list)-2]
				endif
//			if (doNormalize)
//				setdatafolder ::
//			endif
			
//			//wave dp = ccn_mono_dp
//			wave ss = ccn_spectra_ss
			
				if (curve_cnt == 0)
					display w[] vs ss
					legend_str += "\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"
				else
					AppendToGraph w[] vs ss
					legend_str += "\r\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"
				endif
				DelayUpdate
				ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
				ModifyGraph marker($wname)=mrk[curve_cnt]
				SetAxis left 0,1
				ModifyGraph grid(left)=1
				ModifyGraph grid=1
				ModifyGraph gaps($wname)=0
				//Legend/C/N=text0/H={0,10,10}/A=LT
				//string title = "D\\Bp\\M = " + num2str(diam) + "nm"
				//TextBox/C/N=text1/H={0,10,10} title
				Label left "CCN/CN Ratio"
				Label bottom "SS (%)"
				
				ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
				
				DoUpdate		
				curve_cnt+=1
			endif
		endfor
	endfor		
	
	Legend/C/N=text0/H={0,10,10}/A=LT legend_str
	DoUpdate

	setdatafolder sdf
End

Function dev_mono_plot_dp_ss_wave(dp,ss,[sample_type,flag_list])
	variable dp
	variable ss
	string sample_type
	string flag_list
	//string state
	
	
	//wave st_config = ccn_get_config("sample_type)
	if (ParamIsDefault(sample_type))
		sample_type = "NORMAL"
	endif

	if (ParamIsDefault(flag_list))
		flag_list = ""
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss:data
	
	string wlist = ccn_find_wavelist_by_par(require_all=1,dp=dp,ss=ss,sample_type=sample_type,flag_list=flag_list,filter="!*_dt") 
	
	variable def_max_conc = 10000
	
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
//	setdatafolder :spectra_ss:data

//	string wname = ccn_spectra_generate_ss_name(ss)
//	wname += suffix
	string wname = stringfromlist(0,wlist)
	wave w = $wname
	wave dt = $(wname+"_dt")
	
	if (!waveexists(w) || !waveexists(dt))
		return 0
	endif
	
	string meta = note(w)

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
	
//	string txt = prefix + "SS="+num2str(ss)+"%"
	string txt = sample_type + "("+flag_list+") - Dp="+num2str(dp)+"nm, SS=" + num2str(ss) +"%"
	TextBox/C/N=text1/H={0,10,10}/A=RC txt	
	
	DoUpdate
	
	setdatafolder sdf
	//setdatafolder dfr
End


Function dev_spectra_plot_ss_ts(ss_list, [sample_type_list, flag_list, force_no_flags])
	string ss_list
	string sample_type_list
	string flag_list
	variable force_no_flags
	//string state
	
	
	//wave st_config = ccn_get_config("sample_type)
	
	if (itemsinlist(ss_list) < 1)
		print "no SS values in ss_list"
		return 1
	endif
	
	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	if (ParamIsDefault(force_no_flags))
		force_no_flags = 0
	endif

	if (ParamIsDefault(flag_list))
		flag_list = "TH_DENUDER[UNHEATED];TH_DENUDER[HEATED]"
		if (force_no_flags)
			flag_list = ""
		endif
	endif
	
	string sdf = ccn_goto_ccn_folder()
	newdatafolder/o/s ss_time_series
	newdatafolder/o/s spectra
	DFREF tsdf = GetDataFolderDFR()	
	
	string dt_path = ""
	string ss_path = ""
//	string ccn_path = ""
//	string cn_path = ""
//	string ratio_path = ""
	variable sampi
	for (sampi=0; sampi<itemsinlist(sample_type_list); sampi+=1)
		string sample_type = stringFromList(sampi, sample_type_list)
		dev_export_waves_using_filter("spectra",sample_type_list=sample_type_list,flag_list=flag_list)
		if (sampi == 0)
			string base_path = "root:ccn:exports:spectra:"+sample_type+":"
			dt_path = base_path + "ccn_datetime"
			ss_path = base_path + "ss"
//			ccn_path = base_path + "ccn"
//			cn_path = base_path + "cn"
//			ratio_path = base_path + "ratio"
		endif
	endfor
	
	wave dt_ref = $dt_path
	wave ss_ref = $ss_path
//	wave ccn_ref = $ccn_path
//	wave cn_ref = $cn_path
//	wave ratio_ref = $ratio_path
	
	variable ssi
	for (ssi=0; ssi<itemsinlist(ss_list); ssi+=1)
		string ss_str = stringfromlist(ssi, ss_list)
		if (itemsinlist(flag_list) > 0)
			variable flagi
			for (flagi=0; flagi<itemsinlist(flag_list); flagi+=1)
				string flag = stringfromlist(flagi, flag_list)
				string flag_wn = replacestring("[", flag, "_")
				flag_wn = replacestring("]", flag_wn, "_")
				string ss_wn = replacestring(".", ss_str,"_")
				duplicate/o ss_ref, $("ccn_ts_"+ss_wn+"_"+flag_wn), $("cn_ts_"+ss_wn+"_"+flag_wn), $("ratio_ts_"+ss_wn+"_"+flag_wn)
				duplicate/o dt_ref, $("dt_ts_"+ss_wn+"_"+flag_wn)
				wave ccn = $("ccn_ts_"+ss_wn+"_"+flag_wn)
				ccn = NaN
				wave cn = $("cn_ts_"+ss_wn+"_"+flag_wn)
				cn = NaN
				wave ratio = $("ratio_ts_"+ss_wn+"_"+flag_wn)
				ratio = NaN
				for (sampi=0; sampi<itemsinlist(sample_type_list); sampi+=1)
					sample_type = stringfromlist(sampi, sample_type_list)
					string pth = "root:ccn:exports:spectra:"+sample_type+":'"+flag+"'"
					setdatafolder $pth
//					root:ccn:exports:spectra:Ambient:'TH_DENUDER[HEATED]':
					wave curr_ccn = $"ccn"
					wave curr_cn = $"cn"
					wave curr_ratio = $"ratio"
					
					variable i
					for (i=0; i<numpnts(dt_ref); i+=1)
						variable tol = .001
						if (abs(ss_ref[i] - str2num(ss_str)) < tol)
							ccn[i] = curr_ccn[i]
							cn[i] = curr_cn[i]
							ratio[i] = curr_ratio[i]
						endif
					endfor
				endfor
				setdatafolder tsdf
			endfor
		else
			// put in code for no flags
			continue
		endif				
	endfor
	
//	variable sampi
//	for (sampi=0; sampi<itemsinlist(sample_type_list); sampi+=1)
//		string stype = stringfromlist(sampi, sample_type_list)
//		string wlist = ccn_find_wavelist_by_par(require_all=0,ss=ss,sample_type=stype,flag_list=flag_list,filter="!*_dt") 
////		string wlist = ccn_find_wavelist_by_par(require_all=1,ss=ss,sample_type=stype,filter="!*_dt") 
//	endfor
//	
//	if (itemsinlist(wlist)  < 1)
//		print "no waves meet that criteria"
//		return 0
//	endif
//	
//	wave w = $(stringfromlist(0, wlist))
//	variable cols = dimsize(w, 1)
//	string ss_name = replaceString(".", num2str(ss), "_")
//	make/o/n=(0,cols) $("ts_"+ss_name)
//	wave ts = $("ts_"+ss_name)
//	make/D/o/n=(0) $("ts_"+ss_name+"_dt")
//	wave ts_dt = $("ts_"+ss_name+"_dt")
//
//	variable wi, newi, i
//	for (wi=0; wi<itemsinlist(wlist); wi+=1)
//		wave w = $(stringfromlist(wi, wlist))
//		wave dt = $(stringfromlist(wi, wlist)+"_dt")
//		
//		for (newi=0; newi<numpnts(dt); newi+=1)
//		
//			variable index = binarysearch(ts_dt, dt[newi])
//			
//			if (index == -3 || index == -1)
//				insertpoints 0, 1, ts_dt, ts
//				ts_dt[0] = dt[newi]
//				ts[0][] = w[newi][q]
//			
//			elseif (index == -2)
//				variable last = numpnts(ts_dt)
//				insertpoints last, 1, ts_dt, ts
//				ts_dt[last] = dt[newi]
//				ts[last][] = w[newi][q]
//		
//			else
//				if (ts_dt[index] != dt[newi])
//					insertpoints index+1, 1, ts_dt, ts
//					ts_dt[index+1] = dt[newi]
//					ts[index+1][] = w[newi][q]
//				endif
//			endif
//		endfor
//	endfor
//	
//	variable def_max_conc = 10000
//	
////	dfref dfr = GetDataFolderDFR()
////	setdatafolder ccn_data_folder
////	setdatafolder :spectra_ss:data
//
////	string wname = ccn_spectra_generate_ss_name(ss)
////	wname += suffix
////	string wname = stringfromlist(0,wlist)
//	wave w = $("ts_"+ss_name)
//	wave dt = $("ts_"+ss_name+"_dt")
//	string wname = nameofwave(w)
//	
//	if (!waveexists(w) || !waveexists(dt))
//		return 0
//	endif
//	
//	string meta = note(w)
	
	string wname
	setdatafolder tsdf
	for (ssi=0; ssi<itemsinlist(ss_list); ssi+=1)
		ss_str = stringfromlist(ssi, ss_list)
		ss_wn = replaceString(".", ss_str, "_")
		for (flagi=0; flagi<itemsinlist(flag_list); flagi+=1)
			flag = stringfromlist(flagi, flag_list)
			flag_wn = replacestring("[", flag, "_")
			flag_wn = replacestring("]", flag_wn, "_")
			
			wave dt = $"dt_ts_"+ss_wn+"_"+flag_wn
			wave ccn = $"ccn_ts_"+ss_wn+"_"+flag_wn
			wave cn = $"cn_ts_"+ss_wn+"_"+flag_wn
			wave ratio = $"ratio_ts_"+ss_wn+"_"+flag_wn

			if (ssi == 0 && flagi == 0)
				display cn vs dt
				DelayUpdate
				wname = nameofwave(cn)
				ModifyGraph mode($wname)=3,marker($wname)=19
				ModifyGraph axisEnab(left)={0,0.3},lblPosMode(left)=1,freePos(left)=0
				Label left "CN"
				
				wname = nameofwave(ccn)
				appendtograph/L=ccn ccn vs dt
				ModifyGraph mode($(wname))=3,marker($(wname))=19,rgb($(wname))=(0,15872,65280)
				ModifyGraph axisEnab(ccn)={0.35,0.65},lblPosMode(ccn)=1,freePos(ccn)=0
				Label ccn "CCN"
				
				wname = nameofwave(ratio)
				appendtograph/L=ratio ratio vs dt
				ModifyGraph mode($(wname))=3,marker($(wname))=19,rgb($(wname))=(0,39168,0)
				ModifyGraph axisEnab(ratio)={0.7,1},lblPosMode(ratio)=1,freePos(ratio)=0
				Label ratio "CCN/CN"
				
			else
				appendtograph cn vs dt
				wname = nameofwave(cn)
				ModifyGraph mode($wname)=3,marker($wname)=19

				appendtograph/L=ccn ccn vs dt
				wname = nameofwave(ccn)
				ModifyGraph mode($(wname))=3,marker($(wname))=19,rgb($(wname))=(0,15872,65280)

				appendtograph/L=ratio ratio vs dt
				wname = nameofwave(ratio)
				ModifyGraph mode($(wname))=3,marker($(wname))=19,rgb($(wname))=(0,39168,0)
			
			endif
		endfor
	endfor
//	display w[][2] vs dt
//	DelayUpdate
//	ModifyGraph mode($wname)=3,marker($wname)=19
//	ModifyGraph axisEnab(left)={0,0.3},lblPosMode(left)=1,freePos(left)=0
//	ErrorBars $wname Y,wave=(w[*][3],w[*][3])
//	Label left "CN"
//	SetAxis left 0,def_max_conc
//
//	AppendToGraph/L=ccn w[][0] vs dt
//	ModifyGraph mode($(wname+"#1"))=3,marker($(wname+"#1"))=19,rgb($(wname+"#1"))=(0,15872,65280)
//	ModifyGraph axisEnab(ccn)={0.35,0.65},lblPosMode(ccn)=1,freePos(ccn)=0
//	ErrorBars $(wname+"#1") Y,wave=(w[*][1],w[*][1])
//	Label ccn "CCN"
//	SetAxis ccn 0,def_max_conc
//
//	AppendToGraph/L=ratio w[][4] vs dt
//	ModifyGraph mode($(wname+"#2"))=3,marker($(wname+"#2"))=19,rgb($(wname+"#2"))=(0,39168,0)
//	ModifyGraph axisEnab(ratio)={0.7,1},lblPosMode(ratio)=1,freePos(ratio)=0
//	ErrorBars $(wname+"#2") Y,wave=(w[*][5],w[*][5])
//	Label ratio "CCN/CN"
//	SetAxis ratio 0,1.2
//	ModifyGraph grid(ratio)=1
//
////	AppendToGraph/R=flag w[][9] vs dt
////	ModifyGraph lblPosMode(flag)=1,freePos(flag)=0
////	ModifyGraph mode=3
////	ModifyGraph axisEnab(flag)={0,0.3}
////	SetAxis flag 0.1,1
////	ModifyGraph marker($(wname+"#3"))=16
////	ModifyGraph rgb($(wname+"#3"))=(0,0,0)
////	Label flag "User NaN"
//	
//	string txt = "SS="+num2str(ss)+"%"
////	string txt = sample_type + "("+flag_list+") - SS=" + num2str(ss) +"%"
//	TextBox/C/N=text1/H={0,10,10}/A=RC txt	
//	
	DoUpdate
//	
	setdatafolder sdf
	//setdatafolder dfr
End


Function dev_spectra_plot_ss_wave(ss,[sample_type,flag_list])
	variable ss
	string sample_type
	string flag_list
	//string state
	
	
	//wave st_config = ccn_get_config("sample_type)
	if (ParamIsDefault(sample_type))
		sample_type = "NORMAL"
	endif

	if (ParamIsDefault(flag_list))
		flag_list = ""
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :spectra_ss:data
	
	string wlist = ccn_find_wavelist_by_par(require_all=1,ss=ss,sample_type=sample_type,flag_list=flag_list,filter="!*_dt") 
	
	variable def_max_conc = 10000
	
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
//	setdatafolder :spectra_ss:data

//	string wname = ccn_spectra_generate_ss_name(ss)
//	wname += suffix
	string wname = stringfromlist(0,wlist)
	wave w = $wname
	wave dt = $(wname+"_dt")
	
	if (!waveexists(w) || !waveexists(dt))
		return 0
	endif
	
	string meta = note(w)

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
	
//	string txt = prefix + "SS="+num2str(ss)+"%"
	string txt = sample_type + "("+flag_list+") - SS=" + num2str(ss) +"%"
	TextBox/C/N=text1/H={0,10,10}/A=RC txt	
	
	DoUpdate
	
	setdatafolder sdf
	//setdatafolder dfr
End

Function/S ccn_find_wavelist_by_par([path,require_all,dp,ss,sample_type_id,sample_type,flag_list_id,flag_list,filter]) 
	string path
	variable require_all 
	variable dp
	variable ss
	variable sample_type_id
	string sample_type
	variable flag_list_id
	string flag_list
	string filter
	
	string wlist = ""
	
	string sdf = getdatafolder(1)
	if (!ParamIsDefault(path))
		setdatafolder $path
	endif
	
	if (ParamIsDefault(require_all))
		require_all = 1
	endif
	
	variable require_dp = 0
	if (!ParamIsDefault(dp))
		require_dp =1
	endif

	variable require_ss = 0
	if (!ParamIsDefault(ss))
		require_ss =1
	endif
	
	variable require_sample_type_id = 0
	if (!ParamIsDefault(sample_type_id))
		require_sample_type_id =1
	endif

	variable require_sample_type = 0
	if (!ParamIsDefault(sample_type))
		require_sample_type =1
	endif

	variable require_flag_list_id = 0
	if (!ParamIsDefault(flag_list_id))
		require_flag_list_id =1
	endif

	variable require_flag_list = 0
	if (!ParamIsDefault(flag_list))
		require_flag_list =1
	endif

	if (ParamIsDefault(filter) || strlen(filter)==0) 
		filter = "*"
	endif

	string list = acg_get_wave_list(filter=filter)

	variable tol = 0.001
	variable i
	for (i=0; i<itemsinlist(list); i+=1)
		variable good_match = 1
		string wname = stringfromlist(i,list)
		
		wave w = $wname
		string meta = note(w)
		if (require_dp)
			if (abs(dp-numberbykey("dp",meta)) < tol)
				if (!require_all && whichlistitem(wname,wlist)<0)
					wlist = addlistitem(wname,wlist,";",Inf)
				endif
			else
				if (require_all)
					continue
				endif
				good_match = 0
			endif
		endif	

		if (require_ss)
			if (abs(ss-numberbykey("ss",meta)) < tol)
				if (!require_all && whichlistitem(wname,wlist)<0)
					wlist = addlistitem(wname,wlist,";",Inf)
				endif
			else
				if (require_all)
					continue
				endif
				good_match = 0
			endif
		endif	

		if (require_sample_type_id)
			if (abs(sample_type_id-numberbykey("sample_type_id",meta)) < tol)
				if (!require_all && whichlistitem(wname,wlist)<0)
					wlist = addlistitem(wname,wlist,";",Inf)
				endif
			else
				if (require_all)
					continue
				endif
				good_match = 0
			endif
		endif	

		if (require_sample_type)
			if (cmpstr(sample_type,stringbykey("sample_type",meta)) == 0)
				if (!require_all && whichlistitem(wname,wlist)<0)
					wlist = addlistitem(wname,wlist,";",Inf)
				endif
			else
				if (require_all)
					continue
				endif
				good_match = 0
			endif
		endif	
					
		if (require_flag_list_id)
			if (abs(flag_list_id-numberbykey("flag_list_id",meta)) < tol)
				if (!require_all && whichlistitem(wname,wlist)<0)
					wlist = addlistitem(wname,wlist,";",Inf)
				endif
			else
				if (require_all)
					continue
				endif
				good_match = 0
			endif
		endif	

		if (require_flag_list)
			//if (cmpstr(sample_type,stringbykey("sample_type",meta)) == 0)
			if (cmpstr("*",flag_list)==0 && good_match && whichlistitem(wname,wlist)<0)
				wlist = addlistitem(wname,wlist,";",Inf)
				good_match = 0
			elseif (acg_compare_lists(flag_list,ccn_convert_list_from_map(stringbykey("flag_list",meta))))
				if (!require_all && whichlistitem(wname,wlist)<0)
					wlist = addlistitem(wname,wlist,";",Inf)
				endif
			else
				if (require_all)
					continue
				endif
				good_match = 0
			endif
		endif	

		if (require_all && good_match && whichlistitem(wname,wlist)<0)
			wlist = addlistitem(wname,wlist,";",Inf)
			setdatafolder sdf
			return wlist
		endif			
	endfor	

	setdatafolder sdf
	return wlist
End

Function acg_compare_lists(listA, listB)
	string listA
	string listB
	
	variable cntA = itemsinlist(listA)
	if (cntA != itemsinlist(listB))
		return 0
	endif
	
	variable cnt = 0
	variable i
	for (i=0; i<cntA; i+=1)
		variable indexB = whichlistitem(stringfromlist(i,listA),listB)
		if (indexB < 0)
			return 0
		endif
		cnt +=1
	endfor
	if (cntA == cnt)
		return 1
	endif
	return 0
	
End

Function ccn_set_range_type_dev(start_dt,stop_dt,stype)
	variable start_dt
	variable stop_dt
	string stype
	
//	dfref dfr = GetDataFolderDFR()
	
//	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	wave dt = ccn_datetime
	
	variable starti = round(BinarySearchInterp(dt,start_dt))
	starti = (numtype(starti)>0) ? 0 : starti
	variable stopi = round(BinarySearchInterp(dt,stop_dt))
	stopi = (numtype(stopi)>0) ? numpnts(dt)-1 : stopi

	wave/T type = ccn_sample_type_dev
	type[starti,stopi] = stype
	
	ccn_update_sample_info_index(config_type="sample_type")
	
	setdatafolder sdf

End

//Window set_sample_info_plot() : Graph
Function ccn_sample_info_plot()

	string sdf = ccn_goto_ccn_folder()
	
	wave ccn = $(":CCN_Concentration_Cleaned")
	wave ratio = $(":CCN_CN_ratio_Cleaned")
	wave ss = $(":SS_setting")
	
	setdatafolder :run_config
	wave sample_type_index = $(":ccn_sample_type_index")
	string flag_index_list = acg_get_wave_list(filter="ccn_flag_*_index")

	PauseUpdate; Silent 1		// building window...
	//String fldrSav0= GetDataFolder(1)
	//SetDataFolder root:ccn:
	
	Display ccn
	AppendToGraph/R ratio
	AppendToGraph/L=ss ss
	AppendToGraph/R=st_index sample_type_index
	
	string wn = NameOfWave(ratio)
	ModifyGraph rgb($wn)=(0,52224,0)
	wn = NameOfWave(ss)
	ModifyGraph rgb($wn)=(0,12800,52224)
	wn = NameOfWave(sample_type_index)
	ModifyGraph rgb($wn)=(65280,43520,0)
	ModifyGraph lSize($wn)=1.5
	
	// add flag waves
	variable flagi
	for (flagi=0; flagi<itemsinlist(flag_index_list); flagi+=1)
		wave flag_index = $stringfromlist(flagi,flag_index_list)
		wn = NameOfWave(flag_index)
		if (dimsize(flag_index,1) > 1)
			variable col
			for (col=0; col<dimsize(flag_index,1); col+=1)
				AppendToGraph/L=flag_index flag_index[*][col]
				if (col>0)
					wn += "#"+num2str(col)
				endif
				ModifyGraph lsize($wn)=2,rgb($wn)=(0,0,0);DelayUpdate
			endfor
		else
			AppendToGraph/L=flag_index flag_index
			ModifyGraph lsize($wn)=2,rgb($wn)=(0,0,0);DelayUpdate
		endif
	endfor
	
	
//	Display /W=(265.5,86.75,1062,594.5) CCN_Concentration_Cleaned
//	AppendToGraph/R CCN_CN_ratio_Cleaned
//	AppendToGraph/L=ss SS_setting
//	AppendToGraph/R=st_index :run_config:ccn_sample_type_index
//	AppendToGraph/L=flag_index :run_config:ccn_flag_2_index
//	SetDataFolder fldrSav0
//	ModifyGraph lSize(ccn_sample_type_index)=1.5
//	ModifyGraph rgb(CCN_CN_ratio_Cleaned)=(0,52224,0),rgb(SS_setting)=(0,12800,52224)
//	ModifyGraph rgb(ccn_sample_type_index)=(65280,43520,0)
	ModifyGraph lblPosMode(left)=1,lblPosMode(right)=1,lblPosMode(ss)=1,lblPosMode(st_index)=1
	ModifyGraph lblPosMode(flag_index)=1
	ModifyGraph lblPos(left)=60,lblPos(right)=60,lblPos(ss)=60,lblPos(st_index)=60
	ModifyGraph freePos(ss)=0
	ModifyGraph freePos(st_index)=0
	ModifyGraph freePos(flag_index)=0
	ModifyGraph axisEnab(left)={0,0.3}
	ModifyGraph axisEnab(right)={0,0.3}
	ModifyGraph axisEnab(ss)={0.34,0.64}
	ModifyGraph axisEnab(st_index)={0.34,0.64}
	ModifyGraph axisEnab(flag_index)={0.68,1}
	ModifyGraph dateInfo(bottom)={0,0,0}
	Label left "CCN"
	Label right "CCN/CN Ratio"
	Label ss "SS"
	Label st_index "Sample Type Index"
	Label flag_index "Flag Index"
	SetAxis left 0,1000
	SetAxis right 0,2
	
	setdatafolder sdf
End

Function ccn_create_cheat_sheet([show])
	string show
	
	variable open_sheets = 0
	if (!ParamIsDefault(show))
		if (cmpstr(show,"true")==0 || cmpstr(show,"yes")==0)
			open_sheets = 1
		endif
	endif
		
	// sample_types
	string sdf = ccn_goto_config()
	
	string st_list = ccn_get_samp_type_list_dev()
	make/T/o/n=(itemsinlist(st_list),2) sample_types_cheat_sheet
	wave/T st_cheat = sample_types_cheat_sheet
	wave/T config = ccn_get_config("sample_type")

	variable i
	for (i=0; i<itemsinlist(st_list); i+=1)
		string name = stringfromlist(i,st_list)
		st_cheat[i][0] = num2str(ccn_get_id_by_name(config,name))
		st_cheat[i][1] = name
	endfor	

	string fl_list = ccn_get_flag_list_dev()
	make/T/o/n=(itemsinlist(fl_list),3) flags_cheat_sheet
	wave/T fl_cheat = flags_cheat_sheet
	wave/T config = ccn_get_config("flag")
	for (i=0; i<itemsinlist(fl_list); i+=1)
		name = stringfromlist(i,fl_list)
		fl_cheat[i][0] = num2str(ccn_get_id_by_name(config,name))
		fl_cheat[i][1] = name
		fl_cheat[i][2] = ccn_get_state_list_by_name(config,name)
	endfor	

	setdatafolder sdf

	if (open_sheets)
		edit st_cheat
		edit fl_cheat
	endif
End

Function dev_plot_working_data(wd)
	wave wd
	
	string sdf = ccn_goto_ccn_folder()

	wave dt = ccn_datetime
	wave ccn = CCN_Concentration_Cleaned
	wave cn = cn_ccn_mono
	
	duplicate/o wd, cn_working, ccn_working
	wave cn_w = cn_working
	wave ccn_w = ccn_working
	
	variable i
	for (i=0; i<numpnts(wd); i+=1)
		variable index = x2pnt(cn,wd[i])

		cn_w[i] = cn[index]	
		ccn_w[i] = ccn[index]	

	endfor

	duplicate/o cn_w, ratio_working
	wave ratio_w = ratio_working
	ratio_w = ccn_w/cn_w
	
	display cn_w vs wd
	appendtograph ccn_w vs wd
	appendtograph/R  ratio_w vs wd
		
	setdatafolder sdf
	
End

// ** dev_export_waves_using_filter **
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
//			<flag>
//				 - ccn, cn, ratio, dt, ss, [dp]
//
//	The function will step through sample_types and then flags. In each folder, the time series will contain data if
//	the sample type or sample type&flag (not all flags) are present. Bad data will not be included.
//
Function dev_export_waves_using_filter(data_type,[sample_type_list,flag_list])
	string data_type
	string sample_type_list
	string flag_list
	
	if (cmpstr(data_type,"spectra")!=0 && cmpstr(data_type,"mono")!=0)
		print "Bad data_type. Allowed types: spectra or mono"
		return 0
	endif
		
	variable all_sample_types = 0
	if (ParamIsDefault(sample_type_list) || cmpstr(sample_type_list,"")==0)
		sample_type_list = "ALL_TYPES"
		all_sample_types = 1
	endif

//	variable require_flags=0
	if (ParamIsDefault(flag_list))
		flag_list = ""
	endif

	// get wave nan db
	wave/T db = ccn_get_nan_db() 
	
//	dfref dfr = GetDataFolderDFR()
//	setdatafolder ccn_data_folder
	string sdf = ccn_goto_ccn_folder()
	

	wave dt = ccn_datetime
	wave all_ccn = CCN_Concentration_Cleaned
	wave/T types = ccn_sample_type_dev
	wave/T flags = ccn_flag_dev
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
		for (flagi=0; flagi<itemsinlist(flag_list); flagi+=1)
			string flag = stringfromlist(flagi,flag_list)
			newdatafolder/o/s $flag
			
			duplicate/o all_ccn, $("cn"), $("ccn"), $("ratio")
			wave cn = $"cn"
			wave ccn = $"ccn"
			wave ratio = $"ratio"
			cn = NaN
			ccn = NaN
			ratio = NaN

			for (row=0; row<numpnts(all_cn); row+=1)
				if (ccn_flag_is_set(flag, row))
//				if (whichlistitem(flag,flags[row]) >= 0)
					if (all_sample_types || cmpstr(types[row],type) == 0) 
						cn[row] = all_cn[row]
						ccn[row] = all_ccn[row]
						ratio[row] = all_ratio[row]
					endif
				endif
			endfor
	
			setdatafolder ::
		endfor
		
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



// *** for now, it just finds ss_crit for all sample types and flags.
// ** Function: ccn_mono_find_ss_crit **
//
//	Calculate critical SS values from mono cn/ccn ratios. Also find values for ratio+sd and ratio-sd values
//
//	Requires: standard dp_v_ss matrix of ratios and ratio_sd for sample types
//
//	usage: ccn_mono_find_ss_critsamp_types, normalized
//		where:
//			samp_types - string list of sample types (standard delimiter)
// 			normalized - specified ss_crit calculated from normalized data or no (0=false, 1=true)
//
//	output:  ccn_crit waves for each samp/flag type where cols correspond to dp and rows:
//		row 0: ss_crit value @ ccn_cn_rat avg
//		row 1: ss_crit value @ ccn_cn_rat avg - sd (max range)
//		row 2: ss_crit value @ ccn_cn_rat avg + sd (min range)
//		row 3: ss_crit positive error bar (row 1 - row 0)
//		row 3: ss_crit negative error bar (row 0 - row 2)
// **
//Function dev_mono_find_ss_crit([samp_type_list, flag_list,normalize])
Function dev_mono_find_ss_crit([normalize])
	//string samp_type_list // sample type list
	//string flag_list // list of flags
	string normalize // use normalized matrix
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss

	wave dp= ccn_mono_dp
	wave ss = ccn_mono_ss
	
//	if (ParamIsDefault(samp_type_list))
//		samp_type_list = ""
//	endif

//	if (ParamIsDefault(flag_list))
//		flag_list = ""
//	endif
		
	variable doNormalize = 0
	string fldr_prefix = ""
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
		fldr_prefix = ":normalize"
	endif

	if (doNormalize)
		setdatafolder $fldr_prefix
	endif
	string dp_v_ss_sdf = getdataFolder(1)
		
	// find list of waves meeting criteria
	string wlist = acg_get_wave_list(filter=("ccn_cn_ratio_st_*")) // get list of all param waves
	string sdlist = replacestring("_st_",wlist,"_sd_st_",1)
	//string sdlist = acg_get_wave_list(filter=(param+"_sd_st_*")) // get list of all sd waves
	variable listi

	if (doNormalize)
		setdatafolder ::
	endif
	newdataFolder/o/s :ss_crit
	if (doNormalize) 
		newdatafolder/o/s :normalize
	endif
	string ss_crit_sdf = getdataFolder(1)

	for (listi=0; listi<itemsinlist(wlist); listi+=1)
		setdatafolder $dp_v_ss_sdf
		wave ratio = $(stringfromlist(listi, wlist))
		wave sd = $(stringfromlist(listi, sdlist))
		
		if (dimsize(ratio,0) <= 0)
			continue
		endif
		
		setdatafolder $ss_crit_sdf
		string wn = replacestring("ccn_cn_ratio", stringfromlist(listi, wlist), "ss_crit")
		make/o/n=(5,numpnts(dp)) $wn
		wave ss_crit = $wn
		
		variable dpi
		for (dpi=0; dpi<numpnts(dp); dpi+=1)
		
			make/o/n=(dimsize(ratio,0)) tmp_ratio
			wave tmp_ratio = tmp_ratio
			tmp_ratio = ratio[p][dpi]
			
			// find crit_ss for ratio
			ss_crit[0][dpi] = dev_find_crit_ss_mono(ss,tmp_ratio,0.5)

			// find crit_ss for ratio-sd
			tmp_ratio = ratio[p][dpi]-sd[p][dpi]
			ss_crit[1][dpi] = dev_find_crit_ss_mono(ss,tmp_ratio,0.5)

			// find crit_ss for ratio+sd
			tmp_ratio = ratio[p][dpi]+sd[p][dpi]
			ss_crit[2][dpi] = dev_find_crit_ss_mono(ss,tmp_ratio,0.5)

			// add error bar values for plotting
			ss_crit[3][dpi] = abs(ss_crit[1][dpi] - ss_crit[0][dpi])
			ss_crit[4][dpi] = abs(ss_crit[0][dpi] - ss_crit[2][dpi])
			
		endfor	 
		
		string rat_info = note(ratio)
		rat_info = replacestringbykey("wavename",rat_info,wn)
 		note/k ss_crit
 		note ss_crit, rat_info
	
	endfor
	
	killwaves/Z tmp_ratio
	setdatafolder sdf
End	


//Function dev_ccn_mono_find_ss_crit(samp_types,[normalize])
//	string samp_types // list of sample types to use (does not have to be full list)
//	string normalize
//	
//	string sdf = ccn_goto_ccn_folder()
//	setdatafolder :dp_v_ss
//
//	variable doNormalize = 0
//	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
//		//suffix=""
//		doNormalize = 1
//	endif
//	 

//
//
//	variable sti
//	for (sti=0; sti<itemsinlist(samp_types); sti+=1)
//		string type = stringfromlist(sti,samp_types)
//		
//		if (doNormalize)
//			setdatafolder $":normalize"
//		endif
//		if ( waveexists( $("ccn_cn_ratio_"+type)) && waveexists( $("ccn_cn_ratio_"+type)) ) //&& waveexists($("ccn_mono_ss")) && waveexists($("ccn_mono_dp")) ) 
//			wave ratio = $("ccn_cn_ratio_"+type)
//			wave sd = $("ccn_cn_ratio_sd_"+type)
//			
//			if (doNormalize)
//				setdatafolder ::
//			endif
//			wave ss = ccn_mono_ss // is this always the name?
//			wave dp = ccn_mono_dp // is this always the name?
//			
//			newdatafolder/o/s :ss_crit
//			if (doNormalize)
//				newdatafolder/o/s :normalize
//			endif
//			make/o/n=(3,numpnts(dp)) $("ss_crit_"+type) // rows: ratio, ratio-sd, ratio+sd; cols: dps
//			wave ss_crit = $("ss_crit_"+type) 
//			
//			if (doNormalize)
//				setdatafolder ::
//			endif
//			
//			variable dpi
//			for (dpi=0; dpi<numpnts(dp); dpi+=1)
//			
//				make/o/n=(dimsize(ratio,0)) tmp_ratio
//				wave tmp_ratio = tmp_ratio
//				tmp_ratio = ratio[p][dpi]
//				
//				// find crit_ss for ratio
//				ss_crit[0][dpi] = ccn_find_crit_ss_mono(ss,tmp_ratio,0.5)
//	
//				// find crit_ss for ratio-sd
//				tmp_ratio = ratio[p][dpi]-sd[p][dpi]
//				ss_crit[1][dpi] = ccn_find_crit_ss_mono(ss,tmp_ratio,0.5)
//	
//				// find crit_ss for ratio+sd
//				tmp_ratio = ratio[p][dpi]+sd[p][dpi]
//				ss_crit[2][dpi] = ccn_find_crit_ss_mono(ss,tmp_ratio,0.5)
//				
//			endfor	 
//			
//			setdatafolder ::
//		else
//			if (doNormalize)
//				setdatafolder ::
//			endif
//			print ("missing wave(s): " + type + " ... skipping")
//		endif
//		
//	endfor
//	
//	killwaves/Z tmp_ratio
//	setdatafolder sdf
//	
//End


// ** Function: ccn_find_crit_ss_mono **
//
//	Worker funciton to find critical ss based on single ccn/cn ratio curve. Uses spline style fit to find 
//		where function crosses threshhold
//
//	usage: ccn_find_crit_ss_mono(ss,ratio,threshhold)
//		where:
//			ss - wave of supersatuations
// 			ratio - wave of ccn/cn ratios
//			threshhold - point at which to find critical supersaturation (float)
//
//	returns: ss_crit value (float)
// **
Function dev_find_crit_ss_mono(ss,ratio,threshhold)
	wave ss
	wave ratio
	variable threshhold
	
	variable upper_ss, lower_ss
	variable upper_ratio, lower_ratio
	variable th_crossed = 0
	
	lower_ss = ss[0]
	lower_ratio = ratio[0]
	if (lower_ratio > threshhold) 
		return NaN
	endif
	
	variable i
	for (i=1; i<numpnts(ss); i+=1)

		if (numtype(ratio[i])==0)
			if (ratio[i] > threshhold)
				upper_ss = ss[i]
				upper_ratio = ratio[i]
				th_crossed = 1
				break
			else
				lower_ss = ss[i]
				lower_ratio = ratio[i]
			endif
		endif

	endfor
	
	if (!th_crossed)
		return NaN
	endif
	
	// find crit_ss for found limits
	make/o/n=2 tmp_rat = {lower_ratio,upper_ratio}
	wave tmp_rat = tmp_rat
					
	variable index = binarysearchinterp(tmp_rat,threshhold)
	variable crit_ss = lower_ss + ( (upper_ss-lower_ss)*index)
	
	killwaves/Z tmp_rat
	
	return crit_ss			
	
	
End


// ** Function: ccn_mono_plot_kappa **
//
//	Plot kappa values against diameter
//
//	Requires: kappa (mono) values as calculated by ccn_mono_find_kappa
//
//	usage: ccn_mono_plot_kappa(samp_types, normalized, use_error_bars)
//		where:
//			samp_types - string list of sample types (standard delimiter)
// 			normalized - specified ss_crit calculated from normalized data or no (0=false, 1=true)
//			use_error_bars - plot the upper and lower limits of kappa (0=false, 1=true)
// **
Function dev_mono_plot_ss_crit([sample_type_list,flag_list, normalize, error_bars, ranges, dp_range_list])
	string sample_type_list
	string flag_list
	string normalize
	string error_bars
	string ranges
	string dp_range_list // should look like this: dp_range="0;1" which are the index values for the first and last dp to plot as a string list

	variable doNormalize = 0
	if (!ParamIsDefault(normalize))
		if (cmpstr(normalize,"true")==0 || cmpstr(normalize,"yes")==0)
			doNormalize = 1
		endif
	endif

	variable use_error_bars = 0
	if (!ParamIsDefault(error_bars) && (cmpstr(error_bars,"yes")==0 || cmpstr(error_bars,"true")==0) )
		//suffix=""
		use_error_bars = 1
	endif

	variable use_ranges = 0
	if (!ParamIsDefault(ranges) && (cmpstr(ranges,"yes")==0 || cmpstr(ranges,"true")==0) )
		//suffix=""
		use_ranges = 1
	endif
	 
	 // can only select 1, default to error bars if both
	 if (use_error_bars && use_ranges)
	 	use_ranges = 0
	 endif

	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable req_all_flags = 1
	if (ParamIsDefault(flag_list))
		flag_list = "*"
		req_all_flags=0
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss

	wave dp= ccn_mono_dp
	string dp_list = acg_get_wave_as_list(dp)

	if (ParamIsDefault(dp_range_list) )
		dp_range_list = "0;"+num2str(numpnts(dp)-1)
	endif
	make/o/n=2 dp_range_w
	wave dp_range = dp_range_w
	dp_range[0] = str2num(stringfromlist(0,dp_range_list))
	dp_range[1] = str2num(stringfromlist(1,dp_range_list))

	setdatafolder :ss_crit
	if (doNormalize)
		setdatafolder ":normalize"
	endif

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {19,16,17,14,60, 2}

	variable i
	variable curve_cnt = 0

	string legend_str = ""
	string title = ""
	
	for (i=0; i<itemsinlist(sample_type_list); i+=1)
		string sample_type = stringfromlist(i,sample_type_list)
		string crit_list = ccn_find_wavelist_by_par(require_all=req_all_flags,sample_type=sample_type,flag_list=flag_list,filter="ss_crit_st_*")
		
		variable listi
		for (listi=0; listi<itemsinlist(crit_list); listi+=1)
			string wname = stringfromlist(listi,crit_list)
			wave ss_crit = $wname

			if (waveexists($wname)) 
			
//				if (doNormalize)
//					setdatafolder $":normalize"
//				endif
			
				wave w = $wname
				string meta = note(w)
				
				string fl_list = ccn_convert_list_from_map(stringbykey("flag_list",meta))
				if (cmpstr(";",fl_list[strlen(fl_list)-1]) == 0)
					fl_list = fl_list[0,strlen(fl_list)-2]
				endif

				if (curve_cnt ==0)
					display ss_crit[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					if (use_ranges)
						appendtograph ss_crit[1][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
						appendtograph ss_crit[2][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					endif
				else
					appendtograph ss_crit[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					if (use_ranges)
						appendtograph ss_crit[1][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
						appendtograph ss_crit[2][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					endif
				endif

				if (use_error_bars)
					ErrorBars $wname Y, wave=(ss_crit[3][dp_range[0],dp_range[1]] ,ss_crit[4][dp_range[0],dp_range[1]] )
				endif
				
				curve_cnt +=1
			
			
//				variable par_index = -1
//				variable valid_trace = 0
//				if (curve_cnt == 0)
//					valid_trace = 0
//					if (use_dp)
//						par_index = whichlistitem(num2str(dp),dp_list) 
//						if (par_index >= 0)
//							display w[][par_index] vs x_axis
//							valid_trace = 1
//						endif
//					else
//						par_index = whichlistitem(num2str(ss),ss_list) 
//						if (par_index >= 0)
//							display w[par_index][] vs x_axis
//							valid_trace = 1
//						endif
//					endif
//
//					if (!valid_trace)
//						continue
//					endif				
//
//					legend_str += "\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"			
//
//				else
//					valid_trace = 0
//					if (use_dp)
//						par_index = whichlistitem(num2str(dp),dp_list) 
//						if (par_index >= 0)
//							AppendToGraph w[][par_index] vs x_axis
//							valid_trace = 1
//						endif
//					else
//						par_index = whichlistitem(num2str(ss),ss_list) 
//						if (par_index >= 0)
//							AppendToGraph w[par_index][] vs x_axis
//							valid_trace = 1
//						endif
//					endif
//
//					if (!valid_trace)
//						continue
//					endif				
//
//					legend_str += "\r\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"
//
//				endif
//				DelayUpdate
//				ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
//				ModifyGraph marker($wname)=mrk[curve_cnt]
//				SetAxis left 0,1
//				ModifyGraph grid(left)=1
//				ModifyGraph grid=1
//				ModifyGraph gaps($wname)=0
//				//Legend/C/N=text0/H={0,10,10}/A=LT
//				Label left "CCN/CN Ratio"
//				if (use_dp)
//					Label bottom "SS (%)"
//					title = "D\\Bp\\M = " + num2str(dp) + "nm"
//				else
//					Label bottom "D\\Bp\\M (nm)"
//					title = "SS = " + num2str(ss) + "%"
//				endif
//				ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
//				
//				DoUpdate		
				curve_cnt+=1
			endif
		endfor
	endfor		
	
	
//	if (doNormalize)
//		title += " (normalized)"
//	endif
//	TextBox/C/N=text1/H={0,10,10} title
//	Legend/C/N=text0/H={0,10,10}/A=LT legend_str
//	DoUpdate

	setdatafolder sdf

	 
//	variable sti
////	for (sti=0; sti<itemsinlist(samp_types); sti+=1)
//	for (sti=0; sti<10; sti+=1)
//		string type = stringfromlist(sti,samp_types)
//		
//		if ( waveexists($(":ss_crit"+normalize_fld+":ss_crit_"+type)) && waveexists($("ccn_mono_dp")) ) 
//			wave dp = ccn_mono_dp // is this always the name?
//			
//			wave ss_crit = $(":ss_crit"+normalize_fld+":ss_crit_"+type)
//
//			string ss_crit_wn = "ss_crit_"+type
//			
//			if (sti ==0)
//				display ss_crit[0][] vs dp
//				if (use_error_bars)
//					appendtograph ss_crit[1][] vs dp
//					appendtograph ss_crit[2][] vs dp
//				endif
//			else
//				appendtograph ss_crit[0][] vs dp
//				if (use_error_bars)
//					appendtograph ss_crit[1][] vs dp
//					appendtograph ss_crit[2][] vs dp
//				endif
//			endif
//			
//							
//		else
//			print ("missing wave(s): " + type + " ... skipping")
//		endif
//		
//	endfor
//	
//	setdatafolder sdf

End


// ** Function: ccn_mono_find_kappa **
//
//	Calculate kappa values from mono ccn data. 
//
//	Requires: Critical SS values as generated by ccn_mono_find_ss_crit (or ccn_mono_find_ss_crit_wave)
//
//	usage: ccn_mono_find_kappa(samp_types, normalized
//		where:
//			samp_types - string list of sample types (standard delimiter)
// 			normalized - specified ss_crit calculated from normalized data or no (0=false, 1=true)
// **
Function dev_mono_find_kappa([normalize])
	//string samp_types // list of sample types to use (does not have to be full list)
	string normalize // use normalized matrix
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss

	wave dp= ccn_mono_dp
	//wave ss = ccn_mono_ss
	
//	if (ParamIsDefault(samp_type_list))
//		samp_type_list = ""
//	endif

//	if (ParamIsDefault(flag_list))
//		flag_list = ""
//	endif
		
	variable doNormalize = 0
	string fldr_prefix = ""
	if (!ParamIsDefault(normalize) && (cmpstr(normalize,"yes")==0 || cmpstr(normalize,"true")==0) )
		//suffix=""
		doNormalize = 1
		fldr_prefix = ":normalize"
	endif

	setdatafolder :ss_crit
	if (doNormalize)
		setdatafolder $fldr_prefix
	endif
	string ss_crit_sdf = getdataFolder(1)
		
	// find list of waves meeting criteria
	string wlist = acg_get_wave_list(filter=("ss_crit_st_*")) // get list of all param waves
	//string sdlist = replacestring("_st_",wlist,"_sd_st_",1)
	//string sdlist = acg_get_wave_list(filter=(param+"_sd_st_*")) // get list of all sd waves
	variable listi

	if (doNormalize)
		setdatafolder ::
	endif
	setdatafolder ::
	newdataFolder/o/s :kappa_mono
	if (doNormalize) 
		newdatafolder/o/s :normalize
	endif
	string kappa_sdf = getdataFolder(1)

	for (listi=0; listi<itemsinlist(wlist); listi+=1)
		setdatafolder $ss_crit_sdf
		wave ss_crit = $(stringfromlist(listi, wlist))
		//wave sd = $(stringfromlist(listi, sdlist))

		if (dimsize(ss_crit,0) <= 0)
			continue
		endif
		

		setdatafolder $kappa_sdf
		string wn = replacestring("ss_crit", stringfromlist(listi, wlist), "kappa")
		make/o/n=(5,numpnts(dp)) $wn
		wave kappa = $wn
		kappa = NaN
		
		variable dpi
		for (dpi=0; dpi<numpnts(dp); dpi+=1)
					
			// find kappa for ss_crit
			variable ss = ss_crit[0][dpi]
			if (numtype(ss) == 0)
				kappa[0][dpi] = ccn_find_kappa(ss, dp[dpi], 0.073)
			endif

			// find kappa for upper ss_crit
			ss = ss_crit[1][dpi]
			if (numtype(ss) == 0)
				kappa[1][dpi] = ccn_find_kappa(ss, dp[dpi], 0.073)
			endif

			// find kappa for lower ss_crit
			ss = ss_crit[2][dpi]
			if (numtype(ss) == 0)
				kappa[2][dpi] = ccn_find_kappa(ss, dp[dpi], 0.073)
			endif

			// add error bar values for plotting
			kappa[3][dpi] = abs(kappa[1][dpi] - kappa[0][dpi])
			kappa[4][dpi] = abs(kappa[0][dpi] - kappa[2][dpi])
								
		endfor	 

		string kappa_info = note(ss_crit)
		kappa_info = replacestringbykey("wavename",kappa_info,wn)
 		note/k kappa
 		note kappa, kappa_info

	endfor
	
	setdatafolder sdf
	
End


// ** Function: ccn_mono_plot_kappa **
//
//	Plot kappa values against diameter
//
//	Requires: kappa (mono) values as calculated by ccn_mono_find_kappa
//
//	usage: ccn_mono_plot_kappa(samp_types, normalized, use_error_bars)
//		where:
//			samp_types - string list of sample types (standard delimiter)
// 			normalized - specified ss_crit calculated from normalized data or no (0=false, 1=true)
//			use_error_bars - plot the upper and lower limits of kappa (0=false, 1=true)
// **
Function dev_mono_plot_kappa([sample_type_list,flag_list, normalize, error_bars, ranges, dp_range_list])
	string sample_type_list
	string flag_list
	string normalize
	string error_bars
	string ranges
	string dp_range_list // should look like this: dp_range="0;1" which are the index values for the first and last dp to plot as a string list

	variable doNormalize = 0
	if (!ParamIsDefault(normalize))
		if (cmpstr(normalize,"true")==0 || cmpstr(normalize,"yes")==0)
			doNormalize = 1
		endif
	endif

	variable use_error_bars = 0
	if (!ParamIsDefault(error_bars) && (cmpstr(error_bars,"yes")==0 || cmpstr(error_bars,"true")==0) )
		//suffix=""
		use_error_bars = 1
	endif

	variable use_ranges = 0
	if (!ParamIsDefault(ranges) && (cmpstr(ranges,"yes")==0 || cmpstr(ranges,"true")==0) )
		//suffix=""
		use_ranges = 1
	endif
	 
	 // can only select 1, default to error bars if both
	 if (use_error_bars && use_ranges)
	 	use_ranges = 0
	 endif

	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable req_all_flags = 1
	if (ParamIsDefault(flag_list))
		flag_list = "*"
		req_all_flags=0
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss

	wave dp= ccn_mono_dp
	string dp_list = acg_get_wave_as_list(dp)

	if (ParamIsDefault(dp_range_list) )
		dp_range_list = "0;"+num2str(numpnts(dp)-1)
	endif
	make/o/n=2 dp_range_w
	wave dp_range = dp_range_w
	dp_range[0] = str2num(stringfromlist(0,dp_range_list))
	dp_range[1] = str2num(stringfromlist(1,dp_range_list))

	setdatafolder :kappa_mono
	if (doNormalize)
		setdatafolder ":normalize"
	endif

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {19,16,17,14,60, 2}

	variable i
	variable curve_cnt = 0

	string legend_str = ""
	string title = ""
	
	for (i=0; i<itemsinlist(sample_type_list); i+=1)
		string sample_type = stringfromlist(i,sample_type_list)
		string kappa_list = ccn_find_wavelist_by_par(require_all=req_all_flags,sample_type=sample_type,flag_list=flag_list,filter="kappa_st_*")
		
		variable listi
		for (listi=0; listi<itemsinlist(kappa_list); listi+=1)
			string wname = stringfromlist(listi,kappa_list)
			wave kappa = $wname

			if (waveexists($wname)) 
			
//				if (doNormalize)
//					setdatafolder $":normalize"
//				endif
			
				wave w = $wname
				string meta = note(w)
				
				string fl_list = ccn_convert_list_from_map(stringbykey("flag_list",meta))
				if (cmpstr(";",fl_list[strlen(fl_list)-1]) == 0)
					fl_list = fl_list[0,strlen(fl_list)-2]
				endif

				if (curve_cnt ==0)
					display kappa[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					if (use_ranges)
						appendtograph kappa[1][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
						appendtograph kappa[2][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					endif
				else
					appendtograph kappa[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					if (use_ranges)
						appendtograph kappa[1][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
						appendtograph kappa[2][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
					endif
				endif

				if (use_error_bars)
					ErrorBars $wname Y, wave=(kappa[3][dp_range[0],dp_range[1]] ,kappa[4][dp_range[0],dp_range[1]] )
				endif
				
				curve_cnt +=1
			
			
//				variable par_index = -1
//				variable valid_trace = 0
//				if (curve_cnt == 0)
//					valid_trace = 0
//					if (use_dp)
//						par_index = whichlistitem(num2str(dp),dp_list) 
//						if (par_index >= 0)
//							display w[][par_index] vs x_axis
//							valid_trace = 1
//						endif
//					else
//						par_index = whichlistitem(num2str(ss),ss_list) 
//						if (par_index >= 0)
//							display w[par_index][] vs x_axis
//							valid_trace = 1
//						endif
//					endif
//
//					if (!valid_trace)
//						continue
//					endif				
//
//					legend_str += "\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"			
//
//				else
//					valid_trace = 0
//					if (use_dp)
//						par_index = whichlistitem(num2str(dp),dp_list) 
//						if (par_index >= 0)
//							AppendToGraph w[][par_index] vs x_axis
//							valid_trace = 1
//						endif
//					else
//						par_index = whichlistitem(num2str(ss),ss_list) 
//						if (par_index >= 0)
//							AppendToGraph w[par_index][] vs x_axis
//							valid_trace = 1
//						endif
//					endif
//
//					if (!valid_trace)
//						continue
//					endif				
//
//					legend_str += "\r\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"
//
//				endif
//				DelayUpdate
//				ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
//				ModifyGraph marker($wname)=mrk[curve_cnt]
//				SetAxis left 0,1
//				ModifyGraph grid(left)=1
//				ModifyGraph grid=1
//				ModifyGraph gaps($wname)=0
//				//Legend/C/N=text0/H={0,10,10}/A=LT
//				Label left "CCN/CN Ratio"
//				if (use_dp)
//					Label bottom "SS (%)"
//					title = "D\\Bp\\M = " + num2str(dp) + "nm"
//				else
//					Label bottom "D\\Bp\\M (nm)"
//					title = "SS = " + num2str(ss) + "%"
//				endif
//				ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
//				
//				DoUpdate		
				curve_cnt+=1
			endif
		endfor
	endfor		
	
	
//	if (doNormalize)
//		title += " (normalized)"
//	endif
//	TextBox/C/N=text1/H={0,10,10} title
//	Legend/C/N=text0/H={0,10,10}/A=LT legend_str
//	DoUpdate

	setdatafolder sdf

End

// ** Function: ccn_mono_plot_kappa **
//
//	Plot kappa values against diameter
//
//	Requires: kappa (mono) values as calculated by ccn_mono_find_kappa
//
//	usage: ccn_mono_plot_kappa(samp_types, normalized, use_error_bars)
//		where:
//			samp_types - string list of sample types (standard delimiter)
// 			normalized - specified ss_crit calculated from normalized data or no (0=false, 1=true)
//			use_error_bars - plot the upper and lower limits of kappa (0=false, 1=true)
// **
Function dev_mono_plot_kappa_std([sample_type_list,flag_list, error_bars, normalize, dp_range_list])
	string sample_type_list
	string flag_list
	string error_bars
	string normalize
	string dp_range_list // should look like this: dp_range="0;1" which are the index values for the first and last dp to plot as a string list

	variable doNormalize = 0
	if (!ParamIsDefault(normalize))
		if (cmpstr(normalize,"true")==0 || cmpstr(normalize,"yes")==0)
			doNormalize = 1
		endif
	endif

	variable use_error_bars = 0
	if (!ParamIsDefault(error_bars) && (cmpstr(error_bars,"yes")==0 || cmpstr(error_bars,"true")==0) )
		//suffix=""
		use_error_bars = 1
	endif


	if (ParamIsDefault(sample_type_list))
		sample_type_list = ccn_get_samp_type_list_dev(ignore_defaults="true")
	endif

	variable req_all_flags = 1
	if (ParamIsDefault(flag_list))
		flag_list = "*"
		req_all_flags=0
	endif
	
	string sdf = ccn_goto_ccn_folder()
	setdatafolder :dp_v_ss

	wave dp_nm= ccn_mono_dp
	duplicate/o dp_nm ccn_mono_dp_um
	wave dp = ccn_mono_dp_um
	dp /= 1000
	
	//string dp_list = acg_get_wave_as_list(dp)

	if (ParamIsDefault(dp_range_list) )
		dp_range_list = "0;"+num2str(numpnts(dp)-1)
	endif
	make/o/n=2 dp_range_w
	wave dp_range = dp_range_w
	dp_range[0] = str2num(stringfromlist(0,dp_range_list))
	dp_range[1] = str2num(stringfromlist(1,dp_range_list))

	setdatafolder :ss_crit
	if (doNormalize)
		setdatafolder ":normalize"
	endif

	make/o/n=(3,6) rgb_values
	wave colors = rgb_values // light gray, red, blue, green, orange, black
	colors = { {62720,0,3840}, {0,15872,65280}, {0,39168,0}, {65280,43520,0}, {0,0,0}, {39168,39168,39168} }
	
	make/o/n=6 marker_values
	wave mrk = marker_values // asterisk, circle, square, triangle(up), hourglass triangle, 4pt star
	mrk = {19,16,17,14,60, 2}

	variable i
	variable curve_cnt = 0

	string legend_str = ""
	string title = "Kappa"
	
	// generate standard plot
	ccn_make_standard_kappa_plot()
	 	
	for (i=0; i<itemsinlist(sample_type_list); i+=1)
		string sample_type = stringfromlist(i,sample_type_list)
		string crit_list = ccn_find_wavelist_by_par(require_all=req_all_flags,sample_type=sample_type,flag_list=flag_list,filter="ss_crit_st_*")
		
		variable listi
		for (listi=0; listi<itemsinlist(crit_list); listi+=1)
			string wname = stringfromlist(listi,crit_list)
			wave ss_crit = $wname

			if (waveexists($wname)) 
			
//				if (doNormalize)
//					setdatafolder $":normalize"
//				endif
			
				wave w = $wname
				string meta = note(w)
				
				string fl_list = ccn_convert_list_from_map(stringbykey("flag_list",meta))
				if (cmpstr(";",fl_list[strlen(fl_list)-1]) == 0)
					fl_list = fl_list[0,strlen(fl_list)-2]
				endif

				appendtograph ss_crit[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
				if (use_error_bars)
					ErrorBars $wname Y, wave=(ss_crit[3][dp_range[0],dp_range[1]] ,ss_crit[4][dp_range[0],dp_range[1]] )
				endif
				
//				if (curve_cnt ==0)
//					display ss_crit[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
//					if (use_error_bars)
//						appendtograph ss_crit[1][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
//						appendtograph ss_crit[2][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
//					endif
//				else
//					appendtograph ss_crit[0][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
//					if (use_error_bars)
//						appendtograph ss_crit[1][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
//						appendtograph ss_crit[2][dp_range[0],dp_range[1]] vs dp[dp_range[0],dp_range[1]]
//					endif
//				endif			
			
//				variable par_index = -1
//				variable valid_trace = 0
				if (curve_cnt == 0)
//					valid_trace = 0
//					if (use_dp)
//						par_index = whichlistitem(num2str(dp),dp_list) 
//						if (par_index >= 0)
//							display w[][par_index] vs x_axis
//							valid_trace = 1
//						endif
//					else
//						par_index = whichlistitem(num2str(ss),ss_list) 
//						if (par_index >= 0)
//							display w[par_index][] vs x_axis
//							valid_trace = 1
//						endif
//					endif

//					if (!valid_trace)
//						continue
//					endif				

					//legend_str += "\s(#"+num2str(curve_cnt)+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"			
					legend_str += "\s("+wname+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"			
//		\s(ss_crit_st_2_fl_0) ss_crit_st_2_fl_0[0][0,1]
				else
//					valid_trace = 0
//					if (use_dp)
//						par_index = whichlistitem(num2str(dp),dp_list) 
//						if (par_index >= 0)
//							AppendToGraph w[][par_index] vs x_axis
//							valid_trace = 1
//						endif
//					else
//						par_index = whichlistitem(num2str(ss),ss_list) 
//						if (par_index >= 0)
//							AppendToGraph w[par_index][] vs x_axis
//							valid_trace = 1
//						endif
//					endif
//
//					if (!valid_trace)
//						continue
//					endif				
//
					legend_str += "\r\s("+wname+") " + stringbykey("sample_type",meta) + " ("+fl_list+")"

				endif
//				DelayUpdate
//				ModifyGraph mode=4,rgb($wname)=(colors[0][curve_cnt],colors[1][curve_cnt],colors[2][curve_cnt])
//				ModifyGraph marker($wname)=mrk[curve_cnt]
//				SetAxis left 0,1
//				ModifyGraph grid(left)=1
//				ModifyGraph grid=1
//				ModifyGraph gaps($wname)=0
//				//Legend/C/N=text0/H={0,10,10}/A=LT
//				Label left "CCN/CN Ratio"
//				if (use_dp)
//					Label bottom "SS (%)"
//					title = "D\\Bp\\M = " + num2str(dp) + "nm"
//				else
//					Label bottom "D\\Bp\\M (nm)"
//					title = "SS = " + num2str(ss) + "%"
//				endif
//				ErrorBars $wname Y,wave=(w_sd[*],w_sd[*])
//				
//				DoUpdate		
				curve_cnt+=1
			endif
		endfor
	endfor		
	
	
	if (doNormalize)
		title += " (normalized)"
	endif
	TextBox/C/N=text1/H={0,10,10} title
	Legend/C/N=text0/H={0,10,10}/A=LT legend_str
	DoUpdate

	setdatafolder sdf	 

End


// Not a general function yet
Function dev_merge_ts()
	
	string flag = "TH_DENUDER_UNHEATED"
	
	
	
	string dt_list = acg_get_wlist_from_folder("root:ccn:ss_time_series:spectra:",  filter_str="dt_ts_*_"+flag+"*")
	string ss_list = ""
	variable wl
	variable listi
	for (listi=0; listi < itemsinlist(dt_list); listi+=1)
		string s = stringfromlist(listi, dt_list)
		if (listi == 0)
			wl = numpnts($s)
			duplicate/o $s, $("dt_ts_"+flag)
		else
			if (numpnts($s) != wl)
				print s, wl, "not the same length"
			endif
		endif
		string ss1 = stringfromlist(2, s, "_")
		string ss2 = stringfromlist(3, s, "_")
		ss_list = addlistitem(ss1+"."+ss2, ss_list, ";", Inf)
	endfor
	
	make/o/n=(wl) $("cn_ts_"+flag)	,  $("ccn_ts_"+flag)	,  $("ratio_ts_"+flag)
	wave dt = $("dt_ts_"+flag)
	wave cn = $("cn_ts_"+flag)
	cn = NaN
	wave ccn = $("ccn_ts_"+flag)
	ccn = NaN
	wave ratio = $("ratio_ts_"+flag)
	ratio = NaN

	ss_list = SortList(ss_list)
	
	duplicate/o ratio, $("ss_ts_"+flag)
	wave ss = $("ss_ts_"+flag)
	for (listi=0; listi<itemsinlist(ss_list); listi+=1)
		s = stringfromlist(listi, ss_list)
		variable ss_val = str2num(s)
		s = replacestring(".", s, "_")
		
		wave ss_dt = $("dt_ts_"+s+"_"+flag+"_")
		wave ss_cn = $("cn_ts_"+s+"_"+flag+"_")
		wave ss_ccn = $("ccn_ts_"+s+"_"+flag+"_")
		wave ss_ratio = $("ratio_ts_"+s+"_"+flag+"_")

		variable i
		for (i=0; i<numpnts(dt); i+=1)
			if (numtype(ss_cn[i]) == 0)
				cn[i] = ss_cn[i]
				ss[i] = ss_val // repeat in case any are missing
			endif
			if (numtype(ss_ccn[i]) == 0)
				ccn[i] = ss_ccn[i]
				ss[i] = ss_val
			endif
			if (numtype(ss_ratio[i]) == 0)
				ratio[i] = ss_ratio[i]
				ss[i] = ss_val
			endif

		endfor
	endfor 

End