function [vcom2,maxi,icl] = CoreRearrange(vcom,ND,icl,ordrho,N_Neigh,dist,sigma,comnum,isonumber)
NCLUST=length(icl);
rearrange=0;
vcom2=vcom;
loca=find(comnum==1);
% If rearrangement is needed
if length(loca)>isonumber
    rearrange=1;
end
icl(loca)=[];
while rearrange==1
    core=icl;
    rearrange=0;
    [class2,NCLUST] = Rearrange(core,ordrho,ND,N_Neigh,dist);
    [vcom2,comnum2] = vertexcom(class2,sigma,ND,NCLUST);
    loca=find(comnum2==1);
    if length(loca)>=1
        rearrange=1;
    end
    icl(loca)=[];
end
maxi=NCLUST;
end
