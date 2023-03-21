function fc_quiver(du,dv,S)
if nargin==2, S=1; end
% Pintar malla + errores como flechas

%figure;hold off
for k=1:11
  plot([k k],[0.5 7.5],'b'); hold on;  
end
for k=1:7
  plot([0.5 11.5],[k k],'b'); hold on;    
end

esc=40/S;
%dd=sqrt(du.^2+dv.^2); s=mean(dd);
du=flipud(reshape(du/esc,11,7)'); 
dv=-flipud(reshape(dv/esc,11,7)');
%quiver(du,dv,(s/20)*S,'r','LineWidth',2)
quiver(du,dv,0,'r','LineWidth',2)
hold off
xlim([0 12]); ylim([0 8])

return