clc;clear;
I=imread('Lena.jpg');
I=I(1:2:end,1:2:end,1:3); %zoom out
[eI,key]=encrypt(I);
dI=decrypt(eI,key);
subplot(2,2,1);imshow(I);title('origin image');
subplot(2,2,2);imshow(eI);title('encrypted image');
subplot(2,2,3);imshow(dI);title('decrypted image');