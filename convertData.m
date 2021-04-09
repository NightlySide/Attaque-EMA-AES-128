function convertData()
    %% load libs
    addpath(fullfile(pwd, "lib"))

    %% getting folder infos
    folderSrc = fullfile(pwd, "data");
    csvFiles = dir(fullfile(folderSrc, "*.csv")); 
    folderDst = fullfile(pwd, "data_converted");
    cacheFolder = fullfile(pwd, "cache");

    %% converting only if it hasn't been done before
    if size(dir(folderDst), 1) < length(csvFiles) + 2
        disp("Converting data to high performance files (this will be done only once)")
        for j = progress(1:length(csvFiles)) 
            data = readmatrix(fullfile(folderSrc, csvFiles(j).name));
            save(fullfile(folderDst, csvFiles(j).name), 'data');
        end
    else
        disp("No need to convert data as it has already be done.")
    end
    
    %% creating a single file with all data
    if exist(fullfile(cacheFolder, "fuites.mat"), "file") == 0
        disp("Creating a single file with all data into it")
        fuites = zeros(length(csvFiles), 4000);
        for j = progress(1:length(csvFiles))
            fuites(j, :) = load(fullfile(folderDst, csvFiles(j).name), '-mat').data;
        end
        disp("Saving file to cache")
        save(fullfile(cacheFolder, "fuites.mat"), "fuites");
    end
end