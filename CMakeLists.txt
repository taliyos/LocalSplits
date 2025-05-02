cmake_minimum_required(VERSION 3.16)

project(LocalSplits VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appLocalSplits
    main.cpp Resources.qrc
        Components/Split/splitmodel.cpp
        Components/Split/splitmodel.h
        Components/Split/splititem.h
        Components/SplitList/splitlistdata.cpp
        Components/SplitList/splitlistdata.h
        Components/Split/split.cpp
        Components/Split/split.h
        Components/Timer/timer.cpp
        Components/Timer/timer.h
)

qt_add_qml_module(appLocalSplits
    URI LocalSplits
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES
    QML_FILES Components/Fonts/OpenSans.qml
    RESOURCES Components/Fonts/qmldir
    RESOURCES Resources.qrc
    SOURCES
    SOURCES Components/Timer/timer.cpp Components/Timer/timer.h
    SOURCES Components/SplitLayoutParsing/layoutparser.cpp Components/SplitLayoutParsing/layoutparser.h   Components/SplitLayoutParsing/splitsegment.h Components/SplitLayoutParsing/splittime.h
    SOURCES Components/SplitLayoutParsing/timemethod.h
    SOURCES Components/SplitLayoutParsing/segmenttime.h
    SOURCES Components/SplitLayoutParsing/splitplatform.h
    SOURCES Components/SplitLayoutParsing/splitmetadata.h
    SOURCES Components/SplitLayoutParsing/splitattempt.h
    SOURCES Components/SplitLayoutParsing/splitlayout.h
    SOURCES Components/SplitRow/splitrowmodel.h Components/SplitRow/splitrowmodel.cpp
    RESOURCES
        Components/SplitRow/qmldir
        Components/SplitList/qmldir
        Components/EditableLabel/qmldir
        Components/SplitFooterButton/qmldir
        Components/SplitsMenuBar/qmldir
        Components/AboutPopup/qmldir
    QML_FILES
        Components/SplitRow/SplitRow.qml
        Components/SplitList/SplitList.qml
        Components/EditableLabel/EditableLabel.qml
        Components/SplitFooterButton/SplitFooterButton.qml
        Components/SplitsMenuBar/SplitsMenuBar.qml
        Components/SplitsMenuBar/SplitsMenuItem.qml
        Components/SplitsMenuBar/SplitsMenu.qml
        Components/AboutPopup/AboutPopup.qml
        SOURCES timer.h timer.cpp


)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appLocalSplits PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appLocalSplits
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appLocalSplits
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appLocalSplits
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
