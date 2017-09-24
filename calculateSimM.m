function  [dist,mdistance] = calculateSimM(xx,ND,N1,t,a)
%Generate adjacent matrix correspond to the edgelist
dist=zeros(ND);
mdistance=zeros(ND);

%For undirected graph
for i=1:N1
    mdistance(xx(i,1),xx(i,2))=xx(i,3);
    mdistance(xx(i,2),xx(i,1))=xx(i,3);
end

%Degree of each node
k=sum(mdistance,2);

%Initialize
vsimilarity=mdistance;
n=a;
if n>0
    %Calculate sab
    for j=1:n
        vsimilarity=vsimilarity+1/2*vsimilarity*vsimilarity;
        %No distance between node itself
        for i=1:ND
            vsimilarity(i,i)=0;
        end
    end
end

%Calculate relative strength
simi=sum(vsimilarity,2);
Simi=sqrt(simi*simi');

aa=t;
bb=1-aa;
dist=vsimilarity*aa*(1/mean(vsimilarity(:)))+bb*ND*vsimilarity./Simi;
%0/0=Nan
dist(isnan(dist))=0;
%Calculate the inverse, get the distance matrix
%dist=1./(dist+eps);
dist=1./dist;
for i=1:ND
   dist(i,i)=0;
end
end