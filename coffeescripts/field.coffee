window.Field =
  new: (opts) ->
    opts.rows = 1 unless opts.rows
    opts.rows = 1 unless opts.rows > 0
    opts.cols = 2 unless opts.cols
    opts.cols = 2 unless opts.cols > 1
    opts.mineCount = 1 unless opts.mineCount
    opts.mineCount = 1 unless opts.mineCount > 0
    if opts.mineCount >= opts.rows * opts.cols
      opts.mineCount = opts.rows * opts.cols - 1

    adjacentCount = (row,col) ->
      iterator = (memo, neighbour) ->
        memo += 1 if hasMine neighbour[0], neighbour[1]
        memo
      _(neighbours(row,col)).reduce iterator, 0

    neighbours = (row, col) ->
      result = []
      append = (r, c) ->
        result.push [r, c] unless (r == row and c == col) or r < 0 or c < 0 or r >= opts.rows or c >= opts.cols
      ((append r,c for c in [col-1..col+1]) for r in [row-1..row+1])
      result

    hasMine = (row, col) ->
      unless opts.mines
        opts.mines = []
        randomRow = -> Math.floor Math.random()*opts.rows
        randomCol = -> Math.floor Math.random()*opts.cols
        addMine = ->
          [r,c] = [randomRow(), randomCol()]
          opts.mines.push [r,c] unless (row == r and col == c) or hasMine r, c
        addMine() until opts.mines.length == opts.mineCount
      _(opts.mines).any (mine) -> mine[0] == row and mine[1] == col

    opts: opts
    adjacentCount: adjacentCount
    neighbours: neighbours
    hasMine: hasMine