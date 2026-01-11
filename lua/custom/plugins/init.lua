-- You can add your own plugins here or in other files in this directory!

-- Plugin manager: Lazy.nvim
-- LSP manager: Mason
--
vim.g.have_nerd_font = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true
vim.schedule(function()
	vim.o.clipboard = 'unnamedplus'
end)
vim.opt.virtualedit = 'block'
-- Personal keymaps
vim.keymap.set('n', '<Leader>b', '<cmd>bp<CR>', { desc = 'Previous [b]uffer' })
vim.keymap.set('n', '<C-a>', 'ggVG')
vim.keymap.set('n', 'J', '20j')
vim.keymap.set('n', 'K', '20k')

-- TIP: Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Source lua files
vim.keymap.set('n', '<leader>ls', '<cmd>source %<CR>', { desc = '[L]ua source file' })
vim.keymap.set('n', '<leader>ll', ':.lua<CR>', { desc = '[L]ua source line' })
vim.keymap.set('v', '<leader>le', ':lua<CR>', { desc = '[L]ua source selection' })



--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
	{
		'stevearc/oil.nvim',
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {
			keymaps = {
				['<BS>'] = { 'actions.parent', mode = 'n' },
			},
		},
		-- Optional dependencies
		-- dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
		dependencies = { 'nvim-tree/nvim-web-devicons' }, -- use if you prefer nvim-web-devicons
		-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
		lazy = false,
		keys = {
			{ '<leader>fo', '<cmd>Oil<cr>', desc = '[O]il file browser' },
		},
	},
	{
		'supermaven-inc/supermaven-nvim',
		config = function()
			require('supermaven-nvim').setup {}
		end,
	},
	{
		'mfussenegger/nvim-dap-python',
		-- opts = {},
	},
	{
		'mfussenegger/nvim-dap',
		enabled = true,
		config = function()
			local dap = require 'dap'
			dap.adapters.python = function(cb, config)
				if config.request == 'attach' then
					---@diagnostic disable-next-line: undefined-field
					local port = (config.connect or config).port
					---@diagnostic disable-next-line: undefined-field
					local host = (config.connect or config).host or '127.0.0.1'
					cb {
						type = 'server',
						port = assert(port, '`connect.port` is required for a python `attach` configuration'),
						host = host,
						options = {
							source_filetype = 'python',
						},
					}
				else
					cb {
						type = 'executable',
						command = '/home/kevin/.virtualenvs/debugpy/bin/python',
						-- command = 'home/kevin/.virtualenvs/debugpy/bin/python',
						args = { '-m', 'debugpy.adapter' },
						options = {
							source_filetype = 'python',
						},
					}
				end
			end
			dap.configurations.python = {
				{
					-- The first three options are required by nvim-dap
					type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
					request = 'launch',
					name = 'Launch file',

					-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

					program = '${file}', -- This configuration will launch the current file if used.
					pythonPath = function()
						-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
						-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
						-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. '/home/kevin/.virtualenvs/debugpy/bin/python') == 1 then
							return cwd .. '/home/kevin/.virtualenvs/debugpy/bin/python'
						elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
							return cwd .. '/.venv/bin/python'
						else
							return '/usr/bin/python3'
						end
					end,
				},
			}
			-- dap.configurations.python = {
			--   {
			--     type = 'debugpy',
			--     request = 'launch',
			--     name = 'Launch file',
			--     program = '${file}',
			--     pythonPath = function()
			--       return '/usr/bin/python3'
			--     end,
			--   },
			-- }
		end,
	},
	{ --Markdown preview
		'iamcco/markdown-preview.nvim',
		cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
		build = 'cd app && yarn install',
		init = function()
			vim.g.mkdp_filetypes = { 'markdown' }
		end,
		ft = { 'markdown' },
	},
	{
		'Hoffs/omnisharp-extended-lsp.nvim',
		lazy = false,
	},
	'NMAC427/guess-indent.nvim',
	{
		'numToStr/Comment.nvim',
		opts = {
			-- add any options here
		},
	},
	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
	},
	{ -- Fuzzy Finder (files, lsp, etc)
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ -- If encountering errors, see telescope-fzf-native README for install instructions
				'nvim-telescope/telescope-fzf-native.nvim',
				-- `build` is used to run some command when the plugin is installed/updated.
				-- This is only run then, not every time Neovim starts up.
				build = 'make',
				-- `cond` is a condition used to determine whether this plugin should be
				-- installed and loaded.
				cond = function()
					return vim.fn.executable 'make' == 1
				end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },
			-- Useful for getting pretty icons, but requires a Nerd Font.
			{ 'nvim-tree/nvim-web-devicons',            enabled = vim.g.have_nerd_font },
		},
		config = function()
			-- Telescope is a fuzzy finder that comes with a lot of different things that
			-- it can fuzzy find! It's more than just a "file finder", it can search
			-- many different aspects of Neovim, your workspace, LSP, and more!
			--
			-- The easiest way to use telescope, is to start by doing something like:
			--  :Telescope help_tags
			--
			-- After running this command, a window will open up and you're able to
			-- type in the prompt window. You'll see a list of help_tags options and
			-- a corresponding preview of the help.
			--
			-- Two important keymaps to use while in telescope are:
			--  - Insert mode: <c-/>
			--  - Normal mode: ?
			--
			-- This opens a window that shows you all of the keymaps for the current
			-- telescope picker. This is really useful to discover what Telescope can
			-- do as well as how to actually do it!
			-- [[ Configure Telescope ]]
			-- See `:help telescope` and `:help telescope.setup()`
			require('telescope').setup {
				-- You can put your default mappings / updates / etc. in here
				--  All the info you're looking for is in `:help telescope.setup()`
				--
				-- defaults = {
				--   mappings = {
				--     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
				--   },
				-- },
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown(),
					},
					file_browser = {
						theme = 'ivy',
						-- disables netrw and use telescope-file-browser in its place
						hijack_netrw = true,
						mappings = {
							['i'] = {
								-- your custom insert mode mappings
							},
							['n'] = {
								-- your custom normal mode mappings
							},
						},
					},
				},
			}

			-- Enable telescope extensions, if they are installed
			pcall(require('telescope').load_extension, 'fzf')
			pcall(require('telescope').load_extension, 'ui-select')
			pcall(require('telescope').load_extension, 'file_browser')

			-- Telescope extension keymaps

			-- See `:help telescope.builtin`
			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
			vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
			vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>s.', builtin.oldfiles,
				{ desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
			vim.keymap.set('n', '<leader>fp', function()
				builtin.find_files(require('telescope.themes').get_dropdown {
					previewer = false,
				})
			end, { desc = 'Find no [p]review' })
			-- Slightly advanced example of overriding default behavior and theme
			vim.keymap.set('n', '<leader>/', function()
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
					winblend = 10,
					previewer = false,
				})
			end, { desc = '[/] Fuzzily search in current buffer' })
			-- Also possible to pass additional configuration options.
			--  See `:help telescope.builtin.live_grep()` for information about particular keys
			vim.keymap.set('n', '<leader>s/', function()
				builtin.live_grep {
					grep_open_files = true,
					prompt_title = 'Live Grep in Open Files',
				}
			end, { desc = '[S]earch [/] in Open Files' })
			-- Shortcut for searching your neovim configuration files
			vim.keymap.set('n', '<leader>sn', function()
				builtin.find_files { cwd = vim.fn.stdpath 'config' }
			end, { desc = '[S]earch [N]eovim files' })

			print(vim.uv.os_uname().sysname)
			vim.keymap.set('n', '<leader>n', function()
				if vim.uv.os_uname().sysname == 'Linux' then
					builtin.find_files { cwd = '~/_notes' }
				elseif vim.uv.os_uname().sysname == 'Windows' then
					builtin.find_files { cwd = 'C:/_notes' }
				end
			end, { desc = '[N]avigate [N]otes' })

			vim.keymap.set('n', '<leader>fc', function()
				require('telescope').extensions.file_browser.file_browser {
					path = '%:p:h',
					select_buffer = true,
				}
			end, { desc = '[C]urrent' })

			vim.keymap.set('n', '<leader>fb', function()
				require('telescope').extensions.file_browser.file_browser()
			end, { desc = 'File [B]rowser' })
		end,
	},
	{
		'folke/which-key.nvim',
		event = 'VimEnter', -- Sets the loading event to 'VimEnter'
		opts = {
			-- delay between pressing a key and opening which-key (milliseconds)
			-- this setting is independent of vim.o.timeoutlen
			delay = 0,
			icons = {
				-- set icon mappings to true if you have a Nerd Font
				mappings = vim.g.have_nerd_font,
				-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
				-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
				keys = vim.g.have_nerd_font and {} or {
					Up = '<Up> ',
					Down = '<Down> ',
					Left = '<Left> ',
					Right = '<Right> ',
					C = '<C-…> ',
					M = '<M-…> ',
					D = '<D-…> ',
					S = '<S-…> ',
					CR = '<CR> ',
					Esc = '<Esc> ',
					ScrollWheelDown = '<ScrollWheelDown> ',
					ScrollWheelUp = '<ScrollWheelUp> ',
					NL = '<NL> ',
					BS = '<BS> ',
					Space = '<Space> ',
					Tab = '<Tab> ',
					F1 = '<F1>',
					F2 = '<F2>',
					F3 = '<F3>',
					F4 = '<F4>',
					F5 = '<F5>',
					F6 = '<F6>',
					F7 = '<F7>',
					F8 = '<F8>',
					F9 = '<F9>',
					F10 = '<F10>',
					F11 = '<F11>',
					F12 = '<F12>',
				},
			},

			-- Document existing key chains
			spec = {
				{ '<leader>s', group = '[S]earch' },
				{ '<leader>t', group = '[T]oggle' },
				{ '<leader>c', group = '[C]ode' },
				{ '<leader>d', group = '[D]ocument' },
				{ '<leader>r', group = '[R]ename' },
				{ '<leader>w', group = '[W]orkspace' },
				{ '<leader>l', group = '[L]azyGit & Lua sourcing' },
				{ '<leader>f', group = '[F]ile utilities' },
				{ '<leader>g', group = '[G]ile utilities' },
			},
		},
	},
	{
		'javiorfo/nvim-soil',

		-- Optional for puml syntax highlighting:
		-- dependencies = { 'javiorfo/nvim-nyctophilia' },

		lazy = true,
		ft = 'plantuml',
		opts = {
			-- If you want to change default configurations

			-- If you want to use Plant UML jar version instead of the install version
			puml_jar = 'C:\\"Program Files"\\Plantuml\\plantuml.jar',

			-- If you want to customize the image showed when running this plugin
			image = {
				darkmode = false, -- Enable or disable darkmode
				format = '-tsvg', -- Choose between png or svg

				-- This is a default implementation of using nsxiv to open the resultant image
				-- Edit the string to use your preferred app to open the image (as if it were a command line)
				-- Some examples:
				-- return "feh " .. img
				-- return "xdg-open " .. img
				execute_to_open = function(img)
					print(string.format('Opening image %s', img))
					-- return 'C:\\"Program Files"\\Google\\Chrome\\Application\\chrome.exe --app=' .. img
					return img
				end,
			},
		},
	},
	{
		'tyru/open-browser.vim',
	},
	{
		'aklt/plantuml-syntax',
	},
	{
		'nvim-telescope/telescope-file-browser.nvim',
		dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' },
	},
	{
		'kdheepak/lazygit.nvim',
		lazy = true,
		cmd = {
			'LazyGit',
			'LazyGitConfig',
			'LazyGitCurrentFile',
			'LazyGitFilter',
			'LazyGitFilterCurrentFile',
		},
		-- optional for floating window border decoration
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		-- setting the keybinding for LazyGit with 'keys' is recommended in
		-- order to load the plugin when the command is run for the first time
		keys = {
			{ '<leader>lg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
		},
	},
	{ -- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for neovim
			{ 'mason-org/mason.nvim', opts = {} },
			'mason-org/mason-lspconfig.nvim',
			'WhoIsSethDaniel/mason-tool-installer.nvim',

			-- Useful status updates for LSP.
			{ 'j-hui/fidget.nvim',    opts = {} },

			-- Allows extra capabilities provided by blink.cmp
			'saghen/blink.cmp',
		},
		config = function()
			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
				callback = function(event)
					-- Helper function
					local map = function(keys, func, desc)
						vim.keymap.set('n', keys, func,
							{ buffer = event.buf, desc = 'LSP: ' .. desc })
					end

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					--          map('gd', require('omnisharp_extended').lsp_definition, '[G]oto [D]efinition')
					--          map('<leader>gd', require('omnisharp_extended').lsp_definitions, '[G]oto [D]efinition')

					-- Find references for the word under your cursor.
					map('gr', vim.lsp.buf.references, '[G]oto [R]eferences')

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map('<leader>ds', require('telescope.builtin').lsp_document_symbols,
						'[D]ocument [S]ymbols')
					-- Fuzzy find all the symbols in your current workspace
					--  Similar to document symbols, except searches over your whole project.
					map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
						'[W]orkspace [S]ymbols')
					-- Rename the variable under your cursor
					--  Most Language Servers support renaming across files, etc.
					map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

					-- Opens a popup that displays documentation about the word under your cursor
					--  See `:help K` for why this keymap
					map('H', vim.lsp.buf.hover, '[H]over Documentation')

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header
					map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
					map('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has 'nvim-0.11' == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
						local highlight_augroup = vim.api.nvim_create_augroup(
							'kickstart-lsp-highlight', { clear = false })

						vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd('LspDetach', {
							group = vim.api.nvim_create_augroup('kickstart-lsp-detach',
								{ clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
							end,
						})
					end
				end,
			})

			-- Diagnostic Config
			-- See :help vim.diagnostic.Opts
			vim.diagnostic.config {
				severity_sort = true,
				float = { border = 'rounded', source = 'if_many' },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = '󰅚 ',
						[vim.diagnostic.severity.WARN] = '󰀪 ',
						[vim.diagnostic.severity.INFO] = '󰋽 ',
						[vim.diagnostic.severity.HINT] = '󰌶 ',
					},
				} or {},
				virtual_text = {
					source = 'if_many',
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			}

			-- LSP servers and clients are able to communicate to each other what features they support.
			--  By default, Neovim doesn't support everything that is in the LSP Specification.
			--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
			--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.

			--  local capabilities = vim.lsp.protocol.make_client_capabilities()
			local capabilities = require('blink.cmp').get_lsp_capabilities()
			-- capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

			-- Enable the following language servers
			--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
			--
			--  Add any additional override configuration in the following tables. Available keys are:
			--  - cmd (table): Override the default command used to start the server
			--  - filetypes (table): Override the default list of associated filetypes for the server
			--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
			--  - settings (table): Override the default settings passed when initializing the server.
			--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`tsserver`) will work just fine
				-- tsserver = {},
				--
				--

				basedpyright = {
					settings = {
						basedpyright = {
							analysis = {
								autoSearchPaths = false,
								useLibraryCodeForTypes = true,
								diagnosticMode = 'openFilesOnly',
								somestufu = 'some',
								typeCheckingMode = 'basic',
							},
						},
					},
				},

				lua_ls = {
					-- cmd = {...},
					-- filetypes = { ...},
					-- capabilities = {},
					settings = {
						Lua = {
							completion = {
								callSnippet = 'Replace',
							},
							diagnostics = {
								globals = { 'vim' },
							},
						},
					},
				},
				--   omnisharp = {},
			}

			-- Now setup those configurations
			for name, config in pairs(servers) do
				local config = config or {}
				-- This handles overriding only values explicitly passed
				-- by the server configuration above. Useful when disabling
				-- certain features of an LSP (for example, turning off formatting for ts_ls)
				config.capabilities = vim.tbl_deep_extend('force', {}, capabilities,
					config.capabilities or {})
				vim.lsp.config(name, config)
			end

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				'stylua', -- Used to format lua code
			})
			require('mason-tool-installer').setup { ensure_installed = ensure_installed }

			require('mason-lspconfig').setup {
				ensure_installed = {},
				automatic_installation = false,
			}
		end,
	},
	{
		'nvim-treesitter/nvim-treesitter-context',
		build = ':TSUpdate',
	},
	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		opts = {
			ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'python' },
		},
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { 'ruby', 'python' },
		},
		indent = { enable = true, disable = { 'ruby', 'python' } },
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = '<Leader>gnn', -- set to `false` to disable one of the mappings
				node_incremental = '<Leader>grn',
				scope_incremental = '<Leader>grc',
				node_decremental = '<Leader>grm',
			},
		}
	},
	{ -- Autoformat
		'stevearc/conform.nvim',
		opts = {
			-- formatters = {
			--   csharpier = {
			--     args = { '--write-stdout --config-path  ' },
			--   },
			-- },
			notify_on_error = true,
			format_on_save = function(bufnr)
				-- Disable "format_on_save lsp_fallback" for languages that don't
				-- have a well standardized coding style. You can add additional
				-- languages here or re-enable it for the disabled ones.
				local disable_filetypes = { lua = true, cs = true, c = true, cpp = true, py = true }
				return {
					timeout_ms = 2000,
					-- lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
					lsp_fallback = true,
				}
			end,
			-- format_on_save = true,
			formatters_by_ft = {
				lua = { 'stylua' },
				-- Conform can also run multiple formatters sequentially
				-- python = { "isort", "black" },
				--
				-- You can use a sub-list to tell conform to run *until* a formatter
				-- is found.
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},
	{
		'mikavilpas/yazi.nvim',
		event = 'VeryLazy',
		dependencies = { 'folke/snacks.nvim', lazy = true },
		keys = {
			-- 👇 in this section, choose your own keymappings!
			{
				'<leader>-',
				mode = { 'n', 'v' },
				'<cmd>Yazi<cr>',
				desc = 'Open yazi at the current file',
			},
			{
				-- Open in the current working directory
				'<leader>cw',
				'<cmd>Yazi cwd<cr>',
				desc = "Open the file manager in nvim's working directory",
			},
			{
				'<c-up>',
				'<cmd>Yazi toggle<cr>',
				desc = 'Resume the last yazi session',
			},
		},
		---@type YaziConfig | {}
		opts = {
			-- if you want to open yazi instead of netrw, see below for more info
			open_for_directories = false,
			keymaps = {
				show_help = '<f1>',
			},
		},
		-- 👇 if you use `open_for_directories=true`, this is recommended
		init = function()
			-- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
			-- vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1
		end,
	}
}
