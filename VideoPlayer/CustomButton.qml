import QtQuick 2.0

Item {
    id : customButton
    width: 100
    height: 50

    property string title: "choose a video"
    property color color: "#be6b4848"
    property real radius: width/2
    property int fontPointSize: 9

    signal clicked()

    Rectangle {
        id : rctBackground
        color: customButton.color
        anchors.fill: parent
        radius: customButton.radius
        clip: true


        Text {
            id: text1
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: customButton.title
            font.pointSize: customButton.fontPointSize
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                customButton.clicked()
            }
            onPressed: {
                customButton.scale = 0.85
            }
            onReleased: {
                customButton.scale = 1
            }
        }
    }
}
