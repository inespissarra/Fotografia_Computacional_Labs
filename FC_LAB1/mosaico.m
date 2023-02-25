L = 360; U = 0.4;
PENALTY = 50;
M = 192; N = 288;

im_original = imread("target.jpg");
im_original = im2double(im_original);
imagenes = imags;

dims_target = size(im_original);
im = zeros(dims_target(1),dims_target(2));
vertical = dims_target(1)/N;
horizontal = dims_target(2)/M;

rx=(1:M); ry=(1:N);
for j = 1:vertical
    for i = 1:horizontal
        im(ry,rx) = imags(:,:,(j-1) * horizontal + i);
        rx = rx + M;
    end
    ry = ry + N; rx=(1:M);
end

for r=1:4
    rx=(1:M); ry=(1:N);
    timeout=zeros(1,L);
    for j = 1:(vertical * 2^(r-1))
        for i = 1:(horizontal * 2^(r-1))
            timeout = timeout - 1;
            sub_im = im_original(ry, rx);
            seleccionado = im(ry, rx);
            e0 = mean2(abs(sub_im - seleccionado));
            min = e0;
            for n=1:L
                if timeout(n)>0
                    continue;
                end
                a=mean2(sub_im-imagenes(:,:,n));
                e = mean2(abs(sub_im - (imagenes(:,:,n) + a)));
                if e/e0<U
                    k = n; min = e;
		            seleccionado = imagenes(:,:,n) + a;
                    break;
                elseif e < min
                        k = n; min = e;
                        seleccionado = imagenes(:,:,n) + a;
                end
            end
            if(min~=e0)
                timeout(k)=PENALTY;
            end
            im(ry,rx) = seleccionado;
            rx = rx + M;
        end
        ry = ry + N; rx=(1:M);
    end
    imagenes=imresize(imagenes,1/2);
    PENALTY = PENALTY*2;
    U = sqrt(U);
    M = M/2; N = N/2;
end

figure(1);
imshow(im);
figure(2);
imshow(im(700:1500, 2200: 3500));