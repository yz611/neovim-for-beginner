local M = {}

local servers = {
  gopls = {},
  html = {},
  jsonls = {},
  pyright = {},
  rust_analyzer = {},
  sumneko_lua = {},
  tsserver = {},
  vimls = {},
}

local lsp_signature = require "lsp_signature"
lsp_signature.setup {
  bind = true,
  handler_opts = {
    border = "rounded",
  },
}

local function on_attach(client, bufnr)
  -- Enable completion triggered by <C-X><C-O>
  -- See `:help omnifunc` and `:help ins-completion` for more information.
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Use LSP as the handler for formatexpr.
  -- See `:help formatexpr` for more information.
  vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")

  -- Configure key mappings
  require("config.lsp.keymaps").setup(client, bufnr)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
if PLUGINS.nvim_cmp.enabled then
  capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities) -- for nvim-cmp
end

local opts = {
  on_attach = on_attach,
  capabilities = capabilities,
  flags = {
    debounce_text_changes = 150,
  },
}

function M.setup()
  require("config.lsp.installer").setup(servers, opts)
end

return M
