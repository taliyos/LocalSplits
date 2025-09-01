import QtQuick
import "../SplitRow"

MouseArea {
    id: dragArea

    property bool held: false
    default property alias data: content.data
    property int itemIndex

    signal moveItem(int currentIndex, int newIndex)

    anchors {
        left: parent?.left
        right: parent?.right
    }
    height: content.height

    drag.target: held ? content : undefined
    drag.axis: Drag.YAxis

    pressAndHoldInterval: 0

    onPressAndHold: {
        held = true
        console.log("HOOOOLD")
    }
    onReleased: held = false

    propagateComposedEvents: true

    Rectangle {
        id: content
        Drag.active: dragArea.held
        Drag.source: dragArea
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        width: dragArea.width
        height: childrenRect.height
        color: "transparent"

        states: State {
            when: dragArea.held

            ParentChange {
                target: content
                parent: root
            }
            AnchorChanges {
                target: content
                anchors {
                    horizontalCenter: undefined
                    verticalCenter: undefined
                }
            }
        }
    }

    DropArea {
        anchors {
            fill: parent
            margins: 10
        }

        onEntered: (drag) => {
            //console.log(drag.source.itemIndex + " - " + dragArea.itemIndex)
            dragArea.moveItem(drag.source.itemIndex, dragArea.itemIndex)
            //ListView.items.move(drag.source.DelegateModel.itemsIndex, dragArea.DelegateModel.itemsIndex)
            //visualModel.items.move(dragArea.DelegateModel.itemsIndex, drag.source.DelegateModel.itemsIndex)
        }
    }
}