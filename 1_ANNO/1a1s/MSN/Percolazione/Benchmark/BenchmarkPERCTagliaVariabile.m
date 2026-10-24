clear
clc
close all

rng(1);

p = 0.55;

R = 12;

L_start = 30;
L_passo = 50;
L_end = 400;

L = [15000, 20000, 25000];

tempiHK = zeros(length(L), R);
tempiLez = zeros(length(L), R);
tempiHKOpt = zeros(length(L), R);

 % Ciclo benchmark sui reticoli
 for idx = 1:length(L)
        
        % Creazione reticolo
        reticolo = zeros(L(idx) + 2);
        aux = rand(L(idx)) < p;
        reticolo(2:end-1, 2:end-1) = aux;
    
        % Ripetere lo stesso reticolo R volte
        for rip = 1:R
            tic;
            resHK = CercaClusterHKBenchmark(L(idx), reticolo, p);
            tempiHK(idx, rip) = toc;
        
            tic;
            resLez = CercaClusterBenchmark(L(idx), reticolo, p);
            tempiLez(idx, rip) = toc;

            tic;
            resHKOpt = CercaClusterHKBenchOpt(L(idx), reticolo, p);
            tempiHKOpt(idx, rip) = toc;

        end

  end


erroreHK = zeros(1, length(L));
erroreLez = zeros(1, length(L));
erroreHKOpt = zeros(1, length(L));

tempoMedioHK = zeros(1, length(L));
tempoMedioLez = zeros(1, length(L));
tempoMedioHKOpt = zeros(1, length(L));


%calcolo errore standard medio
for idx = 1:length(L)
    erroreHK(idx) = std(tempiHK(idx, :)) / sqrt(R);
    erroreLez(idx) = std(tempiLez(idx, :)) / sqrt(R); 
    erroreHKOpt(idx) = std(tempiHKOpt(idx, :)) / sqrt(R); 
    
    tempoMedioHK(idx) = mean(tempiHK(idx, :));
    tempoMedioLez(idx) = mean(tempiLez(idx, :));
    tempoMedioHKOpt(idx) = mean(tempiHKOpt(idx, :));

end


subplot(2, 1, 1)
plot(L, tempoMedioHK, "r", "DisplayName", "Tempi esecuzione HK")

hold on
plot(L, tempoMedioLez, "b", "DisplayName", "Tempi esecuzione Lez.")
plot(L, tempoMedioHKOpt, "y", "DisplayName", "Tempi esecuzione HK-opt")


xlim([min(L) max(L)])  
ylim([0 inf])

ylabel("Tempo d'esecuzione")
xlabel("Dimensione reticolo")
title("Confronto tempi d'esecuzione tra i due algoritmi")
legend("Location", "southeast")
subplot(2, 1, 2)

plot(L, erroreLez, "b", "DisplayName", "Errore standard medio Lez.")
hold on
plot(L, erroreHK, "r", "DisplayName", "Errore standard medio HK")
plot(L, erroreHKOpt, "y", "DisplayName", "Errore standard medio HK-opt");

xlim([min(L) max(L)])   
ylim([0 inf])   

ylabel("Errore")
xlabel("Dimensione reticolo")
title("Confronto errore standard medio dei due algoritmi")
legend("Location", "southeast")

legend
