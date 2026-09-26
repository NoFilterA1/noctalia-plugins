import QtQuick
import Quickshell.Io
import qs.Commons

Item {
  id: root
  property var pluginApi: null

  readonly property var cfg: pluginApi?.pluginSettings || ({})
  readonly property var defaults: pluginApi?.manifest?.metadata?.defaultSettings || ({})

  readonly property bool enabled: cfg.enabled ?? defaults.enabled ?? true
  readonly property string targetFileSetting: cfg.targetFile || defaults.targetFile || "~/.config/niri/overview-color-sync.kdl"

  property string home: ""
  readonly property string resolvedTargetFile: root.home !== ""
    ? root.targetFileSetting.replace("~", root.home)
    : ""

  function colorToHex(c) {
    function channel(v) {
      var h = Math.round(v * 255).toString(16)
      return h.length === 1 ? "0" + h : h
    }
    return "#" + channel(c.r) + channel(c.g) + channel(c.b)
  }

  function requestSync() {
    if (!root.enabled || root.resolvedTargetFile === "")
      return
    debounce.restart()
  }

  function writeNow() {
    if (!root.enabled || root.resolvedTargetFile === "" || writeProc.running)
      return

    var hex = root.colorToHex(Color.mSurface)
    writeProc.command = ["python3", "-c",
      "import sys\n" +
      "target, hexColor = sys.argv[1], sys.argv[2]\n" +
      "content = 'overview {\\n    backdrop-color \"' + hexColor + '\"\\n}\\n'\n" +
      "f = open(target, 'w')\n" +
      "f.write(content)\n" +
      "f.close()",
      root.resolvedTargetFile, hex
    ]
    writeProc.running = true
  }

  Timer {
    id: debounce
    interval: 300
    onTriggered: root.writeNow()
  }

  onEnabledChanged: root.requestSync()
  onTargetFileSettingChanged: root.requestSync()

  Connections {
    target: Color
    function onMSurfaceChanged() { root.requestSync() }
  }

  Process {
    id: resolveHome
    command: ["bash", "-c", "echo -n $HOME"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        root.home = data.trim()
        root.requestSync()
      }
    }
  }

  Process {
    id: writeProc
    onExited: exitCode => {
      if (exitCode !== 0)
        Logger.e("niri-overview-color-sync", "Failed to write", root.resolvedTargetFile)
    }
  }
}
