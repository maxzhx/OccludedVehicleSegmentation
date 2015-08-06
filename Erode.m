%车辆检测扫描
clear all
clc
close all
tic

f=imread('f9.png');
f=im2double(f);
% f=rgb2gray(f);
figure
imshow(f);

b=imread('b9.png');
b=im2double(b);
% b=rgb2gray(b);
figure
imshow(b);

%背景差分

f2=imabsdiff(b,f);
f2=im2double(f2);
f2=rgb2gray(f2);
[m,n]=size(f2);

%中值滤波
f2=medfilt2(f2,[7,7]);
figure
imshow(f2);
%二值化
f3=f2;
for i=1:m
     for j= 1:n
%          if(f2(i,j)<0.05)
         if(f2(i,j)<0.07)
             f3(i,j)=0;
         else
             f3(i,j)=1;
         end
     end
end
%区域填充
% f3=bwmorph(f3,'close');
f3=imfill(f3);
figure
imshow(f3);

% f4=edge(f3,'canny');
% figure
% imshow(f4);

%区域统计
[l,num]=bwlabel(f3,8);
display(num);
p=zeros(num,1);
%找最大区域
for i=1:m
     for j= 1:n
         if(l(i,j)~=0)
              p(l(i,j),1)=p(l(i,j),1)+1;
         end
     end
end
[n1,m1]=find(p==max(p))

for i=1:m
     for j= 1:n
         if(l(i,j)==n1)
              l(i,j)=1;
         else
             l(i,j)=0;
         end
     end
end
figure
imshow(l);
o_l=l;

%--------------------------粘连检测1--------------------------------

areaV=p(n1,m1);
areaC=n*m;
display(areaV);
display(areaC);
Ra=areaV/areaC;
display(Ra);

% display(isOcclusive);
% display(n);
left=n;
right=1;
top=m;
buttom=1;
for i=1:m
     for j= 1:n
         if(l(i,j)==1)
             if(i<top)
                 top=i;
             end
             if(i>buttom)
                 buttom=i;
             end
             if(j>right)
                 right=j;
             end
             if(j<left)
                 left=j;
             end
         end
     end
end
% display(left);
% display(right);
% display(top);
% display(buttom);

width=right-left;
height=buttom-top;
Rwh=width/height;
display(Rwh);

if((Ra<0.65&&Rwh<0.5)||(Ra<0.65&&Rwh>0.75))
    display('存在粘连');
    isOcclusive=1;
else 
    display('不存在粘连');
    isOcclusive=0;
end

%-----------------------------粘连检测2-------------------------------
THarea=areaC*0.01;
% THarea=800;
display(THarea);
SE1=strel('disk',4);
while true 
    l=imerode(l,SE1);
    [r,num]=bwlabel(l,8);
    p=zeros(num,1);
    for i=1:m
         for j= 1:n
             if(r(i,j)~=0)
                  p(r(i,j),1)=p(r(i,j),1)+1;
             end
         end
    end
    [n1,m1]=find(p>THarea);
    
    areaNum=size(n1,1);
    if (areaNum>1)
        display('粘连');
        break;
    end
    if (areaNum<1)
        display('没有');
        break;
    end
end

% l1=imdilate(l);
display(areaNum);

figure
imshow(l);
%-----------------------------分割线查找-------------------------------
e1=edge(r,'canny');
figure
imshow(e1);
[e2,num]=bwlabel(e1,8);
[r1(:,1),r1(:,2)]=find(e2==1);
[r2(:,1),r2(:,2)]=find(e2==2);
[mA,nA] = size(r1);
[mB,nB] = size(r2);

for i = 1:mA
    for j = 1:mB
        D(i,j) = sqrt( sum((r1(i,:)-r2(j,:)).^2) ); %计算A与B各点距离
    end
end
minvalue= min(min(D)); %距离最小值
[minrow,mincol] = find(D==minvalue); %距离最小值的行列
p1=r1(minrow,:); %距离最小值的行对应的A中的点
p2=r2(mincol,:);  %距离最小值的行对应的B中的点
line([p1(1,2),p2(1,2)],[p1(1,1),p2(1,1)],'color','b','LINEWIDTH',3);
pm=[(p1+p2)/2];

temp_p1=[p1(1,1);p1(1,2);1];
rot=[0,-1,pm(1,1)+pm(1,2);1,0,pm(1,2)-pm(1,1);0,0,1];
r_p1=rot*temp_p1;

temp_p2=[p2(1,1);p2(1,2);1];
% rot=[0,-1,pm(1,1)+pm(1,2);1,0,pm(1,2)-pm(1,1);0,0,1];
r_p2=rot*temp_p2;
% temp_p1=[p1(1,1);p2(1,2);1];
% rot=[0,-1,pm(1,1)+pm(1,2);1,0,pm(1,2)-pm(1,1);0,0,1];
% r_p1=rot*temp_p1;
% r(round(pm(1,1)),round((pm(1,2))))=3;
% figure
% imshow(o_l);
line([p1(1,2),p2(1,2)],[p1(1,1),p2(1,1)],'color','b','LINEWIDTH',3);
line([r_p1(2,1),r_p2(2,1)],[r_p1(1,1),r_p2(1,1)],'color','r','LINEWIDTH',3);
% display(num);

a1(1)=r_p1(1,1);
a1(2)=r_p1(2,1);
a2(1)=r_p2(1,1);
a2(2)=r_p2(2,1);

% y=kx+b
k = (a1(2)-a2(2))/(a1(1)-a2(1));
b = a1(2) - k*a1(1);

line([b,m*k+b],[0,m],'color','y','LINEWIDTH',3);

figure
imshow(o_l);
line([b,m*k+b],[0,m],'color','y','LINEWIDTH',3);
figure
imshow(f);
line([b,m*k+b],[0,m],'color','y','LINEWIDTH',3);
toc