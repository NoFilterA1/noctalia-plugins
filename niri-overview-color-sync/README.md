# Niri Overview Color Sync

Keeps the solid backdrop color behind niri's Overview (`Mod+Tab`) in sync with the
currently active Noctalia palette, instead of niri's static default. When your
wallpaper changes and Noctalia regenerates its Material palette, the Overview
backdrop updates with it automatically.

This plugin never edits your main `config.kdl`. It writes a small standalone
`overview { backdrop-color "..."; }` file and expects you to `include` it from
your niri config once — see Setup below.

## Features

- **Follows the active palette** — reacts to Noctalia's `mSurface` color, no polling
- **Never touches your main config** — writes only to its own dedicated KDL file
- **Configurable target file** — point it anywhere in your niri config tree

## Setup

1. Enable the plugin, then open its settings to see the target file path
   (default: `~/.config/niri/overview-color-sync.kdl`).
2. If you already have an `overview { ... }` block in your `config.kdl`, remove it.
3. Add this line to `config.kdl` instead:
   ```kdl
   include "~/.config/niri/overview-color-sync.kdl"
   ```
4. Save. niri reloads its config automatically.

## Configuration

Open the plugin settings to configure:

| Setting | Default | Description |
|---|---|---|
| Enabled | `true` | Turn the sync on or off |
| Target file | `~/.config/niri/overview-color-sync.kdl` | File the plugin writes the `overview` block to |

## Requirements

- Noctalia Shell 4.6.6+
- niri with the `overview { backdrop-color }` config option
- `python3` on `PATH` (used to write the target file)
