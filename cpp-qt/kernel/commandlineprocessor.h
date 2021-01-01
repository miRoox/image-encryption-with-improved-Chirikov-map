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

#include <QObject>
#include <QCommandLineParser>
#include <QCommandLineOption>
#include "ichirikov/ichirikov_global.h"

class QStringList;
class QImage;

class CommandLineProcessor : public QObject
{
    Q_OBJECT
public:
    explicit CommandLineProcessor(QObject *parent = nullptr);

signals:
    void processed();

public slots:
    void process(const QStringList& args);

private:
    IChirikov::Key getKey();
    QImage readInputImage();
    void writeOutputImage(const QImage& output);

private:
    QCommandLineParser parser;

    QCommandLineOption helpOpt;
    QCommandLineOption versionOpt;
    QCommandLineOption decryptOpt;
    QCommandLineOption outputOpt;
    QCommandLineOption bitxorOpt;
    QCommandLineOption keyOpt;
    QCommandLineOption autoKeyOpt;

};

