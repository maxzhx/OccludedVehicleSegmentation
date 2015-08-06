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

%--------------------------粘连检测--------------------------------

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
display(width);
display(height);
Rwh=width/height;
display(Rwh);

if((Ra<0.65&&Rwh<0.5)||(Ra<0.65&&Rwh>0.75))
    display('存在粘连');
    isOcclusive=1;
else 
    display('不存在粘连');
    isOcclusive=0;
end

toc