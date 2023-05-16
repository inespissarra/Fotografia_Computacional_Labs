function im_res = img_recursiva(n,im,iP)
    if n==0
        im_res=im;
        return;
    end
    S = 1;
    L = round(2*S);
    filtro = fspecial('gauss', 2*L+1, S);
    im_2 = imfilter(im, filtro, 'sym');
    im_2 = warp_img(im_2,iP);
    im_rec=img_recursiva(n-1, im_2, iP);
    idxMat=isnan(im_rec);
    im_rec(idxMat)=im(idxMat);
    im_res=im_rec;
end

