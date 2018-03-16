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


#include "commandlineprocessor.h"
#include <QCoreApplication>
#include <QString>
#include <QMutex>
#include <QMutexLocker>
#include <QtDebug>
#include <cstdio>

void messageOutput(QtMsgType type, const QMessageLogContext& context, const QString& msg);

int main(int argc, char* argv[])
{
    qSetMessagePattern("%{if-debug}Debug: %{endif}"
                       "%{if-warning}Warning: %{endif}"
                       "%{if-critical}Critical: %{endif}"
                       "%{if-fatal}Fatal: %{endif}"
                       "%{if-category}<%{category}>: %{endif}"
#ifdef QT_DEBUG
                       "[%{time yyyyMMdd h:mm:ss.zzz}] "
#endif
                       "%{if-debug}%{file}:%{line}{%{function}}: %{endif}"
                       "%{message}");
    qInstallMessageHandler(messageOutput);

    QCoreApplication app(argc,argv);
    app.setApplicationVersion(VERSION_STR);
    app.setApplicationName(APP_FULL_NAME);

    CommandLineProcessor processor;
    processor.process(app.arguments());

    return EXIT_SUCCESS;
}

static QMutex messageMutex;

void messageOutput(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    QMutexLocker locker(&messageMutex);
    QString format = qFormatLogMessage(type,context,msg);
    std::fputs(qUtf8Printable(format),stderr);
    std::fputc('\n',stderr);
    std::fflush(stderr);
    if (type == QtFatalMsg)
    {
        locker.unlock();
        std::exit(EXIT_FAILURE);
    }
}
