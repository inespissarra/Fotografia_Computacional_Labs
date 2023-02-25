L = 360; U = 0.4;
PENALTY = 50;
M = 192; N = 288;

rx=(1:M); ry=(1:N);

im_original = imread("target.jpg");
im_original = im2double(im_original);
imagenes = imags;

dims_target = size(im_original);
im = zeros(dims_target(1),dims_target(2));
vertical = dims_target(1)/N;
horizontal = dims_target(2)/M;

for j = 1:vertical
    for i = 1:horizontal
        im(ry,rx) = imags(:,:,(j-1) * horizontal + i);
        rx = rx + M;
    end
    ry = ry + N;
    rx=(1:M);
end

usos = ones(1, L);
timeout=zeros(1,L); %
rx=(1:M);
ry=(1:N);

for j = 1:vertical
    for i = 1:horizontal
        timeout = timeout - 1; %
        sub_im = im_original(ry, rx);
        seleccionado = im(ry, rx);
        e0 = mean2(abs(sub_im - seleccionado));
        min = e0;
        for n=1:L
            if timeout(n)>0 %
                continue; %
            end %
            e = mean2(abs(sub_im - imagenes(:,:,n)));
            if e/e0<U
                min = e;
                k = n;
                seleccionado = imagenes(:,:,n);
                break;
            elseif e < min
                    k = n;
                    min = e;
                    seleccionado = imagenes(:,:,n);
            end
        end
        im(ry,rx) = seleccionado;
        if(min~=e0)
            usos(k) = usos(k) + 1;
            usos(horizontal * (j-1) + i) = usos(horizontal * (j-1) + i) - 1;
            timeout(k)=PENALTY; %
        end
        rx = rx + M;
    end
    ry = ry + N;
    rx=(1:M);
end

figure(1);
imshow(im);
figure(2);
plot(usos');

mas_20 = 0;
for i=1:L
    if usos(i)>20
        mas_20 = mas_20 + 1;
    end
end
sum = sum(usos);