function [vectorTrace,PTI,CTO] = readTrace(folderSrc,tracename)
% use : readTrace(folderSrc,algo,tracename)
%
% Author : Victor LOMNE - victor.lomne@lirmm.fr
%
%Modified Florent Bruguier
%
% folderSrc : path of folder containing traces
%
% tracename : filename string of the trace

% read trace
vectorTraceCsv = csvread(fullfile(folderSrc,tracename));

% get size of the trace
L = size(vectorTraceCsv,1);

% get the good line/column
if(L == 1)
    vectorTrace = vectorTraceCsv;
else
    if(size(vectorTraceCsv,2) == 2)
        vectorTrace = transpose(vectorTraceCsv(:,2));
    else
        vectorTrace = transpose(vectorTraceCsv(:,1));
    end;
end;

% get the PTI and CTO in decimal
        
        % get the PTI & the CTO in decimal
        [header,body] = strtok(tracename,'=');
        
        % find the PTI
        PTIhex = body(1,39:70);
        PTI(1,1) = hex2dec(PTIhex(1,1:2));
        PTI(1,2) = hex2dec(PTIhex(1,3:4));
        PTI(1,3) = hex2dec(PTIhex(1,5:6));
        PTI(1,4) = hex2dec(PTIhex(1,7:8));
        PTI(1,5) = hex2dec(PTIhex(1,9:10));
        PTI(1,6) = hex2dec(PTIhex(1,11:12));
        PTI(1,7) = hex2dec(PTIhex(1,13:14));
        PTI(1,8) = hex2dec(PTIhex(1,15:16));
        PTI(1,9) = hex2dec(PTIhex(1,17:18));
        PTI(1,10) = hex2dec(PTIhex(1,19:20));
        PTI(1,11) = hex2dec(PTIhex(1,21:22));
        PTI(1,12) = hex2dec(PTIhex(1,23:24));
        PTI(1,13) = hex2dec(PTIhex(1,25:26));
        PTI(1,14) = hex2dec(PTIhex(1,27:28));
        PTI(1,15) = hex2dec(PTIhex(1,29:30));
        PTI(1,16) = hex2dec(PTIhex(1,31:32));
        
        % find the CTO
        CTOhex = body(1,76:107);
        CTO(1,1) = hex2dec(CTOhex(1,1:2));
        CTO(1,2) = hex2dec(CTOhex(1,3:4));
        CTO(1,3) = hex2dec(CTOhex(1,5:6));
        CTO(1,4) = hex2dec(CTOhex(1,7:8));
        CTO(1,5) = hex2dec(CTOhex(1,9:10));
        CTO(1,6) = hex2dec(CTOhex(1,11:12));
        CTO(1,7) = hex2dec(CTOhex(1,13:14));
        CTO(1,8) = hex2dec(CTOhex(1,15:16));
        CTO(1,9) = hex2dec(CTOhex(1,17:18));
        CTO(1,10) = hex2dec(CTOhex(1,19:20));
        CTO(1,11) = hex2dec(CTOhex(1,21:22));
        CTO(1,12) = hex2dec(CTOhex(1,23:24));
        CTO(1,13) = hex2dec(CTOhex(1,25:26));
        CTO(1,14) = hex2dec(CTOhex(1,27:28));
        CTO(1,15) = hex2dec(CTOhex(1,29:30));
        CTO(1,16) = hex2dec(CTOhex(1,31:32));
