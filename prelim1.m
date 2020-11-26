clear;
close all;
clc;

%% Etape 1 : Fonction de transfert

theta0_a = pi/3;
theta0_b = 2*pi/3;
r = 0; % Pour faire les zeros aussi mais osef vu que nul
R_a = 0.95;
R_b = 0.95;

z1 = r*exp(1i*theta0_a);
z2 = conj(z1);
z3 = r*exp(1i*theta0_b);
z4 = conj(z3);

zeros = [z1; z2; z3; z4];

p1 = R_a*exp(1i*theta0_a);
p2 = conj(p1);
p3 = R_b*exp(1i*theta0_b);
p4 = conj(p3);

poles = [p1; p2; p3; p4];

zplane(zeros, poles);


num = [1; 0; 0; 0; 0]; % Osef on ne veut pas de zéros
denom = [1; -(p1+p2+p3+p4); (p1*p2+p3*p4+(p1+p2)*(p3+p4)); (p1+p2)*p3*p4+(p3+p4)*p1*p2; p1*p2*p3*p4];

N = 5000;
f = -1/2:1/N:1/2-1/N;
w = 2*pi*f; % Il faut pas diviser par f_ech aussi ?
H = freqz(num, denom, w);

figure
subplot(2,1,1)
plot(f, 20*log10(abs(H))) % ou juste abs(H) si pas echelle log
grid on
xlabel('fréquence normalisée')
ylabel('module (dB)')
title("réponse fréquentielle en amplitude d'un système à deux pôles");
subplot(2,1,2)
plot(f, angle(H));
grid on
xlabel('fréquence normalisée')
ylabel('angle (rad)')
title("réponse fréquentielle en amplitude d'un système à deux pôles");

%% Etape 2 : Caractérisation du filtre

m = 0;
sigma2 = 1;

bruit = m + sqrt(sigma2)*randn(1, N);
bruit_filtre = filter(num, denom, bruit);

% Calcul de la DSP
dsp_bruit = fftshift(abs(fft(bruit))).^2/N;
dsp_bruit_filtre = fftshift(abs(fft(bruit_filtre))).^2/N;

figure
subplot(2,1,1), plot(bruit)
title('bruit blanc gaussien');
subplot(2,1,2), plot(bruit_filtre)
title('bruit blanc gaussien filtré');


figure
subplot(2,1,1)
plot(f, dsp_bruit)
xlabel('fréquence normalisée')
title('spectre de puissance du bruit')
subplot(2,1,2)
plot(f, dsp_bruit_filtre)
hold on
plot(f, abs(H).^2*sigma2, 'r', 'LineWidth', 2) % expression = dsp d'un bruit blanc
xlabel('fréquence normalisée')
title('spectre de puissance du signal filtré (bleu) et dsp (rouge)')
