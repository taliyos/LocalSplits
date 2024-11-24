pragma Singleton

import QtQuick

Item {

    readonly property string regular: openSansRegularFont.name

    FontLoader {
        id: openSansRegularFont
        source: "qrc:/Components/Fonts/OpenSans/OpenSans-ExtraBold.ttf"
    }

    Text {
        text: openSansRegularFont.status == FontLoader.Ready ? "Ready! " : "Not Ready"
        font.family: openSansRegularFont.name
    }
}
