function [class,NCLUST,icl,coren3] = classify_overlap(ordrho,rho,rhomin,deltamin,ND,N_Neigh,dist,new_delta,new_rho,delta)
number=0;
NCLUST=0;
coren=[];
gamma=zeros(1,ND);

for i=1:ND
    %Get the cores from step 1
    if ((new_rho(i)>rhomin) && (new_delta(i)>deltamin))&&delta(i)~=Inf
        coren=[coren,i];
    elseif(delta(i)==Inf)%isolated or far far away nodes, themselves are clusters
        coren=[coren,i];
    else %overlapping community,calculate gamma(new_delta(i)~=Inf) for step 2
        gamma(i)=new_delta(i)*new_rho(i);  
    end
end

%choose gamma
[sortgam]=sort(gamma,'ascend');
[coren2] = chooseg(gamma,sortgam,ND);
coren=[coren,coren2];
%Exclude some nodes(step 3)
%Select final cores
coren3=[];
for k=coren
    [a_sorted,orda]=sort(dist(k,:),'ascend');
    n_len=length(find(a_sorted~=Inf))-1;
    if n_len>5
        n_len=5;
    end
    ave=sum(rho(orda(2:(n_len+1))))/n_len;
      if rho(k)>=ave||n_len<1
         coren3=[coren3,k];
         number=number+1;
         NCLUST=NCLUST+1;
         icl(NCLUST)=k;
     end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('NUMBER OF CORE CLUSTERS: %i \n', number);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Allocation of other nodes' belongings
class=zeros(ND,NCLUST);%class is the probability vectors of nodes
% icl
%for cores
for i=1:NCLUST
    class(icl(i),i)=1;
end
%The node with max rho 
[~,orddist]=sort(dist(ordrho(1),icl),'ascend');
if(~ismember(ordrho(1),icl))
        neighbours=icl(orddist);%Neighbors need to be considered
        dneighbours=1./dist(ordrho(1),neighbours);
        sumd=sum(dneighbours);
        %Weight
        dweights=dneighbours/sumd;
        %Probability vector
        class(ordrho(1),:)=dweights*class(neighbours',:);
end
%For other nodes
for i=2:ND
% i=3;
    if((i-1)>N_Neigh)%N_neib limitation
        n_end=N_Neigh;
    else
        n_end=i-1;
    end

    if(~ismember(ordrho(i),icl))
        neighbours=ordrho(1:i-1);%Neighbors to be considered
        %Sort by ascending distances
        [~,orddist]=sort(dist(ordrho(i),neighbours),'ascend');
        %Selected neighbors
        new_neighbours=neighbours(orddist(1:n_end));
        dneighbours=1./dist(ordrho(i),new_neighbours);
        sumd=sum(dneighbours);
        %Weight
        dweights=dneighbours/sumd;
        %Probability Vector
        class(ordrho(i),:)=dweights*class(new_neighbours',:);
    end
end