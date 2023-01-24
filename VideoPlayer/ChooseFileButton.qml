import QtQuick 2.0
import QtGraphicalEffects 1.0

Item {
    id : chooseFileButton
    width: 100
    height: 50

    property string title: "choose a video"

    signal clicked()



    Rectangle {
        id : rctBackground
        color: "#be6b4848"
        anchors.fill: parent
        radius: 35
        clip: true


        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: chooseFileButton.title
        }



        MouseArea {
            anchors.fill: parent
            onClicked: {
                chooseFileButton.clicked()
            }
            onPressed: {
                chooseFileButton.scale = 0.85
            }
            onReleased: {
                chooseFileButton.scale = 1
            }
        }
    }

}
