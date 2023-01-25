import QtQuick 2.0
import VideoFileExplorerModel 0.1

Item {

    id: customFilePicker
    width: 500
    height: 300

    property string selectedFileAddress: ""

    signal fileSelected(var url)

    Rectangle {
        anchors.fill: parent
        color: "#5c4d4d"
    }

    Rectangle {
        id : rctHeader
        color: "transparent"
        width: parent.width
        height: 30
        anchors.top: parent.top
        Text {
            anchors.fill: parent
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Choose a video")
        }
    }

    Rectangle {
        id: rctFileBrowserContent
        color: "white"
        anchors.top: rctHeader.bottom
        anchors.bottom: rctActionButton.top
        width: parent.width

        Component {
            id: fileExplorerDelegate

            Rectangle {
                id : itemContainer
                width: fileExplorerGridView.itemWidth
                height: fileExplorerGridView.itemHeight
                color: "transparent"

                Column {
                    spacing: 0
                    Rectangle {
                        width: fileExplorerGridView.itemWidth
                        height: fileExplorerGridView.itemHeight * 0.80
                        color: fileExplorerGridView.currentIndex === model.index ? "lightgray" : "transparent"
                        Image {
                            id : imgFolderFileIcon
                            anchors.fill: parent
                            anchors.margins: 3
                            fillMode: Image.PreserveAspectFit
                            source: isfolder ? "qrc:/Assets/folder.png" : "qrc:/Assets/video.png"
                        }
                    }

                    Text {
                        id: lblFolderFileText
                        text: name
                        width: fileExplorerGridView.itemWidth
                        height: fileExplorerGridView.itemHeight * 0.20
                        wrapMode: Text.WordWrap
                        elide: Text.ElideRight
                        font.pixelSize: 12
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fileExplorerGridView.currentIndex = model.index
                        if(isfolder){
                            lblFileName.text=""
                            customFilePicker.selectedFileAddress =""
                        } else {
                            lblFileName.text=name
                            customFilePicker.selectedFileAddress = url
                        }
                    }
                    onDoubleClicked: {
                        if(isfolder)
                            vModel.folder = "file://" + url
                    }
                }
            }
        }


        GridView {
            id : fileExplorerGridView
            property int itemWidth: 50
            property int itemHeight: 70
            anchors.fill: parent

            cellWidth: fileExplorerGridView.itemWidth
            cellHeight: fileExplorerGridView.itemHeight
            currentIndex: 0
            clip: true
            focus: true

            model: vModel

            delegate: fileExplorerDelegate

        }
    }

    Rectangle {
        id : rctActionButton
        color: "#cb1d1e18"
        width: parent.width
        height: 46
        anchors.bottom: parent.bottom

        CustomButton {
            x: 90
            y: 6
            width: 77
            height: 35
            title: "OK"
            onClicked: {
                if(customFilePicker.selectedFileAddress !=="") {
                    customFilePicker.visible = false
                    customFilePicker.fileSelected(customFilePicker.selectedFileAddress)
                    customFilePicker.selectedFileAddress=""
                }
            }
        }

        CustomButton {
            x: 8
            y: 6
            width: 77
            height: 35
            title: "Cancel"
            onClicked: {
                customFilePicker.visible = false
            }
        }

        Text {
            id: lblFileName
            x: 173
            y: 8
            width: 319
            height: 30
            color: "#ffffff"
            text: qsTr("")
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 8
            wrapMode: Text.WordWrap
            elide: Text.ElideRight
        }
    }


    VideoFileExplorerModel {
        id : vModel
        folder: "file:///home/safa"
    }

}
