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
clc;clear;
I=imread('Lena.jpg');
I=I(1:2:end,1:2:end,1:3); %zoom out
[eI,key]=encrypt(I);
dI=decrypt(eI,key);
subplot(2,2,1);imshow(I);title('origin image');
subplot(2,2,2);imshow(eI);title('encrypted image');
subplot(2,2,3);imshow(dI);title('decrypted image');