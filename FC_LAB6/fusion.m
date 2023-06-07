clear;

N = 5;

im1 = im2double(imread("exp_1.jpg"));
p1 = lap(im1, N);
im2 = im2double(imread("exp_2.jpg"));
p2 = lap(im2, N);
im3 = im2double(imread("exp_3.jpg"));
p3 = lap(im3, N);

pm = cell(1, N);

pm{N} = (p1{N} + p2{N} + p3{N})/3;

for l = 1:N-1
    [alto, ancho, ~] = size(p1{l});
    nivel_combinado = zeros(alto, ancho, 3);
    for i = 1:alto
        for j = 1:ancho
            detalle1 = p1{l}(i, j, :);
            detalle2 = p2{l}(i, j, :);
            detalle3 = p3{l}(i, j, :);

            norm1 = norm(detalle1(:));
            norm2 = norm(detalle2(:));
            norm3 = norm(detalle3(:));
            if norm1 >= norm2 && norm1 >= norm3
                nivel_combinado(i, j, :) = p1{l}(i, j, :);
            elseif norm2 >= norm1 && norm2 >= norm3
                nivel_combinado(i, j, :) = p2{l}(i, j, :);
            else
                nivel_combinado(i, j, :) = p3{l}(i, j, :);
            end
        end
    end 
    
    pm{l} = nivel_combinado;
end

HDR=pm{N};

for k=N-1:-1:1
    HDR = imresize(HDR, 2);
    HDR = HDR + pm{k};
end


v0 = min(HDR(:));
v1 = max(HDR(:));
HDR = (HDR-v0)/(v1-v0);

HSV = rgb2hsv(HDR);

HSV(:,:,3) = adapthisteq(HSV(:,:,3),'ClipLimit',0.01);

HSV(:,:,2) = HSV(:,:,2).^0.75;

RGB = hsv2rgb(HSV);
imshow(RGB)


%----------------------------- Funciones ----------------------------------

function p=lap(im,N)
    p=cell(1,N);
    for k=1:N-1
        im_red = imresize(im, 1/2);
        im2 = imresize(im_red, 2);
        p{k} = im-im2;
        im = im_red;
    end
    p{N} = im;
end