clc;
clear;
close;

targetavi='traffic.avi';
mov=VideoReader(targetavi);
fnum=mov.NumberOfFrames;
%%%%%%%%%%%%%%%%%%%%%%֡���ַ�
t=40; %%��ֵ����ֵ���Ե���
t=t/256;%%ת��Ϊdouble������
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
    c=q-w;%%���            
    k=find(abs(c)>=t);%%find�����������ҵ�ͼc�е�ֵ����t�ĵ�����    
    c(k)=255;%%��ֵ����һ    
    k=find(abs(c)<t);
    c(k)=0;%%��ֵ������  
    figure(3);
    imshow(c);
%     [L,n]=bwlabel(c,8); % ������
%     stats = regionprops(L); % ��������  
%     hold on
%     for j=1:n
%         rect=stats(j).BoundingBox;
%         rectangle('Position', rect, 'EdgeColor', 'r');
%     end
end
