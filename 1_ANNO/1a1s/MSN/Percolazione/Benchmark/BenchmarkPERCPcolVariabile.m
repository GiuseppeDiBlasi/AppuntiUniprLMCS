clear
clc
close all

rng(1);

p = [0.20:0.20:0.50, 0.50:0.05:0.76, 0.80:0.20:0.99];

R = 2000;

L = 10;

tempiHK = zeros(length(p), R);
tempiLez = zeros(length(p), R);
tempiHKOpt = zeros(length(p), R);

 % Ciclo benchmark sui reticoli
 for idx = 1:length(p)
        
        % Creazione reticolo
        reticolo = zeros(L + 2);
        aux = rand(L) < p(idx);
        reticolo(2:end-1, 2:end-1) = aux;
    
        % Ripetere lo stesso reticolo R volte
        for rip = 1:R
            tic;
            resHK = CercaClusterHKBenchmark(L, reticolo, p(idx));
            tempiHK(idx, rip) = toc;
        
            tic;
            resLez = CercaClusterBenchmark(L, reticolo, p(idx));
            tempiLez(idx, rip) = toc;
            
            tic;
            resHKOpt = CercaClusterHKBenchOpt(L, reticolo, p(idx));
            tempiHKOpt(idx, rip) = toc;

        end

  end


erroreHK = zeros(1, length(p));
erroreLez = zeros(1, length(p));
erroreHKOpt = zeros(1, length(p));


tempoMedioHK = zeros(1, length(p));
tempoMedioLez = zeros(1, length(p));
tempoMedioHKOpt = zeros(1, length(p));


%calcolo errore standard medio
for idx = 1:length(p)
    erroreHK(idx) = std(tempiHK(idx, :)) / sqrt(R);
    erroreLez(idx) = std(tempiLez(idx, :)) / sqrt(R);
    erroreHKOpt(idx) = std(tempiHKOpt(idx, :)) / sqrt(R);
    
    
    tempoMedioHK(idx) = mean(tempiHK(idx, :));
    tempoMedioLez(idx) = mean(tempiLez(idx, :));
    tempoMedioHKOpt(idx) = mean(tempiHKOpt(idx, :));

end


subplot(2, 1, 1)
plot(p, tempoMedioHK, "r", "DisplayName", "Tempi esecuzione HK")

hold on
plot(p, tempoMedioLez, "b", "DisplayName", "Tempi esecuzione Lez.")
plot(p, tempoMedioHKOpt, "y", "DisplayName", "Tempi esecuzione HK-opt")


xlim([min(p) max(p)])  
ylim([0 inf])

ylabel("Tempo d'esecuzione")
xlabel("Probabilità di colorazione")
title("Confronto tempi d'esecuzione tra i due algoritmi")
legend("Location", "southeast")
subplot(2, 1, 2)

plot(p, erroreLez, "b", "DisplayName", "Errore standard medio Lez.")
hold on
plot(p, erroreHK, "r", "DisplayName", "Errore standard medio HK")
plot(p, erroreHKOpt, "y", "DisplayName", "Errore standard medio HK-opt")

xlim([min(p) max(p)])   
ylim([0 inf])   

ylabel("Errore")
xlabel("Probabilità di colorazione")
title("Confronto errore standard medio dei due algoritmi")
legend("Location", "southeast")

legend

(sum(tempiLez(:)) + sum(tempiHK(:))) / 60
