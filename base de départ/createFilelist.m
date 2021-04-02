function y = createFilelist(folderSrc)
% use : createFilelist(folderSrc)
%
% Author : Victor LOMNE - victor.lomne@lirmm.fr
%
% folderSrc : path of folder containing traces

% get filelist
matrixFilelist = dir(folderSrc);

% get the size of the filelist
sizeFilelist = size(matrixFilelist,1);

% create pointer on the file
fid = fopen(fullfile(folderSrc,'filelistChronologicalOrder.txt'),'w');

% loop over the number of files
for i = 1 : sizeFilelist
    
    if( (size(findstr('trace',matrixFilelist(i).name),2) > 0 ) || (size(findstr('wave',matrixFilelist(i).name),2) > 0))
        
        fprintf(fid,'%s\n',matrixFilelist(i).name);
        
    end;
    
end;

% close the file
fclose(fid);

y = 0;