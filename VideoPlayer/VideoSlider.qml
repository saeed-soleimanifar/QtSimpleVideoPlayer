import QtQuick 2.0

Item {
    id : videoSlider
    width: 300
    height: 50

    function setSliderMaximum(max) {
        videoScroll.to = max
    }

    function setSliderCurrent(current) {
        d.changeIt = false
        videoScroll.value = current
        d.changeIt = true
    }

    signal valueChanged(var position)

    QtObject {
        id : d
        property bool changeIt: true
    }

    Rectangle {
        id : rctVideoSlider
        anchors.fill: parent
        color: "transparent"

        CustomSlider {
            id : videoScroll
            anchors.fill: parent
            onValueChanged: {
                if(d.changeIt){
                    videoSlider.valueChanged(videoScroll.value)
                }
            }
        }
    }
}
