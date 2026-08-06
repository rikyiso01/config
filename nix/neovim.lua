vim.opt.termguicolors = true
local lsp_capabilities=require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("basedpyright",{capabilities=lsp_capabilities,settings={basedpyright={analysis={typeCheckingMode="strict",stubPath="/home/riky/backup/Documents/Projects/Python/common-stubs",extraPaths={"typings"}}}}})
vim.lsp.enable("basedpyright")
-- vim.lsp.config("ruff",{capabilities=lsp_capabilities,cmd={"${pkgs.ruff}/bin/ruff","server","--preview"}})
-- vim.lsp.enable("ruff")
vim.lsp.config("nil_ls",{capabilities=lsp_capabilities})
vim.lsp.enable("nil_ls")
vim.lsp.config("bashls",{capabilities=lsp_capabilities})
vim.lsp.enable("bashls")
vim.lsp.config("hls",{capabilities=lsp_capabilities})
vim.lsp.enable("hls")
vim.lsp.config("dockerls",{capabilities=lsp_capabilities})
vim.lsp.enable("dockerls")
vim.lsp.config("yamlls",{capabilities=lsp_capabilities})
vim.lsp.enable("yamlls")
vim.lsp.config("jdtls",{capabilities=lsp_capabilities})
vim.lsp.enable("jdtls")
vim.lsp.config("kotlin_language_server",{capabilities=lsp_capabilities})
vim.lsp.enable("kotlin_language_server")
vim.lsp.config("ts_ls",{capabilities=lsp_capabilities})
vim.lsp.enable("ts_ls")
vim.lsp.config("eslint",{capabilities=lsp_capabilities})
vim.lsp.enable("eslint")
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
vim.lsp.config("jsonls",{capabilities=lsp_capabilities})
vim.lsp.enable("jsonls")
vim.lsp.config("taplo",{capabilities=lsp_capabilities})
vim.lsp.enable("taplo")
vim.lsp.config("lemminx",{capabilities=lsp_capabilities})
vim.lsp.enable("lemminx")
vim.lsp.config("psalm",{capabilities=lsp_capabilities})
vim.lsp.enable("psalm")
vim.lsp.config("intelephense",{capabilities=lsp_capabilities})
vim.lsp.enable("intelephense")
vim.lsp.config("cssls",{capabilities=lsp_capabilities})
vim.lsp.enable("cssls")
vim.lsp.config("rust_analyzer",{capabilities=lsp_capabilities,cmd={"rust-analyzer"},settings={['rust-analyzer']={check={command='clippy'}}}})
vim.lsp.enable("rust_analyzer")
vim.lsp.config("dartls",{capabilities=lsp_capabilities})
vim.lsp.enable("dartls")
vim.lsp.config("ltex_plus",{capabilities=lsp_capabilities,settings={ltex={language="auto"},additionalRules={languageModel="/home/riky/.ngrams"}}})
vim.lsp.enable("ltex_plus")
vim.lsp.config("dhall_lsp_server",{capabilities=lsp_capabilities})
vim.lsp.enable("dhall_lsp_server")
vim.lsp.config("clangd",{capabilities=lsp_capabilities})
vim.lsp.enable("clangd")
vim.lsp.config("solargraph",{capabilities=lsp_capabilities})
vim.lsp.enable("solargraph")
vim.lsp.config("elp",{capabilities=lsp_capabilities})
vim.lsp.enable("elp")
vim.lsp.config("postgres_lsp",{capabilities=lsp_capabilities})
vim.lsp.enable("postgres_lsp")
-- vim.lsp.config("astro",{capabilities=lsp_capabilities,cmd={"${pkgs.astro-language-server}/bin/astro-ls","--stdio"},init_options={typescript={tsdk="${pkgs.typescript}/lib/node_modules/typescript/lib"}}})
-- vim.lsp.enable("astro")
vim.lsp.config("lua_ls",{capabilities=lsp_capabilities})
vim.lsp.enable("lua_ls")
vim.lsp.config("csharp_ls",{capabilities=lsp_capabilities,filetypes={"cs","razor"},cmd=function(dispatchers, config)
    return vim.lsp.rpc.start({ 'csharp-ls',"-f","razor-support" }, dispatchers, {
      cwd = config.cmd_cwd or config.root_dir,
      env = config.cmd_env,
      detached = config.detached,
    })
end})
vim.lsp.enable("csharp_ls")

require("lualine").setup()
require('nvim-autopairs').setup{}
require("formatter").setup{
    filetype={
        python={function()return {exe="ruff",args={"format","-"},stdin=true} end},
        haskell={function()return {exe="fourmolu",args={"--no-cabal","-"},stdin=true} end},
        java={function()return {exe="google-java-format",args={"-"},stdin=true} end},
        kotlin={function()return {exe="ktfmt",args={"-"},stdin=true} end},
        javascript={function()return {exe="prettier",args={"--stdin-filepath=test.js"},stdin=true} end},
        typescript={function()return {exe="prettier",args={"--stdin-filepath=test.ts"},stdin=true} end},
        typescriptreact={function()return {exe="prettier",args={"--stdin-filepath=test.tsx"},stdin=true} end},
        json={function()return {exe="prettier",args={"--stdin-filepath=test.json"},stdin=true} end},
        jsonc={function()return {exe="prettier",args={"--stdin-filepath=test.jsonc"},stdin=true} end},
        yaml={function()return {exe="prettier",args={"--stdin-filepath=test.yml"},stdin=true} end},
        markdown={function()return {exe="prettier",args={"--stdin-filepath=test.md"},stdin=true} end},
        html={function()return {exe="prettier",args={"--stdin-filepath=test.html"},stdin=true} end},
        htmldjango={function()return {exe="prettier",args={"--stdin-filepath=test.html"},stdin=true} end},
        css={function()return {exe="prettier",args={"--stdin-filepath=test.css"},stdin=true} end},
        graphql={function()return {exe="prettier",args={"--stdin-filepath=test.graphql"},stdin=true} end},
        xml={function()return {exe="tidy",args={"-i","-xml"},stdin=true} end},
        nix={function()return {exe="nixpkgs-fmt",stdin=true} end},
        bash={function()return {exe="shfmt",stdin=true} end},
        dockerfile={function()return {exe="dockerfmt",stdin=true} end},
        toml={function()return {exe="taplo",args={"fmt","-"},stdin=true} end},
        arduino={function()return {exe="clang-format",stdin=true} end},
        c={function()return {exe="clang-format",stdin=true} end},
        cpp={function()return {exe="clang-format",stdin=true} end},
        rust={function()return {exe="rustfmt",stdin=true} end},
        dart={function()return {exe="dart",args={"format"},stdin=false} end},
        dhall={function()return {exe="dhall",args={"format"},stdin=true} end},
        just={function()return {exe="just",args={"--dump"},stdin=true} end},
        ruby={function()return {exe="rufo",args={"--simple-exit"},stdin=true} end},
        cs={function()return {exe="dotnet-csharpier",stdin=true} end},
        -- astro={function()return {exe="${pkgs.prettier}/bin/prettier",args={"--plugin=${pkgs.vscode-extensions.astro-build.astro-vscode}/share/vscode/extensions/astro-build.astro-vscode/node_modules/prettier-plugin-astro/dist/index.js","--stdin-filepath=test.astro"},stdin=true} end},
        erlang={function()return {exe="erlfmt",args={"-"},stdin=true} end},
    }
}
vim.api.nvim_create_autocmd({'BufLeave'},{command='silent! wa'})
require('mini.map').setup{integrations={require('mini.map').gen_integration.diagnostic()}}
require("trouble").setup{icons={},warn_no_results = false,open_no_results = true,preview={type="main",size={width=0.8}}}
vim.opt.completeopt = {'menu', 'menuone', 'noselect'}
local cmp=require("cmp")
cmp.setup{
snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        -- require'snippy'.expand_snippet(args.body) -- For `snippy` users.
      end,
    },
    sources={{name="nvim_lsp",keyword_length=1},},
    window={
        completion={
            border="rounded",
            winhighlight="Normal:CmpNormal",
        },
        documentation={
            border="rounded",
            winhighlight="Normal:CmpNormal",
        },
    },
    formatting={fields={"menu","abbr","kind"},},
    mapping={
        ['<CR>']=cmp.mapping.confirm({select=false}),
        ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
        ['<Down>'] = cmp.mapping.select_next_item(select_opts),
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<esc>'] = cmp.mapping.abort(),
    },
}
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'razor' },
  callback = function() vim.treesitter.start() end,
})
require('gitblame').setup {
    enabled = true,
    message_when_not_committed = ""
}
require('gitsigns').setup()
require('yazi').setup({open_for_directories = true})
require('nvim-ts-autotag').setup()
require("nvim-surround").setup()
-- require('leap').set_default_mappings()
-- require('nvim_context_vt').setup()
require("hardtime").setup{}
vim.notify = require("notify")
require('flash').setup{}
require('boole').setup{
  mappings = {
      increment = '<C-a>',
      decrement = '<C-x>'
    },
}
require("outline").setup({})
require"dap-view".setup({
    winbar={
        sections= { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
        controls={enabled=true},
        default_section="threads",
    },
    auto_toggle=true,
})
local dap = require('dap')
dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'debugpy-adapter',
      options = {
        source_filetype = 'python',
      },
    })
  end
end
dap.adapters.coreclr = {
  type = 'executable',
  command = 'netcoredbg',
  args = {'--interpreter=vscode'}
}

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

    program = "${file}"; -- This configuration will launch the current file if used.
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
vim.keymap.set('n', "<Leader>bd", '<cmd>DapDisconnect<cr>')
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

vim.api.nvim_set_hl(0, "red",   { fg = "#ff0000" }) 
vim.api.nvim_set_hl(0, "green",  { fg = "#00ff00" }) 

vim.fn.sign_define('DapBreakpoint', { text='@', texthl='red',   linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text='>', texthl='green',  linehl='DapBreakpoint', numhl='DapBreakpoint' })
