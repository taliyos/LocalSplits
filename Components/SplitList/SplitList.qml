import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.localsplits
import "../SplitRow"
import "../Fonts"
import "../SplitFooterButton"

ColumnLayout {
    id: splitListLayout
    spacing: 0

    RowLayout {
        Layout.fillWidth: true
        Layout.minimumHeight: 20
        Layout.maximumHeight: 20
        visible: split.gameMode === Split.MultiPlayer
        spacing: 1

        Item {
            Layout.preferredWidth: splitListLayout.width * 0.4
            Layout.preferredHeight: 20
        }

        Repeater {
            model: split.getRunnerModel()
            delegate: Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
                color: "#2b2b2b"

                Text {
                    anchors.fill: parent
                    text: model.name
                    color: "white"
                    font.pointSize: 8
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }
    }

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
                easing.type: Easing.OutSine }
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

        onCountChanged: {
            if (addedIndex === -1) return
            currentIndex = addedIndex
            splitsList.itemAtIndex(addedIndex).startEdit()
            addedIndex = -1
        }

        model: SplitModel {
            id: splitListModel
            splits: splitList
        }

        delegate: Item {
            id: delegateRoot
            width: splitsList.width
            height: 30
            property int splitIndex: index

            SplitRow {
                id: splitRowItem
                visible: split.gameMode === Split.SinglePlayer
                width: delegateRoot.width
                height: delegateRoot.height

                name: model.name
                time: model.time
                splitColor: splitIndex % 2 === 0 ? "#2b2b2b" : "#00000000"
                textColor: "#ffffff"
                highlightBackgroundColor: "#ffffff"
                highlightTextColor: "#000000"
                hoverBackgroundColor: "#3d3d3d"
                hoverTextColor: "#ffffff"

                function deactivateCurrentRow() {
                    if (splitsList.currentItem != null && splitsList.currentItem !== splitRowItem)
                        splitsList.currentItem.setInactive()
                }

                ListView.onAdd: {
                    for (let i = splitIndex + 1; i < splitsList.count; i++) {
                        if (splitsList.itemAtIndex(i) === null) continue
                        splitsList.itemAtIndex(i).setInactive()
                    }
                }
                ListView.onRemove: {
                    for (let i = splitIndex; i < splitsList.count; i++) {
                        if (splitsList.itemAtIndex(i) === null) continue
                        splitsList.itemAtIndex(i).setInactive()
                    }
                }

                onNameEditConfirmed: editedText => {
                    if (model.name === editedText) return
                    model.name = editedText
                    name = editedText
                    globalKeyHandler.forceActiveFocus()
                }
                onTimeEditConfirmed: editedText => {
                    if (model.time === editedText) return
                    model.time = editedText
                    time = editedText
                    globalKeyHandler.forceActiveFocus()
                }
                onTabToNextRow: {
                    let idx = splitIndex + 1
                    if (idx >= splitsList.count) idx = 0
                    finishEdit()
                    splitsList.currentIndex = idx
                    splitsList.itemAtIndex(idx).startEdit()
                }
                onActivateRow: deactivateCurrentRow()
                onDuplicate: {
                    splitsList.addedIndex = splitIndex + 1
                    splitList.addItem(model.name, model.time, splitIndex + 1)
                }
                onRemove: splitList.removeItem(splitIndex)
            }

            RowLayout {
                visible: split.gameMode === Split.MultiPlayer
                width: delegateRoot.width
                height: delegateRoot.height
                spacing: 1

                Rectangle {
                    Layout.preferredWidth: delegateRoot.width * 0.4
                    Layout.fillHeight: true
                    color: splitIndex % 2 === 0 ? "#2b2b2b" : "#00000000"

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: 4
                        text: model.name
                        color: "white"
                        font.pointSize: 10
                        font.family: OpenSans.family
                        verticalAlignment: Text.AlignVCenter
                    }
                }

                Repeater {
                    model: split.getRunnerModel()
                    delegate: Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: splitIndex % 2 === 0 ? "#2b2b2b" : "#00000000"

                        Text {
                            anchors.fill: parent
                            anchors.rightMargin: 4
                            text: {
                                var s = model.splits
                                return (s && splitIndex < s.length) ? s[splitIndex] : "--"
                            }
                            color: "white"
                            font.pointSize: 10
                            font.family: OpenSans.family
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }
            }
        }

        footer: Rectangle {
            visible: split.gameMode === Split.SinglePlayer
            color: "#2b2b2b"
            width: 50
            height: 25
            radius: 2
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
                    radius: 2
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
                    radius: 2
                    onClicked: splitList.removeItem(splitsList.count - 1)
                }
            }
        }
    }
}