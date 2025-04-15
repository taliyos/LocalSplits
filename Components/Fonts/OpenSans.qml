        pragma Singleton

import QtQuick

Item {

    readonly property string family : openSansRegularFont.name

    readonly property string regular: openSansRegularFont.font.styleName
    readonly property string bold: openSansBoldFont.font.styleName
    readonly property string boldItalic: openSansBoldItalicFont.font.styleName
    readonly property string extraBold: openSansExtraBoldFont.font.styleName
    readonly property string extraBoldItalic: openSansExtraBoldItalicFont.font.styleName
    readonly property string italic: openSansItalicFont.font.styleName
    readonly property string light: openSansLightFont.font.styleName
    readonly property string lightItalic: openSansLightItalicFont.font.styleName
    readonly property string medium: openSansMediumFont.font.styleName
    readonly property string mediumItalic: openSansMediumItalicFont.font.styleName
    readonly property string semiBold: openSansSemiBoldFont.font.styleName
    readonly property string semiBoldItalic: openSansSemiBoldItalicFont.font.styleName

    FontLoader {
        id: openSansRegularFont
        source: "qrc:/fonts/OpenSans-Regular.ttf"
    }

    FontLoader {
        id: openSansBoldFont
        source: "qrc:/fonts/OpenSans-Bold.ttf"
    }

    FontLoader {
        id: openSansBoldItalicFont
        source: "qrc:/fonts/OpenSans-BoldItalic.ttf"
    }

    FontLoader {
        id: openSansExtraBoldFont
        source: "qrc:/fonts/OpenSans-ExtraBold.ttf"
    }

    FontLoader {
        id: openSansExtraBoldItalicFont
        source: "qrc:/fonts/OpenSans-ExtraBoldItalic.ttf"
    }

    FontLoader {
        id: openSansItalicFont
        source: "qrc:/fonts/OpenSans-Italic.ttf"
    }

    FontLoader {
        id: openSansLightFont
        source: "qrc:/fonts/OpenSans-Light.ttf"
    }

    FontLoader {
        id: openSansLightItalicFont
        source: "qrc:/fonts/OpenSans-LightItalic.ttf"
    }

    FontLoader {
        id: openSansMediumFont
        source: "qrc:/fonts/OpenSans-Medium.ttf"
    }

    FontLoader {
        id: openSansMediumItalicFont
        source: "qrc:/fonts/OpenSans-MediumItalic.ttf"
    }

    FontLoader {
        id: openSansSemiBoldFont
        source: "qrc:/fonts/OpenSans-SemiBold.ttf"
    }

    FontLoader {
        id: openSansSemiBoldItalicFont
        source: "qrc:/fonts/OpenSans-SemiBoldItalic.ttf"
    }
}
