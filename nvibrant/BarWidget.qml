import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Commons
import qs.Commons as NC
import qs.Widgets
import qs.Services.UI

Item {
  id: root

  property var pluginApi: null
  property ShellScreen screen
  property string widgetId: ""
  property string section: ""
  property int sectionWidgetIndex: -1
  property int sectionWidgetsCount: 0

  readonly property var cfg: pluginApi?.pluginSettings ?? ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings ?? ({})

  readonly property bool vibrantEnabled: cfg.enabled ?? defaults.enabled ?? false
  readonly property int vibranceValue: cfg.vibranceValue ?? defaults.vibranceValue ?? 512
  readonly property int displayIndex: (cfg.displayIndex ?? defaults.displayIndex ?? 1) - 1

  readonly property real contentWidth: Style.capsuleHeight
  readonly property real contentHeight: Style.capsuleHeight

  implicitWidth: contentWidth
  implicitHeight: contentHeight

  Rectangle {
    id: visualCapsule
    x: Style.pixelAlignCenter(parent.width, width)
    y: Style.pixelAlignCenter(parent.height, height)
    width: root.contentWidth
    height: root.contentHeight
    radius: Style.radiusL
    color: mouseArea.containsMouse ? NC.Color.mHover : Style.capsuleColor
    border.color: Style.capsuleBorderColor
    border.width: Style.capsuleBorderWidth

    NIcon {
      anchors.centerIn: parent
      icon: "contrast"
      applyUiScale: false
      color: root.vibrantEnabled
        ? NC.Color.mPrimary
        : (mouseArea.containsMouse ? NC.Color.mOnHover : NC.Color.mOnSurface)
    }
  }

  MouseArea {
    id: mouseArea
    anchors.fill: parent
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    onClicked: (mouse) => {
      if (mouse.button === Qt.LeftButton) {
        pluginApi?.togglePanel(root.screen, root)
      } else if (mouse.button === Qt.RightButton) {
        pluginApi?.mainInstance?.toggle()
      }
    }
  }
}
