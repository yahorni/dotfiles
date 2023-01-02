" extra_options.vim

" {{{ nvim-treesitter configuration

if has("nvim-0.5.0")
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "c", "cpp", "python",
  highlight = {
    enable = true,
    disable = {},
  },
  indent = {
    enable = true,
  },
}
EOF
end

" }}}
