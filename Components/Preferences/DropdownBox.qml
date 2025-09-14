import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    id: root
    property string currentText: "Never"   // default selected value
    property var options: ["Never", "Ask me", "Always"]
    signal onSelected(string value)

    width: 120
    height: 25

    // Background for closed dropdown
    Rectangle {
        id: bg
        anchors.fill: parent
        radius: 2
        color: mouseArea.pressed || dropdownList.visible ? "#ffffff"
              : mouseArea.containsMouse ? "#3d3d3d"
              : "#1b1b1b"
        border.width: 0
    }

    // Display selected text
    Text {
        id: labelText
        text: root.currentText
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 8
        color: mouseArea.pressed || dropdownList.visible ? "#000000"
              : mouseArea.containsMouse ? "#ffffff"
              : "#ffffff"
        font.pixelSize: 12
    }

    // Arrow
    Text {
        id: arrow
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 8
        font.pixelSize: 12
        text: dropdownList.visible ? "\u25B2" : "\u25BC"  // up/down triangle
        color: labelText.color
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: dropdownList.visible = !dropdownList.visible
    }

    // Dropdown options
    Column {
        id: dropdownList
        anchors.top: parent.bottom
        anchors.left: parent.left
        width: parent.width
        spacing: 0
        visible: false

        Repeater {
            model: options
            delegate: Rectangle {
                width: parent.width
                height: 25
                color: mouseAreaOption.containsMouse ? "#3d3d3d" : "#1b1b1b"

                Text {
                    anchors.centerIn: parent
                    text: modelData
                    color: "#ffffff"
                    font.pixelSize: 12
                }

                MouseArea {
                    id: mouseAreaOption
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: {
                        root.currentText = modelData
                        dropdownList.visible = false
                        root.onSelected(modelData)
                    }
                }
            }
        }
    }
}


