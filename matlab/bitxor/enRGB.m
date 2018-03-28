%
%  Copyright 2018 Lu <miroox@outlook.com>
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
% 输入RGB图像I，将之分解为三个矩阵分别加\解密,然后合成彩色图像
function [TH]=enRGB(RGB,x,y,k)
% I=imread('pears.png');
R=encrypt(RGB(:,:,1),x,y,k);
G=encrypt(RGB(:,:,2),x,y,k);
B=encrypt(RGB(:,:,3),x,y,k);
TH=cat(3,R,G,B);
%subplot(2,2,1);imshow(R);title('R');
%subplot(2,2,2);imshow(G);title('G');
%subplot(2,2,3);imshow(B);title('B');
%subplot(2,2,4);
imshow(TH);