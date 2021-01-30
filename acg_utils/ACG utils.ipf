#pragma rtGlobals=1		// Use modern global access method.
//#pragma ModuleName = NAAMES_BOTTLE
//#pragma version = 2.9


#include <WaveSelectorWidget>
#include  <New Polar Graphs>
//User defined variables====
	//Path to local data source

constant acg_utils_version=2.10
// -- moved to windows 10
// -- test an issue fix with vscode
// constant acg_utils_version=2.9
// --- Changes from 2.8 to 2.9 --- 12 July 2018
// 	- probably lots of unrecorded changes
//	- added function to avg windD using time index
// --- Changes from 2.7 to 2.8 --- 30 November 2010
// 	- modified/fixed: loading multiple itx files from dchart
//	- more I don't remember
// --- Changes from 2.6 to 2.7 --- 04 June 2010
//	- added wrapper functions to do rose plots
// --- Changes from 2.5 to 2.6 --- 19 May 2010
//	- added dchart_itx data reader
// --- Changes from 2.4 to 2.5 --- 8 May 2009
//	- ??? modified TBM
//		- removed some incomplete functions
//		- resized entire panel to accomodate lower resolutions (for Tim)
// --- Changes from 2.3 to 2.4 --- 8 May 2009
//	- ??? prior to making major change to TBM
// --- Changes from 2.2 to 2.3 --- 26 Feb 2009
//	- changed suffix "_common" to "_c" for wavename lenght restrictions
// --- Changes from 2.1 to 2.2 --- 17 Feb 2009
//	- minor bugfixes
// --- Changes from 2.0 to 2.1 --- 31 July 2008
//	- bugfix: set unused output file variable to good value (TBM)
// 	- init TBM before first call to panel
//	- define destFolder only if moving folders (acg_common_timebase_data)
//	- add project info controller to menu
//	- adjust project code to have last point be one sample period before stoptime
//	- change calc_dt to true if no dt wave is selected -or- use wavenotes box is checked
// --- Changes from 1.9 to 2.0 --- 31 July 2008
// 	- added ProjectInfo funtions
//	- added TimeBase Manager (TBM)
// --- Changes from 1.8 to 1.9 --- 20 March 2008
//  	- added function to load data selector format for new format in ICEALOT
/// --- Changes from 1.7 to 1.8 --- 26 April 2007
//  	- added function to mask waves for a given value (and range) --> acg_mask_by_value(...)
// --- Changes from 1.6 to 1.7 --- ???
//     - ???
// --- Changes from 1.5 to 1.6 --- 6 December 2006
//  	- added function to adjust a wave to given start, stop points
// 	- added function to "expand" a wave (e.g., expand 5min timebase to 1min using selectable method)
// --- Changes from 1.4 to 1.5 --- 4 October 2006
//	- added functions to concatenate loaded waves on same timebase...finally (patterned after the averaging function)
//
// --- Changes from 1.3 to 1.4 --- 31 August 2006
//	- added functions to put loaded waves on same time base (patterned after the averaging function)
//
// --- Changes from 1.2 to 1.3 --- 26 August 2006
// 	- reconciled changes from Tim and Trish (added get_wave_list function)
//
// --- Changes from 1.1 to 1.2 ---
//	- added ability to average already loaded waves using the same interface as the load and average
//
// --- Changes from 1.0 to 1.1 ---
//	- added ability to load (from dataselector) and average data
//		- see load_and_average()
//		- all new waves are now scaled by time - much faster
//	- Changed get_timebase_index to use BinarySearch instead of FindValue - much faster


//strconstant base_path_to_data = "D:Data:Cruises:"
//strconstant tmp_dataset_name = "dataset_name"
//strconstant tmp_dataset_waves = "dataset_waves"
//strconstant raw_folder = "raw"

constant ACG_DS_FORMAT = 0
strconstant acg_tmp_dataload_folder = "root:acg_tmp_dataload"
strconstant acg_toAverage_folder = "root:toAverage"
constant ACG_BAD_VALUE = -999

strconstant acg_tmp_timebase_folder = "root:acg_tmp_timebase"
strconstant acg_toTimeBase_folder = "root:toTimeBase"

strconstant acg_tmp_concat_folder = "root:acg_tmp_concat"
strconstant acg_toConcat_folder = "root:toConcat"

// plot folders
strconstant acg_plots_folder = "root:plots"
strconstant acg_rosePlot_folder = "rosePlot"


//strconstant global_folder = "root:GlobalVars"

strconstant acf_timestamp = "year month day hour minute second"
//strconstant isodate = "DateTime"

strconstant ProjectInfo_folder = "root:ProjectInfo"
strconstant ProjectInfo_empty_string = "NAME:;START_DT:;STOP_DT:;"

strconstant TBM_tb_tag = "TB"
strconstant TBM_avg_src_tb_tag = "AVG_SRC_TB"
strconstant TBM_expand_src_tb_tag = "EXPAND_SRC_TB"
strconstant TBM_proj_tag = "PROJECT"

strconstant ProjectFlag_folder = "ProjectFlag"
//strconstant PFW_base_string = "NORMAL:0;BAD:1;BLOWER_REVERSED:2;TEST_AEROSOL:3"
strconstant PFW_base_string = "BAD;AMBIENT;BLOWER_REVERSED;TEST_AEROSOL"
strconstant PFW_key_sep = "="
strconstant PFW_flag_sep = "%"

strconstant wv_datafolder = "root:wind_vector"


// delimeters for wavenotes

strconstant acg_list_delim = ";acg;"
strconstant acg_key_delim = "=acg="


// loaddata_base_path is base path for data files

//String/G loaddata_base_path

//User defined variables====

//menu "ACG Utils"
menu "ACG Data"
	submenu "Utils"
		"Time Base Manager", acg_display_TBM()
		"Project Info Controller", acg_display_PIC()
		"-"
		submenu "Project"
			"Project Info Controller", acg_display_PIC()
			"Import Project Info", acg_import_project_info()
			submenu "Flags"
				"Print Flags", print pfw_get_keys()
			end
//			"Initialize Project Info", init_project_info()
//			"Set Project Info", set_project_info()
		end
		submenu "Load Data"
			"Load DChart itx data file 1sec data", acg_load_dchart_itx_format(1)
			"Load DataSelector data file", load_data_selector_format()
			"Load and Average DataSelector data file", load_and_average(ACG_DS_FORMAT)
			//"Load ACF data file", load_acf()
			//"Load DMPS and APS data from AeroSizing", load_dmps_aps()
			//"Load Particle Counter from AeroSIzing", load_dmps_cpc()
		end
		submenu "Manipulate Loaded Data"
			"Time Base Manager", acg_display_TBM()
			submenu "old"
				"Average loaded data",acg_average_loaded_waves()
				"Put loaded waves on constant time base",acg_set_timebase_loaded_waves()
			end
			"Concatenate loaded waves on constant time base",acg_concat_loaded_waves()
		end
		submenu "Paths"
			"Set base data path", set_base_path()
			"Change base data path", change_base_path()
			"Kill base data path", kill_base_path()
		end
	end
end

Menu "GraphMarquee", dynamic
	"-"
	submenu "Set project flag..."
		pfw_get_marquee_menu_string(),/Q,pfw_set_flag_from_marquee()
	end
End


// *** Project Info Functions"  ****//
Function init_project_info()
	set_project_name("")
	set_project_starttime("")
	set_project_stoptime("")
End

Function set_project_info()
	execute "ProjectInfoPanel()"
	pauseforuser ProjectInfoPanel

End

Function set_project_name(pname)
	string pname
	string sdf = getdatafolder(1)
	newdatafolder/o/s root:project_info

	SVAR name = ProjectName
	if (!SVAR_exists(name))
		string/g ProjectName
		name = ProjectName
	endif
	name = pname

	setdatafolder(sdf)
End

Function/S get_project_name()
	SVAR name = root:project_info:ProjectName
	if (!SVAR_exists(name))
		return ""
	endif
	return name
End

Function set_project_starttime(stime)
	string stime
	string sdf = getdatafolder(1)
	newdatafolder/o/s root:project_info

	SVAR start = StartTimeString
	if (!SVAR_exists(start))
		string/g StartTimeString
		start = StartTimeString
	endif
	start = stime

	setdatafolder(sdf)
End

Function get_project_starttime()
	variable stime
	SVAR start = root:project_info:StartTimeString
	if (!SVAR_exists(start) || (cmpstr(start,"")==0) )
		return -1
	endif
	variable yr, mo, day, hr, mn, sec
	sscanf start, "%d-%d-%d %d:%d:%d", yr, mo, day, hr, mn, sec
	stime = date2secs(yr,mo,day) + hr*60*60 + mn*60 + sec
	// should do a sanity check here...is value within limits?
	return stime

End

Function set_project_stoptime(stime)
	string stime
	string sdf = getdatafolder(1)
	newdatafolder/o/s root:project_info

	SVAR stop = StopTimeString
	if (!SVAR_exists(stop))
		string/g StopTimeString
		stop = StopTimeString
	endif
	stop = stime

	setdatafolder(sdf)
End

Function get_project_stoptime()
	variable stime
	SVAR stop = root:project_info:StopTimeString
	if (!SVAR_exists(stop) || (cmpstr(stop,"")==0) )
		return -1
	endif
	variable yr, mo, day, hr, mn, sec
	sscanf stop, "%d-%d-%d %d:%d:%d", yr, mo, day, hr, mn, sec
	stime = date2secs(yr,mo,day) + hr*60*60 + mn*60 + sec
	// should do a sanity check here...is value within limits?
	return stime

End


Function ProjectInfoProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"closeButton") == 0)
		killwindow projectinfopanel
	endif
End


// *** Path Functions *** //
Function set_base_path()

	string sdf = getdatafolder(1)
	NewDataFolder/O/S root:loaddata_tmp

	PathInfo loaddata_base_path
	//print "first: ", S_path
	String basepath = S_path

	if (cmpstr(basepath,"") == 0)
		//print "basepath == 0"
		NewPath/O/M="Select base path to Data" loaddata_base_path
	endif

	SetDataFolder sdf
	KillDataFolder root:loaddata_tmp

	//String/G loaddata_base_path
	//SVAR/Z pth = loaddata_base_path

	//if (SVAR_Exists(pth) != 1)
	//print "set_base_path 5"
	//	KillStrings/Z pth
	//	String/G loaddata_base_path = ""
	//	//SVAR/Z pth = loaddata_base_path
	//	NewPath/O spth
	//	PathInfo spth
	//	print S_path
	//	String/G loaddata_base_path = S_path
	//	//NewPath loaddata_base_path
	//	//SVAR/Z pth = loaddata_base_path
	//endif
	//print "set_base_path 6"
	//SVAR pth = loaddata_base_path
	//print pth

	//SetDataFolder sdf
	//print "set_base_path 7"
	//return pth
end

Function change_base_path()
	//string sdf = getdatafolder(1)
	//NewDataFolder/O/S $global_folder

	//SVAR/Z pth = loaddata_base_path
	//KillStrings/Z pth
	//KillStrings/Z loaddata_base_path
	//set_base_path()

	NewPath/O/M="Select base path to Data" loaddata_base_path


	//SetDataFolder sdf
end

Function kill_base_path()
	KillPath/Z loaddata_base_path
end

Function load_and_average(data_format)
	variable data_format
	String sdf = getdatafolder(1)
	newdatafolder/o/s $acg_tmp_dataload_folder
	newdatafolder/o/s input

	if (data_format == ACG_DS_FORMAT) // DataSelector format
		load_data_selector_format()
	else
		print "Unknown data format!"
		return 0
	endif

	acg_init_gui()
	DoWindow/F LoadAvgPanel
	if (V_Flag != 0)
		return 0
	endif
	Execute "LoadAvgPanel()"

	//killdatafolder/Z $acg_tmp_dataload_folder
End


Function acg_init_gui()
	string sdf = getdatafolder(1)
	setdatafolder root:
	if (!datafolderexists("gui"))
		newdatafolder/o/s root:gui
		String/G load_datafolder_list = "<new data folder>"
		variable/G load_datafolder_index = 0
		variable/G last_avgtime = 60
		variable/G last_timebase = 300
		variable/G concat_do_avg_flag = 0
	else
		setdatafolder root:gui
		if (exists("last_timebase") != 2)
			variable/G last_timebase = 300
		elseif (exists("concat_do_avg_flag") != 2)
			variable/G concat_do_avg_flag = 0
		endif
	endif

	newdatafolder/o $acg_toAverage_folder
	newdatafolder/o $acg_toTimeBase_folder
	newdatafolder/o $acg_toConcat_folder

	setdatafolder sdf
End

// Load various data file formats
Function load_data_selector_format()
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
End

// for dataselector format during ICEALOT
Function load_data_selector_format_v2()
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
	LoadWave/J/D/A/W/O/K=0/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
End

// for dataselector format during ICEALOT
Function load_data_labview_acf_format()
	set_base_path()
	PathInfo loaddata_base_path

	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
//	LoadWave/J/D/A/W/O/K=0/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
	// Make sure the base path to the data file is set

	print "base_path = ", S_path

	// User selects file...1st column (meta data) is read into meta0
	LoadWave/O/J/D/N=meta/K=2/V={"\t"," $",0,0}/P=loaddata_base_path
	duplicate/o/t meta0, metadata
	wave/t metadata
	killwaves meta0

	// get filename and full path for use later
	Variable nfiles = V_flag // # of files loaded...future use?
	String filename = S_filename
	String fullpath = S_path

	variable pts = numpnts(metadata)
	print pts
	variable ii
	variable num_params=0
	variable dataline=0
	String val
	make/o/t params
	// if this isn't done 1st, timestamp screwed up
	add_acf_timestamp_params(params, num_params)
	for (ii=0; ii<pts; ii+=1)
		if (cmpstr(metadata[ii],"#PARAMETER#")==0)
			num_params+=1
			redimension/N=(num_params) params
			params[num_params-1]=metadata[ii+1]
		endif
		if (strsearch(metadata[ii],"#DATA",0)==0)
			variable skip
			sscanf metadata[ii], "#DATA %f HEADING", skip
			dataline = ii+skip
			break
		endif
		//print metadata[ii]
	endfor
	//print metadata
	print "number of parameters = ", num_params
	print params
	print dataline
	//print fullpath, filename

//	string fldr= ":" + stringfromlist(0,filename,".")
//	NewDataFolder/O/S $fldr


	String fn=fullpath+filename
	//print fn
	//LoadWave/O/J/D/N=acf/K=1/V={"\t"," $",0,0}/L={0,dataline,0,0,0}/p=fullpath filename
	LoadWave/O/J/D/N=acf/K=1/V={"\t"," $",0,0}/L={0,dataline,0,0,0} fn

	for (ii=0; ii<num_params; ii+=1)
		duplicate/o $("acf"+num2str(ii)), $(params[ii])
		killwaves $("acf"+num2str(ii))
	endfor

	duplicate/o hour, Start_DateTime
	wave Start_DateTime
	wave year,month,day,hour,minute,second
	Start_DateTime = date2secs(year,month,day) + (hour*3600) + (minute*60) + (second)


End

Function load_data_dchart_itx_format()
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path

	Variable refNum
	String message = "Select one or more files"
	String outputPaths
	String fileFilters = "Igor Text Files (*.itx):.itx;"
	fileFilters += "All Files:.*;"

	Open /D /R /MULT=1 /F=fileFilters /M=message /P=loaddata_base_path refNum
	outputPaths = S_fileName

	if (strlen(outputPaths) == 0)
		Print "Cancelled"
	else
		Variable numFilesSelected = ItemsInList(outputPaths, "\r")
		Variable i
		for(i=0; i<numFilesSelected; i+=1)
			String path = StringFromList(i, outputPaths, "\r")
			//Printf "%d: %s\r", i, path
			LoadWave/T/O path
		endfor
	endif
	//LoadWave/T/O/P=loaddata_base_path
End

// for dataselector format during ICEALOT
Function load_data_selector_v2_byname(fileName)
	string fileName
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
	LoadWave/J/D/A/W/O/K=0/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path fileName
End

Function load_data_selector_v2_bypath(path)
	string path
//	set_base_path()
//	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path
	LoadWave/J/D/A/W/O/K=0/R={English,2,2,2,2,"Year-Month-DayOfMonth",40} path
End

Function/T acg_get_file_list_batch()
	set_base_path()
	PathInfo loaddata_base_path
	//print S_path
	string path
	path = IndexedFile(loaddata_base_path,-1,".dat")
	path = SortList(path)
	//print path
	return path
End

Function add_acf_timestamp_params(p, num_p)
	variable &num_p
	Wave/T p

//	num_p+=1
//	redimension/N=(num_p) p
//	p[num_p-1]=isodate

	variable jj=0
	do
		string stamp = StringFromList(jj,acf_timestamp," ")
		if (cmpstr(stamp,"") != 0)
			num_p+=1
			redimension/N=(num_p) p
			p[num_p-1]=stamp
		else
			break
		endif
		jj += 1
		stamp = StringFromList(jj,acf_timestamp," ")
	while(1)

end

Function load_acf()

	string sdf = getdatafolder(1)
	NewDataFolder/O/S root:ACF

	//set_base_path()

	// Make sure the base path to the data file is set
	set_base_path()
	PathInfo loaddata_base_path
	print "base_path = ", S_path

	// User selects file...1st column (meta data) is read into meta0
	LoadWave/O/J/D/N=meta/K=2/V={"\t"," $",0,0}/P=loaddata_base_path
	duplicate/o/t meta0, metadata
	wave/t metadata
	killwaves meta0

	// get filename and full path for use later
	Variable nfiles = V_flag // # of files loaded...future use?
	String filename = S_filename
	String fullpath = S_path

	variable pts = numpnts(metadata)
	print pts
	variable ii
	variable num_params=0
	variable dataline=0
	String val
	make/o/t params
	// if this isn't done 1st, timestamp screwed up
	add_acf_timestamp_params(params, num_params)
	for (ii=0; ii<pts; ii+=1)
//		if (cmpstr(metadata[ii],"#TIME PARAMETERS#")==0)
//			variable jj=0
//			do
//				string stamp = StringFromList(jj,metadata[ii+1]," ")
//				if (cmpstr(stamp,"") != 0)
//					num_params+=1
//					redimension/N=(num_params) params
//					params[num_params-1]=stamp
//				else
//					break
//				endif
//				jj += 1
//				stamp = StringFromList(jj,metadata[ii+1]," ")
//			while(1)
//		endif
		if (cmpstr(metadata[ii],"#PARAMETER#")==0)
			num_params+=1
			redimension/N=(num_params) params
			params[num_params-1]=metadata[ii+1]
		endif
		if (strsearch(metadata[ii],"#DATA",0)==0)
			variable skip
			sscanf metadata[ii], "#DATA %f HEADING", skip
			dataline = ii+skip
			break
		endif
		//print metadata[ii]
	endfor
	//print metadata
	print "number of parameters = ", num_params
	print params
	print dataline
	//print fullpath, filename

	string fldr= ":" + stringfromlist(0,filename,".")
	NewDataFolder/O/S $fldr


	String fn=fullpath+filename
	//print fn
	//LoadWave/O/J/D/N=acf/K=1/V={"\t"," $",0,0}/L={0,dataline,0,0,0}/p=fullpath filename
	LoadWave/O/J/D/N=acf/K=1/V={"\t"," $",0,0}/L={0,dataline,0,0,0} fn

	for (ii=0; ii<num_params; ii+=1)
		duplicate/o $("acf"+num2str(ii)), $(params[ii])
		killwaves $("acf"+num2str(ii))
	endfor

	duplicate/o hour, isodate
	wave isodate
	wave year,month,day,hour,minute,second
	isodate = date2secs(year,month,day) + (hour*3600) + (minute*60) + (second)


	SetDataFolder sdf

end

Function acg_get_year(dt_in)
	variable dt_in

	string date_str = secs2date(dt_in,0)
	variable val 	= str2num(stringfromlist(2,date_str,"/"))

	return val
end

Function acg_get_month(dt_in)
	variable dt_in

	string date_str = secs2date(dt_in,0)
	variable val 	= str2num(stringfromlist(0,date_str,"/"))

	return val
end

Function acg_get_day(dt_in)
	variable dt_in

	string date_str = secs2date(dt_in,0)
	variable val 	= str2num(stringfromlist(1,date_str,"/"))

	return val
end

Function acg_get_hour(dt_in)
	variable dt_in

	string time_str = secs2time(dt_in,3)
	variable val	= str2num(stringfromlist(0,time_str,":"))

	return val
end

Function acg_get_minute(dt_in)
	variable dt_in

	string time_str = secs2time(dt_in,3)
	variable val	= str2num(stringfromlist(1,time_str,":"))

	return val
end

Function acg_get_second(dt_in)
	variable dt_in

	string time_str = secs2time(dt_in,3)
	variable val	= str2num(stringfromlist(2,time_str,":"))

	return val
end


// *** datetime <--> doy conversions ***//
Function doy2datetime(year_in, doy_in)
	variable doy_in // input decimal doy (dayofyear.fractofday)
	variable year_in // year needed for complete time string
	variable dt_out  // returned datetime in igor format (seconds)

	// get the year and day
	dt_out = date2secs(year_in,1,1)
	dt_out += (floor(doy_in)-1) * 24 * 60 * 60

	// now do the fraction
	variable fract = doy_in - floor(doy_in)
	dt_out += fract * 24 * 60 * 60

	return dt_out

End

Function datetime2doy(dt_in)
	variable dt_in // input datetime (in seconds)
	variable doy_out // returned doy.fract

	// get date values
	string date_str = secs2date(dt_in,0)
	variable mo 	= str2num(stringfromlist(0,date_str,"/"))
	variable day  	= str2num(stringfromlist(1,date_str,"/"))
	variable yr 	= str2num(stringfromlist(2,date_str,"/"))

	// get time values
	string time_str = secs2time(dt_in,3)
	variable hr	= str2num(stringfromlist(0,time_str,":"))
	variable mn	= str2num(stringfromlist(1,time_str,":"))
	variable sec	= str2num(stringfromlist(2,time_str,":"))

	// need to get Julian day of desired year
	variable offset = dateToJulian(yr,1,1) - 1

	// do the math
	doy_out = dateToJulian(yr,mo,day) - offset
	doy_out += hr/24
	doy_out += mn/24/60
	doy_out += sec/24/60/60

	return doy_out

End

Function doy2datetime_wave(year, doy, dt_name)
	wave year, doy
	string dt_name

	duplicate/o doy $dt_name
	wave dt = $dt_name

	variable i
	for (i=0; i<numpnts(doy); i+=1)
		dt[i] = doy2datetime(year[i], doy[i])
	endfor
End

Function datetime2doy_wave(dt, doy_name)
	wave dt
	string doy_name

	duplicate/o dt $doy_name
	wave doy = $doy_name

	variable i
	for (i=0; i<numpnts(dt); i+=1)
		doy[i] = datetime2doy(dt[i])
	endfor
End

Function get_timebase_index_FindValue(common, sparse, tol, index_name)
	wave common, sparse
	variable tol
	string index_name

	// do time base once because it takes awhile
	print "ACG Utils: creating time index for constant time base (may take awhile)..."
	duplicate/o  sparse $index_name
	wave time_index = $index_name
	time_index = -1
	variable k
	for (k=0; k<numpnts(sparse); k+=1)
		FindValue/T=(tol)/V=(sparse[k]) common
		time_index[k]=V_value
		//time_index[k] = BinarySearch(common,sparse[k])
	endfor
//	time_index = BinarySearch(common,sparse[p])

End


Function get_timebase_index(common, sparse, tol, index_name)
	wave common, sparse
	variable tol
	string index_name

	// do time base once because it takes awhile
	print "ACG Utils: creating time index for constant time base (may take awhile)..."
	duplicate/o  sparse $index_name
	wave time_index = $index_name
	time_index = -1
	variable k
//	for (k=0; k<numpnts(sparse); k+=1)
//		//FindValue/T=(tol)/V=(sparse[k]) common
//		//time_index[k]=V_value
//		time_index[k] = BinarySearch(common,sparse[k])
//	endfor
	time_index = BinarySearch(common,sparse[p])

End

// *** GUI macros *** //

Window ProjectInfoPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(150,79,570,266) as "Project Information"
	ShowTools
	SetDrawLayer UserBack
	DrawText 142,139,"(yyyy-mm-dd hh:mm:ss)"
	SetVariable setvar0,pos={42,19},size={303,19},title="Project Name:",fSize=14
	SetVariable setvar0,fStyle=1,value= root:project_info:projectName,bodyWidth= 201
	SetVariable setStartTime,pos={86,73},size={187,19},title="StartTime"
	SetVariable setStartTime,help={"Leave blank to use dataset start time"},fSize=14
	SetVariable setStartTime,value= root:project_info:startTImeString,bodyWidth= 125
	SetVariable setvar1_1,pos={85,99},size={188,19},title="StopTime"
	SetVariable setvar1_1,help={"Leave blank to use dataset stop time"},fSize=14
	SetVariable setvar1_1,value= root:project_info:stopTImeString,bodyWidth= 125
	Button closeButton,pos={187,156},size={50,20},proc=ProjectInfoProc,title="Close"
	Button closeButton,fSize=14
EndMacro


Function DFolder_PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	NVAR index = root:gui:load_datafolder_index

	if (cmpstr(popStr,"<new data folder>") == 0)
		// show window for user input
		String foldername
		Prompt foldername, "Enter new datafolder name: "
		DoPrompt "New Folder Dialog", foldername
		print foldername
//		newdatafolder foldername
		SVAR list = root:gui:load_datafolder_list
		variable cnt = itemsinlist(list)
		list += ";" + foldername
		index = cnt
		PopupMenu data_folder_popup,popvalue=foldername,value=acg_getdatafolder_list(),mode=index+1
	else
		index = popNum-1
		//variable/G acg_timebase
	endif
	// set current datafolder index value

End


Function AvgPer_SetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName


End

Function LoadAvg_ButtonProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"go_button") == 0)
		// do the avg
		acg_check_avgtime()
		acg_average_loaded_data()
		acg_concat_loaded_data()
		killwindow LoadAvgPanel
	else
		// quit
		killwindow LoadAvgPanel
	endif

	killdatafolder/Z $acg_tmp_dataload_folder
End

Function acg_check_avgtime()

	// some quick housekeeping to make sure new data is averaged at
	//    correct avgtime
	SVAR dflist = root:gui:load_datafolder_list
	NVAR index = root:gui:load_datafolder_index
	NVAR avgtime = root:gui:datafolder_list

	if (datafolderexists("root:"+stringfromlist(index,"dflist")))
		NVAR/Z ds_avgtime = $("root:"+stringfromlist(index,"dflist")+":dataset_avgtime")
		if (ds_avgtime != avgtime)
			avgtime = ds_avgtime
		endif
	endif

End

Function acg_concat_loaded_data()
	String sdf = getdatafolder(1)

	SVAR folderlist = root:gui:load_datafolder_list
	NVAR findex = root:gui:load_datafolder_index
	NVAR avgtime = root:gui:last_avgtime
	string dfolder = "root:"+stringfromlist(findex,folderlist)
	variable isNew = 0
	if (!datafolderexists(dfolder))
		newdatafolder/s $dfolder
		variable/G dataset_timebase = avgtime
		isNew = 1
	endif
	setdatafolder acg_tmp_dataload_folder
	string wlist = acg_get_wlist_from_folder(":input")

	// handle the times
	wave avg_dt = avg_tw
	if (isNew)
		duplicate avg_dt $(dfolder+":date_time")
	else
		duplicate/o $(dfolder+":date_time") $(dfolder+":date_time_bak")
		wave old_dt = $(dfolder+":date_time_bak")
		wavestats/Q avg_dt
		variable newmin = V_min
		variable newmax = V_max
		wavestats/Q old_dt
		variable oldmin = V_min
		variable oldmax = V_max
		variable mintime = (newmin<oldmin) ? newmin : oldmin
		variable maxtime = (newmax>oldmax) ? newmax : oldmax

		variable npts = ((maxtime-mintime)/avgtime) + 1
		make/o/n=(npts)/d $(dfolder+":date_time")
		wave dt = $(dfolder+":date_time")
		dt[0] = mintime
		dt[1,] = dt[p-1]+avgtime

		// create doy wave for ease
		datetime2doy_wave(dt,dfolder+":doy")
	endif

	String lname
	variable i
	wave dt = $(dfolder+":date_time")
	wave old_dt = $(dfolder+":date_time_bak")
	for (i=0; i<itemsinlist(wlist); i+=1)
		String wname = stringfromlist(i,wlist)
		if ( (cmpstr(wname,"Start_DateTime") == 0) || (cmpstr(wname,"AvePeriod") ==0)  || (cmpstr(wname,"DOY")==0) )
			// skip these
		else
			lname = acg_map2newname(wname)
			wave new_param = $(wname+"_avg")
			if (waveexists($(dfolder+":"+lname)))
				duplicate/o $(dfolder+":"+lname) $(dfolder+":"+lname+"_bak")
				wave old_param = $(dfolder+":"+lname+"_bak")
				duplicate/o dt $(dfolder+":"+lname)
				wave param = $(dfolder+":"+lname)
				param = NaN
				SetScale/P x dt[0],avgtime,"dat", param
				variable starti = x2pnt(param,old_dt[0])
				param[starti,starti+numpnts(old_param)] = old_param[p-starti]
				starti = x2pnt(param,avg_dt[0])
				param[starti,starti+numpnts(new_param)] = new_param[p-starti]
			else
				duplicate/o dt $(dfolder+":"+lname)
				wave param = $(dfolder+":"+lname)
				param = NaN
				SetScale/P x dt[0],avgtime,"dat", param
				starti = x2pnt(param,avg_dt[0])
				param[starti,starti+numpnts(new_param)] = new_param[p-starti]
			endif
		endif
	endfor

	setdatafolder sdf
End

Function/S acg_map2newname(varname)
	string varname
	if (cmpstr(varname,"Start_DateTime")==0)
		return "date_time"
	elseif (cmpstr(varname,"GPS_LatDec") == 0)
		return "lat"
	elseif (cmpstr(varname,"GPS_LongDec") == 0)
		return "lon"
	elseif (cmpstr(varname,"zi_wind_speed_relative_wx") == 0)
		return "wind_speed_rel_wx"
	elseif (cmpstr(varname,"zi_wind_direction_relative_wx") == 0)
		return "wind_dir_rel_wx"
	elseif (cmpstr(varname,"heading_gyro_ship") == 0)
		return "heading_gyro"
	elseif (cmpstr(varname,"barometric_pressure_wx") == 0)
		return "barometric_pressure"
	elseif (cmpstr(varname,"chlorophyll_fluorometer_ship") == 0)
		return "chlorophyll_ship"
	else
		return varname
	endif
End


Function/S acg_get_wlist_from_folder(dfolder, [filter_str])
	string dfolder
	// optional: must specify with filter_str="some string"
	string filter_str

	variable use_filter = 1
	if (numtype(strlen(filter_str))==2 || strlen(filter_str)==0)
		use_filter = 0
	endif

	string sdf = getdatafolder(1)
	setdatafolder dfolder
	string list = ""
	if (use_filter)
		list = acg_get_wave_list(filter=filter_str)
	else
		list = acg_get_wave_list()
	endif

	setdatafolder sdf
	return list
End

Function/S acg_get_wave_list([filter])
	//optional
	string filter

	variable use_filter = 1
	if (numtype(strlen(filter))==2 || strlen(filter)==0)
		use_filter = 0
	endif

	String list=""
	String w
	variable index = 0
	do
		w = GetIndexedObjName(":",1,index)
		if (strlen(w) == 0)
			break
		endif
		if (use_filter)
			if ( stringmatch(w,filter) )
				list += w + ";"
			endif
		else
			list += w + ";"
		endif
		index += 1
	while(1)
	return list
End

Function acg_average_loaded_data()
	String sdf = getdatafolder(1)
	setdatafolder $(acg_tmp_dataload_folder+":input")
	string list = acg_get_wave_list()
	setdatafolder acg_tmp_dataload_folder

	wave ds_tw = $(":input:Start_DateTime")

	// get timebase limits
	wavestats/Q ds_tw
	variable mintime=V_min
	variable maxtime=V_max
	variable pts = maxtime-mintime+1
	make/o/d/n=(pts) common_tw
	common_tw[0] = mintime
	common_tw[1,] = common_tw[p-1]+1
	variable i,j
	for (i=0; i<itemsinlist(list); i+=1)
		string var = stringfromlist(i,list)
		wave v = $(":input:"+var)
		duplicate/o common_tw $(var+"_c")
		wave w = $(var+"_c")
		w=NaN
		SetScale/P x common_tw[0],1,"dat", w
		for (j=0; j<numpnts(v); j+=1)
//			variable index = x2pnt(w,ds_tw[j])
//			w[index] = v[j]
			w[x2pnt(w,ds_tw[j])] = v[j]
		endfor
	endfor

	NVAR avg_time = root:gui:last_avgtime
	variable first_starttime=mintime - mod(mintime,avg_time)
	if (BinarySearch(common_tw,first_starttime) == -1)
		first_starttime += avg_time
	endif
	variable last_starttime=maxtime - mod(maxtime,avg_time)
	if (BinarySearch(common_tw,last_starttime) == -2)
		last_starttime -= avg_time
	endif

	variable avg_pts = ((last_starttime-first_starttime)/avg_time)+1
	make/o/d/n=(avg_pts) avg_tw
	avg_tw[0] = first_starttime
	avg_tw[1,] = avg_tw[p-1]+avg_time
	for (i=0; i<itemsinlist(list); i+=1)
		var = stringfromlist(i,list)
		wave v = $(var+"_c")
		v = (v[p] == ACG_BAD_VALUE) ? NaN : v[p]
		duplicate/o avg_tw $(var+"_avg")
		wave w = $(var+"_avg")
		w=NaN
		SetScale/P x avg_tw[0],avg_time,"dat", w
//		for (j=0; j<numpnts(v); j+=1)
		for (j=0; j<numpnts(w)-1; j+=1)
//			variable index = x2pnt(w,ds_tw[j])
//			w[index] = v[j]
//			w[x2pnt(w,ds_tw[j])] = v[j]

			//variable firstp = x2pnt(v,avg_tw[j])
			//wavestats/Q/R=(avg_tw[j],avg_tw[j]+60) v
			//wavestats/Q/R=(avg_tw[j],avg_tw[j]+avg_time) v
			wavestats/Q/R=(avg_tw[j],avg_tw[j+1]-1) v
			w[j] = V_avg
		endfor
	endfor




End

Function/S acg_getdatafolder_list()
	SVAR list = root:gui:load_datafolder_list
	print list
	return list
End

Window LoadAvgPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(150,77,450,277) as "Load & Average"
	SetDrawLayer UserBack
	DrawText 67,36,"Choose where to save data..."
	PopupMenu data_folder_popup,pos={61,43},size={170,21},proc=DFolder_PopMenuProc
	PopupMenu data_folder_popup,mode=1,bodyWidth= 170,popvalue="<new data folder>",value=acg_getdatafolder_list()
	SetVariable acg_avgtime,pos={76,94},size={135,16},proc=AvgPer_SetVarProc,title="Avg Time (sec)"
	SetVariable acg_avgtime,format="%G"
	SetVariable acg_avgtime,limits={1,43200,0},value= root:gui:last_avgtime,bodyWidth= 60
	Button go_button,pos={133,147},size={85,22},proc=LoadAvg_ButtonProc,title="Go"
	Button cancel_button,pos={62,147},size={50,22},proc=LoadAvg_ButtonProc,title="Cancel"
EndMacro

Function/S get_wavelist(dfolder)
	string dfolder
	string wlist=""
	//string dset_folder = "root:smps:datasets"
	string wname=""
	variable index=0
	do
		wname = GetIndexedObjName(dfolder,1, index)
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

// requires igor 6.1 or greater
Function/S get_dfr_list(dfr)
	DFREF dfr
	string dfrlist = ""
	string dfrname = ""
	variable index = 0
	do
		dfrname = GetIndexedObjNameDFR(dfr,4, index)
		if (strlen(dfrname) == 0)
			break
		endif

		//Print wname
		dfrlist += dfrname + ";"
		index += 1
	while(1)
	//print wlist, itemsinlist(wlist)
	return SortList(dfrlist)
End


End

Function PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	print ctrlName, popNum, popStr

	string sdf = getdatafolder(1)
	setdatafolder $acg_toAverage_folder

	NVAR index = datetime_index
	index = popNum - 1

	setdatafolder sdf

End

Function/S acg_get_toAverage_list()
	string sdf = getdatafolder(1)
	setdatafolder $acg_toAverage_folder

	string list = wavelist("*",";","")

	setdatafolder sdf

	return list
End

Function/S acg_get_toTimeBase_list()
	string sdf = getdatafolder(1)
	setdatafolder $acg_toTimeBase_folder

	string list = wavelist("*",";","")

	setdatafolder sdf

	return list
End

Function/S acg_get_toConcat_list()
	string sdf = getdatafolder(1)
	setdatafolder $acg_toConcat_folder

	string list = wavelist("*",";","")

	setdatafolder sdf

	return list
End

Window DateTimeSelPanel() : Panel
	string sdf = getdatafolder(1)
	setdatafolder $acg_toAverage_folder
	variable/G datetime_index = 0
	setdatafolder sdf

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(364,155,664,355) as "DateTime Selector"
	SetDrawLayer UserBack
	DrawText 85,62,"Select DateTime wave:"
	PopupMenu DateTimeSelector,pos={72,67},size={158,21},proc=toAverage_PopMenuProc
	PopupMenu DateTimeSelector,mode=1,bodyWidth= 158,value= #"acg_get_toAverage_list()"
	Button doneButton,pos={160,121},size={86,30},proc=toAverage_ButtonProc,title="Done"
	Button cancelButton,pos={53,121},size={86,30},proc=toAverage_ButtonProc,title="Cancel"
EndMacro

Function toAverage_ButtonProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"doneButton") == 0)

		// copy data to acg_tmp_datafolder
		string sdf = getdatafolder(1)
		setdatafolder $acg_toAverage_folder

		NVAR index = datetime_index
		string list = acg_get_toAverage_list()
		newdatafolder/o/s $acg_tmp_dataload_folder
		newdatafolder/o/s input
		variable i
		for (i=0; i<itemsinlist(list); i+=1)
			wave param = $(acg_toAverage_folder+":"+stringfromlist(i,list))
			if (i == index) // date_time wave
				duplicate/o param Start_DateTime
			else
				string name = acg_map2newname(stringfromlist(i,list))
				duplicate/o param $name
			endif
		endfor

		// exit
	elseif (cmpstr(ctrlName,"cancelButton") == 0)
		print "cancelled"
	endif
	killwindow DateTimeSelPanel

End

Function toAverage_PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	print ctrlName, popNum, popStr

	string sdf = getdatafolder(1)
	setdatafolder $acg_toAverage_folder

	NVAR index = datetime_index
	index = popNum - 1

	setdatafolder sdf

End

function acg_average_loaded_waves()

	acg_init_gui()

	DoWindow/F DateTimeSelPanel
	if (V_Flag != 0)
		return 0
	endif
	Execute "DateTimeSelPanel()"
	PauseForUser DateTimeSelPanel

	DoWindow/F LoadAvgPanel
	if (V_Flag != 0)
		return 0
	endif
	Execute "LoadAvgPanel()"

end


// ----

// For same TimeBase
Window DateTimeSelPanel_TB() : Panel
	string sdf = getdatafolder(1)
	setdatafolder $acg_toTimeBase_folder
	variable/G datetime_index = 0
	setdatafolder sdf

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(364,155,664,355) as "DateTime Selector"
	SetDrawLayer UserBack
	DrawText 85,62,"Select DateTime wave:"
	PopupMenu DateTimeSelector,pos={72,67},size={158,21},proc=toTimeBase_PopMenuProc
	PopupMenu DateTimeSelector,mode=1,bodyWidth= 158,value= #"acg_get_toTimeBase_list()"
	Button doneButton,pos={160,121},size={86,30},proc=toTimeBase_ButtonProc,title="Done"
	Button cancelButton,pos={53,121},size={86,30},proc=toTimeBase_ButtonProc,title="Cancel"
EndMacro

Function toTimeBase_ButtonProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"doneButton") == 0)

		// copy data to acg_tmp_datafolder
		string sdf = getdatafolder(1)
		setdatafolder $acg_toTimeBase_folder

		NVAR index = datetime_index
		string list = acg_get_toTimeBase_list()

		newdatafolder/o/s $acg_tmp_timebase_folder
		newdatafolder/o/s input
		variable i
		for (i=0; i<itemsinlist(list); i+=1)
			wave param = $(acg_toTimeBase_folder+":"+stringfromlist(i,list))
			if (i == index) // date_time wave
				duplicate/o param Start_DateTime
			else
				string name = acg_map2newname(stringfromlist(i,list))
				duplicate/o param $name
			endif
		endfor

		// exit
	elseif (cmpstr(ctrlName,"cancelButton") == 0)
		print "cancelled"
	endif
	killwindow DateTimeSelPanel_TB

End

Function toTimeBase_PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	print ctrlName, popNum, popStr

	string sdf = getdatafolder(1)
	setdatafolder $acg_toTimeBase_folder

	NVAR index = datetime_index
	index = popNum - 1

	setdatafolder sdf

End

function acg_set_timebase_loaded_waves()

	acg_init_gui()

	DoWindow/F DateTimeSelPanel_TB
	if (V_Flag != 0)
		return 0
	endif
	Execute "DateTimeSelPanel_TB()"
	PauseForUser DateTimeSelPanel_TB

	//Variable tb
	//Prompt tb,"enter timebase (in seconds)"
	//DoPrompt "Enter timebase", tb
	DoWindow/F LoadTimeBasePanel
	if (V_Flag != 0)
		return 0
	endif
	Execute "LoadTimeBasePanel()"


end

Window LoadTimeBasePanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(150,77,450,277) as "Common Time Base"
	SetDrawLayer UserBack
	DrawText 67,36,"Choose where to save data..."
	PopupMenu data_folder_popup,pos={61,43},size={170,21},proc=DFolder_PopMenuProc
	PopupMenu data_folder_popup,mode=1,bodyWidth= 170,popvalue="<new data folder>",value=acg_getdatafolder_list()
	SetVariable acg_timebase,pos={76,94},size={135,16},proc=TimeBase_SetVarProc,title="Time Base (sec)"
	SetVariable acg_timebase,format="%G"
	SetVariable acg_timebase,limits={1,43200,0},value= root:gui:last_timebase,bodyWidth= 60
	Button go_button,pos={133,147},size={85,22},proc=TimeBase_ButtonProc,title="Go"
	Button cancel_button,pos={62,147},size={50,22},proc=TimeBase_ButtonProc,title="Cancel"
EndMacro

Function TimeBase_SetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName


End

Function TimeBase_ButtonProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"go_button") == 0)
		// do the avg
		//acg_check_avgtime()
		//acg_average_loaded_data()
		//acg_concat_loaded_data()
		acg_common_timebase_data(1)
		killwindow LoadTimeBasePanel
	else
		// quit
		killwindow LoadTimeBasePanel
	endif

	killdatafolder/Z $acg_tmp_timebase_folder
End

Function acg_common_timebase_data(moveWaves)
	variable moveWaves
	String sdf = getdatafolder(1)
	setdatafolder $(acg_tmp_timebase_folder+":input")
	string list = acg_get_wave_list()
	setdatafolder acg_tmp_timebase_folder

	wave ds_tw = $(":input:Start_DateTime")

	nvar tb = root:gui:last_timebase

	// --- Change here ---

	// get timebase limits
	wavestats/Q ds_tw
	variable mintime=V_min
	variable maxtime=V_max

	variable/G first_starttime=mintime - mod(mintime,tb)
	variable/G last_starttime=maxtime - mod(maxtime,tb) + tb

	variable time_periods = (last_starttime-first_starttime)/(tb) + 1

	if ((last_starttime-maxtime) > tb)
		time_periods -= 1
	endif

	variable pts = time_periods
	make/o/d/n=(pts) common_tw
	common_tw[0] = first_starttime
	common_tw[1,] = common_tw[p-1]+tb

	nvar dfIndex = root:gui:load_datafolder_index
	svar dfolder_list = root:gui:load_datafolder_list
//	string destFolder = "root:"+stringfromlist(dfindex,dfolder_list)
	string destFolder

	if (moveWaves)
		//destFolder = "root:"+stringfromlist(dfindex,dfolder_list)
		destFolder = acg_get_destFolder_from_list(dfindex)

		//newdatafolder/o $(destFolder)
		acg_create_destFolder(destFolder)
		duplicate/o common_tw $(destFolder+":date_time")
	endif

	variable i,j
	for (i=0; i<itemsinlist(list); i+=1)
		string var = stringfromlist(i,list)
		if (cmpstr(var,"Start_DateTime") != 0)
			wave v = $(":input:"+var)
			duplicate/o common_tw $(var+"_c")
			wave w = $(var+"_c")
			w=NaN
			SetScale/P x common_tw[0],tb,"dat", w
			for (j=0; j<numpnts(v); j+=1)
	//			variable index = x2pnt(w,ds_tw[j])
	//			w[index] = v[j]
				w[round(x2pnt(w,ds_tw[j]))] = v[j]
			endfor
			if (moveWaves)
				duplicate/o w $(destFolder+":"+var)
			endif
		endif
	endfor
	if (moveWaves)
		killdatafolder/Z $(acg_tmp_timebase_folder)
	endif
	setdatafolder sdf
end

function acg_concat_loaded_waves()

	acg_init_gui()

	DoWindow/F DateTimeSelPanel_Concat
	if (V_Flag != 0)
		return 0
	endif
	Execute "DateTimeSelPanel_Concat()"
	PauseForUser DateTimeSelPanel_Concat

	DoWindow/F LoadConcatPanel
	if (V_Flag != 0)
		return 0
	endif
	Execute "LoadConcatPanel()"

end

Window LoadConcatPanel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(150,77,450,277) as "Concatenate"
	SetDrawLayer UserBack
	DrawText 67,36,"Choose where to save/concatenate data..."
	PopupMenu data_folder_popup,pos={61,43},size={170,21},proc=DFolder_PopMenuProc
	PopupMenu data_folder_popup,mode=1,bodyWidth= 170,popvalue="<new data folder>",value=#acg_getdatafolder_list()
	SetVariable acg_concat_tb,pos={76,94},size={135,16},proc=Concat_SetVarProc,title="Time Base (sec)"
	SetVariable acg_concat_tb,format="%G"
	SetVariable acg_concat_tb,limits={1,43200,0},value= root:gui:last_timebase,bodyWidth= 60
	Button go_button,pos={133,147},size={85,22},proc=Concat_ButtonProc,title="Go"
	Button cancel_button,pos={62,147},size={50,22},proc=Concat_ButtonProc,title="Cancel"
	SetVariable acg_concat_avg,pos={56,115},size={156,16},bodyWidth=60,proc=Concat_SetVarProc,title="Average Time (sec)"
	SetVariable acg_concat_avg,limits={-inf,inf,0},value= root:gui:last_avgtime
	CheckBox concat_doAvg,pos={222,115},size={73,14},proc=Concat_CheckProc,title="do Average"
	CheckBox concat_doAvg,value=root:gui:concat_do_avg_flag
EndMacro

// For same TimeBase
Window DateTimeSelPanel_Concat() : Panel
	string sdf = getdatafolder(1)
	setdatafolder $acg_toConcat_folder
	variable/G datetime_index = 0
	setdatafolder sdf

	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(364,155,664,355) as "DateTime Selector"
	SetDrawLayer UserBack
	DrawText 85,62,"Select DateTime wave:"
	PopupMenu DateTimeSelector,pos={72,67},size={158,21},proc=toConcat_PopMenuProc
	PopupMenu DateTimeSelector,mode=1,bodyWidth= 158,value= #"acg_get_toConcat_list()"
	Button doneButton,pos={160,121},size={86,30},proc=toConcat_ButtonProc,title="Done"
	Button cancelButton,pos={53,121},size={86,30},proc=toConcat_ButtonProc,title="Cancel"
EndMacro

Function toConcat_ButtonProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"doneButton") == 0)


		// copy data to acg_tmp_datafolder
		string sdf = getdatafolder(1)
		setdatafolder $acg_toConcat_folder

		NVAR index = datetime_index
		string list = acg_get_toConcat_list()

		newdatafolder/o/s $acg_tmp_concat_folder
		newdatafolder/o/s input
		variable i
		for (i=0; i<itemsinlist(list); i+=1)
			wave param = $(acg_toConcat_folder+":"+stringfromlist(i,list))
			if (i == index) // date_time wave
				duplicate/o param Start_DateTime
			else
				string name = acg_map2newname(stringfromlist(i,list))
				duplicate/o param $name
			endif
		endfor

		 //exit
	elseif (cmpstr(ctrlName,"cancelButton") == 0)
		print "cancelled"
	endif
	killwindow DateTimeSelPanel_Concat

End

Function toConcat_PopMenuProc(ctrlName,popNum,popStr) : PopupMenuControl
	String ctrlName
	Variable popNum
	String popStr
	print ctrlName, popNum, popStr

	string sdf = getdatafolder(1)
	setdatafolder $acg_toConcat_folder

	NVAR index = datetime_index
	index = popNum - 1

	setdatafolder sdf

End

Function Concat_SetVarProc(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum
	String varStr
	String varName


End

Function Concat_CheckProc(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			NVAR flag = root:gui:concat_do_avg_flag
			flag = checked
			print checked
			break
	endswitch

	return 0
End

Function Concat_ButtonProc(ctrlName) : ButtonControl
	String ctrlName

	if (cmpstr(ctrlName,"go_button") == 0)
		// do the avg
		//acg_check_avgtime()
		//acg_average_loaded_data()
		//acg_concat_loaded_data()
		//acg_common_timebase_data(1)
		acg_same_tb_concat_loaded_waves()
		killwindow LoadConcatPanel
	else
		// quit
		killwindow LoadConcatPanel
	endif

	killdatafolder/Z $acg_tmp_concat_folder
End

// put new waves on correct timebase and concat with user supplied waves
Function acg_same_tb_concat_loaded_waves()

	string sdf = getdatafolder(1)
	variable i,j,k


	// Have to change below to use the tmp folders -- doh!
	newdatafolder/o/s $acg_tmp_timebase_folder
	newdatafolder/o/s input

	// duplicate current waves to toTimeBase folder and determine the proper timebase
	// 	to create - a) use dataset_timebase var if exists or b) determine from dest timewave
	setdatafolder $(acg_tmp_concat_folder+":input")
	string list = acg_get_wave_list()
	for (i=0; i<itemsinlist(list); i+=1)
		string w = stringfromlist(i,list)
		duplicate/o $w $(acg_tmp_timebase_folder+":input:"+w)
	endfor
//	NVAR tb_index = $(acg_tmp_timebase_folder+":input:datetime_index")
//	NVAR concat_index = datetime_index
//	tb_index = concat_index

	// determine the proper timebase to use
	NVAR tb = root:gui:last_timebase
	nvar dfIndex = root:gui:load_datafolder_index
	svar dfolder_list = root:gui:load_datafolder_list

	//string destFolder = stringfromlist(dfindex,dfolder_list)
	string destFolder = acg_get_destFolder_from_list(dfindex)

	if (exists(destFolder+":dataset_timebase") == 2)
		NVAR ds_tb = $(destFolder+":dataset_timebase")
		tb = ds_tb
	endif

	// put new waves on common timebase - use concat tmp directory as dest (try and do all this
	//	without using the dialog

	// set tmp values for running toTimeBase
	variable bak_index = dfIndex
	variable tmp_index = 0
	dfIndex = tmp_index
	string bak_list = dfolder_list
	//string tmp_list = acg_tmp_concat_folder
	string tmp_list = "acg_tmp_concat"
	dfolder_list = tmp_list
	acg_common_timebase_data(1)

	// reset the gui variables
	dfIndex = bak_index
	dfolder_list = bak_list

	// do standard tricks to add new data to old (keep new data at overlap)
	acg_concat_waves(acg_tmp_concat_folder, destFolder, tb)






//	string sdf = getdatafolder(1)
//	setdatafolder acg_toConcat_folder
//
//	string  new_wlist = get_wavelist(":")
//
//	nvar dfIndex = root:gui:load_datafolder_index
//	svar dfolder_list = root:gui:load_datafolder_list
//	string destFolder = "root:"+stringfromlist(dfindex,dfolder_list)
//	string  old_wlist = get_wavelist(destFolder)
//
//	variable i,j,k
//	variable new_cnt = itemsinlist(new_wlist)
//	for (i=0; i<new_cnt; i+=1)
//		string new_wname = stringfromlist(i,new_wlist)
//		wave new_w = $new_wname
//		variable old_index = whichlistitem(new_wname,old_wlist)
//		if (old_index != -1)
//			wave old_w = $(destFolder + ":" + stringfromlist(old_index,old_wlist))
//			concatenate/o/np {old_w,new_w}, cat_w
//			// I need a time wave first...otherwise I can't clean this up
//		endif
//	endfor

	setdatafolder sdf
End

Function acg_concat_waves(srcFolder, destFolder, tb)
	string srcFolder, destFolder
	variable tb // timebase
	String sdf = getdatafolder(1)

//	SVAR folderlist = root:gui:load_datafolder_list
//	NVAR findex = root:gui:load_datafolder_index
//	NVAR avgtime = root:gui:last_avgtime
//	string dfolder = "root:"+stringfromlist(findex,folderlist)
	variable isNew = 0
	if (!datafolderexists(destFolder) || (exists(destFolder+":date_time") != 1) )
		//newdatafolder/s $destFolder
		acg_create_destFolder(destFolder)
		setdatafolder destFolder
		variable/G dataset_timebase = tb
		isNew = 1
	endif
	setdatafolder srcFolder
	string wlist = acg_get_wave_list()

	// handle the times
	wave new_dt = date_time
	if (isNew)
		duplicate new_dt $(destFolder+":date_time")
	else
		duplicate/o $(destFolder+":date_time") $(destFolder+":date_time_bak")
		wave old_dt = $(destFolder+":date_time_bak")
		wavestats/Q new_dt
		variable newmin = V_min
		variable newmax = V_max
		wavestats/Q old_dt
		variable oldmin = V_min
		variable oldmax = V_max
		variable mintime = (newmin<oldmin) ? newmin : oldmin
		variable maxtime = (newmax>oldmax) ? newmax : oldmax

		variable npts = ((maxtime-mintime)/tb) + 1
		make/o/n=(npts)/d $(destFolder+":date_time")
		wave dt = $(destFolder+":date_time")
		dt[0] = mintime
		dt[1,] = dt[p-1]+tb

		// create doy wave for ease
		datetime2doy_wave(dt,destFolder+":doy")
	endif

	String lname
	variable i
	wave dt = $(destFolder+":date_time")
	wave old_dt = $(destFolder+":date_time_bak")
	for (i=0; i<itemsinlist(wlist); i+=1)
		String wname = stringfromlist(i,wlist)
		if ( (cmpstr(wname,"Start_DateTime") == 0) || (cmpstr(wname,"date_time") ==0)  || (cmpstr(wname,"AvePeriod") ==0)  || (cmpstr(wname,"DOY")==0) )
			// skip these
		else
			lname = acg_map2newname(wname)
			wave new_param = $(wname)
			if (waveexists($(destFolder+":"+lname)))
				duplicate/o $(destFolder+":"+lname) $(destFolder+":"+lname+"_bak")
				wave old_param = $(destFolder+":"+lname+"_bak")
				duplicate/o dt $(destFolder+":"+lname)
				wave param = $(destFolder+":"+lname)
				param = NaN
				SetScale/P x dt[0],tb,"dat", param
				variable starti = x2pnt(param,old_dt[0])
				param[starti,starti+numpnts(old_param)] = old_param[p-starti]
				starti = x2pnt(param,new_dt[0])
				param[starti,starti+numpnts(new_param)] = new_param[p-starti]
			else
				duplicate/o dt $(destFolder+":"+lname)
				wave param = $(destFolder+":"+lname)
				param = NaN
				SetScale/P x dt[0],tb,"dat", param
				starti = x2pnt(param,new_dt[0])
				param[starti,starti+numpnts(new_param)] = new_param[p-starti]
			endif
		endif
	endfor

	setdatafolder sdf
End

// This function assumes that the data are already on a common timebase and data_w scaled with datetime
Function acg_adjust_wave_to_datetime(start_dt, stop_dt, tb, dt_w, data_w, newdt_name, newdata_name)
	variable start_dt, stop_dt, tb
	wave dt_w, data_w
	string newdt_name, newdata_name

	//create new time wave
	variable pnts = (stop_dt - start_dt) / tb + 1
	make/D/o/n=(pnts) $newdt_name
	wave newdt = $newdt_name
	newdt[0] = start_dt
	newdt[1,] = newdt[p-1] + tb

	duplicate/o newdt $newdata_name
	wave newdata = $newdata_name
	newdata = NaN
	SetScale/P x newdt[0],tb,"dat", newdata

	variable starti,index
	index=0
	do
		starti = x2pnt(newdata,dt_w[index])
		index += 1
	while ( ((starti < 0) || (starti > pnts-1)) && (index < pnts) )
	variable totalpnts
	totalpnts = ( (pnts-1) > (starti+numpnts(data_w)) ) ?  numpnts(data_w) : (pnts-starti-1)
	newdata[starti,starti+totalpnts] = data_w[p-starti]


End

// acg_expand_wave_to_tb
// 	Expand a wave based from a lower resolution (e.g. 300 s) to higher resolution (e.g., 60 s) timebase. It will also apply adjust the
//	wave to the start and stop times given (similar to the function above).
//  Input:
//	start_dt 			= first datetime of the output wave
//	stop_dt 			= last datetime of output wave
// 	old_tb   			= old, lower resolution timebase in seconds
//	new_tb 			= new, higher resolution timebase in seconds
//	dt_w			= original datetime wave of data to be expanded
//	data_w 			= original data wave to be expanded
//	newdt_name		= string containing the name of datetime wave to be created and output
//	newdata_name 	= string containing the name of data wave to be created and output
// 	expansion_type 	= how should the data be "expanded"
//		0  = stairstep (default) - all data in the expanded region will be the same value
//		1 = interpolate - interpolate over added timesteps (not implemented, yet)
Function acg_expand_wave_to_tb(start_dt, stop_dt, old_tb, new_tb, dt_w, data_w, newdt_name, newdata_name, expansion_type)
	variable start_dt, stop_dt
	variable old_tb, new_tb
	wave dt_w, data_w
	string newdt_name, newdata_name
	variable expansion_type

	variable tb_offset = floor(old_tb/new_tb) - 1

	//create new time wave
	variable pnts = (stop_dt - start_dt) / new_tb + 1
	make/o/d/n=(pnts) $newdt_name
	wave newdt = $newdt_name
	newdt[0] = start_dt
	newdt[1,] = newdt[p-1] + new_tb

	// change this to allow for 2D data
//	duplicate/o newdt $newdata_name
	duplicate/o data_w $newdata_name
	wave newdata = $newdata_name
	newdata = NaN
	variable is2d = 0
	if (dimsize(newdata,1) > 0) // multi d data
		redimension/N=(numpnts(newdt),dimsize(newdata,1)) newdata
		is2d = 1
	else
		redimension/N=(numpnts(newdt)) newdata
	endif

	SetScale/P x newdt[0],new_tb,"dat", newdata

	variable starti,index
//	index=0
//	do
//		starti = x2pnt(newdata,dt_w[index])
//		index += 1
//	while ( ((starti < 0) || (starti > pnts-1)) && (index < pnts) )

	if (is2d)
		for (index=0; index<numpnts(dt_w); index+=1)
			starti = x2pnt(newdata,dt_w[index])
			if ( (starti>0) && (starti<numpnts(newdata)) )
				if (expansion_type == 0)
					//if (starti+tb_offset > numpnts(newdata)-1)
					if (starti+tb_offset > dimsize(newdata,0)-1)
						newdata[starti,] = data_w[index][q]
					else
						newdata[starti,starti+tb_offset] = data_w[index][q]
					endif
				endif
			endif
		endfor

	else

		for (index=0; index<numpnts(dt_w); index+=1)
			starti = x2pnt(newdata,dt_w[index])
			if ( (starti>0) && (starti<numpnts(newdata)) )
				if (expansion_type == 0)
					if (starti+tb_offset > numpnts(newdata)-1)
						newdata[starti,] = data_w[index]
					else
						newdata[starti,starti+tb_offset] = data_w[index]
					endif
				endif
			endif
		endfor
	endif
//	variable totalpnts
//	totalpnts = ( (pnts-1) > (starti+numpnts(data_w)) ) ?  numpnts(data_w) : (pnts-starti-1)
//	newdata[starti,starti+totalpnts] = data_w[p-starti]


End


// acg_expand_wave_to_wave_start_stop
// 	Expand a wave based from a lower resolution (e.g. 300 s) to higher resolution (e.g., 60 s) wave. It will also apply adjust the
//	wave to the start and stop times given (similar to the function above).
//  Input:
//	slow_start_dt 			= start_datetime wave of slower resolution
//	slow_stop_dt 			= stop_datetime wave of slower resolution
//	slow_dat 				= data wave of slower resolution
//	slow_start_dt 			= start_datetime wave of faster resolution
//	slow_stop_dt 			= stop_datetime wave of faster resolution
//	newdata_name 	= string containing the name of data wave to be created and output
// 	expansion_type 	= how should the data be "expanded"
//		0  = stairstep (default) - all data in the expanded region will be the same value
//		1 = interpolate - interpolate over added timesteps (not implemented, yet)
Function acg_expand_startstop2startstop(slow_start_dt, slow_stop_dt, slow_dat, fast_start_dt, fast_stop_dt, newdata_name, expansion_type)
	wave slow_start_dt
	wave slow_stop_dt
	wave slow_dat
	wave fast_start_dt
	wave fast_stop_dt
	string newdata_name
	variable expansion_type

	make/o/n=(numpnts(fast_start_dt))/d $(newdata_name) //, testi_start, testi_stop
	//make/o/n=(numpnts(slow_start_dt))/d testi_start, testi_stop
	wave fast_dat = $(newdata_name)
	//wave pnt_start  = testi_start
	//wave pnt_stop  = testi_stop
	fast_dat = NaN
	//pnt_start = NaN
	//pnt_stop = NaN

	variable i, starti, stopi
	for (i=0; i<numpnts(slow_start_dt); i+=1)
//		pnt_start[i] = BinarySearch(fast_start_dt,slow_start_dt[i])
//		pnt_stop[i] = BinarySearch(fast_stop_dt,slow_stop_dt[i])
		starti = BinarySearch(fast_start_dt,slow_start_dt[i])
		stopi = BinarySearch(fast_stop_dt,slow_stop_dt[i])
		if (starti == -1  && stopi == -1)
			continue
		elseif (starti == -2 && stopi == -2)
			return 0
		endif

		starti = (starti == -1) ? 0 : starti
		stopi = (stopi == -2) ? numpnts(fast_stop_dt)-1 : stopi

		fast_dat[starti,stopi] = slow_dat[i]

	endfor

End

// Calcuates stats over all data in specficed time periods
Function acg_stats_using_time_index(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat
	string output_name

	make/o/n=0 all_data
	wave all = all_data

	//make/o/n=(numpnts(avg_per_start)) $(output_name)
	//wave avg = $(output_name)
	//avg=NaN
	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		duplicate/o all, tmp_all
		wave tmp = tmp_all

		variable starti = BinarySearch(dt, avg_per_start[i])
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		if (starti >= 0 && stopi >=0)
			make/o/n=(stopi-starti+1) per_data
			wave per = per_data
			per = dat[p+starti]
			concatenate/np/o {tmp,per}, all_data

		endif
	endfor

	wave all = all_data

	make/o/n=4 $(output_name)
	wave out = $(output_name)

	WaveStats/Q all
	out[0] = V_avg
	out[1] = V_sdev
	out[2] = V_min
	out[3] = V_max


//		WaveStats/Q/R=[starti,stopi] dat
//		variable avg_var = V_avg
//		//print i, starti, stopi, avg_var
//		if (starti >=0 && stopi >= 0)
//			avg[i] = avg_var
//		endif
//	endfor
	killwaves/Z tmp_all, all_data, per_data
End

Function acg_avg_windD_using_time_index(avg_per_start, avg_per_stop, dt, windS,windD,output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave windS
	wave windD
	string output_name

	duplicate/o windD, tmp_windU, tmp_windV
	wave wU = tmp_windU
	wave wV = tmp_windV

	wU = -windS * sin(windD*(pi/180))
	wV = -windS * cos(windD*(pi/180))

	make/o/n=(numpnts(avg_per_start)) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		variable stopi = BinarySearch(dt, avg_per_stop[i])

		WaveStats/Q/R=[starti,stopi] wU
		variable wU_avg = V_avg

		WaveStats/Q/R=[starti,stopi] wV
		variable wV_avg = V_avg

		//print i, starti, stopi, avg_var
		if (starti >=0 && stopi >= 0)
			avg[i] = atan2(-wU_avg, -wV_avg) * 180/pi
		endif
	endfor

	avg = (avg[p] < 0) ? avg[p]+360 : avg[p]

End

//Function acg_sd_windD_using_time_index(avg_per_start, avg_per_stop, dt, windS,windD,output_name)
//	wave avg_per_start
//	wave avg_per_stop
//	wave dt
//	wave windS
//	wave windD
//	string output_name
//
//	duplicate/o windD, tmp_windU, tmp_windV
//	wave wU = tmp_windU
//	wave wV = tmp_windV
//
//	wU = -windS * sin(windD*(pi/180))
//	wV = -windS * cos(windD*(pi/180))
//
//	make/o/n=(numpnts(avg_per_start)) $(output_name)
//	wave sd = $(output_name)
//	sd=NaN
//	variable i
//	for (i=0; i<numpnts(avg_per_start); i+=1)
//		variable starti = BinarySearch(dt, avg_per_start[i])
//		variable stopi = BinarySearch(dt, avg_per_stop[i])
//
//		WaveStats/Q/R=[starti,stopi] wU
//		variable wU_avg = V_sdev
//
//		WaveStats/Q/R=[starti,stopi] wV
//		variable wV_avg = V_sdev
//
//		//print i, starti, stopi, avg_var
//		if (starti >=0 && stopi >= 0)
//			sd[i] = atan2(-wU_avg, -wV_avg) * 180/pi
//		endif
//	endfor
//
//	//avg = (avg[p] < 0) ? avg[p]+360 : avg[p]
//
//End

Function acg_avg_using_time_index(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat
	string output_name

	make/o/n=(numpnts(avg_per_start)) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		WaveStats/Q/R=[starti,stopi] dat
		variable avg_var = V_avg
		//print i, starti, stopi, avg_var
		if (starti >=0 && stopi >= 0)
			avg[i] = avg_var
		endif
	endfor
End

Function acg_sd_using_time_index(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat
	string output_name

	make/o/n=(numpnts(avg_per_start)) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		WaveStats/Q/R=[starti,stopi] dat
		variable avg_var = V_sdev
		//print i, starti, stopi, avg_var
		if (starti >=0 && stopi >= 0)
			avg[i] = avg_var
		endif
	endfor
End

Function acg_min_using_time_index(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat
	string output_name

	make/o/n=(numpnts(avg_per_start)) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		WaveStats/Q/R=[starti,stopi] dat
		variable avg_var = V_min
		//print i, starti, stopi, avg_var
		if (starti >=0 && stopi >= 0)
			avg[i] = avg_var
		endif
	endfor
End

Function acg_max_using_time_index(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat
	string output_name

	make/o/n=(numpnts(avg_per_start)) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		WaveStats/Q/R=[starti,stopi] dat
		variable avg_var = V_max
		//print i, starti, stopi, avg_var
		if (starti >=0 && stopi >= 0)
			avg[i] = avg_var
		endif
	endfor
End


Function acg_avg_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat // 2d wave
	string output_name

	variable rows = numpnts(avg_per_start)
	variable cols = dimsize(dat,1)

	make/o/n=(rows,cols) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i,j
	for (i=0; i<rows; i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		if (starti == -1)
			starti = 0
		endif
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		if (stopi == -2)
			stopi = numpnts(dt)-1
		endif

		for (j=0; j<cols; j+=1)
			acg_get_column_from_2d(dat,j,"tmp_col")
			wave tcol = tmp_col

			WaveStats/Q/R=[starti,stopi] tmp_col
			//print i,j,starti,stopi,V_avg
			if (starti >=0 && stopi >= 0)
				avg[i][j] = V_avg
			endif
			killwaves/Z tcol
		endfor
	endfor
End

Function acg_sd_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat // 2d wave
	string output_name

	variable rows = numpnts(avg_per_start)
	variable cols = dimsize(dat,1)

	make/o/n=(rows,cols) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i,j
	for (i=0; i<rows; i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		if (starti == -1)
			starti = 0
		endif
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		if (stopi == -2)
			stopi = numpnts(dt)-1
		endif

		for (j=0; j<cols; j+=1)
			acg_get_column_from_2d(dat,j,"tmp_col")
			wave tcol = tmp_col

			WaveStats/Q/R=[starti,stopi] tmp_col
			//print i,j,starti,stopi,V_avg
			if (starti >=0 && stopi >= 0)
				avg[i][j] = V_sdev
			endif
			killwaves/Z tcol
		endfor
	endfor
End

Function acg_min_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat // 2d wave
	string output_name

	variable rows = numpnts(avg_per_start)
	variable cols = dimsize(dat,1)

	make/o/n=(rows,cols) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i,j
	for (i=0; i<rows; i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		if (starti == -1)
			starti = 0
		endif
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		if (stopi == -2)
			stopi = numpnts(dt)-1
		endif

		for (j=0; j<cols; j+=1)
			acg_get_column_from_2d(dat,j,"tmp_col")
			wave tcol = tmp_col

			WaveStats/Q/R=[starti,stopi] tmp_col
			//print i,j,starti,stopi,V_avg
			if (starti >=0 && stopi >= 0)
				avg[i][j] = V_min
			endif
			killwaves/Z tcol
		endfor
	endfor
End

Function acg_max_using_time_index_2d(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat // 2d wave
	string output_name

	variable rows = numpnts(avg_per_start)
	variable cols = dimsize(dat,1)

	make/o/n=(rows,cols) $(output_name)
	wave avg = $(output_name)
	avg=NaN
	variable i,j
	for (i=0; i<rows; i+=1)
		variable starti = BinarySearch(dt, avg_per_start[i])
		if (starti == -1)
			starti = 0
		endif
		variable stopi = BinarySearch(dt, avg_per_stop[i])
		if (stopi == -2)
			stopi = numpnts(dt)-1
		endif

		for (j=0; j<cols; j+=1)
			acg_get_column_from_2d(dat,j,"tmp_col")
			wave tcol = tmp_col

			WaveStats/Q/R=[starti,stopi] tmp_col
			//print i,j,starti,stopi,V_avg
			if (starti >=0 && stopi >= 0)
				avg[i][j] = V_max
			endif
			killwaves/Z tcol
		endfor
	endfor
End

Function acg_avg_using_time_index2(avg_per_start, avg_per_stop, dt, dat, output_name)
	wave avg_per_start
	wave avg_per_stop
	wave dt
	wave dat
	string output_name

	make/o/n=(numpnts(avg_per_start)) $(output_name)
	wave avg = $(output_name)


	variable i
	for (i=0; i<numpnts(avg_per_start); i+=1)
		//variable starti = BinarySearch(dt, avg_per_start[i])
		//variable stopi = BinarySearch(dt, avg_per_stop[i])
		WaveStats/Q/R=(avg_per_start[i],avg_per_stop[i]) dat
		variable avg_var = V_avg
		//print i, starti, stopi, avg_var
		avg[i] = avg_var
	endfor
End

Function acg_mask_by_value(mask_w, mask_value, mask_value_range, data_w, output_name)
	wave mask_w
	variable mask_value
	variable mask_value_range
	wave data_w
	string output_name

	duplicate/o data_w $(output_name)
	wave out = $output_name

	out = ( (mask_w[p] > mask_value - mask_value_range) && (mask_w[p] < mask_value + mask_value_range) ) ? data_w[p] : NaN

End

Function/S acg_remove_quotes(str)
	string str
	string result = ReplaceString("\"",str,"")
	return result
End

Function acg_remove_quotes_wave(str_w)
	wave/T str_w
	variable i
	for (i=0; i<numpnts(str_w); i+=1)
		str_w[i] = acg_remove_quotes(str_w[i])
	endfor
End


Function acg_get_column_from_2d(data,colnum,output_name)

	wave data // 2d wave
	variable colnum // column to strip out
	string output_name // name of resulting 1d wave containing the column

	if (colnum > dimsize(data,1)-1)
		print "*** the input wave does not have that many columns ***"
		return 0
	endif

	make/o/D/n=(dimsize(data,0)) $(output_name)
	wave out = $output_name

	out = data[p][colnum]




End


Function acg_mask_1D(dat,mask,uses_nans,output_name)
	wave dat
	wave mask
	variable uses_nans // 1=mask uses 1's and nans, 0=value based (1=good, 0=bad)
	string output_name

	duplicate/o dat $output_name
	wave out = $output_name

	out = NaN

	if (uses_nans)
		out = dat*mask
	else
		out = (mask[p] > 0) ? dat[p] : NaN
	endif

End

Function acg_mask_2D(dat,mask,uses_nans,output_name)
	wave dat
	wave mask
	variable uses_nans // 1=mask uses 1's and nans, 0=value based (1=good, 0=bad)
	string output_name

	duplicate/o dat $output_name
	wave out = $output_name

	out = NaN

	if (dimsize(mask,1) > 0) // uses 2d mask wave
		if (uses_nans)
			out = dat*mask
		else
			out = (mask[p][q] > 0) ? dat[p][q] : NaN
		endif
	else
		if (uses_nans)
			out = dat[p][q]*mask[p] // does this work?
		else
			out = (mask[p] > 0) ? dat[p][q] : NaN
		endif
	endif

End


// *********** ProjectInfo and TBM code *****************

Structure PIE_Data
	string	 	info
	variable		saved
EndStructure

Function/S acg_goto_ProjectInfo()

	string sdf = getdatafolder(1)
	setdatafolder root:

	if (!datafolderexists("ProjectInfo"))
		acg_init_ProjectInfo()
	endif

	setdatafolder "root:ProjectInfo"
	return sdf
End

Function acg_export_project_info()

	string sdf = acg_goto_ProjectInfo()

	SaveData/O/I/R

	setdatafolder sdf

End

Function acg_import_project_info()

	string sdf = getdatafolder(1)
	setdatafolder root:

	LoadData/I/O/T/R

	setdatafolder sdf

End

Function/S acg_goto_ProjectInfoDB()

	string sdf = acg_goto_ProjectInfo()

	if (!datafolderexists("ProjectInfoDB"))
		acg_init_ProjectInfoDB()
	endif

	setdatafolder "ProjectInfoDB"
	return sdf
End

Function/S acg_goto_PIC()

	string sdf = acg_goto_ProjectInfo()

	if (!datafolderexists("gui_PIC"))
		acg_init_PIC()
	endif

	setdatafolder "gui_PIC"
	return sdf
End

Function/S acg_goto_PIE()

	string sdf = acg_goto_ProjectInfo()

	if (!datafolderexists("gui_PIE"))
		acg_init_PIE()
	endif

	setdatafolder "gui_PIE"
	return sdf
End

// PIC = ProjectInfo Controller
Function acg_display_PIC()


	//if (!datafolderexists(ProjectInfo_folder)) // init Project info
	//	acg_init_ProjectInfo()
	//endif

	acg_goto_ProjectInfo()

	acg_update_PIC_gui_data()

	DoWindow/F acg_ProjInfo_Controller
	if (V_Flag != 0)
		return 0
	endif
//
//	init_gui()
	Execute "acg_ProjInfo_Controller()"

End

Function acg_init_PIC()

	string sdf = acg_goto_ProjectInfo()

	newdatafolder/o/s gui_PIC
	variable/G PIC_data_saved
	string/G PIC_info_string
	string/G tmp_project_info

	setdatafolder sdf

End

Function acg_init_PIE()

	string sdf = acg_goto_ProjectInfo()

	newdatafolder/o/s gui_PIE

	string/G proj_name = ""

	// --- Start Time ---
	variable/G start_year = 2010
	variable/G start_month = 1
	variable/G start_day = 1

	variable/G start_hour = 0
	variable/G start_minute = 0
	variable/G start_second = 0

	// --- Stop Time ---
	variable/G stop_year = 2010
	variable/G stop_month = 1
	variable/G stop_day = 1

	variable/G stop_hour = 0
	variable/G stop_minute = 0
	variable/G stop_second = 0

	variable/G proj_info_entry_saved = 0 // 0 = cancel, 1 = save from edit panel

	setdatafolder ::

	acg_reset_PIE_data()

End

Function acg_update_PIC_gui_data()
//	string sdf = getdatafolder(1)
//	setdatafolder ProjectInfo_folder

	//acg_init_PIC()




	NVAR isSet = this_project_is_set
	SVAR proj_info = this_project_info
	//newdatafolder/o/s gui_PIC
	//variable/G PIC_data_saved = 0

	//string/G PIC_info_string

	string sdf = acg_goto_PIC()

	SVAR display_str = PIC_info_string
	if (!isSet)
		//display_str = "No Project Info"
		display_str = "\\Z14Project Name: N/A  \\Z12\r\r\tStart Time: N/A   \r\tStop Time: N/A  "
		return 0
	endif

	//SVAR proj_info = ::this_project_info
	//string/G tmp_project_info = proj_info

	SVAR info = tmp_project_info
	info = proj_info

	string val = stringbykey("NAME",info)
	display_str = "\\Z14Project Name: " + val + "\\Z12\r\r"

	variable dt = numberbykey("START_DT",info)
	display_str += "\tStart Time: " + secs2date(dt,0) + " " + secs2time(dt,3) + "\r"

	dt = numberbykey("STOP_DT",info)
	display_str += "\tStop Time: " + secs2date(dt,0) + " " + secs2time(dt,3)


	setdatafolder sdf
End

Function acg_init_ProjectInfo()

	//string sdf = getdatafolder(1)
	setdatafolder root:

	// create ProjectInfo data folder(s) if they don't exist
	//     ProjectInfo              <-- for current expt
	//		ProjectInfoDB    <-- global info

	//

	newdatafolder/o/s ProjectInfo

	//string/G this_project_info = "NAME:;START_DT:;STOP_DT:;"
	string/G this_project_info = ProjectInfo_empty_string

//	string/G this_proj_name = ""
//
//	variable/G this_start_year = 2008
//	variable/G this_start_month = 1
//	variable/G this_start_day = 1
//
//	variable/G this_start_hour = 0
//	variable/G this_start_minute = 0
//	variable/G this_start_second = 0
//
//	variable/G this_stop_year = 2008
//	variable/G this_stop_month = 1
//	variable/G this_stop_day = 1
//
//	variable/G this_stop_hour = 0
//	variable/G this_stop_minute = 0
//	variable/G this_stop_second = 0
//
	variable/G this_project_is_set = 0

//	string/G this_project_info_string = "No Project Info\rNo Project Info\rNo Project Info"
	//string/G this_project_info_string = "\\Z14Project Name: N/A  \\Z12\r\r\tStart Time: N/A   \r\tStop Time: N/A  "


	//acg_reset_PIE_data()



//	newdatafolder/o/s gui
//	string/G proj_name = ""
//
//	variable/G start_year = 2008
//	variable/G start_month = 1
//	variable/G start_day = 1
//
//	variable/G start_hour = 0
//	variable/G start_minute = 0
//	variable/G start_second = 0
//
//	variable/G stop_year = 2008
//	variable/G stop_month = 1
//	variable/G stop_day = 1
//
//	variable/G stop_hour = 0
//	variable/G stop_minute = 0
//	variable/G stop_second = 0
//
//	variable/G proj_info_entry_saved = 0 // 0 = cancel, 1 = save from edit panel
//	setdatafolder ::

	//setdatafolder sdf

End

Function acg_reset_PIE_data()

	acg_set_PIE_data(ProjectInfo_empty_string)

End

// PIE = ProjectInfoEntry
Function acg_set_PIE_data(info)
	string info

//	string sdf = getdatafolder(1)
//	setdatafolder ProjectInfo_folder
//
//	newdatafolder/o/s gui_PIE

	string sdf = acg_goto_PIE()

	SVAR proj_name
	proj_name = stringbykey("NAME",info)


	// --- Start Time ---
	NVAR start_year
	NVAR start_month
	NVAR start_day
	start_year = 2010
	start_month = 1
	start_day = 1

	NVAR start_hour
	NVAR start_minute
	NVAR start_second
	start_hour = 0
	start_minute = 0
	start_second = 0

	variable val = numberbykey("START_DT",info)
	if (numtype(val) == 0)
		start_year = acg_get_year(val)
		start_month = acg_get_month(val)
		start_day = acg_get_day(val)
		start_hour = acg_get_hour(val)
		start_minute = acg_get_minute(val)
		start_second = acg_get_second(val)
	endif


	// --- Stop Time ---
	NVAR stop_year
	NVAR stop_month
	NVAR stop_day
	stop_year = 2010
	stop_month = 1
	stop_day = 1

	NVAR stop_hour
	NVAR stop_minute
	NVAR stop_second
	stop_hour = 0
	stop_minute = 0
	stop_second = 0

	val = numberbykey("STOP_DT",info)
	if (numtype(val) == 0)
		stop_year = acg_get_year(val)
		stop_month = acg_get_month(val)
		stop_day = acg_get_day(val)
		stop_hour = acg_get_hour(val)
		stop_minute = acg_get_minute(val)
		stop_second = acg_get_second(val)
	endif


	NVAR proj_info_entry_saved // 0 = cancel, 1 = save from edit panel
	proj_info_entry_saved = 0

	setdatafolder sdf

End

Function acg_set_ProjectInfo()

	// dialog -> set local only or select from db
	//	if db
	// 		if doesn't exist...
	//			create or import


End

Function acg_init_ProjectInfoDB()

	acg_goto_ProjectInfo()

	newdatafolder/o/s ProjectInfoDB

	string/G entry_proj_name = ""

	variable/G entry_start_year = 2010
	variable/G entry_start_month = 1
	variable/G entry_start_day = 1

	variable/G entry_start_hour = 0
	variable/G entry_start_minute = 0
	variable/G entry_start_second = 0

	variable/G entry_stop_year = 2010
	variable/G entry_stop_month = 1
	variable/G entry_stop_day = 1

	variable/G entry_stop_hour = 0
	variable/G entry_stop_minute = 0
	variable/G entry_stop_second = 0

End

Function acg_create_ProjectInfoDB()
	acg_init_ProjectInfoDB()
	make/o/S/n=0 ProjectInfoDB
End


Function acg_import_ProjectInfoDB()
	// Load igor text file containing db
End


Function acg_edit_ProjectInfoDB()
	// Pop up edit window
	DoWindow/F acg_ProjInfoDB_panel
		if (V_Flag != 0)
		return 0
	endif

	Execute "acg_ProjInfoDB_panel()"

End


Function acg_create_ProjectInfoDB_entry()

End

Function acg_edit_ProjectInfoDB_entry()

End

Function acg_delete_ProjectInfoDB_entry()

End

Function acg_select_ProjectInfoDB_entry()

End

Function acg_edit_current_ProjectInfo()

	struct PIE_Data data
	string sdf = acg_goto_ProjectInfo()

	string info = ProjectInfo_empty_string

	NVAR isSet = this_project_is_set
	SVAR current_info = this_project_info
	if (isSet)
		info = current_info
	endif
	data.info = info
	data.saved = 0
	//print isSet, data
	acg_display_PIE_panel(data)
	if (data.saved)
		current_info = data.info
		isSet = 1
		acg_update_PIC_gui_data()
	endif
	setdatafolder sdf
End

Function acg_display_PIE_panel(data)
	struct PIE_Data &data

	DoWindow/K acg_ProjInfo_entry_panel
	acg_set_PIE_data(data.info)
	Execute "acg_ProjInfo_entry_panel()"
	PauseForUser acg_ProjInfo_entry_panel
	acg_goto_PIE()
	SVAR info = proj_info
	NVAR saved = proj_info_entry_saved
	data.info = info
	data.saved = saved
	print data
	setdatafolder ::
	//killdatafolder/Z gui_PIE
End

Function acg_set_PIE_info()

	string sdf = acg_goto_PIE()
	SVAR proj_name
	NVAR start_year
	NVAR start_month
	NVAR start_day
	NVAR start_hour
	NVAR start_minute
	NVAR start_second
	NVAR stop_year
	NVAR stop_month
	NVAR stop_day
	NVAR stop_hour
	NVAR stop_minute
	NVAR stop_second

	variable start_dt = date2secs(start_year, start_month, start_day) + start_hour*60*60 + start_minute*60 + start_second
	variable stop_dt = date2secs(stop_year, stop_month, stop_day) + stop_hour*60*60 + stop_minute*60 + stop_second


	string/G proj_info = ProjectInfo_empty_string
	proj_info = acg_set_info(proj_info,proj_name,start_dt,stop_dt)
	setdatafolder sdf
End

Function/S acg_set_info(info, name, start_dt, stop_dt)
	string info
	string name
	variable start_dt
	variable stop_dt

	info = ReplaceStringByKey("NAME",info,name)
	info = ReplaceNumberByKey("START_DT",info,start_dt)
	info = ReplaceNumberByKey("STOP_DT",info,stop_dt)

	return info
End

Function ProjInfo_Entry_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	//string sdf = getdatafolder(1)
	//setdatafolder ProjectInfo_folder
	//setdatafolder :gui_PIE

	switch( ba.eventCode )
		case 2: // mouse up

			string sdf = acg_goto_PIE()
			NVAR saved = proj_info_entry_saved

			print ba.ctrlName
			if (cmpstr(ba.ctrlName,"entry_save_button") == 0 )
				saved = 1
				acg_set_PIE_info()
				print "Save...saved = ", saved
			elseif (cmpstr(ba.ctrlName,"entry_cancel_button") == 0 )
				saved = 0
				print "Cancel...saved = ", saved
			else
				saved = 0
				print "Unknown...saved = ", saved
			endif

			killwindow acg_ProjInfo_entry_panel
			setdatafolder ::
			//killdatafolder :gui_PIE
			//setdatafolder sdf
			break
	endswitch

	return 0
End



Window acg_ProjInfo_entry_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(851,374,1349,605) as "Project Info Entry"
	SetDrawLayer UserBack
	SetDrawEnv fstyle= 1
	DrawText 178,104,"-"
	SetDrawEnv fstyle= 1
	DrawText 230,104,"-"
	SetDrawEnv fstyle= 1
	DrawText 346,105,":"
	SetDrawEnv fstyle= 1
	DrawText 393,105,":"
	DrawText 53,105,"Start Time"
	SetDrawEnv fstyle= 1
	DrawText 178,142,"-"
	SetDrawEnv fstyle= 1
	DrawText 230,142,"-"
	SetDrawEnv fstyle= 1
	DrawText 346,143,":"
	SetDrawEnv fstyle= 1
	DrawText 393,143,":"
	DrawText 53,143,"Stop Time"
	SetDrawEnv fstyle= 2
	DrawText 306,86,"Hour"
	SetDrawEnv fstyle= 2
	DrawText 348,85,"Minute"
	SetDrawEnv fstyle= 2
	DrawText 393,85,"Second"
	SetDrawEnv fstyle= 2
	DrawText 124,85,"Year"
	SetDrawEnv fstyle= 2
	DrawText 184,85,"Month"
	SetDrawEnv fstyle= 2
	DrawText 240,85,"Day"
	SetVariable ProjName,pos={53,23},size={328,20},title="Project Name"
	SetVariable ProjName,value= root:ProjectInfo:gui_PIE:proj_name,bodyWidth= 250
	SetVariable start_yr,pos={115,88},size={60,20},title=" ",format="%04g"
	SetVariable start_yr,limits={1988,2020,1},value= root:ProjectInfo:gui_PIE:start_year,bodyWidth= 60
	SetVariable start_mo,pos={185,88},size={40,20},title=" ",format="%02d"
	SetVariable start_mo,limits={1,12,1},value= root:ProjectInfo:gui_PIE:start_month,noedit= 1,bodyWidth= 40
	SetVariable start_day,pos={236,88},size={40,20},title=" ",format="%02d"
	SetVariable start_day,limits={1,31,1},value= root:ProjectInfo:gui_PIE:start_day,noedit= 1,bodyWidth= 40
	SetVariable start_hr,pos={304,88},size={40,20},title=" ",format="%02d"
	SetVariable start_hr,limits={0,23,1},value= root:ProjectInfo:gui_PIE:start_hour,noedit= 1,bodyWidth= 40
	SetVariable start_min,pos={350,88},size={40,20},title=" ",format="%02d"
	SetVariable start_min,limits={0,59,1},value= root:ProjectInfo:gui_PIE:start_minute,noedit= 1,bodyWidth= 40
	SetVariable start_sec,pos={397,88},size={40,20},title=" ",format="%02d"
	SetVariable start_sec,limits={0,59,1},value= root:ProjectInfo:gui_PIE:start_second,noedit= 1,bodyWidth= 40
	SetVariable stop_yr,pos={115,126},size={60,20},title=" ",format="%04g"
	SetVariable stop_yr,limits={1988,2020,1},value= root:ProjectInfo:gui_PIE:stop_year,bodyWidth= 60
	SetVariable stop_mo,pos={185,126},size={40,20},title=" ",format="%02d"
	SetVariable stop_mo,limits={1,12,1},value= root:ProjectInfo:gui_PIE:stop_month,noedit= 1,bodyWidth= 40
	SetVariable stop_day,pos={236,126},size={40,20},title=" ",format="%02d"
	SetVariable stop_day,limits={1,31,1},value= root:ProjectInfo:gui_PIE:stop_day,noedit= 1,bodyWidth= 40
	SetVariable stop_hr,pos={304,126},size={40,20},title=" ",format="%02d"
	SetVariable stop_hr,limits={0,23,1},value= root:ProjectInfo:gui_PIE:stop_hour,noedit= 1,bodyWidth= 40
	SetVariable stop_min,pos={350,126},size={40,20},title=" ",format="%02d"
	SetVariable stop_min,limits={0,59,1},value= root:ProjectInfo:gui_PIE:stop_minute,noedit= 1,bodyWidth= 40
	SetVariable stop_sec,pos={397,126},size={40,20},title=" ",format="%02d"
	SetVariable stop_sec,limits={0,59,1},value= root:ProjectInfo:gui_PIE:stop_second,noedit= 1,bodyWidth= 40
	Button entry_save_button,pos={279,177},size={50,20},proc=ProjInfo_Entry_ButtonProc,title="Save"
	Button entry_cancel_button,pos={163,177},size={50,20},proc=ProjInfo_Entry_ButtonProc,title="Cancel"
EndMacro

Function acg_ProjInfoDB_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			print ba.ctrlName
			if (cmpstr(ba.ctrlName,"add_entry_button")==0)
				acg_set_PIE_data(ProjectInfo_empty_string)
				Execute "acg_ProjInfo_entry_panel()"
				PauseForUser acg_ProjInfo_entry_panel
			elseif (cmpstr(ba.ctrlName,"Edit")==0)
				// get info for selected project
				// set gui entry data
			elseif (cmpstr(ba.ctrlName,"Delete")==0)
				// popup "are you sure?"
				// remove selected project
			endif
			break
	endswitch

	return 0
End

Window acg_ProjInfoDB_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(1019,77,1318,335)
	ListBox name_list,pos={40,38},size={150,155}
	ListBox name_list,listWave=root:ProjectInfo:ProjectInfoDB:proj_name_w
	ListBox name_list,selWave=root:ProjectInfo:ProjectInfoDB:sel_name_w,mode= 2
	ListBox name_list,selRow= 0
	Button Close_button,pos={92,208},size={50,20},title="Close"
	Button add_entry_button,pos={207,66},size={50,20},proc=acg_ProjInfoDB_ButtonProc,title="Add"
	Button edit_sel_button,pos={207,100},size={50,20},title="Edit"
	Button delete_sel_button,pos={207,136},size={50,20},title="Delete"
EndMacro

Window acg_ProjInfo_Controller() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(261,296,670,472) as "Project Info Controller"
	SetDrawLayer UserBack
	SetDrawEnv fsize= 16,fstyle= 4
	DrawText 55,40,"Current Project Information"
	TitleBox title0,pos={55,46},size={122,67},labelBack=(65535,65535,65535),frame=0
	TitleBox title0,variable= root:ProjectInfo:gui_PIC:PIC_info_string
	Button acg_pic_edit_local_button,pos={297,58},size={100,20},proc=acg_PIC_Edit_ButtonProc,title="Change (local)"
	Button acg_pic_edit_db_button,pos={297,85},size={100,20},proc=acg_PIC_Edit_ButtonProc,title="Change (via DB)"
	Button acg_pic_clear_button,pos={55,130},size={55,20},proc=acg_PIC_Ctrl_ButtonProc,title="Clear"
	Button acg_pic_cancel_button,pos={119,130},size={55,20},proc=acg_PIC_Ctrl_ButtonProc,title="Cancel"
	Button acg_pic_save_button,pos={183,130},size={55,20},proc=acg_PIC_Ctrl_ButtonProc,title="Save"
EndMacro

Function acg_PIC_Ctrl_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			//string sdf = getdatafolder(1)
			//setdatafolder ProjectInfo_folder
			//setdatafolder :gui_PIC
			acg_goto_ProjectInfo()
			//NVAR saved = proj_info_entry_saved
			//saved = 0
			variable close_window = 0

			if (cmpstr(ba.ctrlName,"acg_pic_clear_button")==0)
				// are you sure...will remove ProjectInfo
				NVAR isSet = this_project_is_set
				isSet = 0
				acg_update_PIC_gui_data()

			elseif (cmpstr(ba.ctrlName,"acg_pic_cancel_button")==0)

				close_window = 1
			elseif (cmpstr(ba.ctrlName,"acg_pic_save_button")==0)
				// save data to main folder
				close_window = 1
			endif

			if (close_window)
				killwindow acg_ProjInfo_Controller
				setdatafolder ::
				//killdatafolder/Z :gui_PIC
			endif

			//setdatafolder sdf
			break
	endswitch

	return 0
End

Function acg_PIC_Edit_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			if (cmpstr(ba.ctrlName,"acg_pic_edit_local_button")==0)
				acg_edit_current_ProjectInfo()

			elseif (cmpstr(ba.ctrlName,"acg_pic_edit_db_button")==0)

			endif

			break
	endswitch

	return 0
End

Function acg_project_is_set()
	string sdf = acg_goto_ProjectInfo()
	NVAR isSet = this_project_is_set
	setdatafolder sdf
	return isSet
End

Function/S acg_get_project_info()
	string sdf = acg_goto_ProjectInfo()
	SVAR info = this_project_info
	setdatafolder sdf
	return info
End

Function/S acg_get_project_name()
	string info = acg_get_project_info()
	return StringByKey("NAME",info)
End

Function acg_get_project_start_dt()
	string info = acg_get_project_info()
	return NumberByKey("START_DT",info)
End

Function acg_get_project_stop_dt()
	string info = acg_get_project_info()
	return NumberByKey("STOP_DT",info)
End

Window test_wsw_panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(433,90,977,469)
	ShowTools/A
	ListBox wlist,pos={93,46},size={317,245}
	Button print_sel_button,pos={420,46},size={100,20},proc=PrintSelectedProc,title="Print Selected"
EndMacro


Function display_file_selector()

	if (WinType("acg_file_selector") == 7)
		DoWindow/F acg_file_selector
	else

		PauseUpdate; Silent 1		// building window...
		NewPanel/N=acg_file_selector/W=(327,107,734,448) as "ACG File Sector"
		SetDrawLayer UserBack
		SetDrawEnv fsize= 14
		DrawText 45,35,"Select wave(s):"
		Button cancel_button,pos={109,306},size={50,20},title="Cancel"
		Button done_button,pos={242,306},size={50,20},title="Done"


		ListBox wlist,pos={48,46},size={317,245}

		MakeListIntoWaveSelector("acg_file_selector","wlist")
	endif

End

Function PrintSelectedProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//wave selwave = root:Packages:WM_WaveSelectorList:WaveSelectorInfo0:SelWave
			print WS_SelectedObjectsList("acg_file_selector","wlist")

			break
	endswitch

	return 0
End


Window acg_file_selector() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(327,107,734,448) as "ACG File Sector"
	ShowTools/A
	SetDrawLayer UserBack
	SetDrawEnv fsize= 14
	DrawText 45,35,"Select wave(s):"
	Button cancel_button,pos={109,306},size={50,20},title="Cancel"
	Button done_button,pos={242,306},size={50,20},title="Done"
	ListBox wlist,pos={48,46},size={317,245},proc=WaveSelectorListProc
	ListBox wlist,userdata(WaveSelectorInfo)= A"!!*'#=(-8`;e9cV@ruX08T&-Y0E;(Qzzz9PJQi=(-8`zzzzzz;e9cH@<Q2^zzzzzz"
	ListBox wlist,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox wlist,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox wlist,userdata(WaveSelectorInfo) += A".KBGKzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox wlist,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz!!!"
	ListBox wlist,listWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo0:ListWave
	ListBox wlist,selWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo0:SelWave
	ListBox wlist,mode= 10,editStyle= 1,widths={20,500},keySelectCol= 1
	SetWindow kwTopWin,hook(WaveSelectorWidgetHook)=WMWS_WinHook
EndMacro

Window acg_time_base_manager() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(70,76,777,841) as "ACG Time Base Manager"
	ShowTools/A
	SetDrawLayer UserBack
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 34,94,"Select start datetime wave..."
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 374,94,"Select data wave(s)..."
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 34,281,"Select stop datetime wave..."
	SetDrawEnv fillpat= 4,fillfgc= (39168,39168,39168)
	DrawRect 35,283,339,396
	SetDrawEnv fsize= 18,fstyle= 2
	DrawText 206,35,"ACG Time Base Manager"
	GroupBox wave_sel_group,pos={16,37},size={679,383},title="Wave Selection"
	GroupBox wave_sel_group,font="Tahoma",fSize=14
	ListBox dt_wave_sel,pos={33,96},size={306,160},mode= 1,selRow= -1
	ListBox data_wave_sel,pos={373,96},size={305,301},mode= 4
	GroupBox input_group,pos={17,429},size={322,257},title="Input information"
	GroupBox output_group,pos={374,428},size={320,258},title="Output options (choose one)"
	CheckBox input_common_tb_check,pos={32,464},size={123,16},title="Common time base"
	CheckBox input_common_tb_check,variable= root:Packages:acg:TBM:input_common_tb_cb
	SetVariable input_common_tb_val,pos={179,462},size={139,20},title="timebase (sec):"
	SetVariable input_common_tb_val,limits={1,3600,1},value= root:Packages:acg:TBM:input_tb_val,bodyWidth= 50
	CheckBox output_common_tb_check,pos={391,464},size={123,16},proc=acg_toggle_tbm_out_opt,title="Common time base"
	CheckBox output_common_tb_check,variable= root:Packages:acg:TBM:output_common_tb_cb
	SetVariable output_common_tb_val,pos={538,462},size={139,20},title="timebase (sec):"
	SetVariable output_common_tb_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_tb_val,bodyWidth= 50
	CheckBox output_avg_check,pos={391,492},size={63,16},proc=acg_toggle_tbm_out_opt,title="Average"
	CheckBox output_avg_check,variable= root:Packages:acg:TBM:output_avg_cb
	SetVariable output_avg_val,pos={528,490},size={149,20},title="Avg period (sec):"
	SetVariable output_avg_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_avg_val,bodyWidth= 50
	CheckBox input_start_stop_dt_check,pos={32,516},size={177,16},title="Use start and stop datetimes"
	CheckBox input_start_stop_dt_check,variable= root:Packages:acg:TBM:input_use_start_stop_cb
	ListBox dt_stop_wave_sel,pos={34,283},size={305,113},mode= 1,selRow= -1
	CheckBox output_expand_check,pos={391,520},size={58,16},proc=acg_toggle_tbm_out_opt,title="Expand"
	CheckBox output_expand_check,variable= root:Packages:acg:TBM:output_expand_cb
	SetVariable output_expand_val,pos={509,518},size={168,20},title="Expand period (sec):"
	SetVariable output_expand_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_expand_val,bodyWidth= 50
	CheckBox output_project_info_check,pos={391,590},size={107,16},proc=acg_toggle_tbm_out_opt,title="Use Project Info"
	CheckBox output_project_info_check,variable= root:Packages:acg:TBM:output_proj_info_cb
	Button done_button,pos={615,705},size={75,20},proc=acg_TBM_ButtonProc,title="Done"
	Button reset_button,pos={529,705},size={75,20},proc=acg_TBM_ButtonProc,title="Reset"
	CheckBox expand_stair_radio,pos={422,546},size={70,16},title="Stair-step"
	CheckBox expand_stair_radio,value= 1,mode=1
	CheckBox expand_avg_radio,pos={422,565},size={63,16},disable=2,title="Average"
	CheckBox expand_avg_radio,value= 0,mode=1
	Button do_it_button,pos={324,705},size={75,20},proc=acg_TBM_ButtonProc,title="Do it"
	CheckBox output_avg_check1,pos={423,614},size={63,16},disable=2,title="Average"
	CheckBox output_avg_check1,value= 0
	SetVariable output_proj_avg_val,pos={528,612},size={149,20},disable=2,title="Avg period (sec):"
	SetVariable output_proj_avg_val,limits={1,3600,1},value= V_Flag,bodyWidth= 50
	SetVariable out_folder,pos={394,654},size={242,20},disable=2,title="output folder"
	SetVariable out_folder,limits={-inf,inf,0},value= root:Packages:acg:TBM:input_use_wavenotes_cb
	Button out_folder_sel_button,pos={644,654},size={30,19},title="..."
	CheckBox input_use_wavenotes,pos={66,490},size={160,16},title="Use wavenotes if available"
	CheckBox input_use_wavenotes,variable= root:Packages:acg:TBM:input_use_wavenotes_cb
EndMacro


// outline and notes

// if output box is checked
//	output folder will be created in base folder and kept
// else
//	next step will be done using tmp waves which will be discarded

// if input is not on a common time base
//	output needs at least a timebase to use for tmp calcs

// src wave will contain wavenotes that contains:
//	what has been calculated (average_<tb>, common_tb_<tb>, etc)
// 	CRC (checksum of sorts) which will also be included in the dest wave's info to see if new calcs are necessary

// feature request: output option to designate where waves end up

Function acg_display_TBM()

	if (WinType("acg_time_base_manager") == 7)
		DoWindow/F acg_time_base_manager
	else

	string sdf = acg_goto_TBM()
	setdatafolder sdf

	PauseUpdate; Silent 1		// building window...
	NewPanel/N=acg_time_base_manager/W=(70,76,777,681) as "ACG Time Base Manager"
	SetDrawLayer UserBack
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 34,94,"Select start datetime wave..."
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 374,94,"Select data wave(s)..."
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 34,281,"Select stop datetime wave..."
	SetDrawEnv fillpat= 4,fillfgc= (39168,39168,39168)
	//DrawRect 35,283,339,396
	SetDrawEnv fsize= 18,fstyle= 2
	DrawText 206,35,"ACG Time Base Manager"
	GroupBox wave_sel_group,pos={16,37},size={679,323},title="Wave Selection"
	GroupBox wave_sel_group,font="Tahoma",fSize=14
	ListBox dt_wave_sel,pos={33,96},size={306,133},mode= 1,selRow= -1
	ListBox data_wave_sel,pos={373,96},size={305,251},mode= 4
	GroupBox input_group,pos={17,375},size={322,188},title="Input information"
	GroupBox output_group,pos={374,374},size={320,189},title="Output options (choose one)"
	CheckBox input_common_tb_check,pos={32,410},size={123,16},title="Common time base"
	CheckBox input_common_tb_check,variable= root:Packages:acg:TBM:input_common_tb_cb
	SetVariable input_common_tb_val,pos={179,408},size={139,20},title="timebase (sec):"
	SetVariable input_common_tb_val,limits={1,3600,1},value= root:Packages:acg:TBM:input_tb_val,bodyWidth= 50
	CheckBox output_common_tb_check,pos={391,410},size={123,16},proc=acg_toggle_tbm_out_opt,title="Common time base"
	CheckBox output_common_tb_check,variable= root:Packages:acg:TBM:output_common_tb_cb
	SetVariable output_common_tb_val,pos={538,408},size={139,20},title="timebase (sec):"
	SetVariable output_common_tb_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_tb_val,bodyWidth= 50
	CheckBox output_avg_check,pos={391,438},size={63,16},proc=acg_toggle_tbm_out_opt,title="Average"
	CheckBox output_avg_check,variable= root:Packages:acg:TBM:output_avg_cb
	SetVariable output_avg_val,pos={528,436},size={149,20},title="Avg period (sec):"
	SetVariable output_avg_val,limits={1,36000,1},value= root:Packages:acg:TBM:output_avg_val,bodyWidth= 50
	CheckBox input_start_stop_dt_check,pos={32,462},size={177,16},disable=2,title="Use start and stop datetimes"
	CheckBox input_start_stop_dt_check,variable= root:Packages:acg:TBM:input_use_start_stop_cb
	ListBox dt_stop_wave_sel,pos={34,252},size={305,113},mode= 1,selRow= -1
	CheckBox output_expand_check,pos={391,466},size={58,16},disable=2,proc=acg_toggle_tbm_out_opt,title="Expand"
	CheckBox output_expand_check,variable= root:Packages:acg:TBM:output_expand_cb
	SetVariable output_expand_val,pos={509,464},size={168,20},disable=2,title="Expand period (sec):"
	SetVariable output_expand_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_expand_val,bodyWidth= 50
	CheckBox output_project_info_check,pos={391,536},size={107,16},proc=acg_toggle_tbm_out_opt,title="Use Project Info"
	CheckBox output_project_info_check,variable= root:Packages:acg:TBM:output_proj_info_cb
	Button done_button,pos={615,574},size={75,20},proc=acg_TBM_ButtonProc,title="Done"
	Button reset_button,pos={529,574},size={75,20},proc=acg_TBM_ButtonProc,title="Reset"
	CheckBox expand_stair_radio,pos={422,492},size={70,16},disable=2,title="Stair-step"
	CheckBox expand_stair_radio,value= 1,mode=1
	CheckBox expand_avg_radio,pos={422,511},size={63,16},disable=2,title="Average"
	CheckBox expand_avg_radio,value= 0,mode=1
	Button do_it_button,pos={324,574},size={75,20},proc=acg_TBM_ButtonProc,title="Do it"
//	CheckBox output_avg_check1,pos={423,614},size={63,16},disable=2,title="Average"
//	CheckBox output_avg_check1,value= 0
//	SetVariable output_proj_avg_val,pos={528,612},size={149,20},disable=2,title="Avg period (sec):"
//	SetVariable output_proj_avg_val,limits={1,3600,1},value= V_Flag,bodyWidth= 50
//	SetVariable out_folder,pos={394,654},size={242,20},disable=2,title="output folder"
//	SetVariable out_folder,limits={-inf,inf,0},value= root:
//	Button out_folder_sel_button,pos={644,654},size={30,19},title="..."
	CheckBox input_use_wavenotes,pos={66,436},size={160,16},title="Use wavenotes if available"
	CheckBox input_use_wavenotes,variable= root:Packages:acg:TBM:input_use_wavenotes_cb


	MakeListIntoWaveSelector("acg_time_base_manager","dt_wave_sel",selectionMode=WMWS_SelectionSingle)
	MakeListIntoWaveSelector("acg_time_base_manager","dt_stop_wave_sel",selectionMode=WMWS_SelectionSingle)
	MakeListIntoWaveSelector("acg_time_base_manager","data_wave_sel")

	endif

End

Window acg_time_base_manager_8May2009() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /W=(70,76,777,681) as "ACG Time Base Manager"
	ShowTools/A
	SetDrawLayer UserBack
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 34,94,"Select start datetime wave..."
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 374,94,"Select data wave(s)..."
	SetDrawEnv fname= "Tahoma",fsize= 14,fstyle= 1
	DrawText 34,281,"Select stop datetime wave..."
	SetDrawEnv fsize= 18,fstyle= 2
	DrawText 206,35,"ACG Time Base Manager"
	GroupBox wave_sel_group,pos={16,37},size={678,323},title="Wave Selection"
	GroupBox wave_sel_group,font="Tahoma",fSize=14
	ListBox dt_wave_sel,pos={33,96},size={306,133},proc=WaveSelectorListProc
	ListBox dt_wave_sel,userdata(WaveSelectorInfo)= A"!!*'#=(-8`;e9cV@ruX08T&-Y0E;(Qzzz9PJQi=(-8`zzzzzz;e9cH@<Q2^zzzzzz"
	ListBox dt_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox dt_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox dt_wave_sel,userdata(WaveSelectorInfo) += A".KBGKzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox dt_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz!!!"
	ListBox dt_wave_sel,listWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo0:ListWave
	ListBox dt_wave_sel,selWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo0:SelWave
	ListBox dt_wave_sel,mode= 6,editStyle= 1,widths={20,500},keySelectCol= 1
	ListBox data_wave_sel,pos={375,95},size={305,251},proc=WaveSelectorListProc
	ListBox data_wave_sel,userdata(WaveSelectorInfo)= A"!!*'#=(-8`;e9cV@ruX08T&-Y1&q:Szzz9PJQi=(-8`zzzzzz;e9cH@<Q2^zzzzzz"
	ListBox data_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox data_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox data_wave_sel,userdata(WaveSelectorInfo) += A".KBGKzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox data_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz!!!"
	ListBox data_wave_sel,listWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo2:ListWave
	ListBox data_wave_sel,selWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo2:SelWave
	ListBox data_wave_sel,mode= 10,editStyle= 1,widths={20,500},keySelectCol= 1
	GroupBox input_group,pos={17,375},size={322,188},title="Input information"
	GroupBox output_group,pos={372,374},size={320,189},title="Output options (choose one)"
	CheckBox input_common_tb_check,pos={32,410},size={123,16},title="Common time base"
	CheckBox input_common_tb_check,variable= root:Packages:acg:TBM:input_common_tb_cb
	SetVariable input_common_tb_val,pos={179,408},size={139,20},bodyWidth=50,title="timebase (sec):"
	SetVariable input_common_tb_val,limits={1,3600,1},value= root:Packages:acg:TBM:input_tb_val
	CheckBox output_common_tb_check,pos={391,410},size={123,16},proc=acg_toggle_tbm_out_opt,title="Common time base"
	CheckBox output_common_tb_check,variable= root:Packages:acg:TBM:output_common_tb_cb
	SetVariable output_common_tb_val,pos={538,408},size={139,20},bodyWidth=50,title="timebase (sec):"
	SetVariable output_common_tb_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_tb_val
	CheckBox output_avg_check,pos={391,438},size={63,16},proc=acg_toggle_tbm_out_opt,title="Average"
	CheckBox output_avg_check,variable= root:Packages:acg:TBM:output_avg_cb
	SetVariable output_avg_val,pos={528,436},size={149,20},bodyWidth=50,title="Avg period (sec):"
	SetVariable output_avg_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_avg_val
	CheckBox input_start_stop_dt_check,pos={32,462},size={177,16},disable=2,title="Use start and stop datetimes"
	CheckBox input_start_stop_dt_check,variable= root:Packages:acg:TBM:input_use_start_stop_cb
	ListBox dt_stop_wave_sel,pos={34,252},size={305,94},proc=WaveSelectorListProc
	ListBox dt_stop_wave_sel,userdata(WaveSelectorInfo)= A"!!*'#=(-8`;e9cV@ruX08T&-Y0`V1Rzzz9PJQi=(-8`zzzzzz;e9cH@<Q2^zzzzzz"
	ListBox dt_stop_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox dt_stop_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox dt_stop_wave_sel,userdata(WaveSelectorInfo) += A".KBGKzzzzzzzzzzzzzzzzzzzzzzzz"
	ListBox dt_stop_wave_sel,userdata(WaveSelectorInfo) += A"zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz!!!"
	ListBox dt_stop_wave_sel,listWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo1:ListWave
	ListBox dt_stop_wave_sel,selWave=root:Packages:WM_WaveSelectorList:WaveSelectorInfo1:SelWave
	ListBox dt_stop_wave_sel,mode= 6,editStyle= 1,widths={20,500},keySelectCol= 1
	CheckBox output_expand_check,pos={391,466},size={58,16},disable=2,proc=acg_toggle_tbm_out_opt,title="Expand"
	CheckBox output_expand_check,variable= root:Packages:acg:TBM:output_expand_cb
	SetVariable output_expand_val,pos={509,464},size={168,20},bodyWidth=50,disable=2,title="Expand period (sec):"
	SetVariable output_expand_val,limits={1,3600,1},value= root:Packages:acg:TBM:output_expand_val
	CheckBox output_project_info_check,pos={391,536},size={107,16},proc=acg_toggle_tbm_out_opt,title="Use Project Info"
	CheckBox output_project_info_check,variable= root:Packages:acg:TBM:output_proj_info_cb
	Button done_button,pos={615,574},size={75,20},proc=acg_TBM_ButtonProc,title="Done"
	Button reset_button,pos={529,574},size={75,20},proc=acg_TBM_ButtonProc,title="Reset"
	CheckBox expand_stair_radio,pos={422,492},size={70,16},disable=2,title="Stair-step"
	CheckBox expand_stair_radio,value= 1,mode=1
	CheckBox expand_avg_radio,pos={422,511},size={63,16},disable=2,title="Average"
	CheckBox expand_avg_radio,value= 0,mode=1
	Button do_it_button,pos={324,574},size={75,20},proc=acg_TBM_ButtonProc,title="Do it"
	CheckBox input_use_wavenotes,pos={66,436},size={160,16},title="Use wavenotes if available"
	CheckBox input_use_wavenotes,variable= root:Packages:acg:TBM:input_use_wavenotes_cb
	SetWindow kwTopWin,hook(WaveSelectorWidgetHook)=WMWS_WinHook
EndMacro


Function acg_TBM_ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	string sdf

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

			if (cmpstr(ba.ctrlName,"done_button")==0)

				killwindow acg_time_base_manager

			elseif (cmpstr(ba.ctrlName,"reset_button")==0)
				sdf = acg_goto_acg_packages()
				acg_init_TBM()
				// clear dt selector
				WS_ClearSelection("acg_time_base_manager", "dt_wave_sel")
				// clear dt_stop selector
				WS_ClearSelection("acg_time_base_manager", "dt_stop_wave_sel")
				// clear data selector
				WS_ClearSelection("acg_time_base_manager", "data_wave_sel")

				setdatafolder sdf

			elseif (cmpstr(ba.ctrlName,"do_it_button")==0)

				sdf = acg_goto_TBM()

				string/G dt_wave = WS_SelectedObjectsList("acg_time_base_manager", "dt_wave_sel")
				NVAR use_stop = input_use_start_stop_cb
				if (use_stop)
					string/G dt_stop_wave = WS_SelectedObjectsList("acg_time_base_manager", "dt_stop_wave_sel")
				endif
				string/G data_waves = WS_SelectedObjectsList("acg_time_base_manager", "data_wave_sel")

				acg_TBM_run()

				setdatafolder sdf
//			elseif (cmpstr(ba.ctrlName,"acg_pic_cancel_button")==0)
//
//				close_window = 1
//			elseif (cmpstr(ba.ctrlName,"acg_pic_save_button")==0)
//				// save data to main folder
//				close_window = 1
			endif

//			if (close_window)
//				killwindow acg_ProjInfo_Controller
//				setdatafolder ::
//				//killdatafolder/Z :gui_PIC
//			endif

			//setdatafolder sdf
			break
	endswitch

	return 0
End

Function acg_TBM_run()

	string sdf = acg_goto_TBM()

	NVAR tb = output_common_tb_cb
	NVAR avg = output_avg_cb
	NVAR expand =  output_expand_cb
	NVAR proj_info  = output_proj_info_cb

	NVAR input_tb = input_common_tb_cb
	NVAR input_wn = input_use_wavenotes_cb
	NVAR input_start_stop = input_use_start_stop_cb

	SVAR dt_w = dt_wave
	NVAR use_stop = input_use_start_stop_cb
	if (use_stop)
		//string/G dt_stop_wave = WS_SelectedObjectsList("acg_time_base_manager", "dt_stop_wave_sel")
		SVAR dt_stop_w =  dt_stop_wave
	endif
	SVAR data_w = data_waves

	// check that start and stop times selected if box is checked
	if (input_start_stop && (itemsinlist(dt_w) == 0) )
		// display error message
		return 0
	elseif (input_start_stop && (itemsinlist(dt_stop_w) == 0) )
		// display error message
		return 0
	endif

	// try to use wavescaling for dt info if no dt wave is selected
	variable calc_dt = 0
	if (itemsinlist(dt_w) == 0 || input_wn)
		calc_dt = 1
	endif

	// Process output request //

	variable i,j,k

	if (tb) // put on common timebase


		NVAR out_tb_val = output_tb_val
		string dt_name = stringfromlist(0,dt_w)
		variable out_tb = out_tb_val

		for (i=0; i<itemsinlist(data_w); i+=1)

			string w_path = stringfromlist(i,data_w)
			variable last_colon = strsearch(w_path,":",Inf,1)
			if (last_colon < 0)
				// error msg
				continue
			endif
			string w_folder  = w_path[0,last_colon-1]
			string w_name = w_path[last_colon+1,strlen(w_path)-1]

			wave w = $w_path

			if ( strlen(dt_name) == 0)
				// skip and display message?
			else

				wave src_dt = $dt_name

				// make sure working tb folder exists
				newdatafolder/o/s $acg_tmp_timebase_folder
				if (datafolderexists("input"))
					killdatafolder/Z :input
				endif
				newdatafolder/o/s :input

				duplicate/o src_dt Start_DateTime
				duplicate/o w $w_name

				// set global var for existing function
				newdatafolder/o root:gui
				if (!waveexists(root:gui:last_timebase))
					variable/G root:gui:last_timebase = 0
				endif
				NVAR last_tb = root:gui:last_timebase
				last_tb = out_tb

				// run tb function
				acg_common_timebase_data(0)

				// duplicate results into proper tb_<>
				setdatafolder (w_folder+":")
				newdatafolder/o/s $("common_tb_" + num2str(out_tb))

				duplicate/o $(acg_tmp_timebase_folder  + ":common_tw") date_time
				duplicate/o $(acg_tmp_timebase_folder  + ":" + w_name + "_c") $w_name

				// set wavenotes on w_name
				wave w = $w_name
				string wnote = note(w)
				wnote = ReplaceNumberByKey(TBM_tb_tag,wnote,out_tb)
				Note/K w
				Note w, wnote


			endif

		endfor

		killdatafolder/Z $acg_tmp_timebase_folder
		// clean up tmp waves and folders
	elseif (avg) // Average selected waves

		NVAR in_tb_val = input_tb_val
		NVAR out_avg_val = output_avg_val
		dt_name = stringfromlist(0,dt_w)
		variable out_avg = out_avg_val
		variable in_tb = in_tb_val
		for (i=0; i<itemsinlist(data_w); i+=1)

			w_path = stringfromlist(i,data_w)
			last_colon = strsearch(w_path,":",Inf,1)
			if (last_colon < 0)
				// error msg
				continue
			endif
			w_folder  = w_path[0,last_colon-1]
			w_name = w_path[last_colon+1,strlen(w_path)-1]

			wave w = $w_path

			//NVAR input_tb_val = input_tb_val
			if (calc_dt)

				// check for wavenotes first
				wnote = note(w)
				variable wn_tb = NumberByKey(TBM_tb_tag,wnote)
				variable do_calc_dt = 0
				if (numtype(wn_tb)==0 && wn_tb>0)
					in_tb = wn_tb
					do_calc_dt = 1
				elseif (cmpstr("dat",waveunits(w,0))==0)
				 	variable tmp_tb = deltax(w)
				 	in_tb = tmp_tb
					do_calc_dt = 1
				endif

				if (do_calc_dt)
				 	variable tmp_start = leftx(w)
				 	make/D/o/n=(numpnts(w)) tmp_dt
				 	wave tmp_dt
				 	tmp_dt[0] = tmp_start
				 	tmp_dt[1,] = tmp_dt[p-1] + in_tb
				 	dt_name = "tmp_dt"
				endif
			endif

			if ( strlen(dt_name) == 0)
				// skip and display message?
				return 0
			else

				wave src_dt = $dt_name

				// make sure working tb folder exists
				newdatafolder/o/s $acg_tmp_dataload_folder
				if (datafolderexists("input"))
					killdatafolder/Z :input
				endif
				newdatafolder/o/s :input

				duplicate/o src_dt Start_DateTime
				duplicate/o w $w_name

				// set global var for existing function
				newdatafolder/o root:gui
				if (!waveexists(root:gui:last_avgtime))
					variable/G root:gui:last_avgtime = 0
				endif
				NVAR last_avg = root:gui:last_avgtime
				last_avg = out_avg

				// run avg function
				acg_average_loaded_data()

				// duplicate results into proper avg_<>
				setdatafolder (w_folder+":")
				newdatafolder/o/s $("avg_" + num2str(out_avg))

				duplicate/o $(acg_tmp_dataload_folder  + ":avg_tw") date_time
				duplicate/o $(acg_tmp_dataload_folder  + ":" + w_name + "_avg") $w_name

				// set wavenotes on w_name
				wave w = $w_name
				wnote = note(w)
				wnote = ReplaceNumberByKey(TBM_tb_tag,wnote,out_avg)
				wnote = ReplaceNumberByKey(TBM_avg_src_tb_tag,wnote,in_tb)
				Note/K w
				Note w, wnote


			endif

		endfor

		// clean up tmp waves and folders
		sdf = acg_goto_TBM()
		killwaves/Z tmp_dt
		killdatafolder/Z $acg_tmp_dataload_folder
		setdatafolder sdf

	elseif (expand) // Expand selected waves

		NVAR in_tb_val = input_tb_val
		NVAR out_expand_val = output_expand_val
		dt_name = stringfromlist(0,dt_w)
		variable out_expand = out_expand_val
		in_tb = in_tb_val
		for (i=0; i<itemsinlist(data_w); i+=1)

			w_path = stringfromlist(i,data_w)
			last_colon = strsearch(w_path,":",Inf,1)
			if (last_colon < 0)
				// error msg
				continue
			endif
			w_folder  = w_path[0,last_colon-1]
			w_name = w_path[last_colon+1,strlen(w_path)-1]

			wave w = $w_path

			//NVAR input_tb_val = input_tb_val
			if (calc_dt)

				// check for wavenotes first
				wnote = note(w)
				wn_tb = NumberByKey(TBM_tb_tag,wnote)
				do_calc_dt = 0
				if (numtype(wn_tb)==0 && wn_tb>0)
					in_tb = wn_tb
					do_calc_dt = 1
				elseif (cmpstr("dat",waveunits(w,0))==0)
				 	tmp_tb = deltax(w)
				 	in_tb = tmp_tb
					do_calc_dt = 1
				endif

				if (do_calc_dt)
				 	tmp_start = leftx(w)
				 	make/D/o/n=(numpnts(w)) tmp_dt
				 	wave tmp_dt
				 	tmp_dt[0] = tmp_start
				 	tmp_dt[1,] = tmp_dt[p-1] + in_tb
				 	dt_name = "tmp_dt"
				endif
			endif

			if ( strlen(dt_name) == 0)
				// skip and display message?
				return 0
			else

				wave src_dt = $dt_name

				variable startdt = src_dt[0]
				variable stopdt = src_dt[numpnts(src_dt)-1]
				acg_expand_wave_to_tb(startdt, stopdt, in_tb, out_expand, src_dt, w, "expand_dt", "expand_data", 0)
				wave exp_dt = $("expand_dt")
				wave exp_data = $("expand_data")

				// duplicate results into proper avg_<>
				setdatafolder (w_folder+":")
				newdatafolder/o/s $("expand_" + num2str(out_expand))

				duplicate/o exp_dt date_time
				duplicate/o exp_data $w_name

				// set wavenotes on w_name
				wave w = $w_name
				wnote = note(w)
				wnote = ReplaceNumberByKey(TBM_tb_tag,wnote,out_expand)
				wnote = ReplaceNumberByKey(TBM_expand_src_tb_tag,wnote,in_tb)
				Note/K w
				Note w, wnote


			endif

		endfor

		// clean up tmp waves and folders
		sdf = acg_goto_TBM()
		killwaves/Z tmp_dt, expand_dt, expand_data
		setdatafolder sdf

	elseif (proj_info) // Put on project times

		if (!acg_project_is_set())
			// msg: define project first
			return 0
		endif


		NVAR out_tb_val = output_tb_val
		dt_name = stringfromlist(0,dt_w)
		out_tb = out_tb_val

		for (i=0; i<itemsinlist(data_w); i+=1)

			w_path = stringfromlist(i,data_w)
			last_colon = strsearch(w_path,":",Inf,1)
			if (last_colon < 0)
				// error msg
				continue
			endif
			w_folder  = w_path[0,last_colon-1]
			w_name = w_path[last_colon+1,strlen(w_path)-1]

			wave w = $w_path

			//NVAR input_tb_val = input_tb_val
			if (calc_dt)

				// check for wavenotes first
				wnote = note(w)
				wn_tb = NumberByKey(TBM_tb_tag,wnote)
				do_calc_dt = 0
				if (numtype(wn_tb)==0 && wn_tb>0)
					out_tb = wn_tb
					do_calc_dt = 1
				elseif (cmpstr("dat",waveunits(w,0))==0)
				 	tmp_tb = deltax(w)
				 	out_tb = tmp_tb
					do_calc_dt = 1
				endif

				if (do_calc_dt)
				 	tmp_start = leftx(w)
				 	make/D/o/n=(numpnts(w)) tmp_dt
				 	wave tmp_dt
				 	tmp_dt[0] = tmp_start
				 	tmp_dt[1,] = tmp_dt[p-1] + out_tb
				 	dt_name = "tmp_dt"
				endif
			endif

			if ( strlen(dt_name) == 0)
				// skip and display message?
				return 0
			else

				wave src_dt = $dt_name


				// create project datetime wave
				variable pstart = acg_get_project_start_dt()
				variable pstop = acg_get_project_stop_dt()
//				variable pcnt = ((pstop - pstart)/out_tb) + 1
				variable pcnt = ((pstop - pstart)/out_tb)  // don't add one in order to have last sample period stop at stoptime
				make/D/O/n=(pcnt) proj_dt
				wave proj_dt
				proj_dt[0] = pstart
				proj_dt[1,] = proj_dt[p-1] + out_tb

				// create new wave
				duplicate/o proj_dt pdata
				wave pdat  = pdata
				pdat = NaN
				SetScale/P x proj_dt[0],out_tb,"dat", pdat


				// find first index
				variable first_index = -1
				variable last_index = -1
				j=-1
				do
					j+=1
					first_index = BinarySearch(proj_dt,src_dt[j])
					//print j, src_dt[j] - leftx(pdat)
				while (first_index < 0 && j<numpnts(src_dt))

				k=numpnts(src_dt)
				do
					k-=1
					last_index = BinarySearch(proj_dt,src_dt[k])
				while (last_index < 0 && k>=0)

				if (first_index<0 && last_index<0) // no matching points
					continue
				endif

				variable match_cnt = k-j
				pdat[first_index, first_index+match_cnt] = w[p - first_index + j]

				// duplicate results into proper tb_<>
				setdatafolder (w_folder+":")
				newdatafolder/o/s $("project_tb_" + num2str(out_tb))

				duplicate/o proj_dt date_time
				duplicate/o pdat $w_name

				// set wavenotes on w_name
				wave w = $w_name
				wnote = note(w)
				wnote = ReplaceNumberByKey(TBM_tb_tag,wnote,out_tb)
				wnote = ReplaceStringByKey(TBM_proj_tag,wnote,acg_get_project_name())
				Note/K w
				Note w, wnote


			endif

		endfor

		// clean up tmp waves and folders
		sdf = acg_goto_TBM()
		killwaves/Z pdata, proj_dt, tmp_dt
		setdatafolder sdf
		// killdatafolder/Z $acg_tmp_timebase_folder

	endif

End

Function acg_init_acg_packages()

	// nothing here for now but creating acg folder
	newdatafolder/o :acg
End

Function/S acg_goto_acg_packages()

	string sdf = getdatafolder(1)

	setdatafolder root:
	newdatafolder/o/s :Packages

	if (!datafolderexists("acg"))
		acg_init_acg_packages()
	endif
	setdatafolder :acg

	return sdf
End

Function acg_init_TBM()

	newdatafolder/o/s :TBM

	// check boxes
	variable/G input_common_tb_cb = 0
	variable/G input_use_wavenotes_cb = 1
	variable/G input_use_start_stop_cb = 0
	variable/G output_common_tb_cb = 0
	variable/G output_avg_cb = 0
	variable/G output_expand_cb = 0
	variable/G output_proj_info_cb = 0

	// value fields
	variable/G input_tb_val = 1
	variable/G output_tb_val = 1
	variable/G output_avg_val = 60
	variable/G output_expand_val = 60

	setdatafolder ::

End

Function/S acg_goto_TBM()

	string sdf = acg_goto_acg_packages()

	if (!datafolderexists("TBM"))
		acg_init_TBM()
	endif

	setdatafolder :TBM

	return sdf
End

Function acg_toggle_tbm_out_opt(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked

			string sdf = acg_goto_TBM()

			NVAR tb = output_common_tb_cb
			NVAR avg = output_avg_cb
			NVAR expand =  output_expand_cb
			NVAR proj_info  = output_proj_info_cb

			if (cmpstr(cba.ctrlName,"output_common_tb_check")==0)
				avg = 0
				expand = 0
				proj_info = 0
			elseif (cmpstr(cba.ctrlName,"output_avg_check")==0)
				tb = 0
				expand = 0
				proj_info = 0
			elseif (cmpstr(cba.ctrlName,"output_expand_check")==0)
				tb = 0
				avg = 0
				proj_info = 0
			elseif (cmpstr(cba.ctrlName,"output_project_info_check")==0)
				tb = 0
				avg = 0
				expand = 0

			//elseif (cmpstr(cba.ctrlName,"output_common_tb_check")==0)
			endif

			setdatafolder sdf

			break
	endswitch

	return 0
End

Function acg_wind_rose_by_time(tw,start_dt, stop_dt, wDir, wParam, angleBinWidth, calmSpeedBin, speedBinWidth, maxSpeed)
	wave tw                    // datetime wave
	variable start_dt      // start datetime
	variable stop_dt      // stop datetime
	Wave wDir			// wind direction in degrees
	Wave wParam		// parameter of choice
	Variable angleBinWidth	// in degrees, use 90 to get 4 bins
	Variable calmSpeedBin	// speeds less than this are considered direction-less and are combined into a circle at the origin.
	Variable speedBinWidth	// each bin contains this much speed range (except the last)
	Variable maxSpeed		// last speed bin contains this value + all that exceed this value.

//	variable start_i = BinarySearch(tw,start_dt)
	variable start_i = -1
	variable i
	if (start_dt < tw[0] || start_dt > tw[numpnts(tw)-1])
		print "Start Time not in datetime wave"
		return 1
	else
		for (i=0; i<numpnts(tw); i+=1)
			if (tw[i] <= start_dt)
				start_i = i
			else
				break
			endif
		endfor
	endif
//	if (start_i < 0)
//		print "Start Time not in datetime wave"
//		return 1
//	endif
	//variable stop_i = BinarySearch(tw,start_dt)
	variable stop_i = -1
	if (stop_dt < tw[0] || stop_dt > tw[numpnts(tw)-1])
		print "Stop Time not in datetime wave"
		return 1
	else
		for (i=0; i<numpnts(tw); i+=1)
			if (tw[i] <= stop_dt)
				stop_i = i
			else
				break
			endif
		endfor
	endif
//	if (stop_i < 0)
//		print "Stop Time not in datetime wave"
//		return 1
//	endif

	acg_wind_rose_by_index(start_i, stop_i, wDir, wParam, angleBinWidth, calmSpeedBin, speedBinWidth, maxSpeed)

End


Function acg_wind_rose_by_index(start_i, stop_i, wDir, wParam, angleBinWidth, calmSpeedBin, speedBinWidth, maxSpeed)
	variable start_i      // start index
	variable stop_i      // stop index
	Wave wDir			// wind direction in degrees
	Wave wParam		// parameter of choice
	Variable angleBinWidth	// in degrees, use 90 to get 4 bins
	Variable calmSpeedBin	// speeds less than this are considered direction-less and are combined into a circle at the origin.
	Variable speedBinWidth	// each bin contains this much speed range (except the last)
	Variable maxSpeed		// last speed bin contains this value + all that exceed this value.

	Variable radiusMax = 100	// 1 for probability/frequency, 100 for percent	...set this manually

	string sdf = getdatafolder(1)

	newdatafolder/o/s $acg_plots_folder
	newdatafolder/o/s $acg_rosePlot_folder

	variable wsize = stop_i - start_i + 1
	string wname = acg_get_next_plot_wave()
	if (cmpstr(wname, "") == 0)
		print "too many waves in plot folder...exiting"
		return 1
	endif
	make/o/n=(wsize) $wname
	wave param = $wname

	make/o/n=(wsize) $(wname+"_wd")
	wave wd = $(wname+"_wd")

	wd = wDir[p+start_i]
	param = wParam[p+start_i]

	 //WMNewRosePlot(wd, param, radiusMax, angleBinWidth, calmSpeedBin, speedBinWidth, maxSpeed)

	acg_clean_plot_waves()

	setdatafolder sdf
End

function/S acg_get_next_plot_wave()

	variable i
	for (i=0; i<100; i+=1)
		string wname = "param_"+num2str(i)
		if (!waveexists($wname))
			return wname
		endif
		return ""
	endfor
end

function/S acg_clean_plot_waves()
	string wlist = acg_get_wave_list()
	variable i
	for (i=0; i<itemsinlist(wlist); i+=1)
		killwaves/Z $(stringfromlist(i, wlist))
	endfor
end


// *** Project Flag Wave functions ***

Function/S pfw_get_marquee_menu_string()
	if (acg_project_flag_is_set())
		return pfw_get_keys()
	endif
	return ""
End

Function pfw_set_flag_from_marquee()

	GetLastUserMenuInfo
	string key = S_value

//	GetMarquee/K/Z left, bottom
	GetMarquee/K/Z bottom

//	GetWindow $S_marqueeWin wavelist
//	wave/T wlist = W_WaveList
//
//	variable start_dt, stop_dt, starti, stopi
//	variable found = 0
//	variable i
//	for (i=0; i<dimsize(wlist, 0); i+=1) // loop through rows to find wave with 'dat' dimension or datetime wave
//		wave w = $(wlist[i][1])
//		if (cmpstr(waveunits(w,0),"dat") == 0) // use wave scaling to set flag
//			starti = round(x2pnt(w,V_left))
//			starti = (starti < 0) ? 0 : starti
//			starti = (starti > dimsize(w,0)) ? dimsize(w,0) : starti
//			stopi = round(x2pnt(w,V_right))
//			stopi = (stopi < 0) ? 0 : stopi
//			stopi = (stopi > dimsize(w,0)) ? dimsize(w,0) : stopi
//			print starti, stopi
//			found = 1
//			break
//		elseif (stringmatch(wlist[i][0],"*datetime*")) // use the first wave with 'datetime' in the name
//			starti = BinarySearch(w,V_left)
//			starti = (starti == -1) ? 0 : starti
//			starti = (starti == -2) ? dimsize(w,0) : starti
//			stopi = BinarySearch(w,V_right)
//			stopi = (stopi == -1) ? 0 : stopi
//			stopi = (stopi == -2) ? dimsize(w,0) : stopi
//			print starti,stopi
//			found = 1
//			break
//		endif
//	endfor
//
//	if (!found)
//		// popup window for user to select dt wave
//	endif
//

	//acg_set_project_flag_range(start_dt,stop_dt,val)
	//acg_set_project_flag_value(dt,val)

	pfw_set_range(V_left,V_right,key)


	print S_value
	print V_value
End

Function pfw_set_range(start_dt,stop_dt,key)
	variable start_dt
	variable stop_dt
	string key

	string sdf = acg_goto_ProjectFlag()
	wave pfw = project_flag_wave

	variable starti, stopi
	starti = round(x2pnt(pfw,start_dt))
	starti = (starti < 0) ? 0 : starti
	starti = (starti > numpnts(pfw)) ? numpnts(pfw) : starti
	stopi = round(x2pnt(pfw,stop_dt))
	stopi = (stopi < 0) ? 0 : stopi
	stopi = (stopi > numpnts(pfw)) ? numpnts(pfw) : stopi
	//print starti, stopi

	variable val = pfw_get_value(key)
	if (numtype(val) == 0)
		pfw[starti,stopi] = val
	endif


End

Function acg_project_flag_is_set()

	if (!acg_project_is_set())
		// changed 05 Jan 2016 to reduce error messages generated when project info not set
		//print "Project Info not set!"
		//setdatafolder sdf
		return 0
	endif

	string sdf = acg_goto_ProjectInfo()
	if (!datafolderexists("ProjectFlag"))
		print "Project Flag is not set!"
		setdatafolder sdf
		return 0
	endif

	setdatafolder sdf
	return 1
End

Function/S acg_goto_ProjectFlag()

	string sdf = acg_goto_ProjectInfo()

	if (!datafolderexists(ProjectFlag_folder))
		acg_init_ProjectFlag()
	endif

	setdatafolder ProjectFlag_folder
	return sdf
End

Function acg_init_ProjectFlag()

	if (!acg_project_is_set())
		print "Project Info not set!"
		return 0
	endif

	string sdf = acg_goto_ProjectInfo()
	newdatafolder/o/s ProjectFlag

	// todo: allow users to add/remove custom flag names
	string/G project_flag_list = PFW_base_string
	string/G custom_flag_list = ""

	variable secs = acg_get_project_stop_dt() - acg_get_project_start_dt() + 1
	make/D/o/n=(secs) project_datetime
	wave pdt = project_datetime
	pdt[0] = acg_get_project_start_dt()
	pdt[1,] = pdt[p-1] + 1

	make/o/n=(secs) project_flag_wave // 1 second flag wave
	wave pfw = project_flag_wave
	SetScale/P x pdt[0],1,"dat", pfw

	pfw_set_metadata()

	//pfw = 0; //initialize to NORMAL
	variable nf = pfw_get_value("AMBIENT")
	pfw = nf

	setdatafolder sdf

End

Function pfw_set_metadata()

	string sdf = acg_goto_ProjectInfo()
	setdatafolder ProjectFlag

	svar std_flags =  project_flag_list
	svar custom_flags = custom_flag_list

	string sep = ";"
	variable has_semicolon = 1
	if (cmpstr(std_flags[strlen(std_flags)-1],";")==0)
		sep = ""
	endif

	string flags = std_flags + sep + custom_flags
	string flag_wn = ""
	variable i;
	for (i=0; i<itemsinlist(flags); i+=1)
		string f = stringfromlist(i,flags)
		flag_wn = addlistitem(f+pfw_get_key_sep()+num2str(i),flag_wn,pfw_get_flag_sep(),9999)
	endfor
	wave fw = project_flag_wave

	string wn = note(fw)
	wn = replacestringbykey("FLAGS",wn,flag_wn)
	Note/K fw, wn


	setdatafolder sdf

End

Function acg_has_project_flag()

End

Function/S pfw_get_flag_sep()
	string sep = PFW_flag_sep
	return sep
End

Function/S pfw_get_key_sep()
	string sep = PFW_key_sep
	return sep
End

Function pfw_add_custom_flag_panel()
	string new_flag = ""
	Prompt new_flag, "Add custom flag: " + pfw_get_keys()
	DoPrompt "Add custom flag", new_flag
	if (V_Flag)
		return -1
	endif

	pfw_add_custom_flag(new_flag)

End

Function pfw_add_custom_flag(flag_key)
	string flag_key

	string sdf = acg_goto_ProjectFlag()
	SVAR list = custom_flag_list

	if (findlistitem(flag_key,list) < 0)
		list = addlistitem(flag_key,list,";",9999)
		pfw_set_metadata()
	endif
	return 0

	// skip this old stuff for now.
	string keys = pfw_get_keys()
	variable max_value = 0

	variable i
	for (i=0; i<itemsinlist(keys); i+=1)
		variable val = pfw_get_value(stringfromlist(i,keys))
		max_value = ( val  >= max_value) ? val : max_value
	endfor
	max_value += 1
	print max_value

	string new_flag = flag_key + ":" + num2str(max_value)

	list = addlistitem(list,new_flag)

	setdatafolder sdf
End

Function/S pfw_get_keys()

	String keys = ""

	string sdf = acg_goto_ProjectFlag()
	//SVAR list = project_flag_list

	wave pfw = project_flag_wave
	string list = stringbykey("FLAGS",note(pfw))

	variable i
	for (i=0; i<itemsinlist(list,pfw_get_flag_sep()); i+=1)
		string item = stringfromlist(i,list,pfw_get_flag_sep())
		variable index = strsearch(item,pfw_get_key_sep(),0)
		keys += item[0,index-1] + ";"
	endfor

	setdatafolder sdf

	return keys
End

Function pfw_get_value(key)
	string key

	string sdf = acg_goto_ProjectFlag()
	//SVAR list = project_flag_list
	wave pfw = project_flag_wave
	string list = stringbykey("FLAGS",note(pfw))

	return NumberByKey(key,list,pfw_get_key_sep(),pfw_get_flag_sep())
End

Function pfw_flag_is_set(key, start_dt, stop_dt)
	string key
	variable start_dt
	variable stop_dt

	string sdf = acg_goto_ProjectFlag()

	wave flag = project_flag_wave
	variable flag_val = pfw_get_value(key)

	setdatafolder sdf

	variable single_pt = (start_dt == stop_dt) ? 1 : 0
	if (single_pt)
		return (flag_val == flag(start_dt))
	else
		variable wmin = wavemin(flag,start_dt, stop_dt)
		variable wmax = wavemax(flag,start_dt, stop_dt)
		return ( (wmin==wmax) && (wmin == flag_val) )
	endif

	return 0

End

//Function pfw_filter_wave(src, flag_key,replace_src, use_full_delta, [dt, delta_time])
Function pfw_filter_wave(src, flag_list,out_wname, use_full_delta, [dt, delta_time, subfld])
	wave src                        // wave to filter
	//string flag_key              // flag type to filter with
	string flag_list              // flag type(s) to filter with. Can be ";" separated list to include multiple flags in output wave
	//variable replace_src     // 0 = create new wave using flag as subfolder, 1 = replace w with filtered data
	string out_wname         // output wavename
	variable use_full_delta  // 0 = use the flag value at start_dt, 1 = all flag values between start_dt, stop_dt must be correct
	// optional parameters...must specify dt=???, delta_time=??? or subfld="???" when calling function
	wave dt                         // datetime wave - if omitted, use w scaling (faster)
	variable delta_time       // delta t in seconds - if omitted or 0, use dt values
	string subfld		     // optional subfolder for output wave

	variable start_dt = 0
	variable stop_dt = 0
	variable delta_t = 1
	variable calc_delta = 0
	if (ParamIsDefault(dt)) // dt scaling must be in X dim
		start_dt = dimoffset(src,0)
		delta_t = dimdelta(src,0)
	else
		// calculate delta from dt wave
		//start_dt = dt[0]
		//delta_t = dt[1] - dt[0]
		calc_delta = 1
	endif

	variable num_dims = 1
	num_dims = (dimsize(src,1)>0) ? 2 : num_dims
	num_dims = (dimsize(src,2)>0) ? 3 : num_dims
	num_dims = (dimsize(src,3)>0) ? 4 : num_dims
	num_dims = (dimsize(src,4)>0) ? 5 : num_dims

	string sdf = acg_goto_ProjectFlag()
	wave wflag = project_flag_wave
	setdatafolder sdf

//	string dest_name = nameofwave(src)
//	if (!replace_src)
//		newdatafolder/o $flag_key
//		duplicate/o src $(":" + flag_key + ":" + dest_name)
//		dest_name = ":" + flag_key + ":" + dest_name
//	endif

	string outname = out_wname
	if ( !ParamIsDefault(subfld)  )
		newdatafolder/o $subfld
		outname = ":"+subfld+":"+outname
	endif
	duplicate/o src $(outname)
//	wave w = $dest_name
	wave w = $(outname)
	w = NaN

	// set wavenote with src (name and path) and flag types using pfw_get_flag_sep()
	string wn = note(w)
	wn = replacestringbykey("NAME",wn,nameofwave(w))
	wn = replacestringbykey("PATH",wn,stringbykey("PATH",waveinfo(w,0)))
	string fstr = ""
	variable ft
	for (ft=0; ft<itemsinlist(flag_list); ft+=1)
		fstr += stringfromlist(ft,flag_list) + pfw_get_flag_sep()
	endfor
	wn = replacestringbykey("FLAGS",wn,fstr)
	Note w, wn

	variable ftype
	for (ftype=0; ftype<itemsinlist(flag_list); ftype+=1)
		string flag_key = stringfromlist(ftype, flag_list)

		variable i
		variable dt1, dt2
		for (i=0; i<dimsize(w,0); i+=1)
			if (calc_delta)
				start_dt = dt[i]
				if ( !ParamIsDefault(delta_time) && (delta_time > 0) )
					stop_dt = start_dt + delta_time
				else
					stop_dt = dt[i+1]
				endif
			else
				start_dt = dimoffset(w,0)  + (i*dimdelta(w,0))
				stop_dt = start_dt + delta_t
			endif

			if (!use_full_delta)
				stop_dt = start_dt
			endif

			if (num_dims == 1) // 1d time series
				w[i] = (pfw_flag_is_set(flag_key, start_dt, stop_dt)) ? src[i] : w[i]
			elseif (num_dims == 2) // 2d time series
				w[i][] = (pfw_flag_is_set(flag_key, start_dt, stop_dt)) ? src[i][q] : w[i][q]
			else
				return 0
			endif
		endfor

	endfor

End


Function acg_shorten_wave_names(fromString,toString)
	string fromString
	string toString

	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path

	Variable refNum
	String message = "Select one or more files"
	String outputPaths
	String fileFilters = "Igor Text Files (*.itx):.itx;"
	fileFilters += "All Files:.*;"

	Open /D /R /MULT=1 /F=fileFilters /M=message /P=loaddata_base_path refNum
	outputPaths = S_fileName

	string sdf = getdatafolder(1)
	newdatafolder/o/s root:tmp_shorten

	if (strlen(outputPaths) == 0)
		Print "Cancelled"
	else
		Variable numFilesSelected = ItemsInList(outputPaths, "\r")
		Variable i
		for(i=0; i<numFilesSelected; i+=1)
			String path = StringFromList(i, outputPaths, "\r")
			Printf "Loading %d: %s\r", i, path

			// load itx file
			LoadWave/T/O path

			// get wavelist
			string wlist=acg_get_wave_list()

			variable j
			for (j=0; j<itemsinlist(wlist); j+=1)
				string oldName = stringfromlist(j,wlist)
				string newName = ReplaceString(fromString, oldName, toString)

				if (cmpstr(oldName,newName) != 0)
					Rename $oldName, $newName
				endif

			endfor

			wlist=acg_get_wave_list()
			string short_path = ReplaceString(".itx", path, "_short.itx")
			Printf "Saving %d: %s\r",i,short_path
			Save/T/B wlist as short_path
			killwaves/A
		endfor
	endif
	//LoadWave/T/O/P=loaddata_base_path

	// set back to original datafolder
	setdatafolder sdf

	killdatafolder/Z root:tmp_shorten
End

Function acg_load_dchart_itx_format(tb)
	variable tb

	acg_init_gui()

	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path

	Variable refNum
	String message = "Select one or more files"
	String outputPaths
	String fileFilters = "Igor Text Files (*.itx):.itx;"
	fileFilters += "All Files:.*;"

	Open /D /R /MULT=1 /F=fileFilters /M=message /P=loaddata_base_path refNum
	outputPaths = S_fileName

	if (tb < 1)
		// show dialog asking for user to supply tb
	endif

	// Get current folder as destination folder
	string sdf = getdatafolder(1)

	string new_df = sdf[0,strlen(sdf)-2] // remove trailing ":"

	// temporarily replace load_datafolder_list and load_datafolder_index values in root:gui
	nvar dfIndex = root:gui:load_datafolder_index
	svar dfolder_list = root:gui:load_datafolder_list
	nvar last_tb = root:gui:last_timebase

	variable bak_index = dfIndex
	dfIndex = 0
	string bak_list = dfolder_list
	dfolder_list = new_df

	last_tb = tb

	// create and set current data folder to a $(acg_tmp_concat_folder+":input")
	newdatafolder/o/s $acg_tmp_concat_folder
	newdatafolder/o/s input


	if (strlen(outputPaths) == 0)
		Print "Cancelled"
	else
		Variable numFilesSelected = ItemsInList(outputPaths, "\r")
		Variable i
		for(i=0; i<numFilesSelected; i+=1)
			String path = StringFromList(i, outputPaths, "\r")
			//Printf "%d: %s\r", i, path

			// load itx file
			LoadWave/T/O path

			// rename StartDateTime to Start_DateTime ??
			//Rename StartDateTime, Start_DateTime
			Duplicate/o StartDateTime Start_DateTime
			KillWaves/Z StartDateTime
			// run acg_same_tb_concat_loaded_waves()
			acg_same_tb_concat_loaded_waves()

		endfor
	endif
	//LoadWave/T/O/P=loaddata_base_path

	// reset load_datafolder_list and load_datafolder_index values in root:gui
	dfIndex = bak_index
	dfolder_list = bak_list

	// set back to original datafolder
	setdatafolder sdf

End

Function acg_load_dgfetch_format(tb)
	variable tb

	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path
//	LoadWave/J/D/A/W/O/K=0/L={0,2,0,0,0}/R={English,2,2,2,2,"Year-Month-DayOfMonth",40}/P=loaddata_base_path

	acg_init_gui()

	Variable refNum
	String message = "Select one or more files"
	String outputPaths
	String fileFilters = "DGFetch files (*.dat):.dat;"
	fileFilters += "All Files:.*;"

	Open /D /R /MULT=1 /F=fileFilters /M=message /P=loaddata_base_path refNum
	outputPaths = S_fileName

	if (tb < 1)
		// show dialog asking for user to supply tb
	endif

	// Get current folder as destination folder
	string sdf = getdatafolder(1)

	string new_df = sdf[0,strlen(sdf)-2] // remove trailing ":"

	// temporarily replace load_datafolder_list and load_datafolder_index values in root:gui
	nvar dfIndex = root:gui:load_datafolder_index
	svar dfolder_list = root:gui:load_datafolder_list
	nvar last_tb = root:gui:last_timebase

	variable bak_index = dfIndex
	dfIndex = 0
	string bak_list = dfolder_list
	dfolder_list = new_df

	last_tb = tb

	// create and set current data folder to a $(acg_tmp_concat_folder+":input")
	newdatafolder/o/s $acg_tmp_concat_folder
	newdatafolder/o/s input


	if (strlen(outputPaths) == 0)
		Print "Cancelled"
	else
		Variable numFilesSelected = ItemsInList(outputPaths, "\r")
		Variable i
		for(i=0; i<numFilesSelected; i+=1)
			String path = StringFromList(i, outputPaths, "\r")
			//Printf "%d: %s\r", i, path

//			// load itx file
//			LoadWave/T/O path
			//string fn = stringfromlist(findex,file_list)
			load_data_selector_v2_bypath(path)

			// rename StartDateTime to Start_DateTime ??
			//Rename StartDateTime, Start_DateTime
			Duplicate/o DateTimeW Start_DateTime
			KillWaves/Z DateTimeW
			// run acg_same_tb_concat_loaded_waves()
			acg_same_tb_concat_loaded_waves()

		endfor
	endif
	//LoadWave/T/O/P=loaddata_base_path

	// reset load_datafolder_list and load_datafolder_index values in root:gui
	dfIndex = bak_index
	dfolder_list = bak_list

	// set back to original datafolder
	setdatafolder sdf

End

Function acg_create_destFolder(destFolder)
	string destFolder

	string sdf = getdatafolder(1)
	setdatafolder root:

	variable i, starti
	starti = (cmpstr("root",stringfromlist(0,destFolder,":")) == 0) ? 1 : 0
	for (i=starti; i<itemsinlist(destFolder,":"); i+=1)
		newdatafolder/o/s $stringfromlist(i,destFolder,":")
	endfor

	setdatafolder sdf

End

Function/S acg_get_destFolder_from_list(index)
	variable index

	nvar dfIndex = root:gui:load_datafolder_index
	svar dfolder_list = root:gui:load_datafolder_list

	string destFolder = stringfromlist(dfindex,dfolder_list)
	if (cmpstr("root",stringfromlist(0,destFolder,":")) != 0)
		destFolder = "root:"+destFolder
	endif

	return destFolder

End

Function wv_export_wind_vector()

	string sdf = getdatafolder(1)
	setdatafolder wv_datafolder

	SaveData/O/I/R

	setdatafolder sdf

End

Function wv_import_wind_vector()

	string sdf = getdatafolder(1)
	setdatafolder root:

	LoadData/I/O/T/R

	setdatafolder sdf

End

Function wv_create_base_waves(lat,lon,dt,ws,wd)  // tb = 60sec
	wave lat,lon,dt
	wave ws // wind speed (m/s)
	wave wd // wind direction (deg, 0=N, 90=E)

	newdatafolder/o/s $wv_datafolder

	duplicate/o lat latitude
	duplicate/o lon longitude
	duplicate/o dt wv_datetime

	make/o/n=(numpnts(dt),2) wind_arrow_base
	wave arrow_base = wind_arrow_base
	make/o/n=(numpnts(dt),3) wind_barb_base
	wave barb_base = wind_barb_base

	// set wind speeds
	arrow_base[][0] = ws[p]
	barb_base[][0] = ws[p]

	// set barb speed in knots
	barb_base[][2] = round(ws[p]*1.94386)

	// set wind direction - need to transform from degrees (0=N clockwise) to radians (0=E counterclockwise)
	//    for arrows - point with the wind
	arrow_base[][1] = ( (90-wd[p]) < 0) ? ( (90-wd[p])+360 )*PI/180 : (90-wd[p])*PI/180
	//windD_radians = (90-root:winds:common_tb_60:project_tb_60:WindD[p] < 0) ? ((90-root:winds:common_tb_60:project_tb_60:WindD[p])+360)*PI/180 : (90-root:winds:common_tb_60:project_tb_60:WindD[p])*PI/180

	// for barbs - point into the wind
	duplicate/o wd wd_barb
	wd_barb = ( (wd[p] + 180) > 360 ) ?  (wd[p] + 180) - 360 : (wd[p] + 180)
	barb_base[][1] = ( (90-wd_barb[p]) < 0) ? ( (90-wd_barb[p])+360 )*PI/180 : (90-wd_barb[p])*PI/180

	setdimlabel 1,2,windBarb,wind_barb_base

	killwaves/Z wd_barb

End

Function wv_create_plotwaves(type,[id,start_idx,stop_idx])
	string type // "arrow", "barb"
	string id
	variable start_idx
	variable stop_idx

	if (ParamIsDefault(id))
		id = ""
	endif

	if (cmpstr(id, "base")==0) // can't use this
		print "id=base is not allowed"
		return 0
	endif

	string sdf = getdatafolder(1)
	setdatafolder wv_datafolder

	wave dt = wv_datetime

	string basename = ""
	string destname = ""
	string paramname = ""
	if (cmpstr(type,"arrow")==0)
		basename = "wind_arrow_base"
		destname = "wind_arrow_"+ id
		paramname = "arrow_par_"+ id
	elseif (cmpstr(type,"barb")==0)
		basename = "wind_barb_base"
		destname = "wind_barb_" + id
		paramname = "barb_par" + id
	endif

	// Parameter wave:
	//    column 0 = wind speed scale factor - speeds < 3 default to marker for arrows
	//	            1 = vector spacing every N minutes
	//                 2 = start index for subset wave
	//                 3 = stop index for subset wave
	//                 4 = unused
	//                 5 = unused

	if (!waveexists($paramname))
		make/n=6 $paramname
		wave par = $paramname

		//set defaults
		par[0] = 1.0
		par[1] = 5
		par[2] = 0
		par[3] = numpnts(dt) -1
	endif

	wave par = $paramname

	if (!ParamIsDefault(start_idx))
		par[2] = start_idx
	endif

	if (!ParamIsDefault(stop_idx))
		par[3] = stop_idx
	endif

	wave base = $basename
	duplicate/o base $destname
	wave dest = $destname
	dest = NaN

	variable i
	for (i=par[2]; i<=par[3]; i+=par[1])

		//variable dest_idx = i-par[2]
		// scale wind speed (but not for barb data)
		dest[i][0] = base[i][0]*par[0]

		dest[i][1,] = base[i][q]

	endfor

	setdatafolder sdf

End

Function wv_spacing(type,everyNmins,[id])
	string type // "arrow", "barb"
	variable everyNmins // 5 = one vector every 5 minutes
	string id

	if (ParamIsDefault(id))
		id = ""
	endif

	if (cmpstr(id, "base")==0) // can't use this
		print "id=base is not allowed"
		return 0
	endif

	string sdf = getdatafolder(1)
	setdatafolder wv_datafolder

	string paramname = ""
	if (cmpstr(type,"arrow")==0)
		paramname = "arrow_par_"+ id
	elseif (cmpstr(type,"barb")==0)
		paramname = "barb_par" + id
	endif

	wave dt = wv_datetime

	if (!waveexists($paramname))
		make/n=6 $paramname
		wave par = $paramname

		//set defaults
		par[0] = 1.0  // wind speed scaling factor - speeds < 3 default to marker for arrows
		par[1] = everyNmins     // spacing every N minutes along track
		par[2] = 0
		par[3] = numpnts(dt) -1

	else
		wave par = $paramname
		par[1] = everyNmins
	endif

	wv_create_plotwaves(type,id=id)
End

Function wv_scaling(type,speed_scale_factor,[id])
	string type // "arrow", "barb"
	variable speed_scale_factor // multiplier for wind speed (anything less than 3 defaults to marker for arrow)
	string id

	if (ParamIsDefault(id))
		id = ""
	endif

	if (cmpstr(id, "base")==0) // can't use this
		print "id=base is not allowed"
		return 0
	endif

	string sdf = getdatafolder(1)
	setdatafolder wv_datafolder

	string paramname = ""
	if (cmpstr(type,"arrow")==0)
		paramname = "arrow_par_"+ id
	elseif (cmpstr(type,"barb")==0)
		paramname = "barb_par" + id
	endif

	wave dt = wv_datetime

	if (!waveexists($paramname))
		make/n=6 $paramname
		wave par = $paramname

		//set defaults
		par[0] = speed_scale_factor // wind speed scaling factor - speeds < 3 default to marker for arrows
		par[1] = 5     // spacing every N minutes along track
		par[2] = 0
		par[3] = numpnts(dt) -1

	else
		wave par = $paramname
		par[0] = speed_scale_factor
	endif

	wv_create_plotwaves(type,id=id)

End

Function wv_mask(type,start_idx,stop_idx,[id])
	string type // "arrow", "barb"
	variable start_idx,stop_idx // multiplier for wind speed (anything less than 3 defaults to marker for arrow)
	string id

	if (ParamIsDefault(id))
		id = ""
	endif

	if (cmpstr(id, "base")==0) // can't use this
		print "id=base is not allowed"
		return 0
	endif

	string sdf = getdatafolder(1)
	setdatafolder wv_datafolder

	string paramname = ""
	if (cmpstr(type,"arrow")==0)
		paramname = "arrow_par_"+ id
	elseif (cmpstr(type,"barb")==0)
		paramname = "barb_par" + id
	endif

	wave dt = wv_datetime

	if (!waveexists($paramname))
		make/n=6 $paramname
		wave par = $paramname

		//set defaults
		par[0] = 1 // wind speed scaling factor - speeds < 3 default to marker for arrows
		par[1] = 5     // spacing every N minutes along track
		par[2] = start_idx
		par[3] = stop_idx

	else
		wave par = $paramname
		par[2] = start_idx
		par[3] = stop_idx
	endif

	wv_create_plotwaves(type,id=id)

End

// acg_interp_nan_gap:
//	generate interpolated wave from xdata and ydata at points in data. The function is
//	designed to interp across gaps filled with NaN values. Interpolated wave will be named
// 	as specified by outw_name
Function acg_interp_nan_gap(ydata, outw_name,[xdata, new_xdata])
	wave ydata     // y-wave of data
	string outw_name // output wave name
	// *** OPTIONAL ***
	wave xdata     // x-wave of data...needed if ywave is not scaled with xwave
	wave new_xdata   // contains points at which you want to interpolate if different than xwave

	variable calc_xdata=0
	if (ParamIsDefault(xdata))
		// check to make sure ywave is scaled
		 if (dimoffset(ydata,0)==0 || dimdelta(ydata,0)==0)
		 	DoAlert 0, "y-wave not scaled...you need to specify an x-wave"
		 	return -1
		 endif
		 calc_xdata = 1
	endif

	string xdata_name = ""
	if (calc_xdata)
		xdata_name = "ing_tmp_xdata_w"
		make/o/d/n=(numpnts(ydata)) $xdata_name
		wave xd = $xdata_name
		xd[0] = dimoffset(ydata,0)
		xd[1,] = xd[p-1] + dimdelta(ydata,0)
	else
		xdata_name = nameofwave(xdata)
	endif
	wave xdata = $xdata_name

	string new_xdata_name = nameofwave(xdata)
	if (!ParamIsDefault(new_xdata))
		 new_xdata_name = nameofwave(new_xdata)
	endif
	wave data = $new_xdata_name

	variable wtype = numberbykey("NUMTYPE",waveinfo(ydata,0))
	make/o/Y=(wtype)/n=(numpnts(data)) $outw_name
	//duplicate/o data, $outw_name
	wave w = $outw_name
	w=nan

	if (calc_xdata)
		SetScale/P x dimoffset(ydata,0),dimdelta(ydata,0),waveunits(ydata,0) w
	endif

	duplicate/o xdata, tmp_xdata
	wave xw = tmp_xdata

	duplicate/o ydata, tmp_ydata
	wave yw = tmp_ydata


	// remove NaN's from xw and yw waves
	variable idex = 0
	variable count = numpnts( xw )
	do
		if( numtype( yw[idex] ) != 0 )
			Deletepoints idex, 1, yw, xw
			count = numpnts( xw )
		else
			idex += 1
		endif
	while( idex < count )

	w = (data[p] >= xw[0] && data[p] <= xw[numpnts(xw)-1]) ? interp(data[p], xw, yw) : NaN

	Killwaves/Z xw, yw

End

Function test_interp()

	make/o/n=100 test_data
	make/o/d/n=100 test_time

	wave data = test_data
	wave dt = test_time

	dt[0] = date2secs(2013,04,15)
	dt[1,] = dt[p-1]+1

	make/o/d/n=220 test_time2
	wave dt2 = test_time2
	dt2[0] = date2secs(2013,04,14) + 23*60*60+59*60
	dt2[1,] = dt2[p-1]+1

	variable i
	for (i=0; i<100;i+=1)
		data[i] = gnoise(10)
	endfor

	data[5,20] = NaN
	data[25,40] = NaN
	data[45,60] = NaN
	data[65,90] = NaN

	SetScale/P x dt[0],1,"dat", data

	acg_interp_nan_gap(data, "test_interp_ng")
	//acg_interp_nan_gap(data, "test_interp_ng",xdata=test_time)
	//acg_interp_nan_gap(data, "test_interp_ng",xdata=test_time,new_xdata=test_time2)
	//acg_interp_nan_gap(dt2, dt, data, "test_interp_ng")
End

Function/S acg_wn_get_note_with_key(w,key)
	wave w
	string key
	string msg = note(w)
	return stringbykey(key,msg)
End

Function acg_wn_set_note_with_key(w,key,msg)
	wave w
	string key
	string msg

	string orig = note(w)
	string new = ReplaceStringByKey(key,orig,msg)
	Note/K w, new
End

Function/WAVE acg_extract_dt(src)
	wave src

	string info = waveinfo(src,0)
	if (cmpstr(stringbykey("XUNITS",info),"dat")==0)
		variable size = dimsize(src,0)
		variable/D first_dt = dimoffset(src,0)
		variable delta_dt = dimdelta(src,0)

		make/D/o/n=(size) $(nameofwave(src)+"_dt")
		wave dt = $(nameofwave(src)+"_dt")

		dt[0] = first_dt
		dt[1,] = dt[p-1] + delta_dt

		return dt
	else
		return null
	endif
//
//	print info
//	print dimdelta(src,0)
//	print dimoffset(src,0)
//	return src
End

Function acg_kill_all_graphs()
	string fulllist = WinList("*", ";","WIN:1")
    	string name, cmd
    	variable i

  	  for(i=0; i<itemsinlist(fulllist); i +=1)
      		  name= stringfromlist(i, fulllist)
      	  	sprintf  cmd, "Dowindow/K %s", name
      	  	print cmd
        	execute cmd
        endfor
End

// ***** ict_time_to_dt
//	Convert icartt time format to datetime using UTC and JDAY waves
//	input:
//		year<variable> : user supplies year from icartt data file
// 	return:
//		nothing
//
//	creates: UTC_datetime wave
//
Function ict_time_to_dt(year)
	variable year
	
	wave jday = $"JDAY"
	wave utc = $"UTC"
	
	make/o/d/n=(numpnts(utc)) UTC_datetime
	wave dt = UTC_datetime
	
	variable i
	for (i=0; i<numpnts(dt); i+=1)
		
		dt[i] = doy2datetime(year, jday[i]) + utc[i]

	endfor
	
End

Function ict_smps_time_to_dt(year, month, day)
	variable year
	variable month
	variable day
	
	wave start_utc = $"Start_UTC"
	wave end_utc = $"End_UTC"
	wave mid_utc = $"Mid_UTC"
//	wave jday = $"JDAY"
//	wave utc = $"UTC"

	make/d/o/n=(numpnts(start_utc)) start_datetime, end_datetime, mid_datetime
	wave start_dt = start_datetime
	wave end_dt = end_datetime
	wave mid_dt = mid_datetime
	
//	make/o/d/n=(numpnts(utc)) UTC_datetime
//	wave dt = UTC_datetime

	variable base_dt = date2secs(year, month, day)
	
	variable i
	for (i=0; i<numpnts(start_dt); i+=1)
		
		start_dt[i] = base_dt + start_utc[i]
		end_dt[i] = base_dt + end_utc[i]
		mid_dt[i] = base_dt + mid_utc[i]

	endfor
	
End