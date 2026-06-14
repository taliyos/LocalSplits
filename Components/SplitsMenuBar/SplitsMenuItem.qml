import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Basic

MenuItem {
    id: menuItem
    height: 25
    contentItem: Label{
        text: menuItem.text
        color: "#ffffff"
        verticalAlignment: Text.AlignVCenter
        leftPadding: 2
    }
    background: Rectangle{
        color: menuItem.highlighted ? "#3d3d3d" : "#1e1e1e"
    }
}
