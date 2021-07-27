% images=spm_select(Inf,'image',[],[],[],'t1')
% spect=spm_select(Inf,'^meas.*_metab\.dat$')

images=cell_rdir('*/*t1*.nii');
spect=cell_rdir('*/meas*_metab.dat');

CoRegStandAlone(spect,images)