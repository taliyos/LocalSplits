import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "../Fonts"
import "../EditableLabel"

Rectangle {
    property string name: "Split Name"
    property string time: "00:00:00.00"
    property color splitColor

    signal nameEditFinished(editedText: string)
    signal timeEditFinished(editedText: string)

    id: split

    Layout.fillWidth: true

    Layout.preferredHeight: 25
    Layout.minimumHeight: 25
    Layout.maximumHeight: 25

    radius: 2
    height: 30

    color: splitColor

    RowLayout {
        id: splitRow

        width: parent.width
        height: parent.height

        EditableLabel {
            id: splitName

            text: split.name

            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.horizontalStretchFactor: 3
            Layout.leftMargin: 4

            onEditFinished: (editedText) => {
                console.log("name edit finished")
                split.nameEditFinished(editedText)
            }

            onTabPressed: {
                console.log("name edit tab out")
                splitTime.startEdit()
            }
        }

        EditableLabel {
            id: splitTime

            text: split.time

            Layout.fillHeight: true
            Layout.fillWidth: false
            Layout.rightMargin: 4
            Layout.minimumWidth: getChildWidth()

            onEditFinished: (editedText) => {
                console.log("time edit finished")
                split.timeEditFinished(editedText)
            }

            onTabPressed: {
                console.log("time edit tab out")
                splitName.startEdit()
            }
        }
    }
}
