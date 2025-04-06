import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "../Fonts"
import "../EditableLabel"

Rectangle {
MouseArea {
    property string name: "Split Name"
    property string time: "00:00:00.00"
    property color textColor: "#ffffff"
    property color splitColor

    property color highlightBackgroundColor
    property color highlightTextColor

    property color currentTextColor: textColor
    property color currentBackgroundColor: splitColor

    property color hoverBackgroundColor
    property color hoverTextColor

    property alias color: rect.color

    property bool active: false

    signal nameEditConfirmed(string editedText)
    signal timeEditConfirmed(string editedText)
    signal tabToNextRow()
    signal activateRow()
    signal duplicate()
    signal remove()

    id: split

    height: 30
    Layout.fillWidth: true

    hoverEnabled: true

    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onClicked: (mouse) => {
        if (mouse.button === Qt.RightButton)
            contextMenu.popup()
    }
    onPressAndHold: (mouse) => {
        if (mouse.source === Qt.MouseEventNotSynthesized)
            contextMenu.popup()
    }

    Menu {
        id: contextMenu
        margins: 0
        padding: 0

        rightInset: 0
        leftInset: 0
        topInset: 0
        bottomInset: 0

        popupType: Popup.Item

        MenuItem {
            onClicked: split.startEdit()

            contentItem: Text {
                leftPadding: 0
                rightPadding: 0
                text: qsTr("Edit")
                font.pointSize: 10
                font.family: OpenSans.family
                font.styleName: OpenSans.regular
                color: parent.highlighted ? parent.down ? split.highlightTextColor: split.hoverTextColor : split.textColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                color: parent.highlighted ? parent.down ? split.highlightBackgroundColor : split.hoverBackgroundColor : "#00000000"
                radius: 2
            }
        }
        MenuItem {
            onClicked: split.duplicate()

            contentItem: Text {
                leftPadding: 0
                rightPadding: 0
                text: qsTr("Duplicate")
                font.pointSize: 10
                font.family: OpenSans.family
                font.styleName: OpenSans.regular
                color: parent.highlighted ? parent.down ? split.highlightTextColor: split.hoverTextColor : split.textColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                color: parent.highlighted ? parent.down ? split.highlightBackgroundColor : split.hoverBackgroundColor : "#00000000"
                radius: 2
            }
        }
        MenuItem {
            onClicked: split.remove()

            contentItem: Label {
                leftPadding: 0
                rightPadding: 0
                text: qsTr("Delete")
                font.pointSize: 10
                font.family: OpenSans.family
                font.styleName: OpenSans.regular
                color: parent.highlighted ? parent.down ? split.highlightTextColor: split.hoverTextColor : split.textColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                color: parent.highlighted ? parent.down ? split.highlightBackgroundColor : split.hoverBackgroundColor : "#00000000"
                radius: 2
            }
        }

        background: Rectangle {
            implicitWidth: 100
            color: "#1e1e1e"
            border.color: "#3c3c3c"
            radius: 2
        }
    }

    onEntered: {
        if (active) return
        startHover()
    }

    onExited: {
        if (active) return
        setInactive()
    }

    function setActive() {
        active = true
        currentBackgroundColor = highlightBackgroundColor
        currentTextColor = highlightTextColor
        activateRow()
    }

    function setInactive() {
        active = false
        if (containsMouse) {
            startHover()
            return
        }
        currentBackgroundColor = splitColor
        currentTextColor = textColor
    }

    function startEdit() {
        splitName.startEdit()
    }

    function finishEdit() {
        console.log("finish edit")
        setInactive()
    }

    function startHover() {
        currentBackgroundColor = hoverBackgroundColor
        currentTextColor = hoverTextColor
    }

    Rectangle {
        id: rect

        width: parent.width
        height: parent.height

        radius: 2

        color: parent.currentBackgroundColor

        RowLayout {
            id: splitRow

            width: parent.width
            height: parent.height

            // Split Name
            EditableLabel {
                id: splitName

                text: split.name
                textColor: split.currentTextColor

                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.horizontalStretchFactor: 3
                Layout.leftMargin: 4

                onEditStarted: {
                    split.setActive()
                }

                // Confirm edit for name
                onEditConfirmed: editedText => {
                    console.log("name edit confirmed")
                    split.nameEditConfirmed(editedText)
                }

                onEditFinished: {
                    console.log("name edit finished")
                    split.setInactive()
                }

                onEditCancelled: {
                    console.log("name edit cancelled")
                    split.setInactive()
                }

                // Tab from name -> time
                onItemTabbed: {
                    console.log("name edit tab out")
                    splitTime.startEdit()
                }
            }

            // Split Time
            EditableLabel {
                id: splitTime

                text: split.time
                textColor: split.currentTextColor

                Layout.fillHeight: true
                Layout.fillWidth: false
                Layout.rightMargin: 4
                Layout.minimumWidth: getChildWidth()

                onEditStarted: {
                    split.setActive()
                }

                // Confirm edit for time
                onEditConfirmed: editedText => {
                    console.log("time edit confirmed")
                    split.timeEditConfirmed(editedText)
                }

                onEditFinished: {
                    console.log("time edit finished")
                    split.setInactive()
                }

                onEditCancelled: {
                    console.log("time edit cancelled")
                    split.setInactive()
                }

                // Tab from time -> next row
                onItemTabbed: {
                    console.log("time edit tab out")
                    tabToNextRow()
                }
            }
        }
    }
