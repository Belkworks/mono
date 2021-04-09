local defaults
defaults = function(Object, Props)
  for i, v in pairs(Props) do
    if Object[i] == nil then
      Object[i] = v
    end
  end
end
local reduce
reduce = function(List, Fn, State)
  for I, V in pairs(List) do
    if State == nil and I == 1 then
      State = V
    else
      State = Fn(State, V, I, List)
    end
  end
  return State
end
local map
map = function(List, Fn)
  local _tbl_0 = { }
  for I, V in pairs(List) do
    _tbl_0[I] = Fn(V, I, List)
  end
  return _tbl_0
end
local unary
unary = function(Fn)
  return function(V)
    return Fn(V)
  end
end
local max
max = function(List)
  return reduce(List, function(s, v)
    return math.max(s, v)
  end)
end
local AlignLeft
AlignLeft = function(Str, Width, Fill)
  if Fill == nil then
    Fill = ' '
  end
  while #Str < Width do
    Str = Str .. Fill
  end
  return Str
end
local AlignRight
AlignRight = function(Str, Width, Fill)
  if Fill == nil then
    Fill = ' '
  end
  while #Str < Width do
    Str = Fill .. Str
  end
  return Str
end
local AlignCenter
AlignCenter = function(Str, Width, Fill)
  if Fill == nil then
    Fill = ' '
  end
  local S = AlignRight(Str, Width / 2 + #Str / 2, Fill)
  return AlignLeft(S, Width, Fill)
end
local TextTable
TextTable = function(Rows, Options)
  if Options == nil then
    Options = { }
  end
  defaults(Options, {
    align = { },
    widths = { },
    left = '',
    sep = ' ',
    right = ''
  })
  local Columns = max(map(Rows, function(Row, I)
    assert('table' == type(Row), 'invalid row at index ' .. I)
    return #Row
  end))
  Options.columns = Columns
  local Widths = { }
  for i = 1, Columns do
    Widths[i] = max(map(Rows, function(Row)
      local W
      do
        local D = Row[i]
        if D then
          W = #tostring(D)
        else
          W = 0
        end
      end
      do
        local A = tonumber(Options.widths[i])
        if A then
          W = math.max(W, A)
        end
      end
      return W
    end))
  end
  local Aligns = map(Widths, function(self, I)
    return Options.align[I] or 'left'
  end)
  local FilledRows = map(Rows, function(Row, I)
    local R = map(Row, unary(tostring))
    while #R < Columns do
      table.insert(R, '')
    end
    return R
  end)
  return map(FilledRows, function(R)
    local S = Options.left
    for i, Data in pairs(R) do
      local Width = Widths[i]
      S = S .. (function()
        local _exp_0 = Aligns[i]
        if 'left' == _exp_0 or 'l' == _exp_0 then
          return AlignLeft(Data, Width)
        elseif 'right' == _exp_0 or 'r' == _exp_0 then
          return AlignRight(Data, Width)
        elseif 'center' == _exp_0 or 'c' == _exp_0 then
          return AlignCenter(Data, Width)
        else
          return error("invalid align! \'" .. tostring(Aligns[i]) .. "\'")
        end
      end)()
      if i ~= Columns then
        S = S .. Options.sep
      end
    end
    return S .. Options.right
  end)
end
return TextTable
