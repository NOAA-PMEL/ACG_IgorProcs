#pragma rtGlobals=3		// Use modern global access method and strict wave access.

//strconstant 
//strconstant APP_REGISTRY = 

Menu "ACG Data"
	submenu "ACG DB"
		submenu "Database"
			"Create DB", db_create_database()
			"Set active DB", db_set_active_db()
			"-"
			"Add data source",db_add_data_src()
		end
		submenu "Datasets"
			"Create Dataset", db_create_dataset()
			"Set active Dataset", db_set_active_ds()
			"Delete Dataset", db_delete_dataset()
		end
	end
end

Menu "GraphMarquee"
	"-"
	"Add to current dataset", db_add_to_ds_marquee(1,0)
	"Add to dataset...", db_add_to_ds_marquee(0,0)
//	submenu "Add with metadata..."
//		"Add to current dataset", db_add_to_ds_marquee(1,1)
//		"Add to dataset...", db_add_to_ds_marquee(0,1)
//	end
End

Function/S db_goto_acgdb_pkg()

	string sdf = acg_goto_acg_packages()
	
	if (!datafolderexists("acgdb"))
		db_init_pkg()
	endif
	
	setdatafolder :acgdb
	
	return sdf
End

Function db_init_pkg()

	string sdf = acg_goto_acg_packages()
		
	if (!datafolderexists("acgdb"))
		newdatafolder/o/s :acgdb			
		
	endif
	
	setdatafolder sdf
End	
	

//		String/G load_datafolder_list = "<new data folder>"
//		variable/G load_datafolder_index = 0
//		variable/G last_avgtime = 60
//		variable/G last_timebase = 300
//		variable/G concat_do_avg_flag = 0
//	else
//		setdatafolder root:gui
//		if (exists("last_timebase") != 2)
//			variable/G last_timebase = 300
//		elseif (exists("concat_do_avg_flag") != 2)
//			variable/G concat_do_avg_flag = 0	
//		endif	
//	endif
//
//	newdatafolder/o $acg_toAverage_folder
//	newdatafolder/o $acg_toTimeBase_folder
//	newdatafolder/o $acg_toConcat_folder
//	
//	setdatafolder sdf
//End


Function db_init()
	dfref sdf = getdatafolderDFR()
	
	
	db_init_pkg()
	
	setdatafolder root:
	
	if (!datafolderexists("acgdb"))
		newdatafolder/o/s acgdb
		newdatafolder/o/s acgdb
		string/G active_db = ""
		string/G db_list = ""
	endif
	
	setdatafolder sdf		
End

Function/S db_goto_db_folder()
	
	string sdf = getdatafolder(1)

	db_init()

	setdatafolder root:acgdb
	return sdf
End

Function db_create_database([name,activate])
	string name // new database name
	variable activate // create and set new db as "active"

	string sdf
	
	if (ParamIsDefault(name)) // prompt user for name using ProjectName as default
		sdf = acg_goto_ProjectInfo()
		nvar proj_is_set = this_project_is_set
		name = ""
		if (proj_is_set)
			svar info = this_project_info
			name = stringbykey("NAME",info)
		endif
		setdatafolder sdf
	endif
	
	Prompt name, "Database name: "
	DoPrompt "Create New Database", name
	if (V_Flag)
		print "create database canceled!"
		return 0
	endif
	
	sdf = db_goto_db_folder()
	
	svar db_list = :acgdb:db_list
	svar active_db = :acgdb:active_db
	
	if (whichlistitem(name,db_list) < 0)
		db_list = addlistitem(name,db_list,";",Inf)
		newdatafolder/s $name
		newdatafolder/s acgdb
		string/G active_ds = ""
		string/G ds_list = ""

	endif
	
	
	if (ParamIsDefault(activate)) // set as active
		db_set_active_db(name=name)
	endif

	setdatafolder sdf	
End

Function/S db_get_active_db()

	//dfref sdf = getdatafolderDFR()
	svar active = root:acgdb:acgdb:active_db	
	return active
	//setdatafolder sdf
End

Function/S db_goto_active_db()
	string sdf = db_goto_db_folder()
	setdatafolder $(db_get_active_db())
	return sdf
End

Function db_set_active_db([name])
	string name // specified db name to make active and goto

	string sdf = db_goto_db_folder()
	svar db_list = :acgdb:db_list
	svar active_db = :acgdb:active_db
	variable menu_item = whichlistitem(active_db,db_list)+1
	
	if (ParamIsDefault(name)) // set db as active database
		Prompt menu_item, "Activate DB: ",popup, db_list
		DoPrompt "Activate Database", menu_item
		if (V_Flag)
			print "canceled!"
			return 0									// user canceled
		endif
		
		active_db = stringfromlist(menu_item-1,db_list)
		
	else
	
		variable sel_item = whichlistitem(name,db_list)
		string alert = "Could not activate " + name + ". Not a valid database"
		if (sel_item < 0)
			DoAlert/T="DB Not found!" 0, alert
		endif
		active_db = stringfromlist(sel_item,db_list)
	endif

	
End

Function db_remove_db()

	// still to do

End

Function db_create_dataset([name,activate])
	string name
	variable activate

	string sdf = db_goto_active_db()
	
	if (ParamIsDefault(name)) // 
		name = ""
		Prompt name, "Database name: "
		DoPrompt "Create New Database", name
		if (V_Flag)
			print "create database canceled!"
			return 0
		endif
	endif
	
	svar ds_list = :acgdb:ds_list
	svar active_ds = :acgdb:active_ds

	if (whichlistitem(name,ds_list) < 0 && cmpstr(name,"")!=0)
		ds_list = addlistitem(name,ds_list,";",Inf)
		newdatafolder/s $name
		// make/o/n=(0,??) dataset
		//newdatafolder/s acgdb
		//string/G active_ds = ""
		//string/G ds_list = ""

		db_create_dataset_files__()
	endif
	
	
	if (ParamIsDefault(activate)) // set as active
		db_set_active_ds(name=name)
	endif

	return 1

End


// Private Function
//
//    assumes in proper folder
Function db_create_dataset_files__()

	// create main dataset wave
	make/D/o/n=(0,3) dataset  // columns: 0=id, 1=start time, 2=stop time
	
	// create metadata wave
	make/T/o/n=(0,3) dataset_meta // columns: 0=id, 1=TAG NAME 2=TAG VALUE
	
End

End

Function/S db_get_active_ds()

	//dfref sdf = getdatafolderDFR()
	string sfd = db_goto_active_db()
	svar active = :acgdb:active_ds	
	return active
	setdatafolder sdf
End

Function/S db_ds_list()

	//dfref sdf = getdatafolderDFR()
	string sfd = db_goto_active_db()
	svar list = :acgdb:ds_list
	return list
	setdatafolder sdf
End

Function db_set_active_ds([name])
	string name // specified db name to make active and goto

	string sdf =db_goto_active_db()
	svar ds_list = :acgdb:ds_list
	svar active_ds = :acgdb:active_ds
	variable menu_item = whichlistitem(active_ds,ds_list)+1
	
	if (ParamIsDefault(name)) // set ds as active dataset
		Prompt menu_item, "Activate Dataset: ",popup, ds_list
		DoPrompt "Activate Dataset", menu_item
		if (V_Flag)
			print "canceled!"
			return 0									// user canceled
		endif
		
		active_ds = stringfromlist(menu_item-1,ds_list)
		
	else
	
		variable sel_item = whichlistitem(name,ds_list)
		string alert = "Could not activate " + name + ". Not a valid dataset"
		if (sel_item < 0)
			DoAlert/T="Dataset Not found!" 0, alert
		endif
		active_ds = stringfromlist(sel_item,ds_list)
	endif
	
End

Function db_add_to_active_dataset(ds_entry)
	wave ds_entry
	
	db_add_to_dataset(ds_entry,dset=db_get_active_ds())

End

Function db_add_to_dataset(ds_entry,[dset])
	wave ds_entry
	string dset
	
	string sdf = db_goto_active_db()
	svar ds_list = :acgdb:ds_list
	svar active_ds = :acgdb:active_ds
	
	if (ParamIsDefault(dset)) // set ds as active dataset
	
		if (itemsinlist(ds_list) == 0)
			db_create_dataset()
			dset = active_ds
		else
	
			//svar ds_list = root:db:dset_list
			//nvar last_ds = root:db:last_dset
			variable menu_item = whichlistitem(active_ds,ds_list)+2
			string ds_menu_list = ds_list
			ds_menu_list = addlistitem("Create new dataset...",ds_menu_list)
			
			Prompt menu_item, "DataSet",popup, ds_menu_list
			DoPrompt "Dataset List", menu_item
			if (V_Flag)
				print "canceled!"
				return 0									// user canceled
			endif
			//print "dset = ", dset
			if (menu_item == 1)
				if (!db_create_dataset())
					print "canceled - entry not added"
					return 0
				endif
				dset = active_ds
			else
				
				dset = stringfromlist(menu_item-1,ds_menu_list)
				
			endif
		endif
	
	else
		if (whichlistitem(dset,ds_list) < 0) // not a valid dataset...create
			db_create_dataset(name=dset)
		endif
	endif		

//	print dset
//	print active_ds
//	print ds_list

	db_update_ds__(dset,ds_entry)

//	print "using dataset: " + stringfromlist(dset-1,ds_list)
//	last_ds = dset
//	// wave $stringfromlist(dset, ds_list)

End

Function/S db_goto_cache_dir()

	string sdf = db_goto_active_db()
	newdatafolder/o/s :cache
	
	return sdf
End

Function/WAVE db_get_tmp_wave(base,xdim,ydim)
	string base
	variable xdim
	variable ydim
	
	string sdf = db_goto_cache_dir()
	
	string wname = uniquename(base,1,0)
	if (ydim>0)
		make/n=(xdim,ydim) $wname
		//return $wname
	else
		make/n=(xdim) $wname
		//return $wname
	endif
	
	wave tmp = $wname	
	setdatafolder sdf
	return tmp
	
End

Function/WAVE db_get_ds_ids([dataset])
	string dataset
	
	string sdf = getdatafolder(1)
	
	if (!ParamIsDefault(dataset))
		db_set_active_ds(name=dataset)
	else
		dataset = db_get_active_ds()
	endif
	
	db_goto_active_ds()
	
	wave ds = :dataset // get working dataset wave
	wave ids = db_get_tmp_wave(dataset,dimsize(ds,0),0) // get a unique/tmp wave
	
	ids = ds[p][0]
	
	setdatafolder sdf
	
	return ids
End

Function/S db_get_ids_string([dataset])
	string dataset
	
	string args = ""
	if (ParamIsDefault(dataset))
		dataset=db_get_active_ds()
	endif
	wave ids = db_get_ds_ids(dataset=dataset)
	
	variable i
	string ids_string = ""
	for (i=0; i<dimsize(ids,0); i+=1)
		ids_string = addlistitem(num2str(ids[i]),ids_string,";",Inf)
	endfor
	killwaves/Z ids
	return ids_string
End

Function/S db_get_ds_meta(id, type)
	variable id
	string type

	string sdf = db_goto_active_ds()
	wave/T meta = :dataset_meta
	setdatafolder sdf
	
	string key = ""
	if (cmpstr(type,"name")==0)
		key = "DS_ENTRY_NAME"
	elseif (cmpstr(type,"note")==0)
		key = "DS_ENTRY_NOTE"
	else
		return ""
	endif
	
	variable i
	for (i=0; i<dimsize(meta,0); i+=1)
		if (str2num(meta[i][0])==id && cmpstr(meta[i][1], key)==0)
			return meta[i][2]
		endif
	endfor
	
	return ""
End

 Function/WAVE db_get_ds_entry(id) // maybe add option to change datasets later
	variable id
 	
 	//create cache directory where unique entry waves are created and returned. User should killwaves
     	//	but need a method to "clean up"
	
	string sdf = db_goto_active_ds()
	wave ds = :dataset
	
	string base = "entry"
	wave entry = db_get_tmp_wave(base,dimsize(ds,1),0)
	variable row = db_find_row_by_id__(ds,id)
	if (row <0)
		return $""
	endif
	
	entry = ds[row][p]
	
	setdatafolder sdf
	return entry
End
	
Function db_get_ds_entry_start_dt(id)	
	variable id
	
	wave entry = db_get_ds_entry(id)
	if (cmpstr(nameofwave(entry),"")==0)
		print "NULL!"
		return -1
	endif
	variable dt = entry[1]
	killwaves/Z entry
	return dt	
End 

Function db_get_ds_entry_stop_dt(id)	
	variable id
	
	wave entry = db_get_ds_entry(id)
	if (cmpstr(nameofwave(entry),"")==0)
		print "NULL!"
		return -1
	endif
	variable dt = entry[2]
	killwaves/Z entry
	return dt	
End 

Function db_update_ds__(ds_name, entry)
	string ds_name
	wave entry

	if (!waveexists(entry))
		print "invalid entry"
		return 0
	endif
	
	setdatafolder ds_name
	wave ds = dataset
	wave/T meta = dataset_meta

	variable row = -1
	if (numtype(entry[0])!=0 || entry[0] < 0) // new entry
	
		entry[0] = db_get_new_id__(ds)
		
		variable cnt = dimsize(ds,0)
		variable cols = dimsize(ds,1)
		redimension/n=(cnt+1,cols) ds
		row = cnt
		ds[row][0] = entry[0]
	else
		
		row = db_find_row_by_id__(ds,entry[0])
	endif
	
	ds[row][1] = entry[1]
	ds[row][2] = entry[2]
	
	// update metadata
	db_update_ds_meta__(meta,entry)
	
	setdatafolder ::
End

Function db_update_ds_meta__(meta, entry)
	wave/T meta
	wave entry
	
	string ms = note(entry)
	
	if (cmpstr(ms,"") == 0)
		return 0
	endif
	
	variable id = entry[0]
		
	variable i,j
	for (i=0; i<itemsinlist(ms); i+=1)
	
		string t = stringfromlist(i,ms)
		string key = stringfromlist(0,t,":")
		string val = stringfromlist(1,t,":")
		
		db_set_meta_tag__(meta,id,key,val)
	endfor
		
	
End

Function/S db_goto_datasource(name)
	string name

	string sdf = db_goto_active_ds()
	newdatafolder/o/s $name

	return sdf
End

Function/S db_goto_active_ds()
	
	string sdf = db_goto_active_db()
	setdatafolder db_get_active_ds()
	
	return sdf
	
End

Function/WAVE db_get_ds_start_wave([dataset])
	string dataset
	
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
	else
		db_set_active_ds(name=dataset)
	endif
	
	db_goto_active_ds()
	
	//wave 
	
	setdatafolder sdf
	
End

Function db_get_new_id__(ds)
	wave ds

	if (dimsize(ds,0) == 0)
		return 1
	endif
	
	make/o/n=(dimsize(ds,0)) col
	wave w = col
	w = ds[p][0]
	
	wavestats/Q/Z w
	variable id = V_max+1
	killwaves/Z w
	return id
	
End

Function db_find_row_by_id__(ds,id)
	wave ds
	variable id
	
	variable row
	for (row=0; row<dimsize(ds,0); row+=1)
		if (ds[row][0] == id)
			return row
		endif
	endfor
	return -1
End

Function db_set_meta_tag__(meta,id,key,val)
	wave/T meta
	variable id
	string key
	string val
	
	variable row = db_find_row_by_idandkey__(meta,id,key)
	if (row < 0)
		variable cnt = dimsize(meta,0)
		variable cols = dimsize(meta,1)
		redimension/n=(cnt+1,cols) meta
		
		row = cnt
		meta[row][0] = num2str(id)
		meta[row][1] = key
	endif
	
	meta[row][2] = val	

End

Function db_find_row_by_idandkey__(meta,id,key)
	wave/T meta
	variable id
	string key
	
	string id_string = num2str(id)
	
	variable row
	for (row=0; row<dimsize(meta,0); row+=1)
		if (cmpstr(meta[row][0],id_string)==0 && cmpstr(meta[row][1],key)==0)
			return row
		endif
	endfor
	return -1
End

Function test_add()

	make/o/n=3 entry
	db_add_to_dataset(entry)
	killwaves/Z entry
End

Function db_delete_dataset([name])
	string name
	
	string sdf =db_goto_active_db()
	svar ds_list = :acgdb:ds_list
	svar active_ds = :acgdb:active_ds
	variable menu_item = whichlistitem(active_ds,ds_list)+1
	
	if (ParamIsDefault(name)) // select dataset to delete
		Prompt menu_item, "Delete Dataset: ",popup, ds_list
		DoPrompt "Delete Dataset", menu_item
		if (V_Flag)
			print "canceled!"
			return 0									// user canceled
		endif
		
		name = stringfromlist(menu_item-1,ds_list)
	
	endif
	
	
	variable sel_item = whichlistitem(name,ds_list)
	string alert
	if (sel_item < 0)
		alert = "Could not find " + name + ". Not a valid dataset"
		DoAlert/T="Dataset Not found!" 0, alert
		return 0
	endif
	
	alert = "        *** WARNING ***\r   All dataset data will be lost.\r Are you sure you want to delete?"
	DoAlert/T="*** DELETE Dataset ***" 1, alert
	if (V_flag == 1)
		ds_list = removefromlist(name,ds_list)
		killdatafolder/Z name
		if (V_flag > 0) // error deleting folder, rename
			newdatafolder/o :trash
			string newdf
			variable go = 1
			variable i = 0
			do
				newdf = ":trash:"+name + "_"+num2str(i)
				if (datafolderexists(newdf))
					i +=1
				else
					go = 0
				endif
			while(go)
			movedatafolder name, newdf
		endif		
	endif
		
End

Function db_edit_entry(ds_entry, [show_dialog])
	wave ds_entry
	variable show_dialog

	string db
	string dataset
	variable start_dt = db_entry_get_start_dt(ds_entry)
	variable stop_dt = db_entry_get_stop_dt(ds_entry)
	
	if (ParamIsDefault(show_dialog))
		show_dialog = 1
	endif
	
	string start_str = secs2date(start_dt,-2) + " " + secs2time(start_dt,3)
	string stop_str = secs2date(stop_dt,-2) + " " + secs2time(stop_dt,3)


//	if (!ParamIsDefault(db)) // set active dataset
//		db_set_active_db(name=db)
//	endif
//
//	string dset = db_get_active_ds()
//	if (!ParamIsDefault(dataset)) // set active dataset
//		dset = dataset
//	endif
//	string dset_list = db_ds_list()	
	
	string name = db_entry_get_name(ds_entry)
	string enote = db_entry_get_note(ds_entry)
	
	if (show_dialog)
		prompt start_str, "Start time: (YYYY-MM-DD HH:mm:ss) "
		prompt stop_str, "Stop time: (YYYY-MM-DD HH:mm:ss) "
		prompt name, "Entry name (optional)" 
		prompt enote, "Note (optional) "
		DoPrompt "Edit dataset entry", start_str,stop_str,name,enote
		if (V_flag)
			return 0
		endif
	endif
		
	db_entry_update_timestrings(ds_entry,start_str,stop_str)
	db_entry_set_name(ds_entry,name)
	db_entry_set_note(ds_entry,enote)
	
End

Function db_add_to_ds_marquee(use_current,add_meta)
	variable use_current //1 = yes, 0 = let user select
	variable add_meta // 1 = yes, 0=no
	
	GetMarquee/K/Z bottom

	if (V_flag==0)
		// not a graph
		print "Not a graph..."
		return 0
	endif
	
	variable left = V_left
	variable right = V_right
	print "left = " + num2str(left) + " --> " + secs2date(left,-2) + " " + secs2time(left,3)
	print "right = " + num2str(right) + " --> " + secs2date(right,-2) + " " + secs2time(right,3)
	
	wave entry = db_create_entry(left,right)
	db_edit_entry(entry)
	
//	if (add_meta)
//		string name = ""
//		string enote = ""
//		Prompt name, "Entry name: "
//		Prompt enote, "Entry note: "
//		DoPrompt "DB Entry Metadata", name, enote
//		if (!V_Flag)
//			db_entry_set_name(entry, name)
//			db_entry_set_note(entry,enote)							
//		endif
//	endif

	if (use_current)
		db_add_to_active_dataset(entry)
	else
		db_add_to_dataset(entry)
	endif
	killwaves/Z entry
End

Function db_add_to_ds_waves(start_dt, stop_dt, use_current, [show_dialog])
	wave start_dt
	wave stop_dt
	variable use_current //1 = yes, 0 = let user select
	variable show_dialog  // defaults to true(1)
	
	if (ParamIsDefault(show_dialog))
		show_dialog = 1
	endif
	
	variable i
	for (i=0; i<numpnts(start_dt); i+=1)
//	for (i=0; i<2; i+=1)
//	for (i=2; i<numpnts(start_dt); i+=1)
//		print start_dt[i], stop_dt[i]
		wave entry = db_create_entry(start_dt[i], stop_dt[i])
//		print entry
		db_edit_entry(entry, show_dialog=show_dialog)

		if (use_current)
			db_add_to_active_dataset(entry)
		else
			db_add_to_dataset(entry)
		endif
	
		killwaves/Z entry
	endfor
	
End

Function/WAVE db_create_entry(start_dt,stop_dt)
	variable start_dt
	variable stop_dt
	
	// Changed to make wave double precision for times
	make/D/o/n=3 db_entry
	wave entry = db_entry
	entry[0] = -1           // unknown id - needs to be computed
	entry[1] = start_dt
	entry[2] = stop_dt
	return entry
End

// helper function to simply update using strings
//    time_str format: YYYY-MM-DD HH:mm:ss          <-- 24 hour time 
Function db_entry_update_timestrings(entry,start_str,stop_str)
	wave entry
	string start_str
	string stop_str
	
	// start
	string date_part = stringfromlist(0,start_str," ")
	string time_part = stringfromlist(1,start_str," ")
	
	variable start_dt = date2secs(str2num(stringfromlist(0,date_part,"-")),str2num(stringfromlist(1,date_part,"-")),str2num(stringfromlist(2,date_part,"-")))
	start_dt += str2num(stringfromlist(0,time_part,":"))*60*60 + str2num(stringfromlist(1,time_part,":"))*60 + str2num(stringfromlist(2,time_part,":"))

	// stop
	date_part = stringfromlist(0,stop_str," ")
	time_part = stringfromlist(1,stop_str," ")
	
	variable stop_dt = date2secs(str2num(stringfromlist(0,date_part,"-")),str2num(stringfromlist(1,date_part,"-")),str2num(stringfromlist(2,date_part,"-")))
	stop_dt += str2num(stringfromlist(0,time_part,":"))*60*60 + str2num(stringfromlist(1,time_part,":"))*60 + str2num(stringfromlist(2,time_part,":"))

	db_entry_update_times(entry,start_dt,stop_dt)
	
End


//Function test_dt_stuff()	
//	string start_str
//	variable now = datetime
//	start_str = secs2date(now,-2) + " " + secs2time(now,3)
//	print "start_str = " , start_str
//	
//	// start
//	string date_part = stringfromlist(0,start_str," ")
//	string time_part = stringfromlist(1,start_str," ")
//	
//	variable start_dt = date2secs(str2num(stringfromlist(0,date_part,"-")),str2num(stringfromlist(1,date_part,"-")),str2num(stringfromlist(2,date_part,"-")))
//	start_dt += str2num(stringfromlist(0,time_part,":"))*60*60 + str2num(stringfromlist(1,time_part,":"))*60 + str2num(stringfromlist(2,time_part,":"))
//	
//	print "start_dt ", start_dt, " start_dt->str ",  secs2date(start_dt,-2) + " " + secs2time(start_dt,3)
//	
//End

Function db_entry_update_times(entry,start_dt,stop_dt)
	wave entry
	variable start_dt
	variable stop_dt
	
	entry[1] = start_dt
	entry[2] = stop_dt
	
End

Function db_entry_get_start_dt(entry)
	wave entry
	
	return entry[1]

End

Function db_entry_get_stop_dt(entry)
	wave entry 
	
	return entry[2]

End


Function db_entry_set_metadata(entry,key,value)
	wave entry
	string key
	string value
	
	string meta = note(entry)
	note/K entry
	meta = replacestringbykey(key,meta,value)
	note entry, meta
	
End

Function/S db_entry_get_metadata(entry, key)
	wave entry
	string key
	
	string meta = note(entry)
	return stringbykey(key,meta)
End

Function db_entry_set_name(entry,name)
	wave entry
	string name
	
	db_entry_set_metadata(entry,"DS_ENTRY_NAME",name)
End

Function/S db_entry_get_name(entry)
	wave entry
	
	return db_entry_get_metadata(entry,"DS_ENTRY_NAME")
End

Function db_entry_set_note(entry,note)
	wave entry
	string note
	
	db_entry_set_metadata(entry,"DS_ENTRY_NOTE",note)
End

Function/S db_entry_get_note(entry)
	wave entry
	
	return db_entry_get_metadata(entry,"DS_ENTRY_NOTE")
End

Function db_init_datasources()
	string sdf = db_goto_active_db()
	
	string src_table = "data_sources"
	if (!waveexists($src_table))
		make/T/n=(0,6) $src_table  // columns: 0=data label, 1=full path to src wave, 2=map of dim wnames, 3=data type, 4=last update dt, 5=data src last update time
	endif

	setdatafolder sdf		
End

Function db_update_datasource__(data,[name,dims,data_type])
	string data
	string name  // label
	string dims
	string data_type
	
	if (!waveexists($data))
		print "Not a valid datasource wave!"
		return 0
	endif
	
	
	string sdf = db_goto_active_db()
	
	db_init_datasources()
	
	string src_table = "data_sources"
//	if (!waveexists($src_table))
//		make/T/n=(0,6) $src_table  // columns: 0=data label, 1=full path to src wave, 2=map of dim wnames, 3=data type, 4=last update dt, 5=data src last update time
//	endif
	wave/T sources = $src_table
	
	// what to do if already in table? For now, just check last update times....if changed, update
	variable index = db_find_datasource__(sources,data)
	if (index >= 0)
		
		if (!ParamIsDefault(name)) // update name
			
			name = db_get_unique_srclabel__(sources, data, name)
			if (cmpstr(name,"") == 0)
				print "add datasource canceled!"
				return 0
			endif
			sources[index][0] = name
		endif

		if (!ParamIsDefault(dims)) // update dims
			string src_dims = sources[index][1]
			string keys = db_get_srcdim_keys__(dims)
			
			variable i
			for (i=0; i<itemsinlist(keys); i+=1)
				string key = stringfromlist(i,keys)
				string val = db_get_srcdim__(dims,key)
				src_dims = db_set_srcdim__(dims,key,val)	
			endfor
			sources[index][2] = src_dims
		endif

		if (!ParamIsDefault(data_type)) // update data_type
			
			sources[index][3] = data_type
		endif
		
				
		wave dat = $data
		string info = waveinfo(dat,0)
		string modtime = stringbykey("MODTIME",info)
		if (cmpstr(sources[index][4],modtime) != 0)
			sources[index][4] = num2istr(datetime)
			sources[index][5] = modtime
		endif
	else
	

		name = db_get_unique_srclabel__(sources, data, "")
		if (cmpstr(name,"") == 0)
			print "add datasource canceled!"
			return 0
		endif
		
		// add new datasource
		variable cnt = dimsize(sources,0)
		variable cols = dimsize(sources,1)
		
		redimension/n=(cnt+1,cols) sources
		
		// add label
		sources[cnt][0] = name
		
		// full path to source wave
		sources[cnt][1] = data
		
		// Dimension map
		if (ParamIsDefault(dims)) // set to default dim(s)
			dims = db_set_srcdim__("","DATETIME","")
		endif
		sources[cnt][2] = dims
		
		// Data type/class
		if (ParamIsDefault(data_type)) // set to default type
			data_type = "default"
		endif
		sources[cnt][3] = data_type
		
		// last update / modtime - dataset
		sources[cnt][4] = num2istr(datetime)
		
		// last update / modtime - data source	
		wave dat = $data
		sources[cnt][5] = stringbykey("MODTIME",waveinfo(dat,0))
	
	endif
		
	setdatafolder sdf

End

Function db_find_datasource__(sources,data)
	wave/T sources
	string data
	
	// search on full path
	variable index
	for (index=0; index<dimsize(sources,0); index+=1)
		if (cmpstr(sources[index][1],data)==0)
			return index
		endif
	endfor
	return -1 // not found
End

Function db_find_datasource_by_label__(sources,name)
	wave/T sources
	string name
	
	// search on label
	variable index
	for (index=0; index<dimsize(sources,0); index+=1)
		if (cmpstr(sources[index][0],name)==0)
			return index
		endif
	endfor
	return -1 // not found
End

Function/S db_get_srcdim_keys__(dims)
	string dims
	
	string keys = ""
	variable i
	for (i=0; i<itemsinlist(dims); i+=1)
		string dim = stringfromlist(i,dims)
		string key = stringfromlist(0,dim,"=")
		keys = addlistitem(key,keys,";",Inf)
	endfor
	return keys

End

Function/S db_set_srcdim__(dims, key, val)
	string dims
	string key
	string val
	
	dims = replacestringbykey(key,dims,val,"=")
	return dims
End

Function/S db_get_srcdim__(dims, key)
	string dims
	string key
	
	return stringbykey(key,dims,"=")
End

Function/S db_get_srcdims__(sources)
	wave/T sources
	
	string dims = ""
	variable i
	for (i=0; i<dimsize(sources,0); i+=1)
		dims = addlistitem(sources[i][2],dims,";",Inf)
	endfor
	return dims
End


// public function to get list of <param> where param is:
// 	"DATATYPE" - datasources type/group
//	"PATH" - list of full paths to datasources  
//  	"LABEL" - list of datasources labels
 
Function/S db_get_datasource_par_list(param)
	string param
	
	db_init_datasources()
	string sdf = db_goto_active_db()
	wave/T sources = data_sources
	
	if (cmpstr(param,"DATATYPE") == 0)
		return db_get_srctypes__(sources)
	elseif (cmpstr(param,"PATH") == 0)
		return db_get_srcpaths__(sources)
	elseif (cmpstr(param,"LABEL") == 0)
		return db_get_srclabels__(sources)
	else
		return "Unknown param type: " + param
	endif	

	setdatafolder sdf
End

Function/S db_get_srctypes__(sources)
	wave/T sources
	
	string types = ""
	variable i
	for (i=0; i<dimsize(sources,0); i+=1)
		if (findlistitem(sources[i][3],types) < 0)
			types = addlistitem(sources[i][3],types,";",Inf)
		endif
	endfor
	return types
End

Function/S db_get_srcpaths__(sources)
	wave/T sources
	
	string paths = ""
	variable i
	for (i=0; i<dimsize(sources,0); i+=1)
		paths = addlistitem(sources[i][1],paths,";",Inf)
	endfor
	return paths
End

Function/S db_get_srclabels__(sources)
	wave/T sources
	
	string names = ""
	variable i
	for (i=0; i<dimsize(sources,0); i+=1)
		if (findlistitem(sources[i][0],names) < 0)
			names = addlistitem(sources[i][0],names,";",Inf)
		endif
	endfor
	return names
End

Function db_has_srclabel__(sources,name)
	wave/T sources
	string name
	
	string names = db_get_srclabels__(sources)
	if (findlistitem(name,names) >= 0)
		return 1
	endif
	return 0
End

Function/S db_get_unique_srclabel__(sources, data, name)
	wave/T sources
	string data
	string name

	if (cmpstr(name,"") == 0)
		// get label from path
		name = stringfromlist(itemsinlist(data,":")-1,data,":")
	endif
	
	if (db_has_srclabel__(sources,name))
		do
			string msg = "Data source label: " + name + " already exists!"
			DoAlert 0, msg
			prompt name, "New Data Source label: "
			DoPrompt "New Label", name
			if (!V_Flag)
				return ""
			endif
			
		while (db_has_srclabel__(sources,name))
	endif
	return name
	
End

Function/S db_get_srclabels_by_type__(sources,type)
	wave/T sources
	string type
	
	string names = ""
	variable i
	for (i=0; i<dimsize(sources,0); i+=1)
		if (cmpstr(sources[i][3],type) == 0)
			names = addlistitem(sources[i][0],names,";",Inf)
		endif
	endfor
	return names
End

Function/S db_get_path_by_label(name)
	string name
	
	string sdf = db_goto_active_db()
	db_init_datasources()
	wave/T sources = data_sources

	variable row = db_find_datasource_by_label__(sources,name)
	if (row >= 0)
		return sources[row][1]
	endif
	return ""

	//return stringbykey(name,db_get_src_map__(sources),"=")
End

Function/S db_get_dims_by_label(name)
	string name
	
	string sdf = db_goto_active_db()
	db_init_datasources()
	wave/T sources = data_sources
	
	variable row = db_find_datasource_by_label__(sources,name)
	if (row >= 0)
		return sources[row][2]
	endif
	return ""

	//return stringbykey(name,db_get_dims_map__(sources),"=")
End

//Function/S db_get_src_map__(sources)
//	wave/T sources
//
//	string src_map = ""
//	
//	string labels = db_get_srclabels__(sources)
//	string paths = db_get_srcpaths__(sources)
//	variable i
//	for (i=0; i<itemsinlist(labels); i+=1)
//		src_map = replacestringbykey(stringfromlist(i,labels),src_map,stringfromlist(i,paths),"=")
//	endfor
//	return src_map
//	
//End

//Function/S db_get_dims_map__(sources)
//	wave/T sources
//
//	string dim_map = ""
//	
//	string labels = db_get_srclabels__(sources)
//	string dims = db_get_srcdims__(sources)
//	variable i
//	for (i=0; i<itemsinlist(labels); i+=1)
//		dim_map = replacestringbykey(stringfromlist(i,labels),dim_map,stringfromlist(i,dims),"=")
//	endfor
//	return dim_map
//	
//End

Function/S db_get_srclabel_map__(sources)
	wave/T sources

	string label_map = ""
	
	string types = db_get_srctypes__(sources)
	variable i
	for (i=0; i<itemsinlist(types); i+=1)
		string type = stringfromlist(i,types)
		label_map = replacestringbykey(type , label_map, db_get_srclabels_by_type__(sources,type), type)
	endfor
	return label_map
	
End

//Function db_add_datasource()
//
//	string sdf = db_goto_active_db()
//	
//	db_init_datasources()
//	
//	wave sources = data_sources
//	
//	//Execute "CreateBrowser prompt=\"Select data source wave and click OK\", showWaves=1, showVars=0, showStrs=0; ModifyBrowser"
//	Execute "CreateBrowser prompt=\"Select data source wave and click OK\", showWaves=1, showVars=0, showStrs=0, executeMode=5, command1=\"foo()\""
////	Execute "ModifyBrowser command1=\"foo()\""
////	Execute "CreateBrowser"
////	Execute "ModifyBrowser command1=\"foo()\" setDafaults"
//		
//	SVAR S_BrowserList=S_BrowserList
//	NVAR V_Flag=V_Flag
//	if(V_Flag==0)
//		Print "You cancelled"
//	else
//		Printf "You selected: %s\r", S_BrowserList
//	endif
//End

//Function foo()
//		String name
//		Variable index=1
//		name=GetBrowserSelection(0)
//		print name
//End

Function db_add_data_src([force])
	string force
	
	if (ParamIsDefault(force))
		force="false"
	endif


	if (WinType("db_add_dsrc_win")==7)
		DoWindow/F db_add_dsrc_win
	else
	
		string sdf = db_goto_add_src_pkg(force=force) // make sure app is initialized
		SVAR data_label = data_src_label
		data_label = ""
		NVAR dt_calc = dt_calc_cb
		dt_calc = 1
		NVAR dp_rb = axis2_Dp_type_rb
		dp_rb = 1
		NVAR ht_rb = axis2_Ht_type_rb
		ht_rb = 0
		NVAR ss_rb = axis2_SS_type_rb
		ss_rb = 0
		setdatafolder sdf
		
		PauseUpdate; Silent 1		// building window...
		//NewPanel/N=db_add_dsrc_win/W=(1014,205,1512,578) as "Add data source"
		NewPanel/N=db_add_dsrc_win/W=(834,151,1332,568) as "Add data source"
		SetDrawLayer UserBack
		//ShowTools/A
		Button datasrc_button,pos={60,70},size={303,30}
		TitleBox dsrc_button_title,pos={64,51},size={95,13},title="Data Source Wave:"
		TitleBox dsrc_button_title,frame=0
		Button datasrc_dt_button,pos={57,214},size={303,30},title=""
		Button datasrc_2axis_button,pos={60,293},size={303,30},disable=2,title=""
		GroupBox datasrc_group,pos={14,21},size={464,336},title="Data Source",fSize=14
		GroupBox dims_group,pos={39,172},size={427,166},title="Dimensions"
		TitleBox dt_title,pos={59,197},size={75,13},title="DateTime wave",frame=0
		TitleBox axis2_title,pos={62,274},size={89,13},title="Dp, Height or SS wave",frame=0
		TitleBox axis2_type_title,pos={382,260},size={24,13},title="Type",frame=0
		CheckBox Dp_rb,pos={383,279},size={32,14},disable=2,proc=axis2_radioType_Proc,title="Dp"
		CheckBox Dp_rb,variable= root:Packages:acg:acgdb:add_src:axis2_Dp_type_rb,mode=1
		CheckBox Height_rb,pos={382,298},size={49,14},disable=2,proc=axis2_radioType_Proc,title="Height"
		CheckBox Height_rb,variable= root:Packages:acg:acgdb:add_src:axis2_Ht_type_rb,mode=1
		CheckBox SS_rb,pos={382,317},size={49,14},disable=2,proc=axis2_radioType_Proc,title="SS"
		CheckBox SS_rb,variable= root:Packages:acg:acgdb:add_src:axis2_SS_type_rb,mode=1

		CheckBox axis2_ovr_cb,pos={200,274},size={62,14},title="override"
		CheckBox axis2_ovr_cb,variable= root:Packages:acg:acgdb:add_src:axis2_override_cb

		Button cancel_button,pos={25,380},size={50,20},proc=db_addsrc_ButtonProc,title="Reset"
		Button cancel_button,fSize=14
		Button add_button,pos={222,378},size={50,20},proc=db_addsrc_ButtonProc,title="Add"
		Button add_button,fSize=14
		Button close_button,pos={391,379},size={50,20},proc=db_addsrc_ButtonProc,title="Close"
		Button close_button,fSize=14
		SetVariable dsrc_label,pos={61,131},size={304,20},bodyWidth=304,title=" "
		SetVariable dsrc_label,fSize=14
		SetVariable dsrc_label,value= root:Packages:acg:acgdb:add_src:data_src_label
		TitleBox srclabel,pos={62,112},size={112,16},title="Data Source Label",fSize=14
		TitleBox srclabel,frame=0
		CheckBox dt_calc_cb,pos={383,223},size={62,14},title="Calculate"
		CheckBox dt_calc_cb,variable= root:Packages:acg:acgdb:add_src:dt_calc_cb
		
		
		
		SetWindow kwTopWin,hook(PopupWS_HostWindowHook)=PopupWSHostHook
		
		//MakeListIntoWaveSelector("test_panel","dt_list",selectionMode=WMWS_SelectionSingle)
		MakeButtonIntoWSPopupButton("db_add_dsrc_win", "datasrc_button", "db_add_src_SelectorNotify", options=PopupWS_OptionFloat)
		MakeButtonIntoWSPopupButton("db_add_dsrc_win", "datasrc_dt_button", "db_add_src_SelectorNotify", options=PopupWS_OptionFloat)
		MakeButtonIntoWSPopupButton("db_add_dsrc_win", "datasrc_2axis_button", "db_add_src_SelectorNotify", options=PopupWS_OptionFloat)
	endif

	

End

Function db_add_src_SelectorNotify(event, wavepath, windowName, ctrlName)
	Variable event
	String wavepath
	String windowName
	String ctrlName
	
	print "Selected wave:",wavepath, " using control", ctrlName, " in window",windowName
	string sdf = db_goto_add_src_pkg() // make sure app is initialized
	
	if (cmpstr(ctrlName,"datasrc_button")==0)
		SVAR data_wave = data_src_wave
		data_wave = wavepath
		SVAR data_label = data_src_label
		data_label = stringfromlist(itemsinlist(wavepath,":")-1,wavepath,":") // get wave name of selected data source
		
		NVAR override_2d = axis2_override_cb
		
		wave data = $data_wave
		variable is_2d = (dimsize(data,1) || override_2d)
		print "override = ", override_2d
		if (is_2d)
			// enable axis2 control
			ModifyControl datasrc_2axis_button disable = 0
			ModifyControl Dp_rb disable = 0
			ModifyControl Height_rb disable = 0
			ModifyControl SS_rb disable = 0
		else
			ModifyControl datasrc_2axis_button disable = 2			
			ModifyControl Dp_rb disable = 2
			ModifyControl Height_rb disable = 2
			ModifyControl SS_rb disable = 2
			
			SVAR axis2_wave =  axis2_src_wave
			axis2_wave = ""
		endif
	
	elseif (cmpstr(ctrlName,"datasrc_dt_button")==0)
		NVAR use_calc = dt_calc_cb
		SVAR dt_wave =  dt_src_wave
		if (use_calc)
			dt_wave = ""
		else
			dt_wave = wavepath
		endif

	elseif (cmpstr(ctrlName,"datasrc_2axis_button")==0)
		SVAR axis2_wave =  axis2_src_wave
		axis2_wave = wavepath
		
	endif
		
	setdatafolder sdf
		
end

Function/S db_get_srctype_menu_list()
	
	string types = db_get_datasource_par_list("DATATYPE")
	if (findlistitem("default",types) < 0) // not found
		types = addlistitem("default",types)
	endif
	types = addlistitem("<add new type>",types)
	return types
End

Function axis2_radioType_Proc(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	string sdf = db_goto_add_src_pkg() // make sure app is initialized
	NVAR dp_rb = axis2_Dp_type_rb
	NVAR ht_rb = axis2_Ht_type_rb
	NVAR ss_rb = axis2_SS_type_rb
	
//	print "rt ctrl name: ", cba
	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			if (cmpstr(cba.ctrlName,"Dp_rb")==0)
				dp_rb = 1
				ht_rb = 0
				ss_rb = 0
			elseif (cmpstr(cba.ctrlName,"Height_rb")==0)
				dp_rb = 0
				ht_rb = 1
				ss_rb = 0
			elseif (cmpstr(cba.ctrlName,"SS_rb")==0)
				dp_rb = 0
				ht_rb = 0
				ss_rb = 1
			endif			
				
			// need to use nvar in config folder like tbm
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function db_addsrc_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//string sdf = getdatafolder(1)
			//setdatafolder ProjectInfo_folder
			//setdatafolder :gui_PIC
//			acg_goto_ProjectInfo()
//			//NVAR saved = proj_info_entry_saved
//			//saved = 0			
//			variable close_window = 0
			
			print ba.ctrlName
			if (cmpstr(ba.ctrlName,"close_button")==0)
			
				killwindow db_add_dsrc_win
						
			elseif (cmpstr(ba.ctrlName,"cancel_button")==0)
				killwindow db_add_dsrc_win
				db_add_data_src()
				print "reset"

			elseif (cmpstr(ba.ctrlName,"add_button")==0)

				string sdf = db_goto_add_src_pkg()
				SVAR data_name = data_src_wave
				SVAR data_label = data_src_label
				
				SVAR dt_name = dt_src_wave
				NVAR use_calc = dt_calc_cb
				
				SVAR axis2_name = axis2_src_wave			
				NVAR is_dp = axis2_Dp_type_rb
				NVAR is_ht = axis2_Ht_type_rb
				NVAR is_ss = axis2_SS_type_rb
				
				
				
				db_goto_active_db()
				db_init_datasources()
	
				wave sources = data_sources
				//wave data = $data_name
		
				// check to see if this datasource exists
				if (db_find_datasource__(sources,data_name) >=0)
					print "data source exists!"
					return 0
				endif
				
				// get dims
				string dim_list = ""
				if (cmpstr(dt_name,"") != 0 && !use_calc)
					dim_list = db_set_srcdim__(dim_list,"DATETIME_AXIS",dt_name)
				endif
				
				if (cmpstr(axis2_name,"") != 0)
					string axis = ""
					if (is_dp)
						axis = "DP_AXIS"
					elseif (is_ht)
						axis = "HEIGHT_AXIS"
					elseif (is_ss)
						axis = "SS_AXIS"
					else
						axis = ""
					endif
						
					
					dim_list = db_set_srcdim__(dim_list,axis,axis2_name)
				endif
				
				if (cmpstr(dim_list,"")!=0)
					print "	adding dimensions: ", dim_list
				endif

				// get unique label
				string udata_label = db_get_unique_srclabel__(sources,data_name,data_label)
				print "	data label: ", udata_label
				
				// set type
				string types = db_get_srctypes__(sources)
				string types_menu = addlistitem("<new type>",types)
				variable menu_item = 1
				string type = ""
				prompt menu_item, "Data source type: ", popup, types_menu
				DoPrompt "Select data source type",menu_item
				if (V_Flag)
					type = "default"
				elseif (menu_item == 1)
				//elseif (cmpstr(type,"<new type>") == 0)
					prompt type, "New data source type: "
					DoPrompt "Add new data source type", type
				else
					type = stringfromlist(menu_item-1,types_menu)
				endif
				print "	data source type: ", type
					
				print ""			
				print "Updating data source" 				
				db_update_datasource__(data_name,name=data_label,dims=dim_list,data_type=type)

				setdatafolder sdf
								
			endif
			
			break
	endswitch

	return 0
End

Function/S db_goto_add_src_pkg([force])
	string force
	
	if (ParamIsDefault(force))
		force="false"
	endif
	
	string sdf = db_goto_acgdb_pkg()
	
	db_init_add_src(force=force)
	
	setdatafolder :add_src
	
	return sdf

End

Function db_init_add_src([force])
	string force
	
	variable do_force = 0
	if (!ParamIsDefault(force))
		if (cmpstr(force,"true")==0)
			do_force=1
		endif
	endif

//	string sdf = db_goto_acgdb_pkg()
	
	if (!datafolderexists("add_src") || do_force)
		newdatafolder/o/s :add_src
	
		// checkboxes
		variable/G axis2_Dp_type_rb = 1
		variable/G axis2_Ht_type_rb = 0
		variable/G axis2_SS_type_rb = 0
		variable/G dt_calc_cb = 1
		variable/G axis2_override_cb=0

		// value fields
		string/G data_src_label = "<no label>"
		
		// list box results
		string/G data_src_wave = ""
		string/G dt_src_wave = ""
		string/G axis2_src_wave = ""
		
	endif
	
//	setdatafolder sdf
	
End

Function/S db_goto_apps_config()
	string sdf = db_goto_db_folder()
	setdatafolder acgdb
	newdatafolder/o/s applications
	
	if (exists("app_registry") != 2)
		string/G app_registry = ""
	endif
		
	return sdf
End

Function/S db_get_app_list()
	
	string sdf = db_goto_apps_config()
	SVAR app_reg = app_registry
	
	string apps = ""
	variable i
	for (i=0; i<itemsinlist(app_reg); i+=1)	
		apps = addlistitem( stringfromlist(0, stringfromlist(i,app_reg) ,":"), apps ,";",Inf)
	endfor
	return apps
End

Function/S db_get_app_long_name(app_sig)
	string app_sig
	
	string sdf = db_goto_apps_config()
	SVAR app_reg = app_registry
	
	string item = stringbykey(app_sig,app_reg)
	string result = stringbykey("LONG_NAME",item,"=","$")
	setdatafolder sdf
	return result	
End
	
Function/S db_get_app_template(app_sig)
	string app_sig
	
	string sdf = db_goto_apps_config()
	SVAR app_reg = app_registry
	
	string item = stringbykey(app_sig,app_reg)
	string result = stringbykey("APP_TEMPLATE",item,"=","$")
	setdatafolder sdf
	return result
End
	


Function db_update_app_registry(reg_item)
	string reg_item
	
	// remove trailing ;
	reg_item = stringfromlist(0,reg_item)
	
	string sdf = db_goto_apps_config()
	SVAR app_reg = app_registry
	
	string key = stringfromlist(0,reg_item,":")
	app_reg = replacestringbykey(key,app_reg,stringfromlist(1,reg_item,":"))
	
	setdatafolder sdf	
End

Function db_register_app(app_sig,long_name,template)
	string app_sig
	string long_name
	string template
	
//	string sdf = db_goto_apps_config()
//	string sdf = db_goto_db_folder()
//	setdatafolder acgdb
//	newdatafolder/o/s applications
	string reg_item = ""
	string reg_item_val = ""
	reg_item_val = replacestringbykey("LONG_NAME",reg_item_val,long_name,"=","$")
	reg_item_val = replacestringbykey("APP_TEMPLATE",reg_item_val,template,"=","$")
	reg_item = replacestringbykey(app_sig,reg_item,reg_item_val)
	print reg_item
	
//	if (exists("app_registry") != 2)
//		string/G app_registry = ""
//	endif
//	SVAR app_reg = app_registry
	db_update_app_registry(reg_item)
	
	//replacestringbykey(app_sig,app_reg,fn,"=")
	
//	if (whichlistitem(app_sig,app_reg) < 0)
//		app_reg = replacestringbykey(app_sig,app_reg,";",Inf)
//	endif
//	setdatafolder sdf
End

Function/S db_app_get_wavelist__(datasource,app_sig)
	string datasource
	string app_sig
	
	return db_app_get_meta__(datasource,app_sig,"DATAWAVES","WAVE_LIST")
End

Function db_app_update_wavelist__(datasource,app_sig,w,[is_default])
	string datasource
	string app_sig
	wave w
	variable is_default
	
	if (ParamIsDefault(is_default))
		is_default = 0
	endif
	
	string name = nameofwave(w)
	string path = getwavesdatafolder(w,2)

	string list = db_app_get_wavelist__(datasource,app_sig)
	if (whichlistitem(name,list) < 0)
		list = addlistitem(name,list,";",Inf)
		db_app_update_meta__(datasource,app_sig,"DATAWAVES","WAVE_LIST",list)
	endif
	db_app_update_meta__(datasource,app_sig,"DATAWAVES",name,path)
	
	if (is_default)
		db_app_update_meta__(datasource,app_sig,"DATAWAVES","DEFAULT_DATA",name)
	endif
	
End

//Function db_app_update_meta__("RECREATE",APP_SIGNATURE,RECREATE)
Function db_app_update_meta__(datasource,app_sig,metatype,key,metadata)
	string datasource
	string app_sig
	string metatype
	string key
	string metadata
	
	string sdf = db_goto_datasource(datasource)
	setdatafolder app_sig
	newdatafolder/o/s meta
	if (exists(metatype) != 2)
		string/G $metatype = ""
	endif
	SVAR type = $metatype
	type = replacestringbykey(key,type,metadata,"?","&")
	
	setdatafolder sdf
	
End

Function/S db_app_get_meta__(datasource,app_sig,metatype,key)
	string datasource
	string app_sig
	string metatype
	string key
	
	string sdf = db_goto_datasource(datasource)
	setdatafolder app_sig
	if (!datafolderexists("meta"))
		return ""
	endif
	setdatafolder meta
	
	if (exists(metatype) != 2)
		return ""
	endif
	SVAR type = $metatype
	
	setdatafolder sdf
	
	return stringbykey(key,type,"?","&")
End

Function/S db_get_app_data(datasource,app_sig,[extras])
	string datasource
	string app_sig
	string extras
	
	string sdf = db_goto_datasource(datasource)
	//string path = db_app_get_meta__("DEFAULT",app_sig)
	setdatafolder sdf
	//return path
	return ""

End
 
Function db_app_average_data([datasource,dataset])
	string datasource
	string dataset
	
	string APP_SIGNATURE = "average"
	string app_long_name = "Average (and stats)"
	db_register_app(APP_SIGNATURE,app_long_name,"db_app_average_data([datasource,dataset])")
	//db_register_app_dependence(APP_SIGNATURE,"")
	
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "Data source: ", popup, labels
		DoPrompt "Select data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		datasource = stringfromlist(label_item-1,labels)
	endif
	string datasource_path = db_get_path_by_label(datasource)
	string datasource_dims = db_get_dims_by_label(datasource)
	
	print "App: ", APP_SIGNATURE
	print "	DB: ", db_get_active_db()
	print "		Dataset: ", dataset
	print "			Data: ", datasource_path
	
	
	wave data = $datasource_path
		
	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
	variable clean_up_dt = 0
	if(cmpstr(dt_name,"") == 0)
		// use wavescaling
		wave dt = acg_extract_dt(data)
		dt_name = nameofwave(dt)
		print "dt_name = ", dt_name
		clean_up_dt = 1			
	endif
	wave dt = $dt_name
	
	
	variable is_2d = 0
	if (dimsize(data,1)) // 2d wave
		string axis2_name = db_get_srcdim__(datasource_dims, "DP_AXIS")
		if (cmpstr(axis2_name,"")==0)
			axis2_name = db_get_srcdim__(datasource_dims, "HEIGHT_AXIS")
		endif
		if (cmpstr(axis2_name,"")==0)
			axis2_name = db_get_srcdim__(datasource_dims, "SS_AXIS")
		endif
		print "axis2_name", axis2_name
		
		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
		is_2d = 1
	endif
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(datasource)

	newdatafolder/o $APP_SIGNATURE
	
	// add meta - maybe add global STRUCT to define meta values
	string RECREATE = "db_app_average_data(datasource=\""+datasource+"\",dataset=\""+dataset+"\")"
	db_app_update_meta__(datasource, APP_SIGNATURE,"RECREATE",APP_SIGNATURE,RECREATE)
	
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	newdatafolder/o/s $APP_SIGNATURE
	
	// create app data waves 
	make/o/n=(numpnts(ids),dimsize(data,1)) $"data_avg"
	wave dat_avg = $"data_avg"

	make/o/n=(numpnts(ids),dimsize(data,1)) $"data_sd"
	wave dat_sd = $"data_sd"
	
	make/o/n=(numpnts(ids),dimsize(data,1)) $"data_min"
	wave dat_min = $"data_min"

	make/o/n=(numpnts(ids),dimsize(data,1)) $"data_max"
	wave dat_max = $"data_max"

	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_avg,is_default=1)
	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_sd)
	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_min)
	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_max)
	
	
	// create working dt waves
	make/o/n=1 start_dt_wave
	wave start_dt = start_dt_wave	
	make/o/n=1 stop_dt_wave
	wave stop_dt = stop_dt_wave	

	variable i
	for (i=0; i<numpnts(ids); i+=1)
	
		start_dt[0] = db_get_ds_entry_start_dt(ids[i])
		stop_dt[0] = db_get_ds_entry_stop_dt(ids[i])
		
		// average data
		string output = "output"
		if (is_2d)
			acg_avg_using_time_index_2d(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_avg[i][] = out[0][q]
			
			acg_sd_using_time_index_2d(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_sd[i][] = out[0][q]

			acg_min_using_time_index_2d(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_min[i][] = out[0][q]

			acg_max_using_time_index_2d(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_max[i][] = out[0][q]
			
		else
			acg_avg_using_time_index(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_avg[i] = out[0]
				
			acg_sd_using_time_index(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_sd[i] = out[0]

			acg_min_using_time_index(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_min[i] = out[0]

			acg_max_using_time_index(start_dt, stop_dt, dt, data, output)
			wave out = $output
			dat_max[i] = out[0]
		endif
		
	endfor

	// clean up tmp waves
	if (clean_up_dt)
		killwaves/Z dt
	endif
	killwaves/Z ids,start_dt,stop_dt,out
	
	setdatafolder sdf
End


STRUCTURE AppData_fit_dist
	string app_sig
	string datasource
	string dataset
	string avgdata_name
	string dp_name
	string fit_par_name
EndStructure


Function db_app_fit_sizedist_data([datasource,dataset])
	string datasource
	string dataset
	
	string APP_SIGNATURE = "fit_size_dist"
	string app_long_name = "Fit size distributions"
	// change!
	db_register_app(APP_SIGNATURE,app_long_name,"db_app_fit_sizedist_data([datasource,dataset])")
	
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "Data source: ", popup, labels
		DoPrompt "Select data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		datasource = stringfromlist(label_item-1,labels)
	endif
	string datasource_path = db_get_path_by_label(datasource)
	string datasource_dims = db_get_dims_by_label(datasource)
	
	print "App: ", APP_SIGNATURE
	print "	DB: ", db_get_active_db()
	print "		Dataset: ", dataset
	print "			Data: ", datasource_path
	
	wave data = $datasource_path

//	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
//	variable clean_up_dt = 0
//	if(cmpstr(dt_name,"") == 0)
//		// use wavescaling
//		wave dt = acg_extract_dt(data)
//		dt_name = nameofwave(dt)
//		print "dt_name = ", dt_name
//		clean_up_dt = 1			
//	endif
//	wave dt = $dt_name
	
	variable is_2d = 0
	if (dimsize(data,1)) // 2d wave
		string dp_name = db_get_srcdim__(datasource_dims, "DP_AXIS")
		if (cmpstr(dp_name,"")==0)
			print "Dp axis not defined"
			return 0
		endif
		print "dp_name", dp_name
		
		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
		is_2d = 1
	endif
	
	// needs average data to do fits
	//wave data_avg = $(db_get_app_data(datasource,"average"))
	// check to see if data_avg is current by comparing modtimes
	//wave dat_avg = $"data_avg"
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()

	newdatafolder/o $APP_SIGNATURE
	

	// init app structure
	db_goto_datasource(datasource)

	// add meta - maybe add global STRUCT to define meta values
	string RECREATE = "db_app_fit_sizedist_data(datasource=\""+datasource+"\",dataset=\""+dataset+"\")"
	//db_app_update_meta__("RECREATE",APP_SIGNATURE,RECREATE)
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	newdatafolder/o/s $APP_SIGNATURE
	
	// create app data waves (zero length) if doesn't exist
	if (!waveexists($"fit_params") )
		 
		make/o/n=(0,11) $"fit_params" // add extra column for ids
//		make/o/n=(0,4) $"number_conc" // add extra column for ids
//		make/o/n=(0,2) $"ssa_nfrac" // add extra column for ids
		
	elseif (dimsize($"fit_params",0) != numpnts(ids))
		print "fit_param size != ids"
	endif
	//make/o/n=(dimsize(data_avg,1)) $"aitken_fit", $"accum_fit", $"ssa_fit",  $"total_fit" 
	
	//wave aitken = $"aitken_fit"
	//wave accum = $"accum_fit"
	//wave ssa = $"ssa_fit"
	//wave total = $"total_fit"
	
	wave fit_par = $"fit_params"
	//wave num_conc = $"number_conc"
	//wave nfrac = $"ssa_nfrac"

	//string path = stringbykey("PATH",waveinfo(fit_par,0))
	//db_app_update_meta__("DEFAULT",APP_SIGNATURE,path)
	
	// hard_code for now
	wave data_avg = ::average:data_avg
	//wave dp = 
	
	// create data for gui
	STRUCT AppData_fit_dist fd_data
	fd_data.app_sig = APP_SIGNATURE
	fd_data.datasource = datasource
	fd_data.dataset = dataset
	fd_data.avgdata_name = getwavesdatafolder(data_avg,2)
	fd_data.dp_name = dp_name
	fd_data.fit_par_name = getwavesdatafolder(fit_par,2)
	
	db_update_appdata_fit_dist(fd_data)


	// show window
	 db_app_fit_size_dist_gui()
	 
	 killwaves/Z ids

End

Function db_plot_fit_by_index(ds_index,[datasource,dataset,add_labels])
	variable ds_index
	string datasource
	string dataset
	string add_labels
	
	string APP_SIGNATURE = "fit_size_dist"
	string app_long_name = "Fit size distributions"
	// change!
//	db_register_app(APP_SIGNATURE,app_long_name,"db_app_fit_sizedist_data([datasource,dataset])")
	
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(add_labels))
		add_labels = "false"
	endif
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "Data source: ", popup, labels
		DoPrompt "Select data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		datasource = stringfromlist(label_item-1,labels)
	endif
	string datasource_path = db_get_path_by_label(datasource)
	string datasource_dims = db_get_dims_by_label(datasource)
	
//	print "App: ", APP_SIGNATURE
//	print "	DB: ", db_get_active_db()
//	print "		Dataset: ", dataset
//	print "			Data: ", datasource_path
	
	wave data = $datasource_path

//	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
//	variable clean_up_dt = 0
//	if(cmpstr(dt_name,"") == 0)
//		// use wavescaling
//		wave dt = acg_extract_dt(data)
//		dt_name = nameofwave(dt)
//		print "dt_name = ", dt_name
//		clean_up_dt = 1			
//	endif
//	wave dt = $dt_name
	
	variable is_2d = 0
	if (dimsize(data,1)) // 2d wave
		string dp_name = db_get_srcdim__(datasource_dims, "DP_AXIS")
		if (cmpstr(dp_name,"")==0)
			print "Dp axis not defined"
			return 0
		endif
		print "dp_name", dp_name
		
		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
		is_2d = 1
	endif
	
	// needs average data to do fits
	//wave data_avg = $(db_get_app_data(datasource,"average"))
	// check to see if data_avg is current by comparing modtimes
	//wave dat_avg = $"data_avg"
	
	// get list of dataset ids
//	wave ids = db_get_ds_ids()

//	newdatafolder/o $APP_SIGNATURE
	

	// init app structure
	db_goto_datasource(datasource)

	// add meta - maybe add global STRUCT to define meta values
	//string RECREATE = "db_app_fit_sizedist_data(datasource=\""+datasource+"\",dataset=\""+dataset+"\")"
	//db_app_update_meta__("RECREATE",APP_SIGNATURE,RECREATE)
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	setdatafolder $APP_SIGNATURE
	
//	// create app data waves (zero length) if doesn't exist
//	if (!waveexists($"fit_params"))
//		 
//		make/o/n=(0,11) $"fit_params" // add extra column for ids
////		make/o/n=(0,4) $"number_conc" // add extra column for ids
////		make/o/n=(0,2) $"ssa_nfrac" // add extra column for ids
//		
//	endif
	//make/o/n=(dimsize(data_avg,1)) $"aitken_fit", $"accum_fit", $"ssa_fit",  $"total_fit" 
	
	//wave aitken = $"aitken_fit"
	//wave accum = $"accum_fit"
	//wave ssa = $"ssa_fit"
	//wave total = $"total_fit"
	
	wave fit_par = $"fit_params"
	//wave num_conc = $"number_conc"
	//wave nfrac = $"ssa_nfrac"

	//string path = stringbykey("PATH",waveinfo(fit_par,0))
	//db_app_update_meta__("DEFAULT",APP_SIGNATURE,path)
	
	// hard_code for now
	wave data_avg = ::average:data_avg
	//wave dp = 
	
	// create data for gui
	STRUCT AppData_fit_dist fd_data
	fd_data.app_sig = APP_SIGNATURE
	fd_data.datasource = datasource
	fd_data.dataset = dataset
	fd_data.avgdata_name = getwavesdatafolder(data_avg,2)
	fd_data.dp_name = dp_name
	fd_data.fit_par_name = getwavesdatafolder(fit_par,2)
	
//	db_update_appdata_fit_dist(fd_data)
	db_plot_fit(ds_index, fd_data,add_labels=add_labels)

	// show window
//	 db_app_fit_size_dist_gui()
	 
//	 killwaves/Z ids

	setdatafolder sdf
End

Function db_plot_fit(index, fd_data,[add_labels])
	variable index
	STRUCT AppData_fit_dist &fd_data
	string add_labels 

	if (ParamIsDefault(add_labels))
		add_labels = "false"
	endif
	
	newdatafolder/o/s :plots
	newdatafolder/o/s $(":index_"+num2str(index))
	
	wave avg = $fd_data.avgdata_name
	make/o/n=(dimsize(avg,1)) dNdlogDp
	wave dn = dNdlogDp
	dn = avg[index-1][p]

	duplicate/o 	$fd_data.dp_name dp_um
	wave dp = dp_um
	
	wave fit_par = $fd_data.fit_par_name
	variable i, row=-1
	for (i=0; i<dimsize(fit_par,0); i+=1)
		if (fit_par[i][0] == index)
			row = i
			break
		endif
	endfor
	
	if (row >= 0)
	
		variable N = fit_par[row][1] 
		variable diam = fit_par[row][2] 
		variable sig = fit_par[row][3]
		duplicate/o dn, aitken_fit 
		wave aitken = aitken_fit
		db_lognormal_fn(N,diam,sig,dp,dn,aitken)

		N = fit_par[row][4] 
		diam = fit_par[row][5] 
		sig = fit_par[row][6]
		duplicate/o dn, accum_fit 
		wave accum = accum_fit
		db_lognormal_fn(N,diam,sig,dp,dn,accum)

		N = fit_par[row][7] 
		diam = fit_par[row][8] 
		sig = fit_par[row][9]
		duplicate/o dn, ssa_fit 
		wave ssa = ssa_fit
		db_lognormal_fn(N,diam,sig,dp,dn,ssa)

		variable chi_sq = fit_par[row][10]
		
		duplicate dn, total_fit
		wave total = total_fit
		total = aitken+accum+ssa
		
		display dn vs dp
		appendtograph aitken vs dp
		appendtograph accum vs dp
		appendtograph ssa vs dp
		appendtograph total vs dp
		string msg  = "chi_sq = " + num2str(chi_sq)
		TextBox/C/N=text0/A=MC msg
		
	else
		print "Index not found"
	endif
		
		
	setdatafolder :::
	
	print fd_data.app_sig
	print fd_data.datasource
	print fd_data.dataset
	print fd_data.avgdata_name
	print fd_data.dp_name
	print fd_data.fit_par_name
	
	//string datasource_path = db_get_path_by_label(datasource)
	//string datasource_dims = db_get_dims_by_label(datasource)
		
	//wave data = $datasource_path
	
End

Function db_update_appdata_fit_dist(fd_data)
	STRUCT AppData_fit_dist &fd_data

	string sdf = db_goto_apps_fit_dist_pkg()
	newdatafolder/o/s :run
	
	// write struct data to folder
	string/G app_sig = fd_data.app_sig
	string/G datasource = fd_data.datasource
	string/G dataset = fd_data.dataset
	string/G avgdata_name = fd_data.avgdata_name
	string/G dp_name = fd_data.dp_name
		
	setdatafolder sdf

	db_update_app_fit_dist()
End

Function db_update_app_fit_dist()
	
	string sdf = db_goto_apps_fit_dist_pkg()
	
	// get struct -----
	setdatafolder :run
	
	STRUCT AppData_fit_dist fd_data
	
	SVAR sig = app_sig
	fd_data.app_sig = sig
	
	SVAR dsource = datasource
	fd_data.datasource = dsource
	
	SVAR dset = dataset
	fd_data.dataset = dset
	
	SVAR avgname = avgdata_name
	fd_data.avgdata_name = avgname
	
	SVAR dpname = dp_name
	fd_data.dp_name = dpname
	
	setdatafolder ::
	// ------
	
	
	NVAR index = index_field 
	NVAR iupper_limit = index_upper_limit
	if (index>iupper_limit)
		index = 0
	endif
	//variable index = id-1 // TODO: make this truly based on id
	
	// set gui params with struct
	wave avgdata = $fd_data.avgdata_name
	wave dw = dw_wave
	redimension/N=(dimsize(avgdata,1)) dw
	dw = avgdata[index][p]
	
	iupper_limit = dimsize(avgdata,0)-1
	
	wave aitken = aitken_wave
	wave accum = accum_wave
	wave ssa = ssa_wave
	wave total = total_wave
	redimension/N=(dimsize(avgdata,1)) aitken, accum, ssa, total
	
	wave avg_dp = $fd_data.dp_name
	duplicate/o avg_dp, dp_wave
	wave dp = dp_wave
	
	SVAR dataset = dataset_label
	dataset = fd_data.dataset
	
	SVAR datasource = data_src_label
	datasource = fd_data.datasource
	
//	// set fit_par using wavename
//	SVAR fp_name = fit_par_name
//	fp_name = fd_data.fit_par_name
//	wave fit_par = $fp_name
	
	wave ids = db_get_ds_ids()
	
	wave fit_param = db_app_get_fit_params(datasource,fd_data.app_sig)
	wave fit_par_item = db_app_get_fit_par_by_id(ids[index],fit_param)
	if (cmpstr(nameofwave(fit_par_item),"") != 0)

		NVAR N_aitken = N_aitken_field 
		N_aitken = fit_par_item[1]
		NVAR Dp_aitken = Dp_aitken_field 
		Dp_aitken = fit_par_item[2]
		NVAR Sigma_aitken = Sigma_aitken_field 
		Sigma_aitken = fit_par_item[3]

		NVAR N_accum = N_accum_field 
		N_accum = fit_par_item[4]
		NVAR Dp_accum = Dp_accum_field 
		Dp_accum = fit_par_item[5]
		NVAR Sigma_accum = Sigma_accum_field 
		Sigma_accum = fit_par_item[6]

		NVAR N_ssa = N_ssa_field 
		N_ssa = fit_par_item[7]
		NVAR Dp_ssa = Dp_ssa_field 
		Dp_ssa = fit_par_item[8]
		NVAR Sigma_ssa = Sigma_ssa_field 
		Sigma_ssa = fit_par_item[9]

		NVAR chi_squared = chi_squared_field
		chi_squared = fit_par_item[10]

	endif

	db_app_update_fits_gui()

	//db_get_tmp_wave(base,xdim,ydim)
	
//	// redimension fit_par if necessary
//	if (dimsize(fit_par,0)<index+1)
//		redimension/N=(index+1,dimsize(fit_par,
	

	setdatafolder sdf
	
	killwaves/Z ids, fit_par_item
	
End

Function/WAVE db_app_get_fit_params(datasource,app_sig)
	string datasource
	string app_sig
		
	string sdf = db_goto_datasource(datasource)
	setdatafolder $app_sig
	
	wave fit_par = fit_params	
	setdatafolder sdf
	return fit_par	
End

Function/WAVE db_app_get_fit_par_by_id(id,fit_par)
	variable id
	wave fit_par
	
	variable row
	for (row=0; row<dimsize(fit_par,0); row+=1)
		if (fit_par[row][0] == id)
			wave tmp = db_get_tmp_wave("fit_param",dimsize(fit_par,1),0)
			tmp = fit_par[row][p]
			return tmp
		endif
	endfor
	return $""
		
End

Function db_app_update_fit_par(id,fit_par,fit_par_item)
	variable id
	wave fit_par
	wave fit_par_item
	
	variable row
	for (row=0; row<dimsize(fit_par,0); row+=1)
		if (fit_par[row][0] == id)
			fit_par[row][] = fit_par_item[q]
			return 1
		endif
	endfor
	
	// add a new row
	variable cnt = dimsize(fit_par,0)
	redimension/N=(cnt+1,dimsize(fit_par,1)) fit_par
	fit_par[cnt][] = fit_par_item[q]
	fit_par[cnt][0] = id
	return 1	
	
End	

Function/S db_goto_apps_pkg()
	
	string sdf = db_goto_acgdb_pkg()
	if (!datafolderexists("apps"))
		newdatafolder/o :apps
	endif
	setdatafolder :apps
	
	return sdf

End

Function/S db_goto_apps_fit_dist_pkg()
	
	string sdf = db_goto_apps_pkg()

	db_init_apps_fit_dist()
	
	setdatafolder :fit_dist
	
	return sdf

End


Function db_init_apps_fit_dist()

//	string sdf = db_goto_acgdb_pkg()
	
	if (!datafolderexists("fit_dist"))
	//if (1)
		newdatafolder/o/s :fit_dist
		
		make/o/n=10 dp_wave, dw_wave
		make/o/n=10 aitken_wave, accum_wave, ssa_wave, total_wave
			
		// checkboxes
		variable/G fit_aitken_cb = 1
		variable/G fit_accum_cb = 1
		variable/G fit_ssa_cb = 1

		// value fields
		variable/G index_upper_limit = 10
		variable/G index_field = 0
		
		variable/G N_aitken_field = 200
		variable/G Dp_aitken_field = 0.030
		variable/G Sigma_aitken_field = 1.5

		variable/G N_accum_field = 200
		variable/G Dp_accum_field = 0.120
		variable/G Sigma_accum_field = 1.5
		
		variable/G N_ssa_field = 10
		variable/G Dp_ssa_field = 0.230
		variable/G Sigma_ssa_field = 2.3

		variable/G chi_squared_field = 9999
		
		variable/G y_axis_upper_limit = 1000
		
		 // row of fit params for current id
		make/o/n=10 fit_param = {200,0.030,1.5,200,0.120,1.5,10,0.230,2.3,9999} // init to defaults
		
		string/G fit_par_name
		
		string/G data_src_label = ""
		string/G dataset_label = ""
		string/G start_dt = ""
		string/G stop_dt
		
		setdatafolder ::
	endif
	
//	setdatafolder sdf
	
End

Structure app_meta

	string app_name
	string app_path
	string app_data_recreate
	string data_list
	string default_data

EndStructure		

Function test_fn()
	
	Struct app_meta am
	am.app_name = "test_app"

	print am	
End

Function Fit_SizeDist_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//string sdf = getdatafolder(1)
			//setdatafolder ProjectInfo_folder
			//setdatafolder :gui_PIC
//			acg_goto_ProjectInfo()
//			//NVAR saved = proj_info_entry_saved
//			//saved = 0			
//			variable close_window = 0
			
			//print ba.ctrlName
			if (cmpstr(ba.ctrlName,"CloseButton")==0)
			
				killwindow db_app_fit_dist_win
						
//			elseif (cmpstr(ba.ctrlName,"cancel_button")==0)
//				killwindow db_add_dsrc_win
//				db_add_data_src()
//				print "reset"

			elseif (cmpstr(ba.ctrlName,"PrevButton")==0)
				
				string sdf = db_goto_apps_fit_dist_pkg()
				
				NVAR index = index_field
				if (index <= 0)
					 index = 0
					 return 0
				else
					index -= 1
				endif
				setdatafolder sdf
				
				db_update_app_fit_dist()

				
			elseif (cmpstr(ba.ctrlName,"NextButton")==0)
			
				sdf = db_goto_apps_fit_dist_pkg()

				NVAR index = index_field
				NVAR upper_limit = index_upper_limit
				if (index >= upper_limit)
					index = upper_limit
					return 0
				else
					index += 1
				endif
				setdatafolder sdf

				db_update_app_fit_dist()
			
			elseif (cmpstr(ba.ctrlName,"DoFitButton")==0)
			
				db_app_update_fits_gui()

				db_update_fit_param()

//				string sdf = db_goto_add_src_pkg()
//				SVAR data_name = data_src_wave
//				SVAR data_label = data_src_label
//				
//				SVAR dt_name = dt_src_wave
//				NVAR use_calc = dt_calc_cb
//				
//				SVAR axis2_name = axis2_src_wave			
//				NVAR is_dp = axis2_Dp_type_rb
//				NVAR is_ht = axis2_Ht_type_rb
//				
//				
//				
//				db_goto_active_db()
//				db_init_datasources()
//	
//				wave sources = data_sources
//				//wave data = $data_name
//		
//				// check to see if this datasource exists
//				if (db_find_datasource__(sources,data_name) >=0)
//					print "data source exists!"
//					return 0
//				endif
//				
//				// get dims
//				string dim_list = ""
//				if (cmpstr(dt_name,"") != 0 && !use_calc)
//					dim_list = db_set_srcdim__(dim_list,"DATETIME_AXIS",dt_name)
//				endif
//				
//				if (cmpstr(axis2_name,"") != 0)
//					string axis = ""
//					if (is_dp)
//						axis = "DP_AXIS"
//					elseif (is_ht)
//						axis = "HEIGHT_AXIS"
//					else
//						axis = ""
//					endif
//						
//					
//					dim_list = db_set_srcdim__(dim_list,axis,axis2_name)
//				endif
//				
//				if (cmpstr(dim_list,"")!=0)
//					print "	adding dimensions: ", dim_list
//				endif
//
//				// get unique label
//				string udata_label = db_get_unique_srclabel__(sources,data_name,data_label)
//				print "	data label: ", udata_label
//				
//				// set type
//				string types = db_get_srctypes__(sources)
//				string types_menu = addlistitem("<new type>",types)
//				variable menu_item = 1
//				string type = ""
//				prompt menu_item, "Data source type: ", popup, types_menu
//				DoPrompt "Select data source type",menu_item
//				if (V_Flag)
//					type = "default"
//				elseif (menu_item == 1)
//				//elseif (cmpstr(type,"<new type>") == 0)
//					prompt type, "New data source type: "
//					DoPrompt "Add new data source type", type
//				else
//					type = stringfromlist(menu_item-1,types_menu)
//				endif
//				print "	data source type: ", type
//					
//				print ""			
//				print "Updating data source" 				
//				db_update_datasource__(data_name,name=data_label,dims=dim_list,data_type=type)
//
//				setdatafolder sdf
								
			endif
			
			break
	endswitch

	return 0
End


Function db_app_fit_size_dist_gui()

	if (WinType("db_app_fit_dist_win")==7)
		DoWindow/F db_app_fit_dist_win
	else
	
		string sdf = db_goto_apps_fit_dist_pkg()
	
		PauseUpdate; Silent 1		// building window...
		NewPanel/N=db_app_fit_dist_win/W=(505,167,1424,966)
		SetDrawLayer UserBack
		TitleBox DataSourceTitle,pos={120,15},size={73,16},title="Data source",fSize=14
		TitleBox DataSourceTitle,frame=0
		SetVariable DataSourceLabel,pos={198,14},size={180,20},title=" ",fSize=14
		SetVariable DataSourceLabel,value= root:Packages:acg:acgdb:apps:fit_dist:data_src_label,noedit= 1
		TitleBox DataSetTitle,pos={542,15},size={47,16},title="Dataset",fSize=14,frame=0
		SetVariable DataSetLabel,pos={592,14},size={180,20},title=" ",fSize=14
		SetVariable DataSetLabel,value= root:Packages:acg:acgdb:apps:fit_dist:dataset_label,noedit= 1
		TitleBox StartTimeTitle,pos={184,516},size={58,16},title="Start time:",fSize=14
		TitleBox StartTimeTitle,frame=0
		SetVariable StartTimeLabel,pos={245,514},size={180,20},title=" ",fSize=14
		SetVariable StartTimeLabel,value= root:Packages:acg:acgdb:apps:fit_dist:start_dt,noedit= 1
		TitleBox StopTimeTitle,pos={487,517},size={59,16},title="Stop time:",fSize=14
		TitleBox StopTimeTitle,frame=0
		SetVariable StopTimeLabel,pos={551,515},size={180,20},title=" ",fSize=14
		SetVariable StopTimeLabel,value= root:Packages:acg:acgdb:apps:fit_dist:stop_dt,noedit= 1
		GroupBox AitkenBox,pos={223,593},size={133,132},title="Aitken"
		SetVariable aitken_N_var,pos={250,625},size={88,20},bodyWidth=74,title="N"
		SetVariable aitken_N_var,fSize=14
		SetVariable aitken_N_var,limits={-inf,inf,10},value= root:Packages:acg:acgdb:apps:fit_dist:N_aitken_field
		SetVariable aitken_Dp_var,pos={242,653},size={96,20},bodyWidth=74,title="Dp"
		SetVariable aitken_Dp_var,fSize=14
		SetVariable aitken_Dp_var,limits={-inf,inf,0.005},value= root:Packages:acg:acgdb:apps:fit_dist:Dp_aitken_field
		SetVariable aitken_Sigma_var,pos={252,681},size={86,20},bodyWidth=74,title="\\F'Symbol's\\]0"
		SetVariable aitken_Sigma_var,fSize=14
		SetVariable aitken_Sigma_var,limits={-inf,inf,0.05},value= root:Packages:acg:acgdb:apps:fit_dist:Sigma_aitken_field
		SetVariable accum_Dp_var,pos={412,658},size={96,20},bodyWidth=74,title="Dp"
		SetVariable accum_Dp_var,fSize=14
		SetVariable accum_Dp_var,limits={-inf,inf,0.005},value= root:Packages:acg:acgdb:apps:fit_dist:Dp_accum_field
		SetVariable accum_Sigma_var,pos={422,686},size={86,20},bodyWidth=74,title="\\F'Symbol's\\]0"
		SetVariable accum_Sigma_var,fSize=14
		SetVariable accum_Sigma_var,limits={-inf,inf,0.05},value= root:Packages:acg:acgdb:apps:fit_dist:Sigma_accum_field
		SetVariable accum_N_var,pos={420,630},size={88,20},bodyWidth=74,title="N"
		SetVariable accum_N_var,fSize=14
		SetVariable accum_N_var,limits={-inf,inf,10},value= root:Packages:acg:acgdb:apps:fit_dist:N_accum_field
		GroupBox AccumBox,pos={393,597},size={133,132},title="Accumulation"
		SetVariable ssa_Dp_var,pos={570,659},size={96,20},bodyWidth=74,title="Dp"
		SetVariable ssa_Dp_var,fSize=14
		SetVariable ssa_Dp_var,limits={-inf,inf,0.005},value= root:Packages:acg:acgdb:apps:fit_dist:Dp_ssa_field
		SetVariable ssa_Sigma_var,pos={580,687},size={86,20},bodyWidth=74,title="\\F'Symbol's\\]0"
		SetVariable ssa_Sigma_var,fSize=14
		SetVariable ssa_Sigma_var,limits={-inf,inf,0.05},value= root:Packages:acg:acgdb:apps:fit_dist:Sigma_ssa_field
		SetVariable ssa_N_var,pos={578,631},size={88,20},bodyWidth=74,title="N",fSize=14
		SetVariable ssa_N_var,limits={-inf,inf,10},value= root:Packages:acg:acgdb:apps:fit_dist:N_ssa_field
		GroupBox SSABox,pos={553,598},size={133,132},title="SSA"
		Button DoFitButton,pos={373,747},size={168,25},title="Do Fit",fSize=14
		Button DoFitButton proc=Fit_SizeDist_ButtonProc
		Button PrevButton,pos={368,560},size={50,20},title="\\W646",fSize=16
		Button PrevButton proc=Fit_SizeDist_ButtonProc
		Button NextButton,pos={495,561},size={50,20},title="\\W649",fSize=16
		Button NextButton proc=Fit_SizeDist_ButtonProc
		SetVariable index_label,pos={428,558},size={60,24},bodyWidth=60,title=" ",fSize=18
		SetVariable index_label,limits={0,inf,0},value= root:Packages:acg:acgdb:apps:fit_dist:index_field,noedit= 1
		NVAR iupper_limit = index_upper_limit
		SetVariable index_label,limits={0,iupper_limit,0}
		SetVariable chi_squared_value,pos={737,659},size={121,20},bodyWidth=121,title=" "
		SetVariable chi_squared_value,fSize=14
		SetVariable chi_squared_value,limits={-inf,inf,0},value= root:Packages:acg:acgdb:apps:fit_dist:chi_squared_field,noedit= 1
		TitleBox chsq_title,pos={738,638},size={75,16},title="Chi-Squared",fSize=14
		TitleBox chsq_title,frame=0
		Button CloseButton,pos={770,746},size={53,25},title="Close",fSize=14
		Button CloseButton proc=Fit_SizeDist_ButtonProc

		//String fldrSav0= GetDataFolder(1)
		wave dw = dw_wave
		wave dp = dp_wave
		wave aitken = aitken_wave
		wave accum = accum_wave
		wave ssa = ssa_wave
		wave total = total_wave
		
		//SetDataFolder root:Packages:acg:acgdb:apps:fit_dist:
		Display/W=(25,44,892,496)/HOST=#  dw vs dp
		//SetDataFolder fldrSav0
		RenameWindow #,SizeDistGraph
		AppendtoGraph aitken vs dp
		AppendtoGraph accum vs dp
		AppendtoGraph ssa vs dp
		AppendtoGraph total vs dp
		ModifyGraph log=1
		ModifyGraph rgb(accum_wave)=(0,39168,0);DelayUpdate
		ModifyGraph rgb(ssa_wave)=(65280,43520,0)
		ModifyGraph lsize(total_wave)=1.5,rgb(total_wave)=(0,0,0)
		NVAR y_max = y_axis_upper_limit
		SetAxis left 0.1,y_max
		
		SetActiveSubwindow ##
		
		setdatafolder sdf
	endif

End

// Will plot size dist and fit (aitken,accum,ssa and total) for the current dataset and user supplied index
Function db_plot_fit_by_index_bad(ds_id)
	variable ds_id

	string sdf = db_goto_apps_fit_dist_pkg()
	
		wave dp = dp_wave
		wave dw = dw_wave
		
		NVAR y_max = y_axis_upper_limit
		wavestats/Q dw
		y_max = V_max
		
		NVAR N_aitken = N_aitken_field 
		NVAR Dp_aitken = Dp_aitken_field 
		NVAR sigma_aitken = Sigma_aitken_field 
		wave aitken = aitken_wave
		db_lognormal_fn(N_aitken,Dp_aitken,sigma_aitken,dp,dw,aitken)
		

		NVAR N_accum = N_accum_field 
		NVAR Dp_accum = Dp_accum_field 
		NVAR sigma_accum = Sigma_accum_field 
		wave accum = accum_wave
		db_lognormal_fn(N_accum,Dp_accum,sigma_accum,dp,dw,accum)
		
		NVAR N_ssa = N_ssa_field 
		NVAR Dp_ssa = Dp_ssa_field 
		NVAR sigma_ssa = Sigma_ssa_field 
		wave ssa = ssa_wave
		db_lognormal_fn(N_ssa,Dp_ssa,sigma_ssa,dp,dw,ssa)
		
		wave total = total_wave
		total = aitken+accum+ssa
		wavestats/Q total
		y_max = (V_max > y_max) ? V_max : y_max
			
		NVAR chi_squared = chi_squared_field
		chi_squared = db_get_chi_sq(dp, total, dw)

		wavestats/Q dw
		variable ymax = V_max
		wavestats/Q total
		ymax = (V_max > ymax) ? V_max : ymax
		SetAxis/W=#SizeDistGraph left  0.1, ymax
	setdatafolder sdf

End

Function db_app_update_fits_gui()

	string sdf = db_goto_apps_fit_dist_pkg()
	
		wave dp = dp_wave
		wave dw = dw_wave
		
		NVAR y_max = y_axis_upper_limit
		wavestats/Q dw
		y_max = V_max
		
		NVAR N_aitken = N_aitken_field 
		NVAR Dp_aitken = Dp_aitken_field 
		NVAR sigma_aitken = Sigma_aitken_field 
		wave aitken = aitken_wave
		db_lognormal_fn(N_aitken,Dp_aitken,sigma_aitken,dp,dw,aitken)
		

		NVAR N_accum = N_accum_field 
		NVAR Dp_accum = Dp_accum_field 
		NVAR sigma_accum = Sigma_accum_field 
		wave accum = accum_wave
		db_lognormal_fn(N_accum,Dp_accum,sigma_accum,dp,dw,accum)
		
		NVAR N_ssa = N_ssa_field 
		NVAR Dp_ssa = Dp_ssa_field 
		NVAR sigma_ssa = Sigma_ssa_field 
		wave ssa = ssa_wave
		db_lognormal_fn(N_ssa,Dp_ssa,sigma_ssa,dp,dw,ssa)
		
		wave total = total_wave
		total = aitken+accum+ssa
		wavestats/Q total
		y_max = (V_max > y_max) ? V_max : y_max
			
		NVAR chi_squared = chi_squared_field
		chi_squared = db_get_chi_sq(dp, total, dw)

		wavestats/Q dw
		variable ymax = V_max
		wavestats/Q total
		ymax = (V_max > ymax) ? V_max : ymax
		SetAxis/W=#SizeDistGraph left  0.1, ymax
	setdatafolder sdf

End

// Changed to use ln instead of log 06June2017 Oops
Function db_lognormal_fn(Ntot,Dmean,sigma,dp,dn,out_w)
	variable Ntot, Dmean, sigma
	wave dp
	wave dn
	wave out_w
	
	out_w = ( Ntot / (sqrt(2*pi)*ln(sigma)) ) * exp( -(( ln(dp[p]) - ln(Dmean))^2 ) / (2*(ln(sigma))^2) )
	
End

Function db_get_chi_sq(x, fit_y, obs_y)
	wave x
	wave fit_y
	wave obs_y
	
	variable chisq
	StatsChiTest obs_y,fit_y
	wave stats = W_StatsChiTest
	return stats[2]
	
End

Function db_update_fit_param()
	
	wave ids = db_get_ds_ids()
	
	string sdf = db_goto_apps_fit_dist_pkg()

	// get struct -----
	setdatafolder :run
	
	STRUCT AppData_fit_dist fd_data
	
	SVAR sig = app_sig
	fd_data.app_sig = sig
	
	SVAR dsource = datasource
	fd_data.datasource = dsource
	
	SVAR dset = dataset
	fd_data.dataset = dset
	
	SVAR avgname = avgdata_name
	fd_data.avgdata_name = avgname
	
	SVAR dpname = dp_name
	fd_data.dp_name = dpname
	
	setdatafolder ::
	// ------


	NVAR index = index_field
	variable id = ids[index]
	
	NVAR N_aitken = N_aitken_field 
	NVAR Dp_aitken = Dp_aitken_field 
	NVAR sigma_aitken = Sigma_aitken_field 

	NVAR N_accum = N_accum_field 
	NVAR Dp_accum = Dp_accum_field 
	NVAR sigma_accum = Sigma_accum_field 

	NVAR N_ssa = N_ssa_field 
	NVAR Dp_ssa = Dp_ssa_field 
	NVAR sigma_ssa = Sigma_ssa_field 

	NVAR chi_squared = chi_squared_field

	wave fit_par = db_app_get_fit_params(fd_data.datasource,fd_data.app_sig)
	make/o/n=11 tmp_fit_par
	wave fp = tmp_fit_par
	
	fp[0] = id
	
	fp[1] = N_aitken
	fp[2] = Dp_aitken
	fp[3] = sigma_aitken
	
	fp[4] = N_accum
	fp[5] = Dp_accum
	fp[6] = sigma_accum

	fp[7] = N_ssa
	fp[8] = Dp_ssa
	fp[9] = sigma_ssa

	fp[10] = chi_squared
	
	db_app_update_fit_par(id,fit_par,fp)
	
	setdatafolder sdf 
	
	killwaves/Z ids
End

// App: average ccn (turns 1d into 2d data
Function db_app_average_ccn_data([datasource,dataset])
	string datasource
	string dataset
	
	string APP_SIGNATURE = "average_ccn"
	string app_long_name = "Average CCN (and stats)"
	db_register_app(APP_SIGNATURE,app_long_name,"db_app_average_ccn_data([datasource,dataset])")
	//db_register_app_dependence(APP_SIGNATURE,"")
	
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "Data source: ", popup, labels
		DoPrompt "Select data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		datasource = stringfromlist(label_item-1,labels)
	endif
	string datasource_path = db_get_path_by_label(datasource)
	string datasource_dims = db_get_dims_by_label(datasource)
	
	print "App: ", APP_SIGNATURE
	print "	DB: ", db_get_active_db()
	print "		Dataset: ", dataset
	print "			Data: ", datasource_path
	
	
	wave data = $datasource_path
		
	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
	variable clean_up_dt = 0
	if(cmpstr(dt_name,"") == 0)
		// use wavescaling
		wave dt = acg_extract_dt(data)
		dt_name = nameofwave(dt)
		print "dt_name = ", dt_name
		clean_up_dt = 1			
	endif
	wave dt = $dt_name
	
	// get ss wave from 2d dim setting for SS
	string axis2_name = db_get_srcdim__(datasource_dims, "SS_AXIS")
	wave ss = $axis2_name
	
	// get ss_setting from folder containing datasource
	string ccn_fldr = getwavesdatafolder(data,1)
	wave ss_setting = $(ccn_fldr+"SS_setting")
	
	
//	variable is_2d = 0
//	if (dimsize(data,1)) // 2d wave
//		string axis2_name = db_get_srcdim__(datasource_dims, "DP_AXIS")
//		if (cmpstr(axis2_name,"")==0)
//			axis2_name = db_get_srcdim__(datasource_dims, "HEIGHT_AXIS")
//		endif
//		if (cmpstr(axis2_name,"")==0)
//			axis2_name = db_get_srcdim__(datasource_dims, "SS_AXIS")
//		endif
//		print "axis2_name", axis2_name
//		
//		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
//		is_2d = 1
//	endif
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(datasource)

	newdatafolder/o $APP_SIGNATURE
	
	// add meta - maybe add global STRUCT to define meta values
	string RECREATE = "db_app_average_data(datasource=\""+datasource+"\",dataset=\""+dataset+"\")"
	db_app_update_meta__(datasource, APP_SIGNATURE,"RECREATE",APP_SIGNATURE,RECREATE)
	
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	newdatafolder/o/s $APP_SIGNATURE
	
	// create app data waves 
	make/o/n=(numpnts(ids),numpnts(ss)) $"data_avg"
	wave dat_avg = $"data_avg"

	make/o/n=(numpnts(ids),numpnts(ss)) $"data_sd"
	wave dat_sd = $"data_sd"
	
	make/o/n=(numpnts(ids),numpnts(ss)) $"data_min"
	wave dat_min = $"data_min"

	make/o/n=(numpnts(ids),numpnts(ss)) $"data_max"
	wave dat_max = $"data_max"
	
	// create wave for convenience
	duplicate/o ss, $"ss_dimension"

	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_avg,is_default=1)
	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_sd)
	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_min)
	db_app_update_wavelist__(datasource,APP_SIGNATURE,dat_max)
	
	
	// create working dt waves
	make/o/n=1 start_dt_wave
	wave start_dt = start_dt_wave	
	make/o/n=1 stop_dt_wave
	wave stop_dt = stop_dt_wave	


	variable tol = 0.0001
	variable i
	for (i=0; i<numpnts(ids); i+=1)
	
		start_dt[0] = db_get_ds_entry_start_dt(ids[i])
		stop_dt[0] = db_get_ds_entry_stop_dt(ids[i])
		
		variable start_index =  binarysearch(dt, start_dt[0])
		variable stop_index = binarysearch(dt, stop_dt[0])
		
		if (start_index == -1 && stop_index==-1)
			continue
		elseif (start_index == -2 && stop_index==-2)
			continue
		elseif (start_index==-1 && stop_index>=0)
			start_index = 0
		elseif(start_index>=0 && stop_index==-2)
			stop_index = numpnts(dt)-1
		endif

		// working wave for averages
		make/o/n=( (stop_index-start_index+1),numpnts(ss)) working_ccn
		wave working = working_ccn
		working = NaN
		
		variable row
		for (row=start_index; row<=stop_index; row+=1)
			variable ccn = data[row]
			variable ss_val = ss_setting[row]
			
			variable ssi
			for (ssi=0; ssi<numpnts(ss); ssi+=1)
//				print ssi, ss[ssi], ss_val, tol, ss[ssi]-ss_val
				if ( abs(ss[ssi] - ss_val) < tol)
					working[row-start_index][ssi] = ccn
					break
//					continue
				endif
			endfor
		endfor
		
		for (ssi=0; ssi<numpnts(ss); ssi+=1)
			
			wavestats/Q/RMD=[0,numpnts(working)-1][ssi,ssi] working
			dat_avg[i][ssi] = V_avg
			dat_sd[i][ssi] = V_sdev
			dat_min[i][ssi] = V_min
			dat_max[i][ssi] = V_max
//			print ss[ssi], i, ssi, dat_avg[i][ssi]
		endfor
		
		// average data
//		string output = "output"
//		if (is_2d)
//			acg_avg_using_time_index_2d(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_avg[i][] = out[0][q]
//			
//			acg_sd_using_time_index_2d(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_sd[i][] = out[0][q]
//
//			acg_min_using_time_index_2d(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_min[i][] = out[0][q]
//
//			acg_max_using_time_index_2d(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_max[i][] = out[0][q]
//			
//		else
//			acg_avg_using_time_index(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_avg[i] = out[0]
//				
//			acg_sd_using_time_index(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_sd[i] = out[0]
//
//			acg_min_using_time_index(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_min[i] = out[0]
//
//			acg_max_using_time_index(start_dt, stop_dt, dt, data, output)
//			wave out = $output
//			dat_max[i] = out[0]
//		endif
		
	endfor

	// clean up tmp waves
	if (clean_up_dt)
		killwaves/Z dt
	endif
	killwaves/Z ids,start_dt,stop_dt,out, working
	
	setdatafolder sdf
End


// App: kappa - use size dist as datasource

Function db_app_find_kappa([ccn_datasource, sizing_datasource, dataset])
	string ccn_datasource
	string sizing_datasource
	string dataset
	
	string APP_SIGNATURE = "kappa"
	string app_long_name = "Find kappa from size distribution"
	// change!
	db_register_app(APP_SIGNATURE,app_long_name,"db_app_find_kappa([datasource,dataset])")
	
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(ccn_datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "CCN Data source: ", popup, labels
		DoPrompt "Select  CCN data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		ccn_datasource = stringfromlist(label_item-1,labels)
	endif
	string ccn_datasource_path = db_get_path_by_label(ccn_datasource)
	string ccn_datasource_dims = db_get_dims_by_label(ccn_datasource)
	
	print "App: ", APP_SIGNATURE
	print "	DB: ", db_get_active_db()
	print "		Dataset: ", dataset
	print "			Data: ", ccn_datasource_path
	
	wave ccn_data = $ccn_datasource_path

	string cdf = db_goto_datasource(ccn_datasource)
	wave ccn_avg = :average_ccn:data_avg
	wave ccn_sd = :average_ccn:data_sd
	setdatafolder cdf


	if (ParamIsDefault(sizing_datasource))
		labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		label_item = 1
		prompt label_item, "Sizing Data source: ", popup, labels
		DoPrompt "Select  Sizing data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		sizing_datasource = stringfromlist(label_item-1,labels)
		print "sizing_datasource(label) = ", sizing_datasource
	endif
	string sizing_datasource_path = db_get_path_by_label(sizing_datasource)
	string sizing_datasource_dims = db_get_dims_by_label(sizing_datasource)
	
	wave sizing_data = $sizing_datasource_path

//	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
//	variable clean_up_dt = 0
//	if(cmpstr(dt_name,"") == 0)
//		// use wavescaling
//		wave dt = acg_extract_dt(data)
//		dt_name = nameofwave(dt)
//		print "dt_name = ", dt_name
//		clean_up_dt = 1			
//	endif
//	wave dt = $dt_name
	
	// sizing
	variable is_2d = 0
	if (dimsize(sizing_data,1)) // 2d wave
		string dp_name = db_get_srcdim__(sizing_datasource_dims, "DP_AXIS")
		if (cmpstr(dp_name,"")==0)
			print "Dp axis not defined"
			return 0
		endif
		print "dp_name", dp_name
		
		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
		is_2d = 1
	else
		return 1 // needs to be a 2d wave
	endif
	wave dp = $dp_name
	// get averaged sizing data
	string tdf = db_goto_datasource(sizing_datasource)
	wave sizing_avg = :average:data_avg
	setdatafolder tdf
	
	// ccn
	is_2d = 0
	//if (dimsize(ccn_data,1)) // 2d wave
	string ss_name = db_get_srcdim__(ccn_datasource_dims, "SS_AXIS")
	if (cmpstr(ss_name,"")==0)
		print "SS axis not defined"
		return 0
	endif
	print "ss_name", ss_name
		
//		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
//		is_2d = 1
//	else
//		return 1 // needs to be a 2d wave
//	endif
	wave ss = $ss_name
	
	// needs average data to find kappa
	//wave data_avg = $(db_get_app_data(datasource,"average"))
	// check to see if data_avg is current by comparing modtimes
	//wave dat_avg = $"data_avg"
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(ccn_datasource)

	// add meta - maybe add global STRUCT to define meta values
//	string RECREATE = "db_app_find_kappa(ccn_datasource=\""+ccn_datasource+"\",sizing_datasource=\""+sizing_datasource+"\",dataset=\""+dataset+"\")"
	//db_app_update_meta__("RECREATE",APP_SIGNATURE,RECREATE)
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	newdatafolder/o/s $APP_SIGNATURE
	newdatafolder/o/s $sizing_datasource

// START HERE FOR NEW APP

	// create app data waves 
	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_avg"
	wave kappa_avg = $"kappa_avg"

	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_sd"
	wave kappa_sd = $"kappa_sd"
	
//	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_min"
//	wave kappa_min = $"kappa_min"
//
//	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_max"
//	wave kappa_max = $"kappa_max"

	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_0_5_avg"
	wave kappa_0_5_avg = $"kappa_0_5_avg"

	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_0_5_sd"
	wave kappa_0_5_sd = $"kappa_0_5_sd"
	
//	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_0_5_min"
//	wave kappa_0_5_min = $"kappa_0_5_min"
//
//	make/o/n=(numpnts(ids),numpnts(ss)) $"kappa_0_5_max"
//	wave kappa_0_5_max = $"kappa_0_5_max"

	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_avg"
	wave dp_crit_avg = $"dp_crit_avg"

	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_sd"
	wave dp_crit_sd = $"dp_crit_sd"

//	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_min"
//	wave dp_crit_min = $"dp_crit_min"
//
//	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_max"
//	wave dp_crit_max = $"dp_crit_max"

	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_0_5_avg"
	wave dp_crit_0_5_avg = $"dp_crit_0_5_avg"

	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_0_5_sd"
	wave dp_crit_0_5_sd = $"dp_crit_0_5_sd"

//	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_0_5_min"
//	wave dp_crit_0_5_min = $"dp_crit_0_5_min"
//
//	make/o/n=(numpnts(ids), numpnts(ss)) $"dp_crit_0_5_max"
//	wave dp_crit_0_5_max = $"dp_crit_0_5_max"

	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,kappa_0_5_avg,is_default=1)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,kappa_0_5_sd)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,kappa_0_5_min)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,kappa_0_5_max)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,kappa_avg)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,kappa_sd)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,kappa_min)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,kappa_max)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,dp_crit_avg)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,dp_crit_sd)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,dp_crit_min)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,dp_crit_max)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,dp_crit_0_5_avg)
	db_app_update_wavelist__(ccn_datasource,APP_SIGNATURE,dp_crit_0_5_sd)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,dp_crit_0_5_min)
//	db_app_update_wavelist__(datasource,APP_SIGNATURE,dp_crit_0_5_max)
	
	
//	// hard_code for now
//	wave ccn_avg = :::average_ccn:data_avg
//	wave ccn_sd = :::average_ccn:data_sd
//	//wave dp = 
	
//	// create data for gui
//	STRUCT AppData_find_kappa fk_data
//	fk_data.app_sig = APP_SIGNATURE
//	fk_data.datasource = datasource
//	fk_data.dataset = dataset
//	fk_data.avgdata_name = getwavesdatafolder(data_avg,2)
//	fk_data.dp_name = dp_name
//	fk_data.dp_crit_name = getwavesdatafolder(dp_crit,2)
//	fk_data.kappa_name = getwavesdatafolder(kappa,2)
//	fk_data.ss_name = getwavesdatafolder(ss,2)
	
	//db_update_appdata_fit_dist(fd_data)

	// *** Calculate critial dp and kappas ***
	variable idi, ssi
	for (idi=0; idi<numpnts(ids); idi+=1)
	
		make/o/n=(dimsize(sizing_avg,1)) tmp_distribution
		wave tmp_dist = tmp_distribution
		tmp_dist = sizing_avg[idi][p]
		
		for (ssi=0; ssi<numpnts(ss); ssi+=1)
			variable crit_conc = ccn_avg[idi][ssi]
			variable crit_conc_sd = ccn_sd[idi][ssi]
//			print ss[ssi], crit_conc
			
			// find dp_crit/kappa for crit and crit_0_5 for avg, min, max

			// conc/2
//			dp*=1000
			variable dp_crit = sizing_find_critical_dp_single(dp, tmp_dist, (crit_conc/2))
//			dp_crit /= 1000
//			dp/=1000
			variable dp_crit_plus = sizing_find_critical_dp_single(dp, tmp_dist, ((crit_conc+crit_conc_sd)/2))
			variable dp_crit_minus = sizing_find_critical_dp_single(dp, tmp_dist, ((crit_conc-crit_conc_sd)/2))
			dp_crit_0_5_avg[idi][ssi] = dp_crit
//			print "dp_crit[][]", idi, ssi, ss[ssi], dp_crit_0_5_avg[idi][ssi], crit_conc
			if (numtype(dp_crit)==0)
				variable k = ccn_find_kappa(ss[ssi], (dp_crit*1000), 0.073)
				kappa_0_5_avg[idi][ssi] = k
			else
				kappa_0_5_avg[idi][ssi] = NaN
				dp_crit_plus = NaN
				dp_crit_minus = NaN
			endif
			
			if (numtype(dp_crit_plus)==0 && numtype(dp_crit_minus)==0)
				dp_crit_0_5_sd[idi][ssi] = abs(dp_crit_plus-dp_crit_minus)/2
				variable k_plus= ccn_find_kappa(ss[ssi], (dp_crit_plus*1000), 0.073)
				variable k_minus= ccn_find_kappa(ss[ssi], (dp_crit_minus*1000), 0.073)
				kappa_0_5_sd[idi][ssi] = abs(k_plus-k_minus)/2
			else
				dp_crit_0_5_sd[idi][ssi] = NaN
				kappa_0_5_sd[idi][ssi]  = NaN
			endif

			// conc
			dp_crit = sizing_find_critical_dp_single(dp, tmp_dist, (crit_conc))
			dp_crit_plus = sizing_find_critical_dp_single(dp, tmp_dist, ((crit_conc+crit_conc_sd)))
			dp_crit_minus = sizing_find_critical_dp_single(dp, tmp_dist, ((crit_conc-crit_conc_sd)))
			dp_crit_avg[idi][ssi] = dp_crit

			if (numtype(dp_crit)==0)
				k = ccn_find_kappa(ss[ssi], (dp_crit*1000), 0.073)
				kappa_avg[idi][ssi] = k
			else
				kappa_avg[idi][ssi] = NaN
				dp_crit_plus = NaN
				dp_crit_minus = NaN
			endif
			
			if (numtype(dp_crit_plus)==0 && numtype(dp_crit_minus)==0)
				dp_crit_sd[idi][ssi] = abs(dp_crit_plus-dp_crit_minus)/2
				k_plus= ccn_find_kappa(ss[ssi], (dp_crit_plus*1000), 0.073)
				k_minus= ccn_find_kappa(ss[ssi], (dp_crit_minus*1000), 0.073)
				kappa_sd[idi][ssi] = abs(k_plus-k_minus)/2
			else
				dp_crit_sd[idi][ssi] = NaN
				kappa_sd[idi][ssi]  = NaN
			endif
			
			
		endfor
		
//		sizing_find_critical_dp(inst,tb,Conc_dt, Conc_crit,diam_type)
	endfor
	
	// show window
	 //db_app_fit_size_dist_gui()
	 
	 killwaves/Z ids, tmp_distribution

End

Function db_plot_kappa([ccn_datasource, sizing_datasource, dataset, add_to_current, crit_ratio, error_bars, add_labels])
	string ccn_datasource
	string sizing_datasource
	string dataset
	string add_to_current // Default: false
	string crit_ratio // "1" or "0.5" Default: "0.5"
	string error_bars // Default: false
	string add_labels
	
	
	string APP_SIGNATURE = "kappa"
	string sdf = getdatafolder(1)

	variable new_plot = 1
	variable init_curve_cnt = 0
	if (!ParamIsDefault(add_to_current) && cmpstr(add_to_current,"true")==0)
		new_plot = 0
		init_curve_cnt = itemsinlist(tracenamelist("",";",1+4))/2
	endif

	if (ParamIsDefault(add_labels))
		add_labels = "false"
	endif
	
	string ratio_str = "_0_5"
	if (!ParamIsDefault(crit_ratio) && cmpstr(crit_ratio,"1")==0)
		ratio_str=""
	endif
	
	variable do_error_bars = 0
	if (!ParamIsDefault(error_bars) && cmpstr(error_bars,"true")==0)
		do_error_bars = 1
	endif
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(ccn_datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "CCN Data source: ", popup, labels
		DoPrompt "Select  CCN data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		ccn_datasource = stringfromlist(label_item-1,labels)
	endif
	string ccn_datasource_path = db_get_path_by_label(ccn_datasource)
	string ccn_datasource_dims = db_get_dims_by_label(ccn_datasource)
//	
//	print "App: ", APP_SIGNATURE
//	print "	DB: ", db_get_active_db()
//	print "		Dataset: ", dataset
//	print "			Data: ", ccn_datasource_path
//	
//	wave ccn_data = $ccn_datasource_path
//
//	string cdf = db_goto_datasource(ccn_datasource)
//	wave ccn_avg = :average_ccn:data_avg
//	wave ccn_sd = :average_ccn:data_sd
//	setdatafolder cdf


	if (ParamIsDefault(sizing_datasource))
		labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		label_item = 1
		prompt label_item, "Sizing Data source: ", popup, labels
		DoPrompt "Select  Sizing data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		sizing_datasource = stringfromlist(label_item-1,labels)
//		print "sizing_datasource(label) = ", sizing_datasource
	endif
	string sizing_datasource_path = db_get_path_by_label(sizing_datasource)
	string sizing_datasource_dims = db_get_dims_by_label(sizing_datasource)
//	
//	wave sizing_data = $sizing_datasource_path

//	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
//	variable clean_up_dt = 0
//	if(cmpstr(dt_name,"") == 0)
//		// use wavescaling
//		wave dt = acg_extract_dt(data)
//		dt_name = nameofwave(dt)
//		print "dt_name = ", dt_name
//		clean_up_dt = 1			
//	endif
//	wave dt = $dt_name
	
	// sizing
	variable is_2d = 0
//	if (dimsize(sizing_data,1)) // 2d wave
//		string dp_name = db_get_srcdim__(sizing_datasource_dims, "DP_AXIS")
//		if (cmpstr(dp_name,"")==0)
//			print "Dp axis not defined"
//			return 0
//		endif
//		print "dp_name", dp_name
//		
//		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
//		is_2d = 1
//	else
//		return 1 // needs to be a 2d wave
//	endif
//	wave dp = $dp_name
//	// get averaged sizing data
//	string tdf = db_goto_datasource(sizing_datasource)
//	wave sizing_avg = :average:data_avg
//	setdatafolder tdf
	
	// ccn
	is_2d = 0
	//if (dimsize(ccn_data,1)) // 2d wave
	string ss_name = db_get_srcdim__(ccn_datasource_dims, "SS_AXIS")
	if (cmpstr(ss_name,"")==0)
		print "SS axis not defined"
		return 0
	endif
//	print "ss_name", ss_name
		
//		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
//		is_2d = 1
//	else
//		return 1 // needs to be a 2d wave
//	endif
	wave ss = $ss_name
	
	// needs average data to find kappa
	//wave data_avg = $(db_get_app_data(datasource,"average"))
	// check to see if data_avg is current by comparing modtimes
	//wave dat_avg = $"data_avg"
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(ccn_datasource)

	// add meta - maybe add global STRUCT to define meta values
	string RECREATE = "db_app_find_kappa(ccn_datasource=\""+ccn_datasource+"\",sizing_datasource=\""+sizing_datasource+"\",dataset=\""+dataset+"\")"
	//db_app_update_meta__("RECREATE",APP_SIGNATURE,RECREATE)
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	setdatafolder $APP_SIGNATURE
	setdatafolder $sizing_datasource
	
	string dp_crit_avg_name  = "dp_crit"+ratio_str+"_avg"
	wave dp_crit_avg = $dp_crit_avg_name
	string dp_crit_sd_name  = "dp_crit"+ratio_str+"_sd"
	wave dp_crit_sd = $dp_crit_sd_name

	string kappa_avg_name  = "kappa"+ratio_str+"_avg"
	wave kappa_avg = $kappa_avg_name
	string kappa_sd_name  = "kappa"+ratio_str+"_sd"
	wave kappa_sd = $kappa_sd_name
	
	// markers: plus, circle, square, up tri, down tri, left tri, rt tri, h diamond, v diamond, fat diamond, h bowtie, v bowtie, star
	string markers = "0;19;16;17;23;46;49;26;29;18;15;14;60;"
	// blue = (1,12815,52428)
	
	string legend_txt =" Dataset: " + dataset
	variable idi
//	variable build_legend = new_plot
	for (idi=0; idi<numpnts(ids); idi+=1)
		if (new_plot)
			display dp_crit_avg[idi][] vs ss
			new_plot=0
		else
			appendtograph dp_crit_avg[idi][] vs ss
		endif
		
		appendtograph/R kappa_avg[idi][] vs ss

		// get wavenames for plots
		string dp_name = dp_crit_avg_name
		string kappa_name = kappa_avg_name
		if (idi>0 || init_curve_cnt>0 ) // how to do this with appended plots
			variable tr_num 
			dp_name +="#"+num2str(init_curve_cnt+idi)
			kappa_name +="#"+num2str(init_curve_cnt+idi)			
		endif
		
		if (do_error_bars)
			ErrorBars $dp_name Y,wave=(dp_crit_sd[idi][*],dp_crit_sd[idi][*])
			ErrorBars $kappa_name Y,wave=(kappa_sd[idi][*],kappa_sd[idi][*])
		endif
		
		// change dp to blue
		ModifyGraph rgb($dp_name)=(1,12815,52428)
		// change to line&marker and set marker based on dataset entry id
		ModifyGraph mode($dp_name)=4,marker($dp_name)=str2num(stringfromlist(ids[idi], markers))
		ModifyGraph mode($kappa_name)=4,marker($kappa_name)=str2num(stringfromlist(ids[idi], markers))

		// build legend
//		if (build_legend)
		legend_txt += "\n\s("+dp_name+")"+db_get_ds_meta(ids[idi],"name")
//		endif
	endfor
	
	// axes and labels	
	ModifyGraph axRGB(left)=(1,12815,52428),tlblRGB(left)=(1,12815,52428),alblRGB(left)=(1,12815,52428)
	Label left "\K(1,12815,52428)Critical D\\Bp\\M (um)"
	ModifyGraph axRGB(right)=(65535,0,0),tlblRGB(right)=(65535,0,0),alblRGB(right)=(65535,0,0)
	Label right "\K(65535,0,0)Kappa"
	Label bottom, "Supersatuation (%)"

	if (cmpstr(add_labels,"true")==0)
		Legend/C/N=traces/A=MC legend_txt
	endif
	
	setdatafolder sdf
End

Function db_plot_average_ccn([datasource, dataset, add_to_current, error_bars, add_labels])
	string datasource
	string dataset
	string add_to_current // Default: false
	string error_bars // Default: false
	string add_labels
	
	
	string APP_SIGNATURE = "average_ccn"
	string sdf = getdatafolder(1)

	variable new_plot = 1
	variable init_curve_cnt = 0
	if (!ParamIsDefault(add_to_current) && cmpstr(add_to_current,"true")==0)
		new_plot = 0
		init_curve_cnt = itemsinlist(tracenamelist("",";",1+4))
	endif

	if (ParamIsDefault(add_labels))
		add_labels = "false"
	endif
		
	variable do_error_bars = 0
	if (!ParamIsDefault(error_bars) && cmpstr(error_bars,"true")==0)
		do_error_bars = 1
	endif
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "CCN Data source: ", popup, labels
		DoPrompt "Select  CCN data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		datasource = stringfromlist(label_item-1,labels)
	endif
	string datasource_path = db_get_path_by_label(datasource)
	string datasource_dims = db_get_dims_by_label(datasource)

	
	variable is_2d = 0
	string ss_name = db_get_srcdim__(datasource_dims, "SS_AXIS")
	if (cmpstr(ss_name,"")==0)
		print "SS axis not defined"
		return 0
	endif
	wave ss = $ss_name
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(datasource)

	// set to APP datafolder
	setdatafolder $APP_SIGNATURE
	
	string data_avg_name  = "data_avg"
	wave data_avg = $data_avg_name
	string data_sd_name  = "data_sd"
	wave data_sd = $data_sd_name
	
	// markers: plus, circle, square, up tri, down tri, left tri, rt tri, h diamond, v diamond, fat diamond, h bowtie, v bowtie, star
	string markers = "0;19;16;17;23;46;49;26;29;18;15;14;60;"
	// blue = (1,12815,52428)
	
	string legend_txt =" Dataset: " + dataset
	variable idi
//	variable build_legend = new_plot
	for (idi=0; idi<numpnts(ids); idi+=1)
		if (new_plot)
			display data_avg[idi][] vs ss
			new_plot=0
		else
			appendtograph data_avg[idi][] vs ss
		endif
		
		// get wavenames for plots
		string data_name = data_avg_name
		if (idi>0 || init_curve_cnt>0 ) // how to do this with appended plots
			data_name +="#"+num2str(init_curve_cnt+idi)
		endif
		
		if (do_error_bars)
			ErrorBars $data_name Y,wave=(data_sd[idi][*],data_sd[idi][*])
		endif
		
//		// change dp to blue
//		ModifyGraph rgb($data_name)=(1,12815,52428)
		// change to line&marker and set marker based on dataset entry id
		ModifyGraph mode($data_name)=4,marker($data_name)=str2num(stringfromlist(ids[idi], markers))

		// build legend
//		if (build_legend)
		legend_txt += "\n\s("+data_name+")"+db_get_ds_meta(ids[idi],"name")
//		endif
	endfor
	
	// axes and labels	
//	ModifyGraph axRGB(left)=(1,12815,52428),tlblRGB(left)=(1,12815,52428),alblRGB(left)=(1,12815,52428)
	Label left "CCN (cm\S-3\M)"
	Label bottom, "Supersatuation (%)"

	if (cmpstr(add_labels,"true")==0)
		Legend/C/N=traces/A=MC legend_txt
	endif
	
	setdatafolder sdf
End

// QUICK AND DIRTY
// Need be in working folder
Function dev_average_by_index_list(data,index_list,out_name)
	wave data
	string index_list
	string out_name
	
	wave w = data
	variable rows = dimsize(w,0)
	variable cols = dimsize(w,1)
	
	newdatafolder/o/s :averages
	make/o/n=(cols) $out_name
	wave out = $out_name
	setdatafolder ::
	
	make/o/n=(itemsinlist(index_list)) tmp_wave
	wave tmp = tmp_wave
	variable coli
	for (coli=0; coli<cols; coli+=1)
		tmp = NaN
		
		variable listi
		for (listi=0; listi<itemsinlist(index_list); listi+=1)
			variable index = str2num(stringfromlist(listi,index_list))
			tmp[listi] = w[index-1][coli]
		endfor
		
		wavestats/Q tmp
		out[coli] = V_avg
	endfor
			
	killwaves/Z tmp
End

Function db_do_calcs_fit_params(calc_fn, [datasource, dataset])
	string calc_fn // "modal_frac",  
	string datasource
	string dataset
	
	string valid_calc_fn = "modal_frac;"
	
	if (whichlistitem(calc_fn,valid_calc_fn) < 0)
		print "invalid calc_fn: ", calc_fn
		return 0
	endif
	
	string APP_SIGNATURE = "fit_size_dist"
	string sdf = getdatafolder(1)
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "Data source: ", popup, labels
		DoPrompt "Select  data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		datasource = stringfromlist(label_item-1,labels)
	endif
	string datasource_path = db_get_path_by_label(datasource)
	string datasource_dims = db_get_dims_by_label(datasource)

	
//	variable is_2d = 0
//	string ss_name = db_get_srcdim__(datasource_dims, "SS_AXIS")
//	if (cmpstr(ss_name,"")==0)
//		print "SS axis not defined"
//		return 0
//	endif
//	wave ss = $ss_name
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(datasource)

	// set to APP datafolder
	setdatafolder $APP_SIGNATURE

	wave fit_par = $"fit_params"

	newdatafolder/o/s calcs
	newdatafolder/o/s $calc_fn
	
	
	// create standard waves
	
	variable nper = dimsize(fit_par,0)
	
	make/o/n=(nper)/T $"data_period_name"
	wave/T name = $"data_period_name"
	
	make/o/n=(nper)/D $"data_period_start_dt"
	wave start_dt = $"data_period_start_dt"

	make/o/n=(nper)/D $"data_period_stop_dt"
	wave stop_dt = $"data_period_stop_dt"

	make/o/n=(nper) $"chi_squared"
	wave chi_sq = $"chi_squared"

	make/o/n=(nper) $"data_period_id"
	wave per_id = $"data_period_id"
	
	variable i
	for (i=0; i<nper; i+=1)

		name = db_get_ds_meta(fit_par[i],"name")

		wave entry = db_get_ds_entry(fit_par[i])
		start_dt[i] = entry[1]
		stop_dt[i] = entry[2]
		chi_sq[i] = fit_par[i][10]
		per_id [i] = fit_par[i][0]

	endfor
	
	
	
	if (cmpstr(calc_fn, "modal_frac")==0) // calclute number fraction in each mode

		make/o/n=(nper) $"ait_num_frac", $"accum_num_frac", $"ssa_num_frac", $"total_N"
		wave ait_nf = $"ait_num_frac"
		wave accum_nf = $"accum_num_frac"
		wave ssa_nf = $"ssa_num_frac"
		wave totN = $"total_N"

		make/o/n=(nper) $"ait_sfc_frac", $"accum_sfc_frac", $"ssa_sfc_frac", $"total_S"
		wave ait_sf = $"ait_sfc_frac"
		wave accum_sf = $"accum_sfc_frac"
		wave ssa_sf = $"ssa_sfc_frac"
		wave totS = $"total_S"

		make/o/n=(nper) $"ait_vol_frac", $"accum_vol_frac", $"ssa_vol_frac", $"total_V"
		wave ait_vf = $"ait_vol_frac"
		wave accum_vf = $"accum_vol_frac"
		wave ssa_vf = $"ssa_vol_frac"
		wave totV = $"total_V"
		
		totN = fit_par[p][1] + fit_par[p][4] + fit_par[p][7] 
		totS = (4*pi*(fit_par[p][2])^2) * fit_par[p][1] + (4*pi*(fit_par[p][5])^2) * fit_par[p][4] + (4*pi*(fit_par[p][8])^2) * fit_par[p][7] 
		totV = (4/3*pi*(fit_par[p][2])^3) * fit_par[p][1] + (4/3*pi*(fit_par[p][5])^3) * fit_par[p][4] + (4/3*pi*(fit_par[p][8])^3) * fit_par[p][7] 

		ait_nf = fit_par[p][1] / totN[p]
		accum_nf = fit_par[p][4] / totN[p]
		ssa_nf = fit_par[p][7] / totN[p]

		ait_sf = ((4*pi*(fit_par[p][2])^2) * fit_par[p][1])/ totS[p]
		accum_sf = ((4*pi*(fit_par[p][5])^2) * fit_par[p][4]) / totS[p]
		ssa_sf = ((4*pi*(fit_par[p][8])^2) * fit_par[p][7]) / totS[p]

		ait_vf = ((4/3*pi*(fit_par[p][2])^3) * fit_par[p][1])/ totV[p]
		accum_vf = ((4/3*pi*(fit_par[p][5])^3) * fit_par[p][4]) / totV[p]
		ssa_vf = ((4/3*pi*(fit_par[p][8])^3) * fit_par[p][7]) / totV[p]

	endif
	
//	string data_avg_name  = "data_avg"
//	wave data_avg = $data_avg_name
//	string data_sd_name  = "data_sd"
//	wave data_sd = $data_sd_name
//	
//	// markers: plus, circle, square, up tri, down tri, left tri, rt tri, h diamond, v diamond, fat diamond, h bowtie, v bowtie, star
//	string markers = "0;19;16;17;23;46;49;26;29;18;15;14;60;"
//	// blue = (1,12815,52428)
//	
//	string legend_txt =" Dataset: " + dataset
//	variable idi
////	variable build_legend = new_plot
//	for (idi=0; idi<numpnts(ids); idi+=1)
//		if (new_plot)
//			display data_avg[idi][] vs ss
//			new_plot=0
//		else
//			appendtograph data_avg[idi][] vs ss
//		endif
//		
//		// get wavenames for plots
//		string data_name = data_avg_name
//		if (idi>0 || init_curve_cnt>0 ) // how to do this with appended plots
//			data_name +="#"+num2str(init_curve_cnt+idi)
//		endif
//		
//		if (do_error_bars)
//			ErrorBars $data_name Y,wave=(data_sd[idi][*],data_sd[idi][*])
//		endif
//		
////		// change dp to blue
////		ModifyGraph rgb($data_name)=(1,12815,52428)
//		// change to line&marker and set marker based on dataset entry id
//		ModifyGraph mode($data_name)=4,marker($data_name)=str2num(stringfromlist(ids[idi], markers))
//
//		// build legend
////		if (build_legend)
//		legend_txt += "\n\s("+data_name+")"+db_get_ds_meta(ids[idi],"name")
////		endif
//	endfor
//	
//	// axes and labels	
////	ModifyGraph axRGB(left)=(1,12815,52428),tlblRGB(left)=(1,12815,52428),alblRGB(left)=(1,12815,52428)
//	Label left "CCN (cm\S-3\M)"
//	Label bottom, "Supersatuation (%)"
//
//	if (cmpstr(add_labels,"true")==0)
//		Legend/C/N=traces/A=MC legend_txt
//	endif
	
	setdatafolder sdf
End

Function db_plot_kappa_std([ccn_datasource, sizing_datasource, dataset, add_to_current, crit_ratio, error_bars, add_labels])
	string ccn_datasource
	string sizing_datasource
	string dataset
	string add_to_current // Default: false
	string crit_ratio // "1" or "0.5" Default: "0.5"
	string error_bars // Default: false
	string add_labels
	
	
	string APP_SIGNATURE = "kappa"
	string sdf = getdatafolder(1)

	variable new_plot = 1
	variable init_curve_cnt = 0
	if (!ParamIsDefault(add_to_current) && cmpstr(add_to_current,"true")==0)
		new_plot = 0
		init_curve_cnt = itemsinlist(tracenamelist("",";",1+4))/2
	endif

	if (ParamIsDefault(add_labels))
		add_labels = "false"
	endif
	
	string ratio_str = "_0_5"
	if (!ParamIsDefault(crit_ratio) && cmpstr(crit_ratio,"1")==0)
		ratio_str=""
	endif
	
	variable do_error_bars = 0
	if (!ParamIsDefault(error_bars) && cmpstr(error_bars,"true")==0)
		do_error_bars = 1
	endif
	
	if (ParamIsDefault(dataset))
		dataset = db_get_active_ds()
		string dsets = db_ds_list()
		variable list_item = whichlistitem(dataset,dsets)
		if (list_item < 0)
			list_item = 1
		else
			list_item  +=1
		endif
		
		prompt list_item, "Dataset: ", popup, dsets
		DoPrompt "Select dataset", list_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		dataset = stringfromlist(list_item-1,dsets)
	endif
	db_set_active_ds(name=dataset)

	if (ParamIsDefault(ccn_datasource))
		string labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		variable label_item = 1
		prompt label_item, "CCN Data source: ", popup, labels
		DoPrompt "Select  CCN data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		ccn_datasource = stringfromlist(label_item-1,labels)
	endif
	string ccn_datasource_path = db_get_path_by_label(ccn_datasource)
	string ccn_datasource_dims = db_get_dims_by_label(ccn_datasource)
//	
//	print "App: ", APP_SIGNATURE
//	print "	DB: ", db_get_active_db()
//	print "		Dataset: ", dataset
//	print "			Data: ", ccn_datasource_path
//	
//	wave ccn_data = $ccn_datasource_path
//
//	string cdf = db_goto_datasource(ccn_datasource)
//	wave ccn_avg = :average_ccn:data_avg
//	wave ccn_sd = :average_ccn:data_sd
//	setdatafolder cdf


	if (ParamIsDefault(sizing_datasource))
		labels = db_get_datasource_par_list("LABEL")
		//datasource = db_get_active_ds()
		//variable label_item = whichlistitem(datasource,labels)+1
		label_item = 1
		prompt label_item, "Sizing Data source: ", popup, labels
		DoPrompt "Select  Sizing data source", label_item
		if (V_flag)
			print "user canceled!"
			return 0
		endif
		sizing_datasource = stringfromlist(label_item-1,labels)
//		print "sizing_datasource(label) = ", sizing_datasource
	endif
	string sizing_datasource_path = db_get_path_by_label(sizing_datasource)
	string sizing_datasource_dims = db_get_dims_by_label(sizing_datasource)
//	
//	wave sizing_data = $sizing_datasource_path

//	string dt_name = db_get_srcdim__(datasource_dims, "DATETIME_AXIS")
//	variable clean_up_dt = 0
//	if(cmpstr(dt_name,"") == 0)
//		// use wavescaling
//		wave dt = acg_extract_dt(data)
//		dt_name = nameofwave(dt)
//		print "dt_name = ", dt_name
//		clean_up_dt = 1			
//	endif
//	wave dt = $dt_name
	
	// sizing
	variable is_2d = 0
//	if (dimsize(sizing_data,1)) // 2d wave
//		string dp_name = db_get_srcdim__(sizing_datasource_dims, "DP_AXIS")
//		if (cmpstr(dp_name,"")==0)
//			print "Dp axis not defined"
//			return 0
//		endif
//		print "dp_name", dp_name
//		
//		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
//		is_2d = 1
//	else
//		return 1 // needs to be a 2d wave
//	endif
//	wave dp = $dp_name
//	// get averaged sizing data
//	string tdf = db_goto_datasource(sizing_datasource)
//	wave sizing_avg = :average:data_avg
//	setdatafolder tdf
	
	// ccn
	is_2d = 0
	//if (dimsize(ccn_data,1)) // 2d wave
	string ss_name = db_get_srcdim__(ccn_datasource_dims, "SS_AXIS")
	if (cmpstr(ss_name,"")==0)
		print "SS axis not defined"
		return 0
	endif
//	print "ss_name", ss_name
		
//		//acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
//		is_2d = 1
//	else
//		return 1 // needs to be a 2d wave
//	endif
	wave ss = $ss_name
	
	// needs average data to find kappa
	//wave data_avg = $(db_get_app_data(datasource,"average"))
	// check to see if data_avg is current by comparing modtimes
	//wave dat_avg = $"data_avg"
	
	// get list of dataset ids
	wave ids = db_get_ds_ids()
	

	// init app structure
	db_goto_datasource(ccn_datasource)

	// add meta - maybe add global STRUCT to define meta values
	string RECREATE = "db_app_find_kappa(ccn_datasource=\""+ccn_datasource+"\",sizing_datasource=\""+sizing_datasource+"\",dataset=\""+dataset+"\")"
	//db_app_update_meta__("RECREATE",APP_SIGNATURE,RECREATE)
	//print db_app_get_meta__("RECREATE",APP_SIGNATURE)

	// create app folder
	setdatafolder $APP_SIGNATURE
	setdatafolder $sizing_datasource
	
	string dp_crit_avg_name  = "dp_crit"+ratio_str+"_avg"
	wave dp_crit_avg = $dp_crit_avg_name
	string dp_crit_sd_name  = "dp_crit"+ratio_str+"_sd"
	wave dp_crit_sd = $dp_crit_sd_name

	string kappa_avg_name  = "kappa"+ratio_str+"_avg"
	wave kappa_avg = $kappa_avg_name
	string kappa_sd_name  = "kappa"+ratio_str+"_sd"
	wave kappa_sd = $kappa_sd_name
	
	// markers: plus, circle, square, up tri, down tri, left tri, rt tri, h diamond, v diamond, fat diamond, h bowtie, v bowtie, star
	string markers = "0;19;16;17;23;46;49;26;29;18;15;14;60;"
	// blue = (1,12815,52428)
	
	
	// generate standard plot
	ccn_make_standard_kappa_plot()

	
	string legend_txt =" Dataset: " + dataset
	variable idi
//	variable build_legend = new_plot
	for (idi=0; idi<numpnts(ids); idi+=1)
//		if (new_plot)
//			display dp_crit_avg[idi][] vs ss
//			new_plot=0
//		else
//			appendtograph dp_crit_avg[idi][] vs ss
//		endif
		
		appendtograph/R  ss vs dp_crit_avg[idi][]

		// get wavenames for plots
		string tr_name = nameofwave(ss)
		string dp_name = dp_crit_avg_name
		string kappa_name = kappa_avg_name
		if (idi>0 || init_curve_cnt>0 ) // how to do this with appended plots
			variable tr_num 
			tr_name +="#"+num2str(init_curve_cnt+idi)
			dp_name +="#"+num2str(init_curve_cnt+idi)
			kappa_name +="#"+num2str(init_curve_cnt+idi)			
		endif
		
		if (do_error_bars)
			ErrorBars $tr_name X,wave=(dp_crit_sd[idi][*],dp_crit_sd[idi][*])
//			ErrorBars $dp_name Y,wave=(dp_crit_sd[idi][*],dp_crit_sd[idi][*])
//			ErrorBars $kappa_name Y,wave=(kappa_sd[idi][*],kappa_sd[idi][*])
		endif
		
		// continue from here
		
		// change dp to blue
		ModifyGraph rgb($tr_name)=(1,12815,52428)
		// change to line&marker and set marker based on dataset entry id
		ModifyGraph mode($tr_name)=4,marker($tr_name)=str2num(stringfromlist(ids[idi], markers))
//		ModifyGraph mode($kappa_name)=4,marker($kappa_name)=str2num(stringfromlist(ids[idi], markers))

		// build legend
//		if (build_legend)
		legend_txt += "\n\s("+tr_name+")"+db_get_ds_meta(ids[idi],"name")
//		endif
	endfor
	
	// axes and labels	
//	ModifyGraph axRGB(left)=(1,12815,52428),tlblRGB(left)=(1,12815,52428),alblRGB(left)=(1,12815,52428)
//	Label left "\K(1,12815,52428)Critical D\\Bp\\M (um)"
//	ModifyGraph axRGB(right)=(65535,0,0),tlblRGB(right)=(65535,0,0),alblRGB(right)=(65535,0,0)
//	Label right "\K(65535,0,0)Kappa"
//	Label bottom, "Supersatuation (%)"

	if (cmpstr(add_labels,"true")==0)
		Legend/C/N=traces/A=MC legend_txt
	endif
	
	setdatafolder sdf
End
