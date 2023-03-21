im=imread('malla.JPG'); 

% Calcular imagen auxiliar aux a partir de im 
global aux
aux=min(im,[],3);
G = fspecial('gaussian',15,5); aux=imfilter(aux,G);

figure(1); imshow(im)

lista={'sup. izda','sup. dcha','inf. dcha','inf. izda'};
u=zeros(1,4); v=zeros(1,4);  % guardar coordenadas esquinas   
for k=1:4  
  fprintf('Esquina %s: ',lista{k});  
  [x,y]=ginput(1); 

  [u(k), v(k)] = refinar(x, y);
  
  fprintf('x_inicial=%6.1f,y_inicial=%6.1f\n',x,y); %
  fprintf('x_final=%6.1f,y_final=%6.1f\n',u(k),v(k));

  hold on; plot(x,y,'ro','MarkerFaceCol','r','MarkerSize',10); %
  hold on; plot(u(k),v(k),'ro','MarkerFaceCol','g','MarkerSize',10); 
  
  hold off;
end

%hold on; 
%plot([u u(1)],[v v(1)],'b');
%hold off;

%..........................................................................

X = [-100, 100, 100, -100];
Y = [60, 60, -60, -60];

%X = [-20, 20, 20, -20];
%Y = [-20, -20, -60, -60];

H=fc_get_H(X,Y,u,v);
volcar_H(H);
save H1 H;
%save H2 H;


load malla_XY;
load H1;

UVW=H*[X; Y; ones(1,77)];

up = UVW(1,:)./UVW(3,:);
vp = UVW(2,:)./UVW(3,:);

d = zeros(1, 77);
du = zeros(1, 77);
dv = zeros(1, 77);

for k=1:77
  [u(k), v(k)] = refinar(up(k), vp(k));
  
  fprintf('x_final=%6.1f,y_final=%6.1f\n',u(k),v(k));

  du(k) = up(k) - u(k);
  dv(k) = vp(k) - v(k);
  d(k) = sqrt(du(k)^2+dv(k)^2);

  hold on; 
  plot(up(k),vp(k),'ro','MarkerFaceCol','r','MarkerSize',7);
  plot(u(k),v(k),'ro','MarkerFaceCol','g','MarkerSize',7); 
  hold off;
end

mean_d = mean2(d);
fprintf("Valor medio de d: %f \n", mean_d);

figure(2);
fc_quiver(du, dv, 4);

H=fc_get_H(X,Y,u,v);
volcar_H(H);
save H77 H;

%..........................................................................

load malla_XY;
load H77;

UVW=H*[X; Y; ones(1,77)];

up = UVW(1,:)./UVW(3,:);
vp = UVW(2,:)./UVW(3,:);

d = zeros(1, 77);
du = zeros(1, 77);
dv = zeros(1, 77);

for k=1:77
  [u(k), v(k)] = refinar(up(k), vp(k));
  
  fprintf('x_final=%6.1f,y_final=%6.1f\n',u(k),v(k));

  du(k) = up(k) - u(k);
  dv(k) = vp(k) - v(k);
  d(k) = sqrt(du(k)^2+dv(k)^2);

  hold on; 
  plot(up(k),vp(k),'ro','MarkerFaceCol','r','MarkerSize',7);
  plot(u(k),v(k),'ro','MarkerFaceCol','g','MarkerSize',7); 
  hold off;
end

mean_d = mean2(d);
fprintf("Valor medio de d: %f \n", mean_d);

figure(3);
fc_quiver(du, dv, 4);


%..........................................................................

load malla_XY;
load H77;

ancho_sensor_mm = 5.6; % 23.7 sensor original; 5.6 sensor mi telefono
alto_sensor_mm = 4.2; % 15.7 sensor original; 4.2 sensor mi telefono

dims = size(aux);
u0 = 1/2*dims(2); v0 = 1/2*dims(1);

h1 = H(:,1); h2 = H(:,2);
B = [1 0 -u0; 0 1 -v0; -u0 -v0 u0^2+v0^2];

f = sqrt((h2'*B*h2 - h1'*B*h1)/(H(3, 1)^2- H(3, 2)^2));

ppmm = dims(2)/ancho_sensor_mm;
fm = f / ppmm;

K = [f 0 u0; 0 f v0; 0 0 1];
[R, t] = pose_from_HK(H, K);

X0 = inv(-R)*t;
dist = norm(X0);

% w = [40; 0; -10];
% R = R2w(w);
% 
% R = [0.3481  0.9332  0.0893;0.6313 -0.3038  0.7135;0.6930 -0.1920 -0.6949];
% w = R2w(R);

k1 = 0;
w = R2w(R);

P0 = [t;w;f;k1;u0;v0];
error=error_uv(P0,X,Y,u,v);

du = error(1:77);
dv = error(78:154);
figure(4);
fc_quiver(du,dv, 4);

opts = optimset('Algorithm', 'levenberg-marquardt', 'Display', 'off');
f_min = @(P)error_uv(P, X, Y, u, v);
P=lsqnonlin(f_min, P0, [], [], opts);

fprintf("Focal (pixels) %f\n", P(7));
fprintf("Focal (mm) %f\n", P(7)/ppmm);

error=error_uv(P,X,Y,u,v);
du = error(1:77);
dv = error(78:154);
figure(5);
fc_quiver(du,dv, 4);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%  Funciones auxiliares %%%%%%%%%%%

function volcar_H(H)
  fprintf('%7.3f %7.3f %7.2f\n',H');
end


function [xm,ym]=refinar(x,y)
    global aux
    % Definición del tamaño y coordenadas zona a explorar
    R=50; r=(-R:R); dx=ones(length(r),1)*r; dy=dx'; %dx?
    
    x=round(x); y=round(y);
    S=im2double(aux((y+r),(x+r)));
    
    S0=min(S(:));
    d = abs(S-S0);
    w=exp(-50*d);
    w=w/sum(w(:));
    
    mult=w.*(x+dx);
    xm = sum(mult(:));
    
    mult2=w.*(y+dy);
    ym = sum(mult2(:));
end


function [R,t]=pose_from_HK(H,K)

    Q = inv(K) * H;
    
    r1 = Q(:, 1);
    r2 = Q(:, 2);
    t = Q(:, 3);
    n1 = norm(r1);
    n2 = norm(r2);
    alpha = sqrt(n1*n2);
    r1 = r1/n1; r2 = r2/n2;
    t = t/alpha;
    
    r3 = cross(r1, r2);
    r3=r3/norm(r3);

    prod_escalar = dot(r1,r2);

    ang = acosd(prod_escalar);
    fprintf("Angulo: %f\n", ang);
    
    R = [r1 r2 r3];
    
    [U,S,V]=svd(R); 
    R = U * eye(3) * V';

    prod_R = R' * R;

end


function out=R2w(in)

 if numel(in)==9 % in = matriz Rotacion 3x3 --> out=w
   R = in;
   w=zeros(3,1); % Inicializo vector w 
   % Calcula vector de giro w equivalente a matriz R
   xyz = [R(3,2); R(1,3); R(2,1)] - [R(2,3);R(3,1);R(1,2)];
   r = norm(xyz);
   t = R(1,1) + R(2,2) + R(3,3);
   w = atan2d(r, t-1);

   w = w*[xyz(1)/r; xyz(2)/r; xyz(3)/r];
   
   out=w; 
 else      % in=w --> out = R (matriz rotacion)
   w=in;  
   R=zeros(3); % Inicializo matriz de rotación
   % Calcula matriz de rotacion R equivalente a vector w
   n = w/norm(w);
   w = norm(w);
   M1 = [0, -n(3), n(2); n(3), 0, -n(1); -n(2), n(1), 0];
   M2 = n*n';
   R = cosd(w)*eye(3) + sind(w) * M1 + (1-cosd(w)) * M2;
   out = R;  
 end    

end


function error=error_uv(P,X,Y,u,v)
    global aux;
    uu = zeros(1, 77); vv = zeros(1, 77);
    t=P(1:3); w=P(4:6); f=P(7); k1 = P(8); u0=P(9); v0=P(10);
    R = R2w(w);
    r1 = R(:, 1); r2 = R(:,2);
    Q = [r1 r2 t];

    %dims = size(aux);
    %u0 = 1/2*dims(2); v0 = 1/2*dims(1);
    
    cam = Q * [X; Y; ones(1, 77)];
    x = cam(1, :)./cam(3, :); 
    y = cam(2, :)./cam(3, :);
    
    r2 = x.^2 + y.^2;
    x = x.*(1+k1*r2);
    y = y.*(1+k1*r2);
    
    uu=u0+f*x; vv=v0+f*y;

    error = [(uu-u) (vv-v)]';
end







