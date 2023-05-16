function M=calcula_M(E)
     M=Inf(size(E));
     [alto, ancho] = size(E);
     for j=2:ancho-1
        M(end,j) = E(end,j);
     end
     for i=alto-1:-1:1
        for j=2:ancho-1
            M(i,j) = E(i,j) + min(M(i+1,j-1:j+1));
        end
     end
end