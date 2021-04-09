-- mono.moon
-- SFZILabs 2021

defaults = (Object, Props) ->
    Object[i] = v for i, v in pairs Props when Object[i] == nil

reduce = (List, Fn, State) -> -- Reduces list to single value, state defaults to first value
    for I, V in pairs List
        State = if State == nil and I == 1 -- skip the first
            V -- default to first value
        else Fn State, V, I, List

    State

map = (List, Fn) -> {I, Fn V, I, List for I, V in pairs List}

unary = (Fn) -> (V) -> Fn V

max = (List) -> reduce List, (s, v) -> math.max s, v

-- 'hello' -> 'hello         '
AlignLeft = (Str, Width, Fill = ' ') ->
    while #Str < Width
        Str ..= Fill

    Str

-- 'hello' -> '         hello'
AlignRight = (Str, Width, Fill = ' ') ->
    while #Str < Width
        Str = Fill..Str

    Str

-- 'hello' -> '    hello     '
AlignCenter = (Str, Width, Fill = ' ') ->
    S = AlignRight Str, Width/2 + #Str/2, Fill
    AlignLeft S, Width, Fill

TextTable = (Rows, Options = {}) ->
    defaults Options, {
        align: {}
        widths: {}
        left: ''
        sep: ' '
        right: ''
    }

    -- Get column count
    Columns = max map Rows, (Row, I) ->
        assert 'table' == type(Row), 'invalid row at index ' .. I
        #Row

    Options.columns = Columns

    -- Get width of each column 
    Widths = {}
    for i = 1, Columns
        Widths[i] = max map Rows, (Row) ->
            W = if D = Row[i]
                #tostring D
            else 0

            if A = tonumber Options.widths[i]
                W = math.max W, A

            W

    -- Default aligns
    Aligns = map Widths, (I) => Options.align[I] or 'left'

    -- Fill empty columns
    FilledRows = map Rows, (Row, I) ->
        R = map Row, unary tostring
        while #R < Columns
            table.insert R, ''
            
        R

    -- Return array of strings
    map FilledRows, (R) ->
        S = Options.left
        for i, Data in pairs R
            Width = Widths[i]
            S ..= switch Aligns[i]
                when 'left', 'l'
                    AlignLeft Data, Width
                when 'right', 'r'
                    AlignRight Data, Width
                when 'center', 'c'
                    AlignCenter Data, Width
                else error "invalid align! \'#{Aligns[i]}\'"

            if i != Columns
                S ..= Options.sep

        S .. Options.right

TextTable
