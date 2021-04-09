function createFolders()
    folders = ["cache", "data_converted"];

    for k = 1:length(folders)
        if exist(folders(k), "dir") == 0
            disp("Creating folder: " + folders(k))
            mkdir(folders(k))
        end
    end
end