import QtQuick 2.0
import QtMultimedia 5.12

Item {

    id : videoScene

    width: 602
    height: 348

    property alias pincherScale: pincher.scale
    property alias position: player.position
    property string source: ""

    signal resetZoomSlider()


    function play() {
        player.play()
    }

    function pause() {
        player.pause()
    }

    function seek(position) {
        player.seek(position)
    }

    Flickable {
        id: flickArea
        anchors.fill: parent
        clip: true
        PinchArea {

            id : pincher
            anchors.fill: parent
            width: Math.max(flickArea.contentWidth, flickArea.width)
            height: Math.max(flickArea.contentHeight, flickArea.height)

            property real initialWidth
            property real initialHeight

            onPinchStarted: {
                initialWidth = flickArea.contentWidth
                initialHeight = flickArea.contentHeight
            }

            onPinchUpdated: {
                flickArea.resizeContent(initialWidth * pinch.scale,
                                        initialHeight * pinch.scale,
                                        pinch.center)
            }

            Rectangle {
                id : rctVideoScreen
                anchors.fill: parent
                color: "black"

                VideoOutput {
                    id : videoRender
                    anchors.fill: parent
                    source: player
                }

                MediaPlayer {
                    id : player
                    source: videoScene.source
                    onPositionChanged: {
                        videoSlider.setSliderCurrent(player.position)
                    }
                    onStatusChanged: {
                        if(status == MediaPlayer.Loaded) {
                            videoSlider.setSliderMaximum(player.duration)
                        }
                    }
                }
            }

            MouseArea {
                id : panArea
                anchors.fill: parent
                drag.target: parent.parent
                drag.axis: Drag.XAndYAxis
                onDoubleClicked: {
                    videoScene.resetZoomSlider()
                    flickArea.resizeContent(flickArea.width,
                                            flickArea.height,
                                            Qt.point(flickArea.width/2, flickArea.height/2))
                }

            }
        }
    }
}
