import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import "Components/Fonts"
import "Components/SplitList"
import "Components/SplitRow"

Window {
    id: window
    width: 300
    height: 480
    visible: true
    title: qsTr("LocalSplits")

    Pane {
        id: _main
        anchors.fill: parent
        padding: 4

        ColumnLayout {
            width: parent.width
            height: parent.height

            ColumnLayout {
                id: _title
                width: parent.width
                spacing: 2
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    id: _titleText
                    text: gameName

                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    wrapMode: Text.WordWrap
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true

                    font.family: OpenSans.family
                    font.styleName: OpenSans.bold
                    font.pointSize: 12
                }

                Item {
                    Layout.fillWidth: true
                    Layout.minimumHeight: childrenRect.height
                    Label {
                        id: _runCategory
                        text: qsTr("Any%")
                        font.pixelSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        wrapMode: Text.NoWrap
                        font.family: OpenSans.family
                        font.styleName: OpenSans.bold

                        anchors.centerIn: parent
                    }

                    Label {
                        id: _attemptCounter
                        text: qsTr("0")
                        font.pixelSize: 12
                        font.bold: false
                        wrapMode: Text.NoWrap

                        font.family: OpenSans.family
                        font.styleName: OpenSans.italic

                        anchors.right: parent.right
                    }
                }
            }

            SplitList {
                id: allSplits

                width: parent.width
                Layout.fillHeight: true
                Layout.fillWidth: true
            }

            RowLayout {
                id: _timer
                width: parent.width

                Layout.alignment: Qt.AlignBottom
                Layout.maximumHeight: 75
                Layout.minimumHeight: 75

                Label {
                    id: _runTimer
                    text: "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><meta charset=\"utf-8\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\nhr { height: 1px; border-width: 0; }\nli.unchecked::marker { content: \"\\2610\"; }\nli.checked::marker { content: \"\\2612\"; }\n</style></head><body style=\" font-family:'Segoe UI'; font-size:9pt; font-weight:400; font-style:normal;\">\n<p style=\" margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><span style=\" font-family:'Open Sans ExtraBold'; font-size:32pt;\">00:00:00</span><span style=\" font-family:'Open Sans ExtraBold'; font-size:24pt;\">.00</span></p></body></html>"
                    font.pointSize: 28
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    textFormat: Text.RichText
                    font.styleName: OpenSans.extraBold
                    font.family: OpenSans.family
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }
            }

            SplitRow {
                id: previousSegment

                name: "Previous Segment"
                time: "-"

                color: "#00000000"
            }
        }
    }

    onClosing: {
    }
}
