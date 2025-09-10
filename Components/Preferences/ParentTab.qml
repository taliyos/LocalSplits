import QtQuick 2.15
import QtQuick.Controls 2.15


Control {
    id: root
    property alias text: label.text
    property bool checked: false

    signal tabSelected(string tabName)

    implicitWidth: 108
    implicitHeight: 20
    property var group: null
    property var subTabGroup: null
    background: Rectangle {
        radius: 2
        color: root.checked ? "#ffffff"
              : root.hovered ? "#3d3d3d"
              : "#1b1b1b"
    }

    contentItem: Text {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: 10
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: root.checked ? "#000000" : "#ffffff"
        font.pointSize: 10
        font.family: "Open Sans"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            // uncheck all parents and all subtabs of all parents
            if (root.group && root.group.buttons) {
                for (let t of root.group.buttons) {   // ✅ declared t
                    if (!t) continue;

                    t.checked = false;

                    // ✅ new: uncheck all subtabs of this parent (was missing for other groups)
                    if (t.subTabGroup && t.subTabGroup.buttons) {
                        for (let s of t.subTabGroup.buttons) {   // ✅ declared s
                            if (!s) continue;
                            s.checked = false;   // ✅ new: reset all subtabs
                        }
                    }
                }
            }

            root.checked = true;
            root.tabSelected(root.text);
        }
    }
}
