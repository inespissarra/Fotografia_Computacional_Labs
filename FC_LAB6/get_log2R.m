function log2R = get_log2R(hdr_data,g,T)
    [alto, ancho, ~] = size(hdr_data);
    log2R = zeros(alto, ancho);
    M = 256; t=(1:M)'/(M+1); w=(t.*(1-t)).^2; w=w/max(w);
    for i=1:alto
        for j=1:ancho
            Z = hdr_data(i, j, :);
            V = g(Z(1,1,:)+1)-log2(T');

            dif = Z-128;
            [~, ref] = min(abs(dif));
            Zref = Z(ref);

            W = sqrt((w(Z+1)*w(Zref+1)));
            W = W/sum(W(:));
            log2R(i, j) = sum(V.*W);
        end
    end
end