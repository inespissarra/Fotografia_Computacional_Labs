clear;

alto = 768;
ancho = 1024;
hdr_data = zeros(alto, ancho, 9);
T = [1/1000, 1/500, 1/250, 1/125, 1/60, 1/30, 1/15, 1/8, 1/4];

for P=1:9
    im = double(imread("belg_" + P + ".jpg"));
    hdr_data(:,:,P) = im(:,:,2);
end

%muestra_HDR(hdr_data,T);

Zdata = extraer_datos(hdr_data, 5000);

g = solve_G(Zdata,T);