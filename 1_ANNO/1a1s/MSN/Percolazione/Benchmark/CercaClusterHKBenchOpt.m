function res = CercaClusterHKBenchOpt(L, reticolo, p)
% res = CercaClusterHK(L, p)
% CercaClusterHK trova i cluster su un reticolo L x L con probabilità p di
% avere un sito colorato
%
% Sfrutta l'algoritmo di Hoshen–Kopelman, ci permette di scansionare la
% matrice con un solo passaggio, risultato molto più efficiente del sistema
% a pila visto a lezione.
% 
% Guarda solo i vicini già esplorati, sopra e a sinistra; sfrutta un
% sistema Union-Find per gestire eventuali fusioni tra 2 cluster che
% dovrebbero formarne uno.
%
% input:
%       L: lunghezza lato matrice
%       reticolo: matrice con siti colorati, usato solo per benchmark!!
%       p: probabilità di colorare un sito della matrice
%
% ritorna:
%       res.p: probabilità di avere un sito colorato
%       res.matrice: matrice dei siti colorati
%       res.label: matrice delle etichette dei cluster trovati
%       res.percolazioneTB: valore di esistenza di percolazione partendo
%       dal bordo superiore al bordo inferiore       
%       res.percolazioneLR: valore di esistenza di percolazione partendo
%       dal bordo sinistro al bordo destro

% % + 2 per il bordo di 0
% res.matrice = zeros(L + 2);
% % Ovviamente devo posizionare aux all'interno del padding di 0
% res.matrice(2:end-1, 2:end-1) = reticolo;

res.matrice = reticolo;

res.percolazioneTB = 0;
res.percolazioneLR = 0;

res.p = p;

res.label = zeros(size(reticolo));

res.clusters = [];

% Label di partenza
labelC = 1;

% Le radici del cluster si troveranno all'interno della cornice di padding
%num_elems è il numero di elementi all'interno del reticolo senza contare i
%bordi di padding
num_elems = (length(reticolo) - 2)^2;
radici_cluster = 1:(num_elems);

valid = find(res.matrice);

% Scansiono la griglia

for i = 1:length(valid)       
        idx_elem = valid(i);

        vicino_sup = res.label(idx_elem - 1);
        vicino_sx = res.label(idx_elem  - (L + 2));

        % Trovato nuovo cluster
        if vicino_sup == 0 && vicino_sx == 0
            res.label(idx_elem) = labelC;
            radici_cluster(labelC) = labelC;
            labelC = labelC + 1;

        % Estendo il cluster in verticale
        elseif vicino_sup > 0 && vicino_sx == 0
            res.label(idx_elem) = vicino_sup;

        % Estendo il cluster in orizzontale
        elseif vicino_sup == 0 && vicino_sx > 0
            res.label(idx_elem) = vicino_sx;
        
        % Vicini con label diverse, controllo se devo unire i cluster
        else 
            res.label(idx_elem) = vicino_sx;

            % Devo unire i due cluster
            if vicino_sx ~= vicino_sup
                unisci_cluster(vicino_sup, vicino_sx);
            end     
        end
    
end

% Sistemo le etichette dei cluster

for i = 2:L+1
    for j = 2:L+1
        if res.label(i,j) > 0
            res.label(i,j) = findRadice(res.label(i,j));
        end
    end
end

lblUniq = unique(res.label(res.label > 0));
res.clusters = histcounts(res.label(:), [lblUniq; max(lblUniq)+1]);

res.label = res.label(2 : end - 1, 2 : end - 1);
res.matrice = res.matrice(2 : end - 1, 2 : end - 1);

auxL = unique(res.label(1:L));
left = auxL(auxL > 0);

auxR = unique(res.label(L*(L-1) + 1:L*L));
right = auxR(auxR > 0);

if (~isempty(intersect(left, right)))
    res.percolazioneLR = 1;
end

auxT = unique(res.label(1:L:L*(L-1) + 1));
top = auxT(auxT > 0);

auxB = unique(res.label(L:L:L*L));
bottom = auxB(auxB > 0);

if (~isempty(intersect(top, bottom)))
    res.percolazioneTB = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%      FUNZIONI DELL'ALGORITMO HK %%%%%%%%%%%%%%%%%%%%%

    function unisci_cluster(x, y)
    % x e y sono le etichette dei due cluster da unire
        rx = findRadice(x);
        ry = findRadice(y);
        
        %  if rx < ry
        %     radici_cluster(ry) = rx;
        % elseif ry < rx
        %     radici_cluster(rx) = ry;
        % end

        radici_cluster(max(rx, ry)) = min(rx, ry);

    % L'algoritmo prevede solo la riga qui sotto
    % La parte superiore a questo commento è stata aggiunta per unire i
    % cluster in modo che la radice più grande, quella aggiunta successivamente,
    % venga aggiunta alla radice
    % con valore minore, aggiunta per prima
    % --> radici_cluster(findRadice(x)) = findRadice(y); 
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    function y = findRadice(x)
        % x, label del cluster 
        y = x;
        
        while radici_cluster(y) ~= y
            y = radici_cluster(y);

        end
        
        % Secondo while: path compression
        while radici_cluster(x) ~= x
            z = radici_cluster(x);
            radici_cluster(x) = y;
            x = z;
        end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
end