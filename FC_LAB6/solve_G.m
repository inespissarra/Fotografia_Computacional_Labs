function g = solve_G(Zdata,T)
    [P, N] = size(Zdata);
    Neq = N*(P-1) + 255;

    b = zeros(Neq,1);
    i = zeros(2*N*(P-1)+254*3, 1);
    j = zeros(2*N*(P-1)+254*3, 1);
    v = zeros(2*N*(P-1)+254*3, 1);
   
    contador = 1; indx = 1;
    M = 256; t=(1:M)'/(M+1); w=(t.*(1-t)).^2; w=w/max(w);
    for n=1:N
        Z = Zdata(:, n);
        dif = Z-128;
        [~, ref] = min(abs(dif));
        Zref = Z(ref);
        for k=[1:(ref-1) (ref+1):P]
            W = sqrt((w(Z(k)+1)*w(Zref+1)));

            i(indx) = contador; j(indx) = Z(k)+1; v(indx) = 1 * W;
            indx = indx+1;
            i(indx) = contador; j(indx) = Zref+1; v(indx) = -1 * W;
            indx = indx+1;
            b(contador) = log2(T(k)/T(ref)) * W;
            contador = contador + 1;
        end
    end
    
    lambda = 1;
    for a=1:254
        i(indx) = contador; j(indx) = a; v(indx) = -1 * lambda;
        indx = indx+1;
        i(indx) = contador; j(indx) = a+1; v(indx) = 2 * lambda;
        indx = indx+1;
        i(indx) = contador; j(indx) = a+2; v(indx) = -1 * lambda;
        indx = indx+1;
        contador = contador + 1;
    end
    i(indx) = contador; j(indx) = 129; v(indx) = 1 * lambda;

    H = sparse(i,j,v,Neq,256);

    g = H\b;
end
