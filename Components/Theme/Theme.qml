pragma Singleton
import QtQuick 2.15
import com.localsplits

QtObject {

    property list<color> backgroundColors: ["#1e1e1e", "#fff2de", "#000000"]
    property list<color> primaryColors: ["#1e1e1e", "#FFFFFF", "#FFFFFF"]
    property list<color> secondaryColors: ["#1B1B1B", "#F0B996", "#1B1B1B"]
    property list<color> accentColors: ["#2B2B2B", "#F0B996", "#FFFFFF"]
    property list<color> borderColors: ["#3c3c3c", "#FFDF88", "#FFE521"]
    property list<color> hoverColors: ["#3D3D3D", "#FFDF88", "#FFE521"]
    property list<color> selectedColors: ["#FFFFFF", "#EAA865", "#FFFFFF"]
    property list<color> secondaryAltColors: ["#1B1B1B", "#F0B996", "#1B1B1B"]
    property list<color> textPrimaryColors: ["#FFFFFF", "#000000", "#FFFFFF"]
    property list<color> textHoverColors: ["#FFFFFF", "#EAA865", "#000000"]
    property list<color> textSelectedColors: ["#000000", "#000000", "#000000"]


    property color backgroundColor: {
        if (theme === "dark")
            return backgroundColors[0];
        else if (theme === "light-orange")
            return backgroundColors[1];
        else if (theme === "high-contrast")
            return backgroundColors[2];
        else
            return "#A90012";
    }

    property color primaryColor: {
        if (theme === "dark")
            return primaryColors[0];
        else if (theme === "light-orange")
            return primaryColors[1];
        else if (theme === "high-contrast")
            return primaryColors[2];
        else
            return "#A90012";
    }

    property color secondaryColor: {
        if (theme === "dark")
            return secondaryColors[0];
        else if (theme === "light-orange")
            return secondaryColors[1];
        else if (theme === "high-contrast")
            return secondaryColors[2];
        else
            return "#A90012";
    }

    property color accentColor: {
        if (theme === "dark")
            return accentColors[0];
        else if (theme === "light-orange")
            return accentColors[1];
        else if (theme === "high-contrast")
            return accentColors[2];
        else
            return "#A90012";
    }

    property color borderColor: {
        if (theme === "dark")
            return borderColors[0];
        else if (theme === "light-orange")
            return borderColors[1];
        else if (theme === "high-contrast")
            return borderColors[2];
        else
            return "#A90012";
    }

    property color hoverColor: {
        if (theme === "dark")
            return hoverColors[0];
        else if (theme === "light-orange")
            return hoverColors[1];
        else if (theme === "high-contrast")
            return hoverColors[2];
        else
            return "#A90012";
    }

    property color selectedColor: {
        if (theme === "dark")
            return selectedColors[0];
        else if (theme === "light-orange")
            return selectedColors[1];
        else if (theme === "high-contrast")
            return selectedColors[2];
        else
            return "#A90012";
    }

    property color secondaryAltColor: {
        if (theme === "dark")
            return secondaryAltColors[0];
        else if (theme === "light-orange")
            return secondaryAltColors[1];
        else if (theme === "high-contrast")
            return secondaryAltColors[2];
        else
            return "#A90012";
    }

    property color textPrimaryColor: {
        if (theme === "dark")
            return textPrimaryColors[0];
        else if (theme === "light-orange")
            return textPrimaryColors[1];
        else if (theme === "high-contrast")
            return textPrimaryColors[2];
        else
            return "#A90012";
    }

    property color textHoverColor: {
        if (theme === "dark")
            return textHoverColors[0];
        else if (theme === "light-orange")
            return textHoverColors[1];
        else if (theme === "high-contrast")
            return textHoverColors[2];
        else
            return "#A90012";
    }

    property color textSelectedColor: {
        if (theme === "dark")
            return textSelectedColors[0];
        else if (theme === "light-orange")
            return textSelectedColors[1];
        else if (theme === "high-contrast")
            return textSelectedColors[2];
        else
            return "#A90012";
    }
}
