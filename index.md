---
title: "基于改进的Chirikov映射的彩色图像加密算法"
description: "基于改进的Chirikov映射的彩色图像加密算法"
---

{% assign resource_url = "https://github.com/miRoox/image-encryption-with-improved-Chirikov-map/raw/master/resource" %}

这是学校创新研修课程项目报告。

项目源码见 [GitHub](https://github.com/miRoox/image-encryption-with-improved-Chirikov-map)

----

# 基于改进的Chirikov映射的彩色图像加密算法

**摘要**：
基于改进的Chirikov映射来实现一种彩色图像加密的算法。
该方法通过在Chirikov映射中增加一个参数来增加算法的随机性。
采用像素数据置乱的方法实现图像加密。
并进行了一些数值仿真来验证加密方案的性能。

----

*关键词：图像加密；混沌映射；数据安全*

## 1.引言

随着网络的普及，数据的流通越来越方便，数据安全形势也变得越来越严峻。
计算机技术的发展也得使数据（例如文本、图像）加密变得简单。
密码编码学和密码分析学应运而生，成为了两个相互对立又相互促进的学科。
图像加密的方法有多种，其中一类是数字加密技术，另一类是光学加密技术。
数字加密技术一般是基于伪随机数，通过逻辑运算或者代数运算得到随机数据。
数字图像加密技术又分空间置乱和像素变换技术。

## 2.研究方法

空间置乱技术通过改变像素的空间位置，将原始图像变成一个杂乱无序、不可见的新图像。
基于置乱技术的图像加密技术一般可以认为是对图像矩阵进行有限步长的初等矩阵转换，
以此打乱图像像素的排列位置，达到图像加密的目的。
像素变换技术则改变图像灰度值的大小，重新生成一幅图像。
通常采用伪随机数对原图像进行逻辑运算以获得加密图像。
混沌映射是产生伪随机数的方法之一，因其对初值和参数具有高度的敏感性，不易破解，适用于各种加密场合，
常用的映射有Logistic映射。本文采用了改进后的Chirikov映射作为随机数的来源，并综合应用了置乱的技术。

### 2.1 Chirikov变换及其改进

Chirikov标准映射表达式为：

![Chrikov map]({{resource_url}}/chirikov.png)

包含有一个 _k_ 参数.

| ![k=0.5]({{resource_url}}/k=0.5.png) <br/> _k_=0.5 | ![k=1.2]({{resource_url}}/k=1.2.png) <br/> _k_=1.2 |
| ![k=4.5]({{resource_url}}/k=4.5.png) <br/> _k_=4.5 | ![k=6.5]({{resource_url}}/k=6.5.png) <br/> _k_=6.5 |
| ![k=8.2]({{resource_url}}/k=8.2.png) <br/> _k_=8.2 | ![k=10]({{resource_url}}/k=10.png) <br/> _k_=10    |

**不同参数 _k_ 对应的映射的迭代轨迹**

----

从映射图像可以看出，只有当 _k_ 的大小超过某一阈值后，映射才会变得混沌，均匀充满整个相空间。
为此，我们在其中添加了一个参数 _h_ ，增加了混沌映射输入参数的任意性。
改进后的Chirikov映射表达式：

![improved Chrikov map]({{resource_url}}/improved-chirikov.png)

包含了 _k_ 和 _h_ 两个参数.

| | ![h=1,k=2]({{resource_url}}/h=1,k=2.png) <br/> _h_=1 _k_=2 |
| ![h=1.5,k=0.5]({{resource_url}}/h=1.5,k=0.5.png) <br/> _h_=1.5 _k_=0.5 | ![h=1.5,k=2]({{resource_url}}/h=1.5,k=2.png) <br/> _h_=1.5 _k_=2 |
| ![h=2,k=0.5]({{resource_url}}/h=2,k=0.5.png) <br/> _h_=2 _k_=0.5 | ![h=2,k=0.5]({{resource_url}}/h=2,k=0.5.png) <br/> _h_=2 _k_=0.5 |
| ![h=2,k=1]({{resource_url}}/h=2,k=1.png) <br/> _h_=2 _k_=1 | ![h=2,k=1]({{resource_url}}/h=2,k=1.png) <br/> _h_=2 _k_=1 |
| ![h=3.5,k=1]({{resource_url}}/h=3.5,k=1.png) <br/> _h_=3.5 _k_=1 | ![h=3.5,k=2]({{resource_url}}/h=3.5,k=2.png) <br/> _h_=3.5 _k_=2 |

**不同 _h_、_k_ 参数对应的映射的迭代轨迹**

----

### 2.2 用于图像加密基本算法

将改进的Chirikov映射用于彩色图像加密的大致流程：

①读入图片与密钥；

②将密钥代表的参数映射到合适的范围内；

③读取图片的像素数据成一个\[行,列,RGB\]的三维数组，并将每个R或G或B值转换成8位的bit array，然后将其展平为长度为 _N_ 的一维数组；

④用第②步生成的参数，使用改进的Chirikov映射生成一个充分长的序对 (_x_,_y_) 列表并线性地扩充为 *N*×*N* 的整型序对列表；

⑤对第③步生成的一维数组进行置乱，使用上一步生成的序对列表中的 _x_ 和 _y_ 作为需要交换的数据的位置依次置换；

⑥从上一步置换完的数据中重新还原成图片。

解密流程和加密流程基本一致，只是在上述第③步后对整个数组进行反向排序。

下面是上述流程中进行一维数组置乱部分的Mathematica代码：

```mathematica
(*shuffle list with improved chirikov map*)
(*parameters: k, h, x, y, source-data*)
encryptShuffle=Compile[{ {k,_Real},{h,_Real},{x,_Real},{y,_Real},{source,_Integer,1} },
Block[{data,pos},data=source;
    pos=(NestList[ (*nest to generate a list of the position need to shuttle*)
             Mod[#[[2]]+k Sin[#[[1]]]+{h #[[1]],0},2. Pi]&, (*improved Chirikov map*)
             {x,y},2*Length[data]
        ]*Length[data]/(2 Pi)) (*normalize*)
            //Ceiling (*take integer part*);
    Scan[(data[[#]]=data[[Reverse@#]])&,pos,1]; (*shuffle data*)
    data] (*return value: shuffled data*)
];
```

## 3.数值模拟

| 原图像 | 加密图像 | 解密图像 |
|:------:|:--------:|:--------:|
| ![origin]({{resource_url}}/origin.png) | ![encrypted]({{resource_url}}/encrypted.png) | ![decrypted]({{resource_url}}/origin.png) |

| ![histogram]({{resource_url}}/histogram.png) |
|=====
| **原图像素和加密像素分布直方图** |

由直方图可以看出，加密算法将图片的像素分布均匀化，有效的增加了原图像素的熵值。
基本排除通过加密图像就能看出原图像的大概轮廓的可能性。

但对于常见的有损压缩（如JEPG），由于其会截去图像的高频分量，因而会导致加密图像损失大量信息，导致无法还原出原图像。

### 安全性测试

| 保持其它参数不变，改变 _h_ | 保持其它参数不变，改变 _k_ |
|:--------------------------:|:--------------------------:|
| ![MSE-h]({{resource_url}}/mse-h.png) | ![MSE-k]({{resource_url}}/mse-k.png) |

MSE(means square error)为均方误差，表征原始图像与解密图像的差异。MSE=0时表示两图像相等。
由上图可知，密钥参数取值范围进入到一个很小的区间（ 10 <sup>-15</sup> 数量级）时，才有可能将图片解密出来。
这能有效防止对加密图像使用枚举遍历进行破解。

### 遮挡攻击测试

| 被遮挡的加密图像 | 对应的解密图像 |
|:----------------:|:--------------:|
| ![25cover-encrypted]({{resource_url}}/25cover-encrypted.png) | ![25cover-decrypted]({{resource_url}}/25cover-decrypted.png) |
| ![50cover-encrypted]({{resource_url}}/50cover-encrypted.png) | ![50cover-decrypted]({{resource_url}}/50cover-decrypted.png) |

上表显示对应对加密图像不同遮挡面积的还原效果。
遮挡方法是用绘图工具在加密图像上填充了一个多边形。
当遮挡面积约为原图的25%时，解密图像与原图像间的MSE=0.039，视觉效果上仍能清楚分辨出与原图的形状、色彩信息。
当遮挡面积约为原图的50%时，解密图像与原图像间的MSE=0.154，此时只能勉强看到原图的轮廓，色彩信息已不可辩。

## 4.结论

我们基于Chirikov映射的改进算法设计了一种彩色图像加密方法，并对加密解密结果进行了安全性测试和鲁棒性测试，具有良好的加密效果。
本方法的主要不足是未提出有效方法解决因压缩图像中数据丢失产生的解密失真问题，图像只能以无损格式储存。

## 参考文献

\[1] Mimoun Hamdi, Rhouma Rhouma, Safya Belghith, A Selective Compression-Encryption Of Images Based On SPIHT Coding and Chirikov Standard MAP, Signal Processing, <http://dx.doi.org/10.1016/j.sigpro.2016.09.011> 

\[2] Yushu Zhang, Di Xiao, Double optical image encryption using discrete Chirikov standard map and chaos-based fractional random transform, Optics and Lasers in Engineering, <http://dx.doi.org/10.1016/j.optlaseng.2012.11.001> 

