local M = {}

local function get_absolute_git_dir_path()
  local absolute_git_dir = vim.fn.system("git rev-parse --absolute-git-dir | tr -d '\n'")
  absolute_git_dir = vim.fn.fnamemodify(absolute_git_dir, ":p")
  return absolute_git_dir
end

local function get_git_toplevel_path()
  local git_toplevel = vim.fn.system("git rev-parse --show-toplevel | tr -d '\n'")
  git_toplevel = vim.fn.fnamemodify(git_toplevel, ":p")
  return git_toplevel
end

local function get_git_exclude_file_path()
  local absolute_git_dir = get_absolute_git_dir_path()
  return absolute_git_dir .. "info/exclude"
end

function M.get_scratchpad_dir(parent_dir)
  if parent_dir == nil then
    parent_dir = get_git_toplevel_path()
  end
  return parent_dir .. ".scratchpad"
end

function M.get_note_path(scratchpad_dir)
  return scratchpad_dir .. "/scratch.md"
end

function M.vim_open_file(file_path)
  vim.cmd(":e " .. file_path)
end

function M.gitExcludeScratchpad()
  local git_exclude_path = get_git_exclude_file_path()
  local exclude_file = io.open(git_exclude_path, "a+")

  if exclude_file then
    for line in exclude_file:lines() do
      local search = line:match("^%.scratchpad/%*")
      if search then
        return nil
      end
    end

    exclude_file:write("\n.scratchpad/*")
    exclude_file:close()
  end
end

return M