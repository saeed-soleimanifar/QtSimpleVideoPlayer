import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {

    id : playToggleButton
    width: 60
    height: 60
    state: "play"

    signal play()
    signal pause()

    Rectangle {
        id: rctBackground
        anchors.fill: parent
        radius: width/2
        clip: true
        color: "#be6b4848"

        Image {
            id : imgIconPlay
            x:15
            y:15
            width: 30
            height: 30
            source: "Assets/play.png"
        }

        Image {
            id : imgIconPause
            x:65
            Behavior on x {
               NumberAnimation {duration: 500}
            }
            y:15
            width: 30
            height: 30
            source: "Assets/pause.png"
            visible: false
        }
    }



    MouseArea {
        anchors.fill: parent
        onPressed: {
            playToggleButton.scale = 0.85
        }
        onReleased: {
            playToggleButton.scale = 1
        }
        onClicked: {
            if(playToggleButton.state == "play"){
                playToggleButton.state = "pasue"
                playToggleButton.play()
            } else {
                playToggleButton.state = "play"
                playToggleButton.pause()
            }
        }
    }
    states: [
        State {
            name: "play"
        },
        State {
            name: "pasue"

            PropertyChanges {
                target: imgIconPause
                x: 15
                visible: true
            }

            PropertyChanges {
                target: imgIconPlay
                visible: false
            }
        }
    ]

}
