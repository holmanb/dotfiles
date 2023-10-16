local nvim_lsp = require('lspconfig')
local opts = { noremap=true, silent=true }
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
capabilities.offsetEncoding = {'utf-8'}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions

-- diagnostics
local signs = { Error = "☢ ", Warn = " ", Hint = " ", Info = "ℹ ", Other = "?" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- show diagnostics in  window
-- note: this setting is global and should be set only once
vim.o.updatetime = 250
vim.cmd [[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false, border='rounded'})]]

-- diagnostic hover window
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = false,
})

-- diagnostic keymap
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- LSP settings (for overriding per client)
local handlers =  {
  ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, {border = "rounded"}),
  ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, {border = "rounded"}),
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

	-- Mappings.
	-- See `:help vim.lsp.*` for documentation on any of the below functions
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
	vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
	vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
	vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
	vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
	vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
	vim.keymap.set('n', '<space>wl', function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, bufopts)
	vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
	vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
	vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
	vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
	vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
end

-- pyright
nvim_lsp.pyright.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- bash
nvim_lsp.bashls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

-- vim
nvim_lsp.vimls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

-- go
nvim_lsp.gopls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

--ansible
nvim_lsp.ansiblels.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

-- markdown
-- nvim_lsp.remark_ls.setup {
-- 	on_attach = on_attach,
-- 	capabilities = capabilities,
-- 	handlers = handlers,
-- }

-- typescript/javascript
nvim_lsp.tsserver.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

-- jsonls
nvim_lsp.jsonls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

-- ccls
nvim_lsp.ccls.setup {
  init_options = {
    cache = {
		directory = ".ccls-cache";
    }
  },
}

-- null-ls
require "null-ls".setup({
	sources = {
		require("null-ls").builtins.code_actions.shellcheck,
		require("null-ls").builtins.diagnostics.checkmake,
		require("null-ls").builtins.diagnostics.flake8,
		require("null-ls").builtins.diagnostics.gitlint,
		require("null-ls").builtins.diagnostics.rstcheck,
		require("null-ls").builtins.diagnostics.codespell,
		require("null-ls").builtins.diagnostics.eslint
	}})

-- yamlls config
nvim_lsp.yamlls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
	settings = {
		yaml = {
			schemas = {
				["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
				["https://raw.githubusercontent.com/canonical/cloud-init-a/main/cloudinit/config/schemas/versions.schema.cloud-config.json"] = "*yml"
				-- add ansible schemas
			}
		}
	}
}

-- c/c++
--local clang_capabilities = capabilities
nvim_lsp.clangd.setup {
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
}

-- sumneko lua server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

nvim_lsp.lua_ls.setup {
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = 'LuaJIT',
				-- Setup your lua path
				path = runtime_path,
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = {'vim'},
			},
			workspace = {
				-- Make the server aware of Neovim runtime files
				library = vim.api.nvim_get_runtime_file("", true),
			},
			-- Do not send telemetry data
			telemetry = {
				enable = false,
			},
		},
	},
}

local cmp = require "cmp"

cmp.setup {
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(0),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = true }),
		-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
	},{
		{ name = 'vsnip' },
	},{
		{ name = 'path' },
	},{
		{ name = 'buffer' },
	},{
		{ name = 'cmdline' },
	},{
		{ name = 'buffer' },
	})
}

require 'nvim-treesitter.configs'.setup {
	-- A list of parser names, or "all"
	ensure_installed = {
		"c",
		"lua",
		"rust",
		"go",
		"bash",
		"make",
		"javascript",
		"yaml",
		"markdown"
	},
	sync_install = true, -- (only applied to `ensure_installed`)
	auto_install = true,
	ignore_install = {},
	highlight = {
		enable = true,
		disable = {},
		additional_vim_regex_highlighting = false,
	},
	-- enable TSHighlightCapturesUnderCursor
	playground = { enable = false }
}

-- status line
require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'auto',
		component_separators = { left = ' ', right = ' '},
		section_separators = { left = ' ', right = ' '},
		disabled_filetypes = {
			statusline = {},
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		globalstatus = false,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		}
	},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {
			'branch',
			'diff',
			{
				'diagnostics',
				symbols = {
					error = "☢ ", warn = " ", hint = " ", info = "ℹ ",
				},
			},
		},
		lualine_c = {'filename'},
		lualine_x = {'encoding', 'filetype'},
		lualine_y = {'progress'},
		lualine_z = {'location'}
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {'filename'},
		lualine_x = {'location'},
		lualine_y = {},
		lualine_z = {}
	},
	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {}
}

require("ibl").setup {}

-- rust-tools integrates with lsp server
require("rust-tools").setup {}

-- Lua
-- local actions = require("diffview.actions")
-- 
-- require("diffview").setup({
--   diff_binaries = false,    -- Show diffs for binaries
--   enhanced_diff_hl = false, -- See ':h diffview-config-enhanced_diff_hl'
--   git_cmd = { "git" },      -- The git executable followed by default args.
--   use_icons = true,         -- Requires nvim-web-devicons
--   icons = {                 -- Only applies when use_icons is true.
--     folder_closed = "",
--     folder_open = "",
--   },
--   signs = {
--     fold_closed = "",
--     fold_open = "",
--   },
--   file_panel = {
--     listing_style = "tree",             -- One of 'list' or 'tree'
--     tree_options = {                    -- Only applies when listing_style is 'tree'
--       flatten_dirs = true,              -- Flatten dirs that only contain one single dir
--       folder_statuses = "only_folded",  -- One of 'never', 'only_folded' or 'always'.
--     },
--     win_config = {                      -- See ':h diffview-config-win_config'
--       position = "bottom",
--       height = 10,
--     },
--   },
--   file_history_panel = {
--     log_options = {   -- See ':h diffview-config-log_options'
--       single_file = {
--         diff_merges = "combined",
--       },
--       multi_file = {
--         diff_merges = "first-parent",
--       },
--     },
--     win_config = {    -- See ':h diffview-config-win_config'
--       position = "bottom",
--       height = 16,
--     },
--   },
--   commit_log_panel = {
--     win_config = {},  -- See ':h diffview-config-win_config'
--   },
--   default_args = {    -- Default args prepended to the arg-list for the listed commands
--     DiffviewOpen = {},
--     DiffviewFileHistory = {},
--   },
--   hooks = {},         -- See ':h diffview-config-hooks'
--   keymaps = {
--     disable_defaults = false, -- Disable the default keymaps
--     view = {
--       -- The `view` bindings are active in the diff buffers, only when the current
--       -- tabpage is a Diffview.
--       ["<tab>"]      = actions.select_next_entry, -- Open the diff for the next file
--       ["<s-tab>"]    = actions.select_prev_entry, -- Open the diff for the previous file
--       ["gf"]         = actions.goto_file,         -- Open the file in a new split in the previous tabpage
--       ["<C-w><C-f>"] = actions.goto_file_split,   -- Open the file in a new split
--       ["<C-w>gf"]    = actions.goto_file_tab,     -- Open the file in a new tabpage
--       ["<leader>e"]  = actions.focus_files,       -- Bring focus to the files panel
--       ["<leader>b"]  = actions.toggle_files,      -- Toggle the files panel.
--     },
--     file_panel = {
--       ["j"]             = actions.next_entry,         -- Bring the cursor to the next file entry
--       ["<down>"]        = actions.next_entry,
--       ["k"]             = actions.prev_entry,         -- Bring the cursor to the previous file entry.
--       ["<up>"]          = actions.prev_entry,
--       ["<cr>"]          = actions.select_entry,       -- Open the diff for the selected entry.
--       ["o"]             = actions.select_entry,
--       ["<2-LeftMouse>"] = actions.select_entry,
--       ["-"]             = actions.toggle_stage_entry, -- Stage / unstage the selected entry.
--       ["S"]             = actions.stage_all,          -- Stage all entries.
--       ["U"]             = actions.unstage_all,        -- Unstage all entries.
--       ["X"]             = actions.restore_entry,      -- Restore entry to the state on the left side.
--       ["R"]             = actions.refresh_files,      -- Update stats and entries in the file list.
--       ["L"]             = actions.open_commit_log,    -- Open the commit log panel.
--       ["<c-b>"]         = actions.scroll_view(-0.25), -- Scroll the view up
--       ["<c-f>"]         = actions.scroll_view(0.25),  -- Scroll the view down
--       ["<tab>"]         = actions.select_next_entry,
--       ["<s-tab>"]       = actions.select_prev_entry,
--       ["gf"]            = actions.goto_file,
--       ["<C-w><C-f>"]    = actions.goto_file_split,
--       ["<C-w>gf"]       = actions.goto_file_tab,
--       ["i"]             = actions.listing_style,        -- Toggle between 'list' and 'tree' views
--       ["f"]             = actions.toggle_flatten_dirs,  -- Flatten empty subdirectories in tree listing style.
--       ["<leader>e"]     = actions.focus_files,
--       ["<leader>b"]     = actions.toggle_files,
--     },
--     file_history_panel = {
--       ["g!"]            = actions.options,          -- Open the option panel
--       ["<C-A-d>"]       = actions.open_in_diffview, -- Open the entry under the cursor in a diffview
--       ["y"]             = actions.copy_hash,        -- Copy the commit hash of the entry under the cursor
--       ["L"]             = actions.open_commit_log,
--       ["zR"]            = actions.open_all_folds,
--       ["zM"]            = actions.close_all_folds,
--       ["j"]             = actions.next_entry,
--       ["<down>"]        = actions.next_entry,
--       ["k"]             = actions.prev_entry,
--       ["<up>"]          = actions.prev_entry,
--       ["<cr>"]          = actions.select_entry,
--       ["o"]             = actions.select_entry,
--       ["<2-LeftMouse>"] = actions.select_entry,
--       ["<c-b>"]         = actions.scroll_view(-0.25),
--       ["<c-f>"]         = actions.scroll_view(0.25),
--       ["<tab>"]         = actions.select_next_entry,
--       ["<s-tab>"]       = actions.select_prev_entry,
--       ["gf"]            = actions.goto_file,
--       ["<C-w><C-f>"]    = actions.goto_file_split,
--       ["<C-w>gf"]       = actions.goto_file_tab,
--       ["<leader>e"]     = actions.focus_files,
--       ["<leader>b"]     = actions.toggle_files,
--     },
--     option_panel = {
--       ["<tab>"] = actions.select_entry,
--       ["q"]     = actions.close,
--     },
--   },
-- })
