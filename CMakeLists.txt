cmake_minimum_required(VERSION 3.16)

project(LocalSplits VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appLocalSplits
    main.cpp Resources.qrc
)

qt_add_qml_module(appLocalSplits
    URI LocalSplits
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES
        QML_FILES
        RESOURCES
        RESOURCES
    QML_FILES Components/Fonts/OpenSans.qml
    RESOURCES Components/Fonts/qmldir
    RESOURCES Resources.qrc
    SOURCES
    SOURCES timer.h timer.cpp
)

#qt_add_resources(appLocalSplits
#        openSansBold
#        FILES
#        fonts/OpenSans-Bold.ttf
#)

#qt_add_resources(appLocalSplits
#        fonts
#        FILES
#        fonts/OpenSans-Bold.ttf
#        fonts/OpenSans-BoldItalic.ttf
#        fonts/OpenSans-Italic.ttf
#        fonts/OpenSans-Light.ttf
#        fonts/OpenSans-LightItalic.ttf
#        fonts/OpenSans-Medium.ttf
#        fonts/OpenSans-MediumItalic.ttf
#        fonts/OpenSans-Regular.ttf
#        fonts/OpenSans-SemiBold.ttf
#        fonts/OpenSans-SemiBoldItalic.ttf
#)


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
