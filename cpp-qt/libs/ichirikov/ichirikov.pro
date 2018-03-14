DEFINES += ICHIRIKOV_LIBRARY

TARGET = IChirikov

include(../../universal.pri)

DESTDIR = $$LIBRARY_PATH

TARGET = $$qtLibraryTarget($$TARGET)

TEMPLATE = lib
CONFIG += shared dll

HEADERS += ichirikov_global.h \
    bitxor.h \
    shuttle.h


SOURCES += \
    ichirikov.cpp
