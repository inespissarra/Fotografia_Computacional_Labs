function fc_pinta_im(im0,name)
  warning('off','images:initSize:adjustingMag');
  figure; set(gcf,'Name',name);  
  
  im0=uint8(im0*255);
  image(im0); colormap(gray(256)); 
  %fc_truesize;
  truesize; axis off;
  set(gca,'Pos',[0.0 0.0 1 1]); % Ejes cubriendo fig
  %if ndims(im0)<3, colormap(gray(256)); end
    
  p=get(gca,'Pos');
  A=0.15; ejes=axes('Pos',[p(1)+p(3)-1.04*A p(2)+p(4)-1.05*A A A]);
  fc_imhist(im0);

  % Centrar figura
  pos_f = get(gcf,'Pos'); dim_fig = pos_f(3:4);
  screen=get(0,'ScreenSize'); screen=screen(3:4);
  pos_f(1) = (screen(1)-dim_fig(1)  )/2;
  pos_f(2) = (screen(2)-dim_fig(2)-50  )/2;
  set(gcf,'Pos',[pos_f(1:2) dim_fig]);
end


function [h x]=fc_imhist(im,N)

if nargin==1, N=256; end

is_uint8=strcmp(class(im),'uint8'); % Check if input is uint8 class

if is_uint8, 
    x=(0:N-1)*255/(N-1); im=double(im);
else
    MM=max(max(im(:,:,1)));
    x=MM*(0:N-1)/(N-1); 
end

np=size(im,3);
h=zeros(N,np);

col='rgb';
if np==1,
  h = histc(im(:),x); 
  stem(x,h,'k','Marker','none'); 
  set(gca,'Ytick',[],'XColor',[1 1 1],'Xtick',(0:64:256));  
else 
  for k=1:3,
    h=histc(reshape(im(:,:,k),1,size(im,1)*size(im,2)),x);      
    stem(x+(k-1)/3,h,col(k),'Marker','none'); hold on;     
  end    
end 
   
   % stem(x+0.33,h(:,2),'g','Marker','none');
   % stem(x+0.67,h(:,3),'b','Marker','none');
    hold off
    set(gca,'Ytick',[],'XColor',[1 1 1],'Xtick',(0:64:256),...
            'Xticklabel',{'0','0.25','0.5','0.75','1'});
%end 
%end    
  
  set(gca,'Xlim',[x(1)-5 x(end)+5]);

end

function fc_truesize

% Control de que existe figura, ejes, imagen
fig=findobj('type','figure'); if isempty(fig), return; end; 
fig=gcf; %fig(1); 

eje=findobj(fig,'type','axes'); if isempty(eje), return; end;
set(eje,'Units','Norm');

h_im = findobj(eje,'type','image');
if isempty(h_im), return; end


dim_im=[size(get(h_im,'Cdata'),2) size(get(h_im,'Cdata'),1)];
pos_f = get(gcf,'Pos'); dim_fig = pos_f(3:4);

set(gca,'Pos',[0.0 0.0 1 1]); % Ejes cubriendo fig
pos_eje=get(gca,'Pos'); 
dim_eje=pos_eje(3:4).*dim_fig;

factor = dim_im./dim_eje;
new_dim_fig = round(dim_fig.*factor);

%qq=get(eje,'Pos');qq=qq(3:4).*

% Falta control de imagen muy grande.
screen=get(0,'ScreenSize'); screen=screen(3:4);

ratio=(new_dim_fig./screen);
M=max(ratio)+0.10;

if M>1,
   K = floor(20/M)/20;
   new_dim_fig =  new_dim_fig*K;
   fprintf('WARNING: Screen size %d x %d. Imagen reducida al %.0f%%\n',screen,K*100);
end    

% Centrar figura

pos_f(1) = (screen(1)-new_dim_fig(1)  )/2;
pos_f(2) = (screen(2)-new_dim_fig(2)-50  )/2;
set(gcf,'Pos',[pos_f(1:2) new_dim_fig]);

% Borrar tras prueba
%set(gcf,'Pos',[600 60 1650 1100]);

%set(gca,'Units','Pixels'); get(gca,'Pos'); set(gca,'Units','Norm');

end





















