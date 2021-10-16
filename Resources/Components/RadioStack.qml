import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import "../Controls"
import "../Scripts/FrequencyUtils.js" as FrequencyUtils

ColumnLayout {
    property bool simConnected: false

    property var isCom1Rx: false
    property var isCom2Rx: false

    property var isCom1Tx: false
    property var isCom2Tx: false

    property var radioStackState;

    Connections {
        target: xplaneAdapter

        function onSimConnectionStateChanged(state) {
            simConnected = state;
        }

        function onRadioStackStateChanged(stack) {
            if(radioStackState !== stack) {
                radioStackState = stack;
            }
        }

        function onPttPressed() {
            if(radioStackState.Com1TransmitEnabled) {
                isCom1Tx = true
            }
            else if(radioStackState.Com2TransmitEnabled) {
                isCom2Tx = true
            }
        }

        function onPttReleased() {
            isCom1Tx = false
            isCom2Tx = false
        }
    }

    Connections {
        target: audio

        function onRadioRxChanged(radio, state) {
            switch(radio) {
            case 0:
                isCom1Rx = state;
                break;
            case 1:
                isCom2Rx = state;
                break;
            }
        }
    }

    Row {
        id: com1
        spacing: 0
        Layout.leftMargin: 0
        Layout.topMargin: 10
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 35

        Text {
            id: com1Label
            text: qsTr("COM1:")
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 16
            font.bold: true
            font.family: robotoMono.name
            renderType: Text.NativeRendering
        }
        Text {
            id: com1FreqLabel
            text: simConnected && radioStackState.AvionicsPowerOn ? FrequencyUtils.printFrequency(radioStackState.Com1Frequency) : "---.---"
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            leftPadding: 5
            font.pixelSize: 16
            font.family: robotoMono.name
            renderType: Text.NativeRendering
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            rightPadding: 15
        }
        RadioStackIndicator{
            id: com1Tx
            isEnabled: simConnected && radioStackState.AvionicsPowerOn && radioStackState.Com1TransmitEnabled
            isActive: isCom1Tx
            label: "TX"
        }
        Text {
            rightPadding: 5
        }
        RadioStackIndicator{
            id: com1Rx
            isEnabled: simConnected && radioStackState.AvionicsPowerOn && radioStackState.Com1ReceiveEnabled
            isActive: isCom1Rx
            label: "RX"
        }
    }
    // com2
    Row {
        id: com2
        spacing: 0
        Layout.leftMargin: 0
        Layout.bottomMargin: 10
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredHeight: 35

        Text {
            id: com2Label
            text: qsTr("COM2:")
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            font.pixelSize: 16
            font.bold: true
            font.family: robotoMono.name
            renderType: Text.NativeRendering
        }
        Text {
            id: com2FreqLabel
            text: simConnected && radioStackState.AvionicsPowerOn ? FrequencyUtils.printFrequency(radioStackState.Com2Frequency) : "---.---"
            anchors.verticalCenter: parent.verticalCenter
            color: "white"
            leftPadding: 5
            font.pixelSize: 16
            font.family: robotoMono.name
            renderType: Text.NativeRendering
        }
        Text {
            anchors.verticalCenter: parent.verticalCenter
            rightPadding: 15
        }
        RadioStackIndicator{
            id: com2Tx
            isEnabled: simConnected && radioStackState.AvionicsPowerOn && radioStackState.Com2TransmitEnabled
            isActive: isCom2Tx
            label: "TX"
        }
        Text {
            rightPadding: 5
        }
        RadioStackIndicator{
            id: com2Rx
            isEnabled: simConnected && radioStackState.AvionicsPowerOn && radioStackState.Com2ReceiveEnabled
            isActive: isCom2Rx
            label: "RX"
        }
    }
}
