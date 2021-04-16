clear all;
clc;
close all;

folderSrc = 'path-to-B_AES_N4'; 
% Number of traces
ceil = 1000;

% modify the following variables to speed-up the measurement
% (this can be done later after analysing the EM traces)
xMin1 = 3000;
xMax1 = 3500;

inputOrder = 'chrono';

disp(' ');
disp('---------------------------------------------------------------------');
disp('---------------------------------------------------------------------');
disp(' ');
disp('                          Launching CPA ...');
disp(' ');

% trig the clock
t1 = cputime;

% call function readInputs()
% read key, PTIs, CTOs & traces
[key,matrixFilename,L] = readInputs(folderSrc,inputOrder,ceil);

full_key(:,:,:) = uint8(zeros(11,4,4));

cout = 1;
a = 1;
for i=1:4
    for j=1:4
        full_key(a,j,i)=(key(cout));
            cout=cout+1;
    end
end
  
for i = 1 : 10 
 full_key(i+1,:,:) = key_schu(squeeze(full_key(i,:,:)),i);
 i
 end;

% initialize matrixResults
result = zeros(ceil,xMax1-xMin1+1,4,4);


% allocate space for buffers computing the CPA
cyphering1 = uint8(zeros(ceil,256,16));
Weight_Hamm1 =  uint8(zeros(ceil,256,16));
vectorTrace_matrix = zeros(ceil,xMax1-xMin1+1);
vectorTrace_matrix_diff = zeros(ceil,xMax1-xMin1+1);

Weight_Hamming_vect =[0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 4 5 5 6 5 6 6 7 5 6 6 7 6 7 7 8];
SubBytes_vect = [99	124	119	123	242	107	111	197	48 1 103 43 254 215 171 118 202	130	201	125	250	89 71 240 173 212 162 175 156 164 114 192 183 253 147 38 54 63 247 204 52 165 229 241 113 216 49 21 4 199 35 195 24 150 5 154 7 18 128 226 235 39 178 117 9 131 44 26 27 110 90 160 82 59 214 179 41 227 47 132 83 209 0 237 32 252 177 91 106 203 190 57 74 76 88 207 208 239 170 251	67	77	51	133	69	249	2	127	80	60	159	168	81	163	64	143	146	157	56	245	188	182	218	33	16	255	243	210	205	12	19	236	95	151	68	23	196	167	126	61	100	93	25	115	96	129	79	220	34	42	144	136	70	238	184	20	222	94	11	219	224	50	58	10	73	6	36	92	194	211	172	98	145	149	228	121	231	200	55	109	141	213	78	169	108	86	244	234	101	122	174	8	186	120	37	46	28	166	180	198	232	221	116	31	75	189	139	138	112	62	181	102	72	3	246	14	97	53	87	185	134	193	29	158	225	248	152	17	105	217	142 148 155 30 135 233 206 85 40 223 140 161 137 13 191 230 66 104 65 153 45 15 176 84 187 22];

 
SBox=[99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22];
invSBox(SBox(1:256)+1)=0:255;
shiftrow=[1,6,11,16,5,10,15,4,9,14,3,8,13,2,7,12];

% initialise traceCounter 
i = 0;
tic;

byteStart = 1;
byteEnd = 16;
keyCandidateStart = 0;
keyCandidateStop = 255;

% -------------------------------------------------------------------------
% ----------------------------- CPA algorithm -----------------------------

% loop on the number of traces
while(i < ceil)
    
    % increment traceCounter
    i = i + 1;
    
    % proof of life
     if mod(i,100)== 0 
         disp(i);
     end;
    
    % call function readTrace()
    % read a trace
    [vectorTrace,PTI,CTO] = readTrace(folderSrc,matrixFilename(i,:));
    
    vectorTrace_matrix(i,:) = vectorTrace(xMin1:xMax1);
    
       
        % -----------------------------------------------------------------
        % ---------------------------- round 10 ----------------------------

        
        % loop on the number of key hypothesis
        for k = keyCandidateStart : keyCandidateStop

        for a = byteStart : byteEnd
        
            %shiftRow final state
                    
         end;

    % end loop on the number of key hypothesis
        end;    
        

        %Guessing entropy
        %if mod(i,100)== 0 
            
         %Correlation
         for a = byteStart : byteEnd
             
             
      
        end;
        
        %end;
        
        
end;
 
%
disp('Key hypothesis generate'); 
%    
%     for a = 1 : 16
%         
%             plot(H2(:,:,a),'c'); figure(1);
%             hold on;
%             [I,Max_key] = max(max(H2(:,:,a)));
%             plot(H2(:,Max_key,a),'r');
%             plot(H2(:,last_rnd(a)+1,a),'k');
%             output = sprintf('Recherche de la sous-clé n°%d\n Nombre de courbes traitées : %d\n Clé correcte : %d\n Hypothèse de clé : %d',a,ceil,last_rnd(a),Max_key-1);
%             title(output); figure(1);
%             pause;
%             
%             hold off;
%             
%             Maxkey(a) = Max_key-1;
%             
%     end;       
 
    

