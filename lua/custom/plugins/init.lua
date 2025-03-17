-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { --Markdown preview
    'iamcco/markdown-preview.nvim',
    cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
    build = 'cd app && yarn install',
    init = function()
      vim.g.mkdp_filetypes = { 'markdown' }
    end,
    ft = { 'markdown' },
  },
  {
    'Hoffs/omnisharp-extended-lsp.nvim',
    lazy = false,
  },
  {
    'javiorfo/nvim-soil',

    -- Optional for puml syntax highlighting:
    -- dependencies = { 'javiorfo/nvim-nyctophilia' },

    lazy = true,
    ft = 'plantuml',
    opts = {
      -- If you want to change default configurations

      -- If you want to use Plant UML jar version instead of the install version
      puml_jar = 'C:\\"Program Files"\\Plantuml\\plantuml.jar',

      -- If you want to customize the image showed when running this plugin
      image = {
        darkmode = false, -- Enable or disable darkmode
        format = '-tsvg', -- Choose between png or svg

        -- This is a default implementation of using nsxiv to open the resultant image
        -- Edit the string to use your preferred app to open the image (as if it were a command line)
        -- Some examples:
        -- return "feh " .. img
        -- return "xdg-open " .. img
        execute_to_open = function(img)
          print(string.format('Opening image %s', img))
          -- return 'C:\\"Program Files"\\Google\\Chrome\\Application\\chrome.exe --app=' .. img
          return img
        end,
      },
    },
  },
  {
    'tyru/open-browser.vim',
  },
  {
    'aklt/plantuml-syntax',
  },
}
