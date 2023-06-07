clear;

alto = 768;
ancho = 1024;
hdr_data_G = zeros(alto, ancho, 9);
hdr_data_R = zeros(alto, ancho, 9);
hdr_data_B = zeros(alto, ancho, 9);
T = [1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4];

for P=1:9
    im = double(imread("belg_" + P + ".jpg"));
    hdr_data_G(:,:,P) = im(:,:,2);
    hdr_data_R(:,:,P) = im(:,:,1);
    hdr_data_B(:,:,P) = im(:,:,3);
end

Zdata = extraer_datos(hdr_data_G, 10000);

g = solve_G(Zdata,T);

log2R_G = get_log2R(hdr_data_G, g, T);

log2R_R = get_log2R(hdr_data_R, g, T);

log2R_B = get_log2R(hdr_data_B, g, T);

log2R = cat(3,log2R_R, log2R_G, log2R_B);

hdr=2.^log2R;

M = max(hdr(:));
m = min(hdr(:));

hdr = (hdr-m)/(M-m);
hdrwrite(hdr, 'belg.hdr');

rgb=tonemap(hdr,'AdjustSaturation',3);
figure();
imshow(rgb);

%------------------------------ Funciones ---------------------------------

function Zdata=extraer_datos(hdr_data,N)
    [alto, ancho, P] = size(hdr_data);
    Zdata = zeros(P, N);
    P2 = zeros(P, 1);
    n = 1;
    while n~=N
        i=floor(rand*(alto))+1;j=floor(rand*(ancho))+1;
        for k=1:P
            P2(k) = hdr_data(i, j, k);
        end
        if all(diff(P2)>=0)
            Zdata(:, n) = P2;
            n = n + 1;
        end
    end
end

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