[![alacritty-xplr.gif](https://s9.gifyu.com/images/alacritty-xplr.gif)](https://gifyu.com/image/GJGU)

> **TIP:** Use it with [xclip.xplr](https://github.com/sayanarijit/xclip.xplr) for better copy-paste experience.

## Requirements

- [Alacritty](https://github.com/alacritty/alacritty)

## Installation

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  local home = os.getenv("HOME")
  package.path = home
  .. "/.config/xplr/plugins/?/init.lua;"
  .. home
  .. "/.config/xplr/plugins/?.lua;"
  .. package.path
  ```

- Clone the plugin

  ```bash
  mkdir -p ~/.config/xplr/plugins

  git clone https://github.com/sayanarijit/alacritty.xplr ~/.config/xplr/plugins/alacritty
  ```

- Require the module in `~/.config/xplr/init.lua`

  ```lua
  require("alacritty").setup()

  -- Or

  require("alacritty").setup{
    mode = "default",
    key = "ctrl-n",
    send_focus = true,
    send_selection = true,
    send_vroot = true,
    alacritty_bin = "alacritty",
    extra_alacritty_args = "",
    xplr_bin = "xplr",
    extra_xplr_args = "",
  }

  -- Press `ctrl-n` to spawn a new alacritty window with the current selection
  ```

## Features

- Send current focus to the new session.
- Send current selection to the new session.
- Send active sorters and filters to the new session.
- Send current vroot
