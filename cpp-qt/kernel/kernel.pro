include(../universal.pri)

TEMPLATE = app
TARGET = ichirikov
DESTDIR = $$BIN_PATH

LIBS *= \
    -l$$qtLibraryName(IChirikov)

SOURCES += main.cpp \
    commandlineprocessor.cpp


HEADERS += \
    commandlineprocessor.h
