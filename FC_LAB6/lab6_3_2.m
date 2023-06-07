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

log2R_G = get_log2R(hdr_data, g, T);

for P=1:9
    im = double(imread("belg_" + P + ".jpg"));
    hdr_data(:,:,P) = im(:,:,1);
end

log2R_R = get_log2R(hdr_data, g, T);

for P=1:9
    im = double(imread("belg_" + P + ".jpg"));
    hdr_data(:,:,P) = im(:,:,3);
end

log2R_B = get_log2R(hdr_data, g, T);

log2R = cat(3,log2R_R, log2R_G, log2R_B);

hdr=2.^log2R;

M = max(hdr(:));
m = min(hdr(:));
rango_din = M/m;

hdr = (hdr-m)/(M-m);

figure();
imshow(hdr)

rgb=tonemap(hdr,'AdjustSaturation',3);
figure();
imshow(rgb);

