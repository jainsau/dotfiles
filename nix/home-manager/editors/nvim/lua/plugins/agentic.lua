return {
  {
    'carlos-algms/agentic.nvim',
    opts = {
      provider = 'pi-acp',
      diff_preview = {
        enabled = true,
        layout = 'split',
        center_on_navigate_hunks = true,
      },
      provider_switcher = {
        hide_unhealthy_providers = true,
      },
    },
    keys = {
      {
        '<leader>aa',
        function()
          require('agentic').toggle()
        end,
        mode = { 'n', 'v' },
        desc = '[A]gentic [A]sk',
      },
      {
        '<leader>ac',
        function()
          require('agentic').add_selection_or_file_to_context()
        end,
        mode = { 'n', 'v' },
        desc = '[A]gentic add [C]ontext',
      },
      {
        '<leader>an',
        function()
          require('agentic').new_session()
        end,
        mode = { 'n', 'v' },
        desc = '[A]gentic [N]ew session',
      },
      {
        '<leader>ar',
        function()
          require('agentic').restore_session()
        end,
        mode = { 'n', 'v' },
        desc = '[A]gentic [R]estore session',
      },
      {
        '<leader>as',
        function()
          require('agentic').switch_provider()
        end,
        desc = '[A]gentic [S]witch provider',
      },
      {
        '<leader>ad',
        function()
          require('agentic').add_current_line_diagnostics()
        end,
        desc = '[A]gentic line [D]iagnostics',
      },
      {
        '<leader>aD',
        function()
          require('agentic').add_buffer_diagnostics()
        end,
        desc = '[A]gentic buffer [D]iagnostics',
      },
      {
        '<leader>ax',
        function()
          require('agentic').stop_generation()
        end,
        mode = { 'n', 'v' },
        desc = '[A]gentic stop generation',
      },
    },
  },
}
