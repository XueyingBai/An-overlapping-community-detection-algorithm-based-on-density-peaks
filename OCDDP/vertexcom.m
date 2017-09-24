function [vcom,comnum] = vertexcom(class,sigma,ND,NCLUST)
comnum=zeros(1,NCLUST);
vcom=cell(0);
vcomcell=[];
%Search for max possibility
for i=1:ND
    vcomcell=[];
    possibility=class(i,:);
    maxp=max(possibility);
    %Compare with others
    for j=1:NCLUST
        if(possibility(j)/maxp>=sigma)
            vcomcell=union(vcomcell,j);
            comnum(j)=comnum(j)+1;
        end
    end
    vcom{i}=vcomcell;
end
end
