function [TH]=enRGB(RGB,x,y,k)
% I=imread('pears.png');
% ����RGBͼ��I����֮�ֽ�Ϊ��������ֱ��\����,Ȼ��ϳɲ�ɫͼ��
R=encrypt(RGB(:,:,1),x,y,k);
G=encrypt(RGB(:,:,2),x,y,k);
B=encrypt(RGB(:,:,3),x,y,k);
TH=cat(3,R,G,B);
%subplot(2,2,1);imshow(R);title('R');
%subplot(2,2,2);imshow(G);title('G');
%subplot(2,2,3);imshow(B);title('B');
%subplot(2,2,4);
imshow(TH);