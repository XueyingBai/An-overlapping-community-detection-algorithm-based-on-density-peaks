clear all
close all
disp('The only input needed is a distance matrix file')
disp('The format of this file should be: ')
disp('Column 1: id of element i')
disp('Column 2: id of element j')
disp('Column 3: weight(i,j)')
%Read the edgelist
medge=input('name of the distance matrix file (with single quotes)?\n');
fid=fopen(medge,'rt');
if (fid==-1)
    disp('Error opening!');
    pause;
end
    
disp('Reading input edgelist')
xx=load(medge);
ND=max(xx(:,2));
NL=max(xx(:,1));
%search for the largest vertex number
if (NL>ND)
  ND=NL;
end
N1=size(xx,1);
%Set weight to edges in weighted graph
% if (size(xx(1,:),2)<3)
%     xx(:,3)=ones(N1,1);
% end
%Although there's an extension of weighted network, the reported best result of
%netscience are from unweighted setting.
xx(:,3)=ones(N1,1);

t=input('Input t in eq(6):\n');
a=input('Input n in eq(6):\n');
%Calculate the distance matrix
[dist,mdistance] = calculateSimM(xx,ND,N1,t,a);

%Calculate dc. N is the number of edges in the network
distlist=tril(dist);
distlist=distlist(distlist~=0);
distlist=distlist(distlist~=Inf);
%distlist=distlist(distlist~=1/eps);
N=length(distlist);
%Set the radius as at the position of top 2% smallest distances in the distlist
percent=2.0;
fprintf('average percentage of neighbours (hard coded): %5.6f\n', percent);

%round(X) rounds the elements of X to the nearest integers.
%choose the approximation of dc
position=round(N*percent/100);
sda=sort(distlist);
dc=sda(position);
fprintf('Computing Rho with gaussian kernel of radius: %12.6f\n', dc);

%Initialization of local densities
rho=zeros(1,ND);
% Gaussian kernel
% Calculate the local densities
for i=1:ND-1
  for j=i+1:ND
     rho(i)=rho(i)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
     rho(j)=rho(j)+exp(-(dist(i,j)/dc)*(dist(i,j)/dc));
  end
end

%Calculate the number of isolated nodes
isonumber=0;
for i=1:ND
    line=dist(i,:);
    if length(line(line~=Inf))==1
        isonumber=isonumber+1;
    end
end
%Calculate delta
% for i=1:ND
%     dist(i,i)=0;
% end
maxd=max(max(dist));
%rho_sorted is the sorted vector, ordrho is the position of elements that in
%rho_sorted in origonal vector.
[rho_sorted,ordrho]=sort(rho,'descend');%Descending order of rho
delta(ordrho(1))=-1.;%set a minimum of delta
%record the neighbour
nneigh(ordrho(1))=0;
for ii=2:ND %ii is the ii(th) largest rho
% If the point is an isolated point,rho=0,nneigh=0
   delta(ordrho(ii))=maxd;
   for jj=1:ii-1 %Traverse nodes whose rho is larger than ii.
     if(dist(ordrho(ii),ordrho(jj))<delta(ordrho(ii)))%If have shorter distance
        delta(ordrho(ii))=dist(ordrho(ii),ordrho(jj));%change the value of delta
        nneigh(ordrho(ii))=ordrho(jj);%modify neighbor
     end
   end
end
delta(ordrho(1))=max(dist(ordrho(1),:));

%First select nodes with high rho and delta as a core
[rhomin,deltamin,new_delta,new_rho]=chooserd(rho,ordrho,delta,ND,nneigh);
% NCLUST represents the amount of clusters
N_Neigh=5;
[class,NCLUST,icl,coren3] = classify_overlap(ordrho,rho,rhomin,deltamin,ND,N_Neigh,dist,new_delta,new_rho,delta);
%%%%%%%%%sign the cluster core
% plot(new_rho(:),new_delta(:),'w.','MarkerSize',5,'MarkerFaceColor','k','MarkerEdgeColor','k');
% k=icl;
% text(new_rho(k),new_delta(k),{k});
%%%%%%%%%%%%%%%%%
corenum=NCLUST;
fprintf('NUMBER OF CLUSTERS: %i \n', NCLUST);

sigma=0.9;
[vcom,comnum] = vertexcom(class,sigma,ND,NCLUST);
%Exclude isolated-node community, optional
icl2=icl;
[vcom2,maxi,icl2] = CoreRearrange(vcom,ND,icl2,ordrho,N_Neigh,dist,sigma,comnum,isonumber);
%The community output is also in function calculateEQ
%[modularity,com,belong,operate]=calculateEQ(vcom,N1,ND,xx,corenum)
% modularity