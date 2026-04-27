-- ~/.config/nvim/init.lua
--------------------------

-- Server version with no dependencies / package manager

vim.g.mapleader = ","
vim.opt.termguicolors = true

-- Plugins
--------------------------

-- None

-- Theming
--------------------------

vim.wo.wrap = false
vim.wo.linebreak = true

vim.opt.cursorline = true

-- Languages
--------------------------

-- Default

-- LSP Diagnostics Options Setup
--------------------------

local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({ name = 'DiagnosticSignError', text = '✗' })
sign({ name = 'DiagnosticSignWarn', text = '⚠' })
sign({ name = 'DiagnosticSignHint', text = '💡' })
sign({ name = 'DiagnosticSignInfo', text = 'ℹ' })

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error
-- Show inlay_hints more frequently
-- vim.cmd([[
-- set signcolumn=yes
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
-- ]])

-- Completion
--------------------------

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
vim.opt.shortmess = vim.opt.shortmess + { c = true }
vim.api.nvim_set_option('updatetime', 300)

-- Backspace
--------------------------

-- indent    allow backspacing over autoindent
-- eol       allow backspacing over line breaks (join lines)
-- start     allow backspacing over the start of insert; CTRL-W and CTRL-U
--           stop once at the start of insert.
vim.opt.backspace = "indent,eol,start"

-- Navigation
--------------------------

vim.opt.foldenable = false -- Disable treesitter autofolding

vim.opt.mouse = 'a'        -- Mouse enabled for all modes

vim.opt.number = true
vim.wo.relativenumber = true
vim.cmd([[
    augroup numbertoggle
      autocmd!
      autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
      autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
    augroup END
]])

-- Open prev buffer when closing current, maintaining window splits
vim.keymap.set('n', '<leader>d', [[:b#<bar>bd#<CR>]], {})

-- Indentation
--------------------------

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.cmd([[
    autocmd BufEnter *.nim :setlocal tabstop=2 shiftwidth=2
    autocmd BufEnter *.nimble :setlocal tabstop=2 shiftwidth=2
]])

-- Clipboard
--------------------------

vim.opt.clipboard:append { 'unnamed', 'unnamedplus' }