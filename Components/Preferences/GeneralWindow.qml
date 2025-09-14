/// SettingsPanel.qml
// SettingsPanel.qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string label
    property var group

    width: 400           // fixed width for side panel
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.leftMargin: 120   // <-- leaves space for vertical tab bar
    visible: group && group.activeParent === label   // show only if active


    Rectangle {
        id: bg
        anchors.fill: parent
        color: "#002d2d2d"
        radius: 8
        border.color: "#00000000"

        Column {
            id: contentItem
            anchors.fill: parent
            anchors.margins: 20
            spacing: 10


        }
    }
}



