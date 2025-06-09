--[[
--To add a plugin such as prettier make sure that you previously install it using Mason
--]]

return {
  "nvimtools/none-ls.nvim",
  opts = function(_, opts)
    local null_ls = require("null-ls")

    opts.sources = vim.list_extend(opts.sources or {}, {
      null_ls.builtins.formatting.prettier.with({
        filetypes = {
          "javascript",
          "typescript",
          "javascriptreact",
          "typescriptreact",
          "vue",
          "css",
          "scss",
          "html",
          "json",
        },
      }),
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.shfmt,
    })
  end,
}
