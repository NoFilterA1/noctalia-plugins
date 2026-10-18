import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons

Item {
  id: root
  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings ?? ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings ?? ({})

  readonly property bool vibrantEnabled: cfg.enabled ?? defaults.enabled ?? false
  readonly property int vibranceValue: cfg.vibranceValue ?? defaults.vibranceValue ?? 512
  // stored 1-based (1 = port 0), converted on use
  readonly property int displayIndex: (cfg.displayIndex ?? defaults.displayIndex ?? 1) - 1

  VibranceRunner {
    id: runner
    pluginApi: root.pluginApi
  }

  function applyVibrance(value) {
    runner.apply(value, root.displayIndex)
  }

  function previewLevel(value) {
    if (vibrantEnabled)
      applyVibrance(value)
  }

  function setLevel(value) {
    if (!pluginApi)
      return
    pluginApi.pluginSettings.vibranceValue = value
    pluginApi.saveSettings()
    previewLevel(value)
  }

  function toggle() {
    if (pluginApi) {
      var newEnabled = !vibrantEnabled
      pluginApi.pluginSettings.enabled = newEnabled
      pluginApi.saveSettings()
      applyVibrance(newEnabled ? vibranceValue : 0)
    }
  }

  IpcHandler {
    target: "plugin:nvibrant"
    function toggle() { root.toggle() }
  }
}
