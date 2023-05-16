function E=energia(im)
    soporte = [7 7];
    S = 1.5;
    filtro = fspecial('gauss', soporte, S);
    
    im2 = imfilter(im, filtro, 'sym');
    det = abs(im - im2);
    detalle = det(:,:,1)+det(:,:,2)+det(:,:,3);
    E = 10*log2(1+detalle);

end