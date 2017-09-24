function [coren] = chooseg(gamma,sortgam,ND)
disp('Select a rectangle enclosing cluster centers');
scrsz = get(0,'ScreenSize');
figure('Position',[6 72 scrsz(3)/4. scrsz(4)/1.3]);
subplot(2,1,1)
tt=plot(1:ND,sortgam,'w.','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%tt=plot(1:ND,gamma,'w.','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
%Only show the part
%tt=plot(round(0.9*ND):ND,sortgam(round(0.9*ND):ND),'w.','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
title ('Decision Graph for Gamma','FontSize',15.0)
xlabel ('number')
ylabel ('\gamma')
subplot(2,1,1)
rect = getrect(1);
% rect is a four-element vector with the form [xmin ymin width height].
gammamin=rect(2);
% core selected
coren=[];
number=0;
for i=1:ND
    if gamma(i)>gammamin&&gamma(i)~=Inf
        number=number+1;
        coren(number)=i;
    elseif gamma(i)==Inf
            number=number+1;
            coren(number)=i;
    end
end
fprintf('NUMBER OF CORE CLUSTERS SELECTED BY GAMMA: %i \n', number);
close all;
end
