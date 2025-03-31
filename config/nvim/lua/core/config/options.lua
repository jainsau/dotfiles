local opt = vim.opt

opt.mouse = "a"																												-- enable mouse support, useful for resizing splits for example
opt.clipboard = 'unnamedplus'                       									-- sync with system clipboard

opt.formatoptions = "t,r,o,q,n,j,l"		              									-- text format options

opt.expandtab = true                                									-- use spaces instead of tabs while saving
opt.softtabstop = 2	                                									-- number of spaces for a tab key press
opt.tabstop = 2	                                    									-- display width of a tab character
opt.shiftwidth = 2                                  									-- number of spaces for each level of indentation

opt.wrap = false                                    									-- wrap lines
opt.sidescroll = 5                                  									-- sensible horizontal scroll
opt.scrolloff = 10                                  									-- number of least visible lines above and below the cursor for better scrolling experience

opt.conceallevel = 3				                        									-- hide * markup for bold and italic
opt.listchars = { tab = '» ', trail = '·',	        									-- adjust whitespace display behaviour when enabled
		  nbsp = '␣', eol = '↲' }

opt.completeopt = { "menu", "menuone", "preview", "noinsert" }				-- set completeopt to have a better completion experience

opt.splitbelow = true																									-- create new split window below
opt.splitright = true                               									-- create new split window to the right

opt.virtualedit = "block"                           									-- allow the cursor to move freely within a block selection
opt.termguicolors = true                            									-- support 24 bit colors

opt.number = true                                   									-- print line number
opt.relativenumber = true                           									-- relative line number

opt.signcolumn = "yes"				                      									-- always show the signcolumn, otherwise it would shift the text each time
opt.showmode = false				                        									-- don't show mode, since it's already in status line
opt.cursorline = true				                        									-- enable highlighting of the current line

opt.hlsearch = true				                          									-- set highlight on search; clear on pressing
opt.inccommand = "split"                            									-- previewing and applying changes to a range of lines in real-time
opt.ignorecase = true                               									-- perform case insensitive searches
opt.smartcase = true				                        									-- don't ignore case with capitals in search

opt.grepformat = "%f:%l:%c:%m"			                									-- output format of grep
opt.grepprg = "rg --vimgrep"			                  									-- use ripgrep with vim specific features

opt.updatetime = 250				                        									-- faster writes to disk (default: 4000)
opt.undofile = true				                          									-- save undo history across sessions
opt.confirm = true				                          									-- confirm to save changes before exiting modified buffer
