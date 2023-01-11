local q = xplr.util.shell_quote

local function setup(args)
  local xplr = xplr

  -- Parse args
  args = args or {}
  args.mode = args.mode or "default"
  args.key = args.key or "ctrl-n"
  args.xplr_bin = args.xplr_bin or "xplr"
  args.alacritty_bin = args.alacritty_bin or "alacritty"
  args.extra_alacritty_args = args.extra_alacritty_args or ""
  args.extra_xplr_args = args.extra_xplr_args or ""

  if args.send_selection == nil then
    args.send_selection = true
  end

  if args.send_focus == nil then
    args.send_focus = true
  end

  if args.send_vroot == nil then
    args.send_vroot = true
  end

  xplr.fn.custom.alacritty = {}
  xplr.fn.custom.alacritty.spawn_window = function(app)
    local cmd = q(args.alacritty_bin)
      .. " "
      .. args.extra_alacritty_args
      .. " --command "
      .. q(args.xplr_bin)
      .. " --on-load ClearNodeFilters ClearNodeSorters"

    for _, x in ipairs(app.explorer_config.filters) do
      local msg = { AddNodeFilter = { filter = x.filter, input = x.input } }
      msg = xplr.util.to_json(msg)
      cmd = cmd .. " " .. xplr.util.shell_quote(msg)
    end

    for _, x in ipairs(app.explorer_config.sorters) do
      local msg = { AddNodeSorter = { sorter = x.sorter, reverse = x.reverse } }
      msg = xplr.util.to_json(msg)
      cmd = cmd .. " " .. xplr.util.shell_quote(msg)
    end

    cmd = cmd .. " ExplorePwd"

    cmd = cmd .. " " .. args.extra_xplr_args

    if args.send_vroot and app.vroot then
      cmd = cmd .. " --vroot " .. q(app.vroot)
    end

    if args.send_focus and app.focused_node then
      cmd = cmd .. " --force-focus -- " .. q(app.focused_node.absolute_path)
    else
      cmd = cmd .. " -- " .. q(app.pwd)
    end

    if args.send_selection then
      for _, node in ipairs(app.selection) do
        cmd = cmd .. " " .. q(node.absolute_path)
      end
    end

    cmd = cmd .. " &"
    os.execute(cmd)
  end

  local messages = {
    { CallLuaSilently = "custom.alacritty.spawn_window" },
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
