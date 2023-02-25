clear
obj=VideoReader('movie.mp4');

X=[540 644 648 544]'; Y=[370 370 473 473]';
NF = get(obj, 'NumFrames');
fprintf('Numero de Frames NF=%d\n',NF);

U = zeros(4, NF);
V = zeros(4, NF);
D = zeros(1, NF);
D2 = zeros(1, NF-1);

figure(1);  
frame=read(obj,1); im_obj=imshow(frame); hold on; 
pp_obj=plot(X,Y,'yo','MarkerFaceCol','y','MarkerSize',4); 
tt=text(X+20,Y+20,['1';'2';'3';'4']);
t_frame=text(15,20,'Frame# 001','Color','y','FontSize',18);
set(tt,'FontWeight','Bold','Color',[0 0 1]);
hold off

pause

R = 25;
%R = 10;
r=(-R:R); dx=ones(length(r),1)*r; dy=dx';
  
for k=1:NF

  % Leer y presentar el siguiente frame  
  frame=read(obj,k); set(im_obj,'Cdata',frame);
  
  frame_gray=rgb2gray(frame);
 % Bucle actualizando posiciones X(j),Y(j) de las 4 esquinas
  for j=1:4
    x=round(X(j)); y=round(Y(j));
    S=im2double(frame_gray((y+r),(x+r)));

    S0=min(S(:));
    d = abs(S-S0);
    w=exp(-50*d);
    w=w/sum(w(:));

    mult=w.*(x+dx);
    X(j) = sum(mult(:));

    mult2=w.*(y+dy);
    Y(j) = sum(mult2(:));

    U(j, k) = x;
    V(j, k) = y;
  end

  D(1, k) = sqrt((X(1)- X(2))^2+(Y(1)-Y(2))^2);
  if k>1 
    D2(1, k-1) = sqrt((U(1, k-1) - U(1, k))^2+(V(1, k-1)-V(1, k))^2);
  end

 
 % Actualizar plot y etiquetas de los puntos sobre la imagen.  
 set(pp_obj,'Xdata',X,'Ydata',Y); 
 for z=1:4, set(tt(z) ,'Position',[X(z)+15 Y(z)+15 0]); end  
 set(t_frame,'String',sprintf('Frame# %03d',k));
 drawnow

 %if k==400
 %   pause;
 %end
 
end

figure(2);
plot(U');
legend('Punto 1','Punto 2', 'Punto 3', 'Punto 4')

figure(3);
plot(V');
legend('Punto 1','Punto 2', 'Punto 3', 'Punto 4')

figure(4);
plot(D');
xlim([0 NF]);
ylim([0 max(D(:)) + 20]);

figure(5);
plot(D2');
xlim([0 NF]);
ylim([0 max(D2(:)) + 20]);
