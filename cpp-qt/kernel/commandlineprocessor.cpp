/**
 ** Copyright 2018-2020 Lu <miroox@outlook.com>
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
#include "ichirikov/bitxor.h"
#include "ichirikov/shuttle.h"
#include <cstdlib>
#include <ctime>
#include <random>
#include <QString>
#include <QStringList>
#include <QFileInfo>
#include <QFile>
#include <QSaveFile>
#include <QImage>
#include <QFlags>
#include <QDataStream>
#include <QtDebug>
#include <QLoggingCategory>

#ifdef __has_include
#   if __has_include(<optional>)
#       include<optional>
using std::optional;
#   elif  __has_include(<experimental/optional>)
#       include <experimental/optional>
using std::experimental::optional;
#   else
#       error "Missing <optional>"
#   endif
#endif

enum Method
{
    Encrypt = 0b00u,
    Decrypt = 0b01u,
    BitXor  = 0b10u,
    Shuttle = 0b00u,
};
Q_DECLARE_FLAGS(Methods, Method)
Q_DECLARE_OPERATORS_FOR_FLAGS(Methods)

static IChirikov::Key readKeyFromFile(const QString& fileName);
static void writeKeyToFile(const IChirikov::Key& key, QSaveFile* file);
static IChirikov::Key randomGenerateKey();
static QImage processImage(const QImage& input, Methods method, const IChirikov::Key& key);

CommandLineProcessor::CommandLineProcessor(QObject *parent)
    : QObject(parent),
      helpOpt(parser.addHelpOption()),
      versionOpt(parser.addVersionOption()),
      decryptOpt({"d","decrypt"},"Decrypt the image rather than encrypt it"),
      outputOpt({"o","output"},"Processed image","output file"),
      bitxorOpt({"x","bitxor"},"Use bitxor method instead of shuttle method to encrypt/decrypt the image"),
      keyOpt("key","Specify the key to encrypt/decrypt image","key file"),
      autoKeyOpt("auto-key","Automatically generate key in image encryption","key file")
{
    parser.setApplicationDescription("Encrypt or decrypt image with improved chirikov map "
                                     "(by default, encrypt the image in-place).");
    parser.addPositionalArgument("input file","Image to process","[file]");
    Q_ASSUME(parser.addOptions({decryptOpt,outputOpt,bitxorOpt,keyOpt,autoKeyOpt}));
}

void CommandLineProcessor::process(const QStringList &args)
{
    if (!parser.parse(args))
    {
        qCritical(qUtf8Printable(parser.errorText()));
        parser.showHelp(EXIT_FAILURE);
    }

    if (parser.isSet(helpOpt))
    {
        if (parser.optionNames().length() > 1)
            qWarning("Too many arguments!");
        parser.showHelp();
    }
    if (parser.isSet(versionOpt))
    {
        if (parser.optionNames().length() > 1)
            qWarning("Too many arguments!");
        parser.showVersion();
    }

    // getMethod
    Methods method = Shuttle|Encrypt;
    if (parser.isSet(decryptOpt))
    {
        method |= Decrypt;
    }
    if (parser.isSet(bitxorOpt))
    {
        method |= BitXor;
    }

    IChirikov::Key key = getKey();
    QImage input = readInputImage();
    writeOutputImage(processImage(input,method,key));

    emit processed();
}

IChirikov::Key CommandLineProcessor::getKey()
{
    optional<IChirikov::Key> key;
    if (parser.isSet(keyOpt)) // key
    {
        if (key)
        {
            qWarning("%s: The key already exists.",qUtf8Printable(keyOpt.names().first()));
            return key.value();
        }
        QString fileName = parser.value(keyOpt);
        if (fileName.isEmpty())
        {
            qFatal("%s: Need a key file.",qUtf8Printable(keyOpt.names().first()));
        }
        key = readKeyFromFile(fileName);
    }
    if (parser.isSet(autoKeyOpt)) // auto-key
    {
        if (key)
        {
            qWarning("%s: The key already exists.",qUtf8Printable(autoKeyOpt.names().first()));
            return key.value();
        }
        if (parser.isSet(decryptOpt))
        {
            qFatal("Image decryption key must be specified");
        }
        QString fileName = parser.value(autoKeyOpt);
        if (fileName.isEmpty())
        {
            qFatal("%s: Need a key file.",qUtf8Printable(autoKeyOpt.names().first()));
        }
        key = randomGenerateKey();

        QSaveFile* keyFile = new QSaveFile(fileName,this);
        connect(this,&CommandLineProcessor::processed,
                [keyFile]{
            if (!keyFile->commit())
                qFatal("Writing key file failed.");
        });
        writeKeyToFile(key.value(),keyFile);
    }
    if (!key)
    {
        qFatal("Need a key for encryption or decryption.");
    }
    return key.value();
}

QImage CommandLineProcessor::readInputImage()
{
    QImage image;
    QStringList args = parser.positionalArguments();
    if (args.isEmpty())
    {
        qFatal("Need an input file.");
    }
    if (args.size() != 1)
    {
        qWarning("Only one of the input images will be pocessed.");
    }
    if (!image.load(args.first()))
    {
        qFatal("Cannot load image from %s",qUtf8Printable(args.first()));
    }
    return image;
}

void CommandLineProcessor::writeOutputImage(const QImage& output)
{
    bool isWrited = false;
    if (parser.isSet(outputOpt))
    {
        QString fileName = parser.value(outputOpt);
        if (fileName.isEmpty())
        {
            qFatal("Need an output file.");
        }
        QSaveFile* outputFile = new QSaveFile(fileName,this);
        connect(this,&CommandLineProcessor::processed,
                [outputFile]{
            if (!outputFile->commit())
                qFatal("Writing output file failed.");
        });
        if (!outputFile->open(QIODevice::WriteOnly))
        {
            qFatal(qUtf8Printable(outputFile->errorString()));
        }
        if (!output.save(outputFile,qPrintable(QFileInfo(fileName).suffix())))
        {
            qFatal("Failed to save the image to %s",qUtf8Printable(fileName));
        }
        isWrited = true;
    }
    if (!isWrited)
    {
        qFatal("No way to output the processed image.");
    }
}

IChirikov::Key readKeyFromFile(const QString& fileName)
{
    IChirikov::Key key;
    QFile file(fileName);
    if (!file.exists())
    {
        qFatal("Key file %s doesnot exist!",qUtf8Printable(fileName));
    }
    if (!file.open(QIODevice::ReadOnly))
    {
        qFatal(qUtf8Printable(file.errorString()));
    }
    QDataStream data(&file);
    data >> key;
    switch (data.status())
    {
    case QDataStream::Ok:
        break;
    case QDataStream::ReadPastEnd:
        qFatal("Unexpected file end.");
        break;
    case QDataStream::ReadCorruptData:
        qFatal("Read corrupt data.");
        break;
    default:
        Q_UNREACHABLE();
    }
    return key;
}

void writeKeyToFile(const IChirikov::Key& key, QSaveFile* file)
{
    Q_ASSUME(!file->isOpen());
    if (!file->open(QIODevice::WriteOnly))
    {
        qFatal(qUtf8Printable(file->errorString()));
    }
    QDataStream data(file);
    data << key;
    switch (data.status())
    {
    case QDataStream::Ok:
        break;
    case QDataStream::WriteFailed:
        qFatal("Cannot write key.");
        break;
    default:
        Q_UNREACHABLE();
    }
}

struct RandomSeedGen
{
    using result_type = std::mt19937::result_type;

    RandomSeedGen()
    {
        std::srand(std::time(0));
    }

    result_type operator()()
    {
        result_type seed;
        std::random_device rd;
        if (rd.entropy() == 0.0)
        {
            seed = std::rand();
        }
        else
        {
            seed = rd();
        }
        return seed;
    }
};

IChirikov::Key randomGenerateKey()
{
    static constexpr qreal Pi = 3.14159265358979323846;
    static RandomSeedGen seed;
    std::mt19937 gen(seed());
    std::lognormal_distribution<qreal> d1(1.6, 1);
    std::normal_distribution<qreal> d2(Pi,Pi/3);
    IChirikov::Key key;
    key.k = d1(gen);
    key.h = 1. + d1(gen);
    key.x = d2(gen);
    key.y = d2(gen);
    return key;
}

QImage processImage(const QImage& input, Methods method, const IChirikov::Key& key)
{
    using namespace IChirikov;
    QImage output;
    switch (method)
    {
    case Method::Shuttle|Encrypt:
        output = Shuttle::encrypt(input,key);
        break;
    case Method::Shuttle|Decrypt:
        output = Shuttle::decrypt(input,key);
        break;
    case Method::BitXor|Encrypt:
        output = BitXor::encrypt(input,key);
        break;
    case Method::BitXor|Decrypt:
        output = BitXor::decrypt(input,key);
        break;
    default:
        Q_UNREACHABLE();
    }
    return output;
}
