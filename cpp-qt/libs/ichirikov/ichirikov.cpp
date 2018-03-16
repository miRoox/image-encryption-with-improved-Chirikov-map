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
#include <limits>

namespace IChirikov {

using ::std::tie;
using ::std::abs;

using Pos = ::std::tuple<qreal,qreal>;

static constexpr qreal Pi = 3.14159265358979323846;

static inline auto iChirikov(qreal k, qreal h)
{
    using ::std::fmod;
    Q_ASSUME(k>0);
    Q_ASSUME(h>1);
    return [k,h](qreal x0, qreal y0)->Pos{
        qreal x, y;
        x = fmod(k*sin(y0)+x0,2*Pi);
        y = fmod(h*y0+x,2*Pi);
        return ::std::make_tuple(x,y);
    };
}

namespace BitXor {

QImage encrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    QImage encrypted(img);
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
    return encrypted;
}

QImage decrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    return encrypt(img,k,h,x,y);
}

} //BitXor

namespace Shuttle {

QImage encrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    QImage encrypted(img);
    Q_UNUSED(k);
    Q_UNUSED(h);
    Q_UNUSED(x);
    Q_UNUSED(y);
    return encrypted;
}

QImage decrypt(const QImage& img, qreal k, qreal h, qreal x, qreal y)
{
    QImage decrypted(img);
    Q_UNUSED(k);
    Q_UNUSED(h);
    Q_UNUSED(x);
    Q_UNUSED(y);
    return decrypted;
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
