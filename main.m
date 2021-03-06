% clc
% clear all 
% close all
% echo off 

%% Chargement des bibliothèques et des fichiers sources
addpath(fullfile(pwd, 'lib'))

% création des dossier de cache
createFolders()

% conversion des fichiers csv->m
convertData()

folderSrc = fullfile(pwd, 'data_converted');
folderInfo = dir(folderSrc); 

%% 1) Tracer une courbe de consommation afin de déterminer le début et la fin du chiffrement
disp("-- 1) Tracé d'une seule courbe")

i = 3; % éviter le "." et ".."
% on charge les données depuis le fichier mat
T = load(fullfile(folderSrc, folderInfo(i).name), "-mat").data;
% définition de l'échelle de temps
Time = 0:size(T,2)-1;
figure
plot(Time, T, 'r')
grid()
ylabel("Fuite électromagnétique")
xlabel("Temps")
title(['Trace consommation n° ',num2str(i-2)])

% par lecture sur le graphique on relève :
% 1er round: t=360
% dernier round: t=3510
hold on
xline(360, "--b", "1er round")
xline(3510, "--b", "dernier round")
hold off

% cleaning
clearvars i T Time;

%% 2) Tracer la moyenne de consommation pour repérer le 1er et dernier round
disp("-- 2) Calcul d'une moyenne des traces")

% Calcul de la moyenne
moyenne = moyenneTraces("data_converted");

% Présentation des résultats
figure
Time = 0:size(moyenne,2)-1;
plot(Time, moyenne, 'r')
grid()
ylabel("Fuite électromagnétique")
xlabel("Temps")
title('Moyenne de consommation')

% Annotations supplémentaires
hold on
xline(921, "--g", "Initialisation du code VHDL (à ignorer)")
xline(1123, "--k", "Round initial")
rounds_t_nb = [1327, 1526, 1728, 1927, 2128, 2326, 2527, 2729, 2925];
for i = 1:9
   xline(rounds_t_nb(i), "--b", "Round n°" + num2str(i)) 
end
xline(3131, "--k", "Round final")
hold off

% cleaning
clearvars i rounds_t_nb Time;

%% 3) Démontrer que le poids de Hamming peut s'appliquer au dernier round

% Pour rappel le poids de Hamming correspond au nombre d'éléments
% différents de zéro dans une chaîne d'éléments dans un corps fini
% (comme un corps de gallois)
% Dans un corps de gallois il s'agit donc du nombre de 1 que les données
% contiennent. Comme la clé est de taille 8 on va avoir un poids de hamming
% qui varie entre 0 et 8. Il faudra le relever sur la variable sensible
% que l'on obtient aux questions d'après.

% Afin d'appliquer le modèle du poids de Hamming au dernier round (Subbyte,
% shiftrow, addroundkey) 

%% 4) Selection du dernier round pour attaquer plus rapidement
% par lecture le dernier round se trouve entre t=3057 et t=3330
dernier_round = 2800:3500;
moyenne_sur_dernier_round = moyenne(dernier_round);

%% 5)prédiction d'etat sur la 1ere mesure (avant remontage sur point d'attaque)
% récupération du chiffré X_str
Ntraces = 20000;
disp("-- 5) Prédiction d'état")

disp("Récupération des chiffrés")
X = zeros(Ntraces, 16);
for k = 3:(Ntraces+2)
    file_name = fullfile(folderSrc, folderInfo(k).name);
    A = strsplit(file_name, '_cto=');
    X_str = strtok(A{1,2}, '.');
    % conversion en chiffré manipulable
    for i = 1:(length(X_str)/2)
        X(k-2, i) = hex2dec(X_str(2*i-1:2*i));
    end
end

Z    = uint8(zeros(Ntraces,256,16));
Z_xor= uint8(zeros(Ntraces,256,16));
Z_sr = uint8(zeros(Ntraces,256,16));
Z_sb = uint8(zeros(Ntraces,256,16));

disp("Remplissage de l'état Z")
for trace = 1:Ntraces
    for hypothese = 1:256
        for valeur = 1:16
            Z(trace, hypothese, valeur) = uint8(X(trace, valeur));
        end 
    end 
end

% xor 
disp("XOR sur Z")
for trace = 1:Ntraces
   for valeur = 1:16
       for hypothese = 1:256
           Z_xor(trace, hypothese, valeur) = uint8(bitxor(Z(trace, hypothese, valeur), uint8(hypothese-1))); 
       end
   end
end

%shiftrow
shiftRowInv = [1, 14, 11, 8, 5, 2, 15, 12, 9, 6, 3, 16, 13, 10, 7, 4];
shiftrow = [1,6,11,16,5,10,15,4,9,14,3,8,13,2,7,12];

disp("ShiftRow inverse")
for trace = 1:Ntraces
    for valeur = 1:16
       for hypothese = 1:256
           Z_sr(trace, hypothese, valeur) = Z_xor(trace, hypothese, shiftRowInv(valeur)); 
       end
   end
end
%Z_sr = Z(:, :, shiftRowInv); 

% on remonte encore pour arriver au point d'attaque 
SBox=[99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22];
invSBox(SBox(1:256)+1)=0:255;

disp("Inv subbyte")
% on passe de 0-255 --> 1-256
%Z_sb = invSBox(Z_sr + 1);
for trace = 1:Ntraces
    for valeur = 1:16
       for hypothese = 1:256
           Z_sb(trace, hypothese, valeur) = uint8(invSBox(Z_sr(trace, hypothese, valeur)+1)); 
       end
   end
end

% cleaning
% clearvars A cle file_name i j k trace X_str Z_sr Z


%% attaque par HW
disp("-- 6) Attaque par Hamming weight")

% matrice de binaires

Weight_Hamming_vect = [0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 1 2 2 3 2 3 3 4 2 3 3 4 3 4 4 5 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 2 3 3 4 3 4 4 5 3 4 4 5 4 5 5 6 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 3 4 4 5 4 5 5 6 4 5 5 6 5 6 6 7 4 5 5 6 5 6 6 7 5 6 6 7 6 7 7 8];
DH = uint8(zeros(Ntraces,256,16));
for i = 1:256
    for k =1:16 
        DH(:,i,k) = bitxor(Z_sb(:,i,k), uint8(X(:,k)));
    end 
end
Phi = Weight_Hamming_vect(DH+1);

% Load leaks if it hasn't been done before
if (exist("L", "var") == 0)
    disp("Loading leaks...")
    L = load(fullfile(pwd, "cache", "fuites.mat"), "-mat").fuites;
end

disp("Calcul des corrélations pour les sous-clés")
best_candidate = zeros(16, 1);
figure
sgtitle("Corrélation par méthode du poids de Hamming")
for k = 1:16
    cor=mycorr(double(Phi(1:Ntraces,:, shiftrow(k))), double(L(1:Ntraces, dernier_round)));

    [RK, IK] = sort(max(abs(cor(:, :)), [], 2), 'descend'); 
    fprintf('%s %d %s %d \n','sous cle n°', k, ' : meilleur candidat : k=', IK(1) - 1)
    best_candidate(k)=IK(1)-1;

    subplot(4,4,k)
    plot(dernier_round, cor(:, :))
    title("k=" + num2str(k))
    xlabel('echantillon')
    ylabel('correlation')
end 

%% 
disp("Affichage de la clé à obtenir")
key = '4c8cdf23b5c906f79057ec7184193a67';
key_dec = zeros(16, 1);
for i = 1:16
    key_dec(i) = hex2dec(key((2*i)-1 : 2*i));
end

w = uint8(zeros(11, 4, 4));
w(1, :, :) = reshape(key_dec, 4, 4);

for i = 1:10
    w(i+1, :, :) = key_schu(squeeze(w(i, :, :)), i);
end
key_to_find = squeeze(w(11, :, :));
disp(key_to_find)


disp('best_candidate = ')
disp(reshape(best_candidate, 4, 4))
disp("Nombre de correspondances: ")
disp(sum(key_to_find == reshape(best_candidate, 4, 4)))
