PRO bulgewinding

;  zoo=mrdfits('Bar_0.06_nbar25_10_v2.fits',1)
;  zoo=mrdfits('bar0.06_nbar25_10.fits',1)
;This is file made by ~/GalaxyZoo/Bars/FinalGZ2/volumelimit.pro which
;is similar to the sample used by Ramin. Volume limit is to z=0.06,
;Mr=-20.15. It shows qualitatively the same colour bar fraction trend
;as we published, but is more objects (and correct volume limit). 
;  zoo=mrdfits('GZ2_sample_specz.fits',1)
 zoo=mrdfits('GZ2_Vol_limit0.035.fits',1)

 all=where(zoo.ra_1 ge 0.0,count)
 vol1 = where(zoo.redshift ge 0.01 and zoo.redshift le 0.035 and zoo.petromag_mr le -19.0, count)
; Final sample
; print,'Sample is everything' & sel=all
 print, 'Sample is 0.01 < z < 0.035 and Mr< -19' & sel=vol1

 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]
 ;mwrfits,zoo,'GZ2_Vol_limit0.035.fits'

 pfeatures=zoo.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
 pnotedgeon=zoo.T02_EDGEON_A05_NO_DEBIASED
; Nnotedgeon=zoo.T02_EDGEON_A05_NO_DEBIASED
 pspiralarms=zoo.T04_SPIRAL_A08_SPIRAL_DEBIASED
 Nspiralarms=zoo.T04_SPIRAL_A08_SPIRAL_COUNT

 spirals=where(pfeatures ge 0.430 and pnotedgeon ge 0.715 and pspiralarms ge 0.619 and Nspiralarms ge 20, count)
 print,count
 print, 'Sample is oblique spirals with visible arms' & sel=spirals

 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]


 pnobulge=zoo.T05_BULGE_PROMINENCE_A10_NO_BULGE_DEBIASED
 pjust=zoo.T05_BULGE_PROMINENCE_A11_JUST_NOTICEABLE_DEBIASED
 pobvious=zoo.T05_BULGE_PROMINENCE_A12_OBVIOUS_DEBIASED
 pdominant=zoo.T05_BULGE_PROMINENCE_A13_DOMINANT_DEBIASED

 ploose=zoo.T10_ARMS_WINDING_A30_LOOSE_DEBIASED
 pmedium=zoo.T10_ARMS_WINDING_A29_MEDIUM_DEBIASED
 ptight=zoo.T10_ARMS_WINDING_A28_TIGHT_DEBIASED

 Bsize = 0.0*pnobulge+0.2*pjust+0.8*pobvious+1.0*pdominant
 AWinding = 0.0*ploose + 0.5*pmedium + 1.0*ptight
  
  y=Awinding
  miny=0
  maxy=1.0
  biny=0.1


  x=Bsize
  minx=0
  maxx=1.0
  binx=0.1

; plot,[0,0],[0,0],ytitle=textoIDL('(g-r)'),xrange=[maxx,minx],yrange=[miny,maxy],xstyle=1,ystyle=1,charsize=1.5,thick=3 
 plot,x,y,psym=3,ytitle=textoIDL('GZ Arm Winding'),xtitle=textoIDL('GZ Bulge Size'),xrange=[minx,maxx],yrange=[miny,maxy],xstyle=1,ystyle=1,charsize=1.5,thick=3
; plot,[0,0],[0,0],ytitle=textoIDL('(g-r)'),yrange=[miny,maxy],xrange=[minx,maxx],xstyle=1,ystyle=1,charsize=1.5,thick=3 

  dens=hist_2d(x,y,min1=minx,max1=maxx,min2=miny,max2=maxy,bin1=binx,bin2=biny)
;Smoooth the contours
  xc=minx+binx*indgen(nint((maxx-minx)/binx))
  yc=miny+biny*indgen(nint((maxy-miny)/biny)+1)
  dens2=min_curve_surf(dens);,NX = nx0,NY = ny0)
  nx0=26
  ny0=26
  xc2=minx+indgen(nint(nx0))*(maxx-minx)/nx0
  yc2=miny+indgen(nint(ny0))*(maxy-miny)/ny0
  
  l=10.
  levels=max(dens)*(1+indgen(l))/l
  ;levels=[1,2,3,4,5,6,7,]
  
  nn=l
  contour,dens2,xc2,yc2,/overplot,levels=levels,/fill,c_colors=reverse([0, findgen(nn)*255/nn, 255]);
  contour,dens2,xc2,yc2,/overplot,levels=levels



STOP
END
bulgewinding
END
