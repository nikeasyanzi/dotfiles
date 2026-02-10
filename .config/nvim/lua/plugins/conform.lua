vim.api.nvim_create_user_command("FormatDisable", function(args)
    if args.bang then
        -- FormatDisable! will disable formatting just for this buffer
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable autoformat-on-save",
    bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
    vim.b.disable_autoformat = false
    vim.g.disable_autoformat = false
end, {
    desc = "Re-enable autoformat-on-save",
})

return { -- Autoformat
    "stevearc/conform.nvim",
    lazy = false,
    cmd = { "ConformInfo" },
    keys = {
        {
            "<leader>tf",
            function()
                -- If autoformat is currently disabled for this buffer,
                -- then enable it, otherwise disable it
                if vim.b.disable_autoformat then
                    vim.cmd("FormatEnable")
                    vim.notify("Enabled autoformat for current buffer")
                else
                    vim.cmd("FormatDisable!")
                    vim.notify("Disabled autoformat for current buffer")
                end
            end,
            desc = "Toggle autoformat for current buffer",
        },
        {
            "<leader>tF",
            function()
                -- If autoformat is currently disabled globally,
                -- then enable it globally, otherwise disable it globally
                if vim.g.disable_autoformat then
                    vim.cmd("FormatEnable")
                    vim.notify("Enabled autoformat globally")
                else
                    vim.cmd("FormatDisable")
                    vim.notify("Disabled autoformat globally")
                end
            end,
            desc = "Toggle autoformat globally",
        },
    },
    opts = {
        notify_on_error = false,
        formatters_by_ft = {
            lua = { "stylua" },
            python = { "ruff" },
            cpp = { "clang_format" },
            c = { "clang_format" },
            sh = { "shfmt" },
        },
        formatters = {
            clang_format = {
                prepend_args = { '-style="{IndentWidth: 4}"' },
                ---     prepend_args = { "--style=file:/home/myname/myproject1/.clang-format" },
            },
            shfmt = {
                prepend_args = { "-i", "2", "-ci", "-bn" },
            },
        },
    },
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
        -- Disable autoformat for files in a certain path
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname:match("/node_modules/") then
            return
        end
        -- Disable autoformat on certain filetypes
        local ignore_filetypes = { "c", "cpp", "sh", "py" }
        if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
            return
        end
        return {
            timeout_ms = 500,
            lsp_format = "fallback",
        }
    end,
}
