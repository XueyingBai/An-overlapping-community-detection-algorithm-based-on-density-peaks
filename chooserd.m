function [rhomin,deltamin,new_delta,new_rho]=chooserd(rho,ordrho,delta,ND,nneigh)
%%%%%regularity,new rho and delta, select cores for step 1%%%%%%%
% regularity of rho
maxr=max(rho);
new_rho=(rho/maxr);
% regularity of delta
new_delta=zeros(1,ND);
% calculate dc
sda=sort(delta(delta~=Inf));
% sda=sort(delta(delta~=1/eps));
realN=length(sda); 
percent=80;%the importance of rho and delta can be distinguished by the percent(dc)
position=round(realN*percent/100);
dc=sda(position);
%end calculation of dc

for i=ordrho
    if delta(i)~=Inf
          new_delta(i)=exp(-(dc/delta(i))*(dc/delta(i)));
    else
        new_delta(i)=Inf;
    end
end
%regularization of the new_delta
 new_delta=(new_delta/max(new_delta(new_delta~=Inf)));
 
%%%%%%%%%%%%%%%%%%%%%%
disp('Generated file:DECISION GRAPH')
disp('column 1:Density')
disp('column 2:Delta')

disp('Select a rectangle enclosing cluster centers')
scrsz = get(0,'ScreenSize');
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);

subplot(2,1,1)
tt=plot(new_rho(:),new_delta(:),'w.','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
hold on;
title ('Decision Graph','FontSize',15.0)
xlabel ('\rho*')
ylabel ('\delta*')

subplot(2,1,1)
rect = getrect(1);%Get a rectangle area
% rect is a four-element vector with the form [xmin ymin width height].
rhomin=rect(1);%get a min new_rho and min new_delta
deltamin=rect(2);
close all;
end