clear
clc
close all

R = 1000;
pL = [0.1:0.05:0.3 0.3:0.005:0.75 0.8:0.05:0.95];

% Contiene la probabilità di percolazione 
prob = zeros(1, length(pL));
LL = [50, 100, 150];

erroreProb = zeros(length(pL), length(LL));
erroreProbPercTB = zeros(length(pL), length(LL));
erroreProbPercLR = zeros(length(pL), length(LL));

probPercLR = zeros(1, length(pL));
probPercTB = zeros(1, length(pL));

iterTOTGlobal = length(pL) * length(LL) * R;
currentIter = 0;

% Matrice contenente:
% Sulle righe, nel seguente ordine: 1) P1, 2) P2, 3) P3, 4) RACS
% Colonne, la probabilità di colorazione del sito.
datiOsservabili = zeros(4, length(pL));

erroreOsservabili = zeros(1, 4);

for L_idx = 1:length(LL)
    L = LL(L_idx);

    valoriP1 = zeros(1, length(R));
    valoriP2 = zeros(1, length(R));
    valoriP3 = zeros(1, length(R));
    valoriRACS = zeros(1, length(R));
    
    for p_idx = 1:length(pL)
        p = pL(p_idx);
    
        sommaProbPerc = 0;
        sommaLR = 0;
        sommaTB = 0;
        
        for iter = 1:R
            res = CercaClusterHKOpt(L, p);
            
            % %Cluster con dimensione più alta
            maxCluster = max(res.clusters);
            % 
            % % P1: rapporto tra cluster massimo e numero di siti
            valoriP1(iter) = maxCluster / LL(L_idx)^2;
            % 
            % % P2: rapportro tra cluster massimo, e numero di siti per la
            % % probabilità di colorazine
            valoriP2(iter) = maxCluster / (p * (LL(L_idx)^2));
            % 
            % % P3
            P3 = 0;
             
            % %Posso riutilizzarla al denominatore del RACS
            mediaPesataP3 = 0;
             
            for c = 1:length(res.clusters)
                ns = length(find(res.clusters == res.clusters(c)));
                mediaPesataP3 = mediaPesataP3 + (res.clusters(c) * ns);
            end
             
            valoriP3(iter) = maxCluster / mediaPesataP3;
            
            %  Calcolo RACS
            idxMax = find(res.clusters == maxCluster, 1);
            cluster_noMax = res.clusters;
            cluster_noMax(idxMax) = [];

            numRACS = 0;
             
            for c = 1:length(cluster_noMax)
                ns = length(find(cluster_noMax == cluster_noMax(c)));
                numRACS = numRACS + (ns*(cluster_noMax(c))) * cluster_noMax(c);
            end
            
            valoriRACS(iter) = numRACS / mediaPesataP3;
                      
            percLR = res.percolazioneLR;
            percTB = res.percolazioneTB;
            perc = res.percolazioneLR || res.percolazioneTB;
  
            sommaProbPerc = sommaProbPerc + perc;
            sommaLR = sommaLR + percLR;
            sommaTB = sommaTB + percTB;

            % stampo l'iterazione corrente per sapere a che punto è il
            % benchmark
            currentIter = currentIter + 1;
            sprintf("%d/%d", currentIter, iterTOTGlobal)
        end
        
        % Calcolo le probabilità di percolazione con i loro errori

        probPercLR(p_idx) = sommaLR / R;
        probPercTB(p_idx) = sommaTB / R;

        prob(p_idx) = sommaProbPerc / R;
        
        erroreProb(p_idx, L_idx) = sqrt(prob(p_idx) * (1 - prob(p_idx)) / R);
        erroreProbPercLR(p_idx, L_idx) = sqrt(probPercLR(p_idx) * (1 - probPercLR(p_idx)) / R);
        erroreProbPercTB(p_idx, L_idx) = sqrt(probPercTB(p_idx) * (1 - probPercTB(p_idx)) / R);

        % calcolo errore delle osservabili e valori medi
        mediaP1 = mean(valoriP1);
        mediaP2 = mean(valoriP2);
        mediaP3 = mean(valoriP3);
        mediaRACS = mean(valoriRACS);

        datiOsservabili(1, p_idx) = mediaP1;
        datiOsservabili(2, p_idx) = mediaP2;
        datiOsservabili(3, p_idx) = mediaP3;
        datiOsservabili(4, p_idx) = mediaRACS;

        erroreOsservabili(1, p_idx) = std(valoriP1) / sqrt(R);
        erroreOsservabili(2, p_idx) = std(valoriP2) / sqrt(R);
        erroreOsservabili(3, p_idx) = std(valoriP3) / sqrt(R);
        erroreOsservabili(4, p_idx) = std(valoriRACS) / sqrt(R);
        
    end
    % Prima di cambiare reticolo disengo la probabilità di percolazione

    
    % plot(pL, prob);
    figure(1);
    hold on
    orient landscape;
    title("Probabilità di percolazione")
    errorbar(pL, prob, erroreProb(:,L_idx), "DisplayName", "L = " + LL(L_idx));
    xlabel("Probabilità colorazione dei siti");
    ylabel("Probabilità di percolazione");
    xlim([min(pL), max(pL)]);
    ylim([0, 1]);
    legend("Location", "southeast");
    legend


    figure(2);
    hold on
    orient landscape;
    title("Osservabile P1")
    errorbar(pL, datiOsservabili(1, :), erroreOsservabili(1, :),  "DisplayName", "P1 con L = " + LL(L_idx));

    xlabel("Probabilità colorazione dei siti");
    ylabel("Valore P1");
    xlim([min(pL), max(pL)]);
    ylim([0, 1]);
    legend("Location", "southeast");
    legend

    figure(3);
    hold on
    orient landscape;
    title("Osservabile P2");
    errorbar(pL, datiOsservabili(2, :), erroreOsservabili(2, :),  "DisplayName", "P2 con L = " + LL(L_idx));
    xlabel("Probabilità colorazione dei siti");
    ylabel("Valore P2");
    xlim([min(pL), max(pL)]);
    ylim([0, 1]);
    legend("Location", "southeast");
    legend

    figure(4);
    hold on
    orient landscape;
    title("Osservabile P3");
    errorbar(pL, datiOsservabili(3, :), erroreOsservabili(3, :),  "DisplayName", "P3 con L = " + LL(L_idx));
    xlabel("Probabilità colorazione dei siti");
    ylabel("Valore P3");
    xlim([min(pL), max(pL)]);
    ylim([0, 1]);
    legend("Location", "southeast");
    legend

    figure(5);
    hold on
    orient landscape;
    title("Osservabile RACS");
    errorbar(pL, datiOsservabili(4, :), erroreOsservabili(4, :),  "DisplayName", "RACS con L = " + LL(L_idx));
    xlabel("Probabilità colorazione dei siti");
    ylabel("Valore RACS");
    xlim([min(pL), max(pL)]);
    ylim([0, +inf]);

    legend("Location", "southeast");
    legend
    
    % Tabella per probabilità di percolazine TB e LR
    TprobPercLRTB = table(prob', probPercTB', probPercLR', erroreProb(:, L_idx), erroreProbPercTB(:, L_idx), erroreProbPercLR(:, L_idx), ...
    'VariableNames', {'Prob. Perc', 'Prob. perc TB', 'Prob. perc LR', 'Errore Prob. Perc', 'Errore TB', 'Errore LR'});
    writetable(TprobPercLRTB, sprintf('DatiPERC_CSV/probPerc-TB-LR_L%d.csv', LL(L_idx)));
    
    % Tabella per le osservabili: P1, P2, P3 e RACS con errori
    Tosservabili = table(datiOsservabili(1, :)', datiOsservabili(2, :)', ... 
        datiOsservabili(3, :)', datiOsservabili(4, :)', ...
        erroreOsservabili(1, :)', erroreOsservabili(2, :)', ...
        erroreOsservabili(3, :)', erroreOsservabili(4, :)', 'VariableNames', ... 
        {'P1', 'P2', 'P3', 'RACS', 'Errore P1', 'Errore P2', 'Errore P3', 'Errore RACS'});

    writetable(Tosservabili, sprintf('DatiPERC_CSV/osservabili_L%d.csv', LL(L_idx)));
end

figure(1);
print('graficiDatiPERC/graficoProbPercolazione', '-dpdf');

figure(2)
print('graficiDatiPERC/graficoP1', '-dpdf');

figure(3)
print('graficiDatiPERC/graficoP2', '-dpdf');

figure(4)
print('graficiDatiPERC/graficoP3', '-dpdf');

figure(5)
print('graficiDatiPERC/graficoRACS', '-dpdf');