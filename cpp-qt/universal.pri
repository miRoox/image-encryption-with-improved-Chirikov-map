!isEmpty(UNIVERSAL_PRI_INCLUDED):error("universal.pri has been included")
UNIVERSAL_PRI_INCLUDED = 1

VERSION = 0.4.0
CONFIG += c++14
DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000 # disables all the APIs deprecated before Qt 6.0.0

defineReplace(qtLibraryName) {
   RET = $$qtLibraryTarget($$1)
   win32 {
      VERSION_LIST = $$split(VERSION, .)
      RET = $$RET$$first(VERSION_LIST)
   }
   return($$RET)
}

SOURCE_ROOT = $$PWD
BUILD_ROOT = $$shadowed($$PWD)

# build path
BIN_PATH = $$BUILD_ROOT/bin
LIBRARY_PATH = $$BUILD_ROOT/lib
APP_PATH = $$BIN_PATH

APP_FULL_NAME = Image Encryption with Improved Chirikov Map
DEFINES += $$shell_quote(APP_FULL_NAME=\"$$APP_FULL_NAME\")
DEFINES += $$shell_quote(VERSION_STR=\"$$VERSION\")

INCLUDEPATH += \
    $$SOURCE_ROOT  \
    $$SOURCE_ROOT/libs

LIBS *= -L$$LIBRARY_PATH
