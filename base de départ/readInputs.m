function [key,matrixFilename,L] = readInputs(folderSrc,inputOrder,ceil)
% use : readInputs(folderSrc,algo,inputOrder,ceil)
%
% Author : Victor LOMNE - victor.lomne@lirmm.fr
%
% folderSrc : path of folder containing traces
%
% algo : cryptographic attacked algorithm
%        'DES'     -> DES
%        'sboxDES' -> sbox DES n°1
%        'AES'     -> AES
%        'sboxAES' -> sbox AES
%
% inputOrder : order in which are raised traces
%              'chrono'  -> chronological order
%              'db'      -> order provided by the select function of SQL language (dpacontest only)
%              'riscure' -> riscure order (dpacontest only)
%              'tohoku'  -> tohoku order (dpacontest only)
%              'stat'    -> statistically optimized order
%              'custom'  -> custom order
%              'random'  -> random order
%
% ceil : iteration where we stop the DPA, even if key is not broken

% open filelist following wanted order
switch(inputOrder)
    case 'chrono'
        fid = fopen(fullfile(folderSrc,'filelistChronologicalOrder.txt'));
        if(fid == -1)
            createFilelist(folderSrc);
            fid = fopen(fullfile(folderSrc,'filelistChronologicalOrder.txt'));
        end;
    case 'db'
        fid = fopen(fullfile(folderSrc,'filelistDataBaseOrder.txt'));
    case 'riscure'
        fid = fopen(fullfile(folderSrc,'filelistRiscureOrder.txt'));
    case 'tohoku'
        fid = fopen(fullfile(folderSrc,'filelistTohokuOrder.txt'));
    case 'torusPoint'
        fid = fopen(fullfile(folderSrc,'filelistTorusPoint.txt'));
    case 'stat'
        fid = fopen(fullfile(folderSrc,'filelistStatOrder.txt'));
    case 'custom'
        fid = fopen(fullfile(folderSrc,'filelistCustomOrder.txt'));
    case 'random'
        fid = fopen(fullfile(folderSrc,'filelistRandomOrder.txt'));
end;

% read N first inputs
for i = 1 : ceil
    matrixFilename(i,:) = fgetl(fid);
end;

% close pointer on file
fclose(fid);

% get size of each trace
trace = csvread(fullfile(folderSrc,matrixFilename(1,:)));
L = size(trace,1);
if(L == 1)
    L = size(trace,2);
end;

% get the key in decimal

        [header,body] = strtok(matrixFilename(1,:),'=');
        K = body(1,2:33);
        key(1,1) = hex2dec(K(1,1:2));
        key(1,2) = hex2dec(K(1,3:4));
        key(1,3) = hex2dec(K(1,5:6));
        key(1,4) = hex2dec(K(1,7:8));
        key(1,5) = hex2dec(K(1,9:10));
        key(1,6) = hex2dec(K(1,11:12));
        key(1,7) = hex2dec(K(1,13:14));
        key(1,8) = hex2dec(K(1,15:16));
        key(1,9) = hex2dec(K(1,17:18));
        key(1,10) = hex2dec(K(1,19:20));
        key(1,11) = hex2dec(K(1,21:22));
        key(1,12) = hex2dec(K(1,23:24));
        key(1,13) = hex2dec(K(1,25:26));
        key(1,14) = hex2dec(K(1,27:28));
        key(1,15) = hex2dec(K(1,29:30));
        key(1,16) = hex2dec(K(1,31:32));

disp('inputs read !');