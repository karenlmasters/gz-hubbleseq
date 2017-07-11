PRO bulgewinding

;  zoo=mrdfits('Bar_0.06_nbar25_10_v2.fits',1)
;  zoo=mrdfits('bar0.06_nbar25_10.fits',1)
;This is file made by ~/GalaxyZoo/Bars/FinalGZ2/volumelimit.pro which
;is similar to the sample used by Ramin. Volume limit is to z=0.06,
;Mr=-20.15. It shows qualitatively the same colour bar fraction trend
;as we published, but is more objects (and correct volume limit). 
;  zoo=mrdfits('GZ2_sample_specz.fits',1)
 zoo=mrdfits('GZ2_Vol_limit0.035.fits',1)

 pstar=zoo.T01_SMOOTH_OR_FEATURES_A03_STAR_OR_ARTIFACT_DEBIASED

 star=where(pstar ge 0.5,count)
 print,'Obvious stars or artifacts, ', count


 all=where(zoo.ra_1 ge 0.0,count)
 vol1 = where(zoo.redshift ge 0.01 and zoo.redshift le 0.035 and zoo.petromag_mr le -19.0 and pstar lt 0.5, count)
; Final sample
; print,'Sample is everything pstar<0.5' & sel=all
 print, 'Sample is 0.01 < z < 0.035 and Mr< -19 and pstar lt 0.5' & sel=vol1

 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]
 ;mwrfits,zoo,'GZ2_Vol_limit0.035.fits'

; Removed disturbed etc. 
 podd=zoo.T06_ODD_A14_YES_DEBIASED
 Nodd=zoo.T06_ODD_A14_YES_COUNT
 pmerger=zoo.T08_ODD_FEATURE_A21_DISTURBED_DEBIASED
 pdist=zoo.T08_ODD_FEATURE_A24_MERGER_DEBIASED
 pirr=zoo.T08_ODD_FEATURE_A22_IRREGULAR_DEBIASED
 normal=where(podd lt 0.42 or Nodd lt 20 or (pmerger+pdist+pirr) lt 0.6,count)
 print, 'Number normal galaxies: ', count
 print, 'Sample is non disturbed' & sel=normal
 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]


 pfeatures=zoo.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
 psmooth=zoo.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_DEBIASED
 Nfeatures=zoo.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_COUNT
 Nsmooth=zoo.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_COUNT 

 smooth=where(psmooth ge 0.469 and Nsmooth ge 20,count1)
 print, 'Smooth tree: ',count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1))
 features=where(pfeatures ge 0.430 and Nfeatures ge 20,count1)
 print, 'Featured tree: ',count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1))
 
 

; spirals=where(pfeatures ge 0.430 and pnotedgeon ge 0.715 and pspiralarms ge 0.619 and Nspiralarms ge 20, count)
; print, 'Sample is oblique spirals with visible arms' & sel=spirals
 all=where(zoo.ra_1 ge 0.0,count)
; print, 'Sample is all of this' & sel=all
 print,'Sample is featured galaxies ' & sel=features

 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]

 pedgeon=zoo.T02_EDGEON_A04_YES_DEBIASED
 Nedgeon=zoo.T02_EDGEON_A04_YES_COUNT
 pnotedgeon=zoo.T02_EDGEON_A05_NO_DEBIASED
 Nnotedgeon=zoo.T02_EDGEON_A05_NO_COUNT
 pspiralarms=zoo.T04_SPIRAL_A08_SPIRAL_DEBIASED
 Nspiralarms=zoo.T04_SPIRAL_A08_SPIRAL_COUNT
 gr=zoo.petromag_mg-zoo.petromag_mr

 find=where(pedgeon gt 0.8,count)
 print,'Edge on', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))

 oblique=where(pnotedgeon ge 0.715 and Nnotedgeon ge 20,count)
 print,'Not edge on', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))


; plothist,pedgeon,bin=0.1

 print,'Sample is oblique galaxies ' & sel=oblique
 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]

;Select example images
 example=where(zoo.redshift ge 0.025 and zoo.redshift lt 0.035,count)
 print,'Sample is 0.25<z<0.25 ' & sel=example
 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]


 pbar=zoo.T03_BAR_A06_BAR_DEBIASED
 pspiral=zoo.T04_SPIRAL_A08_SPIRAL_DEBIASED
 
 x=0.25
 

 find=where(pbar gt 0.5,count)
 print,'Pbar>0.5', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))
 index=nint(x*count) -1
 print,'Example: ', zoo[find[index]].objid,zoo[find[index]].ra_1,zoo[find[index]].dec_1,pbar[find[index]],pspiral[find[index]]

 find=where(pbar gt 0.2 and pbar le 0.5,count)
 print,'0.2<Pbar<0.5', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))
 index=nint(x*count) -1
 print,'Example: ', zoo[find[index]].objid,zoo[find[index]].ra_1,zoo[find[index]].dec_1,pbar[find[index]],pspiral[find[index]]

 find=where(pbar le 0.2,count)
 print,'Pbar<0.2', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))
 index=nint(x*count) -1
 print,'Example: ', zoo[find[index]].objid,zoo[find[index]].ra_1,zoo[find[index]].dec_1,pbar[find[index]],pspiral[find[index]]


 find=where(pspiral gt 0.5,count)
 print,'Pspiral>0.5', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))
 index=nint(x*count) -1
 print,'Example: ', zoo[find[index]].objid,zoo[find[index]].ra_1,zoo[find[index]].dec_1,pbar[find[index]],pspiral[find[index]]

 find=where(pspiral gt 0.2 and pspiral le 0.5,count)
 print,'0.2<Pspiral<0.5', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))
 index=nint(x*count) -1
 print,'Example: ', zoo[find[index]].objid,zoo[find[index]].ra_1,zoo[find[index]].dec_1,pbar[find[index]],pspiral[find[index]]

 find=where(pspiral le 0.2,count)
 print,'Pspiral<0.2', count, 1.*count/(1.*n_elements(zoo[sel].ra_1))
 index=nint(x*count) -1
 print,'Example: ', zoo[find[index]].objid,zoo[find[index]].ra_1,zoo[find[index]].dec_1,pbar[find[index]],pspiral[find[index]]


STOP
END
bulgewinding
END
