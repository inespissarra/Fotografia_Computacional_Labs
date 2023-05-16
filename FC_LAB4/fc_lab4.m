%--------------------------------------------------------------------------
%                                  Ej.1                                
%--------------------------------------------------------------------------

S = 2;
L = round(2*S);
filtro = fspecial('gauss', 2*L+1, S);

im = double(imread('img1.jpg'));
im_s = imfilter(im, filtro, 'sym');

figure()
imshow(im/255);
figure()
imshow(im_s/255);

det = (im - im_s);

show_detail(det);

alfa = 1.5;
im2_gauss = im + alfa*det;

im_comp = im;
dims = size(im_comp);
im_comp(1:dims(1)/2,:) = im2_gauss(1:dims(1)/2,:);

figure()
imshow(im_comp/255);


%--------------------------------------------------------------------------
%                                  Ej.2                                
%--------------------------------------------------------------------------

S = 2;
R = 20;
L = round(2*S);
im = double(imread('img1.jpg'));

f1 = filtro_bilat(im, S, R);

f2=imbilatfilt(im,R^2,S,'Padding','symmetric','NeighborhoodSize',2*L+1);

f = f1-f2;
M = max(f(:));
m = min(f(:));


det=(im-f1);
show_detail(det);

alfa = 2.5;
im2_bilat = im + alfa*det;

figure()
imshow(im2_bilat/255)


S = 5;
R = 20;
L = round(2*S);
im = double(imread('img1.jpg'));

filtro_gauss = fspecial('gauss', 2*L+1, S);
im_s_gauss = im;
im_s_bilat = im;


for i=1:4
    im_s_gauss = imfilter(im_s_gauss, filtro_gauss, 'sym');
    im_s_bilat=imbilatfilt(im_s_bilat,R^2,S,'Padding','symmetric','NeighborhoodSize',2*L+1);
end


figure()
imshow(im_s_gauss/255)
figure()
imshow(im_s_bilat/255)

%--------------------------------------------------------------------------
%                                 Ej.2b                                
%--------------------------------------------------------------------------

clear;
flash = double(imread('flash.jpg'));
im1 = double(imread('no_flash.jpg'));

S = 5; R = 10;
im2 = filtro_gauss(im1, S);
im3 = filtro_cross(im1, flash, S, R);

im = [im1 im2 im3];

figure()
imshow(im/255);


%--------------------------------------------------------------------------
%                                 Ej.3                                
%--------------------------------------------------------------------------

clear;
im = imread('img2.bmp');
figure()
imshow(im);

v=(0:255); edges=v(1)-0.5:v(end)+0.5; h = histcounts(im(:),edges);
figure();
bar(v, h);
npix = numel(im);
h = h/npix;
suma = sum(h(:));
p50 = h(50+1);

T = cumsum(h);
plot(T);

im2 = T(im + 1) * 255;
image = [im,im2];
figure()
imshow(image);

h2 = histcounts(im2(:),edges);
h2 = h2/npix;
figure();
bar(v, h2)


figure();
v2 = (0:31);
subplot(121);
h=histcounts(im(:),32);
bar(v2, h);

subplot(122);
h2=histcounts(im2(:),32);
bar(v2, h2);



%--------------------------------------------------------------------------
%                                 Ej.3b                                
%--------------------------------------------------------------------------
clear;
im = imread('img2.bmp');
im = im2double(im);
I = rgb2gray(im);

S=5;L=round(2*S); R=0.05;
w=imbilatfilt(I,R^2,S,'Padding','symmetric','NeighborhoodSize',2*L+1);

w = (w-min(w(:)))/(max(w(:)-min(w(:))));

y = 0.05;
alfa = f_alfa(w, y);
figure();
imagesc(alfa);
colorbar('vert');
I_out = L_alfa(I, alfa);
R = I_out./(I+0.001);
figure();
imagesc(R);
colorbar('vert');

I_res = im.*R;
image = [im, I_res, sqrt(im)];
figure();
imshow(image);

%--------------------------------------------------------------------------

clear;
im = imread('img2.bmp');
im = im2double(im);
I = rgb2gray(im);

S=5;L=round(2*S); R=0.05;
filtro=fspecial('gaussian',2*L+1,S); 
w=imfilter(I,filtro,'sym');

w = (w-min(w(:)))/(max(w(:)-min(w(:))));

y = 0.05;
alfa = f_alfa(w, y);
figure();
imagesc(alfa);
colorbar('vert');
I_out = L_alfa(I, alfa);
R = I_out./(I+0.001);
figure();
imagesc(R);
colorbar('vert');

I_res = im.*R;
figure();
imshow(I_res);

%--------------------------------------------------------------------------
%                                 Ej.4                                
%--------------------------------------------------------------------------
clear;
G = im2double(imread('degradado.png'));
imshow(G);

load K;
imagesc(K);colormap(gray)

K2=fliplr(flipud(K));
F = G;

std_dF = zeros(400);

for i=1:400
    G2 = imfilter(F, K, "symmetric");
    Q = G./(G2+0.001);
    Q = imfilter(Q, K2, "symmetric");
    F_old = F;
    F = F_old.*Q;
    F(F>1)=1; F(F<0)=0;
    dF = F-F_old;
    std_dF(i) = std2(dF);
end

figure()
imshow(F);
figure();
semilogy(std_dF);

%--------------------------------------------------------------------------

clear;
G = im2double(imread('degradado.png'));
imshow(G);

K=fspecial("gauss",17,4);

K2=fliplr(flipud(K));
F = G;

std_dF = zeros(400);

for i=1:400
    G2 = imfilter(F, K, "symmetric");
    Q = G./(G2+0.001);
    Q = imfilter(Q, K2, "symmetric");
    F_old = F;
    F = F_old.*Q;
    F(F>1)=1; F(F<0)=0;
    dF = F-F_old;
    std_dF(i) = std2(dF);
end

figure()
imshow(F);
figure();
semilogy(std_dF);
p

%--------------------------------------------------------------------------
%                                Funciones                                
%--------------------------------------------------------------------------

function show_detail(det)
    abs_det = abs(det);
    R = abs_det(:,:,1);
    G = abs_det(:,:,2);
    B = abs_det(:,:,3);

    det_final = 0.3*R+0.55*G+0.15*B;
    figure();
    imagesc(det_final);
    colorbar('vert');
end

function alfa=f_alfa(w,G)
    alfa = w;
    alfa(w<=0.5) = 128*(1-(w(w<=0.5)/0.5).^G);
    alfa(w>0.5) = -128*(1-((1-w(w>0.5))/0.5).^G);
end

function I_out=L_alfa(I,alfa)
    I_out = I;
    I_out(alfa>0) = log(1+alfa(alfa>0).*I(alfa>0))./log(1+alfa(alfa>0));
    I_out(alfa<0) = 1-log(1+abs(alfa(alfa<0)).*(1-I(alfa<0)))./log(1+abs(alfa(alfa<0)));
end
