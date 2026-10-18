import QtQuick
import QtQuick.Layouts
import qs.Commons
import qs.Widgets

ColumnLayout {
  id: root
  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings ?? ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings ?? ({})

  spacing: Style.marginM

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS

    NLabel {
      label: pluginApi?.tr("settings.vibrance-value")
      description: pluginApi?.tr("settings.vibrance-value-desc")
    }

    RowLayout {
      Layout.fillWidth: true
      spacing: Style.marginM

      NSlider {
        id: vibranceSlider
        Layout.fillWidth: true
        from: 0
        to: 1023
        stepSize: 1
        value: root.cfg.vibranceValue ?? root.defaults.vibranceValue ?? 512
      }

      NText {
        text: Math.round(vibranceSlider.value).toString()
        Layout.preferredWidth: Style.baseWidgetSize * 1.5 * Style.uiScaleRatio
        horizontalAlignment: Text.AlignRight
      }
    }
  }

  NDivider {
    Layout.fillWidth: true
    Layout.topMargin: Style.marginM
    Layout.bottomMargin: Style.marginM
  }

  ColumnLayout {
    Layout.fillWidth: true
    spacing: Style.marginS

    NLabel {
      label: pluginApi?.tr("settings.display-index")
      description: pluginApi?.tr("settings.display-index-desc")
    }

    NSpinBox {
      id: displayIndexSpinBox
      from: 1
      to: 8
      stepSize: 1
      value: root.cfg.displayIndex ?? root.defaults.displayIndex ?? 1
    }
  }

  function saveSettings() {
    if (!pluginApi) return
    pluginApi.pluginSettings.vibranceValue = Math.round(vibranceSlider.value)
    pluginApi.pluginSettings.displayIndex  = displayIndexSpinBox.value
    pluginApi.saveSettings()

    // re-apply right away so the new level shows up if vibrance is currently on
    var main = pluginApi.mainInstance
    if (main && pluginApi.pluginSettings.enabled)
      main.applyVibrance(pluginApi.pluginSettings.vibranceValue)
  }
}
