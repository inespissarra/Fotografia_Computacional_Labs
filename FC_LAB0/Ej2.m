%apartado 2.1

im=imread('faunia.jpg');
im_d=im2double(im);

figure(1);
subplot(2,2,1);
im_r=im_d;
im_r(:,:,2)=0;
im_r(:,:,3)=0;
imshow(im_r);
subplot(2,2,2);
im_g=im_d;
im_g(:,:,1)=0;
im_g(:,:,3)=0;
imshow(im_g);
subplot(2,2,3);
im_b=im_d;
im_b(:,:,1)=0;
im_b(:,:,2)=0;
imshow(im_b);

%Apartado 2.2
figure(2);
imshow(im(:,:,[3 1 2]));

%Apartado 2.3
hsv1=rgb2hsv(im_d);
hsv2=hsv1;
hsv3=hsv1;
% ponemos valores del canal V a 0.5
figure(3);
hsv1(:,:,3)=0.5;
res=hsv2rgb(hsv1);
imshow(res);
% ponemos valores del canal de saturacion a 1
figure(4);
hsv2(:,:,2)=1;
res=hsv2rgb(hsv2);
imshow(res);
% ponemos valores del canal del tono a 0.33
figure(5);
hsv3(:,:,1)=0.33;
res=hsv2rgb(hsv3);
imshow(res);
