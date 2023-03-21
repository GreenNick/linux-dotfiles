local module = {}

module.tabline = function()
  local s = ''

  for tab = 1, vim.fn.tabpagenr('$') do
    if tab == vim.fn.tabpagenr() then
      s = s .. '%#TabLineSel#'
    else 
      s = s .. '%#TabLine#'
    end
    s = s .. ' ' .. module.label(tab) .. ' '
  end

  s = s .. '%#TabLineFill#%T'
  return s
end

module.label = function(tab)
  local label = ''
  local winnr = vim.fn.tabpagewinnr(tab)
  local buflist = vim.fn.tabpagebuflist(tab)

  for _, buf in ipairs(buflist) do
    if vim.fn.getbufvar(buf, '&modified') == 1 then
      label = label .. '+'  
      break
    end
  end  

  local cwd = vim.fn.getcwd(winnr, tab)
  local filename = vim.fn.bufname(buflist[winnr])

  label = label .. '[' .. vim.fs.basename(cwd) .. ']'
  if filename ~= '' then
    label = label .. ' ' .. vim.fs.basename(filename)
  end

  return label
end

local setup = function()
  vim.o.tabline = '%!v:lua.require(\'tabline\').module.tabline()'
end

return {
  module = module,
  setup = setup
}
