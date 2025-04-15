import QtQuick
import QtQuick.Effects
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
    width: 300
    height: 480
    visible: true
    title: qsTr("LocalSplits")

    menuBar: SplitsMenuBar {
        onNewFile: {
            split.newFile()
        }

        onOpen: {
            openFileDialog.open()
        }
    }

    FileDialog {
        id: openFileDialog

        acceptLabel: "Open Splits"
        fileMode: FileDialog.OpenFile
        nameFilters: ["LocalSplits (*.localsplits)", "LiveSplit (*.lss)"]

        onAccepted: {
            console.log("file opened")
            //console.log(split.getName())
            split.openFile(selectedFile)
            split.name = "Test123"
        }
    }

    Pane {
        id: main
        anchors.fill: parent
        padding: 4

        ColumnLayout {
            width: parent.width
            height: parent.height

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
                        if (split.gameName === editedText) return
                        console.log("Game name edit: " + split.gameName + " -> " + editedText)
                        split.gameName = editedText
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    //Layout.minimumHeight: childrenRect.height
                    height: runCategory.height

                    EditableLabel {
                        id: runCategory
                        text: split.categoryName
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.minimumHeight: getChildHeight()

                        pointSize: 9
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter

                        anchors.centerIn: parent

                        onEditConfirmed: editedText => {
                            if (split.categoryName === editedText) return
                            console.log("Category name edit: " + split.gameName + " -> " + editedText)
                            split.categoryName = editedText
                        }
                    }

                    EditableLabel {
                        id: attemptCount
                        text: split.attemptCount
                        Layout.alignment: Qt.AlignHCenter
                        Layout.minimumWidth: getChildWidth()
                        Layout.minimumHeight: getChildHeight()

                        pointSize: 9
                        wrapMode: Text.NoWrap
                        horizontalAlignment: Text.AlignRight
                        verticalAlignment: Text.AlignVCenter

                        anchors.right: parent.right
                        readFontStyle: OpenSans.italic
                        // debug: true

                        onEditConfirmed: editedText => {
                            if (split.attemptCount === editedText) return
                            console.log("Category name edit: " + split.attemptCount + " -> " + editedText)
                            split.attemptCount = parseInt(editedText)
                        }
                    }
                }
            }

            SplitList {
                id: allSplits

                width: parent.width
                Layout.fillHeight: true
                Layout.fillWidth: true
            }


            RowLayout {
                property string name: "HERE1"
                id: qmlTimer
                width: parent.width

                Layout.alignment: Qt.AlignBottom
                Layout.maximumHeight: 75
                Layout.minimumHeight: 75



                Label {
                    id: _runTimer

                    text: "HERE :()"
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
                   id: pauseButton
                    width: 32
                    height:32

                    onClicked: Timer.pauseTimer()
                }


            }

            SplitRow {
                id: previousSegment

                name: "Previous Segment"
                time: "-"

                color: "#00000000"
            }
        }

        background: Rectangle {
            color: "#1e1e1e"
        }

    }

    onClosing: {
        Qt.quit()
    }

}
