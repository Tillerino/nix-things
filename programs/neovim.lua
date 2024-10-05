local lazyPackages = {
	{ "L3MON4D3/LuaSnip" },
  { "lukas-reineke/lsp-format.nvim" },
  { "neovim/nvim-lspconfig" },
  { "nvim-treesitter/nvim-treesitter" },
  { "savq/melange-nvim" },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  { "mbbill/undotree" },
  { "tpope/vim-fugitive" },
  { "nmac427/guess-indent.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "saadparwaiz1/cmp_luasnip" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "tzachar/cmp-ai" },
  { "christoomey/vim-tmux-navigator" },
}

for k,v in ipairs(extraLazy) do
    table.insert(lazyPackages, v)
 end

require("lazy").setup(lazyPackages)

vim.o.hidden = false
vim.opt.background = 'light'
vim.opt.termguicolors = true
vim.cmd.colorscheme 'melange'
vim.g.mapleader = ' '

--
-- LSP
--
-- See https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

local lspconfig = require("lspconfig")
lspconfig.nil_ls.setup{}
lspconfig.dhall_lsp_server.setup{}
lspconfig.java_language_server.setup {
  cmd = { "java-language-server" },
}
lspconfig.pyright.setup{}

-- HTML, see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#html
--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup {
  capabilities = capabilities,
}
lspconfig.rust_analyzer.setup{}
lspconfig.bashls.setup{}

vim.keymap.set('n', '<leader>lref', vim.lsp.buf.references, opts)
vim.keymap.set('n', '<leader>lren', vim.lsp.buf.rename, opts)
--
-- END LSP
--

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8

-- global undo history across sessions
vim.opt.undodir = os.getenv("HOME") .. "/.local/share/nvim/undo"
vim.opt.undofile = true

vim.keymap.set("n", "<C-d>", "<C-d>zz") -- keep half-page down jump centered
vim.keymap.set("n", "<C-u>", "<C-u>zz") -- keep half-page up jump centered
vim.keymap.set("n", "n", "nzzzv") -- keep jump-to-next centered
vim.keymap.set("n", "N", "Nzzzv") -- keep jump-to-prvious centered

vim.keymap.set("n", "<leader>hms", ":w <CR> :!home-manager switch <CR>")

-- Telescope
local builtin = require('telescope.builtin')
-- see https://github.com/nvim-telescope/telescope.nvim#pickers
vim.keymap.set('n', '<leader>ff', function()
  builtin.find_files{hidden = true}
end, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Undotree
vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)

-- Fugitive
vim.keymap.set('n', '<leader>gs', vim.cmd.Git)

-- Treesitter
vim.opt.runtimepath:append("~/.cache/nvim/treesitter-parsers")
require'nvim-treesitter.configs'.setup {
  parser_install_dir = "~/.cache/nvim/treesitter-parsers",
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn", -- set to `false` to disable one of the mappings
      node_incremectal = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('UserLspConfig', {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
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
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }

		end, opts)
	end,
})

require('guess-indent').setup {}

-- Snippets https://github.com/L3MON4D3/LuaSnip
ls = require('luasnip')
ls.setup { }
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

-- AI provider for CMP, fork from https://github.com/JoseConseco/cmp-ai

local cmp_ai = require('cmp_ai.config')

-- Completions https://github.com/hrsh7th/nvim-cmp
local cmp = require('cmp')
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'cmp_ai' },
  }, {
    { name = 'buffer' },
  })
})
