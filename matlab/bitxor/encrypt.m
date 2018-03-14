function [J]=encrypt(I,x0,y0,k0)
% e.g
% encrypt(rgb2gray(imread('')),6,6,8);
%
% ����ԭʼͼ��I�����ͼ��J�������ǻҶ�ͼ���򷵻ؼ���ͼ���ԭʼͼ��ҶȾ���
% x,yΪӳ���ֵ��kΪһ������,��kӦ����8����.
[m,l]=size(I);
i=m*l;
x=zeros(1,i);
y=zeros(1,i);
x(1)=x0;y(1)=y0;k=k0;

for n=1:i-1;
    x(n+1)=mod(x(n)+k*sin(y(n)),2*pi);
    y(n+1)=mod(y(n)+x(n+1),2*pi);
end

x1=uint8(255*x/2/pi);  %��һ��
p=reshape(x1,m,l);     % key
J=bitxor(I,p);    %�߼�������\����
