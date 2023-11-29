call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neovim/nvim-lspconfig'
Plug 'elentok/format-on-save.nvim'
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'ray-x/aurora'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'

call plug#end()

map <C-\> :CHADopen<CR>

set termguicolors            " 24 bit color
let g:aurora_italic = 1     " italic
let g:aurora_transparent = 1     " transparent
let g:aurora_bold = 1     " bold
let g:aurora_darker = 1     " darker background
hi Normal guibg=NONE ctermbg=NONE "remove background
hi String guibg=#339922 ctermbg=NONE "remove background

colorscheme aurora

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

nmap cp :let @+=expand('%')<CR>
set nu
set splitbelow
set splitright
if isdirectory($HOME . '/.config/nvim/backup') == 0
  :silent !mkdir -p ~/.config/nvim/backup > /dev/null 2>&1
endif
set backupdir=~/.config/nvim/backup
set backup

if isdirectory($HOME . '/.config/nvim/swap') == 0
  :silent !mkdir -p ~/.config/nvim/swap > /dev/null 2>&1
endif
set directory=~/.config/nvim/swap

if exists("+undofile")
  if isdirectory($HOME . '/.config/nvim/undo') == 0
    :silent !mkdir -p ~/.config/nvim/undo > /dev/null 2>&1
  endif
  set undodir=~/.config/nvim/undo
  set undofile
endif

lua << EOF

require'nvim-treesitter.configs'.setup {
  ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "go", "ruby", "javascript", "typescript", "bash", "markdown", "json", "yaml", "terraform", "sql", "proto" },

  sync_install = false,

  auto_install = false,

  highlight = {
    enable = true,

    additional_vim_regex_highlighting = false,
  },
}

vim.g.coq_settings = {
  auto_start = 'shut-up',
  clients = {
    lsp = {
      resolve_timeout = 0.02,
    },
    tree_sitter = {
      slow_threshold = 0.025,
    },
    buffers = {
      match_syms = true,
      same_filetype = true,
    },
  },
  limits = {
    completion_auto_timeout = 0.05,
  },
}

local lspconfig = require('lspconfig')
local coq = require("coq")
local on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
end
lspconfig.gopls.setup { coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.golangci_lint_ls.setup { coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.denols.setup { coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.eslint.setup { coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.ruby_ls.setup { coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.yamlls.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.cssls.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.html.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.jsonls.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.marksman.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.terraformls.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }
lspconfig.yamlls.setup{ coq.lsp_ensure_capabilities({ on_attach = on_attach_callback }) }

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

vim.g.markdown_fenced_languages = {
  "ts=typescript"
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

local format_on_save = require("format-on-save")
local formatters = require("format-on-save.formatters")

format_on_save.setup({
  exclude_path_patterns = {
    "/node_modules/",
  },
  formatter_by_ft = {
    css = formatters.lsp,
    html = formatters.lsp,
    javascript = formatters.lsp,
    json = formatters.lsp,
    markdown = formatters.prettierd,
    sh = formatters.shfmt,
    terraform = formatters.lsp,
    typescript = formatters.lsp,
    yaml = formatters.lsp,

    go = {
      formatters.shell({ cmd = { "goimports" } }),
    },
  },

  run_with_sh = false,
})

require("nvim-autopairs").setup {}
require('gitsigns').setup()

EOF
