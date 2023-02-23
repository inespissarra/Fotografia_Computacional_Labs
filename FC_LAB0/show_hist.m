function show_hist(im)
    figure(1)
    subplot(211);
    imshow(im);
    subplot(212);
    imhist(im);
    set(gca,'Xlim',[-5 260]);
    set(gca,'Ylim',[0 5000]);
end