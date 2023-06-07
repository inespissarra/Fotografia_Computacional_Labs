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