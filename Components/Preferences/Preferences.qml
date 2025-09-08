import QtQuick 2.15
import QtQuick.Controls 2.15
  // folder containing ParentTab.qml & SubTab.qml

Window {
    x: 0
    width: 730
    height: 455
    visible: true

    Rectangle {
        id: preferencesScreen
        color: "#1e1e1e"
        anchors.fill: parent
        anchors.leftMargin: 0
        anchors.rightMargin: 0
        anchors.topMargin: 0
        anchors.bottomMargin: 0

        ParentTab {
            id: generalTab
            text: "General"
            checked: true

            onTabSelected: {
                console.log("Parent tab clicked:", text)
                checked = true        // ensure it stays checked
            }
        }

        SubTab {
            id: runsTab
            text: "Runs"

            onTabSelected: {
                console.log("Subtab clicked:", text)
                runsTab.checked = true
                generalTab.checked = true   // keep parent selected
            }
        }



        Column {
            id: divider
            x: 140
            y: 42
            width: 3
            height: 371

            Rectangle {
                id: seperator
                color: "#1b1b1b"
                radius: 10
                anchors.fill: parent
            }
        }

        Column {
            id: selectedTab
            x: 155
            y: 12
            width: 563
            height: 431
            padding: 10
        }

    }

}


