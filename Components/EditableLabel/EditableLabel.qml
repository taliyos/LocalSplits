import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "../Fonts"

MouseArea {
    property bool isClicked: false
    property string text: "Text"
    property color textColor: "#ffffff"

    signal editStarted
    signal editConfirmed(editedText: string)
    signal editFinished
    signal editCancelled
    signal itemTabbed

    id: mouseArea
    clip: true

    acceptedButtons: Qt.LeftButton
    propagateComposedEvents: true

    function startEdit() {
        isClicked = !isClicked
        if (isClicked) {
            edit.forceActiveFocus()
            edit.cursorPosition = edit.length
            edit.selectAll()
        }
        editStarted()
    }

    function getChildWidth() {
        if (isClicked) return edit.contentWidth;
        else return label.contentWidth;
    }

    onDoubleClicked: {
        startEdit()
    }

    Label {
        id: label

        width: parent.width
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        font.family: OpenSans.family
        font.styleName: OpenSans.bold

        color: mouseArea.textColor
        text: parent.text

        visible: !parent.isClicked
    }

    TextEdit {
        id: edit

        width: parent.width
        height: parent.height
        verticalAlignment: Text.AlignVCenter
        font.pointSize: 10
        font.family: OpenSans.family
        font.styleName: OpenSans.regular

        color: mouseArea.textColor
        text: parent.text

        visible: parent.isClicked

        onEditingFinished: {
            parent.focus = false
            console.log("editing finished for " + parent.text)
            parent.editConfirmed(text)
        }

        onFocusChanged: {
            if (!focus) {
                parent.isClicked = false
                setInactive()
            }
        }

        Keys.onPressed: event => {
            if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return) {
                event.accepted = true
                focus = false
                parent.editFinished()
            }
            else if (event.key === Qt.Key_Tab) {
                event.accepted = true
                focus = false
                parent.itemTabbed()
            }
            else if (event.key === Qt.Key_Escape) {
                event.accepted = true
                text = parent.text
                focus = false
                parent.editCancelled()
            }
        }
    }
}
