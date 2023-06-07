function Zdata=extraer_datos(hdr_data,N)
    [alto, ancho, P] = size(hdr_data);
    Zdata = zeros(P, N);
    P2 = zeros(P, 1);
    n = 1;
    %figure();
    %imshow(hdr_data(:,:,5)/255);
    while n~=N
        i=floor(rand*(alto))+1;j=floor(rand*(ancho))+1;
        for k=1:P
            P2(k) = hdr_data(i, j, k);
        end
        if all(diff(P2)>=0)
            Zdata(:, n) = P2;
            n = n + 1;
            %hold on;
            %plot(j, i,'g.');
            %hold off;
        end
    end
end