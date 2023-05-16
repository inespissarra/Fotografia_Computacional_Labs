function P=get_proy(xy,uv)

    Z=zeros(4,3);
    A=[xy(1,:)' xy(2,:)' ones(4,1)];
    b=[uv(1,:)' uv(1,:)' uv(1,:)'];
    B=-A.*b;
    c=[uv(2,:)' uv(2,:)' uv(2,:)'];
    C=-A.*c;
 
    M = [A Z B; Z A C];
    
    [U,S,V]=svd(M); % Descomposicion valores singulares
    h = V(:,9);  
    P = reshape(h,3,3)';
    P = P/P(3,3);

end