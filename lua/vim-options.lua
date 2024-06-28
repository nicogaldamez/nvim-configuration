vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard=unnamed")
vim.cmd("set nowrap")
vim.g.mapleader = ","
vim.g.background = "light"

vim.opt.swapfile = false

-- Navigate vim panes better
vim.keymap.set('n', '<c-k>', ':wincmd k<CR>')
vim.keymap.set('n', '<c-j>', ':wincmd j<CR>')
vim.keymap.set('n', '<c-h>', ':wincmd h<CR>')
vim.keymap.set('n', '<c-l>', ':wincmd l<CR>')

-- Deletes lines with byebug, binding, or debugger
vim.keymap.set('n', '<leader>by', ':g/byebug\\|binding\\|debugger/d<cr>')

-- Shortcut to save
vim.keymap.set('n', '<leader><leader>', ':w<CR>', { noremap = true, silent = true })

-- Tab split
vim.keymap.set('n', 'tt', ':tab split<CR>')

-- Shortcut to quit
vim.keymap.set('n', '<leader>q', ':q<CR>')

vim.cmd("inoremap jk <esc>")
vim.cmd("inoremap jj <esc>")
vim.cmd("inoremap kk <esc>")
vim.cmd("inoremap kj <esc>")

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.wo.number = true

-- Function to strip trailing whitespace
local function strip_trailing_whitespace()
    -- Save current cursor position
    local save_cursor = vim.fn.getpos(".")
    -- Search and replace trailing whitespace
    vim.cmd([[%s/\s\+$//e]])
    -- Restore cursor position
    vim.fn.setpos(".", save_cursor)
end

-- Create an autocommand group
vim.api.nvim_create_augroup('StripTrailingWhitespace', { clear = true })

-- Add an autocommand to run the function on buffer write
vim.api.nvim_create_autocmd('BufWritePre', {
    group = 'StripTrailingWhitespace',
    pattern = '*',
    callback = strip_trailing_whitespace,
})
