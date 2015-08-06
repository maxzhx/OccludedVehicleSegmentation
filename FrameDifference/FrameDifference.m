clc;
clear;
close;

targetavi='traffic.avi';
mov=VideoReader(targetavi);
fnum=mov.NumberOfFrames;
%%%%%%%%%%%%%%%%%%%%%%帧间差分法
t=40; %%阈值，此值可以调节
t=t/256;%%转化为double型数据
for i=1:fnum
    x=read(mov,i-1);
    figure(1);
    imshow(x);
    y=read(mov,i);  
    figure(2);
    imshow(y);
    m=rgb2gray(x);
    m=medfilt2(m);
    n=rgb2gray(y);
    n=medfilt2(n);
    q=im2double(n);
    w=im2double(m);    
    c=q-w;%%差分            
    k=find(abs(c)>=t);%%find函数作用是找到图c中的值大于t的点坐标    
    c(k)=255;%%二值化的一    
    k=find(abs(c)<t);
    c(k)=0;%%二值化的零  
    figure(3);
    imshow(c);
%     [L,n]=bwlabel(c,8); % 区域标记
%     stats = regionprops(L); % 区域属性  
%     hold on
%     for j=1:n
%         rect=stats(j).BoundingBox;
%         rectangle('Position', rect, 'EdgeColor', 'r');
%     end
end
