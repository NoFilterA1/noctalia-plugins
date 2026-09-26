import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  property bool editEnabled: cfg.enabled ?? defaults.enabled ?? true
  property string editTargetFile: cfg.targetFile ?? defaults.targetFile ?? ""

  spacing: Style.marginL

  NToggle {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.enabled.label")
    description: pluginApi?.tr("settings.enabled.desc")
    checked: root.editEnabled
    onToggled: checked => {
      root.editEnabled = checked
      root.saveSettings()
    }
  }

  NTextInput {
    Layout.fillWidth: true
    label: pluginApi?.tr("settings.targetFile.label")
    description: pluginApi?.tr("settings.targetFile.desc")
    text: root.editTargetFile
    onTextChanged: {
      root.editTargetFile = text
      root.saveSettings()
    }
  }

  NBox {
    Layout.fillWidth: true
    implicitHeight: setupCol.implicitHeight + Style.marginM * 2

    ColumnLayout {
      id: setupCol
      anchors {
        left: parent.left
        right: parent.right
        top: parent.top
        margins: Style.marginM
      }
      spacing: Style.marginS

      NText {
        Layout.fillWidth: true
        text: pluginApi?.tr("settings.setup.title")
        font.weight: Font.Bold
        color: Color.mOnSurface
      }

      NText {
        Layout.fillWidth: true
        wrapMode: Text.Wrap
        text: pluginApi?.tr("settings.setup.body", { path: root.editTargetFile })
        color: Color.mOnSurfaceVariant
      }
    }
  }

  function saveSettings() {
    if (!pluginApi) {
      Logger.e("niri-overview-color-sync", "Cannot save: pluginApi is null")
      return
    }
    pluginApi.pluginSettings.enabled = root.editEnabled
    pluginApi.pluginSettings.targetFile = root.editTargetFile
    pluginApi.saveSettings()
  }
}
