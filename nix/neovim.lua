local dap = require('dap')
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "attach",
    processId = function()
        local cmd="netstat -nlp | grep 127.0.0.1:$(jq '.profiles | values[] | .applicationUrl' Properties/launchSettings.json | sed -rn 's/.*http:\\/\\/localhost:([0-9]+).*/\\1/p' | head -n 1) | sed -rn 's/.* ([0-9]+)\\/Reply.Ferrar.*/\\1/p' | head -n 1"
        local handle=io.popen(cmd)
        local result=handle:read("*a")
        print(result)
        handle:close()
        return result
    end,
  },
}
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "''${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end;
  },
}



vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.incsearch = true
vim.opt.shortmess:remove({ 'S' })
vim.opt.colorcolumn = "90"
vim.opt.list = true
vim.wo.relativenumber = true
vim.keymap.set('n', '<Leader>e', '<cmd>Yazi<cr>')
vim.keymap.set('n', '<Leader>f', '<cmd>Format<cr>')
vim.keymap.set('n', '<Leader>m', '<cmd>Trouble diagnostics toggle focus=true<cr>')
vim.keymap.set('n', "<Leader>/", '<cmd>Telescope live_grep<cr>')
vim.keymap.set('v', "<Leader>/", '<cmd>Telescope grep_string<cr>')
vim.keymap.set('n', "<Leader>d", '<cmd>Telescope git_files<cr>')
vim.keymap.set('n', "<Leader>l", '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', "<Leader>g", '<cmd>LazyGit<cr>')
vim.keymap.set('n', "<Leader>bb", '<cmd>DapToggleBreakpoint<cr>')
vim.keymap.set('n', "<Leader>br", '<cmd>DapNew<cr>')
vim.keymap.set('n', "<Leader>bc", '<cmd>DapContinue<cr>')
vim.keymap.set('n', "<Leader>bn", '<cmd>DapStepOver<cr>')
vim.keymap.set('n', "<Leader>bi", '<cmd>DapStepInto<cr>')
vim.keymap.set('n', "<Leader>bo", '<cmd>DapStepOut<cr>')
vim.keymap.set('n', "<Leader>bv", '<cmd>DapViewToggle<cr>')
vim.keymap.set('n', "<Leader>bt", '<cmd>DapTerminate<cr>')
vim.keymap.set('n', "<esc>", '<cmd>nohlsearch<cr>')
-- vim.keymap.set('n', "<Leader>i", vim.lsp.buf.hover)
vim.keymap.set('n', '<Leader>r', vim.lsp.buf.rename)
-- vim.keymap.set('n', '<Leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<Leader>p', MiniMap.toggle)
vim.keymap.set('n', "<Leader>o", '<cmd>Outline<cr>')
vim.keymap.set({'n','v'}, "<Leader>.", vim.lsp.buf.code_action)
vim.keymap.set("n","s",function() require("flash").jump() end)
-- function _G.set_terminal_keymaps()
--     local opts = {buffer = 0}
--     vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
-- end
-- vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
-- vim.env.NVIM_SERVER=vim.v.servername
vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.cmd [[colorscheme tokyonight-night]]
vim.o.splitright=true
vim.o.splitbelow=true
-- vim.api.nvim_create_autocmd('TermOpen', {
--     pattern = { '*' },
--     callback = function()
--         vim.opt.number = false
--     end,
--     group = generalSettingsGroup,
-- })
vim.cmd [[highlight DiagnosticUnderlineError ctermfg=red guifg=red]]
vim.cmd [[highlight DiagnosticUnderlineWarn ctermfg=yellow guifg=yellow]]
vim.cmd [[highlight DiagnosticUnderlineInfo ctermfg=lightblue guifg=lightblue]]
-- vim.cmd [[highlight DiagnosticUnderlineHint ctermfg=red guifg=red]]

-- vim.keymap.set({"n","v"},"hh","<nop>")
-- vim.keymap.set({"n","v"},"ll","<nop>")
vim.keymap.set({"n","v","i"},"<Up>","<nop>")
vim.keymap.set({"n","v","i"},"<Down>","<nop>")
vim.keymap.set({"n","v","i"},"<Left>","<nop>")
vim.keymap.set({"n","v","i"},"<Right>","<nop>")
-- vim.keymap.set("n","x","<nop>")
-- vim.keymap.set("i","<BS>","<nop>")
-- vim.keymap.set("i","<Del>","<nop>")
vim.keymap.set("i","jk","<Esc>")
vim.keymap.set("i","kj","<Esc>")
vim.keymap.set("i","jj","<Esc>")
vim.keymap.set("i","kk","<Esc>")

vim.api.nvim_set_hl(0, "red",   { fg = "#ff0000" }) 
vim.api.nvim_set_hl(0, "green",  { fg = "#00ff00" }) 

vim.fn.sign_define('DapBreakpoint', { text='@', texthl='red',   linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text='>', texthl='green',  linehl='DapBreakpoint', numhl='DapBreakpoint' })
