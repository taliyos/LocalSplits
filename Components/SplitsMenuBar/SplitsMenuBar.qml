import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import com.localsplits
import "../AboutPopup"



MenuBar {
    id: menuBar
    height: 20

    //visible: false

    signal newFile
    signal open
    signal save
    signal saveAs


    Dialog {
        id: joinRoomDialog

        title: "Join Room"
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 250

        onOpened: {
            roomCodeInput.text = ""
            roomCodeInput.forceActiveFocus()
        }

        Column {
            width: parent.width
            spacing: 12

            Text {
                text: "Enter room code:"
                color: "black"
            }

            TextField {
                id: roomCodeInput
                width: parent.width
                placeholderText: "e.g. XK4R9M"
                maximumLength: 6
                Keys.onReturnPressed: confirmButton.clicked()
            }
        }

        footer: DialogButtonBox {
            Button {
                id: confirmButton
                text: "Join"
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                enabled: roomCodeInput.text.length > 0
                onClicked: split.raceManager.joinRoom(roomCodeInput.text.toUpperCase())
            }
            Button {
                text: "Cancel"
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }
    }
    Dialog {
        id: serverAddressDialog

        title: "Server Address"
        modal: true
        anchors.centerIn: Overlay.overlay
        width: 250

        onOpened: {
            serverAddressInput.text = split.raceManager.serverAddress
            serverAddressInput.forceActiveFocus()
        }

        Column {
            width: parent.width
            spacing: 12

            Text {
                text: "Server address host:port"
                color: "black"
            }

            TextField {
                id: serverAddressInput
                width: parent.width
                placeholderText: "e.g. 192.168.1.5:8080"
                Keys.onReturnPressed: serverAddressConfirmButton.clicked()
            }
        }

        footer: DialogButtonBox {
            Button {
                id: serverAddressConfirmButton
                text: "Save"
                DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
                enabled: serverAddressInput.text.length > 0
                onClicked: split.raceManager.serverAddress = serverAddressInput.text.trim()
            }
            Button {
                text: "Cancel"
                DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            }
        }
    }


    Dialog {
        id: notMultiplayerDialog
        title: "Not in Multiplayer Mode"
        modal: true
        anchors.centerIn: Overlay.overlay

        Text {
            text: "Switch to Multiplayer mode first before joining a room."
            color: "white"
            wrapMode: Text.Wrap
            width: 250
        }

        standardButtons: Dialog.Ok
    }


    SplitsMenu {
        title: qsTr("File")
        SplitsMenuItem {
            text: qsTr("New")
            onTriggered: {
                newFile();
            }
        }
        SplitsMenuItem {
            text: qsTr("Open")
            onTriggered: {
                open();
            }
        }
        SplitsMenuItem {
            text: qsTr("Save")
            onTriggered: {
                save();
            }
        }
        SplitsMenuItem {
            text: qsTr("Save As")
            onTriggered: {
                saveAs();
            }
        }
        MenuSeparator {}
        SplitsMenuItem{
            text: split.gameMode === Split.SinglePlayer ? qsTr("Switch to Multiplayer") : qsTr("Switch to SinglePlayer")
            onTriggered: {
                if (split.gameMode === Split.SinglePlayer){
                    split.setGameMode(Split.MultiPlayer)
                }else{
                    split.setGameMode(Split.SinglePlayer)
                }
            }
        }

        SplitsMenuItem{
            text: qsTr("Create Room")
            onTriggered: {
                if (split.gameMode === Split.SinglePlayer){
                    notMultiplayerDialog.open()
                }else{
                    split.raceManager.createRoom()
                }
            }
        }

        SplitsMenuItem{
            text: qsTr("Join Room")
            onTriggered: {
                if (split.gameMode === Split.SinglePlayer){
                    notMultiplayerDialog.open()
                }else{
                    joinRoomDialog.open()
                }
            }
        }

        SplitsMenuItem {
            text: qsTr("Server Address")
            onTriggered: {
                if (split.gameMode === Split.SinglePlayer){
                    notMultiplayerDialog.open()
                }else{
                    serverAddressDialog.open()
                }
            }
        }

        MenuSeparator {}
        SplitsMenuItem {
            text: qsTr("Quit")
            onTriggered: {
                Qt.quit();
            }
        }
    }
    SplitsMenu {
        title: qsTr("Help")
        SplitsMenuItem {
            text: qsTr("About")
            onTriggered: {
                let component = Qt.createComponent("../AboutPopup/AboutPopup.qml");
                let window = component.createObject();
                window.show();
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

