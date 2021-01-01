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
% e.g
% encrypt(rgb2gray(imread('')),6,6,8);
%
% 读入原始图像I或加密图像J，必须是灰度图像则返回加密图像或原始图像灰度矩阵；
% x,y为映射初值，k为一个参数,且k应大于8左右.
function [J]=encrypt(I,x0,y0,k0)

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
