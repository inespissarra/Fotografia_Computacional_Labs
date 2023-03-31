clear
%--------------------------------------------------------------------------
%                                  3.1
%--------------------------------------------------------------------------
offset = 128;

raw = imread("raw.pgm");
raw = double(raw);

% Reescalar valores
M=max(raw(:));
raw = (raw - offset)/(M-offset);
raw(raw<0)=0;

fc_pinta_im(raw, "Imagen RAW")


%--------------------------------------------------------------------------
%                                  3.2
%--------------------------------------------------------------------------

dims_im = size(raw);
R=0*raw;
R(1:2:end,1:2:end) = raw(1:2:end,1:2:end);
B=0*raw;
B(2:2:end, 2:2:end) = raw(2:2:end, 2:2:end);
G = 0*raw;
G(1:2:end, 2:2:end) = raw(1:2:end, 2:2:end);
G(2:2:end, 1:2:end) = raw(2:2:end, 1:2:end);

fc_pinta_im(cat(3,R,G,B),'Mosaico');


%--------------------------------------------------------------------------
%                                  3.3
%--------------------------------------------------------------------------

% Verticales Rojo
for j = 1 : 2 : dims_im(2)
    for i = 2 : 2 : dims_im(1)-1
        R(i, j) = (R(i-1, j) + R(i+1, j))/2;
    end
end

% Horizontales Rojo
for j = 2 : 2 : dims_im(2) - 1
    for i = 1 : dims_im(1)
        R(i, j) = (R(i, j-1) + R(i, j+1))/2;
    end
end

% Verticales Azul
for j = 2 : 2 : dims_im(2)
    for i = 3 : 2 : dims_im(1) - 1
        B(i, j) = (B(i-1, j) + B(i+1, j))/2;
    end
end

% Horizontales Azul
for j = 3 : 2 : dims_im(2) - 1
    for i = 2 : dims_im(1)
        B(i, j) = (B(i, j-1) + B(i, j+1))/2;
    end
end


% Green
for i = 2 : dims_im(1) - 1
    for j = 2 + rem(i, 2) : 2 : dims_im(2) - 1
        G(i, j) = (G(i, j-1) + G(i, j+1) + G(i-1, j) + G(i+1, j))/4;
    end
end


R=R(2:end-1,2:end-1);
B=B(2:end-1,2:end-1);
G=G(2:end-1,2:end-1);

fc_pinta_im(cat(3,R,G,B),'Mosaico Interpolado');


%--------------------------------------------------------------------------
%                                  3.4
%--------------------------------------------------------------------------

im = (0.3*R+0.5*G+0.2*B);
M2 = max(im(:));
BW = im/M2;

U0 = 0.5; U1 = 0.8;
ok=(BW>=U0 & BW<=U1);

n = size(ok(ok==1));
dims_im = size(BW);
perc = n(1)/(dims_im(1)*dims_im(2)) * 100;

RR = mean2(R(ok));
GG = mean2(G(ok));
BB = mean2(B(ok));

div=[RR GG BB]/mean([RR GG BB]);

R = R./div(1);
G = G./div(2);
B = B./div(3);

sR = 1.65*R - 0.61*G - 0.04*B;
sG = 0.01*R + 1.27*G - 0.28*B;
sB = 0.01*R - 0.21*G + 1.20*B;

a = cat(3,sR,sG,sB);
a(a<0) = 0;
a(a>1) = 1;

fc_pinta_im(a, 'Balance de Blancos + paso a sRGB');


%--------------------------------------------------------------------------
%                                  3.5
%--------------------------------------------------------------------------
sR = sR.^0.4167;
sG = sG.^0.4167;
sB = sB.^0.4167;

fc_pinta_im(cat(3,sR,sG,sB), 'Aplicación de función y');


%--------------------------------------------------------------------------
%                                  3.6
%--------------------------------------------------------------------------

image = cat(3,sR,sG,sB);

hsv=rgb2hsv(image);

% Contraste
V = hsv(:,:,3);

% reescalar a [0,1] -----------------------
figure;
hist(V(:),1000); 
xlim([-0.05 1.05]);

max_hsv_v = max(V(:));
min_hsv_v = min(V(:));
V2 = (V-min_hsv_v)/(max_hsv_v - min_hsv_v);

figure;
hist(V2(:),1000); 
xlim([-0.05 1.05]);
%------------------------------------------

% Retocar Contraste
V = retoca(V, 1.05);
hsv(:,:,3) = V;

image = hsv2rgb(hsv);
fc_pinta_im(image, 'Aumento de contraste');

% Retocar Saturacion
S = hsv(:,:,2);

S = retoca(S, 1.25);
hsv(:,:,2) = S;

% Final
image = hsv2rgb(hsv);
fc_pinta_im(image, 'Aumento de contraste y Saturación');


%--------------------------------------------------------------------------
%                                  3.7
%--------------------------------------------------------------------------

image = uint8(image * 255);
imwrite(image,'foto.tif');

imwrite(image,'foto_99.jpg','Quality',99);
imwrite(image,'foto_90.jpg','Quality',90);


image2 = imread('foto2.tif');
imwrite(image2,'foto2_99.jpg','Quality',99);
imwrite(image2,'foto2_90.jpg','Quality',90);
%}
%--------------------------------------------------------------------------
%                                Funciones
%--------------------------------------------------------------------------
function P=retoca(P,K)
    figure;
    subplot(211);
    hist(P(:),1000); 
    xlim([-0.05 1.05]);

    m = min(P(:));
    M = max(P(:));
    m=m*K;
    M=M/K;
    P=(P-m)/(M-m);
    P(P<0)=0;
    P(P>1)=1;

    subplot(212);
    hist(P(:),1000); 
    xlim([-0.05 1.05]);
end
