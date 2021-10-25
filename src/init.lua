local function setup(args)
    local xplr = xplr

    -- Parse args
    args = args or {}
    args.exe = args.exe or 'alacritty'
    args.exe_launch = args.exe_launch or (args.exe == 'alacritty' and '--command' or nil)
    args.mode = args.mode or 'default'
    args.key = args.key or 'ctrl-n'
    args.extra_term_args = args.extra_term_args or ''
    args.extra_xplr_args = args.extra_xplr_args or ''

    xplr.fn.custom.term_spawn_window = function(app)
        local cmd = args.exe .. ' '
        if args.extra_term_args then
            cmd = cmd .. args.extra_term_args .. ' '
        end
        if args.exe_launch then
            cmd = cmd .. args.exe_launch .. ' '
        end
        cmd = cmd .. 'xplr --on-load ClearNodeFilters ClearNodeSorters'

        for _, x in ipairs(app.explorer_config.filters) do
            cmd = cmd .. [[ 'AddNodeFilter: { filter: "]] .. x.filter .. [[", input: "]] .. x.input .. [[" }']]
        end

        for _, x in ipairs(app.explorer_config.sorters) do
            cmd = cmd
                .. [[ 'AddNodeSorter: { sorter: "]]
                .. x.sorter
                .. [[", reverse: ]]
                .. tostring(x.reverse)
                .. [[ }']]
        end

        cmd = cmd .. ' ExplorePwd'

        if args.send_focus and app.focused_node then
            cmd = cmd .. [[ 'FocusPath: "]] .. app.focused_node.absolute_path .. [["']]
        end

        if args.send_selection then
            for _, node in ipairs(app.selection) do
                cmd = cmd .. [[ 'SelectPath: "]] .. node.absolute_path .. [["']]
            end
        end

        cmd = cmd .. ' ' .. args.extra_xplr_args .. ' &'

        os.execute(cmd)
    end

    local messages = {
        { CallLuaSilently = 'custom.term_spawn_window' },
        'PopMode',
    }

    if args.send_selection then
        table.insert(messages, 'ClearSelection')
    end

    xplr.config.modes.builtin[args.mode].key_bindings.on_key[args.key] = {
        help = 'new session',
        messages = messages,
    }
end

return { setup = setup }
