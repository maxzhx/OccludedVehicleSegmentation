%�������ɨ��
clear all
clc
close all
tic

f=imread('f5.png');
f=im2double(f);
% f=rgb2gray(f);
figure
imshow(f);

b=imread('b5.png');
b=im2double(b);
% b=rgb2gray(b);
figure
imshow(b);

%�������

f2=imabsdiff(b,f);
f2=im2double(f2);
f2=rgb2gray(f2);
[m,n]=size(f2);

%��ֵ�˲�
f2=medfilt2(f2,[7,7]);
figure
imshow(f2);
%��ֵ��
f3=f2;
for i=1:m
     for j= 1:n
         if(f2(i,j)<0.06)
             f3(i,j)=0;
         else
             f3(i,j)=1;
         end
     end
end
%�������
% f3=bwmorph(f3,'close');
f3=imfill(f3);
figure
imshow(f3);

% f4=edge(f3,'canny');
% figure
% imshow(f4);

%����ͳ��
[l,num]=bwlabel(f3,8);
display(num);
p=zeros(num,1);
%���������
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

%--------------------------ճ�����--------------------------------

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
    display('����ճ��');
    isOcclusive=1;
else 
    display('������ճ��');
    isOcclusive=0;
end

%-----------------------------ճ������-------------------------------
bw=l;

se=strel('disk',3);
bw=imdilate(bw,se);
bw=imdilate(bw,se);
% bw=imdilate(bw,se);
bw=imerode(bw,se,'same');
% bw=imerode(bw,se,'same');
bw=imerode(bw,se,'same');

% h=fspecial('gaussian',3,2);
% bw=filter2(h,bw);
% figure 
% imshow(bw); 


figure 
imshow(bw);

imwrite(bw,'output.png');


%-------------------Harris�ǵ���-----------------------
%---------------------ʱ���Ż�--����������ȡ��ķ���-----------------------
clc,clear;
harris_result=[];

%----����ͼ��������Ϣ����ȡͼ��-----
FileInfo=imfinfo('output.png');
Image=imread('output.png');

%-----ת��Ϊ�Ҷ�ֵͼ��---------
if(strcmp('truecolor',FileInfo.ColorType)==1)
    Image=im2uint8(rgb2gray(Image));
end

%------------------����ͼ��ķ�����------------------
%-----����Prewitt���ģ��
dx=[-1 0 1;
    -1 0 1;
    -1 0 1];
Ix2=filter2(dx,Image).^2;
Iy2=filter2(dx',Image).^2;
Ixy=filter2(dx,Image).*filter2(dx',Image);
%--------------------����ֲ�����ؾ���----------------
%----����9*9�ĸ�˹���ڣ�����Խ��̽�⵽�Ľǵ�Խ�٣�
h=fspecial('gaussian',5,2);

A=filter2(h,Ix2);
B=filter2(h,Iy2);
C=filter2(h,Ixy);

%---------------����Corner���������ѡ�ǵ�λ��------------
nrow=size(Image,1);
ncol=size(Image,2);
Corner=zeros(nrow,ncol);

%-----------------������ɸѡ------ʱ���Ż�------------
%-----����t����(i,j)������ġ����ƶȲ����������ĵ������������˸��������ֵ֮����
%------------(-t,+t)֮�䣬��ȷ������Ϊ���Ƶ�
t=20;
boundary=8; %---ȥ���߽���boundary������
for i=boundary:1:nrow-boundary+1
    for j=boundary:1:ncol-boundary+1
        nlike=0; %----���Ƶ�ĸ���
        if Image(i-1,j-1)-Image(i,j)>-t&&Image(i-1,j-1)-Image(i,j)<t
            nlike=nlike+1;
        end
        if Image(i-1,j)-Image(i,j)>-t&&Image(i-1,j)-Image(i,j)<t
            nlike=nlike+1;
        end
        
        if Image(i-1,j+1)-Image(i,j)>-t&&Image(i-1,j+1)-Image(i,j)<t
            nlike=nlike+1;
        end
        
        if Image(i,j-1)-Image(i,j)>-t&&Image(i,j-1)-Image(i,j)<t
            nlike=nlike+1;
        end
        
        if Image(i,j+1)-Image(i,j)>-t&&Image(i,j+1)-Image(i,j)<t
            nlike=nlike+1;
        end
        
        if Image(i+1,j-1)-Image(i,j)>-t&&Image(i+1,j-1)-Image(i,j)<t
            nlike=nlike+1;
        end
        
        if Image(i+1,j)-Image(i,j)>-t&&Image(i+1,j)-Image(i,j)<t
            nlike=nlike+1;
        end
        if Image(i+1,j+1)-Image(i,j)>-t&&Image(i+1,j+1)-Image(i,j)<t
            nlike=nlike+1;
        end
        
        if nlike>=2&&nlike<=6
            Corner(i,j)=1;
        end
        
    end
end

%-----------����ǵ���Ӧ����ֵ---corness = det(u) - k*trace(u)^2-------
CRF=zeros(nrow,ncol);
CRFmax=0;   %----ͼ���нǵ���Ӧ���������ֵ������ֵ��
k=0.05;
for i=boundary:1:nrow-boundary+1
    for j=boundary:1:ncol-boundary+1
        if Corner(i,j)==1
            M=[A(i,j) C(i,j);
                C(i,j) B(i,j)];
            CRF(i,j)=det(M)-k*(trace(M))^2;
            if CRF(i,j)>CRFmax
                CRFmax=CRF(i,j);
            end
        end
    end
end
%--------�ж���ǰλ���Ƿ�Ϊ�ǵ�------------
count=0;%----�ǵ����
t=0.01;

for i=boundary:1:nrow-boundary+1
    for j=boundary:1:ncol-boundary+1
        if Corner(i,j)==1
            if CRF(i,j)>t*CRFmax&&CRF(i,j)>CRF(i-1,j-1)...
                    &&CRF(i,j)>CRF(i-1,j)&&CRF(i,j)>CRF(i-1,j+1)...
                    &&CRF(i,j)>CRF(i,j-1)&&CRF(i,j)>CRF(i,j+1)...
                    &&CRF(i,j)>CRF(i+1,j-1)&&CRF(i,j)>CRF(i+1,j)...
                    &&CRF(i,j)>CRF(i+1,j+1)
                count=count+1;
            else
                Corner(i,j)=0;
            end
        end
    end
end


figure,imshow(Image);
hold on;
for i=boundary:1:nrow-boundary+1
    for j=boundary:1:ncol-boundary+1
        column_ave=0;
        row_ave=0;
        k=0;
        if Corner(i,j)==1
            for x=i-3:1:i+3
                for y=j-3:1:j+3
                    if Corner(x,y)==1
                        row_ave=row_ave+x;
                        column_ave=column_ave+y;
                        k=k+1;
                    end
                end
            end
        end
        if k>0
            harris_result=[harris_result;round(row_ave/k) round(column_ave/k)];
            plot(column_ave/k,row_ave/k,'b.');
        end
    end
end
% figure
% imshow(Corner);
X = harris_result;
opts = statset('Display','final');

%����Kmeans����
%X N*P�����ݾ���
%Idx N*1������,�洢����ÿ����ľ�����
%Ctrs K*P�ľ���,�洢����K����������λ��
%SumD 1*K�ĺ�����,�洢����������е���������ĵ����֮��
%D N*K�ľ��󣬴洢����ÿ�������������ĵľ���;
sizeX=size(X);
nc=[X(1) X(1,2);X(ceil(sizeX(1)/2)) X(ceil(sizeX(1)/2),2);X(sizeX(1)) X(sizeX(1),2)];

[Idx,Ctrs,SumD,D] = kmeans(X,3,'dist','sqEuclidean','Start',nc);

%��������Ϊ1�ĵ㡣X(Idx==1,1),Ϊ��һ��������ĵ�һ�����ꣻX(Idx==1,2)Ϊ�ڶ���������ĵڶ�������
% figure
hold on
plot(X(Idx==1,2),X(Idx==1,1),'r.','MarkerSize',14)
hold on
plot(X(Idx==2,2),X(Idx==2,1),'b.','MarkerSize',14)
hold on
plot(X(Idx==3,2),X(Idx==3,1),'g.','MarkerSize',14)

%����������ĵ�,kx��ʾ��Բ��
plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)
plot(Ctrs(:,1),Ctrs(:,2),'kx','MarkerSize',14,'LineWidth',4)

%ȡ���ҶԳ���
sym1=mean(X(Idx==1,2));
sym2=mean(X(Idx==3,2));





plot(sym1,200,'r.','MarkerSize',14)
plot(sym2,500,'g.','MarkerSize',14)
% plot(mean(X(Idx==2,2)),300,'b.','MarkerSize',14)

a1=X(Idx==1|Idx==2,1);
a2=X(Idx==1|Idx==2,2);
hold on
plot(a2(a2>sym1),a1(a2>sym1),'y.','MarkerSize',14)
plot(sym1*2-a2(a2>sym1),a1(a2>sym1),'y.','MarkerSize',14)

b1=[a2(a2>sym1);sym1*2-a2(a2>sym1)];
b2=[a1(a2>sym1);a1(a2>sym1)];

a3=X(Idx==2|Idx==3,1);
a4=X(Idx==2|Idx==3,2);
hold on
plot(a4(a4<sym2),a3(a4<sym2),'m.','MarkerSize',14)
plot(sym2*2-a4(a4<sym2),a3(a4<sym2),'m.','MarkerSize',14)

b3=[a4(a4<sym2);sym2*2-a4(a4<sym2)];
b4=[a3(a4<sym2);a3(a4<sym2)];


[rectx,recty,area,perimeter] = minboundrect(b1,b2,'a');
line(rectx(:),recty(:),'color','y');
[rectx,recty,area,perimeter] = minboundrect(b3,b4,'a');
line(rectx(:),recty(:),'color','m');
legend('Cluster 1','Cluster 2','Cluster 3','Centroids','Location','NW')

toc