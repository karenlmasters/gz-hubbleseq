""" This python code will take the ../data/GZ_hubbleseq_sample_featured_faceon_spiralarms.fits
file and priduce a contour plot for the locations of the arm winding and bulge size and save
it as bulge_armwinding.pdf"""

import numpy as np 
from matplotlib import pyplot as plt 
from astropy.table import Table 
import os
from hist2d import hist2d

# Here redefine the matplotlib defaults to make nice plots
os.environ['PATH'] = os.environ['PATH'] + ':/usr/texbin'

plt.rc('figure', facecolor='none', edgecolor='none', autolayout=True)
plt.rc('path', simplify=True)
plt.rc('text', usetex=True)
plt.rc('font', family='serif')
plt.rc('axes', labelsize='large', facecolor='none', linewidth=0.7, color_cycle = ['k', 'r', 'g', 'b', 'c', 'm', 'y'])
plt.rc('xtick', labelsize='medium')
plt.rc('ytick', labelsize='medium')
plt.rc('lines', markersize=4, linewidth=1, markeredgewidth=0.2)
plt.rc('legend', numpoints=1, frameon=False, handletextpad=0.3, scatterpoints=1, handlelength=2, handleheight=0.1)
plt.rc('savefig', facecolor='none', edgecolor='none', frameon='False')

params =   {'font.size' : 16,
            'xtick.major.size': 8,
            'ytick.major.size': 8,
            'xtick.minor.size': 3,
            'ytick.minor.size': 3,
            }
plt.rcParams.update(params) 

# Load data from fits table

data = Table.read("../data/GZ_hubbleseq_sample_featured_faceon_spiralarms.fits")

# Calculate bulge size and arm winding as per equations (1) and (2) respectively 
bulgesize = 0.0*data['t05_bulge_prominence_a10_no_bulge_debiased'] + 0.2*data['t05_bulge_prominence_a11_just_noticeable_debiased'] + 0.8*data['t05_bulge_prominence_a12_obvious_debiased'] + 1.0*data['t05_bulge_prominence_a13_dominant_debiased']

armwind = 0.0*data['t10_arms_winding_a30_loose_debiased'] + 0.5*data['t10_arms_winding_a29_medium_debiased'] + 1.0*data['t10_arms_winding_a28_tight_debiased']

# Bin the data for the contour plot
H, X, Y = np.histogram2d(bulgesize, armwind, range=((0,1),(0,1)), bins=20)
Xbins = np.diff(X)/2. + X[:-1]
Ybins = np.diff(Y)/2. + Y[:-1]

# Make the pretty python plot

plt.figure(figsize=(6.5,6))
ax = plt.subplot(111)
# ax.contourf(Xbins, Ybins, H.T, origin='lower', cmap=plt.cm.binary, alpha=0.2)
# ax.contour(Xbins, Ybins, H.T, origin='lower', colors='k')
csl = hist2d(bulgesize, armwind, bins=21, range=((-0.05,1.05),(-0.05,1.05)), smooth=0.5,
           ax=ax, plot_datapoints=True, plot_density=True,
           plot_contours=True, fill_contours=True)
ax.clabel(csl, inline=1, fontsize=12, fmt='%i')
ax.set_xlabel(r'$B_{avg}$')
ax.set_ylabel(r'$w_{avg}$')
# ax.set_xlim(0,1)
# ax.set_ylim(0,1)
ax.minorticks_on()
ax.tick_params(axis='both', which='both', direction='in', top='on', right='on')
plt.tight_layout()
plt.savefig('../bulge_armwinding.pdf')
