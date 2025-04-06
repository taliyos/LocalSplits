import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.localsplits
import "../SplitRow"

ColumnLayout {
    property alias splitHeight: splitsList.height

    id: splitListLayout

    ListView {
        clip: true

        id: splitsList
        Layout.fillWidth: true
        Layout.fillHeight: true

        spacing: 1

        model: SplitModel {
            splits: splitList
        }

        delegate: SplitRow {
            width: splitsList.width

            name: model.name
            time: model.time

            splitColor: index % 2 == 0 ? "#2b2b2b" : "#00000000"
            onNameEditFinished: editedText => {
                if (model.name === editedText) return
                console.log("Name edit: " + model.name + " -> " + editedText)
                model.name = editedText
                name = editedText
            }

            onTimeEditFinished: editedText => {
                if (model.time === editedText) return
                console.log("Time edit: " + model.time + " -> " + editedText)
                model.time = editedText
                time = editedText
            }
        footer: Rectangle {
            color: "#2b2b2b"

            width: 50
            height: 25
            bottomRightRadius: 2
            bottomLeftRadius: 2

            anchors.right: parent.right

            RowLayout {
                anchors.fill: parent
                spacing: 0

                SplitFooterButton {
                    contentText: "+"
                    layoutWidth: parent.width / 2

                    backgroundNormalColor: "transparent"
                    backgroundHoverColor: "#3d3d3d"
                    backgroundPressedColor: "#ffffff"
                    textNormalColor: "#ffffff"
                    textHoverColor: "#ffffff"
                    textPressedColor: "#000000"

                    bottomLeftRadius: 2
                    bottomRightRadius: 0
                    topRightRadius: 0
                    topLeftRadius: 0

                    onClicked: {
                        splitsList.addedIndex = splitsList.count
                        splitList.addItem()
                    }
                }

                SplitFooterButton {
                    contentText: "-"
                    layoutWidth: 25

                    backgroundNormalColor: "transparent"
                    backgroundHoverColor: "#3d3d3d"
                    backgroundPressedColor: "#ffffff"
                    textNormalColor: "#ffffff"
                    textHoverColor: "#ffffff"
                    textPressedColor: "#000000"

                    bottomLeftRadius: 0
                    bottomRightRadius: 2
                    topRightRadius: 0
                    topLeftRadius: 0

                    onClicked: {
                        splitList.removeItem(splitsList.count - 1)
                    }
                }
            }
        }
    }
}
