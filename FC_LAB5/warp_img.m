function im2=warp_img(im,iP)
    size_im = size(im);
    im2 = im;
    X = zeros(size_im(1), size_im(2));
    Y = zeros(size_im(1), size_im(2));
    uv = zeros(2, size_im(2));
    uv(1, :)= 1:size_im(2);
    
    for k=1:size_im(1)
        uv(2, :)= k;
        xy = convierte(uv, iP);
        X(k, :)=xy(1,:);
        Y(k, :)=xy(2,:);
    
    end
    
    for i=1:size_im(3)
        im2(:,:,i)=interp2(im(:,:,i),X,Y,'bilinear');
    end
end


