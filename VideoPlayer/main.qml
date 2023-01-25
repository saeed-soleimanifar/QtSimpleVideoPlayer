import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Dialogs 1.2
import QtMultimedia 5.0

Window {
    width: 640
    height: 520
    visible: true
    title: qsTr("Video Player Saeed Soleimanifar")

    function filePickerSelected(url) {
        player.source = "file://" + url
    }

    Image {
        source: "Assets/background.jpeg"
        fillMode: Image.PreserveAspectCrop
        anchors.fill: parent
    }

    Text {
        x: 246
        y: 12
        text: qsTr("Simple Video Player")
        font.pixelSize: 16
    }

    VideoScene {
        id : player
        x: 19
        y: 41
        onResetZoomSlider: {
            zoomSlider.value = 1
        }
    }

    Item {
        id : zoomSliderItem
        x: 372
        y: 468
        width: 236
        height: 40
        Rectangle {
            anchors.fill: parent
            color: "transparent"
            Row {
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: qsTr("Zoom")
                }
                CustomSlider {
                    id : zoomSlider
                    width: 200
                    from : 1
                    to:3
                    stepSize: 0.1
                    onValueChanged: {
                        player.pincherScale = value
                    }
                }
            }
        }
    }

    VideoSlider {
        id: videoSlider
        x: 19
        y: 400
        width: 602
        height: 50

        onValueChanged: {
            if(position !== player.position){
                player.seek(position)
            }
        }
    }

    PlayToggleButton {
        id : btnPlay
        x: 28
        y: 449

        onPlay: {
            player.play()
        }

        onPause: {
            player.pause()
        }
    }

    CustomButton {
        x:102
        y:454
        fontPointSize: 11
        title: "choose a file"
        onClicked: {
            filePicker.visible = true
        }
    }


    CustomFilePicker {
        id : filePicker
        x: 70
        y: 65
        visible: false
    }

//    CustomSlider {
//        id : mySlider
//        x: 221
//        y: 432
//    }

//    CustomSlider2 {
//        id : mySlider
//        x: 221
//        y: 432
//    }

    Component.onCompleted: {
        filePicker.fileSelected.connect(filePickerSelected)
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}D{i:1}D{i:2}D{i:3}D{i:7}D{i:8}D{i:6}D{i:5}D{i:4}D{i:9}D{i:10}
D{i:11}D{i:12}
}
##^##*/
