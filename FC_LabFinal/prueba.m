clear

im1 = im2double(imread("img1.jpg"));
im2 = im2double(imread("img2.jpg"));
im3 = im2double(imread("img3.jpg"));

E1 = enfoque(im1);
M = max(E1(:));

figure();
imagesc(E1); 
colormap('jet');
colorbar('vert');

E2 = enfoque(im2);
E3 = enfoque(im3);

S = E1 + E2 + E3;

p1 = E1./S;
p2 = E2./S;
p3 = E3./S;


image = cat(3, p1,p2,p3);
figure();
imshow(image);

im = im1*0;
for k=1:3
    im(:,:,k) = p1.*im1(:,:,k) + p2.*im2(:,:,k) + p3.*im3(:,:,k);
end

figure()
imshow(im);

%--------------------------------------------------------------------------
clear
im = im2double(imread("foto.jpg"));
YIQ = rgb2ntsc(im);


im1 = YIQ;

soporte = [7 7];
S = 1.5;
G = fspecial('gauss', soporte, S);
im1(:,:,1)= imfilter(im1(:,:,1), G, 'sym');
im1 = ntsc2rgb(im1);


im2 = YIQ;

soporte = [15 15];
S = 3;
G = fspecial('gauss', soporte, S);
im2(:,:,2)= imfilter(im1(:,:,2), G, 'sym');
im2(:,:,3)= imfilter(im1(:,:,3), G, 'sym');
im2 = ntsc2rgb(im2);

trozo = im(300:400, 170:330,:);
trozo1 = im1(300:400, 170:330,:);
trozo2 = im2(300:400, 170:330,:);

image = [trozo trozo1 trozo2];
figure();
imshow(image)

imwrite(im1, 'foto1.jpg', 'Quality', 98)
imwrite(im2, 'foto2.jpg', 'Quality', 98)

function E=enfoque(im)
    im = rgb2gray(im);
    soporte = [11 11];
    S = 2.5;
    G = fspecial('gauss', soporte, S);
    im_filtrada = imfilter(im, G, 'sym');
    dif = 255*(im-im_filtrada).^2;
    E = imfilter(dif, G, 'sym');
end