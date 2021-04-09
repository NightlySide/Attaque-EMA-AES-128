function moyenne = moyenneTraces(folder_name)
    % reference au dossier cache
    cacheDir = fullfile(pwd, "cache");
    
    if exist(fullfile(cacheDir, "moyenne.mat"), "file")
        disp("Loading moyenne from cache")
        moyenne = load(fullfile(cacheDir, "moyenne.mat")).moyenne;
    else
        disp("Calcul de la moyenne")
        % adding the lib folder to path
        addpath(fullfile(pwd, 'lib'))

        % folderInfo
        folderSrc = fullfile(pwd, folder_name);
        traceFiles = dir(fullfile(folderSrc, "*.csv")); 

        moyenne = ones(1, 4000);
        % pour chaque fichier dans le dossier data
        for j = progress(1:length(traceFiles)) 
            % on charge les données et on met a jour la moyenne
            T = load(fullfile(folderSrc, traceFiles(j).name), '-mat').data;
            moyenne = moyenne + T/20000;
        end
        disp("Mise en cache de la moyenne")
        save(fullfile(cacheDir, "moyenne.mat"), "moyenne", "-double");
    end
end