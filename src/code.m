% Paramètres
fe = 100e6;              % Fréquence d'échantillonnage en Hz
tinitial = 0;
tfinal = 0.25e-3;
t = linspace(tinitial, tfinal, fe*(tfinal-tinitial)); %ms          % Vecteur temps
pulse_duration = 1e-6;  %ms % Durée du pulse 
f_sin = 1/pulse_duration*10;             % Fréquence du signal sinusoidal en Hz

% Générer l'enveloppe du pulse rectangulaire
pulse_envelope = rectpuls(t, pulse_duration);

% Générer le signal sinusoidal
sin_wave = sin(2 * pi * f_sin * t);

% Multiplier l'enveloppe par le signal sinusoidal
pulse_with_sin = (pulse_envelope) .* sin_wave;

% Tracer l'enveloppe du pulse modulé
figure;
plot(t, pulse_with_sin);
title('Pulse modulé par un signal sinusoidal');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

pulse_with_sin2 = pulse_with_sin; % on recopie le tableau

for i=1:round(fe*pulse_duration) %round pour avoir un entier et la boucle sur le nb d'échantillon
    pulse_with_sin2(i+round(fe*(tfinal-tinitial)/2)) = pulse_with_sin(i); % on recopie le premier pulse plus loins et on le fixe au milieu arbitrairement 
end

% Tracer les deux pulses 
figure;
plot(t, pulse_with_sin2);
title('Deux pulses séparés dans le temps');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;


%On split les deux pulses pour créer deux signaux distincts

x = pulse_with_sin;

for i=1:round(fe*pulse_duration)
    pulse_with_sin2(i) = 0;
end

y=pulse_with_sin2;

% Tracer les deux pulses séparés
figure;
plot(t, x);
title('Pulse x');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

% Tracer les deux pulses séparés
figure;
plot(t, y);
title('Pulse y');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

%On passe dans le domaine fréquentiel 

X_FFT = fft(x);
Y_FFT = fft(conj(y));

gamma = ifft(Y_FFT.*X_FFT);

figure;
plot(t, gamma);
title('Résultat de l''intercorrélation');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
    

%Tracage des FFT

%Calculer le vecteur des fréquences
n = length(X_FFT);
frequencies = (0:n-1)*(fe/n);

% Tracer le spectre de fréquence de X_FFT
figure;
plot(frequencies, abs(X_FFT));
title('Spectre de fréquence du signal modulé x');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;

% Tracer le spectre de fréquence de Y_FFT
figure;
plot(frequencies, abs(Y_FFT));
title('Spectre de fréquence du signal modulé y');
xlabel('Fréquence (Hz)');
ylabel('Amplitude');
grid on;


%On rajoute du bruit 

% Ajouter du bruit au signal x
SNR = -20; % Rapport signal sur bruit en dB
signal_power = rms(x)^2;
noise_power = signal_power / (10^(SNR/10));
noise = sqrt(noise_power) * randn(size(x));
x_noisy = x + noise;


X_FFT_NOISY = fft(x_noisy);
Y_FFT = fft(conj(y));


gamma_noisy = ifft(Y_FFT.*X_FFT_NOISY);

% Tracer le résultat avec du bruit
figure;
plot(t, gamma_noisy);
title('Signal d''intercorrélation avec bruit');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;



% Réduire l'amplitude de y
y_reduced = pulse_with_sin2 / 100;
Y_FFT_reduced = fft(conj(y_reduced));

% Calculer l'intercorrélation avec le signal x bruité
gamma_reduced = ifft(Y_FFT_reduced .* X_FFT_NOISY);

% Tracer le résultat d'intercorrélation avec l'amplitude réduite de y
figure;
plot(t, real(gamma_reduced));
title('Intercorrélation avec amplitude réduite de y');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;




