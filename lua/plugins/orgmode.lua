return {
   {
      'nvim-orgmode/orgmode',
      dependencies = {
         { 'nvim-treesitter/nvim-treesitter', lazy = true },
      },
      ft = { 'org' },
      event = 'VeryLazy',
      -- event = { "BufRead", "BufNewFile" },
      config = function()
         -- Load treesitter grammar for org
         require('orgmode').setup_ts_grammar()

         -- Setup treesitter
         require('nvim-treesitter.configs').setup({
            highlight = {
               enable = true,
               additional_vim_regex_highlighting = { 'org' },
           },
            ensure_installed = { 'org' },
         })

         -- Setup orgmode
         require('orgmode').setup({
            org_agenda_files = '~/orgfiles/**/*',
            org_default_notes_file = '~/orgfiles/refile.org',
            org_todo_keywords = {
               'TODO(t)', 'NEXT(n)', 'WAITING(w)', 'POSTPONED(p)',
               'FEEDBACK(a)', 'VERIFY(v)',
               'REPORT(r)', 'BUG(b)', 'KNOWNCAUSE(k)',
               '|',
               'DONE(d)', 'CANCELED(c)', 'FIXED(f)'
            },
            org_todo_keyword_faces = {
               --   WAITING = ':foreground blue :weight bold',
               --   CANCELED = ':background #FFFFFF :slant italic :underline on',
               -- overrides builtin color for `TODO` keyword
               TODO = ':foreground #fdf6e3',
            },
            org_priority_highest = 'A',
            org_priority_default = 'B',
            org_priority_lowest = 'C',
            org_hide_leading_stars = true,
            org_hide_emphasis_markers = true,
            org_highlight_latex_and_related = "entities",
            org_indent_mode = 'indent',
            org_edit_src_content_indentation = 2,
            win_split_mode = 'vertical',
            notifications = {
             enabled = true,
             cron_enabled = true,
             repeater_reminder_time = { 30, 5, 1, 0 },
             deadline_warning_reminder_time = { 30, 0 },
             reminder_time = { 30, 5, 1, 0 },
             deadline_reminder = true,
             scheduled_reminder = true,
            },
         })
      end,
   }
}
