function A=findcluster(vcom,n,ND)
%Find members in a community
A=[];
for i=1:ND
    if(ismember(n,vcom{i}))
        A=[A,i];
    end
end
end
