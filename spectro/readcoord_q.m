%function [] = readcoord(datapath);
close all
clear all

files = dir(strcat('F3T_2015_24_0*', '/*.coord'));
num_files = length(files);

if num_files > 0 
	trash_raw = [];
	ppm_raw = zeros(num_files, 320);
	fit_raw = zeros(num_files, 320);
	spectrum_raw = zeros(num_files, 320);
	baseline_raw = zeros(num_files, 320);
	residuum = zeros(num_files, 320);
	
	
	for i=1:num_files
		fprintf('remaining %i\n', (num_files+1)-i)
		fullpath = fullfile(files(i).folder, files(i).name);
		id = fopen(fullpath, 'r');
		C = textscan(id, '%s');
		
		C = [C{:}];
		indexC = strfind(C, 'NY');
		index = find(not(cellfun('isempty', indexC)));
		
		tmp = C(index(1)+1:index(2));
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
		ppm_raw(i,:) = cell2mat(tmp2(ind));

		tmp = C(index(2)+1:index(3));
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
		spectrum_raw(i,:) = cell2mat(tmp2(ind));

		tmp = C(index(3)+1:index(4));
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
		fit_raw(i,:) = cell2mat(tmp2(ind));

		tmp = C(index(4)+1:index(4)+323);
		tmp2 = cellfun(@str2num, tmp, 'UniformOutput', 0);
		ind = not(cellfun('isempty', tmp2));
		baseline_raw(i,:) = cell2mat(tmp2(ind));

		residuum(i,:) = spectrum_raw(i,:) - fit_raw(i,:);
		%figure
		%plot(ppm_raw(i,:).*(-1), spectrum_raw(i,:), 'b');
		%hold on
		%plot(ppm_raw(i,:).*(-1), fit_raw(i,:), 'r');
		%hold on
		%plot(ppm_raw(i,:).*(-1), residuum(i,:), 'g');
		%hold on
		%plot(ppm_raw(i,:).*(-1), baseline_raw(i,:), 'y');
		%x{1} = 'spectrum';
		%x{2} = 'fit';
		%x{3} = 'residual';
		%x{4} = 'baseline';
		%legend(x);
		%xlabel('ppm');
	end
end

% chunks = 100;
% spectrum_temp = spectrum_raw(:,1:3100);
% noise_temp = reshape(spectrum_temp, [num_files, chunks, 3100/chunks]);
% noise_mean = squeeze(mean(noise_temp, 2));
% noise_std = squeeze(std(noise_temp, 0, 2));
% %noise_chunks = sqrt(noise_mean.^2+noise_std.^2)
% noise_chunks = noise_std;
% noise_min = (min(noise_chunks'))';
% 
% residual_std = std(residuum,0,2);
% q = residual_std./noise_min
% 
% save(checkpoint, 'residuum', 'ppm_raw', 'fit_raw', 'spectrum_raw', 'baseline_raw', 'residual_std', 'noise_chunks', 'noise_min', 'q')


spectra_sum = sum(spectrum_raw,1);
fit_sum = sum(fit_raw,1);
baseline_sum = sum(baseline_raw,1);
residuum_sum = spectra_sum - (fit_sum + baseline_sum);

figure
plot(ppm_raw(1,:).*(-1), spectra_sum);
hold on
plot(ppm_raw(1,:).*(-1), fit_sum, 'r');
hold on
plot(ppm_raw(1,:).*(-1), residuum_sum, 'g');
hold on
plot(ppm_raw(1,:).*(-1), baseline_sum, 'y');

x{1} = 'data mean';
x{2} = 'fit mean';
x{3} = 'residual mean';
x{4} = 'baseline'
legend(x);
xlabel('ppm');


return

figure; shadedErrorBar(ppm_raw(1,:),spectrum_raw(bin,:),{@mean,@std},'-r',1)

hold on
shadedErrorBar(ppm_raw(1,:),spectrum_raw(~bin,:),{@mean,@std},'-b',1)

xlim([0.2,4]);
set(gca, 'Xdir', 'reverse')
xlabel('Frequency [ppm]')
