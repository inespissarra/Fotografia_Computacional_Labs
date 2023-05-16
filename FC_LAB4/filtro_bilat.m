function res=filtro_bilat(im,S, R)

L = round(S*2); 
Gs = fspecial('gaussian',2*L+1,S); %Creación máscara gaussiana
im=double(im); 

[N,M,P]=size(im);

% Añadimos margen de L filas y columnas por cada lado
% repitiendo la 1ª/última fila y la 1ª/última columna
% Equivale a opción symmetric en imfilter
im=[im(:,L:-1:1,:) im im(:,M:-1:M-L+1,:)];
im=[im(L:-1:1,:,:);im;im(N:-1:N-L+1,:,:)];
    
res=im*0; s=(-L:L); 
for k=L+1:L+N
  for j=L+1:L+M               
      vec = im(k+s,j+s,:);   
      D = (vec - im(k,j,:))/R;
      D2 = sum(D.^2, 3);
      Gr= exp(-0.5*D2);
      G = Gr.*Gs;
      G = G/sum(G(:));
      vec = vec.*G;
      res(k,j,:) = sum(sum(vec));
  end
end

% Quitamos el margen que le hemos añadido al principio
res = res(L+(1:N),L+(1:M),:);

return