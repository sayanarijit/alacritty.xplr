local function setup(args)
  local xplr = xplr

  -- Parse args
  args = args or {}
  args.mode = args.mode or "default"
  args.key = args.key or "ctrl-n"
  args.send_selection = args.send_selection or true
  args.send_focus = args.send_focus or true
  args.extra_alacritty_args = args.extra_alacritty_args or ""
  args.extra_xplr_args = args.extra_xplr_args or ""

  xplr.fn.custom.alacritty_spawn_window = function(app)
    local cmd = "alacritty " .. args.extra_alacritty_args .. " --command xplr"
    if args.send_focus and app.focused_node then
      cmd = cmd
        .. [[ --on-load 'FocusPath: "]]
        .. app.focused_node.absolute_path
        .. [["']]
    end

    if args.send_selection then
      for _, node in ipairs(app.selection) do
        cmd = cmd
          .. [[ --on-load 'SelectPath: "]]
          .. node.absolute_path
          .. [["']]
      end
    end

    cmd = cmd .. " " .. args.extra_xplr_args .. " &"
    os.execute(cmd)
  end

  local messages = {
    { CallLua = "custom.alacritty_spawn_window" },
    "ExplorePwdAsync",
    "PopMode",
  }

  if args.send_selection then
    table.insert(messages, "ClearSelection")
  end

  xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
    help = "new session",
    messages = messages,
  }
end

return { setup = setup }
