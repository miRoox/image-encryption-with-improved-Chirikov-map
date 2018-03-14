function [encrypted,key] = encrypt(image,key)
% encrypt.m    encrypt image by improved chirikov map 
% [encrypted,key] = encrypt(image,key) encrypt image with the certain key
% [encrypted,key] = encrypt(image) encrypt image with a random key

if nargin==1
    key = 10*rand(1,4); %���������Կ
end

x=key(1);y=key(2);k=key(3);h=key(4);
[cols,rows,chans] = size(image); %ͼ��ߴ磬ͨ����

kk = 2 + exp( mod(h + 10 * sin(k) + k ,2*pi));
hh = 2 + exp( mod(h + 10 * sin(k) ,2*pi));
xx = mod(x + hh * sin(y) + kk * y ,2*pi);
yy = mod(x + hh * sin(y) ,2*pi); % ʹ�����ں��ʵķ�Χ��

bitArray = dec2bin(image,8);  % ������ת����8λ����������
bitArray = [bitArray(:)]; % չƽ

N = size(bitArray,1);

posX = zeros(1, 2*N); posY = zeros(1, 2*N); 
posX(1)=xx ; posY(1) = yy; % λ�������ʼ��

for i = 1 : 2*N-1 % ������������λ������
    posY(i+1) = mod(posX(i) + kk * sin(posY(i)) ,2*pi);
    posX(i+1) = mod(posY(i+1) + hh * posX(i) ,2*pi);
end
posX = ceil(posX*N/(2*pi)); posY = ceil(posY*N/(2*pi)); %��һ����ȡ��

for j = [posX ; posY] % ����
    tmp = bitArray(j(1));
    bitArray(j(1)) = bitArray(j(2));
    bitArray(j(2)) = tmp;
end

bitArray = reshape(bitArray,N/8,8); %��ԭ��8λһ��
Array = bin2dec(bitArray); %��ԭΪ����
encrypted = uint8(reshape(Array,cols,rows,chans)); %��ԭ��״