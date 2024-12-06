
function [e] = calcula_entropia (x)

% x = pruebas(1).NP;

for j = 1:size(x,2)
    [e(j,1)] = sampen(x(:,j),2,0.2,0,0);
end


