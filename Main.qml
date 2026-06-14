import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Dialogs

import "Components/Fonts"
import "Components/SplitList"
import "Components/SplitRow"
import "Components/EditableLabel"
import com.localsplits

ApplicationWindow {
    id: window
    width: 450
    height: 600
    visible: true
    title: qsTr("LocalSplits")

    menuBar: SplitsMenuBar {
        onNewFile: {
            split.newFile();
        }

        onOpen: {
            openFileDialog.open();
        }
    }

    FileDialog {
        id: openFileDialog

        acceptLabel: "Open Splits"
        fileMode: FileDialog.OpenFile
        nameFilters: ["LiveSplit (*.lss)", "LocalSplits (*.localsplits)"]
        onAccepted: {
            split.openFile(selectedFile);
            split.name = "Test123";
        }
    }

    Pane {
        id: main
        anchors.fill: parent
        padding: 4

        background: Rectangle {
            color: "#1e1e1e"
        }

        ColumnLayout {
            width: parent.width
            height: parent.height

            RowLayout{
                Layout.fillWidth: true
                Layout.maximumHeight: 20

                EditableLabel {
                    id: usernameLabel
                    text: split.username
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    pointSize: 8
                    horizontalAlignment: Text.AlignLeft
                    verticalAlignment: Text.AlignVCenter

                    onEditConfirmed: editedText => {
                        // globalKeyHandler.forceActiveFocus()
                        if (split.username === editedText) return
                        split.username = editedText
                    }
                }

                Rectangle{
                    id: connectionDot
                    visible: split.gameMode === Split.MultiPlayer
                    width:10
                    height: 10
                    radius: 5
                    color: {
                            if (split.gameMode !== Split.MultiPlayer) return "transparent"
                            if (split.getRaceManager() === null) return "red"
                            return split.getRaceManager().connected ? "green" : "red"
                        }
                    Layout.alignment: Qt.AlignVCenter
                }

                Label{
                    text: split.gameMode === Split.MultiPlayer ? "MultiPlayer" : "SinglePlayer"
                    color: "white"
                    font.pointSize: 8
                    Layout.alignment: Qt.AlignVCenter
                }
            }


            ColumnLayout {
                id: title
                width: parent.width
                spacing: 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true

                EditableLabel {
                    id: titleText
                    text: split.gameName
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.minimumHeight: getChildHeight()

                    pointSize: 12
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter

                    onEditConfirmed: editedText => {
                        globalKeyHandler.forceActiveFocus();
                        if (split.gameName === editedText) return;
                        // console.log("Game name edit: " + split.gameName + " -> " + editedText);
                        split.gameName = editedText;
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    height: runCategory.height

                    EditableLabel {
                        id: runCategory
                        text: split.categoryName
                        Layout.fillWidth: true
                        Layout.minimumHeight: getChildHeight()

                        pointSize: 9
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

                        onEditConfirmed: editedText => {
                            globalKeyHandler.forceActiveFocus();
                            if (split.categoryName === editedText)
                                return;
                            // console.log("Category name edit: " + split.gameName + " -> " + editedText);
                            split.categoryName = editedText;
                        }
                    }

                    EditableLabel {
                        id: attemptCount
                        text: split.attemptCount
                        Layout.minimumWidth: getChildWidth()
                        Layout.minimumHeight: getChildHeight()

                        pointSize: 9
                        wrapMode: Text.NoWrap
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter

                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                        readFontStyle: OpenSans.italic

                        onEditConfirmed: editedText => {
                            globalKeyHandler.forceActiveFocus();
                            if (split.attemptCount === editedText)
                                return;
                            console.log("Category name edit: " + split.attemptCount + " -> " + editedText);
                            split.attemptCount = parseInt(editedText);
                        }
                    }
                }
            }

            SplitList {
                id: allSplits
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            RowLayout {
                id: qmlTimer
                width: parent.width
                Layout.alignment: Qt.AlignBottom
                Layout.maximumHeight: 75
                Layout.minimumHeight: 75

                Label {
                    id: _runTimer
                    color: split.run_ended ? "green" : "white"
                    text: {
                        var t = split.getTimer().time;
                        return t.slice(0, -2) + "<span style='font-size:16pt; font-weight:800'>" + t.slice(-2) + "</span>"
                    }
                    font.pointSize: 28
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    font.styleName: OpenSans.extraBold
                    font.family: OpenSans.family
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
                Button {
                    onClicked: split.onPauseButtonPress()
                }
                Button {
                    onClicked: split.onSplitButtonPress()
                }
                Button {
                    onClicked: split.onResetButtonPress()
                }
            }

            SplitRow {
                id: previousSegment

                name: "Previous Segment"
                time: "-"

                color: "#00000000"
            }
        }


    }

    onClosing: {
        Qt.quit();
    }
}
