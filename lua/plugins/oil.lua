return {
  'stevearc/oil.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('oil').setup({
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
    })

    vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open oil file browser' })

    -- Show git status markers on files in oil buffers
    local ns = vim.api.nvim_create_namespace("oil_git")

    local function apply_git_status(buf, dir)
      -- First async call: get repo root
      vim.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }, { text = true }, function(root_obj)
        if root_obj.code ~= 0 then return end
        local root = vim.trim(root_obj.stdout) .. "/"

        -- Second async call: get status relative to repo root
        vim.system({ "git", "-C", root, "status", "--porcelain" }, { text = true }, function(status_obj)
          if status_obj.code ~= 0 then return end

          -- Apply marks back on the main thread
          vim.schedule(function()
            if not vim.api.nvim_buf_is_valid(buf) then return end
            vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

            local statuses = {}
            for _, line in ipairs(vim.split(status_obj.stdout, "\n", { plain = true })) do
              if #line >= 4 then
                local xy = line:sub(1, 2)
                local abs = root .. line:sub(4):gsub("/$", "")
                if abs:sub(1, #dir) == dir then
                  local name = abs:sub(#dir + 1):match("^([^/]+)")
                  if name and not statuses[name] then
                    statuses[name] = xy
                  end
                end
              end
            end

            local oil = require("oil")
            local line_count = vim.api.nvim_buf_line_count(buf)
            for lnum = 1, line_count do
              local entry = oil.get_entry_on_line(buf, lnum)
              if entry then
                local xy = statuses[entry.name]
                if xy then
                  local hl
                  if xy == "??" then hl = "DiagnosticWarn"
                  elseif xy:find("M") then hl = "DiagnosticInfo"
                  elseif xy:find("A") then hl = "DiagnosticOk"
                  elseif xy:find("D") then hl = "DiagnosticError"
                  else hl = "Comment"
                  end
                  vim.api.nvim_buf_set_extmark(buf, ns, lnum - 1, 0, {
                    virt_text = {{ xy:gsub(" ", "-"), hl }},
                    virt_text_pos = "eol",
                  })
                end
              end
            end
          end)
        end)
      end)
    end

    -- OilEnter fires after oil has fully rendered, unlike BufEnter
    vim.api.nvim_create_autocmd("User", {
      pattern = "OilEnter",
      callback = function(args)
        local buf = args.data and args.data.buf or args.buf
        local dir = require("oil").get_current_dir(buf)
        if dir then apply_git_status(buf, dir) end
      end,
    })
  end,
}
