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

 podd=zoo.T06_ODD_A14_YES_DEBIASED
 Nodd=zoo.T06_ODD_A14_YES_COUNT
 pmerger=zoo.T08_ODD_FEATURE_A21_DISTURBED_DEBIASED
 pdist=zoo.T08_ODD_FEATURE_A24_MERGER_DEBIASED
 pirr=zoo.T08_ODD_FEATURE_A22_IRREGULAR_DEBIASED

 irregular=where(podd ge 0.42 and Nodd ge 20 and (pmerger+pdist+pirr) ge 0.6,count)
 print, 'Number of disturbed, irregular or merging galaxies: ',count
; forprint,zoo[irregular[0:50]].objid,zoo[irregular[0:50]].ra_1,zoo[irregular[0:50]].dec_1,pmerger[irregular[0:50]],pdist[irregular[0:50]],pirr[irregular[0:50]]

 find=where(pmerger[irregular] gt pdist[irregular] and pmerger[irregular] gt pirr[irregular],count) & print, 'Merger: ',count
 find=where(pdist[irregular] gt pmerger[irregular] and pdist[irregular] gt pirr[irregular],count) & print, 'Distrurbed: ',count
 find=where(pirr[irregular] gt pmerger[irregular] and pirr[irregular] gt pdist[irregular],count) & print, 'Irregular: ',count
 

 normal=where(podd lt 0.42 or Nodd lt 20 or (pmerger+pdist+pirr) lt 0.6,count)
 print, 'Number normal galaxies: ', count

 print, 'Sample is non disturbed' & sel=normal
 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]

 pfeatures=zoo.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
 psmooth=zoo.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_DEBIASED
 Nfeatures=zoo.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_COUNT
 Nsmooth=zoo.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_COUNT 

 find=where(psmooth ge 0.8,count1)
 find=where(psmooth ge 0.5,count2)
 find=where(pfeatures ge 0.8,count3)
 find=where(pfeatures ge 0.5,count4)
 find=where(psmooth gt pfeatures, count5)
 find=where(pfeatures gt psmooth, count6)

 print,'Morphology distribution smooth 80%, smooth 50%, features 80%, features 50%, smooth>features, features>smooth'
 print,count1, count2, count3, count4, count5, count6
 print,1.*count1/(1.*n_elements(zoo[sel].ra_1)),1.*count2/(1.*n_elements(zoo[sel].ra_1)),1.*count3/(1.*n_elements(zoo[sel].ra_1)),1.*count4/(1.*n_elements(zoo[sel].ra_1)),1.*count5/(1.*n_elements(zoo[sel].ra_1)),1.*count6/(1.*n_elements(zoo[sel].ra_1))

 find=where(psmooth ge 0.469 and Nsmooth ge 20,count1)
 print, 'Smooth tree: ',count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1))
 find=where(pfeatures ge 0.430 and Nfeatures ge 20,count1)
 print, 'Featured tree: ',count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1))
 

 pnotedgeon=zoo.T02_EDGEON_A05_NO_DEBIASED
; Nnotedgeon=zoo.T02_EDGEON_A05_NO_DEBIASED
 pspiralarms=zoo.T04_SPIRAL_A08_SPIRAL_DEBIASED
 Nspiralarms=zoo.T04_SPIRAL_A08_SPIRAL_COUNT
 gr=zoo.petromag_mg-zoo.petromag_mr

 spirals=where(pfeatures ge 0.430 and pnotedgeon ge 0.715 and pspiralarms ge 0.619 and Nspiralarms ge 20, count)
; print, 'Sample is oblique spirals with visible arms' & sel=spirals
 all=where(zoo.ra_1 ge 0.0,count)
 print, 'Sample is all of this' & sel=all

 print,'Number is sample is: ',n_elements(zoo[sel].ra_1)
 zoo=zoo[sel]


  y=pfeatures
  miny=-0.2
  maxy=1.2
  biny=0.1

  x=zoo.petromag_mr
  minx=-23.0
  maxx=-18.9
  binx=0.1

  erase & multiplot,[2,2]

; plot,[0,0],[0,0],ytitle=textoIDL('(g-r)'),xrange=[maxx,minx],yrange=[miny,maxy],xstyle=1,ystyle=1,charsize=1.5,thick=3 
 plot,x,y,psym=3,ytitle=textoIDL('p_{features}'),xtitle=textoIDL('M_r'),xrange=[-19.0,minx],yrange=[0,1.0],xstyle=1,ystyle=1,charsize=1.5,thick=3
; plot,[0,0],[0,0],ytitle=textoIDL('(g-r)'),yrange=[miny,maxy],xrange=[minx,maxx],xstyle=1,ystyle=1,charsize=1.5,thick=3 

  dens=hist_2d(x,y,min1=minx,max1=maxx,min2=miny,max2=maxy,bin1=binx,bin2=biny)
;Smoooth the contours
  xc=minx+binx*indgen(nint((maxx-minx)/binx)+1)
  yc=miny+biny*indgen(nint((maxy-miny)/biny)+1)
  dens2=min_curve_surf(dens);,NX = nx0,NY = ny0)
  nx0=26
  ny0=26
  xc2=minx+((maxx-minx)/nx0)+indgen(nint(nx0))*(maxx-minx)/nx0
  yc2=miny+(maxy-miny)/ny0+indgen(nint(ny0))*(maxy-miny)/ny0

  
  l=10.
  levels=max(dens)*(1+indgen(l))/l
  ;levels=[1,2,3,4,5,6,7,]
  
  nn=l
  contour,dens2,xc2,yc2,/overplot,levels=levels,/fill,c_colors=reverse([0, findgen(nn)*255/nn, 255]);
  contour,dens2,xc2,yc2,/overplot,levels=levels
;  contour,dens,xc,yc,/overplot,levels=levels,/fill,c_colors=reverse([0, findgen(nn)*255/nn, 255]);
;  contour,dens,xc,yc,/overplot,levels=levels
;  oplot,x,y,psym=3

  multiplot
  multiplot
 
  y=gr
  miny=0.1
  maxy=0.9
  biny=0.1 

  plot,x,y,psym=3,ytitle=textoIDL('(g-r)'),xtitle=textoIDL('M_r'),xrange=[maxx,minx],yrange=[miny,maxy],xstyle=1,ystyle=1,charsize=1.5,thick=3
  dens=hist_2d(x,y,min1=minx,max1=maxx,min2=miny,max2=maxy,bin1=binx,bin2=biny)
;Smoooth the contours
  xc=minx+binx*indgen(nint((maxx-minx)/binx))
  yc=miny+biny*indgen(nint((maxy-miny)/biny)+1)
  dens2=min_curve_surf(dens);,NX = nx0,NY = ny0)
  nx0=26
  ny0=26
  xc2=minx+(maxx-minx)/nx0+indgen(nint(nx0))*(maxx-minx)/nx0
  yc2=miny+indgen(nint(ny0))*(maxy-miny)/ny0
  
  l=10.
  levels=max(dens)*(1+indgen(l))/l
  ;levels=[1,2,3,4,5,6,7,]
  
  nn=l
  contour,dens2,xc2,yc2,/overplot,levels=levels,/fill,c_colors=reverse([0, findgen(nn)*255/nn, 255]);
  contour,dens2,xc2,yc2,/overplot,levels=levels
;  oplot,x,y,psym=3
 
  multiplot

  x=pfeatures
  minx=-0.2
  maxx=1.0
  binx=0.1

  plot,x,y,psym=3,xtitle=textoIDL('p_{features}'),xrange=[0,maxx],yrange=[miny,maxy],xstyle=1,ystyle=1,charsize=1.5,thick=3
  dens=hist_2d(x,y,min1=minx,max1=maxx,min2=miny,max2=maxy,bin1=binx,bin2=biny)
;Smoooth the contours
  xc=minx+binx*indgen(nint((maxx-minx)/binx))
  yc=miny+biny*indgen(nint((maxy-miny)/biny)+1)
  dens2=min_curve_surf(dens);,NX = nx0,NY = ny0)
  nx0=26
  ny0=26
  xc2=minx+((maxx-minx)/nx0)+indgen(nint(nx0))*(maxx-minx)/nx0
  yc2=miny+indgen(nint(ny0))*(maxy-miny)/ny0
  
  l=10.
  levels=max(dens)*(1+indgen(l))/l
  ;levels=[1,2,3,4,5,6,7,]
  
  nn=l
  contour,dens2,xc2,yc2,/overplot,levels=levels,/fill,c_colors=reverse([0, findgen(nn)*255/nn, 255]);
  contour,dens2,xc2,yc2,/overplot,levels=levels
;  oplot,x,y,psym=3



  multiplot,/default

;  find=where(zoo.redshift ge 0.025 and zoo.redshift lt 0.035,count)
  find=where(zoo.redshift ge -100,count)
  example=zoo[find]

  dim=where(example.petromag_mr ge -20,Ndim)
  mid1=where(example.petromag_mr lt -20 and example.petromag_mr ge -21,N1)
  mid2=where(example.petromag_mr lt -21 and example.petromag_mr ge -22,N2)
  brt=where(example.petromag_mr le -22,Nbrt)

  print,Ndim,N1,N2,Nbrt

  print,'Selection is dim ' &  sel=dim
  out=example[sel]
  pfeatures=out.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
  psmooth=out.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_DEBIASED

  find1=where(pfeatures gt psmooth,count1)
  find2=where(psmooth gt pfeatures,count2)
  print,'Morphology distribution (Featured then Smooth): ', count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1)), count2, 1.*count2/(1.*n_elements(zoo[sel].ra_1))
  index1=Nint(randomu(seed)*count1)
  index2=Nint(randomu(seed)*count2)
  print,'Featured: ', out[find1[index1]].objid,psmooth[find1[index1]],pfeatures[find1[index1]]
  print,'Smooth: ',out[find2[index2]].objid,psmooth[find2[index2]],pfeatures[find2[index2]]
  
  print,'Selection is mid1 ' & sel=mid1
  out=example[sel]
  pfeatures=out.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
  psmooth=out.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_DEBIASED

  find1=where(pfeatures gt psmooth,count1)
  find2=where(psmooth gt pfeatures,count2)
  print,'Morphology distribution (Featured then Smooth): ', count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1)), count2, 1.*count2/(1.*n_elements(zoo[sel].ra_1))
   index1=Nint(randomu(seed)*count1)
  index2=Nint(randomu(seed)*count2)
  print,'Featured: ', out[find1[index1]].objid,psmooth[find1[index1]],pfeatures[find1[index1]]
  print,'Smooth: ',out[find2[index2]].objid,psmooth[find2[index2]],pfeatures[find2[index2]]
  
   print,'Selection is mid2 ' &  sel=mid2
  out=example[sel]
  pfeatures=out.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
  psmooth=out.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_DEBIASED

  find1=where(pfeatures gt psmooth,count1)
  find2=where(psmooth gt pfeatures,count2)
  print,'Morphology distribution (Featured then Smooth): ', count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1)), count2, 1.*count2/(1.*n_elements(zoo[sel].ra_1))
   index1=Nint(randomu(seed)*count1)
  index2=Nint(randomu(seed)*count2)
  print,'Featured: ', out[find1[index1]].objid,psmooth[find1[index1]],pfeatures[find1[index1]]
  print,'Smooth: ',out[find2[index2]].objid,psmooth[find2[index2]],pfeatures[find2[index2]]
  
  print,'Selection is bright ' &  sel=brt
  out=example[sel]
  pfeatures=out.T01_SMOOTH_OR_FEATURES_A02_FEATURES_OR_DISK_DEBIASED
  psmooth=out.T01_SMOOTH_OR_FEATURES_A01_SMOOTH_DEBIASED

  find1=where(pfeatures gt psmooth,count1)
  find2=where(psmooth gt pfeatures,count2)
  print,'Morphology distribution (Featured then Smooth): ', count1, 1.*count1/(1.*n_elements(zoo[sel].ra_1)), count2, 1.*count2/(1.*n_elements(zoo[sel].ra_1))
   index1=Nint(randomu(seed)*count1)
  index2=Nint(randomu(seed)*count2)
  print,'Featured: ', out[find1[index1]].objid,psmooth[find1[index1]],pfeatures[find1[index1]]
  print,'Smooth: ',out[find2[index2]].objid,psmooth[find2[index2]],pfeatures[find2[index2]]
  

  

STOP
END
bulgewinding
END
