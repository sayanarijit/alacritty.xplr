[![alacritty-xplr.gif](https://s9.gifyu.com/images/alacritty-xplr.gif)](https://gifyu.com/image/GJGU)

> **TIP:** Use it with [xclip.xplr](https://github.com/sayanarijit/xclip.xplr) for better copy-paste experience.


Requirements
------------

- [Alacritty](https://github.com/alacritty/alacritty)


Installation
------------

### Install manually

- Add the following line in `~/.config/xplr/init.lua`

  ```lua
  package.path = os.getenv("HOME") .. '/.config/xplr/plugins/?/src/init.lua'
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
    extra_alacritty_args = "",
    extra_xplr_args = "",
  }

  -- Press `ctrl-n` to spawn a new alacritty window with the current selection
  ```


Features
--------

- Send current focus to the new session.
- Send current selection to the new session.
