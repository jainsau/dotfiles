local status_ok, tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

local g = vim.g

g.show_icons = {
    git = 1,
    folders = 1,
    files = 1,
    folder_arrows = 0,
    tree_width = 40,
  }

tree.setup {
  disable_netrw       = true,
  open_on_setup       = true,
  auto_close          = true,
  open_on_tab         = true,
  hijack_cursor       = true,
  update_cwd          = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  view = {
    width = 40,
    height = 30,
    hide_root_folder = false,
    side = 'left',
    auto_resize = false,
    mappings = {
      custom_only = false,
      list = {}
    },
    number = true,
    relativenumber = true,
    signcolumn = "yes"
  },
  actions = {
    change_dir = {
      enable = true,
      global = true,
    },
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = {
            "notify",
            "packer",
            "qf"
          }
        }
      }
    }
  }
}
