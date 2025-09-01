import QtQuick
import QtQuick.Layouts

MouseArea {

    /** Layout */
    Layout.minimumHeight: parent.height
    Layout.minimumWidth: 20

    Image {
        id: image
        width: parent.width
        height: parent.height
        source: "file:/" + applicationDirPath + "/icons/GrabHandle/GrabHandle-Lines.svg"
        fillMode: Image.PreserveAspectFit
    }

    /** Properties */
    property bool held: false
    required property Item root

    acceptedButtons: MouseButtons.LeftButton
    pressAndHoldInterval: 0
    drag.target: held ? root : undefined
    drag.axis: Drag.YAxis

    /** Slots */
    onClicked: mouse => {
                   console.log(mouse + " MOUSE CLICK")
               }

    onPressAndHold: held = true
    onReleased: held = false
}
