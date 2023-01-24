import QtQuick 2.14
import QtQuick.Window 2.14
import QtQuick.Controls 2.12
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
    }

//    Flickable {
//        id: flickArea
//        x: 19
//        y: 41
//        width: 602
//        height: 348
//        clip: true

//        PinchArea {

//            id : pincher
//            anchors.fill: parent
//            width: Math.max(flickArea.contentWidth, flickArea.width)
//            height: Math.max(flickArea.contentHeight, flickArea.height)

//            property real initialWidth
//            property real initialHeight

//            onPinchStarted: {
//                initialWidth = flickArea.contentWidth
//                initialHeight = flickArea.contentHeight
//            }

//            onPinchUpdated: {
//                flickArea.resizeContent(initialWidth * pinch.scale,
//                                        initialHeight * pinch.scale,
//                                        pinch.center)
//            }

//            Rectangle {
//                id : rctVideoScreen
//                anchors.fill: parent
//                color: "black"

//                VideoOutput {
//                    id : videoRender
//                    anchors.fill: parent
//                    source: player
//                }

//                MediaPlayer {
//                    id : player
//                    source: ""
//                    onPositionChanged: {
//                        videoSlider.setSliderCurrent(player.position)
//                    }
//                    onStatusChanged: {
//                        if(status == MediaPlayer.Loaded) {
//                            videoSlider.setSliderMaximum(player.duration)
//                        }
//                    }
//                }
//            }

//            MouseArea {
//                id : panArea
//                anchors.fill: parent
//                drag.target: parent.parent
//                drag.axis: Drag.XAndYAxis
//                onDoubleClicked: {
//                    zoomSlider.value=1
//                    flickArea.resizeContent(flickArea.width,
//                                            flickArea.height,
//                                            Qt.point(flickArea.width/2, flickArea.height/2))
//                }

//            }
//        }
//    }


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
                Slider {
                    id : zoomSlider
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

    ChooseFileButton {
        x:102
        y:454
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

    Component.onCompleted: {
        filePicker.fileSelected.connect(filePickerSelected)
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.66}D{i:1}D{i:2}D{i:6}D{i:7}D{i:5}D{i:8}D{i:4}D{i:3}D{i:12}
D{i:13}D{i:11}D{i:10}D{i:9}D{i:14}D{i:15}D{i:16}D{i:17}
}
##^##*/
