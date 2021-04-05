clear all 
close all
echo off 

folderSrc = fullfile(pwd, 'data');
folderInfo = dir(folderSrc); 

% tracé courbe consommation (faire commencer à 3)
i = 3;
T = csvread(fullfile(folderSrc, folderInfo(i).name));
Time = 0:size(T,2)-1;
figure
plot(Time, T, 'r')
title(['trace consommation n° ',num2str(i-2)])

% moyenne consommation 
 
data = zeros(4000, 20000);
moyenne = ones(1, 4000);
for j = 3:20002 
    T = csvread(fullfile(folderSrc, folderInfo(j).name));
    data(:, j-2) = T; 

end
for k = 1:4000
    moyenne(1,k)=mean(data(:,k));
end

figure
plot(Time, moyenne, 'r')
title('moyenne consommation')