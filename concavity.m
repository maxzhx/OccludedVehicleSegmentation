%车辆检测扫描
clear all
clc
close all
tic

f=imread('f2.png');
f=im2double(f);
% f=rgb2gray(f);
figure
imshow(f);

b=imread('b2.png');
b=im2double(b);
% b=rgb2gray(b);
figure
imshow(b);

%背景差分
% for i=1:m
%      for j= 1:n
%          f2(i,j)=abs(f(i,j)-b(i,j));
%      end
% end
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
         if(f2(i,j)<0.09)
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

%粘连检测

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

%粘连分割
%旋转
r=imrotate(l,-45,'nearest','crop');
figure
imshow(r);
se=strel('disk',10);
r=imdilate(r,se);
r=imerode(r,se);
figure
imshow(r);

%扫描
[m,n]=size(r);
e=edge(r,'canny');
j1=0;
j2=0;
fillArea=0;
count=1;
pointArray=zeros(2,4);
for i=1:m
    f1=0;
    f2=0;
    f3=0;
    j1=0;
    j2=0;
     for j= 1:n
         
         if(f1==0&&r(i,j)==1)
             f1=1;             
         end
         if(f2==0&&f1==1&&r(i,j)==0)
             if(fillArea==0)
                 t1=i;
                 t2=j;
             end
             j1=j;
             f2=1;
         end
         if(f3==0&&f2==1&&r(i,j)==1)
             j2=j;
             f3=1;
         end
         if(f3==1)%扫描到
             b1=i;
             b2=j;
             fillArea=fillArea+j2-j1;
             break;
         end
         if(j==n&&f3==0)%如果扫描到最后,说明没有连接部分
%              display(fillArea);
             if(fillArea>500)
                 display(fillArea);
                 pointArray(count,1)=b1;
                 pointArray(count,2)=b2;
                 pointArray(count,3)=t1;
                 pointArray(count,4)=t2;
                 count=count+1;
                 display(b1);display(b2);
                 display(t1);display(t2);
             end
             fillArea=0;
             break;
         end
     end
     %画出阴影区域
     if(j1~=0&&j2~=0)
        for k=j1:j2
                r(i,k)=0.5;
        end
     end
end
% display('dsd');

figure
imshow(r);
figure
imshow(r);
line([pointArray(1,2),pointArray(2,4)],[pointArray(1,1),pointArray(2,3)]);

% r(pointArray(1,1),pointArray(1,2))=0.1;
% r(pointArray(2,3),pointArray(2,4))=0.1;
% % f=zeros(1,1,1);
%  
% r=imrotate(r,45,'nearest','crop');
% [x,y]=find(r==0.1);
% figure
% imshow(r);
% line([x(2),y(2)],[x(1),y(1)]);

toc