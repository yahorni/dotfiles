" extra_options.vim

let g:python3_host_prog = '/usr/bin/python3'

if has('nvim-0.5.0')

" {{{ nvim-treesitter configuration
lua <<EOF
  require('nvim-treesitter.configs').setup {
    ensure_installed = {'c', 'cpp', 'python', 'vim', 'lua'},
    highlight = {
      enable = true,
      disable = {},
    },
    indent = {
      enable = true,
    },
  }
EOF
" }}}

" {{{ lsp mason
let g:complete_plugin = get(g:, 'complete_plugin', 'none')
if project#isDirSet() && g:complete_plugin == 'lsp'
lua <<EOF
  local servers = {
    clangd = {},
  }
  require('mason').setup()
  local mason_lspconfig = require('mason-lspconfig')
  mason_lspconfig.setup {
    ensure_installed = {'clangd'},
  }
  mason_lspconfig.setup_handlers {
    function(server_name)
      require('lspconfig')[server_name].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = servers[server_name],
      }
    end,
  }
EOF
endif
" }}}

endif
