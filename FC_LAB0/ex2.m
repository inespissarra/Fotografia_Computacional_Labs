figure(1)
im=imread('faunia.jpg');
subplot(2,2,1);
im1 = im;
im1(:,:,2)=0;
im1(:,:,3)=0;
imshow(im1);
subplot(2,2,2);
im2 = im;im3(im3<0)=0;
im2(:,:,1)=0;
im2(:,:,3)=0;
imshow(im2);
subplot(2,2,3);
im3 = im;
im3(:,:,1)=0;
im3(:,:,2)=0;
imshow(im3);

figure(2);
imshow(im(:,:,[3 1 2]))