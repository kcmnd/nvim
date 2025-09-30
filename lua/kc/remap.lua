vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc = 'Telescope find files'})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc = 'Telescope live grep'})


-- Move current line down (normal mode)
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move line down', silent = true })

-- Move current line up (normal mode)
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move line up', silent = true })

-- Move selected lines down (visual mode)
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down', silent = true })

-- Move selected lines up (visual mode)
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up', silent = true })

-- Copy the error window from pyright
vim.keymap.set('n', '<leader>y', function()
    local d = vim.diagnostic.get(0, {lnum = vim.fn.line('.')-1})[1]
    if d then
        vim.fn.setreg('+', d.message)
        print("Copied diagnostic!")
    else
        print("No diagnostic here")
    end
end, { desc = "Copy LSP diagnostic under cursor", silent = true })
