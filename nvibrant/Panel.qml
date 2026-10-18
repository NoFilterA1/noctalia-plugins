import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Commons as NC
import qs.Services.UI
import qs.Widgets

Item {
  id: root

  property var pluginApi: null
  readonly property var geometryPlaceholder: panelContainer
  readonly property bool allowAttach: true

  readonly property var mainInstance: pluginApi?.mainInstance
  readonly property bool vibrantEnabled: mainInstance?.vibrantEnabled ?? false
  readonly property int vibranceValue: mainInstance?.vibranceValue ?? 512

  property real contentPreferredWidth: 340 * Style.uiScaleRatio
  property real contentPreferredHeight: content.implicitHeight + Style.marginL * 2

  anchors.fill: parent

  Rectangle {
    id: panelContainer
    anchors.fill: parent
    color: "transparent"

    ColumnLayout {
      id: content
      anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        margins: Style.marginL
      }
      spacing: Style.marginM

      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginS

        NIcon {
          icon: "contrast"
          pointSize: Style.fontSizeL
          color: root.vibrantEnabled ? NC.Color.mPrimary : NC.Color.mOnSurface
        }

        NText {
          text: pluginApi?.tr("panel.title")
          font.weight: Style.fontWeightBold
          Layout.fillWidth: true
        }

        NIconButton {
          icon: root.vibrantEnabled ? "eye" : "eye-off"
          tooltipText: root.vibrantEnabled ? pluginApi?.tr("panel.disable-vibrance") : pluginApi?.tr("panel.enable-vibrance")
          onClicked: root.mainInstance?.toggle()
        }

        NIconButton {
          icon: "settings"
          tooltipText: pluginApi?.tr("panel.settings")
          onClicked: {
            var screen = pluginApi?.panelOpenScreen
            if (screen && pluginApi?.manifest) {
              pluginApi.closePanel(screen)
              BarService.openPluginSettings(screen, pluginApi.manifest)
            }
          }
        }
      }

      RowLayout {
        Layout.fillWidth: true
        spacing: Style.marginM

        NSlider {
          id: levelSlider
          Layout.fillWidth: true
          from: 0
          to: 1023
          stepSize: 1
          value: root.vibranceValue

          // live preview while dragging; the level is saved on release
          onMoved: previewTimer.restart()
          onPressedChanged: {
            if (!pressed)
              root.mainInstance?.setLevel(Math.round(value))
          }
        }

        NText {
          text: Math.round(levelSlider.value).toString()
          Layout.preferredWidth: Style.baseWidgetSize * 1.5 * Style.uiScaleRatio
          horizontalAlignment: Text.AlignRight
        }
      }
    }
  }

  Timer {
    id: previewTimer
    interval: 120
    onTriggered: root.mainInstance?.previewLevel(Math.round(levelSlider.value))
  }
}
