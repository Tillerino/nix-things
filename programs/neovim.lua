vim.o.hidden = false
vim.opt.background = 'light'
vim.opt.termguicolors = true
vim.cmd.colorscheme 'melange'

local lspconfig = require("lspconfig")
lspconfig.nil_ls.setup{}
lspconfig.dhall_lsp_server.setup{}
lspconfig.java_language_server.setup {
  cmd = { "java-language-server" },
}

vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 8
vim.g.mapleader = ' '

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
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
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
		vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
		vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
		vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
		vim.keymap.set('n', '<space>f', function()
			vim.lsp.buf.format { async = true }
		end, opts)
	end,
})
