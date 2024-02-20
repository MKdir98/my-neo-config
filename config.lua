-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
require 'lspconfig'.phpactor.setup {}
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.cmd([[set relativenumber]])
vim.cmd([[set termbidi]])
lvim.keys.normal_mode["gt"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["gT"] = ":BufferLineCyclePrev<CR>"
lvim.keys.normal_mode["<Tab>"] = ":bnext<CR>"
lvim.keys.normal_mode["<S-Tab>"] = ":bprev<CR>"
lvim.keys.normal_mode["|"] = ":vsplit<CR>"
lvim.keys.normal_mode["-"] = ":split<CR>"
local neotest_opts = {
    -- Can be a list of adapters like what neotest expects,
    -- or a list of adapter names,
    -- or a table of adapter names, mapped to adapter configs.
    -- The adapter will then be automatically loaded with the config.
    adapters = {},
    -- Example for loading neotest-go with a custom config
    -- adapters = {
    --   ["neotest-go"] = {
    --     args = { "-tags=integration" },
    --   },
    -- },
    status = { virtual_text = true },
    output = { open_on_run = true },
    quickfix = {
        open = function()
            if require("lazyvim.util").has("trouble.nvim") then
                require("trouble").open({ mode = "quickfix", focus = false })
            else
                vim.cmd("copen")
            end
        end,
    },
}

local dap_opts = {
    adapter = {
        type = "executable",
        command = "dap-go",
        args = { "-c", "b", "--", vim.fn.expand("%:p") },
    },
}

local which_key_opts = {
    defaults = {
        ["<leader>t"] = { name = "+test" },
    },
    plugins = {
        nvim_tree = {
            ["<CR>"] = "Open",
        },
    },
}

local neotest_keys = {
    { "<leader>tt", function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File" },
    { "<leader>tB", function() require("neotest").run.run({ path = vim.loop.cwd() }) end,               desc = "Run test with Battery" },
    { "<leader>tT", function() require("neotest").run.run(vim.loop.cwd()) end,                          desc = "Run All Test Files" },
    { "<leader>tr", function() require("neotest").run.run() end,                                        desc = "Run Nearest" },
    { "<leader>ts", function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel" },
    { "<leader>tS", function() require("neotest").run.stop() end,                                       desc = "Stop" },
}

local trouble_keys = {
    { "<leader>xx", function() require("trouble").toggle() end,                        desc = "" },
    { "<leader>xw", function() require("trouble").toggle("workspace_diagnostics") end, desc = "" },
    { "<leader>xd", function() require("trouble").toggle("document_diagnostics") end,  desc = "" },
    { "<leader>xq", function() require("trouble").toggle("quickfix") end,              desc = "" },
    { "<leader>xl", function() require("trouble").toggle("loclist") end,               desc = "" },
    { "gR",         function() require("trouble").toggle("lsp_references") end,        desc = "" },
}

local dap_keys = {
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug Nearest" },
}

local trouble_vim_opts = {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    severity = nil, -- nil (ALL) or vim.diagnostic.severity.ERROR | WARN | INFO | HINT
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    cycle_results = true, -- cycle item list when reaching beginning or end of list
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q",                                                                      -- close the list
        cancel = "<esc>",                                                                 -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r",                                                                    -- manually refresh
        jump = { "<cr>", "<tab>", "<2-leftmouse>" },                                      -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" },                                                         -- open buffer in new split
        open_vsplit = { "<c-v>" },                                                        -- open buffer in new vsplit
        open_tab = { "<c-t>" },                                                           -- open buffer in new tab
        jump_close = { "o" },                                                             -- jump to the diagnostic and close the list
        toggle_mode = "m",                                                                -- toggle between "workspace" and "document" diagnostics mode
        switch_severity = "s",                                                            -- switch "diagnostics" severity filter level to HINT / INFO / WARN / ERROR
        toggle_preview = "P",                                                             -- toggle auto_preview
        hover = "K",                                                                      -- opens a small popup with the full multiline message
        preview = "p",                                                                    -- preview the diagnostic location
        open_code_href = "c",                                                             -- if present, open a URI with more information about the diagnostic error
        close_folds = { "zM", "zm" },                                                     -- close all folds
        open_folds = { "zR", "zr" },                                                      -- open all folds
        toggle_fold = { "zA", "za" },                                                     -- toggle fold of current file
        previous = "k",                                                                   -- previous item
        next = "j",                                                                       -- next item
        help = "?"                                                                        -- help menu
    },
    multiline = true,                                                                     -- render multi-line messages
    indent_lines = true,                                                                  -- add an indent guide below the fold icons
    win_config = { border = "single" },                                                   -- window configuration for floating windows. See |nvim_open_win()|.
    auto_open = false,                                                                    -- automatically open the list when you have diagnostics
    auto_close = false,                                                                   -- automatically close the list when you have no diagnostics
    auto_preview = true,                                                                  -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false,                                                                    -- automatically fold a file trouble list at creation
    auto_jump = { "lsp_definitions" },                                                    -- for the given modes, automatically jump if there is only a single result
    include_declaration = { "lsp_references", "lsp_implementations", "lsp_definitions" }, -- for the given modes, include the declaration of the current symbol in the results
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
    },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
}

lvim.plugins = {
    {
        "folke/which-key.nvim",
        opts = which_key_opts,
    },
    {
        "nvim-neotest/neotest",
        opts = neotest_opts,
        keys = neotest_keys,
    },
    {
        "olimorris/neotest-phpunit",
        config = function()
            require("neotest").setup({
                adapters = { require("neotest-phpunit")({
                    env = {
                        XDEBUG_CONFIG = "idekey=neotest",
                    },
                    dap = require('dap').configurations.php[1],
                }) },
            })
        end,
    },
    {
        "mfussenegger/nvim-dap",
        opts = dap_opts,
        keys = dap_keys,
    },
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = trouble_vim_opts,
        keys = trouble_keys,
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
    }
}
require('dap').adapters.php = {
    type = 'executable',
    command = 'node',
    args = { '/home/mahdi/all/tools/runtime/vscode-php-debug/out/phpDebug.js' }
}

require('dap').configurations.php = {
    {
        log = true,
        type = "php",
        request = "launch",
        name = "Listen for XDebug",
        port = 9003,
        stopOnEntry = false,
        xdebugSettings = {
            max_children = 512,
            max_data = 1024,
            max_depth = 4,
        },
        breakpoints = {
            exception = {
                Notice = false,
                Warning = false,
                Error = false,
                Exception = false,
                ["*"] = false,
            },
        },
    }
}

require('dap').adapters.python = {
    type = 'executable',
    command = 'python3',
    args = { '-m', 'debugpy.adapter' },
}

require('dap').configurations.python = {
    {
        type = 'python',
        request = 'launch',
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
            local cwd = vim.fn.getcwd()
            if vim.fn.glob(cwd .. '/venv/bin/python') ~= '' then
                return cwd .. '/venv/bin/python'
            elseif vim.fn.glob(cwd .. '/.venv/bin/python') ~= '' then
                return cwd .. '/.venv/bin/python'
            else
                return '/usr/bin/python3'
            end
        end,
    },
}

local actions = require("telescope.actions")
local trouble = require("trouble.providers.telescope")

local telescope = require("telescope")

telescope.setup {
    defaults = {
        mappings = {
            i = { ["<c-t>"] = trouble.open_with_trouble },
            n = { ["<c-t>"] = trouble.open_with_trouble },
        },
    },
}


local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.black,
    },
})
