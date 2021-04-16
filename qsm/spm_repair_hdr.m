%MEDI
I=spm_read_vols(spm_vol('MEDI.nii'));
H=spm_vol('QSM-te1.nii');
H.fname='rMEDI.nii';
spm_write_vol(H,flip(reshape(I,256,256,64),1));

%STI
I=spm_read_vols(spm_vol('S001_QSM_star.nii'));
H=spm_vol('QSM-te1.nii');
H.fname='rS001_QSM_star.nii';
H.dt=[64,0]; %floats
spm_write_vol(H,flip(flip(I,2),1)); %flip AP

I=spm_read_vols(spm_vol('S001_QSM_iLSQR.nii'));
H=spm_vol('QSM-te1.nii');
H.fname='rS001_QSM_iLSQR.nii';
H.dt=[64,0]; %floats
spm_write_vol(H,flip(flip(I,2),1)); %flip AP