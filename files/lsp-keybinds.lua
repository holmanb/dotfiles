local nvim_lsp = require('lspconfig')

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

require "cmp".setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
require "lspconfig".pyright.setup {
	on_attach = on_attach,
	capabilities = capabilities, -- from nvim-cmp
	settings = {
		python = {
			analysis = {
				diagnosticMode = "openFilesOnly",
			}
		}
	}
}

-- rust
require "lspconfig".rust_analyzer.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}


-- bash
require "lspconfig".bashls.setup {

	on_attach = on_attach,
	capabilities = capabilities,
}

-- vim
require "lspconfig".vimls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- go
require "lspconfig".gopls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

--ansible
require "lspconfig".ansiblels.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- markdown
require "lspconfig".remark_ls.setup {
	on_attach = on_attach,
	capabilities = capabilities,
}

-- null-ls
local null_ls = require "null-ls"
local sources = {

	null_ls.builtins.code_actions.shellcheck,

	-- diagnostics
	null_ls.builtins.diagnostics.checkmake,
	null_ls.builtins.diagnostics.flake8,
	null_ls.builtins.diagnostics.gitlint,
	null_ls.builtins.diagnostics.rstcheck,
	null_ls.builtins.diagnostics.codespell
}
null_ls.setup({ sources = sources })

----diagnosticMode = "openFilesOnly"
---- Flake8/efm-server config
--require "lspconfig".efm.setup {
--    capabilites = capabilities, -- from nvim-cmp
--    on_attach = on_attach,
--    init_options = {documentFormatting = true},
--    settings = {
--        -- rootMarkers = {".git/"},
--	filetypes = { 'python' },
--        languages = {
--            python = {{
--		lintCommand= "flake8 --exit-zero --stdin-display-name ${INPUT} -",
--		lintStdin= true,
--		lintIgnoreExitCode = true,
--		lintFormats = {"%f:%l:%c: %m"}
--		}}
--        },
--    }
--}

-- yamlls config
require'lspconfig'.yamlls.setup{
  on_attach=on_attach,
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/canonical/cloud-init/main/cloudinit/config/schemas/versions.schema.cloud-config.json"] = "user-data*yml"
	-- add ansible schemas
      }
    }
  }
}

-- sumneko lua server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

require'lspconfig'.sumneko_lua.setup {
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

require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all"
  ensure_installed = {
    "c",
    "lua",
    "rust",
    "go",
    "bash",
    "make",
    "yaml",
    "markdown"
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = false,

  -- List of parsers to ignore installing (for "all")
  ignore_install = { },

  highlight = {
    -- `false` will disable the whole extension
    enable = true,

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
}
