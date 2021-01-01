/**
 ** Copyright 2018-2021 Lu <miroox@outlook.com>
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


#pragma once

#include <QtGlobal>

#if defined(ICHIRIKOV_LIBRARY)
#  define ICHIRIKOV_EXPORT Q_DECL_EXPORT
#else
#  define ICHIRIKOV_EXPORT Q_DECL_IMPORT
#endif

namespace IChirikov {

struct ICHIRIKOV_EXPORT Key
{
    qreal k, h, x, y;
};

ICHIRIKOV_EXPORT QDataStream& operator<<(QDataStream& stream, const Key& key);
ICHIRIKOV_EXPORT QDataStream& operator>>(QDataStream& stream, Key& key);

}

