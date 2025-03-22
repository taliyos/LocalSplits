import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "../Fonts"

MouseArea {
    property bool isClicked: false
    property string text: "Text"

    signal editFinished(editedText: string)
    signal tabPressed

    id: mouseArea
    clip: true

    acceptedButtons: Qt.LeftButton

    function startEdit() {
        isClicked = !isClicked
        if (isClicked) {
            edit.forceActiveFocus()
            edit.cursorPosition = edit.length
            edit.selectAll()
        }
    }

    function getChildWidth() {
        if (isClicked) return edit.contentWidth;
        else return label.contentWidth;
    }

    onClicked: {
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

        color: "#ffffff"
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

        color: "#ffffff"
        text: parent.text

        visible: parent.isClicked

        onEditingFinished: {
            parent.focus = false
            parent.editFinished(text)
        }

        onFocusChanged: {
            if (!focus)
                parent.isClicked = false
        }

        Keys.onPressed: event => {
                            if (event.key === Qt.Key_Enter
                                || event.key === Qt.Key_Return) {
                                event.accepted = true
                                focus = false
                                parent.editFinshed(text)
                            }

                            if (event.key === Qt.Key_Tab) {
                                event.accepted = true
                                focus = false
                                parent.tabPressed()
                            }
                        }
    }
}
