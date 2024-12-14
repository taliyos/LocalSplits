import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import com.localsplits
import "../SplitRow"

ColumnLayout {
    property alias splitHeight: splitsList.height

    id: splitListLayout

    ListView {
        clip: true

        id: splitsList
        Layout.fillWidth: true
        Layout.fillHeight: true

        spacing: 1

        model: SplitModel {
            splits: splitList
        }

        delegate: SplitRow {
            width: splitsList.width

            name: model.name
            time: model.time

            splitColor: index % 2 == 0 ? "#2b2b2b" : "#00000000"

            onNameEditFinished: (editedText) => {
                console.log("EDIT")
                if (model.name === editedText) return;
                console.log(model.name + " " + editedText)
                model.name = editedText
                name = editedText
            }

            onTimeEditFinished: (editedText) => {
                if (model.time === editedText) return;
                console.log(model.time + " " + editedText)
                model.time = editedText
                time = editedText
            }
        }
    }
}
