/**
 ** Copyright 2018 Lu <miroox@outlook.com>
 **
 ** Licensed under the Apache License, Version 2.0 (the "License");
 ** you may not use this file except in compliance with the License.
 ** You may obtain a copy of the License at
 **
 **     http://www.apache.org/licenses/LICENSE-2.0
 **
 ** Unless required by applicable law or agreed to in writing, software
 ** distributed under the License is distributed on an "AS IS" BASIS,
 ** WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 ** See the License for the specific language governing permissions and
 ** limitations under the License.
 **/


#include "bitxor.h"
#include "shuttle.h"
#include <functional>
#include <utility>
#include <cmath>
#include <climits>
#include <limits>
#include <algorithm>
#include <QDataStream>

namespace IChirikov {

using ::std::tie;
using ::std::abs;

using Pos = ::std::tuple<qreal,qreal>;

static constexpr qreal Pi = 3.14159265358979323846;

static inline qreal mod(qreal x, qreal y)
{
    return ::std::fmod(::std::fabs(x),::std::fabs(y));
}

static inline auto iChirikov(qreal k, qreal h)
{
    Q_ASSUME(k>0);
    Q_ASSUME(h>1);
    return [k,h](qreal x0, qreal y0)->Pos{
        qreal x, y;
        x = mod(k*sin(y0)+x0,2*Pi);
        y = mod(h*y0+x,2*Pi);
        return ::std::make_tuple(x,y);
    };
}

static QImage convertToNoUnusedBitImage(const QImage& img)
{
    switch (img.format())
    {
    case QImage::Format_Mono:
    case QImage::Format_MonoLSB:
        return img.convertToFormat(QImage::Format_Grayscale8);
    case QImage::Format_Indexed8:
        if (img.colorCount() != 0x100)
        {
            return img.convertToFormat(QImage::Format_RGB888);
        }
        break;
    case QImage::Format_RGB32:
    case QImage::Format_RGB666:
    case QImage::Format_RGB555:
    case QImage::Format_RGB444:
    case QImage::Format_RGBX8888:
    case QImage::Format_BGR30:
    case QImage::Format_RGB30:
        return img.convertToFormat(QImage::Format_RGB888);
    case QImage::Format_ARGB8555_Premultiplied:
        return img.convertToFormat(QImage::Format_ARGB32);
    default:
        break;
    }
    return img;
}

static QImage recoverImageFormat(const QImage& img, QImage::Format format)
{
    switch (format)
    {
    case QImage::Format_Mono:
    case QImage::Format_MonoLSB:
        return img;
    case QImage::Format_Indexed8:
        if (img.format() != QImage::Format_Indexed8)
        {
            qWarning("Cannot recover to the original image format.");
            return img;
        }
        break;
    default:
        break;
    }
    return img.convertToFormat(format);
}

namespace BitXor {

QImage encrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    QImage encrypted = convertToNoUnusedBitImage(img);
    const auto byteCount = encrypted.sizeInBytes();
    constexpr uchar max = ::std::numeric_limits<uchar>::max();
    uchar* data = encrypted.bits();
    k = abs(k);
    h = abs(h-1)+1;
    auto map = iChirikov(k,h);
    qreal x0, y0;
    for(int i=0; i<byteCount; ++i)
    {
        x0=x; y0=y;
        tie(x,y) = map(x0,y0);
        data[i] ^= static_cast<uchar>(max*x0/(2*Pi));
    }
    return recoverImageFormat(encrypted,img.format());
}

QImage decrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    return encrypt(img,k,h,x,y);
}

} //BitXor

namespace Shuttle {

static inline bool testBit(uchar byte, ::std::size_t pos)
{
    Q_ASSUME(pos<CHAR_BIT);
    return byte & (1<<pos);
}

static inline void setBit(uchar& byte, ::std::size_t pos, bool set)
{
    Q_ASSUME(pos<CHAR_BIT);
    if (set)
        byte |= (1<<pos);
    else
        byte &= ~(1<<pos);
}

static inline bool testBit(const uchar* data, ::std::size_t pos)
{
    static_assert(CHAR_BIT==8,"Number of bits in byte should be 8");
    return testBit(data[pos>>3],pos&0b111);
}

static inline void setBit(uchar* data, ::std::size_t pos, bool set)
{
    static_assert(CHAR_BIT==8,"Number of bits in byte should be 8");
    return setBit(data[pos>>3],pos&0b111,set);
}

static inline void bitSwap(uchar* data, ::std::size_t pos1, ::std::size_t pos2)
{
    if (pos1 == pos2)
        return;
    bool tmp = testBit(data,pos1);
    setBit(data,pos1,testBit(data,pos2));
    setBit(data,pos2,tmp);
}

QImage encrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    QImage encrypted = convertToNoUnusedBitImage(img);
    const auto bitCount = CHAR_BIT*encrypted.sizeInBytes();
    uchar* data = encrypted.bits();
    k = abs(k);
    h = abs(h-1)+1;
    auto map = iChirikov(k,h);
    qreal x0, y0;
    for(int i=0; i<2*bitCount; ++i)
    {
        x0=x; y0=y;
        tie(x,y) = map(x0,y0);
        bitSwap(data,x0/(2*Pi)*bitCount,y0/(2*Pi)*bitCount);
    }
    return recoverImageFormat(encrypted,img.format());
}

QImage decrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    QImage decrypted = convertToNoUnusedBitImage(img);
    const auto bitCount = CHAR_BIT*decrypted.sizeInBytes();
    k = abs(k);
    h = abs(h-1)+1;
    auto map = iChirikov(k,h);
    qreal x0, y0;
    QVector<Pos> toSwap;
    toSwap.reserve(2*bitCount);
    for(int i=0; i<2*bitCount; ++i)
    {
        x0=x; y0=y;
        tie(x,y) = map(x0,y0);
        toSwap.append(::std::make_tuple(x0,y0));
    }
    uchar* data = decrypted.bits();
    ::std::for_each(toSwap.crbegin(),toSwap.crend(),[data,bitCount](const Pos& pos){
        qreal x, y;
        tie(x,y) = pos;
        bitSwap(data,x/(2*Pi)*bitCount,y/(2*Pi)*bitCount);
    });
    return recoverImageFormat(decrypted,img.format());
}

} //Shuttle

constexpr quint32 KeyMask = 0xFFCBC5D9u;

QDataStream& operator<<(QDataStream& stream, const Key& key)
{
    return stream << KeyMask << key.k << key.h << key.x << key.y;
}

QDataStream& operator>>(QDataStream& stream, Key& key)
{
    quint32 mask;
    stream >> mask;
    if (mask != KeyMask)
    {
        stream.setStatus(QDataStream::ReadCorruptData);
        return stream;
    }
    stream >> key.k >> key.h >> key.x >> key.y;
    if (key.k <= 0 || key.h < 1)
    {
        stream.setStatus(QDataStream::ReadCorruptData);
    }
    return stream;
}

} //IChirikov
