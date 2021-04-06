%% load libs
addpath(fullfile(pwd, 'lib'))

%% convert data
folderSrc = fullfile(pwd, 'data');
folderInfo = dir(folderSrc); 
folderDst = fullfile(pwd, 'data_converted');

for j = progress(3:20002) 
    data = readmatrix(fullfile(folderSrc, folderInfo(j).name));
    save(fullfile(folderDst, folderInfo(j).name), 'data');
end