function res=filtro_gauss(im,S)

L = round(S*2); 
Gs = fspecial('gaussian',2*L+1,S); %Creaci�n m�scara gaussiana
im=double(im); 

[N,M,P]=size(im);

% A�adimos margen de L filas y columnas por cada lado
% repitiendo la 1�/�ltima fila y la 1�/�ltima columna
% Equivale a opci�n symmetric en imfilter
im=[im(:,L:-1:1,:) im im(:,M:-1:M-L+1,:)];
im=[im(L:-1:1,:,:);im;im(N:-1:N-L+1,:,:)];
    
res=im*0; s=(-L:L); 
for k=L+1:L+N
  for j=L+1:L+M               
      vec = im(k+s,j+s,:);   
      vec = vec.*Gs;    
      res(k,j,:) = sum(sum(vec));
  end
end

% Quitamos el margen que le hemos a�adido al principio
res = res(L+(1:N),L+(1:M),:);

return