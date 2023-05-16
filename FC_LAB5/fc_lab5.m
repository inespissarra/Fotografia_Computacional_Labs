%--------------------------------------------------------------------------
%                                  Ej.1                                
%--------------------------------------------------------------------------
%                                 Parte 1
%{
xy = [ 0 600 465 215; 0 65 680 585];
uv = [275 655 365  25;  30 285 755 340];
P=get_proy(xy,uv);
dump_mat(P);
uv2 = convierte(xy, P);
dif = uv-uv2;

P_inv = inv(P);
xy2 = convierte(uv, P_inv);
iP = get_proy(uv, xy);


%                                 Parte 2

im = im2double(imread('foto.jpg'));
im2 = warp_img(im, P_inv);
figure();
imshow(im2);

demoP4(im);


im = im2double(imread('im.jpeg'));
im = imcrop(im, [120, 0, 570, 900]);
demoP4(im);


%                                 Parte 3
im = im2double(imread('billboard.jpg'));
figure()
imshow(im); % para medir las coordenadas
xy = [1 1500 1500 1;1 1 840 840];
uv = [583 1195 1195 580;266 174 649 556];
P = get_proy(xy, uv);

S = 1;
L = round(2*S);
filtro = fspecial('gauss', 2*L+1, S);

im_s = imfilter(im, filtro, 'sym');

im2 = warp_img(im_s, inv(P));

im2(isnan(im2)) = im(isnan(im2));
figure();
imshow(im2);

% a = img_recursiva(4, im, inv(P));

%}
%--------------------------------------------------------------------------
%                                  Ej.2                                
%--------------------------------------------------------------------------
%                                 Parte 1
xy = [401 643 299 99; 201 296 646 268];
uv = [269 545 276 26; 350 371 744 412];
P = get_nolineal(xy, uv);

iP = get_nolineal(uv, xy);

uv2 = convierte(xy, P);
dif = uv-uv2;

xy2 = convierte(uv, iP);
%                                 Parte 2
%{
im = im2double(imread('foto.jpg'));
im2 = warp_img(im, iP);
figure();
imshow(im2);

im3 = warp_img(im, P);
figure();
imshow(im3);


%                                Mi imagen
im = im2double(imread('im.jpeg'));
im = imcrop(im, [120, 0, 570, 900]);
demoP4(im);
xy = [1 571 571 1; 144.798 146.725 857 857];
uv = [39.3683 407.362 174.235 378.462;408.752 15.7117 745.918 834.545];
P = get_nolineal(xy, uv);


%--------------------------------------------------------------------------
%                                  Ej.3                                
%--------------------------------------------------------------------------
%                                 Parte 1
im = im2double(imread('img.jpg'));
E = energia(im);
pix1010 = E(10,10);
medio = mean2(E);

imagesc(E);
colormap("jet");
colorbar('vert');

size_im = size(im);
altura = size_im(1);
ancho_actual = size_im(2);

ancho_meta = altura * 3/2;
n = ancho_actual - ancho_meta;
im_actual = im;

for i=1:n
    E = energia(im_actual);
    [~, m] = min(E);
    m = mod(m, ancho_actual) + 1;
    new_im = zeros(altura, ancho_actual-1, 3);
    for j=1:altura
        new_im(j, 1:m(j)-1,:) = im_actual(j,1:m(j)-1,:);
        new_im(j,m(j):ancho_actual-1,:) = im_actual(j,m(j)+1:ancho_actual,:);
    end
    ancho_actual = ancho_actual-1;
    im_actual = new_im;
end


E = energia(im_actual);
medio = mean2(E);

imshow(im_actual)


%                                Parte 2
im = im2double(imread('img.jpg'));
E = energia(im);
M = calcula_M(E);

figure();
imagesc(M);
colormap("hot");
colorbar('vert');

figure();
plot(M(1,:));

s=find_seam(M);

[alto] = size(im);
figure();
imshow(im);
hold on;
plot(s,1:alto, 'Color','g','LineWidth',2);
hold off;

[alto] = size(im);
sum = 0;
for i=1:alto
    sum = sum+E(i,s(i));
end


%                                Parte 3
% imagen del prof
% im = im2double(imread('img.jpg'));

% Mi imagen
im = im2double(imread('image.JPG'));
im = imcrop(im, [150 100 1650 850]);
im = imresize(im, [648, 1152]);

im_actual = im;

size_im = size(im);
altura = size_im(1);
ancho_actual = size_im(2);

ancho_meta = altura * 3/2;
n = ancho_actual - ancho_meta;

for n=1:n
    E = energia(im_actual);
    M = calcula_M(E);
    s=find_seam(M);
    new_im = zeros(altura, ancho_actual-1, 3);
    for j=1:altura
        new_im(j, 1:s(j)-1,:) = im_actual(j,1:s(j)-1,:);
        new_im(j,s(j):ancho_actual-1,:) = im_actual(j,s(j)+1:ancho_actual,:);
    end
    ancho_actual = ancho_actual-1;
    im_actual = new_im;
end

%E = energia(im_actual);
%M = calcula_M(E);

%plot(M(1,:));

% imagen del prof
%im_resize = imresize(im, [altura, ancho_actual]);
%im_el_nprim = im(:, (n+1):end, :);
%imshow([im_resize;im_el_nprim;im_actual])

%media = mean2(E);

% Mi imagen
imshow(im_actual)

%                                Parte 4
im = im2double(imread('img.jpg'));
im_actual = im;

size_im = size(im);
altura = size_im(1);
ancho_actual = size_im(2);

ancho_meta = altura * 2;
n = ancho_meta-ancho_actual;

for i=1:n
    E = energia(im_actual);
    M = calcula_M(E);
    s=find_seam(M);
    new_im = zeros(altura, ancho_actual+1, 3);
    for j=1:altura
        new_im(j, 1:s(j),:) = im_actual(j,1:s(j),:);
        new_im(j, s(j)+1,:) = im_actual(j,s(j),:);
        new_im(j,s(j)+2:ancho_actual+1,:) = im_actual(j,s(j)+1:ancho_actual,:);
    end
    ancho_actual = ancho_actual+1;
    im_actual = new_im;
end

imshow(im_actual);


%                                Parte 5
% imagen del prof
% im = im2double(imread('img.jpg'));

% Mi imagen
im = im2double(imread('image.JPG'));
im = imcrop(im, [150 100 1550 850]);
im = imresize(im, [648, 1152]);

size_im = size(im);
altura = size_im(1);
ancho_actual = size_im(2);

ancho_meta = altura * 2;
n = ancho_meta-ancho_actual;

E = energia(im);
S = zeros(altura, n);

%figure();
%imshow(im);

for k=1:n
    M = calcula_M(E);
    S(:,k)=find_seam(M);
    E(:, S(:,k)') = E(:, S(:,k)')*1.5;
    %hold on;
    %plot(S(:,k),1:altura, 'Color','g','LineWidth',2);
    %hold off;
end


im2 = zeros(altura, ancho_meta, 3);
for k=1:altura
    idx = sort([1:ancho_actual S(k, :)]);
    im2(k,:,:)=im(k, idx,:);
end

% imagen del prof
% im_resize = imresize(im, [altura, ancho_meta]);
% im3 = [zeros(altura, n/2,3) im zeros(altura, n/2,3)];
% imshow([im_resize;im3;im2])

%Mi imagen
imshow(im2);

%}