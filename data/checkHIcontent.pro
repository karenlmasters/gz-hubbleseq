PRO makeDataTables

;  zoo=mrdfits('Bar_0.06_nbar25_10_v2.fits',1)
;  zoo=mrdfits('bar0.06_nbar25_10.fits',1)
;This is file made by ~/GalaxyZoo/Bars/FinalGZ2/volumelimit.pro which
;is similar to the sample used by Ramin. Volume limit is to z=0.06,
;Mr=-20.15. It shows qualitatively the same colour bar fraction trend
;as we published, but is more objects (and correct volume limit). 
  zoo=mrdfits('GZ2_sample_specz.fits',1)
;This one as above but 0.01<z<0.05

;ALFALFA redshift limit is cz=18,000 km/s or z=0.06
;  find=where(zoo.redshift le 0.06,count)
;  print,'Galaxy Zoo targets in redshift range is : ',count
;  zoo=zoo[find]
 
;  restore,filename=('../tab4karen_template.dat')
;  alfalfa=read_ascii('../data/tab4karen101025.txt',template=template)

  

  ra_hi=strcompress(alfalfa.ra_opt,/remove_all)
  dec_hi=strcompress(alfalfa.dec_opt,/remove_all)
;z=0.01 is v=3000 km/s
  
  find=where(ra_hi ne '0000000' and dec_hi ne '000000' and ra_hi ne '       ' and dec_hi ne '      ' and alfalfa.v21 ge 3000,count)
  print,'ALFALFA sources with optical IDs in redshift range of GZ is: ',count
  
  ra_hi=ra_hi[find]
  dec_hi=dec_hi[find]
  logmh=alfalfa.logmh[find]
  agc=alfalfa.agc[find]
  v21=alfalfa.v21[find]
  w50=alfalfa.w50[find]


;  n=n_elements(alfalfa.agc)
;  rah=strmid(ra_hi,0,2)
  rah=strmid(ra_hi,0,2);,rah,format='(i2)'
  ram=strmid(ra_hi,2,2);,ram,format='(i2)'
  ras=strmid(ra_hi,4,4);,ras,format='(i2)'
  sign=strmid(dec_hi,0,1)
  decd=strmid(dec_hi,1,2)
  decm=strmid(dec_hi,3,2)
  decs=strmid(dec_hi,5,2)

  rah_hi=rah+(ram+ras/60.)/60.
  ra_hi=rah_hi*15.
  dec_hi=decd+(decm+decs/60.)/60.
  find=where(sign ne '+',count)
  if (count ne 0) then print, 'Check sign errors on Declinations', count

   forprint,agc,ra_hi,dec_hi,logmh,v21,w50,textout='ALFALFAdata.txt'
  
; Remove ALFALFA objects with no optical counterpart or those outside
; of SDSS footprint
  ra=ra_hi
  dec=dec_hi
  find=where(ra gt 110.35 and ra le 250.196 and ((dec ge 3.7 and dec le 16.33) or (dec ge 23.8 and dec le 28.23) and v21 le 15100),count)

  print,'Number of ALFALFA sources with possible SDSS overlap z<0.05 ', count
  ra_hi=ra_hi[find]
  dec_hi=dec_hi[find]
  logmh=logmh[find]
  agc=agc[find]
  v21=v21[find]
  w50=w50[find]

;Put gap in GZ data
  ra=zoo.ra
  dec=zoo.dec
  find=where(ra gt 110.35 and ra le 250.196 and ((dec ge 3.7 and dec le 16.33) or (dec ge 23.8 and dec le 28.23)),count)
  print,'Number Galaxy Zoo sources within area observed by ALFALFA: ',count

  zoo=zoo[find]
 
  all=where(zoo.ra ge 0.0,count)

; Final sample
 print,'Sample is everything' & sel=all

 print,'Number is sample is: ',n_elements(zoo[sel].ra)
  zoo=zoo[sel]

  matches=0*zoo.ra
  index=-99*zoo.ra/zoo.ra
  sep=zoo.ra*0.
  smax=10.

;Match with ALFALFA sources
  for i=0,(n_elements(zoo.ra) -1) do begin

     s=sqrt(((zoo[i].ra-ra_hi)*cos(zoo[i].dec*!pi/180.))^2+(zoo[i].dec-dec_hi)^2)
     s=s*3600.
;     find=where(s le 60.,count)
     find=where(s eq min(s) and min(s) le smax,link)
     sep[i]=min(s)
     check=where(s le smax,count) 
     matches[i]=count
     if (link ne 0) then index[i]=find[0]
  endfor

  find=where(matches ge 1,nmatch)
  print,'Number matches within ',smax, ' arcsec is ',nmatch

  index=index[find]
  forprint,agc[index],ra_hi[index],dec_hi[index],logmh[index],zoo[find].ra,zoo[find].dec,zoo[find].objid,textout='junk.txt',format='I,F,F,F,F,F,A'

  forprint,zoo[find].objid,zoo[find].ra,zoo[find].dec,textout='list.txt'

  gzalfa=create_struct(zoo[0],'agc',100000,'ra_hi',0.0,'dec_hi',0.0,'logmh',0.0,'v21',0,'w50',0)
  gzalfa=replicate(gzalfa,N_elements(zoo.ra))
  copy_struct,zoo,gzalfa
  gzalfa[find].agc=agc[index]
  gzalfa[find].ra_hi=ra_hi[index]
  gzalfa[find].dec_hi=dec_hi[index]
  gzalfa[find].logmh=logmh[index]
  gzalfa[find].v21=v21[index]
  gzalfa[find].w50=w50[index]

  ;mwrfits,gzalfa,'Bars_ALFALFAmatch3.fits'
                                ;mwrfits,gzalfa,'Bars_ALFALFAmatch4.fits'
                                ;- this one with the correct volume
                                ;  limit
;mwrfits,gzalfa,'Bars_ALFALFAmatch0.05.fits' for 0.01<z<0.05
;mwrfits,gzalfa,'Bars_ALFALFAmatch0.05_v2.fits' fixed truncation
;problem with ALFALFA IDs.
STOP
END
makeDataTables
END
