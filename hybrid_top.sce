clc;
clear;

//load narval
exec("loader.sce",-1);

b=8;r=8;s=9;N=b+r+s;

G=graph(); 

x=zeros(1,N);y=zeros(1,N);nc=zeros(N,3);

//bus nodes
for i=1:b
 x(i)=i;y(i)=0;nc(i,:)=[1 0 0];addnode(G,"n"+string(i),x(i),y(i));
end

//ring nodes
rs=b+1;re=b+r;
theta=linspace(0,2*%pi,r+1);theta($)=[];
for i=1:r
 idx=rs+i-1;x(idx)=5+cos(theta(i));y(idx)=4+sin(theta(i));nc(idx,:)=[0 1 0];addnode(G,"n"+string(idx),x(idx),y(idx));
end

//star nodes
sc=re+1;x(sc)=11;y(sc)=0;nc(sc,:)=[0 0 1];addnode(G,"n"+string(sc),x(sc),y(sc));
for i=sc+1:N
 x(i)=11+cos(i);y(i)=sin(i);nc(i,:)=[0 0 1];addnode(G,"n"+string(i),x(i),y(i));
end

//edges
A=zeros(N,N);
for i=1:b-1;A(i,i+1)=1;A(i+1,i)=1;end
for i=rs:re-1;A(i,i+1)=1;A(i+1,i)=1;end
A(rs,re)=1;A(re,rs)=1;
for i=sc+1:N;A(sc,i)=1;A(i,sc)=1;end
A(b,rs)=1;A(rs,b)=1;A(re,sc)=1;A(sc,re)=1;

//add edges to graph
ec=zeros(N,N,3);en=1;
for i=1:N
 for j=i+1:N
  if A(i,j)==1 then
   addedge(G,"e"+string(en),"n"+string(i),"n"+string(j));
   ec(i,j,:)=[0 0 1];ec(j,i,:)=[0 0 1];
   en=en+1;
  end
 end
end

//draw
draw(G,"nodeColor",nc,"edgeColor",ec,"showNodeLabel",%T,"showEdgeLabel",%T);

//degree calc
deg=sum(A,"r");
disp("Node degrees:");
for i=1:N
 disp("Node "+string(i)+" has "+string(deg(i))+" edges");
end
[mx,node]=max(deg);
disp("Node with maximum edges: Node "+string(node));
disp("Total nodes = "+string(N));
disp("Total edges = "+string(sum(A)/2));
