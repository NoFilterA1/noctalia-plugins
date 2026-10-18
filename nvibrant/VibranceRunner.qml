import QtQuick
import Quickshell.Io
import qs.Services.UI

// Applies saturation via nvibrant (NVIDIA outputs) or niri color-matrix (other outputs, e.g. the laptop panel),
// and reports why nothing changed.
Item {
  id: root
  property var pluginApi: null

  readonly property string scriptPath: (pluginApi?.pluginDir ?? "") + "/apply.sh"

  property var queued: null

  function apply(value, displayIndex) {
    if (proc.running) {
      queued = [value, displayIndex]
      return
    }
    proc.command = ["bash", scriptPath, value.toString(), displayIndex.toString()]
    proc.running = true
  }

  Process {
    id: proc
    onExited: (code) => {
      if (root.queued) {
        var q = root.queued
        root.queued = null
        root.apply(q[0], q[1])
        return
      }
      if (code === 3) {
        ToastService.showWarning(pluginApi?.tr("toast.no-nvidia-title"), pluginApi?.tr("toast.no-nvidia-desc"))
      } else if (code === 5) {
        ToastService.showWarning(pluginApi?.tr("toast.no-ctm-title"), pluginApi?.tr("toast.no-ctm-desc"))
      } else if (code !== 0) {
        ToastService.showError(pluginApi?.tr("toast.failed-title"), pluginApi?.tr("toast.failed-desc"))
      }
    }
  }
}
