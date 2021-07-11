local vim = vim
local galaxyline = require('galaxyline')


local section = galaxyline.section

local colors = require("../colors/colors")

local mode_color = function()
  local mode_colors = {
    n = colors.base8,
    i = colors.base11,
    c = colors.base10,
    V = colors.base10,
    [''] = colors.base10,
    v = colors.base10,
    R = colors.base9,
  }

  local color = mode_colors[vim.fn.mode()]

  if color == nil then
    color = colors.red
  end

  return color
end

section.left[1] = {
  ViMode = {
    provider = function()
      vim.api.nvim_command('hi GalaxyViMode guibg='..mode_color())
      return ' '
    end,
    separator = '',
    highlight = {colors.base0, colors.base8},
    separator_highlight = {colors.base4, colors.base0 },
  }
}


section.left[2] = {
    current_dir = {
        provider = function()
            local dir_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
            return "   " .. dir_name .. "  "
        end,
        highlight = {colors.base5, colors.base2},
        separator = "",
        separator_highlight = {colors.base8, colors.base0}
    }
}

section.right[1] = {
  GitIcon = {
    provider = function() return ' ' end,
    condition = require('galaxyline.condition').check_git_workspace,
    highlight = {colors.base4,colors.base0},
  }
}

section.right[3] = {
     line_percentage = {
        provider = function()
            local current_line = vim.fn.line(".")
            local total_line = vim.fn.line("$")
            local result, _ = math.modf((current_line / total_line) * 100)
            -- return "   " .. result .. "%  "
            return string.format("   %2d%%  ", result) 
        end,
    highlight = {colors.base5,colors.base2},
    }
}

section.right[4] = {
  ViMode = {
    provider = function()
      -- vim.api.nvim_command('hi GalaxyViMode guibg='..mode_color())
      return ' '
    end,
    separator = '',
    highlight = {colors.base0, colors.base8},
    separator_highlight = {colors.base4, colors.base0 },
  }
}

-- section.right[1] = {
--     ShowLspClient = {
--     provider = get_lsp_client,
--     condition = function()
--       local tbl = { ["dashboard"] = true, [" "] = true }
--       if tbl[vim.bo.filetype] then
--         return false
--       end
--       return true
--     end,
--     icon = "  ",
--     highlight = "StatusLineNC",
--   },
-- }
--
section.short_line_left[1] = {
  BufferType = {
    provider = 'FileTypeName',
    separator = ' ',
    separator_highlight = {'NONE',colors.bg},
    highlight = {colors.base2,colors.base0,}
  }
}

section.short_line_right[1] = {
  BufferIcon = {
    provider= 'BufferIcon',
    highlight = {colors.base2,colors.base0}
  }
}


