call plug#begin()

Plug 'nvim-treesitter/nvim-treesitter'
Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/nvim-cmp'
Plug 'onsails/lspkind.nvim'
Plug 'L3MON4D3/LuaSnip', { 'tag': 'v2.3.0', 'do': 'make install_jsregexp'}
Plug 'zbirenbaum/copilot-cmp'
Plug 'elentok/format-on-save.nvim'
Plug 'zbirenbaum/copilot.lua'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
Plug 'ray-x/aurora'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-rhubarb'
Plug 'tpope/vim-fugitive'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nmac427/guess-indent.nvim'
Plug 'nvim-pack/nvim-spectre'
Plug 'nvim-lualine/lualine.nvim'
Plug 'AndreM222/copilot-lualine'
Plug 'nvim-tree/nvim-web-devicons'

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
nnoremap <leader>fs <cmd>Telescope treesitter<cr>
nnoremap <leader>fd <cmd>Telescope diagnostics<cr>
nnoremap <leader>gs <cmd>Telescope git_status<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
nnoremap <leader>gbc <cmd>Telescope git_bcommits<cr>
nnoremap <leader>\ <cmd>Spectre<cr>

nmap cp :let @+=expand('%')<CR>
set nu
set splitbelow
set splitright
if isdirectory($HOME . '/.local/nvim/backup') == 0
  :silent !mkdir -p ~/.local/nvim/backup > /dev/null 2>&1
endif
set backupdir=~/.local/nvim/backup
set backup

if isdirectory($HOME . '/.local/nvim/swap') == 0
  :silent !mkdir -p ~/.local/nvim/swap > /dev/null 2>&1
endif
set directory=~/.local/nvim/swap

if exists("+undofile")
  if isdirectory($HOME . '/.local/nvim/undo') == 0
    :silent !mkdir -p ~/.local/nvim/undo > /dev/null 2>&1
  endif
  set undodir=~/.local/nvim/undo
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

local lspconfig = require('lspconfig')
local luasnip = require("luasnip")
local cmp = require('cmp')
local lspkind = require('lspkind')
local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end
luasnip.setup()
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol",
      max_width = 50,
      symbol_map = {
        Copilot = "",
      }
    })
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping(function(fallback)
        if cmp.visible()  and has_words_before() then
            if luasnip.expandable() then
                luasnip.expand()
            else
                cmp.confirm({
                    select = true,
                })
            end
        else
            fallback()
        end
    end),

    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_next_item()
      elseif luasnip.locally_jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() and has_words_before() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = {
    -- Copilot Source
    { name = "copilot", group_index = 2 },
    -- Other Sources
    { name = "nvim_lsp", group_index = 2 },
    { name = "path", group_index = 2 },
    { name = "luasnip", group_index = 2 },
  },
})

require("copilot_cmp").setup()
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
    require("lsp-format").on_attach(client, bufnr)
end
lspconfig.gopls.setup { capabilities = capabilities }
lspconfig.golangci_lint_ls.setup { capabilities = capabilities }
lspconfig.tsserver.setup { capabilities = capabilities }
lspconfig.eslint.setup { capabilities = capabilities }
lspconfig.ruby_lsp.setup { capabilities = capabilities }
lspconfig.yamlls.setup { capabilities = capabilities }
lspconfig.cssls.setup { capabilities = capabilities }
lspconfig.html.setup { capabilities = capabilities }
lspconfig.jsonls.setup { capabilities = capabilities }
lspconfig.marksman.setup { capabilities = capabilities }
lspconfig.terraformls.setup { capabilities = capabilities }
lspconfig.yamlls.setup { capabilities = capabilities }
lspconfig.bashls.setup { capabilities = capabilities }

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
local vim_notify = require("format-on-save.error-notifiers.vim-notify")

format_on_save.setup({
  exclude_path_patterns = {
    "/node_modules/",
  },
  formatter_by_ft = {
    css = formatters.lsp,
    html = formatters.lsp,
    markdown = formatters.prettierd,
    sh = formatters.lsp,
    bash = formatters.lsp,
    terraform = formatters.lsp,
    yaml = formatters.lsp,

    javascript = {
      formatters.remove_trailing_whitespace,
      formatters.remove_trailing_newlines,
      formatters.lazy_eslint_d_fix,
    },

    javascriptreact = {
      formatters.remove_trailing_whitespace,
      formatters.remove_trailing_newlines,
      formatters.lazy_eslint_d_fix,
    },

    typescript = {
      formatters.remove_trailing_whitespace,
      formatters.remove_trailing_newlines,
      formatters.lazy_eslint_d_fix,
    },

    typescriptreact = {
      formatters.remove_trailing_whitespace,
      formatters.remove_trailing_newlines,
      formatters.lazy_eslint_d_fix,
    },

    json = {
      formatters.remove_trailing_whitespace,
      formatters.remove_trailing_newlines,
      formatters.shell({ cmd = { "python3", "-m", "json.tool" } }),
    },

    go = {
      formatters.remove_trailing_whitespace,
      formatters.remove_trailing_newlines,
      formatters.shell({ cmd = { "goimports" } }),
    },
  },

  fallback_formatter = {
    formatters.remove_trailing_whitespace,
    formatters.remove_trailing_newlines,
  },

  error_notifier = vim_notify,
  run_with_sh = false,
})

require("nvim-autopairs").setup {}
require("ibl").setup()
require('guess-indent').setup {
  auto_cmd = true,
  filetype_exclude = {
    "netrw",
    "tutor",
  },
  buftype_exclude = {
    "help",
    "nofile",
    "terminal",
    "prompt",
  },
}
require("copilot").setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
})

require('evil_lualine')
require('gitsigns-custom')

EOF
