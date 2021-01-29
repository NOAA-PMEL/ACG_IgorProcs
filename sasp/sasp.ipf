#pragma TextEncoding = "UTF-8"
#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Structure MetaData
	string proj_name // string list defining project/sub/sub  e.g., "NAAMES:Leg1"
	string location
	string id
	variable/D start_dt
	variable/D end_dt
EndStructure

// need a function to init this structure
Structure ReadData

	// variables
	variable rotrate
	variable short_gate
	variable long_gate
	variable npoints
	variable nhk  // unused?

	// lists and maps
	string wl_list // = "A;B;C;D"
	string pos_list //= "Lat;Lon"
	string mdy_list //= "Month;Day;Year"
	string orient_list //= "Yaw;Pitch;Roll"
	string barom_list //= "BaromPr;BaromTe"
	string solar_list //= "SolarZenithSh;SolarAzimuthsh"

	// waves 
	wave/wave photo_merge_array // Photo[A,B,C,D]Merge
	wave/wave azimuth_array            // Azimuth[A,B,C,D]
	wave udt
	wave home_p
	wave dt

	// housekeeping waves (fewer points)
	wave udt_of_hk
	wave te
	wave/wave pos_array //  pos_list = "Lat;Lon"
	wave/wave mdy_array        //  mdy_list = "Month;Day;Year"
	wave/wave orient_array     //  orient_list = "Yaw;Pitch;Roll"
	wave/wave barom_array   //  barom_list = "BaromPr;BaromTe"
	wave/wave solar_array      // solar_list = "SolarZenithSh;SolarAzimuthsh"
	wave udt_for_zenith
	wave mode_flag
	wave hk_photo_max
	wave hk_photo_avg
	wave dt_hk

EndStructure

Function sasp_init_ReadData(rd)
	STRUCT ReadData &rd
	
	rd.wl_list = "A;B;C;D"
	rd.pos_list = "Lat;Lon"
	rd.mdy_list = "Month;Day;Year"
	rd.orient_list = "Yaw;Pitch;Roll"
	rd.barom_list = "BaromPr;BaromTe"
	rd.solar_list = "SolarZenithSh;SolarAzimuthSh"
	
End

Structure SunPeakData
	variable npeaks
	wave peak_udt
	wave lo_indices
	wave hi_indices
	wave peak_type_flags	
Endstructure

Structure ProcessScanData
	wave mid_angles
	wave scan_avg
	wave nScan
	variable NearSunAngle
	variable RayleighOD
	variable RayleighGamma
	variable pressure
	variable SunElevMax
	variable AngleShift
	variable SideMatchFraction
	variable MinAngle
	variable MaxAngle
	wave FitParams
	wave FitSigmas
	variable FitMeasure
	variable FitStatus
	variable rayscat
endstructure		


Function sasp_readradiometer4e([proj_name, id, filename, skipstart, wavenamesuffix, unitnumber, readfrommerge, inpath, start_year])
	string proj_name // NAAMES:Leg1
	string id // flight number, test number
	string filename
	variable skipstart
	string wavenamesuffix
	variable unitnumber
	variable readfrommerge
	string inpath
	variable start_year // YYYY for start of datafile
	
	STRUCT MetaData md
	
	// Set default parameters
	if (ParamIsDefault(id))
		id = "no_id"
	endif
	md.id = id

	if (ParamIsDefault(proj_name))
		proj_name = "no_project"
	endif
	md.proj_name = proj_name
	
	if (ParamIsDefault(filename))
		filename = ""
	endif
	
	if (ParamIsDefault(skipstart))
		skipstart = 2000
	endif
	
	if (ParamIsDefault(wavenamesuffix))
		wavenamesuffix = ""
	endif
	
	if (ParamIsDefault(unitnumber))
		unitnumber = 0
	endif
	
	if (ParamIsDefault(readfrommerge))
		readfrommerge = 0
	endif
	
	if (ParamIsDefault(inpath))
		inpath = "" // don't know what to do with this yet
	endif

	if (ParamIsDefault(start_year)) // set to current year
		string ds = date()
		start_year = str2num(stringfromlist(2,ds,","))
	endif

	print "Starting to process data..."
	DFREF ref = sasp_goto_sasp_folder(proj_name=proj_name, id=id)
	
	// create struct for read data and init
	STRUCT ReadData rd
	sasp_init_ReadData(rd)
	
	// Constants
	make/o Wavelengths = {550.4, 460.3, 671.2, 860.7}   // decimals from curves on filters - same batch?
	make/o RayleighOD = {0.0972023, 0.202482, 0.0435789, 0.0158781} // at sea level zenith
	make/o Rayleighgamma = {1.471, 1.442, 1.413, 1.384}// Bucholtz
	Rayleighgamma = 0.01*Rayleighgamma
	// from estimateRayleigh.pro
	
	variable NearSunAngle = 4.32     //  angle for "near sun" value to subtract sky light (degrees to each side) typically 4 to 5
	variable NearSunFitAngle = 6.33 //  closest point of fitting scattered light to asymmetry parameter (degrees to each side) typically 6 to 9
	  // helpful if it matches a midpoint of AvgAngleLo, Hi below     
	variable MaxAvgDegrees = 2.2      // half width  Average n highest values within this of middle of peak to get max 
	variable nforMaxAvg = 5           // about 0.35 degree per value    
	 
	// averaging bins for scattering angle
	make/o/n=60 first = 2.5
//	first = 60
	make/o/n=20 second = 1.0
	make/o/n=30 third = 2./3.
	concatenate/o/NP=1 {first,second,third,second,first}, AvgAngleWidths

	duplicate/o AvgAngleWidths, AvgAngleHi, AvgAngleLo, MidAngles
	
	AvgAngleHi[0]  = -180 + AvgAngleWidths[0]
	AvgAngleHi[1,] = AvgAngleWidths[p] + AvgAngleHi[p-1]
	AvgAngleLo = AvgAngleHi[p] - AvgAngleWidths[p]
	MidAngles = 0.5*(AvgAngleLo[p] + AvgAngleHi[p])
	variable nAvgAngles = numpnts(AvgAngleLo)
	
//	AvgAngleWidths = {REPLICATE(2.5,60),REPLICATE(1.0,20),REPLICATE(2./3.,30),REPLICATE(1.0,20),REPLICATE(2.5,60)}
//	AvgAngleHi = -180 + TOTAL(AvgAngleWidths,/CUM)
//	AvgAngleLo = AvgAngleHi - AvgAngleWidths
//	MidAngles = 0.5*(AvgAngleLo + AvgAngleHi)
//	nAvgAngles = N_ELEMENTS(AvgAngleLo)	
	
//
// -------------------------------------- Read in Data -----------------------------------------
//
	if(readfrommerge)
		print "	Reading data from file..."
		sasp_readradiometerfile(rd, md, filename=filename, skipstart=skipstart, unitnumber=unitnumber, do_read_file="true", start_year=start_year)
//		OutFileName, rotrate, shortgate, longgate, npoints, nhk,  $  // scalar outputs
//		PhotoAMerge, PhotoBMerge, PhotoCMerge, PhotoDMerge, $        // array outputs
//		AzimuthA, AzimuthB, AzimuthC, AzimuthD, $
//		UDT,  Homep, $                                             // other outputs each data point
//		HKTime, te, lat, lon, Month, Day, Year, $                    // outputs each housekeeping point (fewer points)
//		Yaw, Pitch, Roll, BaromPr, BaromTe, SolarZenithsh, SolarAzimuthsh, UDTforZenith, $
//		ModeFlag, HKPhotoMax, HKPhotoAvg, $
//		INPATH = InPath, $
//		SUFFIX = Suffix, $   // this for input file
//		WRITEFILEFLAG = WriteFileFlag, OUTPUTPATH = OutputPath, $
//		WAVENAMESUFFIX = WaveNameSuffix  // for output files
	else
		// use data already read 
		print "	processing loaded data..."
		sasp_readradiometerfile(rd, md, do_read_file="false")
	endif
	//ENDIF ELSE BEGIN
	//  // read from already processed file
	//ENDELSE
	
//
// -------------------------------------- FIND SUN PEAKS -----------------------------------------
//
// find peaks in signal indicating sun 
//   useforThreshold is master but then find same peaks in other channels
//   set at "C" for now: 860 is cleanest wavelength but position can be a little off - different optics
//
//	UseForThreshold = 'C'
	
	string UseForThreshold = "C"
	wave SunPhoto = $("Photo"+UseForThreshold+"Merge")
	
//	CASE STRUPCASE(UseForThreshold) OF
//	  'A': SunPhoto = PhotoAMerge
//	  'B': SunPhoto = PhotoBMerge
//	  'C': SunPhoto = PhotoDMerge
//	  'D': SunPhoto = PhotoDMerge
//	  ELSE: STOP
//	ENDCASE
	
	make/o/n=200 histInSunPhoto=NaN
	duplicate/o SunPhoto, tmpSunphoto
	tmpSunPhoto = (tmpSunPhoto[p] > 10.0) ? tmpSunPhoto[p] : NaN
	tmpSunPhoto = ln(SunPhoto[p])
	histogram/B=2 tmpSunPhoto, histInSunPhoto
	duplicate/o histInSunPhoto, HistBins
//	print wavemax(tmpSunPhoto), wavemin(tmpSunPhoto)
	variable binSize = (wavemax(tmpSunPhoto)-wavemin(tmpSunPhoto)) / (numpnts(histInSunPhoto)-1)
	HistBins = wavemin(tmpSunPhoto) + p*binSize
	Reverse histInSunPhoto/D=CumHist
	CumHist[1,] = CumHist[p] + CumHist[p-1]
	
	make/o/n=0 $"SunPhoto95"
	wave SunPhoto95 = $"SunPhoto95"
	
	variable row
	variable nOver95 = 0
	for (row=0; row<numpnts(SunPhoto95); row+=1)
		if (CumHist[row] >= (0.5*numpnts(SunPhoto)))							 
			 sasp_append_to_wave(SunPhoto95, row)
			 nOver95 += 1
		endif
	endfor
	
	variable PercentilePt = EXP(HistBins[nOver95])
	variable SunThresholdMerge = PercentilePt
	
	STRUCT SunPeakData spd
	
	print "	finding peaks..."
	sasp_find_sun_peaks(SunPhoto, rd.UDT, SunThresholdMerge, spd, rotrate=rd.rotrate, \
						  timespacing=(rd.short_gate+rd.long_gate), \
						  max_width_angle=9.0, closest_above=30.0, gap_angle=600.0)
	
	duplicate/o spd.peak_udt, $"PeakUDT"
	duplicate/o spd.lo_indices, MidIndices
	MidIndices = ROUND(0.5*(spd.lo_indices[p] + spd.hi_indices[p]))
	
	print "	processing each peak..."
	//
	// -------------------------------------- CALCULATIONS FOR EACH MAXIMUM ---------------------------------------
	//
	//
	// information about maxima such as time, lat, lon, sun elevation
	//
	variable ishort = numpnts(rd.udt_of_hk)
	if (spd.npeaks > 0)
		variable lastUDTofHK = rd.udt_of_hk[ishort-1]-0.0001
		make/o/n=0 LatMax, LonMax, PrMax
		make/o/D/n=0 sasp_dt_max
		variable rows
		for (rows=0; rows<numpnts(spd.peak_udt); rows+=1)
			if (spd.peak_udt[rows] < lastUDTofHK)
				
				variable result = interp(spd.peak_udt[rows], rd.udt_of_hk, rd.pos_array[whichlistitem("Lat",rd.pos_list)])
				sasp_append_to_wave(LatMax, result)
				
				result = interp(spd.peak_udt[rows], rd.udt_of_hk, rd.pos_array[whichlistitem("Lon",rd.pos_list)])
				sasp_append_to_wave(LonMax, result)

				result = interp(spd.peak_udt[rows], rd.udt_of_hk, rd.barom_array[whichlistitem("BaromPr",rd.barom_list)])
				sasp_append_to_wave(PrMax, result)

				result = interp(spd.peak_udt[rows], rd.udt_of_hk, rd.dt_hk)
				sasp_append_to_wave(sasp_dt_max, result)

			endif
		endfor

		duplicate/o rd.orient_array[whichlistitem("Yaw",rd.orient_list)], YawX, YawY
		YawX = sin(rd.orient_array[whichlistitem("Yaw",rd.orient_list)]*(pi/180))
		YawY = cos(rd.orient_array[whichlistitem("Yaw",rd.orient_list)]*(pi/180))

		make/o/n=0 YawXEvery, YawYEvery, UDTforInterp
		make/o/n=0 SolarZenith, SolarAzimuth
		for (row=0; row<numpnts(rd.udt); row+=1)
			if (rd.udt[row]<lastUDTofHK && rd.udt[row]>rd.udt_of_hk[0])
				
				sasp_append_to_wave(UDTforInterp, rd.udt[row])
				
				result = interp(rd.udt[row], rd.udt_of_hk, YawX)
				sasp_append_to_wave(YawXEvery, result)
				
				result = interp(rd.udt[row], rd.udt_of_hk, YawY)
				sasp_append_to_wave(YawYEvery, result)

				result = interp(rd.udt[row], rd.udt_of_hk, YawY)
				sasp_append_to_wave(YawYEvery, result)

//				wave sz = rd.solar_array[whichlistitem("SolarZenithSh",rd.solar_list)]
				result = interp(rd.udt[row], rd.udt_for_zenith, rd.solar_array[whichlistitem("SolarZenithSh",rd.solar_list)])
//				print rd.udt[rows], result, sz[rows
				sasp_append_to_wave(SolarZenith, result)

				result = interp(rd.udt[row], rd.udt_for_zenith, rd.solar_array[whichlistitem("SolarAzimuthSh",rd.solar_list)])
				sasp_append_to_wave(SolarAzimuth, result)
				
			endif
		endfor
		duplicate/o YawXEvery, YawEvery
		YawEvery = atan(YawXEvery[p]/YawYEvery[p])/(pi/180)
		duplicate/o MidIndices, YawMax
		YawMax = YawEvery[MidIndices[p]]
		
		duplicate/o MidIndices, SunElevMax, SunAzMax
		SunElevMax = 90.0 - SolarZenith[MidIndices[p]]		
		SunAzMax = SolarAzimuth[MidIndices[p]]		

		make/o/n=(spd.npeaks) LoScanIndices, HiScanIndices
		make/o/n=(spd.npeaks, 4) SunMax, SunAvgMax, NearSun
		make/o/n=(spd.npeaks, 4, nAvgAngles) AvgPhoto,AvgPhoto_sd, AvgAzimuth
		make/o/n=(spd.npeaks, nAvgAngles) AvgScatAngle, AvgRelazAngle//, AvgAzimuthA, AvgAzimuthB, AvgAzimuthC, AvgAzimuthD
		make/o/n=(spd.npeaks, nAvgAngles) nAvgAngle
		
		//
		// relative azimuth, interpolated sky radiance in sun, 
		//
		duplicate/o SolarAzimuth, relazimuth, scatangle
		relazimuth = 500
		scatangle = 500
//		relazimuth = SolarAzimuth*0+500. // sizes array and fills with value larger than 180 degrees.
//		scatangle = relazimuth
		variable n180 = ceil(180./(rd.rotrate*(rd.short_gate + rd.long_gate)))
		variable nlook = 2*n180+1
		variable near1sub=0, near2sub=0
		duplicate/o MidAngles, tmpAngles
		tmpAngles = abs(MidAngles[p]-NearSunAngle)
		variable aa = min(wavemin(tmpAngles), near1sub)
		tmpAngles = abs(MidAngles[p]+NearSunAngle)
		aa = min(wavemin(tmpAngles), near2sub)
		
		variable ipk
		for (ipk=0; ipk<spd.npeaks; ipk+=1)
			
			variable loindx = ((midindices[ipk] - n180) > 0) ?  (midindices[ipk] - n180) : 0
			variable tipts = (nlook < (rd.npoints-(loindx+1))) ? nlook : (rd.npoints-(loindx+1))
			make/o/n=(tipts) theseindices
			theseindices = loindx + p
			make/o/n=(numpnts(theseindices)) localyaw, localrelaz, prevrelaz
			for (rows=0; rows<numpnts(theseindices); rows+=1)
				if (theseindices[rows] >= numpnts(YawEvery))
					localyaw[rows] = localyaw[rows-1]
				else 
					localyaw = YawEvery[theseindices[rows]] - YawEvery[MidIndices[ipk]]
				endif
			endfor
			localrelaz = (rd.UDT[theseindices[p]] - spd.peak_udt[ipk])*(3600.*rd.rotrate)
			for (rows=0; rows<numpnts(theseindices); rows+=1)
				if (theseindices[rows] >= numpnts(relazimuth))
					prevrelaz[rows] = prevrelaz[rows-1]
				else 
					prevrelaz = relazimuth[rows]  // fix nans
				endif
			endfor
			
			make/o/n=0 smaller
			for (rows=0; rows<numpnts(localrelaz); rows+=1)
				if  (abs(localrelaz[rows]) < (abs(prevrelaz[rows]) < 180.))
					sasp_append_to_wave(smaller, rows)
				endif
			endfor
			
			variable coszenith = sin(SunElevMax[ipk]*((pi/180)*1.0))   // sin and cos reversed for elevation versus zenith
			variable sinzenith = cos(SunElevMax[ipk]*((pi/180)*1.0))
			if (numpnts(smaller)>0)
				print numpnts(smaller)
				make/o/n=(numpnts(smaller)) theserelaz, arrayindices
				for (rows=0; rows<numpnts(smaller); rows+=1)
					theserelaz = localrelaz[smaller[rows]]
					arrayindices = theseindices[smaller[rows]]
//					relazimuth[arrayindices[rows]] = theserelaz[rows]
				endfor
 
//				make/o/n=(numpnts(theserelaz)) signangle, thesescatangle
//				signangle = 2.0*(theserelaz[p] > 0.0) - 1.0
//				// equation 2 Box and Deepak 1981:
//				thesescatangle = (signangle[p]/(pi/180))*ACOS(coszenith*coszenith + sinzenith*sinzenith*cos(theserelaz[p]*(pi/180)))
//				scatangle[arrayindices[p]] = thesescatangle[p]
			else
			
				// removed "smaller" calcs. Just using peak angles at the moment
//				make/o/n=(spd.hi_indices[ipk]-spd.lo_indices[ipk]+1) theserelaz, arrayindices
				duplicate/o localrelaz, theserelaz
				duplicate/o theseindices, arrayindices
//				arrayindices = p+spd.lo_indices[ipk]
//				theserelaz = (rd.UDT[arrayindices[p]] - spd.peak_udt[ipk])*(3600.*rd.rotrate)
				//relazimuth[arrayindices[ipk]] = theserelaz[ipk]
			endif
			wave theserelaz = $"theserelaz"
			wave thesescanangle = $"thesescatangle"
			make/o/n=(numpnts(theserelaz)) signangle, thesescatangle
			signangle = 2.0*(theserelaz[p] > 0.0) - 1.0
			thesescatangle = (signangle[p]/(pi/180))*ACOS(coszenith*coszenith + sinzenith*sinzenith*cos(theserelaz[p]*(pi/180)))
			//scatangle[arrayindices[ipk]] = thesescatangle[ipk]


//			wave thescatangle = $"thescatangle"
//			wave arrayindices = $"arrayindices"
			
			// --- changing things here...using max of peak for SunAvgMax and SunMax, avg of peak for AvgPhoto and AvgAzimuth
			//     --- also, skipping the iangle dependence for now...
			
			variable wli
			for (wli=0; wli<itemsinlist(rd.wl_list); wli+=1)
				wavestats/Q/R=[spd.lo_indices[ipk],spd.hi_indices[ipk]] rd.photo_merge_array[wli]
				SunAvgMax[ipk][wli] = V_max
				SunMax[ipk][wli] = V_max
				variable iangle
				for (iangle=0; iangle<nAvgAngles; iangle+=1)
				
					make/o/n=0 InRange
					for (rows=0; rows<numpnts(thesescatangle); rows+=1)
						if (thesescatangle[rows] >= AvgAngleLo[iangle] && thesescatangle[rows] < AvgAngleHi[iangle])
							sasp_append_to_wave(InRange, rows)
						endif
					endfor
					if (numpnts(InRange)>0)
						variable lo = arrayindices[0]
						variable hi = arrayindices[numpnts(arrayindices)-1]
						wavestats/Q/R=[lo,hi] rd.photo_merge_array[wli]
						AvgPhoto[ipk][wli][iangle] = V_avg
						AvgPhoto_sd[ipk][wli][iangle] = V_sdev

						wavestats/Q/R=[lo,hi] rd.azimuth_array[wli]
						AvgAzimuth[ipk][wli][iangle] = V_avg
						
						nAvgAngle[ipk][iangle] = numpnts(InRange)
						
						if (wli==0)
							//wavestats/Q/R=[lo,hi] thesescatangle
							wavestats/Q thesescatangle
							AvgScatAngle[ipk][iangle] = V_avg
						endif
					endif
				endfor				
				
				NearSun[ipk][wli] = 0.5*(AvgPhoto[ipk][wli][near1sub] + AvgPhoto[ipk][wli][near2sub])

			endfor
			

//			notclose = WHERE(ABS(relazimuth) GT 200., nnotclose)
//			if nnotclose GT 0 THEN BEGIN
//			relazimuth[notclose] = !VALUES.F_NAN
//			scatangle[notclose] = !VALUES.F_NAN
//			ENDIF
				
		endfor
	
		// ProcessScan

		duplicate/o SunMax, rayscat_max, aod_max
		rayscat_max = NaN
		aod_max = NaN
		
		STRUCT ProcessScanData psd
		for (rows=0; rows<spd.npeaks; rows+=1)
				make/o/n=(dimsize(AvgScatAngle,1)) $"TheseAngles"
				wave psd.mid_angles = $"TheseAngles"
				psd.mid_angles = AvgScatAngle[rows][p]
	
				make/o/n=(dimsize(nAvgAngle,1)) $"thesen"
				wave psd.nScan = $"thesen"
				psd.nScan = nAvgAngle[rows][p]

			for (wli=0; wli<itemsinlist(rd.wl_list); wli+=1)			
			
				make/o/n=(dimsize(AvgPhoto,2)) $"tmpAvgPhoto"
				wave psd.scan_avg = $"tmpAvgPhoto"
				psd.scan_avg = AvgPhoto[rows][wli][p]
				
				psd.RayleighOD = RayleighOD[wli]
				psd.RayleighGamma = RayleighGamma[wli]
				
				psd.pressure = PrMax[rows]
				psd.SunElevMax = SunElevMax[rows]
			
				sasp_process_scan(psd)
			
				rayscat_max[rows][wli] = psd.rayscat 
			endfor
				
			
		
		endfor
		aod_max = -(ln(SunMax[p][q]) - (rayscat_max[p][q]))	
	endif
	
	// make some waves for plotting
	duplicate/o SunElevMax, LangleyMax, Press_AM
	make/o/n=(numpnts(SunElevMax), itemsinlist(rd.wl_list)) lnMax
	
	for (wli=0; wli<itemsinlist(rd.wl_list); wli+=1)
		lnMax[][wli] = ln(SunAvgMax[p][wli] - NearSun[p][wli])
	endfor
	LangleyMax = 1.0/cos((90.0 - SunElevMax[p])*pi/180.)
	
	Press_AM = PrMax[p]/100*LangleyMax[p]
	
	sasp_make_rayleigh(Press_AM, proj_name=proj_name, id=id)
	
//	// quick and dirty peak photo values
//	string wl_list = rd.wl_list
//	variable npeaks = spd.npeaks
//	make/o/n=(npeaks) sza_avg
//	for (wli=0; wli<itemsinlist(wl_list); wli+=1)
//		make/o/n=(npeaks) $("photo_avg_"+stringfromlist(wli,wl_list)), $("photo_sd_"+stringfromlist(wli,wl_list)), $("ln_photo_avg_"+stringfromlist(wli,wl_list))
//		wave photo_avg = $("photo_avg_"+stringfromlist(wli,wl_list))
//		wave photo_sd = $("photo_sd_"+stringfromlist(wli,wl_list))
//		wave ln_photo_avg = $("ln_photo_avg_"+stringfromlist(wli,wl_list))
//	
//		variable peaki
//		for (peaki=0; peaki<npeaks; peaki+=1)
//			variable start_index = spd.lo_indices[peaki]
//			variable end_index = spd.hi_indices[peaki]
//			
//			wavestats/Q/R=[start_index,end_index] rd.photo_merge_array[wli]
//			photo_avg[peaki] = V_avg
//			photo_sd[peaki] = V_sdev
//
//			wavestats/Q/R=[start_index,end_index] $"SolarZenith"
//			sza_avg[peaki] = V_avg
//		endfor
//		ln_photo_avg = ln(photo_avg[p])
//	endfor
//	duplicate/o sza_avg, air_mass_factor
//	air_mass_factor = 1 / cos(sza_avg[p]*(pi/180))
//	air_mass_factor = (air_mass_factor[p]<0) ? NaN : air_mass_factor[p]
	
	print "done."
	setdatafolder ref
End

Function/DF sasp_goto_sasp_folder([proj_name, id])
	string proj_name
	string id
	
	if (ParamIsDefault(proj_name) || cmpstr(proj_name,"")==0)
		proj_name = "no_project"
	endif
 
 	if (ParamIsDefault(id) || cmpstr(id,"")==0)
		id = "no_id"
	endif

	DFREF ref = getdataFolderDFR()
	setdatafolder root:
	newdatafolder/o/s sasp
	
	variable pri 
	for (pri=0; pri<itemsinlist(proj_name, ":"); pri+=1)
		newdatafolder/o/s $(stringfromlist(pri, proj_name, ":"))
	endfor	
	newdatafolder/o/s $id
	
	return ref
End


Function sasp_readradiometerfile(rd, md, [filename, skipstart, UnitNumber, do_read_file, start_year])
	STRUCT ReadData &rd
	STRUCT MetaData &md
	string filename
	variable skipstart
	variable UnitNumber
	string do_read_file
	variable start_year
	
	// Set default parameters
	if (ParamIsDefault(filename))
		filename = ""
	endif
	
	if (ParamIsDefault(skipstart))
		skipstart = 2000
	endif
	
	if (ParamIsDefault(UnitNumber))
		UnitNumber = 0
	endif

	if (ParamIsDefault(do_read_file))
		do_read_file = "true"
	endif

	if (ParamIsDefault(start_year))
		start_year = str2num(stringfromlist(2,date(),","))
	endif

	DFREF ref = sasp_goto_sasp_folder(proj_name=md.proj_name, id=md.id)
			
	//  constants for reading and interpreting file
	//
	variable rotationrate = 5194.8    // ms per radian, see unit number statements below
	variable millisscale = 10.        // factor in Arduino print statement
	UnitNumber = 25          // should put in inputs, put unit-specific information here
	// UnitNumber for Cyprus unit is 20+number written on board in marker (e.g. 23 if three on board)
	//
	//
	variable nlong = 50000    // maximum number of lines in a SASP file
	// 9 hours is about a million points
	variable nshort = nlong/20
	variable HiThres = 10000      // when to transition from long to short gate (raw units)  // 6000L
	variable RollingPts = 49      // number of points to sample max and average on ishort
	//   nominal is HK comes around every 49
	//
	// defaults below will be overwritten with data from SASP file
	//
	variable pressure = 819E2
//	variable Year = start_year
	
	variable/G ConstOffsetA = 40.  // take out guess at zero offset, makes plots a little cleaner, tiny effect on Rayleigh calculations
	variable/G ConstOffsetB = 40.
	variable/G ConstOffsetC = 40.
	variable/G ConstOffsetD = 40.	

	switch (UnitNumber)
	    case 25:
	    ConstOffsetA = 40.  // here is where to put dark current measurements
	    ConstOffsetB = 40.
	    ConstOffsetC = 40.
	    ConstOffsetD = 40.
	    // from night or covered data
	    break
	    default:
	    	break
	endswitch

	variable rotrate = 1000./(rotationrate*(pi/180.))

	if (cmpstr(do_read_file,"true")==0) // do actual file read, else just poplulate the ReadData structure

		//PhotoA = zeros(1, nlong);   // long gate
		//PhotoAsh = PhotoA;        // short gate
		
		variable wi
		// Fix to make things easier to work with...
	
		// maps for waves
		string case_map = ""
	
		// main waves
		string main_list = "PhotoAsh;PhotoBsh;PhotoCsh;PhotoDsh;PhotoA;PhotoB;PhotoC;PhotoD;Seconds"
		make/WAVE/o/n=(itemsinlist(main_list)) main_waves
		wave/WAVE main = main_waves
		for (wi=0; wi<itemsinlist(main_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,main_list))
			main[wi] = $(stringfromlist(wi,main_list))
		endfor
	
		// pos waves
		string pos_list = "azimuth;homep;MicroUsed"
		make/WAVE/o/n=(itemsinlist(pos_list)) pos_waves
		wave/WAVE pos = pos_waves
		for (wi=0; wi<itemsinlist(pos_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,pos_list))
			pos[wi] = $(stringfromlist(wi,pos_list))
		endfor
		case_map = replacestringbykey("0", case_map, "pos_waves")
	
		// nav waves
		string nav_list = "Lat;Lon;Te"
		make/WAVE/o/n=(itemsinlist(nav_list)) nav_waves
		wave/WAVE nav = nav_waves
		for (wi=0; wi<itemsinlist(nav_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,nav_list))
			nav[wi] = $(stringfromlist(wi,nav_list))
		endfor
		case_map = replacestringbykey("1", case_map, "nav_waves")
	
		// gpstime waves
		string gpstime_list = "GPSHr;GPSReadSeconds;MonthDay;HKSeconds"
		make/WAVE/o/n=(itemsinlist(gpstime_list)) gpstime_waves
		wave/WAVE gpstime = gpstime_waves
		for (wi=0; wi<itemsinlist(gpstime_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,gpstime_list))
			gpstime[wi] = $(stringfromlist(wi,gpstime_list))
		endfor
		case_map = replacestringbykey("2", case_map, "gpstime_waves")
	
		// orient waves
		string orient_list = "Yaw;Pitch;Roll"
		make/WAVE/o/n=(itemsinlist(orient_list)) orient_waves
		wave/WAVE orient = orient_waves
		for (wi=0; wi<itemsinlist(orient_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,orient_list))
			orient[wi] = $(stringfromlist(wi,orient_list))
		endfor
		case_map = replacestringbykey("3", case_map, "orient_waves")
		
		// baro waves
		string baro_list = "BaromPr;BaromTe;ModeFlag"
		make/WAVE/o/n=(itemsinlist(baro_list)) baro_waves
		wave/WAVE baro = baro_waves
		for (wi=0; wi<itemsinlist(baro_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,baro_list))
			baro[wi] = $(stringfromlist(wi,baro_list))
		endfor
		case_map = replacestringbykey("4", case_map, "baro_waves")
	
		// gate waves
		string gate_list = "GateLgArr;GateShArr;PhotoOffArr"
		make/WAVE/o/n=(itemsinlist(gate_list)) gate_waves
		wave/WAVE gate = gate_waves
		for (wi=0; wi<itemsinlist(gate_list); wi+=1)
			make/o/n=0 $(stringfromlist(wi,gate_list))
			gate[wi] = $(stringfromlist(wi,gate_list))
		endfor
		case_map = replacestringbykey("5", case_map, "gate_waves")
	
		make/o/n=0 $"GPSTimeIndices"
	
		make/o/n=4 $"RollingArray"
		wave RollingArray = $"RollingArray"
		RollingArray = RollingPts
	
		variable refNum
		Open/R refnum as filename
		if (refNum == 0)
			return -1
		endif
//		filename = stringfromlist(itemsinlist(S_fileName,":")-1,S_fileName,":")
//		filename = stringfromlist(0,filename, ".")
//		newdatafolder/o/s $filename
		
		String buffer=""
		string line
		variable skip_cnt = 0
		variable index = 0
		do
			
			FReadLine refNum, line
			if (strlen(line) == 0)
				break
			endif
			if (skip_cnt < skipstart)
				skip_cnt += 1
				continue
			endif
					
			 if ( (cmpstr(line[0],"$") != 0) && (itemsinlist(line,",")==13) ) // Bad strings start with "$" and complete  lines need 13 values
			 	
			 	line = trimString(line)
			 	
			 	variable listi
			 	for (listi=0; listi<itemsinlist(main_list); listi+=1)
			 		wave w = main[listi]
			 		sasp_append_to_wave(w, str2num(stringfromlist(listi, line, ",")))
			 	endfor
			 	
	//		 	PhotoAsh[index] = str2num(stringfromlist(0, line, ","))
	//		 	PhotoBsh[index] = str2num(stringfromlist(1, line, ","))
	//		 	PhotoCsh[index] = str2num(stringfromlist(2, line, ","))
	//		 	PhotoDsh[index] = str2num(stringfromlist(3, line, ","))
	//
	//		 	PhotoA[index] = str2num(stringfromlist(4, line, ","))
	//		 	PhotoB[index] = str2num(stringfromlist(5, line, ","))
	//		 	PhotoC[index] = str2num(stringfromlist(6, line, ","))
	//		 	PhotoD[index] = str2num(stringfromlist(7, line, ","))
	//		 	
	//		 	Seconds[index] = str2num(stringfromlist(8, line, ","))
	
			 	variable caseflag = str2num(stringfromlist(9, line, ","))
				if (caseflag<0 || caseflag>5)
					continue
				endif
				
				variable offset = 10
				if (caseflag == 0)
		
				 	for (listi=0; listi<itemsinlist(pos_list); listi+=1)
				 		wave w = pos[listi]
				 		sasp_append_to_wave(w, str2num(stringfromlist(listi+offset, line, ",")))
				 	endfor
					
	//			 	azimuth[index] = str2num(stringfromlist(10, line, ","))
	//			 	homep[index] = str2num(stringfromlist(11, line, ","))
	//			 	MicroUsed[index] = str2num(stringfromlist(12, line, ","))
					
				else
				
				 	for (listi=0; listi<itemsinlist(pos_list); listi+=1)
				 		wave w = pos[listi]
				 		sasp_append_to_wave(w, NaN)
				 	endfor
					wave mu = $"MicroUsed"
					mu[numpnts(mu)-1] = mu[max(0,numpnts(mu)-1)]
					
	//				azimuth[index] = NaN;
	//			        homep[index] =  NaN;
	//			        MicroUsed[index] = MicroUsed[max(0,index-1)];
				        
	//			        if (caseflag == 1)
	//					Lat[index] = str2num(stringfromlist(10, line, ","))
	//					Lon[index] = str2num(stringfromlist(12, line, ","))
	//					Te[index] = str2num(stringfromlist(13, line, ","))
	//	
	////				          ione = ione + 1;
				        if (caseflag == 2)
	//			        		if (index>3000)
	//			        			print "here"
	//			        		endif
				        		sasp_append_to_wave($"GPSHr", str2num(stringfromlist(10, line, ",")))
				        		sasp_append_to_wave($"MonthDay", str2num(stringfromlist(11, line, ",")))
				        		sasp_append_to_wave($"GPSReadSeconds", (str2num(stringfromlist(12, line, ","))/100.0))
				        		wave w = $"Seconds"			        		
				        		sasp_append_to_wave($"HKSeconds", w[numpnts(w)-1])
				        		sasp_append_to_wave($"GPSTimeIndices", numpnts($"GPSTimeIndices"))
	
	//					GPSHr[index] = str2num(stringfromlist(10, line, ","))
	//					MonthDay[index] = str2num(stringfromlist(12, line, ","))
	//					GPSReadSeconds[index] = str2num(stringfromlist(13, line, ","))/100.0
	//					HKSeconds[index] = Seconds[index];
	//					GPSTimeIndices[index] = index;
	
					else // no more special parsing
						wave/wave ww = $(stringbykey(num2str(caseflag), case_map))
					 	for (listi=0; listi<itemsinlist(pos_list); listi+=1)
					 		wave w = ww[listi]
					 		sasp_append_to_wave(w, str2num(stringfromlist(listi+offset, line, ",")))
					 	endfor
					
					endif
	//				          GPSHr(itwo) = nums(11);
	//          MonthDay(itwo) = nums(12);
	//          GPSReadSeconds(itwo) = nums(13)/100;
	//          HKSeconds(itwo) = Seconds(ii);
	//          GPSTimeIndices(itwo) = ii;
	//          itwo = itwo + 1;
	//				elseif (caseflag == 3)
	//					Yaw[index] = str2num(stringfromlist(10, line, ","))
	//					Pitch[index] = str2num(stringfromlist(12, line, ","))
	//					Roll[index] = str2num(stringfromlist(13, line, ","))
	////					ithree = ithree + 1;
	//				elseif (caseflag == 4)
	//					BaromPr[index] = str2num(stringfromlist(10, line, ","))
	//					BaromTe[index] = str2num(stringfromlist(12, line, ","))
	//					ModeFlag[index] = str2num(stringfromlist(13, line, ","))
	////					ifour = ifour + 1;
	//				elseif (caseflag == 5)
	//					GateLgArr[index] = str2num(stringfromlist(10, line, ","))
	//					GateShArr[index] = str2num(stringfromlist(12, line, ","))
	//					PhotoOffArr[index] = str2num(stringfromlist(13, line, ","))
	////					ifive = ifive + 1;
	//				endif																														
				
				endif
				
	//			PhotoAsh(ii) = nums(1);
	//			PhotoBsh(ii) = nums(2);
	//			PhotoCsh(ii) = nums(3);
	//			PhotoDsh(ii) = nums(4);
	//			PhotoA(ii)   = nums(5);
	//			PhotoB(ii)   = nums(6);
	//			PhotoC(ii)   = nums(7);
	//			PhotoD(ii)   = nums(8);
	//			Seconds(ii)  = nums(9);
	//			caseflag = nums(10);
						 
			 endif
			 
			 index += 1
		while (1)
		
		close refNum
	
		// clean up bad data
		variable/D maxposs = 2^20
		string wlist = "PhotoA;PhotoB;PhotoC;PhotoD" 
		for (listi=0; listi<itemsinlist(wlist); listi+=1)
			wave w = $(stringfromlist(listi, wlist)) // this uses "find" in matlab code but I think this does the same thing
			w = (w[p] > maxposs) ? 0 : w[p]
		endfor
		
		// emulates following "find" command (to reduce all waves?)
			//usethese = find((PhotoA >= 0) & (PhotoB >= 0) & (PhotoC >= 0) & (PhotoD >= 0) ...
			//  & (PhotoA < maxposs) & (PhotoB < maxposs) & (PhotoC < maxposs) & (PhotoD < maxposs)  ...
			//  & (PhotoAsh < maxposs) & (PhotoBsh < maxposs) & (PhotoCsh < maxposs) & (PhotoDsh < maxposs) ...
			//  & ((PhotoA+PhotoB+PhotoC+PhotoD) ~= 0));	
	
			// extract/INDX src, dest, logical_ex  <-- line matlab "find" 
	
		make/o/n=0 $"usethese"
		wave usethese = $"usethese"
		
		variable row
		for (row=0; row<numpnts($"PhotoA"); row+=1)
	
	//		print whichlistitem("PhotoA",main_list), row, sasp_get_wval_at_index(main, main_list, "PhotoA", row)
			if ( sasp_get_wval_at_index(main, main_list, "PhotoA", row) >= 0 &&  sasp_get_wval_at_index(main, main_list, "PhotoB", row) >= 0 &&  \
			     sasp_get_wval_at_index(main, main_list, "PhotoC", row) >= 0 &&  sasp_get_wval_at_index(main, main_list, "PhotoD", row) >= 0 &&  \
			     sasp_get_wval_at_index(main, main_list, "PhotoA", row) < maxposs &&  sasp_get_wval_at_index(main, main_list, "PhotoB", row) < maxposs &&  \
			     sasp_get_wval_at_index(main, main_list, "PhotoC", row) < maxposs &&  sasp_get_wval_at_index(main, main_list, "PhotoD", row) < maxposs &&  \
			     sasp_get_wval_at_index(main, main_list, "PhotoAsh", row) < maxposs &&  sasp_get_wval_at_index(main, main_list, "PhotoBsh", row) < maxposs &&  \
			     sasp_get_wval_at_index(main, main_list, "PhotoCsh", row) < maxposs &&  sasp_get_wval_at_index(main, main_list, "PhotoDsh", row) < maxposs &&  \
			     ( sasp_get_wval_at_index(main, main_list, "PhotoA", row) + sasp_get_wval_at_index(main, main_list, "PhotoB", row) +  \
			       sasp_get_wval_at_index(main, main_list, "PhotoC", row) +  sasp_get_wval_at_index(main, main_list, "PhotoD", row) ) != 0 )   
	//		main[whichlistitem("PhotoA",main_list)][row] > 0 && main[whichlistitem("PhotoB",main_list)][row] > 0 && \
	//			main[whichlistitem("PhotoC",main_list)][row] > 0 && main[whichlistitem("PhotoD",main_list)][row] > 0 && \
	//			main[whichlistitem("PhotoA",main_list)][row] < maxposs && main[whichlistitem("PhotoB",main_list)][row] < maxposs && \
	//			main[whichlistitem("PhotoC",main_list)][row] < maxposs && main[whichlistitem("PhotoD",main_list)][row] < maxposs && \
	//			main[whichlistitem("PhotoAsh",main_list)][row] < maxposs && main[whichlistitem("PhotoBsh",main_list)][row] < maxposs && \
	//			main[whichlistitem("PhotoCsh",main_list)][row] < maxposs && main[whichlistitem("PhotoDsh",main_list)][row] < maxposs && \
	//			(main[whichlistitem("PhotoA",main_list)][row] + main[whichlistitem("PhotoB",main_list)][row] + \
	//			 main[whichlistitem("PhotoC",main_list)][row] + main[whichlistitem("PhotoD",main_list)][row]) != 0 )
				 
				 sasp_append_to_wave(usethese, row)
			endif
		endfor
		
//		// Don't know why this is addressed in original...check to usethese against size of main and pos waves
		wave mw = main[0]
		wave pw = pos[0]
		variable i
		for (i=0; i<numpnts(usethese); i+=1)
			if (usethese[i] > (numpnts(mw)-1) || usethese[i] > (numpnts(pw)-1))
				redimension/N=(i) usethese
				break
			endif
		endfor
				
		for (wi=0; wi<numpnts(main); wi+=1)
			sasp_trim_waves_with_index(main[wi], usethese)
		endfor
		wave w = $"Seconds"
		w *= (millisscale/1000.0)
		
		for (wi=0; wi<numpnts(pos); wi+=1)
			sasp_trim_waves_with_index(pos[wi], usethese)
		endfor
		wave w = $"MicroUsed"
		w *= 100.0
		
		// truncate to shortest of rotating files
		variable ishort
		
		variable casei
		for (casei=1; casei<=5; casei+=1)
			wave/wave ww = $(stringbykey(num2str(casei), case_map))
			wave w = ww[0]
			if (casei==1)
				ishort = numpnts(w)
			else
				ishort = min(ishort, numpnts(w))
			endif
		endfor
		
		// nav waves
		for (wi=0; wi<numpnts(nav); wi+=1)
			wave w = nav[wi]
			redimension/N=(ishort) w
		endfor
		wave w = $"Te"
		variable vscale = 4.95
		w = (w*(vscale/1023.0)-0.5)*100.0 // convert digital bits to degrees
		
		
	
		// gpstime waves
		for (wi=0; wi<numpnts(gpstime); wi+=1)
			wave w = gpstime[wi]
			redimension/N=(ishort) w
		endfor
		wave w = $"MonthDay"
		duplicate/o w, Year  // create Year wave
		Year = start_year
		Year = (w[p] > 1300) ? Year[p] + floor( floor(w[p]/100) / 12.01) : Year[p]
		w = (w[p] > 1300) ? w[p] - (floor( floor(w[p]/100) / 12.01)*1200) : w[p]
		
//		if (w[ishort-1] > 1300)
////			Year = 2000 + floor(w[ishort-1]/10000)
//			w = mod(w[p],10000)
////			w=0
//		endif
		wave w = $"HKSeconds"
		w *= (millisscale/1000.0)
		
		//orient waves
		for (wi=0; wi<numpnts(orient); wi+=1)
			wave w = orient[wi]
			redimension/N=(ishort) w
		endfor
	
		//gate waves
		for (wi=0; wi<numpnts(gate); wi+=1)
			wave w = gate[wi]
			redimension/N=(ishort) w
		endfor
		
		
		// fill and process azimuth, UDT
	
		make/o/n=0 $"missaz"
		wave missaz = $"missaz"
		
		wave azimuth = $"azimuth"
		for (row=0; row<numpnts($"azimuth"); row+=1)
			if (numtype(azimuth[row]) != 0)
				sasp_append_to_wave(missaz, row)
			endif
		endfor
		if (numpnts(missaz)>0)
			duplicate/o missaz, previndx
			previndx -= 1
			// previndx = (previndx  //***not sure what to do if index=0...nan?, 0?
			
			wave seconds = $"Seconds"
			for (row=0; row<numpnts(missaz); row+=1)
				if (missaz[row] == 0)
					azimuth[0]=0  // is this right???
				else
					// *** rotrate is missing in matlab version! ***
					azimuth[missaz[row]] = azimuth[previndx[row]] + (seconds[missaz[row]] - seconds[previndx[row]])*rotrate
				endif
			endfor
		endif
		
		make/o/n=0 $"HadGPS"
		wave HadGPS = $"HadGPS"
		
		for (row=0; row<numpnts($"GPSReadSeconds"); row+=1)
			if ( sasp_get_wval_at_index(gpstime, gpstime_list, "GPSReadSeconds", row) > 0 &&   sasp_get_wval_at_index(gpstime, gpstime_list, "MonthDay", row) > 0 )
				sasp_append_to_wave(HadGPS, row)
			endif
		endfor
		wave MonthDay = $"MonthDay"
		wave Lat = $"Lat"
		wave Lon = $"Lon"
		if (numpnts(HadGPS) > 0 && HadGPS[0] > 0) // we need to fill in missing values
			MonthDay[0,(HadGPS[0]-1)] = MonthDay[HadGPS[0]]
			Lat[0,(HadGPS[0]-1)] = Lat[HadGPS[0]]
			Lon[0,(HadGPS[0]-1)] = Lon[HadGPS[0]]
		endif
		duplicate/o MonthDay, $"Month"
		wave Month = $"Month"
		Month = floor(MonthDay[p]/100.)
		duplicate/o MonthDay, $"Day"
		wave Day = $"Day"
		Day = MonthDay[p] - Month[p]*100.
		
		variable C0
		variable C1
		if (numpnts(HadGPS) > 2)
			if (MonthDay[ishort-1] > MonthDay[HadGPS[0]])
				Month = floor(MonthDay[p]/100)
				duplicate MonthDay, $"TempDays"
				wave TempDays = $"TempDays"
				TempDays = datetoJulian(Year, Month[p], (MonthDay[p]-Month[p]))
				wave GPSHr = $"GPSHr"
				GPSHr = GPSHr[p] + 24.0*(TempDays[p] - TempDays[0])
				killwaves/Z TempDays	
			endif
	
			duplicate/o $"GPSHr", xwave 
			wave x = xwave 
			duplicate/o $"GPSReadSeconds", ywave 
			wave y = ywave
			sasp_trim_waves_with_index(x, HadGPS)
			sasp_trim_waves_with_index(y, HadGPS)
			CurveFit/Q line y /X=x
			wave coef = W_coef
			C0 = coef[0]
			C1 = coef[1]
		else
			print "Not enough GPS readings to compute times"
			return 1	
		endif
		
		wave HKSeconds = $"HKSeconds"
		duplicate/o HKSeconds, $"UDTofHK"
		wave UDTofHK = $"UDTofHK"
		UDTofHK = (HKSeconds[p] - C0) / C1
		
		wave Seconds = $"Seconds"
		duplicate/o Seconds, $"UDT"
		wave UDT = $"UDT"
		UDT = (Seconds[p] - C0) / C1
		
		// create HK datetime wave
		make/o/D/n=(numpnts(UDTofHK)) sasp_dt_hk
		sasp_dt_hk = date2secs(Year[p], Month[p], Day[p]) + UDTofHK[p]*3600
		
		// create datetime to correspond to UDT
		make/o/D/n=(numpnts(UDT)) sasp_dt 
		sasp_dt = interp(UDT[p],UDTofHK, sasp_dt_hk)
		
		// do checkplot
		
		
		// end do checkplot
		wave GateShArr = $"GateShArr"
		variable/G shortgate = GateShArr[0]*1E-6;
		wave GateLgArr = $"GateLgArr"
		variable/G longgate =  GateLgArr[0]*1E-6;
		
		variable shorttimeoffset = -(longgate + 0.5*shortgate);
		variable longtimeoffset = -0.5*longgate;
	
		variable gateratio = longgate/shortgate;
	
		duplicate/o $"PhotoA", $"PhotoAMerge"
		duplicate/o $"PhotoB", $"PhotoBMerge"
		duplicate/o $"PhotoC", $"PhotoCMerge"
		duplicate/o $"PhotoD", $"PhotoDMerge"
		
		duplicate/o $"azimuth", $"AzimuthA", $"AzimuthB", $"AzimuthC", $"AzimuthD"
	
		UDT += longtimeoffset/3600.	
	
	
	// find and subtract small digitizer offset between short and long gates
	//   fixed slope calculation
	
		string wl_list = "A;B;C;D"
		string var_list = "PhotoX;PhotoXsh;PhotoXMerge;AzimuthX"
		
		variable wli, vari
		for (wli=0; wli<itemsinlist(wl_list); wli+=1)
			string wl = stringfromlist(wli, wl_list)
			string tmp_list = var_list
			tmp_list = replacestring("X", tmp_list, wl)
			
			wave PhotoX = $(stringfromlist(0, tmp_list))
			wave PhotoXsh = $(stringfromlist(1, tmp_list)) 
			wave PhotoXMerge = $(stringfromlist(2, tmp_list)) 
			wave AzimuthX = $(stringfromlist(3, tmp_list)) 
	
	
			make/o/n=0 $"HiSig"
			wave HiSig = $"HiSig"
		
	//	wave PhotoA = $"PhotoA"
			for (row=0; row<numpnts(PhotoX); row+=1)
				if (PhotoX[row]  > HiThres)
					sasp_append_to_wave(HiSig, row)
				endif
			endfor
	
			make/o/n=0 $"LoSig"
			wave LoSig = $"LoSig"
		
			for (row=0; row<numpnts(PhotoX); row+=1)
				if (PhotoX[row]  <= HiThres)
					sasp_append_to_wave(LoSig, row)
				endif
			endfor
		
			if (numpnts(LoSig) > 0)
				duplicate/o PhotoXsh, $"tmpXsh"
				wave tmpXsh = $"tmpXsh"
				duplicate/o PhotoX, $"tmpX"
				wave tmpX = $"tmpX"
				sasp_trim_waves_with_index(tmpXsh, LoSig)
				sasp_trim_waves_with_index(tmpX, LoSig)
				duplicate/o tmpX, $"resultX"
				wave resultX = $"resultX"
				resultX = ( tmpXsh[p] - tmpX[p]/gateratio )
	//			wavestats/Q resultX
	//			variable XOffset = V_avg
				variable XOffset = mean(resultX)
				
				if(numpnts(HiSig) > 0)
					for (row=0; row<numpnts(HiSig); row+=1)
						PhotoXMerge[HiSig[row]] = (PhotoXsh[HiSig[row]] - XOffset)*gateratio
						AzimuthX[HiSig[row]] += rotrate*(shorttimeoffset - longtimeoffset)
					endfor
				endif
			endif
			NVAR ConstOffsetX = $("ConstOffset"+wl)
			PhotoXMerge -= ConstOffsetX
		endfor
	
			
	// -------------------- Short version of data on each HK time (about 1.5 s instead of 33 ms)
		make/o/n=(ishort,4) $"HKPhotoMax", $"HKPhotoAvg"
		wave HKPhotoMax = $"HKPhotoMax"
		HKPhotoMax = 0
		wave HKPhotoAvg = $"HKPhotoAvg"
		HKPhotoAvg = 0
		
		make/o/n=(RollingPts) $"BaseIndices", $"TheseIndices"
		wave BaseIndices = $"BaseIndices"
		BaseIndices = p
		wave TheseIndices = $"TheseIndices"
		
		wave GPSTimeIndices = $"GPSTimeIndices"
		wave PhotoA = $"PhotoA"
		variable npoints = numpnts(PhotoA)
		
		for (row=0; row<ishort; row+=1)
			TheseIndices = BaseIndices + max(GPSTimeIndices[row], 0)
			TheseIndices = (TheseIndices[p] <= npoints) ? TheseIndices[p] : npoints
			
			for (wli=0; wli<itemsinlist(wl_list); wli+=1)
				wave PhotoXMerge = $("Photo"+stringfromlist(wli, wl_list)+"Merge")
				duplicate/o $("Photo"+stringfromlist(wli, wl_list)+"Merge"), $"tmpXMerge"
				wave tmpXMerge = $"tmpXMerge"
				sasp_trim_waves_with_index(tmpXMerge, TheseIndices)
				
				wavestats/Q tmpXMerge
				HKPhotoMax[row][wli] = V_max
				HKPhotoAvg[row][wli] = V_sum/RollingPts
			endfor
		endfor
		
	//-------------------------------------- CALCULATED PARAMETERS -----------------------------------------
	
	//	; solar zenith
	//	;
		wave UDT = $"UDT"
		wave UDTofHK = $"UDTofHK"
	//	make/o/n=(numpnts(UDTofHK)+2) $"UDtForZenith"
	//	wave UDtForZenith = $"UDtForZenith"
		
		//make/o $"UDtForZenith" = {UDT[0], UDTofHK[Inf,Inf], UDT[numpnts(UDT)-1]}
		make/o $"UDtForZenith" = {UDT[0]}
		make/o first = {UDT[0]}
		Concatenate/o/NP=1 {first, UDTofHK}, second
		make/o third = {UDT[numpnts(UDT)-1]}
		Concatenate/o/NP=1 {second, third}, $"UDtForZenith"
		wave UDtForZenith = $"UDtForZenith"
		
		
		// Concatenate/O/NP=1 {UDT[0,0], UDTofHK, UDT[numpnts(UDT)-1,numpnts(UDT)-1]}, $"UDtForZenith"
	//	UDtForZenith = udt[0L], UDTofHK, UDT[npoints-1L]]
	//	; use housekeeping spacing for fewer calculations, then interpolate
		
		wave Lat  = $"Lat"
		make/o/n=(numpnts(lat)+2) $"latforzenith" // = {lat[0], lat, lat[ishort-1]}
		wave latforzenith = $"latforzenith"
		latforzenith[0] = Lat[0]
		latforzenith[1,numpnts(latforzenith)-2] = Lat[p-1]
		latforzenith[numpnts(latforzenith)-1] = Lat[ishort-1]

		wave Lon = $"Lon"
		make/o/n=(numpnts(lat)+2) $"lonforzenith" // = {lon[0], lon, lon[ishort-1]}
		wave lonforzenith = $"lonforzenith"
		lonforzenith[0] = Lon[0]
		lonforzenith[1,numpnts(lonforzenith)-2] = Lon[p-1]
		lonforzenith[numpnts(lonforzenith)-1] = Lon[ishort-1]

		make/o/n=(numpnts(lat)+2) yearforzenith // = {year[0], year, year[ishort-1]}
		yearforzenith[0] = year[0]
		yearforzenith[1,numpnts(yearforzenith)-2] = year[p-1]
		yearforzenith[numpnts(yearforzenith)-1] = year[ishort-1]

		make/o/n=(numpnts(lat)+2) monthforzenith // = {month[0], month, month[ishort-1]}
		monthforzenith[0] = month[0]
		monthforzenith[1,numpnts(monthforzenith)-2] = month[p-1]
		monthforzenith[numpnts(monthforzenith)-1] = month[ishort-1]

		make/o/n=(numpnts(lat)+2) dayforzenith // = {day[0], day, day[ishort-1]}
		dayforzenith[0] = day[0]
		dayforzenith[1,numpnts(dayforzenith)-2] = day[p-1]
		dayforzenith[numpnts(dayforzenith)-1] = day[ishort-1]
		
	 	duplicate/o latforzenith, $"SolarZenithsh", $"SolarAzimuthsh" //; size
		wave SolarZenithsh = $"SolarZenithsh"
		wave SolarAzimuthsh = $"SolarAzimuthsh"
	
	//	FOR i = 0L, N_ELEMENTS(latforzenith)-1L DO BEGIN
		for (i=0; i<numpnts(latforzenith); i+=1)
			wave sunpos = sasp_sunPosition_single(latforzenith[i], lonforzenith[i], yearforzenith[i], monthforzenith[0], dayforzenith[0], UDtForZenith[i]*3600.)
		 	SolarZenithsh[i] = 90.0 - sunpos[0]
		 	SolarAzimuthsh[i] = sunpos[1]
		endfor
	
	//	for (i=0; i<numpnts(SolarZenith); i+=1)
		duplicate/o UDT, $"SolarZenith", $"SolarAzimuth"
		wave SolarZenith = $"SolarZenith"
		wave SolarAzimuth = $"SolarAzimuth"
		SolarZenith = interp(UDT[p], UDtForZenith, SolarZenithsh)
		SolarAzimuth = interp(UDT[p], UDtForZenith, SolarAzimuthsh)
			
	endif
	
	// --- populate ReadData structure
	rd.rotrate = rotrate
	NVAR sg = $"shortgate"
	rd.short_gate = sg
	NVAR lg = $"longgate"
	rd.long_gate = lg
	rd.npoints = numpnts($"PhotoA")
	
	make/wave/o/n=(itemsinlist(rd.wl_list)) photo_merge_array, azimuth_array
	for (wli=0; wli<itemsinlist(rd.wl_list); wli+=1)
		photo_merge_array[wli] = $("Photo"+stringfromlist(wli, rd.wl_list)+"Merge")
		azimuth_array[wli] = $("Azimuth"+stringfromlist(wli, rd.wl_list))
	endfor
	wave/wave rd.photo_merge_array = photo_merge_array
	wave/wave rd.azimuth_array = azimuth_array
	
	wave rd.udt = $"UDT"
	wave rd.home_p = $"homep"
	
	wave rd.udt_of_hk = $"UDTofHK"
	wave rd.te = $"Te"
	
	wave rd.dt = $"sasp_dt"
	wave rd.dt_hk = $"sasp_dt_hk"
	
	make/wave/o/n=(itemsinlist(rd.pos_list)) pos_array
	for (listi=0; listi<itemsinlist(rd.pos_list); listi+=1)
		pos_array[listi] = $stringfromlist(listi, rd.pos_list)
	endfor
	wave rd.pos_array = pos_array

	make/wave/o/n=(itemsinlist(rd.mdy_list)) mdy_array
	for (listi=0; listi<itemsinlist(rd.mdy_list); listi+=1)
		mdy_array[listi] = $stringfromlist(listi, rd.mdy_list)
	endfor
	wave rd.mdy_array = mdy_array

	make/wave/o/n=(itemsinlist(rd.orient_list)) orient_array
	for (listi=0; listi<itemsinlist(rd.orient_list); listi+=1)
		orient_array[listi] = $stringfromlist(listi, rd.orient_list)
	endfor
	wave rd.orient_array = orient_array

	make/wave/o/n=(itemsinlist(rd.barom_list)) barom_array
	for (listi=0; listi<itemsinlist(rd.barom_list); listi+=1)
		barom_array[listi] = $stringfromlist(listi, rd.barom_list)
	endfor
	wave rd.barom_array = barom_array

	make/wave/o/n=(itemsinlist(rd.solar_list)) solar_array
	for (listi=0; listi<itemsinlist(rd.solar_list); listi+=1)
		solar_array[listi] = $stringfromlist(listi, rd.solar_list)
	endfor
	wave rd.solar_array = solar_array
	
	wave rd.udt_for_zenith = $"UDtForZenith"
	wave rd.mode_flag = $"ModeFlag"
	wave rd.hk_photo_max = $"HKPhotoMax"
	wave rd.hk_photo_avg = $"HKPhotoAvg"
	
	// --- end populate ReadData structure

	setdatafolder ref

//	print nameofwave(rd.udt_for_zenith), nameofwave(rd.udt_of_hk), nameofwave(rd.te)
End

Function sasp_get_wval_at_index(waverefs, wname_list, wname, index)
	wave/wave waverefs
	string wname_list
	string wname
	variable index

	wave w = waverefs[whichlistitem(wname,wname_list)]
	return w[index]
End	
	
Function sasp_trim_waves_with_index(w, index_w)
	wave w
	wave index_w

//	variable ncnt = numpnts(index_x)
	duplicate/o w, tmpw
	wave tmp = tmpw
	
	redimension/N=(numpnts(index_w)) w
	w = tmp[index_w[p]]
	
	killwaves/Z tmpw
	
End

Function sasp_append_to_wave(w, val)
	wave w
	variable val

	variable is2d = 0
	if (dimsize(w,1) > 0)
		is2d = 1
	endif
	
	variable rows = dimsize(w,0)
	
	if (!is2d)
		
		redimension/N=(rows+1) w
		w[rows] = val
		
	else
//		continue
	endif
End


Function/WAVE sasp_SunPosition_single(lat, lon, year, month, day, udt)
	variable lat
	variable lon
	variable year
	variable month
	variable day
	variable udt

	// Get day of the year, e.g. Feb 1 = 32, Mar 1 = 61 on leap years
	make/o cummonthdays =  {0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334}
	make/o cummonthdaysleap = {0, 31, 60, 91, 121, 152, 182, 213, 244, 274, 305, 335}

	variable dayyear
	if (mod(year,4))
//	if (Year MOD 4) EQ 0 THEN $ 
		dayyear = day + cummonthdaysleap[month-1] - 1
	else
		dayyear = day + cummonthdays[month-1] - 1
	endif
	variable hour = UDT/3600. //; hour + min/60. + sec/3600.

//	; The input to the Atronomer's almanach is the difference between
//	; the Julian date and (noon, 1 January 2000)
//	; modified to delta from 2013 for better single precision

	variable deltayr2 = year - 2013
	variable nleap2 = FLOOR(deltayr2/4. + 0.01)
	variable time2 =  deltayr2 * 365.0 + nleap2 + dayyear + hour / 24.0 - 0.5 
//	; 0.5 is because julday is at noon and formulas below are julday

//	; Ecliptic coordinates
//	; Mean longitude
//	;mnlong = 280.460D + 0.9856474D*time ; .463 best eclong but .459 best ra
	variable mnlong = 281.29860 + 0.985647*time2   
	mnlong = mod(mnlong,360.0)
	
//	;mnlong += 360.0*(mnlong LT 0.0)
//	; Mean anomaly
	variable mnanom = 358.14382 + 0.9856 * time2
	mnanom = mod(mnanom, 360.0)
//	;mnanom += 360.0*(mnanom LT 0)
	mnanom = mnanom * (pi/180)
//	; Ecliptic longitude and obliquity of ecliptic
//	;eclong = mnlong + 1.915 * sin(mnanom) + 0.020 * sin(2 * mnanom)
	variable eclong = mnlong + 1.915 * sin(mnanom) + 0.0205 * sin(2 * mnanom)
//	;print, mnanom
	eclong = mod(eclong, 360.0)
	if (eclong < 0)
		eclong += 360.0
	endif
	eclong = eclong * (pi/180)

//	; Celestial coordinates
//	; Right ascension and declination
//	;num =  0.91751185D* sin(eclong)
	variable num =  0.91751185* sin(eclong)
	variable den = cos(eclong)
	variable ra = atan(num / den)
	if (den < 0)
		ra += PI
	elseif (den >= 0 && num < 0)
		ra += 2*PI
	endif
	variable dec = asin(0.39770844* sin(eclong))      
	
//	; Local coordinates
//	; Greenwich mean sidereal time
	variable gmst = 6.75333 + 0.0657098242*time2 + hour
	gmst = mod(gmst, 24.0)
	if (gmst < 0)
		gmst += 24.0
	endif
//	; Local mean sidereal time
	variable lmst = gmst + lon/15.
	lmst = mod(lmst, 24.0)
	if (lmst < 0)
		lmst += 24.0
	endif
//	; Hour angle
	variable ha = lmst * 15.0* (pi/180) - ra
	if (ha < -(pi))
		ha += (2*pi)
	elseif (ha > pi)
		ha -= (2*pi)
	endif

//	;Azimuth and elevation
	variable sinlat = sin(lat*(pi/180))
	variable el = asin(sin(dec) * sinlat + cos(dec) * cos(lat*(pi/180)) * cos(ha))
	variable az = asin(-cos(dec) * sin(ha)/cos(el))
	
	variable cosAzPos = (0.0 <  (sin(dec) - sin(el) * sinlat))
	variable sinAzNeg = (sin(az) < 0.0)
	az+= (2*pi)*(cosAzPos*sinAzNeg)
	variable notcosAzPos = ABS(1.0-cosAzPos)
	az = az + (pi - 2.0*az)*notcosAzPos
//	;az[!cosAzPos] <- pi - az[!cosAzPos]
	
	el = el /(pi/180)
	az = az /(pi/180)
	
	variable oblqec = 23.435* (pi/180)
	
	make/o output = {el, az, ra/(pi/180), dec/(pi/180), eclong/(pi/180), oblqec/pi/180}
	return output
End

Function sasp_find_sun_peaks(sun_photo, udt , sun_threshold, spd, [rotrate, timespacing, max_width_angle, closest_above, gap_angle])
	wave sun_photo
	wave udt
	variable sun_threshold
	STRUCT SunPeakData &spd
	variable rotrate
	variable timespacing
	variable max_width_angle
	variable closest_above
	variable gap_angle
	
	// TODO: ParamIsDefault

	// TODO: ParamIsDefault
	
	variable nSmooth = 7
	variable nToSide = CEIL(max_width_angle/(rotrate*timespacing))
	variable TimeToSide = (max_width_angle/rotrate)/3600.


	duplicate/o sun_photo, AboveThreshold
	AboveThreshold = (sun_photo[p] > sun_threshold)
	
	variable npts = numpnts(sun_photo)

	// change it up...find peaks using built in function FindPeak
	variable startP = 0
	variable endP = (npts-1)
	variable smoothing = 2 // this seems to work but might need to be changed
	variable peak_ht_thresh = 500000 // would it be better to use some pct of max values? 
	
	// create waves to hold peak info
	make/o/n=0 $"LoIndices", $"HiIndices", $"MidSeconds"
	wave spd.lo_indices = $"LoIndices"
	wave spd.hi_indices = $"HiIndices"
	wave spd.peak_udt = $"MidSeconds"

	do 
//		print startP, endP
		FindPeak/Q/B=(smoothing)/M=(peak_ht_thresh)/R=[startP,endP] sun_photo
		if (V_Flag != 0)
			break
		endif
		
		if (numtype(V_LeadingEdgeLoc) != 0 || numtype(V_TrailingEdgeLoc) != 0)
			break
		endif
		
		if (V_PeakWidth>4 && V_PeakWidth<15) // guesses for now
			sasp_append_to_wave(spd.lo_indices, ceil(V_LeadingEdgeLoc))
			sasp_append_to_wave(spd.hi_indices, floor(V_TrailingEdgeLoc))
			variable midsec = 3600*(udt[ceil(V_LeadingEdgeLoc)] + udt[floor(V_TrailingEdgeLoc)])/2
			sasp_append_to_wave(spd.peak_udt, midsec)
		endif
		
		startP = ceil(V_TrailingEdgeLoc)+10
	while (1)	
	
	spd.npeaks = numpnts(spd.lo_indices)
	spd.peak_udt /= 3600
//	duplicate/o MidSeconds, SunDeltaAngles
//	SunDeltaAngles[,(numpnts(MidSeconds)-2)] = (MidSeconds[p+1]-MidSeconds[p])*rotrate	
//	SunDeltaAngles[(numpnts(MidSeconds)-1)] = SunDeltaAngles[p-1]

	// Original had code to figure out if peaks were too close or too far away from each other and coded them 
	//    with PeakTypeFlags but it does not look like that variable is used after it's returned so I'm skipping
		
End

Function sasp_find_sun_peaks_idl(sun_photo, udt , sun_threshold, spd, [rotrate, timespacing, max_width_angle, closest_above, gap_angle])
	wave sun_photo
	wave udt
	variable sun_threshold
	STRUCT SunPeakData &spd
	variable rotrate
	variable timespacing
	variable max_width_angle
	variable closest_above
	variable gap_angle
	
	// TODO: ParamIsDefault
	
	variable nSmooth = 7
	variable nToSide = CEIL(max_width_angle/(rotrate*timespacing))
	variable TimeToSide = (max_width_angle/rotrate)/3600.

	duplicate/o sun_photo, AboveThreshold
	AboveThreshold = (sun_photo[p] > sun_threshold)
	
	variable npts = numpnts(sun_photo)

	duplicate/o AboveThreshold, ThresDiff
	ThresDiff = 0
	ThresDiff[1,] = AboveThreshold[p] - AboveThreshold[p-1]
	
	make/o/n=0 RisingEdge
	variable row
	for (row=0; row<numpnts(ThresDiff); row+=1)
		if (ThresDiff[row]  == 1)
			sasp_append_to_wave(RisingEdge, row)
		endif
	endfor
	variable nRisingEdge = numpnts(RisingEdge)

	if (nRisingEdge > 0) // THEN BEGIN
		// take out last or first sun encounter if too close to end of file
		if (RisingEdge[nRisingEdge-1] > (npts-(nToSide+2)) ) //THEN BEGIN
			deletepoints (nRisingEdge-1), 1, RisingEdge
	    		//RisingEdge = RisingEdge[0L:nRisingEdge-2L]
	    		nRisingEdge = nRisingEdge-1
	  	endif
	 	if (RisingEdge[0] < (nToSide+2) ) //THEN BEGIN
			deletepoints 0, 1, RisingEdge
	    		// RisingEdge = RisingEdge[1L:nRisingEdge-1L]
	    		nRisingEdge = nRisingEdge-1
	 	endif
	endif
	spd.nPeaks = nRisingEdge
	
	if (nRisingEdge > 0)
		make/o/n=(nRisingEdge) LoIndices, HiIndices, MidSeconds
		make/o/n=(nRisingEdge) MidSeconds
		
		variable ihigh, ti		
		for( ihigh=0; ihigh<nRisingEdge; ihigh+=1)
			make/o/n=(nToSide) tmp_w
			tmp_w = RisingEdge[ihigh]+p
			duplicate/o AboveThreshold, LookForSatRegion
			LookForSatRegion = 0
			for (ti=0; ti<numpnts(tmp_w); ti+=1)
				LookForSatRegion[tmp_w[ti]] = AboveThreshold[tmp_w[ti]]
			endfor
			
			/// which are indices and which are 0|1?
			duplicate/o udt, TimeDiff
//			TimeDiff = (LookForSatRegion[p]) ? UDT[p] : 
			
		endfor
	endif
//			LookForSatRegion = AboveThreshold[RisingEdge[ihigh] + LINDGEN(nToSide)]
//			TimeDiff = UDT[LookForSatRegion]-UDT[LookForSatRegion[0]]
//			ThisAbove = WHERE((LookForSatRegion EQ 1) AND (TimeDiff LE TimeToSide), nThisAbove)
//			LoIndices[ihigh] = ThisAbove[0]
//			HiIndices[ihigh] = ThisAbove[nThisAbove-1]
//		ENDFOR
//		LoIndices = LoIndices + RisingEdge
//		HiIndices = HiIndices + RisingEdge
//		localwidths = HiIndices - LoIndices
//		MidSeconds = 1800.*(UDT[LoIndices] + UDT[HiIndices])
//		midindices = ROUND((LoIndices + HiIndices)/2.)
//		if nRisingEdge GT 1 THEN BEGIN
//			SunDeltaAngles = (MidSeconds[1:nRisingEdge-1] - MidSeconds[0:nRisingEdge-2])*rotrate
//			//
//			// code for too close 
//			//
//			TooClose = WHERE(SunDeltaAngles LT ClosestAbove, nTooClose)
//			if nTooClose GT 0 THEN BEGIN
//				  Ones = REPLICATE(1, nRisingEdge)
//				  // take wider one because noise on edge of peak will give a narrow side peak
//				  FOR iclose = 0, nTooClose-1 DO BEGIN
//				    thisindx = TooClose[iclose]
//				    if localwidths[thisindx + 1] GT localwidths[thisindx] THEN $
//				      Ones[thisindx] = 0 ELSE Ones[ThisIndx + 1] = 0 
//				  ENDFOR
//				  KeepPeaks = WHERE(Ones)
//				  LoIndices = LoIndices[KeepPeaks]
//				  HiIndices = HiIndices[KeepPeaks]
//				  midindices = midindices[KeepPeaks]
//				  MidSeconds = MidSeconds[KeepPeaks]
//				  localwidths = localwidths[KeepPeaks]
//				  nPeaks = nRisingEdge - nTooClose
//			 endif 
//		endif
//	endif

	
	
//	variable ThresDiff = AboveThreshold[1:npts-1] - AboveThreshold[0:npts-2]
//	ThresDiff = [0, ThresDiff]
//	RisingEdge = WHERE(ThresDiff EQ 1, nRisingEdge)
	
	
	
End

Function sasp_make_rayleigh(pressure,[proj_name, id])
	wave pressure
	string proj_name
	string id

	

	DFREF ref = sasp_goto_sasp_folder()
	
	
	make/o RayConst = {0.0972023, 0.2202482, 0.0435789, 0.0158781}

	newdatafolder/o/s rayleigh
	make /o/n=7 RayThPr, RayThA, RayThB, RayThC, RayThD
	make/o/n=(numpnts(pressure),numpnts(RayConst)) RayleighMax
	
	variable wli
	for (wli=0; wli<numpnts(RayConst); wli+=1)
		//	RayThPr = {650,1000, 2000, 3000, 4000, 5000, 10000}
		//	RayThA = 0.0 - 0.0972023*RayThPr/1013.
		//	RayThB = 0.0 - 0.2202482*RayThPr/1013.
		//	RayThC = 0.0 - 0.0435789*RayThPr/1013.
		//	RayThD = 0.0 - 0.0158781*RayThPr/1013.
		RayleighMax[][wli] = 0.0 - RayConst[wli]*pressure[p]/1013
	endfor
	
	setdatafolder ref

End

Function sasp_make_rayleigh_th()
//	wave pressure

	DFREF ref = sasp_goto_sasp_folder()
	
	
//	make/o RayConst = {0.0972023, 0.2202482, 0.0435789, 0.0158781}

	newdatafolder/o/s rayleigh
	make /o/n=7 RayThPr, RayThA, RayThB, RayThC, RayThD
//	make/o/n=(numpnts(pressure),numpnts(RayConst)) RayleighMax

	RayThPr = {650,1000, 2000, 3000, 4000, 5000, 10000}
	RayThA = 0.0 - 0.0972023*RayThPr/1013.
	RayThB = 0.0 - 0.2202482*RayThPr/1013.
	RayThC = 0.0 - 0.0435789*RayThPr/1013.
	RayThD = 0.0 - 0.0158781*RayThPr/1013.
	
//	duplicate/ RayThA, RayThA_abs
//	RayThA_abs = RayThA[
	setdatafolder ref

End

Function sasp_process_scan(psd)
	STRUCT ProcessScanData &psd

//	IF N_ELEMENTS(DiagPlotFlag) LT 1 THEN DiagPlotFlag = 0
//	IF N_ELEMENTS(DIAGPLOTTEXT) LT 1 THEN DiagPlotText = ''
	//
	// September 2014 implement getting some parameters from a ULR scan
	//
	variable CheckShiftFlag = 0
	variable shifttry = 0.5  // degrees to try shifting data to match sides better
	variable FracTolerance = 0.2  //  note AERONET requires data on both sides to match within 0.2
	variable MinAnglesForFit = 10
	variable MinAngleRange = 30.  // range of angles with valid data to do fit     (degrees)
	variable SkyFraction = 0.000649565// of slit
	variable RayleighScale = 0.0
	if (psd.SunELevMax >= 0.0)
		RayleighScale = psd.RayleighOD*(psd.pressure/1.01E5)/cos(((90.0-psd.SunElevMax) < 89.9)*(pi/180))
		RayleighScale = 1.0 - exp(-RayleighScale)
		RayleighScale = RayleighScale*SkyFraction
	endif

	// Near Sun value
	//
	//aa = MIN(ABS(MidAngles - NearSunAngle), near1sub)
	//aa = MIN(ABS(MidAngles + NearSunAngle), near2sub)
	variable nangles = numpnts(psd.mid_angles)
	variable halfn = floor(nangles/2)
	//
	// pull out each side
	// 
//	side1 = REVERSE(ScanAvg[0:halfn-1])
	reverse psd.scan_avg /D=side1
//	side2 = ScanAvg[nangles - halfn:nangles - 1]
	duplicate/o psd.scan_avg side2
	side2[nangles-halfn, nangles-1] = psd.scan_avg[p]

//	nside1 = REVERSE(nScan[0:halfn-1])
	reverse psd.nScan /D=nside1
//	nside2 = nScan[nangles - halfn:nangles - 1]
	duplicate/o psd.nScan nside2
	side2[nangles-halfn, nangles-1] = psd.nScan[p]
	
//	angles = ABS(REVERSE(MidAngles[0:halfn-1]))
	reverse psd.mid_angles /D=angles
	
//	Tangles = angles
//	Tside1 = side1
	duplicate/o angles, Tangles
	duplicate/o side1, Tside1
	
	variable SunValue = 0.5*(side1[0] + side2[0])
	
	make/o/n=0 havedata
	variable i
	for (i=0; i<numpnts(nside1); i+=1)
		if ( (nside1[i]*nside2[i]>0) && (angles[i] >= psd.NearSunAngle) )
			sasp_append_to_wave(havedata, i)
		endif
	endfor
	
	if (numpnts(havedata) <= MinAnglesForFit)
		psd.AngleShift = 0
		psd.SideMatchFraction = 0
		psd.MinAngle = 0
		psd.MaxAngle = 0
		make/o $"FitParams" = {0,0,0,0}
		wave psd.FitParams = $"FitParams"
		make/o $"FitSigmas" = {0,0,0,0}
		wave psd.FitSigmas = $"FitSigmas"
		psd.FitMeasure = 0
		psd.FitStatus = -1
		psd.rayscat = NaN
		
		return 1
	endif
	
	sasp_trim_waves_with_index(side1, havedata)
	sasp_trim_waves_with_index(side2, havedata)
	sasp_trim_waves_with_index(nside1, havedata)
	sasp_trim_waves_with_index(nside2, havedata)
	sasp_trim_waves_with_index(angles, havedata)

	//
	// check small angle shifts
	//
//	IF CheckShiftFlag THEN BEGIN
//	side1shift = INTERPOL(side1, angles-shifttry, angles)
//	side2shift = INTERPOL(side2, angles-shifttry, angles)
//	side1shifth = INTERPOL(side1, angles-shifttry/2.0, angles)
//	side2shifth = INTERPOL(side2, angles-shifttry/2.0, angles)
//	noshiftcorr = CORRELATE(side1, side2)
//	shift1corr = CORRELATE(side1shift, side2)
//	shift2corr = CORRELATE(side1,side2shift)
//	shift1corrh = CORRELATE(side1shifth, side2)
//	shift2corrh = CORRELATE(side1,side2shifth)
//	//print, [noshiftcorr, shift1corr, shift2corr, shift1corrh, shift2corrh]
//	MaxCorr = MAX([noshiftcorr, shift1corr, shift2corr, shift1corrh, shift2corrh], CorrIndx)
//	CASE CorrIndx OF
//	0: AngleShift = 0.0
//	1: BEGIN
//	AngleShift = shifttry
//	side1 = side1shift
//	END
//	2: BEGIN
//	AngleShift = -shifttry
//	side2 = side2shift
//	END
//	3: BEGIN
//	AngleShift = shifttry/2.0
//	side1 = side1shifth
//	END
//	4: BEGIN
//	AngleShift = -shifttry/2.0
//	side2 = side2shifth
//	END
//	ENDCASE
//	ENDIF ELSE AngleShift = 0.0
	
	// skip checkshift as it appears to be manual and I don't know what it's doing
	psd.AngleShift = 0.0
	
	//
	// throw out mismatched data
	//
	duplicate/o side1, SideAvg, SideRatio
	SideAvg = 0.5*(side1[p] + side2[p])
	SideRatio = side1[p]/SideAvg[p]
	//plot, angles, sideratio, yrange = [0.7, 1.3]
	//wait, 0.2
	
	make/o/n=0 GData
//	GData = WHERE((Sideratio LT (1.0+FracTolerance)) AND (SideRatio GT (1.0 - FracTolerance)), nGData)
	for (i=0; i<numpnts(SideRatio); i+=1)
		if ( (SideRatio[i] < (1+FracTolerance)) && (SideRatio[i] > (1-Fractolerance)) )
			sasp_append_to_wave(GData, i)
		endif
	endfor
	variable SideMatchFraction = numpnts(GData)/numpnts(havedata)
	if (numpnts(GData) > 1)
		sasp_trim_waves_with_index(SideAvg, GData)
		duplicate/o nside1, tmp1
		duplicate/o nside2, tmp2
		sasp_trim_waves_with_index(tmp1, GData)
		sasp_trim_waves_with_index(tmp2, GData)
		make/o/n=(numpnts(GData)) nSideAvg
		nSideAvg = tmp1[p]+tmp2[p]
		sasp_trim_waves_with_index(angles, GData)
	endif
	//weights = 1.0 + (angles GT 10.0) + (angles GT 30.0)  // larger angles span greater range
	duplicate/o SideAvg, weights
	weights = (SideAvg[p] > 1) ? (1.0/sqrt(SideAvg[p]))*(1.0 + (angles[p] < 30.0)) : (1.0/sqrt(1))*(1.0 + (angles[p] > 30.0))
	psd.MinAngle = angles[0]
	psd.MaxAngle = angles[numpnts(GData)-1]
	variable anglerange = psd.MaxAngle - psd.MinAngle

//	IF (nGData GT MinAnglesForFit) AND (anglerange GT MinAngleRange) THEN BEGIN
//		if ( (numpnts(GData) > MinAnglesForFit) && (anglerange > MinAngleRange) )
		if ( (numpnts(GData) > MinAnglesForFit) )
			if (anglerange <= MinAngleRange) 
				psd.FitStatus = -1
			endif
		//FitAngles = angles + (angles/ABS(angles))*2.8*(ABS(angles) > 2.0)^(-0.9425)
			duplicate/o angles, FitAngles
			FitAngles = (abs(angles[p]) > 2.0) ? angles[p] + (angles[p]/ABS(angles[p]))*2.50*(ABS(angles[p]))^(-0.9760) : \
						                                           angles[p] + (angles[p]/ABS(angles[p]))*2.50*(2.0)^(-0.9760)
			// light through slit comes from range of angles
			// on average this is a bigger angle than nominal angle. See slitangle.pro and IGOR SlitAngleFit
			//  
			duplicate/o FitAngles, mus
			mus = COS(Fitangles[p]*(pi/180))
			//RayleighScat = RayleighScale*SunValue*(1.0435 + 0.9855*mus*mus)*(0.7289)
			// 0.7289 to normalize the function 1 + mu^2 from zero to 1
			duplicate/o mus, RayleighScat
//			print RayleighScale*SunValue, (1.0 + 3.0*psd.Rayleighgamma),  (1.0 - psd.Rayleighgamma)*mus[0]*mus[0], (0.75/(1.0 + 2.0*psd.Rayleighgamma))
			RayleighScat = RayleighScale*SunValue*((1.0 + 3.0*psd.Rayleighgamma) + \
			                               (1.0 - psd.Rayleighgamma)*mus[p]*mus[p])*(0.75/(1.0 + 2.0*psd.Rayleighgamma))
			 wavestats/Q RayleighScat
			 psd.rayscat = V_avg
			// Bucholtz eqtn as
			SideAvg = SideAvg[p] - RayleighScat[p]
			wavestats/Q SideAvg
			variable AvgSideAvg = V_avg
	//		AvgSideAvg = TOTAL(SideAvg)/nGData
			//
			// fit to sum of Rayleigh and Henley-Greenstein
			// 
			//IF MaxAngle GT 100.0 THEN BEGIN
			//  FitParams = [10., 0.1*AvgSideAvg, 0.75, 0.5*AvgSideAvg]  // initial guess
			//  HGFitResult = CURVEFIT(mus, SideAvg, Weights, FitParams, FitSigmas, $
			//     FUNCTION_NAME='hgrayfunction', CHISQ=fitmeasure, STATUS = fitstatus, ITMAX = 50, TOL = 0.01)
			//    // default 20 iterations max, 0.001
			// ENDIF ELSE BEGIN
			make/o TFitParams = {10., 0.1*AvgSideAvg, 0.75}  // initial guess
		
//		HGFitResult = CURVEFIT(mus, SideAvg, Weights, TFitParams, TFitSigmas, $
//		FUNCTION_NAME='hgfunction', CHISQ=fitmeasure, STATUS = fitstatus, ITMAX = 50, TOL = 0.01)
		// default 20 iterations max, 0.001
//		FitParams = [TFitParams, RayleighScale*SunValue]
//		FitSigmas = [TFitSigmas, RayleighScale*SunValue]
		//ENDELSE
//		IF DiagPlotFlag EQ 1 THEN BEGIN
//		plot, fitangles, SideAvg, psym=4 //, yrange = [0,800]
//		oplot, fitangles, SideAvg + RayleighScat, psym=1
//		oplot, fitangles, HGFitResult, color=2
//		oplot, fitangles, RayleighScat, color=3
//		XYOUTS, 0.6, 0.75, STRING(FitParams[2]), /NORM
//		XYOUTS, 0.6, 0.7, STRING(RayleighOD), /NORM
//		XYOUTS, 0.6, 0.8, DiagPlotText, /NORM
//		SideAvg = SideAvg  // there to allow a stop
//		ENDIF
	else
	// no fit
		psd.FitParams = {0.0, 0.0, 0.0, RayleighScale*SunValue}
		psd.FitSigmas = {0.0, 0.0, 0.0, RayleighScale*SunValue}
		psd.fitmeasure = 0.0
		psd.FitStatus = -1
		psd.rayscat = NaN
	endif
	
End