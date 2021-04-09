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

disp(fullfile(folderSrc, folderInfo(i).name));

%% 4) Selection du dernier round pour attaquer plus rapidement
% par lecture le dernier round se trouve entre t=3057 et t=3330
dernier_round = moyenne(3057:3330);

%% 5)prédiction d'etat sur la 1ere mesure (avant remontage sur point d'attaque) 
% récupération du chiffré X_str
A = strsplit(folderInfo(3).name, '_cto=');
X_str = strtok(A{1,2}, '.');
% conversion en chiffré manipulable
X = ones(length(X_str), 1);
for i = 1:length(X_str)
   X(i) = hex2dec(X_str(i));
end

% conversion vers un vecteurs d'octets 

% prédiction d'état après XOR 
Z = bitxor(uint8(single(X)*ones(1,256)),uint8(ones(size(X,1),1)*(0:255)))+1; 

%% remontage vers point d'attaque 