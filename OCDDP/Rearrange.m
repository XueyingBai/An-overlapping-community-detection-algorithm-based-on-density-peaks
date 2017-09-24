function [class,NCLUST] = Rearrange(core,ordrho,ND,N_Neigh,dist)
NCLUST=length(core);
class=zeros(ND,NCLUST);
for i=1:NCLUST
    class(core(i),i)=1;
end

[~,orddist]=sort(dist(ordrho(1),core),'ascend');
if(~ismember(ordrho(1),core))
        neighbours=core(orddist);
        dneighbours=1./dist(ordrho(1),neighbours);
        sumd=sum(dneighbours);
        dweights=dneighbours/sumd;
        class(ordrho(1),:)=dweights*class(neighbours',:);
end
 
for i=2:ND
    if((i-1)>N_Neigh
        n_end=N_Neigh;
    else
        n_end=i-1;
    end
     
    if(~ismember(ordrho(i),core))
        neighbours=ordrho(1:i-1);         
        [~,orddist]=sort(dist(ordrho(i),neighbours),'ascend');
        new_neighbours=neighbours(orddist(1:n_end));
        dneighbours=1./dist(ordrho(i),new_neighbours);
        sumd=sum(dneighbours);
        dweights=dneighbours/sumd;
        class(ordrho(i),:)=dweights*class(new_neighbours',:);
    end
end
end
