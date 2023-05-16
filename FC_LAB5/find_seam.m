function s=find_seam(M)
    [alto,~] = size(M);
    s = zeros(alto, 1);

    [~, s(1)]=min(M(1,:));
    
    for k=2:alto
        [~,s(k)] = min(M(k, (s(k-1)-1):(s(k-1)+1)));
        s(k)=s(k)+s(k-1)-2;
    end
end