#pragma rtGlobals=1		// Use modern global access method.

//strconstant icdata_ion_list = "Na;NH4;K;Mg;Ca;Acetate;Formate;MSA;Cl;Br;NO3;totSO4;oxalate;ssSO4;nssSO4"
strconstant icdata_ion_list = "Na;NH4;K;Mg;Ca;MSA;Cl;Br;NO3;totSO4" // for best 7 stage.
strconstant ocec_cmp_list = "OC;EC"
strconstant xrf_cmp_list = "IOM"

constant ocec_use_ams_org = 0 // if true, use the ams waves to get to POM
constant ocec_pom_factor = 1.9


Function icdata_load_7st()

	string sdf = getdatafolder(1)
	setdatafolder  root:
	newdatafolder/o/s chemistry
	newdatafolder/o/s icdata
	newdatafolder/o/s imp9
	newdatafolder/o/s raw
	newdatafolder/o/s sub
	
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path

	// Load submicron data
	LoadWave/J/D/A/W/O/K=0/L={2,3,0,1,5}/P=loaddata_base_path

	wave w = Sample__
	duplicate/o w :Sample_num
	killwaves/Z w
	
	wave w = Stage__
	duplicate/o w :Stage_num
	killwaves/Z w

	wave w = Start
	duplicate/o w :imp_starttime
	killwaves/Z w

	wave w = Stop
	duplicate/o w :imp_stoptime
	killwaves/Z w

//	LoadWave/J/D/A/W/O/K=0/L={2,3,0,17,0}/P=loaddata_base_path S_fileName  // ICEALOT
//	LoadWave/J/D/A/W/O/K=0/L={2,3,0,19,(itemsinlist(icdata_ion_list))}/P=loaddata_base_path S_fileName  // VOCALS
	LoadWave/J/D/A/W/O/K=0/L={2,3,0,6,(itemsinlist(icdata_ion_list))}/P=loaddata_base_path S_fileName  // CalNex
	setdatafolder ::

	// Load supermicron data
	newdatafolder/o/s sup
	LoadWave/J/D/A/W/O/K=0/L={2,3,0,1,5}/P=loaddata_base_path
	wave w = Sample__
	duplicate/o w :Sample_num
	killwaves/Z w
	
	wave w = Stage__
	duplicate/o w :Stage_num
	killwaves/Z w

	wave w = Start
	duplicate/o w :imp_starttime
	killwaves/Z w

	wave w = Stop
	duplicate/o w :imp_stoptime
	killwaves/Z w

//	LoadWave/J/D/A/W/O/K=0/L={2,3,0,17,0}/P=loaddata_base_path S_fileName
//	LoadWave/J/D/A/W/O/K=0/L={2,3,0,19,(itemsinlist(icdata_ion_list))}/P=loaddata_base_path S_fileName  //VOCALS
	LoadWave/J/D/A/W/O/K=0/L={2,3,0,6,(itemsinlist(icdata_ion_list))}/P=loaddata_base_path S_fileName  // CalNex
	setdatafolder ::
	setdatafolder ::
		
	// get time waves
	wave imp_start_raw = :raw:sub:imp_starttime
	wave imp_stop_raw  = :raw:sub:imp_stoptime
	
	string ion_list = icdata_ion_list
	// create 2d waves for each ion
	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)
		// do sub first
		wave samp = :raw:sub:Sample_num
		wave stage = :raw:sub:Stage_num
		wave ion = $(":raw:sub:"+ stringfromlist(i,ion_list))
		
		wavestats/Q samp
		variable num_samps = V_max
		
		make/o/D/n=(num_samps) imp_starttime
		make/o/D/n=(num_samps) imp_stoptime
		make/o/D/n=(num_samps) imp_sample
		wave imp_start = imp_starttime
		wave imp_stop = imp_stoptime
		wave imp_samp = imp_sample

		make/o/n=(num_samps,7) $(stringfromlist(i,ion_list))
		wave ion_2d = $(stringfromlist(i,ion_list))
		ion_2d = NaN
		
		variable j
		for (j=0;  j<numpnts(ion); j+=1)
			if (numtype(stage[j]) == 0)
				imp_start[samp[j]-1] = imp_start_raw[j]
				imp_stop[samp[j]-1] = imp_stop_raw[j]
				imp_samp[samp[j]-1] = samp[j]				
				ion_2d[samp[j]-1][stage[j]-1] = ion[j]
			endif
		endfor

		// now the supermicron
		wave samp = :raw:sup:Sample_num
		wave stage = :raw:sup:Stage_num
		wave ion = $(":raw:sup:"+ stringfromlist(i,ion_list))
		for (j=0;  j<numpnts(ion); j+=1)
			if (numtype(stage[j]) == 0)
				//imp_start[samp[j]-1] = imp_start_raw[j]
				//imp_stop[samp[j]-1] = imp_stop_raw[j]
				ion_2d[samp[j]-1][stage[j]-1] = ion[j]
			endif
		endfor
		
		// clean up data
		ion_2d = (ion_2d[p][q] == -999) ? NaN : ion_2d[p][q]
		ion_2d = (ion_2d[p][q] < 0) ? 0 : ion_2d[p][q]
		
	endfor 
		

	setdatafolder sdf
	
End

Function icdata_merge_amb_ss()

	DFREF dfr = getdatafolderDFR()
	setdatafolder  root:reformat
	
	string ion_list = "Na;NH4;K;Mg;Ca;MSA;Cl;Br;NO3;SO4"
	
	string extras = "Duration;LAT;LONGT"
	
	wave amb_dt = $(":ambient:StartDateTime")
	wave ss_dt = $(":seasweep:StartDateTime")
	variable ambNum = numpnts(amb_dt)
	variable ssNum = numpnts(ss_dt)
	variable newNum = numpnts(amb_dt)+numpnts(ss_dt)
	//make/o/n=(newNum) StartDateTime
	Concatenate/NP/O {amb_dt, ss_dt}, StartDateTime
	wave dt_key = StartDateTime
	
	variable i
	for (i=0; i<itemsinlist(extras); i+=1)
	
		wave amb_extra = $(":ambient:"+ stringfromlist(i,extras))
		wave ss_extra = $(":seasweep:"+ stringfromlist(i,extras))
		
		make/o/n=(newNum) $stringfromlist(i,extras)
		
		Concatenate/NP/O {amb_extra,ss_extra}, $stringfromlist(i,extras)
		wave extra = $stringfromlist(i,extras)
		Sort dt_key, extra

	endfor
	//Sort dt_key, dt_key

	for (i=0; i<itemsinlist(ion_list); i+=1)

		if ( !waveexists($(":ambient:sub"+ stringfromlist(i,ion_list))) )
			make/o/n=(ambNum) $(":ambient:sub"+ stringfromlist(i,ion_list))
			wave w = $(":ambient:sub"+ stringfromlist(i,ion_list))
			w=0
		endif
		wave amb_sub = $(":ambient:sub"+ stringfromlist(i,ion_list))

		if ( !waveexists($(":ambient:sup"+ stringfromlist(i,ion_list))) )
			make/o/n=(ambNum) $(":ambient:sup"+ stringfromlist(i,ion_list))
			wave w = $(":ambient:sup"+ stringfromlist(i,ion_list))
			w=0
		endif
		wave amb_sup = $(":ambient:sup"+ stringfromlist(i,ion_list))
		
		if ( !waveexists($(":seasweep:sub"+ stringfromlist(i,ion_list))) )
			make/o/n=(ssNum) $(":seasweep:sub"+ stringfromlist(i,ion_list))
			wave w = $(":seasweep:sub"+ stringfromlist(i,ion_list))
			w=0
		endif		
		wave ss_sub = $(":seasweep:sub"+ stringfromlist(i,ion_list))

		if ( !waveexists($(":seasweep:sup"+ stringfromlist(i,ion_list))) )
			make/o/n=(ssNum) $(":seasweep:sup"+ stringfromlist(i,ion_list))
			wave w = $(":seasweep:sup"+ stringfromlist(i,ion_list))
			w=0
		endif		
		wave ss_sup = $(":seasweep:sup"+ stringfromlist(i,ion_list))
	
		make/o/n=(newNum) $("sub"+stringfromlist(i,ion_list))
		Concatenate/NP/O {amb_sub,ss_sub}, $("sub"+stringfromlist(i,ion_list))
		wave sub = $("sub"+stringfromlist(i,ion_list))
		Sort dt_key, sub

		make/o/n=(newNum) $("sup"+stringfromlist(i,ion_list))
		Concatenate/NP/O {amb_sup,ss_sup}, $("sup"+stringfromlist(i,ion_list))
		wave sup = $("sup"+stringfromlist(i,ion_list))
		Sort dt_key, sup


	endfor
	
	Sort dt_key, dt_key
	
	setdatafolder dfr

End

Function icdata_merge_amb_ss_naames1()

	DFREF dfr = getdatafolderDFR()
	setdatafolder  root:reformat
	
	string ion_list = "Na;NH4;K;Mg;Ca;MSA;Cl;Br;NO3;SO4"
	
//	string extras = "Duration;LAT;LONGT"
	string extras = "impnumber0;stoptime0"
	
	wave amb_dt = $(":ambient:sub:starttime0")
	wave ss_dt = $(":seasweep:sub:starttime0")
	variable ambNum = numpnts(amb_dt)
	variable ssNum = numpnts(ss_dt)
	variable newNum = numpnts(amb_dt)+numpnts(ss_dt)
	//make/o/n=(newNum) StartDateTime
	Concatenate/NP/O {amb_dt, ss_dt}, imp_starttime
	wave dt_key = imp_starttime
	
	variable i
	for (i=0; i<itemsinlist(extras); i+=1)
	
		wave amb_extra = $(":ambient:sub:"+ stringfromlist(i,extras))
		wave ss_extra = $(":seasweep:sub:"+ stringfromlist(i,extras))
		
		make/o/n=(newNum) $stringfromlist(i,extras)
		
		Concatenate/NP/O {amb_extra,ss_extra}, $stringfromlist(i,extras)
		wave extra = $stringfromlist(i,extras)
		Sort dt_key, extra

	endfor
	//Sort dt_key, dt_key

	for (i=0; i<itemsinlist(ion_list); i+=1)

		if ( !waveexists($(":ambient:sub:"+ stringfromlist(i,ion_list)+"_1_1")) )
			make/o/n=(ambNum) $(":ambient:sub:"+ stringfromlist(i,ion_list)+"_1_1")
			wave w = $(":ambient:sub:"+ stringfromlist(i,ion_list)+"_1_1")
			w=0
		endif
		wave amb_sub = $(":ambient:sub:"+ stringfromlist(i,ion_list)+"_1_1")

		if ( !waveexists($(":ambient:sup:"+ stringfromlist(i,ion_list)+"_1_2")) )
			make/o/n=(ambNum) $(":ambient:sup:"+ stringfromlist(i,ion_list)+"_1_2")
			wave w = $(":ambient:sup:"+ stringfromlist(i,ion_list)+"_1_2")
			w=0
		endif
		wave amb_sup = $(":ambient:sup:"+ stringfromlist(i,ion_list)+"_1_2")
		
		if ( !waveexists($(":seasweep:sub:"+ stringfromlist(i,ion_list)+"_1_1")) )
			make/o/n=(ssNum) $(":seasweep:sub:"+ stringfromlist(i,ion_list)+"_1_1")
			wave w = $(":seasweep:sub:"+ stringfromlist(i,ion_list)+"_1_1")
			w=0
		endif		
		wave ss_sub = $(":seasweep:sub:"+ stringfromlist(i,ion_list)+"_1_1")

		if ( !waveexists($(":seasweep:sup:"+ stringfromlist(i,ion_list)+"_1_2")) )
			make/o/n=(ssNum) $(":seasweep:sup:"+ stringfromlist(i,ion_list)+"_1_2")
			wave w = $(":seasweep:sup:"+ stringfromlist(i,ion_list)+"_1_2")
			w=0
		endif		
		wave ss_sup = $(":seasweep:sup:"+ stringfromlist(i,ion_list)+"_1_2")
	
		make/o/n=(newNum) $("sub"+stringfromlist(i,ion_list))
		Concatenate/NP/O {amb_sub,ss_sub}, $("sub"+stringfromlist(i,ion_list))
		wave sub = $("sub"+stringfromlist(i,ion_list))
		Sort dt_key, sub

		make/o/n=(newNum) $("sup"+stringfromlist(i,ion_list))
		Concatenate/NP/O {amb_sup,ss_sup}, $("sup"+stringfromlist(i,ion_list))
		wave sup = $("sup"+stringfromlist(i,ion_list))
		Sort dt_key, sup


	endfor
	
	Sort dt_key, dt_key
	
	setdatafolder dfr

End

Function icdata_load_2st()

	string sdf = getdatafolder(1)
	setdatafolder  root:
	newdatafolder/o/s chemistry
	newdatafolder/o/s icdata
	newdatafolder/o/s imp1
	newdatafolder/o/s raw
	
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path

	// Load anion data
	//LoadWave/J/D/A/W/O/K=0/L={2,3,0,1,5}/P=loaddata_base_path
	LoadWave/O/T/P=loaddata_base_path
	
	// Change following for CalNex
//	duplicate/o subSO4 :subtotSO4, :subssSO4
//	duplicate/o supSO4 :suptotSO4, :supssSO4
//	wave ss = subssSO4
//	wave nss = subnssSO4
//	ss -= nss
//	wave ss = supssSO4
//	wave nss = supnssSO4
//	ss -= nss

	duplicate/o subSO4 :subtotSO4
	duplicate/o supSO4 :suptotSO4

	// Load cation data
	//LoadWave/J/D/A/W/O/K=0/L={2,3,0,1,5}/P=loaddata_base_path
	LoadWave/O/T/P=loaddata_base_path

	setdatafolder ::
		
	// get time waves
	wave imp_start_raw = :raw:StartDateTime
	//wave imp_stop_raw  = :raw:sub:imp_stoptime
	wave imp_duration  = :raw:Duration
	duplicate/o imp_start_raw imp_starttime
	wave imp_start = imp_starttime
	
	string ion_list = icdata_ion_list
	// create 2d waves for each ion
	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)

		wave ion_sub = $(":raw:sub"+ stringfromlist(i,ion_list))
		wave ion_sup = $(":raw:sup"+ stringfromlist(i,ion_list))
		
		//wavestats/Q samp
		variable num_samps = numpnts(imp_start)
		
		//make/o/D/n=(num_stages) imp_starttime
		make/o/D/n=(num_samps) imp_stoptime
		//wave imp_start = imp_starttime
		wave imp_stop = imp_stoptime

		make/o/n=(num_samps,2) $(stringfromlist(i,ion_list))
		wave ion_2d = $(stringfromlist(i,ion_list))
		ion_2d = NaN
		
		variable j
		for (j=0;  j<numpnts(imp_start); j+=1)
				imp_stop[j] = imp_start[j] + imp_duration[j]
				ion_2d[j][0] = ion_sub[j]
				ion_2d[j][1] = ion_sup[j]
		endfor
		
		// clean up data
		ion_2d = (ion_2d[p][q] == -999) ? NaN : ion_2d[p][q]
		ion_2d = (ion_2d[p][q] < 0) ? 0 : ion_2d[p][q]
		
	endfor 
		

	setdatafolder sdf
	
End


Function icdata_create_best_7st_icdata()

	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:icdata
		
	string ion_list = icdata_ion_list
	
	wave imp_start = :imp1:imp_starttime
	wave imp_stop = :imp1:imp_stoptime
	wave imp_samp = :imp9:imp_sample

	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)
		wave ion_7st = $(":imp9:"+stringfromlist(i,ion_list))
		wave ion_2st = $(":imp1:"+stringfromlist(i,ion_list))
	
		// create relative 7 st matrix
		duplicate/o ion_7st $("relative_dist_"+stringfromlist(i,ion_list))
		wave rel_dist = $("relative_dist_"+stringfromlist(i,ion_list))
		
		variable j,k
		variable tot = 0
		for (j=0; j<numpnts(imp_samp); j+=1)
			tot=0
			// compute sub
			for (k=0; k<4; k+=1)
				tot+=ion_7st[j][k]
			endfor
			for (k=0; k<4; k+=1)
				rel_dist[j][k] = ion_7st[j][k]/tot
			endfor			

			// compute sup
			tot = 0
			for (k=4; k<7; k+=1)
				tot+=ion_7st[j][k]
			endfor
			for (k=4; k<7; k+=1)
				rel_dist[j][k] = ion_7st[j][k]/tot
			endfor			
		endfor
		
		// create best 7st wave
		duplicate/o ion_7st $(stringfromlist(i,ion_list)+"_7st")
		wave ion = 	$(stringfromlist(i,ion_list)+"_7st")
		for (j=0; j<numpnts(imp_samp); j+=1)
			for (k=0; k<4; k+=1)
				ion[j][k] = ion_2st[j][0]*rel_dist[j][k]
			endfor			
			for (k=4; k<7; k+=1)
				ion[j][k] = ion_2st[j][1]*rel_dist[j][k]
			endfor	
		endfor		

		killwaves/Z rel_dist		
			
	endfor
	
	icdata_create_total_icmass()
	
	setdatafolder sdf

End

Function icdata_create_total_icmass()

	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:icdata
		
	string ion_list = icdata_ion_list
	
	wave imp_start = :imp1:imp_starttime
	wave imp_stop = :imp1:imp_stoptime
	wave imp_samp = :imp9:imp_sample

	make/o/n=(numpnts(imp_samp),7) tot_icmass_7st
	wave totmass = tot_icmass_7st
	totmass = 0
	
	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)
		wave ion_7st = $(":imp9:"+stringfromlist(i,ion_list))
		if (cmpstr(stringfromlist(i,ion_list),"nssSO4")!=0  && cmpstr(stringfromlist(i,ion_list),"ssSO4")!=0)
			//totmass += ion_7st // can't add NaNs 
			variable j,k
			for (j=0; j<dimsize(ion_7st,0); j+=1)
				for (k=0; k<dimsize(ion_7st,1); k+=1)
					if (numtype(ion_7st[j][k])==0)
						variable add = ion_7st[j][k]
						totmass[j][k] += ion_7st[j][k]
					endif
				endfor
			endfor
//			totmass = (numtype(ion_7st[p][q])==0) ? totmass[p][q] + ion_7st[p][q] : totmass[p][q]
		endif
	endfor

	setdatafolder sdf
End

Function icdata_save_data_for_aerho()
	
	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:icdata

//	string out_prefix = "Y:Data:Cruises:vocals:chemistry:icdata:aerho:"	
//	string out_prefix = "Y:Data:Cruises:calnex:chemistry:icdata:aerho:"	
//	string out_prefix = "Y:Data:Cruises:dynamo:chemistry:icdata:aerho:"	
//	string out_prefix = "Y:Data:Cruises:wacs:chemistry:icdata:aerho:"	
	string out_prefix = "Y:Data:Cruises:wacs2:chemistry:icdata:aerho:"	
	string ion_list = icdata_ion_list
	
	wave imp_samp = :imp9:imp_sample

	variable i
	variable refNum
	for (i=0; i<itemsinlist(ion_list); i+=1)
//		string fname = out_prefix+"vocals_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
//		string fname = out_prefix+"calnex_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
//		string fname = out_prefix+"wacs_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
		string fname = out_prefix+"wacs2_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
		Open/Z=2 refNum as fname
		Variable err = V_flag
		
		if (err != 0)
//			string err_msg = "Error saving to: vocals_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
//			string err_msg = "Error saving to: calnex_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
//			string err_msg = "Error saving to: wacs_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
			string err_msg = "Error saving to: wacs2_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
			DoAlert 0, err_msg
			return err
		endif
		
		//fprintf refNum, "This is a test\n"
		
//		string buf = "VOCALS:  Imp 9 (from 1) "+stringfromlist(i,ion_list)+",,,,,,,,,,,,,,\n"
//		string buf = "CalNex:  Imp 9 (from 1) "+stringfromlist(i,ion_list)+",,,,,,,,,,,,,,\n"
//		string buf = "WACS:  Imp 9 "+stringfromlist(i,ion_list)+",,,,,,,,,,,,,,\n"
		string buf = "WACS2:  Imp 9 "+stringfromlist(i,ion_list)+",,,,,,,,,,,,,,\n"
		fprintf refNum, buf
		buf = ",,,,,,,,,,,,,,\n"
		fprintf refNum, buf
		buf = ",ug/m3,ug/m3,ug/m3,ug/m3,ug/m3,ug/m3,ug/m3,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um\n"
		fprintf refNum, buf
		buf = "Sample,0.12,0.24,0.41,0.76,1.47,2.89,6.52,0.12,0.24,0.41,0.76,1.47,2.89,6.52\n"	
		fprintf refNum,	buf

		wave ion_data = $(stringfromlist(i,ion_list)+"_7st")
		duplicate/o ion_data ion_cleaned
		wave ion = ion_cleaned
		
		ion = (numtype(ion[p][q]) != 0) ? 0 : ion[p][q]
		
		variable j,k
		for (j=0; j<numpnts(imp_samp); j+=1)
			
			fprintf refNum, "%d,", imp_samp[j]
			for (k=0; k<(dimsize(ion,1)); k+=1)
				fprintf refNum, "%g,", ion[j][k]
			endfor
			fprintf refNum, ",,,,,,\n"
		endfor
		
		Close refNum
		
		killwaves/Z ion
		
	endfor

	setdatafolder sdf

End

Function icdata_save_2st_data_for_aerho()
	
	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:icdata:imp1

	string out_prefix = "Y:Data:Cruises:vocals:chemistry:icdata:aerho:"	
	string ion_list = icdata_ion_list
	
	wave imp_samp = imp_sample

	variable i
	variable refNum
	for (i=0; i<itemsinlist(ion_list); i+=1)
		if (waveexists($(stringfromlist(i,ion_list)+"_2st")))
			string fname = out_prefix+"vocals_"+LowerStr(stringfromlist(i,ion_list))+"_2stage.csv"
			Open/Z=2 refNum as fname
			Variable err = V_flag
			
			if (err != 0)
				string err_msg = "Error saving to: vocals_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
				DoAlert 0, err_msg
				return err
			endif
			
			//fprintf refNum, "This is a test\n"
			
			string buf = "VOCALS:  Imp 1 "+stringfromlist(i,ion_list)+",,,,,,,,,,,,,,\n"
			fprintf refNum, buf
			buf = ",,,,,,,,,,,,,,\n"
			fprintf refNum, buf
			buf = ",ug/m3,ug/m3,ug/m3,ug/m3,ug/m3,ug/m3,ug/m3,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um,ug/m3/um\n"
			fprintf refNum, buf
			buf = "Sample,0.12,0.24,0.41,0.76,1.47,2.89,6.52,0.12,0.24,0.41,0.76,1.47,2.89,6.52\n"	
			fprintf refNum,	buf
	
			wave ion_data = $(stringfromlist(i,ion_list)+"_2st")
			make/o/n=(numpnts(imp_samp),7)  ion_cleaned
			wave ion = ion_cleaned
			ion = 0
			
			ion[][,1] = (numtype(ion_data[p][q]) != 0) ? 0 : ion_data[p][q]
			
			variable j,k
			for (j=0; j<numpnts(imp_samp); j+=1)
				
				fprintf refNum, "%d,", imp_samp[j]
				for (k=0; k<(dimsize(ion,1)); k+=1)
					fprintf refNum, "%g,", ion[j][k]
				endfor
				fprintf refNum, ",,,,,,\n"
			endfor
			
			Close refNum
			
			killwaves/Z ion
		endif
	endfor

	setdatafolder sdf

End

Function ocec_load_2st()

	string sdf = getdatafolder(1)
	setdatafolder  root:
	newdatafolder/o/s chemistry
	newdatafolder/o/s ocec
	newdatafolder/o/s imp_2st
	newdatafolder/o/s raw
	
	set_base_path()
	PathInfo loaddata_base_path
	//print "base_path  = " S_path

	// Load anion data
	//LoadWave/J/D/A/W/O/K=0/L={2,3,0,1,5}/P=loaddata_base_path
	LoadWave/O/T/P=loaddata_base_path

//	duplicate/o subEC :supEC
//	wave ec = supEC
//	ec = NaN

	// CalNex specific
	if (ocec_use_ams_org)
		duplicate/o ams_org_amb_asImp_cor subOC, supOC
		supOC = NaN
	endif

	
	duplicate/o imp13_sub_OC subOC, supOC
	supOC = NaN
	
	duplicate/o subOC subEC, supEC
	wave ec = subEC
	ec = NaN
	wave ec = supEC
	ec = NaN
		
	setdatafolder ::
		
//	// get time waves
//	wave imp_start_raw = :raw:StartDateTime
//	//wave imp_stop_raw  = :raw:sub:imp_stoptime
//	wave imp_duration  = :raw:Duration
//	duplicate/o imp_start_raw imp_starttime
//	wave imp_start = imp_starttime
//
//	//wavestats/Q samp
//	variable num_samps = numpnts(imp_start)
//	
//	//make/o/D/n=(num_stages) imp_starttime
//	make/o/D/n=(num_samps) imp_stoptime
//	//wave imp_start = imp_starttime
//	wave imp_stop = imp_stoptime
//	imp_stop = imp_start + imp_duration
	
	duplicate/o :raw:imp_starttime imp_starttime
	duplicate/o :raw:imp_stoptime imp_stoptime
	wave imp_start = imp_starttime
	wave imp_stop = imp_stoptime
	variable num_samps = numpnts(imp_start)
	
	string ion_list = ocec_cmp_list
	// create 2d waves for each ion
	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)

		wave ion_sub = $(":raw:sub"+ stringfromlist(i,ion_list))
		wave ion_sup = $(":raw:sup"+ stringfromlist(i,ion_list))
		

		make/o/n=(num_samps,2) $(stringfromlist(i,ion_list))
		wave ion_2d = $(stringfromlist(i,ion_list))
		ion_2d = NaN
		
		variable j
		for (j=0;  j<numpnts(imp_start); j+=1)
				ion_2d[j][0] = ion_sub[j]
				ion_2d[j][1] = ion_sup[j]
		endfor
		
		// clean up data
		ion_2d = (ion_2d[p][q] == -999) ? NaN : ion_2d[p][q]
		ion_2d = (ion_2d[p][q] < 0) ? 0 : ion_2d[p][q]
		
	endfor 
		

	setdatafolder sdf
	
End

Function ocec_create_best_7st_data()

	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:ocec
		
	string ion_list = ocec_cmp_list
	
	wave imp_start = :imp_2st:imp_starttime
	wave imp_stop = :imp_2st:imp_stoptime
	wave imp_samp = root:chemistry:icdata:imp9:imp_sample

//	wave ion_7st = $("root:chemistry:icdata:imp9:nssSO4")
	wave ion_7st = $("root:chemistry:icdata:imp9:totSO4")
	wave ic_totmass = $("root:chemistry:icdata:tot_icmass_7st")
	
	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)
		//wave ion_7st = $("root:chemistry:icdata:imp9:"+stringfromlist(i,ion_list))
		wave ion_2st = $(":imp_2st:"+stringfromlist(i,ion_list))
	
		// create relative 7 st matrix
		duplicate/o ion_7st $("relative_dist_"+stringfromlist(i,ion_list))
		wave rel_dist = $("relative_dist_"+stringfromlist(i,ion_list))
		
		variable j,k
		variable tot = 0
		for (j=0; j<numpnts(imp_samp); j+=1)
			tot=0
			// compute sub
			for (k=0; k<4; k+=1)
				tot+=ion_7st[j][k]
			endfor
			for (k=0; k<4; k+=1)
				rel_dist[j][k] = ion_7st[j][k]/tot
			endfor			

			// compute sup
			tot = 0
			for (k=4; k<7; k+=1)
				tot+=ic_totmass[j][k]
			endfor
			for (k=4; k<7; k+=1)
				rel_dist[j][k] = ic_totmass[j][k]/tot
			endfor			
		endfor
		
		// create best 7st wave
		duplicate/o ion_7st $(stringfromlist(i,ion_list)+"_7st")
		wave ion = 	$(stringfromlist(i,ion_list)+"_7st")
		for (j=0; j<numpnts(imp_samp); j+=1)
			for (k=0; k<4; k+=1)
				ion[j][k] = ion_2st[j][0]*rel_dist[j][k]
			endfor			
			for (k=4; k<7; k+=1)
				ion[j][k] = ion_2st[j][1]*rel_dist[j][k]
			endfor	
		endfor		

		killwaves/Z rel_dist		
			
	endfor

	variable pom_factor = (ocec_use_ams_org) ? 1 : ocec_pom_factor // don't convert if using ams data

	
	// create POM wave based on pom_factor (defined at top)
	wave oc = :OC_7st
	duplicate/o oc $("POM_"+num2str(pom_factor)+"_7st")
	wave pom = $("POM_"+num2str(pom_factor)+"_7st")

	pom = oc*pom_factor
	
	setdatafolder sdf

End

Function ocec_save_data_for_aerho()
	
	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:ocec

//	string out_prefix = "Y:Data:Cruises:vocals:chemistry:ocec:aerho:"	
//	string out_prefix = "Y:Data:Cruises:calnex:chemistry:ocec:aerho:"	
//	string out_prefix = "Y:Data:Cruises:wacs:chemistry:ocec:aerho:"	
	string out_prefix = "Y:Data:Cruises:wacs2:chemistry:ocec:aerho:"	
	string ion_list = ocec_cmp_list
	
	wave imp_samp = root:chemistry:icdata:imp9:imp_sample

	variable pom_factor = (ocec_use_ams_org) ? 1 : ocec_pom_factor // don't convert if using ams data

	variable i
	variable refNum
	for (i=0; i<itemsinlist(ion_list); i+=1)
		string cmpname = stringfromlist(i,ion_list)
		if (cmpstr(cmpname,"OC")==0)
			cmpname = "POM_"+num2str(pom_factor)
			cmpname = replacestring(".",cmpname,"_") 
		endif
//		string fname = out_prefix+"vocals_"+LowerStr(cmpname)+"_7stage.txt"
//		string fname = out_prefix+"calnex_"+LowerStr(cmpname)+"_7stage.txt"
//		string fname = out_prefix+"wacs_"+LowerStr(cmpname)+"_7stage.txt"
		string fname = out_prefix+"wacs2_"+LowerStr(cmpname)+"_7stage.txt"
		Open/Z=2 refNum as fname
		Variable err = V_flag
		
		if (err != 0)
//			string err_msg = "Error saving to: vocals_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
//			string err_msg = "Error saving to: calnex_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
//			string err_msg = "Error saving to: wacs_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
			string err_msg = "Error saving to: wacs2_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
			DoAlert 0, err_msg
			return err
		endif
		
		//fprintf refNum, "This is a test\n"
		
//		string buf = "VOCALS:   "+cmpname+"\t\t\t\t\t\t\t\n"
//		string buf = "CalNex:   "+cmpname+"\t\t\t\t\t\t\t\n"
//		string buf = "WACS:   "+cmpname+"\t\t\t\t\t\t\t\n"
		string buf = "WACS2:   "+cmpname+"\t\t\t\t\t\t\t\n"
		fprintf refNum, buf
		buf = "\tug/m3\tug/m3\tug/m3\tug/m3\tug/m3\tug/m3\tug/m3\n"
		fprintf refNum, buf
		buf = "Sample\t0.12\t0.24\t0.41\t0.76\t1.47\t2.89\t6.52\n"	
		fprintf refNum,	buf

		wave ion_data = $(cmpname+"_7st")
		duplicate/o ion_data ion_cleaned
		wave ion = ion_cleaned
		
		ion = (numtype(ion[p][q]) != 0) ? 0 : ion[p][q]
		
		variable j,k
		for (j=0; j<numpnts(imp_samp); j+=1)
			
			fprintf refNum, "%d\t", imp_samp[j]
			for (k=0; k<(dimsize(ion,1)); k+=1)
				fprintf refNum, "%g", ion[j][k]
				if (k < dimsize(ion,1)-1)
					fprintf refNum, "\t"
				endif
			endfor
			fprintf refNum, "\n"
		endfor
		
		Close refNum
		
		killwaves/Z ion
		
	endfor

	setdatafolder sdf

End

Function xrf_cacl_iom()

	string sdf = getdatafolder(1)
	setdatafolder root:chemistry:xrf:imp_2st
	
	string frac_list = "sub;sup"
	variable i,j


	// get time waves
	wave imp_start_raw = StartDateTime
	//wave imp_stop_raw  = :raw:sub:imp_stoptime
	wave imp_duration  = Duration
	duplicate/o imp_start_raw imp_starttime
	wave imp_start = imp_starttime

	//wavestats/Q samp
	variable num_samps = numpnts(imp_start)
	
	//make/o/D/n=(num_stages) imp_starttime
	make/o/D/n=(num_samps) imp_stoptime
	//wave imp_start = imp_starttime
	wave imp_stop = imp_stoptime
	imp_stop = imp_start + imp_duration

	make/o/n=(num_samps,2) IOM
	wave iom_2st = IOM
	
	for (i=0; i<itemsinlist(frac_list); i+=1)
		string frac = stringfromlist(i,frac_list)
		wave al = $(frac+"ElAl")
		wave si = $(frac+"ElSi")
		wave ca = $(frac+"ElCa")
		wave fe = $(frac+"ElFe")
		wave ti = $(frac+"ElTi")
		
		al = (numtype(al[p]) > 0) ? 0 : al[p]
		si = (numtype(si[p]) > 0) ? 0 : si[p]
		ca = (numtype(ca[p]) > 0) ? 0 : ca[p]
		fe = (numtype(fe[p]) > 0) ? 0 : fe[p]
		ti = (numtype(ti[p]) > 0) ? 0 : ti[p]
		
		duplicate/o al $(frac+"IOM")
		wave iom = $(frac+"IOM")
		
		iom = 2.2*al + 2.49*si + 1.63*ca *2.42*fe + 1.94*ti
		
		iom_2st[][i] = iom[p]
		
	endfor
	
	
	setdatafolder sdf

End


Function xrf_create_best_7st_data()

	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:xrf

	string ion_list = xrf_cmp_list
	
	wave imp_start = :imp_2st:imp_starttime
	wave imp_stop = :imp_2st:imp_stoptime
	wave imp_samp = root:chemistry:icdata:imp9:imp_sample

	variable i,j,k

	// calculate relative nssSO4 dist for sub stages
	wave nss_7st = $("root:chemistry:icdata:imp9:nssSO4")
//	wave ic_totmass = $("root:chemistry:icdata:tot_icmass_7st")
	make/o/n=(numpnts(imp_samp)) nss_sub_tot
	wave nss_tot = nss_sub_tot
	duplicate/o nss_7st nss_7st_rel
	wave nss_rel = nss_7st_rel
	
	nss_tot = 0
	nss_tot = nss_7st[p][0] + nss_7st[p][1] + nss_7st[p][2] + nss_7st[p][3] 
	
	nss_rel = NaN
	nss_rel[][,3] = nss_7st[p][q]/nss_tot[p][q]
	
	// calculate relative SS dist for sup stages
	wave na_7st = $("root:chemistry:icdata:Na_7st")
	wave cl_7st = $("root:chemistry:icdata:Cl_7st")
	duplicate/o na_7st ss_7st
	wave ss = ss_7st
	ss = cl_7st + na_7st*1.47

	make/o/n=(numpnts(imp_samp)) ss_sup_tot
	wave ss_tot = ss_sup_tot
	duplicate/o ss ss_7st_rel
	wave ss_rel = ss_7st_rel
	
	ss_tot = 0
	ss_tot = ss[p][4] + ss[p][5] + ss[p][6] 
	
	ss_rel = NaN
	ss_rel[][4,] = ss[p][q]/ss_tot[p]
	
			
	for (i=0; i<itemsinlist(ion_list); i+=1)
		wave ion_2st = $(":imp_2st:"+stringfromlist(i,ion_list))
	
//		// create relative 7 st matrix
//		duplicate/o ion_7st $("relative_dist_"+stringfromlist(i,ion_list))
//		wave rel_dist = $("relative_dist_"+stringfromlist(i,ion_list))
		
//		variable j,k
//		variable tot = 0
//		for (j=0; j<numpnts(imp_samp); j+=1)
//			tot=0
//			// compute sub
//			for (k=0; k<4; k+=1)
//				tot+=ion_7st[j][k]
//			endfor
//			for (k=0; k<4; k+=1)
//				rel_dist[j][k] = ion_7st[j][k]/tot
//			endfor			
//
//			// compute sup
//			tot = 0
//			for (k=4; k<7; k+=1)
//				tot+=ic_totmass[j][k]
//			endfor
//			for (k=4; k<7; k+=1)
//				rel_dist[j][k] = ic_totmass[j][k]/tot
//			endfor			
//		endfor
		
		// create best 7st wave
		duplicate/o nss_7st $(stringfromlist(i,ion_list)+"_7st")
		wave ion = 	$(stringfromlist(i,ion_list)+"_7st")
		for (j=0; j<numpnts(imp_samp); j+=1)
			for (k=0; k<4; k+=1)
				ion[j][k] = ion_2st[j][0]*nss_rel[j][k]
			endfor			
			for (k=4; k<7; k+=1)
				ion[j][k] = ion_2st[j][1]*ss_rel[j][k]
			endfor	
		endfor		

		killwaves/Z rel_dist		
			
	endfor
	
	setdatafolder sdf
End

Function xrf_save_data_for_aerho()
	
	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:xrf

	string out_prefix = "Y:Data:Cruises:ICEALOT:chemistry:xrf:aerho:"	
	string ion_list = xrf_cmp_list
	
	wave imp_samp = root:chemistry:icdata:imp9:imp_sample

	variable i
	variable refNum
	for (i=0; i<itemsinlist(ion_list); i+=1)
		string cmpname = stringfromlist(i,ion_list)
		string fname = out_prefix+"icealot_"+LowerStr(cmpname)+"_7stage.txt"
		Open/Z=2 refNum as fname
		Variable err = V_flag
		
		if (err != 0)
			string err_msg = "Error saving to: icealot_"+LowerStr(stringfromlist(i,ion_list))+"_7stage.csv"
			DoAlert 0, err_msg
			return err
		endif
		
		//fprintf refNum, "This is a test\n"
		
		string buf = "ICEALOT:   "+cmpname+"\t\t\t\t\t\t\t\n"
		fprintf refNum, buf
		buf = "\tug/m3\tug/m3\tug/m3\tug/m3\tug/m3\tug/m3\tug/m3\n"
		fprintf refNum, buf
		buf = "Sample\t0.12\t0.24\t0.41\t0.76\t1.47\t2.89\t6.52\n"	
		fprintf refNum,	buf

		wave ion_data = $(cmpname+"_7st")
		duplicate/o ion_data ion_cleaned
		wave ion = ion_cleaned
		
		ion = (numtype(ion[p][q]) != 0) ? 0 : ion[p][q]
		
		variable j,k
		for (j=0; j<numpnts(imp_samp); j+=1)
			
			fprintf refNum, "%d\t", imp_samp[j]
			for (k=0; k<(dimsize(ion,1)); k+=1)
				fprintf refNum, "%g", ion[j][k]
				if (k < dimsize(ion,1)-1)
					fprintf refNum, "\t"
				endif
			endfor
			fprintf refNum, "\n"
		endfor
		
		Close refNum
		
		killwaves/Z ion
		
	endfor

	setdatafolder sdf

End

Function icdata_create_best_2st_icdata()

	string sdf = getdatafolder(1)
	setdatafolder  root:chemistry:icdata:imp1
		
	string ion_list = icdata_ion_list
	
//	wave imp_start = :raw:imp_starttime
	duplicate/o :raw:imp_starttime imp_starttime
//	wave imp_stop = :raw:imp_stoptime
	duplicate/o :raw:imp_stoptime imp_stoptime
//	wave imp_samp = :raw:imp_sample
	duplicate/o :raw:imp_number imp_sample

	variable i
	for (i=0; i<itemsinlist(ion_list); i+=1)

		if (waveexists($(":raw:imp1_"+stringfromlist(i,ion_list)+"_1")))
		
			wave sub = $(":raw:imp1_"+stringfromlist(i,ion_list)+"_1")
			wave sup = $(":raw:imp1_"+stringfromlist(i,ion_list)+"_2")
	
			make/o/n=(numpnts(sub),2) $(stringfromlist(i,ion_list)+"_2st")
			wave ion_2st = $(stringfromlist(i,ion_list)+"_2st")
		
			variable j
			for (j=0; j<numpnts(sub); j+=1)
				ion_2st[j][0] = sub[j]
				ion_2st[j][1] = sup[j]
			endfor
		endif
						
	endfor
		
	setdatafolder sdf

End

Function thermo_calc_final(isAmbient)
	variable isAmbient // 1 to use ambient data
	
	thermo_interp_totalWt(isAmbient)
	
	string sdf = getdatafolder(1)
	setdatafolder root:thermo
	if (isAmbient)
		setdatafolder ambient
	endif
	
	//get model params
	wave model_tw = totalWt_interp
	wave model_dens = :raw:density
	wave model_n_real = :raw:index
	wave model_n_imag = :raw:imaginary
	
	//get/set iom params
	//wave iom_tw = root:chemistry:xrf: IOM_7st  // uncomment and replace following when xrf
	wave iom_tw
	variable iom_dens = 2.75 // illite
	variable iom_n_real = 1.56
	variable iom_n_imag = 0.001
	
	duplicate/o model_dens density
	wave dens = density
	dens = (dens[p][q] < 0) ? NaN : dens[p][q]
	
	duplicate/o model_n_real index_real
	wave n_real = index_real
	n_real = (n_real[p][q] < 0) ? NaN : n_real[p][q]
	
	duplicate/o model_n_imag index_imag
	wave n_imag = index_imag
	n_imag = (n_imag[p][q] < 0) ? NaN : n_imag[p][q]
	
	dens = dens*(1 - (iom_tw/(iom_tw+model_tw))) +  iom_dens*(iom_tw/(iom_tw+model_tw))
	n_real = n_real*(1 - (iom_tw/(iom_tw+model_tw))) +  iom_n_real*(iom_tw/(iom_tw+model_tw))
	n_imag = n_imag*(1 - (iom_tw/(iom_tw+model_tw))) +  iom_n_imag*(iom_tw/(iom_tw+model_tw))
	
	setdatafolder sdf
	
End

Function thermo_interp_totalWt(isAmbient)
	variable isAmbient 
	
	string sdf = getdatafolder(1)
	setdatafolder root:thermo
	if (isAmbient)
		setdatafolder ambient
	endif
	
	wave tw_sparse = :raw:totalWt
	
	thermo_interp_param("", "",tw_sparse,"totalwt_interp")
	
//	duplicate/o tw_sparse totalwt_interp_rows
//	wave tw_rows = totalwt_interp_rows
//	tw_rows = (tw_rows[p][q] < 0) ? NaN : tw_rows[p][q]
//	
//	duplicate/o tw_sparse totalwt_interp_cols
//	wave tw_cols = totalwt_interp_cols
//	tw_cols = (tw_cols[p][q] < 0) ? NaN : tw_cols[p][q]
//	
//	duplicate/o tw_sparse totalwt_interp
//	wave tw_interp = totalwt_interp
//	
//	variable i,j,k
//	
//	make/o/n=(dimsize(tw_rows,1)) xwave
//	wave xw = xwave
//	xw = p
//	
//	make/o/n=(dimsize(tw_rows,0)) ywave
//	wave yw = ywave
//	yw = p
//	
//	// find totalWts by interpolating the rows
//	for (i=0; i<dimsize(tw_rows,0); i+=1)
//		
//		make/o/n=(dimsize(tw_rows,1)) a_row
//		wave row = a_row
//		
//		row = tw_rows[i][p]
//		
//		sizing_interp_nan_gap(xw, xw, row, "a_row_interp")
//		wave row_interp = $("a_row_interp")
//		
//		tw_rows[i][] = row_interp[q]	
//	
//	endfor	
//
//	// find totalWts by interpolating the cols
//	for (i=0; i<dimsize(tw_cols,1); i+=1)
//		
//		make/o/n=(dimsize(tw_cols,0)) a_col
//		wave col = a_col
//		
//		col = tw_cols[p][i]
//		
//		sizing_interp_nan_gap(yw, yw, col, "a_col_interp")
//		wave col_interp = $("a_col_interp")
//		
//		tw_cols[][i] = col_interp[p]	
//	
//	endfor	
//	
//	tw_interp = 0.67*tw_cols + 0.33*tw_rows
	setdatafolder sdf
End

Function thermo_interp_param(xwname, ywname,dat,output_name)
	string xwname
	string ywname
	wave dat
	string output_name

	duplicate/o dat dat_interp_rows
	wave dat_rows = dat_interp_rows
	dat_rows = (dat_rows[p][q] < 0) ? NaN : dat_rows[p][q]
	
	duplicate/o dat dat_interp_cols
	wave dat_cols = dat_interp_cols
	dat_cols = (dat_cols[p][q] < 0) ? NaN : dat_cols[p][q]

	
	// set or create xwave if needed
	variable create_flag=0
	if (cmpstr(xwname,"")==0 || !waveexists($xwname))
		make/o/n=(dimsize(dat_rows,1)) xwave
		xwname = "xwave"
		create_flag = 1
	endif
	
	wave xw = xwave
	if (create_flag)
		xw = p
	endif
	
	create_flag=0
	if (cmpstr(ywname,"")==0 || !waveexists($ywname))
		make/o/n=(dimsize(dat_rows,0)) ywave
		ywname = "ywave"
		create_flag = 1
	endif

	wave yw = ywave
	if (create_flag)
		yw = p
	endif
	
	// create output wave
	duplicate/o dat $output_name
	wave dat_interp = $output_name
	
	
	variable i,j,k
	
	// find totalWts by interpolating the rows
	for (i=0; i<dimsize(dat_rows,0); i+=1)
		
		make/o/n=(dimsize(dat_rows,1)) a_row
		wave row = a_row
		
		row = dat_rows[i][p]
		
		// *** CHECK THIS! next time you use it *** 
		//sizing_interp_nan_gap(xw, xw, row, "a_row_interp")
		acg_interp_nan_gap(row, "a_row_interp",xdata=xw)
		wave row_interp = $("a_row_interp")
		
		dat_rows[i][] = row_interp[q]	
	
	endfor	

	// find totalWts by interpolating the cols
	for (i=0; i<dimsize(dat_cols,1); i+=1)
		
		make/o/n=(dimsize(dat_cols,0)) a_col
		wave col = a_col
		
		col = dat_cols[p][i]
		
		// *** CHECK THIS! next time you use it *** 
		//sizing_interp_nan_gap(yw, yw, col, "a_col_interp")
		acg_interp_nan_gap(col, "a_col_interp",xdata=yw)
		wave col_interp = $("a_col_interp")
		
		dat_cols[][i] = col_interp[p]	
	
	endfor	
	
	dat_interp = 0.67*dat_cols + 0.33*dat_rows

	
	
End


Function thermo_calc_gf(gf_type)
	string gf_type // "dmps_to_samp", "samp_to_amb", "samp_to_dry"
	
	string sdf = getdatafolder(1)
	setdatafolder root:thermo
	
	string low_wname
	string high_wname
	string gf_outname = ""
	if (cmpstr(gf_type,"dmps_to_samp")==0)
		low_wname = ":dmps:raw:totalWt"
		high_wname = ":raw:totalWt"
		gf_outname = "gf_dmps_to_samp"
	elseif (cmpstr(gf_type,"samp_to_amb")==0)
		low_wname = ":raw:totalWt"
		high_wname = ":ambient:raw:totalWt"
		gf_outname = "gf_samp_to_amb"
	elseif (cmpstr(gf_type,"samp_to_dry")==0)
		low_wname = ":raw:totalWt"
		high_wname = ":dry:raw:totalWt"
		gf_outname = "gf_samp_to_dry"
	endif	

	wave low_tw = $low_wname
	wave high_tw = $high_wname
	
	wave iom = root:chemistry:xrf:IOM_7st
	
	newdatafolder/o/s gf
	
	thermo_interp_param("", "",low_tw,"totalwt_low_interp")
	wave low_twi = $("totalwt_low_interp")
	thermo_interp_param("", "",high_tw,"totalwt_high_interp")
	wave high_twi = $("totalwt_high_interp")
	
	duplicate/o iom tmp_iom
	wave tmp_iom 
	
	tmp_iom = (tmp_iom[p][q] < 0 || numtype(tmp_iom[p][q]) != 0) ? 0 : tmp_iom[p][q] 

	low_twi = low_twi + tmp_iom
	high_twi = high_twi + tmp_iom
	
	duplicate/o low_twi mass_ratio
	wave rat = mass_ratio
	
	rat = high_twi / low_twi
	
	duplicate/o low_twi $gf_outname
	wave gf = $gf_outname
	
	gf = 2 * ( 0.5^3 * rat )^(1/3)
		
	setdatafolder sdf
End

Function icdata_create_2st_from_7st()

	DFREF dfr = getdatafolderDFR()
	setdatafolder  root:
	newdatafolder/o/s chemistry
	newdatafolder/o/s icdata
	newdatafolder/o/s imp1

	// create times and samplenums
	duplicate/o ::imp9:imp_starttime imp_starttime
	duplicate/o ::imp9:imp_stoptime imp_stoptime
	duplicate/o ::imp9:imp_sample imp_sample
	
	string list = icdata_ion_list
	variable i
	for (i=0; i<itemsinlist(list); i+=1)
		wave imp9 = $("::imp9:"+stringfromlist(i,list))
		make/o/n=(dimsize(imp9,0),2) $(stringfromlist(i,list))
		wave imp1 = $(stringfromlist(i,list))
		imp1[][0] = imp9[p][0]+imp9[p][1]+imp9[p][2]+imp9[p][3]
		imp1[][1] = imp9[p][4]+imp9[p][5]+imp9[p][6]
	endfor
	setdatafolder dfr
End