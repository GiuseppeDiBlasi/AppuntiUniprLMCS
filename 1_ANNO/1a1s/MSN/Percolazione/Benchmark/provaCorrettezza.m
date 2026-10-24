clear 
clc

rng(1);

R = 1;

L = 5;

p = 0.55;

reticolo = zeros(L + 2);
aux = rand(L) < p;
reticolo(2:end-1, 2:end-1) = aux;

tic
res = CercaClusterHKBenchmark(L, reticolo, p);
tHK = toc 

% tic
% resLez = CercaClusterBenchmark(L, reticolo, p);
% tLez = toc 

tic
resHKOpt = CercaClusterHKBenchOpt(L, reticolo, p);
tHKopt = toc


