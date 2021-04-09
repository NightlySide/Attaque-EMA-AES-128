function convertData()
    %% load libs
    addpath(fullfile(pwd, "lib"))

    %% getting folder infos
    folderSrc = fullfile(pwd, "data");
    folderInfo = dir(folderSrc); 
    folderDst = fullfile(pwd, "data_converted");

    %% converting only if it hasn't been done before
    if size(dir(folderDst), 1) < 20002
        disp("Converting data to high performance files (this will be done only once)")
        for j = progress(3:20002) 
            data = readmatrix(fullfile(folderSrc, folderInfo(j).name));
            save(fullfile(folderDst, folderInfo(j).name), 'data');
        end
    else
        disp("No need to convert data as it has already be done.")
    end
end