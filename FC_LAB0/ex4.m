im = imread("faro.jpg");
im2 = imread("playa.jpg");
ntsc = rgb2ntsc(im);
ntsc2 = rgb2ntsc(im2);

for i = (1:3)
    fprintf('mean: %.2f\nstandard desviation: %.2f\n', mean2(ntsc2(:,:,i)), std2(ntsc2(:,:,i)));
    ntsc2(:,:,i) = (ntsc2(:,:,i) - mean2(ntsc2(:,:,i)))/std2(ntsc2(:,:,i));
    ntsc2(:,:,i) = (ntsc2(:,:,i) * std2(ntsc(:,:,i))) + mean2(ntsc(:,:,i));
    fprintf('mean: %.2f\nstandard desviation: %.2f\n\n', mean2(ntsc2(:,:,i)), std2(ntsc2(:,:,i)));
end

res = ntsc2rgb(ntsc2);
figure(2);
subplot(1,3,1);
imshow(im2);
subplot(1,3,2);
imshow(res);
subplot(1,3,3);
imshow(im);