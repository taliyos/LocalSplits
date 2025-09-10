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

        QtObject {
            id: themeGroup
            property var buttons: []
        }

        QtObject {
            id: startupGroup
            property var buttons: []
        }

        QtObject {
            id: racesGroup
            property var buttons: []
        }

        QtObject {
            id: parentGroup
            property var buttons: []
        }

        QtObject {
            id: generalGroup
            property var buttons: []
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

        Column {
            id: options
            x: 12
            y: 42
            anchors.left: parent.left
            anchors.right: divider.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.leftMargin: 12
            anchors.rightMargin: 12
            anchors.topMargin: 42
            anchors.bottomMargin: 70
            padding: 4


            Column {
                id: theme
                y: 78
                height: 56
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: 0
                anchors.rightMargin: 0

                ParentTab {
                    id: themeTab
                    text: "Theme"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    group: parentGroup
                    subTabGroup: themeGroup
                    Component.onCompleted: parentGroup.buttons.push(this)

                    onTabSelected: (tabName) => {
                                       console.log("Parent selected:", tabName)
                                   }

                }

                SubTab {
                    id: presetTab
                    text: "Presets"
                    anchors.left: parent.left
                    anchors.top: themeTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 3
                    group: themeGroup
                    parentTab: themeTab
                    Component.onCompleted: themeGroup.buttons.push(this)
                    onTabSelected: (tabName) => {
                                       console.log("Sub selected:", tabName)
                                       //themeTab.checked = true  // parent stays selected
                                   }
                }

                SubTab {
                    id: subTab
                    text: "Custom"
                    anchors.left: parent.left
                    anchors.top: themeTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 20
                    group: themeGroup
                    parentTab: themeTab
                    Component.onCompleted: themeGroup.buttons.push(this)
                    onTabSelected: (tabName) => {
                                       console.log("Sub selected:", tabName)
                                       //themeTab.checked = true  // parent stays selected
                                   }
                }
            }




            Column {
                id: general
                height: 75
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 268


                ParentTab {
                    id: generalTab
                    text: "General"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    checked: true

                    group: parentGroup
                    subTabGroup: generalGroup
                    Component.onCompleted: parentGroup.buttons.push(this)

                    onTabSelected: (tabName) => {
                                       console.log("Parent selected:", tabName)
                                   }
                }

                SubTab {
                    id: runsTab
                    text: "Runs"
                    anchors.left: parent.left
                    anchors.top: generalTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 3
                    group: generalGroup
                    parentTab: generalTab
                    Component.onCompleted: generalGroup.buttons.push(this)
                    onTabSelected: (tabName) => {
                                       console.log("Sub selected:", tabName)
                                       //generalTab.checked = true  // parent stays selected
                                   }
                }

                SubTab {
                    id: savingTab
                    text: "Saving"
                    anchors.left: parent.left
                    anchors.top: generalTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 20
                    group: generalGroup
                    parentTab: generalTab
                    Component.onCompleted: generalGroup.buttons.push(this)
                    onTabSelected: (tabName) => {
                                       console.log("Sub selected:", tabName)
                                       //generalTab.checked = true  // parent stays selected
                                   }
                }

                SubTab {
                    id: importsTab
                    text: "Imports"
                    anchors.left: parent.left
                    anchors.top: generalTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 37
                    group: generalGroup
                    parentTab: generalTab
                    Component.onCompleted: generalGroup.buttons.push(this)
                    onTabSelected: (tabName) => {
                                       console.log("Sub selected:", tabName)
                                        // parent stays selected
                                   }
                }
            }

            Column {
                id: startup
                height: 56
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 149

                ParentTab {
                    id: startupTab
                    text: "Startup"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 36

                    group: parentGroup
                    subTabGroup: startupGroup
                    Component.onCompleted: parentGroup.buttons.push(this)
                }

                SubTab {
                    id: splitsTab
                    text: "Splits"
                    anchors.left: parent.left
                    anchors.top: startupTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 3

                    group: startupGroup
                    parentTab: startupTab
                    Component.onCompleted: startupGroup.buttons.push(this)
                }

                SubTab {
                    id: otherTab
                    text: "Other"
                    anchors.left: parent.left
                    anchors.top: startupTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 20

                    group: startupGroup
                    parentTab: startupTab
                    Component.onCompleted: startupGroup.buttons.push(this)
                }
            }

            Column {
                id: races
                height: 75
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom
                anchors.leftMargin: 0
                anchors.rightMargin: 0
                anchors.bottomMargin: 70

                ParentTab {
                    id: racesTab
                    text: "Races"
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.leftMargin: 0
                    anchors.rightMargin: 0
                    anchors.bottomMargin: 55

                    group: parentGroup
                    subTabGroup: racesGroup
                    Component.onCompleted: parentGroup.buttons.push(this)
                }

                SubTab {
                    id: connectionTab
                    text: "Connection"
                    anchors.left: parent.left
                    anchors.top: racesTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 3

                    group: racesGroup
                    parentTab: racesTab
                    Component.onCompleted: racesGroup.buttons.push(this)
                }

                SubTab {
                    id: splitsharingTab
                    text: "Split Sharing"
                    anchors.left: parent.left
                    anchors.top: racesTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 20
                    group: racesGroup
                    parentTab: racesTab
                    Component.onCompleted: racesGroup.buttons.push(this)
                }

                SubTab {
                    id: pausingTab
                    text: "Pausing"
                    anchors.left: parent.left
                    anchors.top: racesTab.bottom
                    anchors.leftMargin: 24
                    anchors.topMargin: 37
                    group: racesGroup
                    parentTab: racesTab
                    Component.onCompleted: racesGroup.buttons.push(this)
                }
            }


        }

        ParentTab {
            id: aboutTab
            x: 16
            y: 393
            width: 116
            text: "About"
            group: parentGroup
            Component.onCompleted: parentGroup.buttons.push(this)
        }

    }

}


