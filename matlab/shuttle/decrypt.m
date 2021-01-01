%
%  Copyright 2018-2021 Lu <miroox@outlook.com>
%
%  Licensed under the Apache License, Version 2.0 (the "License");
%  you may not use this file except in compliance with the License.
%  You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
%  Unless required by applicable law or agreed to in writing, software
%  distributed under the License is distributed on an "AS IS" BASIS,
%  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%  See the License for the specific language governing permissions and
%  limitations under the License.
%
% decrypt.m    decrypt image by improved chirikov map 
% decrypted = decrypt(encrypted,key) decrypt encrypted image with the certain key
function decrypted = decrypt(encrypted,key)

x=key(1);y=key(2);k=key(3);h=key(4);
[cols,rows,chans] = size(encrypted); %ͼ��ߴ磬ͨ����

kk = 2 + exp( mod(h + 10 * sin(k) + k ,2*pi));
hh = 2 + exp( mod(h + 10 * sin(k) ,2*pi));
xx = mod(x + hh * sin(y) + kk * y ,2*pi);
yy = mod(x + hh * sin(y) ,2*pi); % ʹ�����ں��ʵķ�Χ��

bitArray = dec2bin(encrypted,8);  % ������ת����8λ����������
bitArray = [bitArray(:)]; % չƽ

N = size(bitArray,1);

posX = zeros(1, 2*N); posY = zeros(1, 2*N); 
posX(1)=xx ; posY(1) = yy; % λ�������ʼ��

for i = 1 : 2*N-1 % ������������λ������
    posY(i+1) = mod(posX(i) + kk * sin(posY(i)) ,2*pi);
    posX(i+1) = mod(posY(i+1) + hh * posX(i) ,2*pi);
end
posX = ceil(posX*N/(2*pi)); posY = ceil(posY*N/(2*pi)); %��һ����ȡ��
posX = fliplr(posX); posY = fliplr(posY); % ��ת��ȡ��

for j = [posX ; posY] % ����
    tmp = bitArray(j(1));
    bitArray(j(1)) = bitArray(j(2));
    bitArray(j(2)) = tmp;
end

bitArray = reshape(bitArray,N/8,8); %��ԭ��8λһ��
Array = bin2dec(bitArray); %��ԭΪ����
decrypted = uint8(reshape(Array,cols,rows,chans)); %��ԭ��״
