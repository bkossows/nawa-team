#!/usr/bin/env python
# coding: utf-8

# In[16]:


import numpy as np
import matplotlib.pyplot as plt
import suspect
import pydicom
import os
from shutil import copyfile
import subprocess
import sys
import glob


# In[2]:


subj=sys.argv[1]


# In[3]:


#water suppressed spectroscopy 
met=glob.glob(os.path.join(subj,'*metab.dat'))
print(met)
data = suspect.io.load_twix(met[0])
data.shape

# side comment: error in suspect twix loader https://github.com/openmrslab/suspect/issues/145


# In[4]:


#water reference (not suppressed)
wat=glob.glob(os.path.join(subj,'*wref1.dat')) 
wref = suspect.io.load_twix(wat[0])
wref.shape


# In[5]:


#combine channels
channel_weights = suspect.processing.channel_combination.svd_weighting(wref, axis=-2)
cc_wref = suspect.processing.channel_combination.combine_channels(wref, channel_weights)
cc_data = suspect.processing.channel_combination.combine_channels(data, channel_weights)


# In[6]:


cc_data.shape


# In[7]:


#accumulate data
#wref_final = np.mean(cc_wref[0], axis=0)
final = np.mean(cc_data, axis=0)





# create a parameters dictionary to set the basis set to use
params = {
    "FILBAS": "/home/jovyan/work/basis/press_te25_3t_v3.basis",
    "key": 210387309,
    "OWNER": (subj + " done by Bartosz Kossowski"),
    "NEACH": 99,
    "LCSV": 11,
    "LCOORD": 9
}
suspect.io.lcmodel.write_all_files(os.path.join(subj,"example.RAW"), data=final, wref_data=cc_wref, params=params)


# In[26]:


myinput = open(os.path.join(subj,'example_sl0.CONTROL'))
result = subprocess.run("/home/jovyan/.lcmodel/bin/lcmodel",stdin=myinput,stdout=subprocess.PIPE)
subprocess.run(["ps2pdf",os.path.join(subj,"example.PS"),os.path.join(subj,"example.PDF")])
print(result.stdout.decode())





