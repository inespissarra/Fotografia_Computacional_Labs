function uv=convierte(xy,P)
    size_xy = size(xy);
    if(numel(P)==9)
        xy = [xy; ones(1, size_xy(2))];
        mult = P*xy;
        uv = mult(1:2, :)./mult(3, :);
    else
        xy = [ones(1, size_xy(2)); xy; (xy(1,:).*xy(2,:))];
        uv = P*xy;
    end

end