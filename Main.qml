import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "Components/Fonts"

Window {
    id: window
    width: 300
    height: 480
    visible: true
    title: qsTr("LocalSplits")

    Page {
        id: _main
        anchors.fill: parent
        padding: 2

        ColumnLayout {
            id: _title
            width: parent.width
            height: 40
            anchors.top: parent.top
            anchors.topMargin: 0
            spacing: 2
            antialiasing: false
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillHeight: true

            Label {
                id: _titleText
                text: qsTr("Luigi's Mansion")

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                anchors.horizontalCenter: _runCategory.horizontalCenter
                font.pointSize: 12
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            Label {
                id: _runCategory
                text: qsTr("Any%")
                font.pixelSize: 10
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                font.styleName: "Italic"
                font.family: "Open Sans"
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
            }

            Label {
                id: _attemptCounter
                text: qsTr("0")
                font.pixelSize: 12
                font.bold: false
                wrapMode: Text.NoWrap
                anchors.bottom: parent.bottom
                anchors.right: parent.right
            }
        }

        ColumnLayout {
            id: _splits
            width: parent.width
            anchors.top: _title.bottom
            anchors.bottom: _timer.top
        }

        ColumnLayout {
            id: _timer
            width: parent.width
            height: 100

            anchors.bottom: _previousSegment.top

            Label {
                id: _runTimer
                text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\nhr { height: 1px; border-width: 0; }\nli.unchecked::marker { content: \"\\2610\"; }\nli.checked::marker { content: \"\\2612\"; }\n</style></head><body style=\" font-family:'Segoe UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-size:28pt; font-weight:700;\">00:00:00</span><span style=\" font-size:20pt; font-weight:700;\">.00</span></p></body></html>"
                font.pixelSize: 12
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                textFormat: Text.RichText
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillHeight: true
                Layout.fillWidth: true
            }
        }

        RowLayout {
            id: _previousSegment
            width: parent.width
            height: 25

            anchors.bottom: parent.bottom

            Label {
                id: _previousSegmentLabel
                text: qsTr("Previous Segment")
                font.bold: true
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter

                Layout.fillHeight: true
            }

            Label {
                id: _previousSegmentTime
                text: qsTr("-")
                font.bold: true
                font.pixelSize: 12
                verticalAlignment: Text.AlignVCenter

                anchors.right: parent.right
                Layout.fillHeight: true
            }
        }
    }
}

/*##^##
Designer {
    D{i:0}D{i:6;locked:true}
}
##^##*/

