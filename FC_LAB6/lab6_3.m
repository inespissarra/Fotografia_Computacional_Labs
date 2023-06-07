clear;

alto = 768;
ancho = 1024;
hdr_data = zeros(alto, ancho, 9);
T = [1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4];

for P=1:9
    im = double(imread("belg_" + P + ".jpg"));
    hdr_data(:,:,P) = im(:,:,2);
end

Zdata = extraer_datos(hdr_data, 10000);

g = solve_G(Zdata,T);

%log2R = g(hdr_data(:,:,1)+1)-log2(T(1));

%imagesc(log2R);
%colormap('hot');
%colorbar;

log2R = get_log2R(hdr_data, g, T);
imagesc(log2R);
colormap('hot');
colorbar;

fila = alto/2;

col=hsv(10);

figure();
for i=1:P
    log2E = log2R(fila, :) + log2(T(i));
    hold on;
    plot(log2E, hdr_data(fila,:,1), '.', 'Color', col(i+1, :));
    hold off;
end

hold on;
plot(g, 1:256, '.', 'Color', col(1, :));
hold off;