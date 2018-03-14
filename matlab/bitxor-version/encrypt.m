function [J]=encrypt(I,x0,y0,k0)
% e.g
% encrypt(rgb2gray(imread('')),6,6,8);
%
% 读入原始图像I或加密图像J，必须是灰度图像则返回加密图像或原始图像灰度矩阵；
% x,y为映射初值，k为一个参数,且k应大于8左右.
[m,l]=size(I);
i=m*l;
x=zeros(1,i);
y=zeros(1,i);
x(1)=x0;y(1)=y0;k=k0;

for n=1:i-1;
    x(n+1)=mod(x(n)+k*sin(y(n)),2*pi);
    y(n+1)=mod(y(n)+x(n+1),2*pi);
end

x1=uint8(255*x/2/pi);  %归一化
p=reshape(x1,m,l);     % key
J=bitxor(I,p);    %逻辑异或加密\解密
