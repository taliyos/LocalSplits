import QtQuick 2.15
import QtQuick.Controls 2.15


Control {
    id: root
    property alias text: label.text
    property bool checked: false
    property var parentTab
    signal tabSelected(string tabName)
    property var group: null
    implicitWidth: 92
    implicitHeight: 15

    background: Rectangle {
        radius: 2
        color: root.checked ? "#ffffff"
              : root.hovered ? "#3d3d3d"
              : "#1b1b1b"
    }

    contentItem: Text {
        id: label
        anchors.left: parent.left
        anchors.leftMargin: 20   // indentation
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignLeft
        color: root.checked ? "#000000" : "#ffffff"
        font.pointSize: 10
        font.family: "Open Sans"
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                // 1. Uncheck all parents and all subtabs of all parents
                if (parentGroup && parentGroup.buttons) {      // parentGroup is the global QtObject with all ParentTabs
                    for (let t of parentGroup.buttons) {       // t = each ParentTab
                        if (!t) continue;
                        t.checked = false;

                        if (t.subTabGroup && t.subTabGroup.buttons) {
                            for (let s of t.subTabGroup.buttons) {   // s = each SubTab
                                if (!s) continue;
                                s.checked = false;
                            }
                        }
                    }
                }

                // 2. Check the parent of this subtab
                if (root.parentTab) {
                    root.parentTab.checked = true;   // assumes each subtab has a reference to its parent
                }

                // 3. Check this subtab
                root.checked = true;


                if (root.parentTab && root.parentTab.group) {
                    root.parentTab.group.activeParent = root.parentTab.text;
                    root.parentTab.checked = true;
                }


                // 4. Emit selection signal if needed
                root.tabSelected(root.text);






            }
        }

    }

}
