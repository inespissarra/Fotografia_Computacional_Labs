%Apartado 1.1
image=imread("foto_bw.jpg");
figure(1);
imshow(image);
whos im;
maximo=max(image(:));
minimo=min(image(:));
media=mean2(image);
fprintf("Máximo de la imagen es: %d\n", maximo);
fprintf("Mínimo de la imagen es: %d\n", minimo);
fprintf("Medio de la imagen es: %d\n", media);
%Apartado 1.2
image_double=double(image)/255; %Alternativamente im2double(image)
figure(6);
im2=double(image/255);
imshow(im2);
%La imagen sigue siendo equivalente a la anterior debido a que es un simple reescalado de [0,255] a [0,1]
figure(2);
imshow(image_double);
%Apartado 1.3
%Parece que aplica un filtro para transformar los grises en blancos
image_transformed=sin(image_double*pi);
figure(3);
imshow(image_transformed);
%Apartado 1.4
%Sumamos a la imagen original un ruido aleatorio
%while true
image_noisy = image_double+0.1*randn(size(image_double));
maximo=max(image_noisy(:));
minimo=min(image_noisy(:));
media=mean2(image_noisy);
fprintf("Máximo de la imagen con ruido es: %d\n", maximo);
fprintf("Mínimo de la imagen con ruido es: %d\n", minimo);
fprintf("Medio de la imagen con ruido es: %d\n", media);
figure(4);
imshow(image_noisy);
%pause;
%end
%Apartado 1.5
%Parece hacer lo mismo que en el apartado 1.4, es decir, trunca
%los valores menores que 0 a 0, y los mayores que 1, a 1
image_noisy(image_noisy>1)=1;
image_noisy(image_noisy<0)=0;
figure(5);
imshow(image_noisy);





