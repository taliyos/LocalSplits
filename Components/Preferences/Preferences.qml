import QtQuick 2.15

Window {
    x: 0
    width: 730
    height: 455

    Rectangle {
        id: rectangle
        color: "#1e1e1e"
        anchors.fill: parent

        Column {
            id: tabBar
            x: 40
            y: 64
            width: 123
            height: 328
        }

        Column {
            id: divider
            x: 178
            y: 56
            width: 38
            height: 356
        }

        Column {
            id: selectedTab
            x: 305
            y: 34
            width: 386
            height: 400
        }
    }

}
