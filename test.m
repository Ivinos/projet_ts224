clear;
close all;
clc;

%% Variables

N = 5000;
P = 4; % ordre du modèle autorégressif

parameters = [0.25, 0.15, 0.3, 0.2];

AR = zeros(1, N);
AR(1:4) = 0.5; % Initialisation des quatre premiers termes
u = 0; % Bruit blanc (pour le moment zéro)
c = 0.5; % Constante

for i=P+1:N
    tmp = 0;
    for j=1:P
        tmp = tmp + parameters(j)*AR(i-j);
    end
    AR(i) = c + tmp + randn(1);
end

plot(AR);

