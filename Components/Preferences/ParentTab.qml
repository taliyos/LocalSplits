import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: parentTab

    property alias text: tabText.text
    signal tabSelected()    // emitted when this parent tab is clicked

    width: 108
    height: 24
    checkable: true
    font.pointSize: 10
    font.family: "Open Sans"
    topPadding: 0
    bottomPadding: 0
    rightPadding: 4
    leftPadding: 4
    checked: false

    onClicked: tabSelected()   // emit signal

    background: Rectangle {
        anchors.fill: parent
        radius: 2
        color: parentTab.checked || parentTab.down ? "#ffffff"
              : parentTab.hovered ? "#3d3d3d"
              : "#1b1b1b"
    }

    contentItem: Text {
        id: tabText
        anchors.fill: parent
        anchors.leftMargin: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: parentTab.checked || parentTab.down ? "#000000" : "#ffffff"
        text: parentTab.text
    }
}
