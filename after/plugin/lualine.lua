require("lualine").setup {
    options = {
        icons_enabled = true,
        theme = "powerline",
    },
    sections = {
        lualine_b = {
            {
                "filename",
                path = 4
            }
        }
    }
}
