import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "../Fonts"

MouseArea {
    property bool isClicked: false
    property string text: "Text"
    property color textColor: "#ffffff"
    property int pointSize: 10
    property int wrapMode: Text.NoWrap
    property int horizontalAlignment: Text.AlignLeft
    property int verticalAlignment: Text.AlignVCenter
    property string readFontStyle: OpenSans.bold
    property string editFontStyle: OpenSans.regular


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

    function getChildHeight() {
        if (isClicked) return edit.contentHeight;
        else return label.contentHeight;
    }

    onDoubleClicked: {
        startEdit()
    }

    Label {
        id: label

        width: parent.width
        height: parent.height
        horizontalAlignment: mouseArea.horizontalAlignment
        verticalAlignment: mouseArea.verticalAlignment
        font.pointSize: mouseArea.pointSize
        font.family: OpenSans.family
        font.styleName: mouseArea.readFontStyle

        color: mouseArea.textColor
        text: parent.text

        visible: !parent.isClicked

        wrapMode: mouseArea.wrapMode
    }

    TextEdit {
        id: edit

        width: parent.width
        height: parent.height
        horizontalAlignment: mouseArea.horizontalAlignment
        verticalAlignment: mouseArea.verticalAlignment
        font.pointSize: mouseArea.pointSize
        font.family: OpenSans.family
        font.styleName: mouseArea.editFontStyle

        color: mouseArea.textColor
        text: parent.text

        visible: parent.isClicked
        wrapMode: mouseArea.wrapMode


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
