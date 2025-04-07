import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "../Fonts"

Window {
    title: qsTr("About")

    width: 400
    height: 150

    Pane {

        anchors.fill: parent
        padding: 4

        ColumnLayout {
            Label {
                text: `${Application.displayName} (${Application.version})`
                color: "#ffffff"
                font.family: OpenSans.family
                font.styleName: OpenSans.bold
                font.pointSize: 16
            }

            Label {
                text: "Created by Charles Reverand and Pranav Tripuraneni"
                color: "#ffffff"
                font.family: OpenSans.family
                font.styleName: OpenSans.regular
                font.pointSize: 10
            }

            Label {
                text: "Licenses & Attributions"
                color: "#ffffff"
                font.family: OpenSans.family
                font.styleName: OpenSans.regular
                font.pointSize: 10
            }

            Text {
                text: "<a href='https://www.github.com/taliyos/LocalSplits/releases'>Releases</a>"
                textFormat: Text.RichText
                onLinkActivated: Qt.openUrlExternally(link)

                color: "#ffffff"
                font.family: OpenSans.family
                font.styleName: OpenSans.regular
                font.pointSize: 10

                MouseArea {
                    anchors.fill: parent
                    acceptedButtons: Qt.NoButton
                    cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
                }
            }
        }
    }
}