-- === NEOVIM OPTIONS ===
local opt = vim.opt

opt.mouse = "a"                -- Enable mouse support, useful for resizing splits
opt.clipboard = 'unnamedplus'  -- Sync with system clipboard

opt.formatoptions = "t,r,o,q,n,j,l" -- Text format options

opt.expandtab = true           -- Use spaces instead of tabs while saving
opt.softtabstop = 2            -- Number of spaces for a tab key press
opt.tabstop = 2                -- Display width of a tab character
opt.shiftwidth = 2             -- Number of spaces for each level of indentation

opt.wrap = false               -- Do not wrap lines
opt.sidescroll = 5             -- Sensible horizontal scroll
opt.scrolloff = 10             -- Minimum visible lines above and below the cursor

opt.conceallevel = 3           -- Hide * markup for bold and italic
opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', eol = '↲' } -- Whitespace display

opt.completeopt = { "menu", "menuone", "preview", "noinsert" } -- Better completion experience

opt.splitbelow = true          -- Create new split window below
opt.splitright = true          -- Create new split window to the right

opt.virtualedit = "block"      -- Allow the cursor to move freely within a block selection
opt.termguicolors = true       -- Support 24 bit colors

opt.number = true              -- Print line number
opt.relativenumber = true      -- Relative line number

opt.signcolumn = "yes"         -- Always show the signcolumn
opt.showmode = false           -- Don't show mode, since it's already in status line
opt.cursorline = true          -- Enable highlighting of the current line

opt.hlsearch = true            -- Set highlight on search; clear on pressing
opt.inccommand = "split"       -- Preview and apply changes to a range of lines in real-time
opt.ignorecase = true          -- Perform case insensitive searches
opt.smartcase = true           -- Don't ignore case with capitals in search

opt.grepformat = "%f:%l:%c:%m" -- Output format of grep
opt.grepprg = "rg --vimgrep"   -- Use ripgrep with vim specific features

opt.updatetime = 250           -- Faster writes to disk (default: 4000)
opt.undofile = true            -- Save undo history across sessions
opt.confirm = true             -- Confirm to save changes before exiting modified buffer
