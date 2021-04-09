clear all 
close all
echo off 

%% Chargement des bibliothèques et des fichiers sources
addpath(fullfile(pwd, 'lib'))

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

%% 3) Démontrer que le poids de Hamming peut s'appliquer au dernier round

% on normalise la moyenne pour appliquer le poids de hamming
offset = mean(moyenne);
moyenne = moyenne - (ones(size(moyenne)) * offset);

% Présentation des résultats
figure
Time = 0:size(moyenne,2)-1;
plot(Time, moyenne, 'r')
grid()
ylabel("Fuite électromagnétique")
xlabel("Temps")
title('Moyenne de consommation')

%% 
SBox=[99,124,119,123,242,107,111,197,48,1,103,43,254,215,171,118,202,130,201,125,250,89,71,240,173,212,162,175,156,164,114,192,183,253,147,38,54,63,247,204,52,165,229,241,113,216,49,21,4,199,35,195,24,150,5,154,7,18,128,226,235,39,178,117,9,131,44,26,27,110,90,160,82,59,214,179,41,227,47,132,83,209,0,237,32,252,177,91,106,203,190,57,74,76,88,207,208,239,170,251,67,77,51,133,69,249,2,127,80,60,159,168,81,163,64,143,146,157,56,245,188,182,218,33,16,255,243,210,205,12,19,236,95,151,68,23,196,167,126,61,100,93,25,115,96,129,79,220,34,42,144,136,70,238,184,20,222,94,11,219,224,50,58,10,73,6,36,92,194,211,172,98,145,149,228,121,231,200,55,109,141,213,78,169,108,86,244,234,101,122,174,8,186,120,37,46,28,166,180,198,232,221,116,31,75,189,139,138,112,62,181,102,72,3,246,14,97,53,87,185,134,193,29,158,225,248,152,17,105,217,142,148,155,30,135,233,206,85,40,223,140,161,137,13,191,230,66,104,65,153,45,15,176,84,187,22];

%% 4) Selection du dernier round pour attaquer plus rapidement
% par lecture le dernier round se trouve entre t=3057 et t=3330
dernier_round = moyenne(3057:3330);