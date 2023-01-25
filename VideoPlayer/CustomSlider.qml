import QtQuick 2.0

Item {

    id: customSlider
    width: 400
    height: 30

    property real from: 0
    property real to: 100
    property real value:0
    property real stepSize:0



    onStepSizeChanged: {
        if(stepSize<0){
            stepSize = 0
        }
    }

    onToChanged: {
        if(to<from){
            to = from + 1
        }
    }

    onFromChanged: {
        if(from>to){
            from = to - 1
        }
    }

    onValueChanged: {
        if(!dragArea.drag.active) {
            if(value>= from & value <= to) {
                calcRctSliderButtonX((value-from) / (to-from))
            } else {
                calcValue(rctSliderButton.x )
            }
        }
    }

    function calcValue(xLocation) {
        var distance = rctSliderBar.width -  rctSliderButton.width
        var actualProgressPercent = xLocation / (rctSliderBar.width -  rctSliderButton.width)
        if(stepSize>0) {
            var movingValue = actualProgressPercent * (to-from)
            var passedSteps = Math.floor(movingValue/stepSize)
            value = from + (passedSteps*stepSize)
        } else {
            value = from +  (actualProgressPercent * (to-from))
        }
    }

    function calcRctSliderButtonX (actualProgressPercent) {
        var distance = rctSliderBar.width -  rctSliderButton.width
        rctSliderButton.x = actualProgressPercent * distance
    }

    Rectangle {
        id : rctSliderBar
        height: 10
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        color: "lightgray"
        radius: 5

        MouseArea {
            id : dragArea
            anchors.fill: parent

            drag {
                target: rctSliderButton
                axis: Drag.XAxis
                maximumX: rctSliderBar.width  - (rctSliderButton.width/2)
                minimumX: 0
            }


            onPositionChanged: {
                if(drag.active){
                    rctSliderButton.x = Math.max(0, Math.min(mouse.x - rctSliderButton.width/2,drag.maximumX- rctSliderButton.width/2))
                    calcValue(rctSliderButton.x )
                }
            }

            onClicked: {
                rctSliderButton.x = Math.max(0, Math.min(mouse.x - rctSliderButton.width/2,drag.maximumX- rctSliderButton.width/2))
                calcValue(rctSliderButton.x )
            }
        }
    }

    Rectangle {
        id : rctSliderButton
        width: 20
        height: 20
        radius: width/2
        anchors.verticalCenter: parent.verticalCenter
    }


}
