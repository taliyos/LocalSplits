import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: subTab

    property alias text: tabText.text
    signal tabSelected()    // emitted when this subtab is clicked

    width: 92
    height: 20
    checkable: true
    font.pointSize: 10
    font.family: "Open Sans"
    checked: false

    onClicked: tabSelected()   // emit signal

    background: Rectangle {
        anchors.fill: parent
        radius: 2
        color: subTab.checked || subTab.down ? "#ffffff"
              : subTab.hovered ? "#3d3d3d"
              : "#1b1b1b"
    }

    contentItem: Text {
        id: tabText
        anchors.fill: parent
        anchors.leftMargin: 20   // indentation for subtab
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: subTab.checked || subTab.down ? "#000000" : "#ffffff"
        text: subTab.text
    }
}
