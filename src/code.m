% Param�tres
fe = 100e6;              % Fr�quence d'�chantillonnage en Hz
tinitial = 0;
tfinal = 0.25e-3;
t = linspace(tinitial, tfinal, fe*(tfinal-tinitial)); %ms          % Vecteur temps
pulse_duration = 1e-6;  %ms % Dur�e du pulse 
f_sin = 1/pulse_duration*10;             % Fr�quence du signal sinusoidal en Hz

% G�n�rer l'enveloppe du pulse rectangulaire
pulse_envelope = rectpuls(t, pulse_duration);

% G�n�rer le signal sinusoidal
sin_wave = sin(2 * pi * f_sin * t);

% Multiplier l'enveloppe par le signal sinusoidal
pulse_with_sin = (pulse_envelope) .* sin_wave;

% Tracer l'enveloppe du pulse modul�
figure;
plot(t, pulse_with_sin);
title('Pulse modul� par un signal sinusoidal');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

pulse_with_sin2 = pulse_with_sin; % on recopie le tableau

for i=1:round(fe*pulse_duration) %round pour avoir un entier et la boucle sur le nb d'�chantillon
    pulse_with_sin2(i+round(fe*(tfinal-tinitial)/2)) = pulse_with_sin(i); % on recopie le premier pulse plus loins et on le fixe au milieu arbitrairement 
end

% Tracer les deux pulses 
figure;
plot(t, pulse_with_sin2);
title('Deux pulses s�par�s dans le temps');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;


%On split les deux pulses pour cr�er deux signaux distincts

x = pulse_with_sin;

for i=1:round(fe*pulse_duration)
    pulse_with_sin2(i) = 0;
end

y=pulse_with_sin2;

% Tracer les deux pulses s�par�s
figure;
plot(t, x);
title('Pulse x');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

% Tracer les deux pulses s�par�s
figure;
plot(t, y);
title('Pulse y');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;

%On passe dans le domaine fr�quentiel 

X_FFT = fft(x);
Y_FFT = fft(conj(y));

gamma = ifft(Y_FFT.*X_FFT);

figure;
plot(t, gamma);
title('R�sultat de l''intercorr�lation');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;
    

%Tracage des FFT

%Calculer le vecteur des fr�quences
n = length(X_FFT);
frequencies = (0:n-1)*(fe/n);

% Tracer le spectre de fr�quence de X_FFT
figure;
plot(frequencies, abs(X_FFT));
title('Spectre de fr�quence du signal modul� x');
xlabel('Fr�quence (Hz)');
ylabel('Amplitude');
grid on;

% Tracer le spectre de fr�quence de Y_FFT
figure;
plot(frequencies, abs(Y_FFT));
title('Spectre de fr�quence du signal modul� y');
xlabel('Fr�quence (Hz)');
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

% Tracer le r�sultat avec du bruit
figure;
plot(t, gamma_noisy);
title('Signal d''intercorr�lation avec bruit');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;



% R�duire l'amplitude de y
y_reduced = pulse_with_sin2 / 100;
Y_FFT_reduced = fft(conj(y_reduced));

% Calculer l'intercorr�lation avec le signal x bruit�
gamma_reduced = ifft(Y_FFT_reduced .* X_FFT_NOISY);

% Tracer le r�sultat d'intercorr�lation avec l'amplitude r�duite de y
figure;
plot(t, real(gamma_reduced));
title('Intercorr�lation avec amplitude r�duite de y');
xlabel('Temps (s)');
ylabel('Amplitude');
grid on;




