function decrypted = decrypt(encrypted,key)
% decrypt.m    decrypt image by improved chirikov map 
% decrypted = decrypt(encrypted,key) decrypt encrypted image with the certain key

x=key(1);y=key(2);k=key(3);h=key(4);
[cols,rows,chans] = size(encrypted); %图像尺寸，通道数

kk = 2 + exp( mod(h + 10 * sin(k) + k ,2*pi));
hh = 2 + exp( mod(h + 10 * sin(k) ,2*pi));
xx = mod(x + hh * sin(y) + kk * y ,2*pi);
yy = mod(x + hh * sin(y) ,2*pi); % 使参数在合适的范围内

bitArray = dec2bin(encrypted,8);  % 将整数转换成8位二进制数组
bitArray = [bitArray(:)]; % 展平

N = size(bitArray,1);

posX = zeros(1, 2*N); posY = zeros(1, 2*N); 
posX(1)=xx ; posY(1) = yy; % 位置数组初始化

for i = 1 : 2*N-1 % 生成置乱所需位置数组
    posY(i+1) = mod(posX(i) + kk * sin(posY(i)) ,2*pi);
    posX(i+1) = mod(posY(i+1) + hh * posX(i) ,2*pi);
end
posX = ceil(posX*N/(2*pi)); posY = ceil(posY*N/(2*pi)); %归一化并取整
posX = fliplr(posX); posY = fliplr(posY); % 翻转即取逆

for j = [posX ; posY] % 置乱
    tmp = bitArray(j(1));
    bitArray(j(1)) = bitArray(j(2));
    bitArray(j(2)) = tmp;
end

bitArray = reshape(bitArray,N/8,8); %还原成8位一组
Array = bin2dec(bitArray); %还原为整数
decrypted = uint8(reshape(Array,cols,rows,chans)); %还原形状
