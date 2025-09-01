import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import "../AboutPopup"

MenuBar {
    id: menuBar
    height: 20

    //visible: false

    signal newFile
    signal open
    signal save
    signal saveAs

    SplitsMenu {
        title: qsTr("File")
        SplitsMenuItem {
            text: qsTr("&New")
            onTriggered: { newFile() }
        }
        SplitsMenuItem {
            text: qsTr("&Open")
            onTriggered: { open() }
        }
        SplitsMenuItem {
            text: qsTr("&Save")
            onTriggered: { save() }
        }
        SplitsMenuItem {
            text: qsTr("Save &As")
            onTriggered: { saveAs() }
        }
        MenuSeparator { }
        SplitsMenuItem { text: qsTr("&Preferences") }
        MenuSeparator { }
        SplitsMenuItem {
            text: qsTr("&Quit")
            onTriggered: {
                Qt.quit()
            }
        }
    }
    SplitsMenu {
        title: qsTr("Race")
        SplitsMenuItem { text: qsTr("&Create") }
        SplitsMenuItem { text: qsTr("C&onnect") }
    }
    SplitsMenu {
        title: qsTr("Help")
        SplitsMenuItem {
            text: qsTr("&About")
            onTriggered: {
                let component = Qt.createComponent("../AboutPopup/AboutPopup.qml")
                let window = component.createObject()
                window.show()
            }
        }
    }

    delegate: MenuBarItem {
        id: menuBarItem
        height: 20

        contentItem: Label {
            text: menuBarItem.text
            font: menuBarItem.font
            opacity: enabled ? 1.0 : 0.3
            color: "#ffffff"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitWidth: 40
            implicitHeight: 20
            opacity: enabled ? 1 : 0.3
            color: menuBarItem.highlighted ? "#3d3d3d" : "#00000000"
        }
    }

    background: Rectangle {
        implicitWidth: 40
        implicitHeight: 20
        color: "#1e1e1e"

        Rectangle {
            color: "#2b2b2b"
            width: parent.width
            height: 1
            anchors.bottom: parent.bottom
        }
    }
}