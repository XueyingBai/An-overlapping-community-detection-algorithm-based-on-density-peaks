function [modularity,com,belong,operate]=calculateEQ(vcom,N1,ND,xx,corenum)
%N1 is the number of edges
%ND is the number of nodes
single=0;
belong=zeros(ND,1);
com=zeros(ND,ND);
%unweighted adjacent matrix
mdistance=zeros(ND,ND);
%undirected weighted graph
for i=1:N1
    mdistance(xx(i,1),xx(i,2))=xx(i,3);
    mdistance(xx(i,2),xx(i,1))=xx(i,3);
end
%Number of communities to which a node belongs, file storage
num=corenum;
name=input('location and name of the output file (with single quotes):\n');
fid=fopen(name,'w');
for i=1:num
    vec=findcluster(vcom,i,ND);
    if length(vec)~=1
        fprintf(fid,'%d ',vec);
        fprintf(fid,'\n');
    end
    com(vec,vec)=com(vec,vec)+1;
    if length(vec)==1
        single=single+1;
        %isolated(single)=vec;
    end
end
fprintf('NUMBER OF SINGLE-NODE CLUSTERS: %i \n', single);

%degree of nodes
k=sum(mdistance,2);
%degree matrix
K=k*k';
%Unweighted setting
%N2=N1;
%Extension of weighted EQ
N2=sum(xx(:,3)); 
minus=K/(2*N2);

%Number of communities a node belongs to
for i=1:ND
    belong(i)=com(i,i);
end
%Belonging matrix
Belong=belong*belong';
com=com./Belong;

operate=(mdistance-minus).*com;
for i=1:ND-1
    for j=i:ND
        if isnan(operate(i,j))==1
            operate(i,j)=0;
            operate(j,i)=0;
        end
    end
end
modularity=sum(sum(operate))/(2*N2);
end
