import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Controls.Basic
import "../Fonts"

Button {
    property alias contentText: content.text
    property real layoutWidth: 15
    property color backgroundNormalColor: "transparent"
    property color backgroundHoverColor: "#3d3d3d"
    property color backgroundPressedColor: "#ffffff"
    property color textNormalColor: "#ffffff"
    property color textHoverColor: "#ffffff"
    property color textPressedColor: "#000000"

    property alias bottomRightRadius: bg.bottomRightRadius
    property alias bottomLeftRadius: bg.bottomLeftRadius
    property alias topLeftRadius: bg.topLeftRadius
    property alias topRightRadius: bg.topRightRadius

    Layout.preferredWidth: layoutWidth
    Layout.fillHeight: true
    flat: true

    contentItem: Label {
        id: content

        font.family: OpenSans.family
        font.styleName: OpenSans.regular
        font.pointSize: 10
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter

        color: parent.hovered ? parent.down ? parent.textPressedColor : parent.textHoverColor : parent.textNormalColor
    }

    background: Rectangle {
        id: bg

        color: parent.hovered ? parent.down ? parent.backgroundPressedColor : parent.backgroundHoverColor : parent.backgroundNormalColor
    }
}