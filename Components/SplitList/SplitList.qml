import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.localsplits
import "../SplitRow"
import "../Fonts"
import "../SplitFooterButton"

ColumnLayout {
    property alias splitHeight: splitsList.height

    id: splitListLayout

    ListView {
        clip: true

        id: splitsList
        Layout.fillWidth: true
        Layout.fillHeight: true

        flickableDirection: Flickable.AutoFlickIfNeeded
        flickDeceleration: 500
        boundsMovement: Flickable.StopAtBounds
        highlightFollowsCurrentItem: true
        highlightMoveVelocity: -1
        highlightMoveDuration: 50

        property int addedIndex: -1

        spacing: 1

        remove: Transition {
            NumberAnimation {
                properties: "x"
                to: -width
                duration: 80
                easing.type: Easing.OutSine
            }
        }

        removeDisplaced: Transition {
            SequentialAnimation {
                PauseAnimation {
                    duration: 15
                }
                NumberAnimation {
                    properties: "y"
                    duration: 65
                    easing.type: Easing.OutSine
                }
            }
        }

        add: Transition {
            NumberAnimation {
                properties: "x"
                from: -width
                duration: 80
                easing.type: Easing.OutSine
            }
        }

        addDisplaced: Transition {
            NumberAnimation {
                properties: "y"
                duration: 80
                easing.type: Easing.OutSine
            }
        }

        // New items are brought into view and edited upon creation.
        onCountChanged: {
            if (addedIndex === -1) return
            currentIndex = addedIndex
            splitsList.itemAtIndex(addedIndex).startEdit()
            addedIndex = -1
            console.log("\n")
        }

        model: SplitModel {
            id: splitListModel
            splits: splitList
        }

        delegate: SplitRow {
            width: splitsList.width

            name: model.name
            time: model.time

            splitColor: index % 2 === 0 ? "#2b2b2b" : "#00000000"
            textColor: "#ffffff"

            highlightBackgroundColor: "#ffffff"
            highlightTextColor: "#000000"

            hoverBackgroundColor: "#3d3d3d"
            hoverTextColor: "#ffffff"

            function deactivateCurrentRow() {
                if (splitsList.currentItem != null && splitsList.currentItem != this) {
                    splitsList.currentItem.setInactive()
                }
            }

            ListView.onAdd: {
                for (let i = index + 1; i < splitsList.count; i++) {
                    if (splitsList.itemAtIndex(i) == null) continue;
                    splitsList.itemAtIndex(i).setInactive()
                }
            }

            ListView.onRemove: {
                for (let i = index; i < splitsList.count; i++) {
                    if (splitsList.itemAtIndex(i) == null) continue;
                    splitsList.itemAtIndex(i).setInactive()
                }
            }

            onNameEditConfirmed: editedText => {
                if (model.name === editedText) return
                console.log("Name edit: " + model.name + " -> " + editedText)
                model.name = editedText
                name = editedText
            }

            onTimeEditConfirmed: editedText => {
                if (model.time === editedText) return
                console.log("Time edit: " + model.time + " -> " + editedText)
                model.time = editedText
                time = editedText
            }

            onTabToNextRow: {
                let idx = index + 1
                if (idx >= splitsList.count) idx = 0
                finishEdit()
                splitsList.currentIndex = idx
                splitsList.itemAtIndex(idx).startEdit()
            }

            onActivateRow: {
                deactivateCurrentRow()
            }

            onDuplicate: {
                splitsList.addedIndex = index + 1
                console.log(splitsList.addedIndex)
                splitList.addItem(model.name, model.time, index + 1)
            }

            onRemove: {
                splitList.removeItem(index)
            }
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
