clear
clc

N = 10;
p = 0:0.01:1;


prob = zeros(1, 100);
for L = 10:10:30
    for ii = 1:length(p)
        pp = p(ii);
    
        s = 0;
        for j = 1:N
            resDFS = CercaCluster(L, pp);
            res = CercaClusterHK(L, pp);
            tmp = res.percolazioneTB || res.percolazioneLR;
    
            s = s + tmp;
        end
    
        prob(ii) = s / N;
    
    
    end
    hold on
    plot(p, prob);

end
title("Probabilità percolazione");
xlabel("Probabilità colorazione sito");
ylabel("Probabilità percolazione su " + N + " tentativi");

legend("Lunghezza 10", "Lunghezza 20", "Lunghezza 30");

