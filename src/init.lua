local function setup(args)
  local xplr = xplr

  -- Parse args
  args = args or {}
  args.mode = args.mode or "default"
  args.key = args.key or "ctrl-n"
  args.extra_alacritty_args = args.extra_alacritty_args or ""
  args.extra_xplr_args = args.extra_xplr_args or ""

  if args.send_selection == nil then
    args.send_selection = true
  end

  if args.send_focus == nil then
    args.send_focus = true
  end

  xplr.fn.custom.alacritty_spawn_window = function(app)
    local cmd = "alacritty " .. args.extra_alacritty_args .. " --command xplr"
    cmd = cmd .. " --on-load ClearNodeFilters ClearNodeSorters"

    for _, x in ipairs(app.explorer_config.filters) do
      cmd = cmd
        .. [[ 'AddNodeFilter: { filter: "]]
        .. x.filter
        .. [[", input: "]]
        .. x.input
        .. [[" }']]
    end

    for _, x in ipairs(app.explorer_config.sorters) do
      cmd = cmd
        .. [[ 'AddNodeSorter: { sorter: "]]
        .. x.sorter
        .. [[", reverse: ]]
        .. tostring(x.reverse)
        .. [[ }']]
    end

    cmd = cmd .. " ExplorePwd"

    if args.send_focus and app.focused_node then
      cmd = cmd
        .. [[ 'FocusPath: "]]
        .. app.focused_node.absolute_path
        .. [["']]
    end

    if args.send_selection then
      for _, node in ipairs(app.selection) do
        cmd = cmd .. [[ 'SelectPath: "]] .. node.absolute_path .. [["']]
      end
    end

    cmd = cmd .. " " .. args.extra_xplr_args .. " &"

    os.execute(cmd)
  end

  local messages = {
    { CallLuaSilently = "custom.alacritty_spawn_window" },
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
