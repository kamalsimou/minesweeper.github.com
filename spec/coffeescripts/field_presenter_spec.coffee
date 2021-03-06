describe 'minesweeper', ->
  right_click = (row, col) ->
    $("#g1r#{row}c#{col}").trigger type: 'mouseup', which: 2

  left_click = (row, col) ->
    $("#g1r#{row}c#{col}").trigger type: 'mouseup', which: 1

  left_press = (row, col) ->
    $("#g1r#{row}c#{col}").trigger type: 'mousedown', which: 1

  double_click = (row, col) ->
    $("#g1r#{row}c#{col}").trigger type: 'dblclick', which: 1

  indicator_press = ->
    $("#g1indicator").trigger type: 'mousedown'

  cls = (id) ->
    $("##{id}").attr 'class'

  indicator_click = ->
    $("#g1indicator").trigger type: 'mouseup'

  indicator_class = ->
    cls 'g1indicator'

  cell_state = (row, col) -> cls "g1r#{row}c#{col}"

  remaining_mines = ->
    lcd_digit = (exponent) ->
      match = /lcd n(\d)/.exec cls "g1minesRemaining#{exponent}s"
      match[1]
    parseInt "#{lcd_digit 100}#{lcd_digit 10}#{lcd_digit 1}"

  givenField = (s) ->
    mines = []
    lines = s.split "\n"
    lastrow = null
    _.each lines, (line, row) ->
      lastrow = line.split " "
      _.each lastrow, (char, col) ->
        mines.push [row, col] if char=='*'
    FieldPresenter.render '#jasmine_content',
      cols: lastrow.length
      rows: lines.length
      mines: mines
      mineCount: mines.length

  it 'should display test mode when specifying mine locations', ->
    FieldPresenter.render '#jasmine_content',
      cols: 2
      rows: 2
      mines: [[0, 0]]
    expect($("#test_mode").text()).toEqual 'TEST MODE'

  it 'should not display test mode when using random mines', ->
      FieldPresenter.render '#jasmine_content',
        cols: 2
        rows: 2
        mineCount = 1
      expect($("#test_mode").text()).toEqual ''

  it 'should cycle through marked to uncertain to unclicked on right click', ->
    givenField """
    * .
    """
    expect(cell_state(0 ,0)).toEqual 'unclicked'
    right_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'marked'
    right_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'uncertain'
    right_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'unclicked'

  it 'should reveal cell with no adjacent mines', ->
    givenField """
    . .
    """
    left_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'mines0'

  it 'should reveal cell with one adjacent mine', ->
    givenField """
    . *
    """
    left_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'mines1'

  it 'should reveal cell with two adjacent mines', ->
    givenField """
    . *
    * .
    """
    left_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'mines2'

  it 'should reveal cell with three adjacent mines', ->
    givenField """
    . *
    * *
    """
    left_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'mines3'

  it 'should reveal cell with four adjacent mines', ->
    givenField """
    * . *
    . * *
    """
    left_click 0, 1
    expect(cell_state(0 ,1)).toEqual 'mines4'

  it 'should reveal cell with five adjacent mines', ->
    givenField """
    * . *
    * * *
    """
    left_click 0, 1
    expect(cell_state(0 ,1)).toEqual 'mines5'

  it 'should reveal cell with six adjacent mines', ->
    givenField """
    * . .
    * . *
    * * *
    """
    left_click 1, 1
    expect(cell_state(1 ,1)).toEqual 'mines6'

  it 'should reveal cell with six adjacent mines', ->
    givenField """
    * * .
    * . *
    * * *
    """
    left_click 1, 1
    expect(cell_state(1 ,1)).toEqual 'mines7'

  it 'should reveal cell with six adjacent mines', ->
    givenField """
    * * *
    * . *
    * * *
    """
    left_click 1, 1
    expect(cell_state(1 ,1)).toEqual 'mines8'

  it 'should reveal adjacent cells when there are no adjacent mines', ->
    givenField """
    . .
    . .
    * .
    """
    left_click 0, 0
    expect(cell_state(0, 0)).toEqual 'mines0'
    expect(cell_state(0, 1)).toEqual 'mines0'
    expect(cell_state(1, 0)).toEqual 'mines1'
    expect(cell_state(1, 1)).toEqual 'mines1'
    expect(cell_state(2, 1)).toEqual 'unclicked'

  it 'should display depressed button when indicator button is clicked', ->
    givenField """
    .
    """
    indicator_press()
    expect(indicator_class()).toEqual 'status alivePressed'

  it 'should reset game when indicator button is clicked', ->
    givenField """
    .
    """
    expect(cell_state(0, 0)).toEqual 'unclicked'
    left_click 0, 0
    expect(cell_state(0, 0)).toEqual 'mines0'
    indicator_click()
    expect(cell_state(0, 0)).toEqual 'unclicked'

  it 'should display initial mine count', ->
    givenField """
    * .
    """
    expect(remaining_mines()).toEqual 1

  it 'should decrement mine count when a mine is marked', ->
    givenField """
    * .
    """
    right_click 0, 0
    expect(remaining_mines()).toEqual 0

  it 'should reincrement mine count when a mine is marked and then unmarked', ->
    givenField """
    * .
    """
    right_click 0, 0
    right_click 0, 0
    expect(remaining_mines()).toEqual 1

  it 'should ignore attempts to mark a mine when the full number of mines have been marked', ->
    givenField """
    * .
    """
    right_click 0, 0
    right_click 0, 1
    expect(remaining_mines()).toEqual 0

  it 'should change game indicator to dead when a mine is clicked', ->
    givenField """
    * .
    """
    left_click 0, 0
    expect(indicator_class()).toEqual 'status dead'

  it 'should reveal all mines when a mine is clicked', ->
    givenField """
    * * .
    """
    left_click 0, 0
    expect(cell_state(0, 0)).toEqual 'clicked_mine'
    expect(cell_state(0, 1)).toEqual 'mine'

  it 'should ignore left clicks once a game has been lost', ->
    givenField """
    * .
    """
    left_click 0, 0
    left_click 0, 1
    expect(cell_state(0, 1)).toEqual 'unclicked'

  it 'should ignore right clicks once a game has been lost', ->
    givenField """
    * .
    """
    left_click 0, 0
    right_click 0, 1
    expect(cell_state(0, 1)).toEqual 'unclicked'

  it 'should ignore right clicks on marked once a game has been lost', ->
    givenField """
    * * .
    """
    right_click 0, 1
    expect(cell_state(0, 1)).toEqual 'marked'
    left_click 0, 0
    right_click 0, 1
    expect(cell_state(0, 1)).toEqual 'marked'

  it 'should ignore right clicks on uncertain once a game has been lost', ->
    givenField """
    * .
    """
    right_click 0, 1
    right_click 0, 1
    left_click 0, 0
    right_click 0, 1
    expect(cell_state(0, 1)).toEqual 'uncertain'

  it 'should change game indicator to won when the game has been won', ->
    givenField """
    * .
    """
    left_click 0, 1
    expect(indicator_class()).toEqual 'status won'

  it 'should change game indicator status to scared when the user is about to reveal a cell', ->
    givenField """
    * .
    """
    left_press 0, 1
    expect(indicator_class()).toEqual 'status scared'

  it 'should not change game indicator status to scared on a revealed cell', ->
    givenField """
    * . .
    """
    left_click 0, 1
    left_press 0, 1
    expect(indicator_class()).toEqual 'status alive'

  it 'should not change game indicator status to scared on a marked cell', ->
    givenField """
    * . .
    """
    right_click 0, 1
    left_press 0, 1
    expect(indicator_class()).toEqual 'status alive'

  it 'should not change game indicator status to scared on an uncertain cell', ->
    givenField """
    * . .
    """
    right_click 0, 1
    right_click 0, 1
    left_press 0, 1
    expect(indicator_class()).toEqual 'status alive'

  it 'should change game indicator status back from scared to alive when the user is has revealed a cell that does not have a mine', ->
    givenField """
    . *
    . .
    """
    left_press 0, 0
    expect(indicator_class()).toEqual 'status scared'
    left_click 0, 0
    expect(indicator_class()).toEqual 'status alive'

  it 'should change game indicator status back from scared to dead when the user is has revealed a cell that has a mine', ->
    givenField """
    . *
    . .
    """
    left_press 0, 1
    expect(indicator_class()).toEqual 'status scared'
    left_click 0, 1
    expect(indicator_class()).toEqual 'status dead'

  it 'should end the game when a cell containing mine is left clicked', ->
    givenField """
    * .
    . .
    """
    left_click 0, 0
    expect(indicator_class()).toEqual 'status dead'

  it 'should show a red mine on the mine you clicked on when a cell containing mine is left clicked', ->
    givenField """
    * .
    . .
    """
    left_click 0, 0
    expect(cell_state(0, 0)).toEqual 'clicked_mine'

  it 'should keep the flags on marked mines when a cell containing mine is left clicked', ->
    givenField """
    * *
    . .
    """
    right_click 0, 0
    left_click 0, 1
    expect(cell_state(0, 0)).toEqual 'marked'

  it 'should show a incorrect flag on falsely marked mines when a cell containing mine is left clicked', ->
    givenField """
    . *
    . .
    """
    right_click 0, 0
    left_click 0, 1
    expect(cell_state(0, 0)).toEqual 'nomine'


  it 'should ignore left clicks once a game has been won', ->
    givenField """
    * .
    """
    left_click 0, 1
    left_click 0, 0
    expect(cell_state(0, 0)).toEqual 'unclicked'

  it 'should click all non-marked neighbouring cells when double clicking a numeric cell', ->
    givenField """
    * . .
    . . .
    . . *
    """
    right_click 0, 0
    expect(cell_state(0 ,0)).toEqual 'marked'
    left_click  0, 1
    expect(cell_state(0 ,1)).toEqual 'mines1'
    double_click 0,1
    expect(cell_state(0 ,0)).toEqual 'marked'
    expect(cell_state(0 ,2)).toEqual 'mines0'
    expect(cell_state(1 ,0)).toEqual 'mines1'
    expect(cell_state(1 ,1)).toEqual 'mines2'
    expect(cell_state(1 ,2)).toEqual 'mines1'

  it 'should do nothing when double clicking a numeric cell with no surrounding marked cells', ->
    givenField """
    * . .
    . . .
    . . *
    """
    left_click  0, 1
    expect(cell_state(0 ,1)).toEqual 'mines1'
    double_click 0,1
    expect(indicator_class()).toEqual 'status alive'
    expect(cell_state(0 ,0)).toEqual 'unclicked'
    expect(cell_state(0 ,2)).toEqual 'unclicked'
    expect(cell_state(1 ,0)).toEqual 'unclicked'
    expect(cell_state(1 ,1)).toEqual 'unclicked'
    expect(cell_state(1 ,2)).toEqual 'unclicked'

  it 'should do nothing when double clicking a numeric cell with non-matching surrounding marked cells', ->
    givenField """
    * . .
    . . .
    . . *
    """
    left_click  1, 1
    expect(cell_state(1 ,1)).toEqual 'mines2'
    right_click 0, 0
    expect(cell_state(0, 0)).toEqual 'marked'
    double_click 1, 1
    expect(indicator_class()).toEqual 'status alive'
    expect(cell_state(0, 0)).toEqual 'marked'
    expect(cell_state(0, 1)).toEqual 'unclicked'
    expect(cell_state(0, 2)).toEqual 'unclicked'
    expect(cell_state(1, 0)).toEqual 'unclicked'
    expect(cell_state(1, 1)).toEqual 'mines2'
    expect(cell_state(1, 2)).toEqual 'unclicked'
    expect(cell_state(2, 0)).toEqual 'unclicked'
    expect(cell_state(2, 1)).toEqual 'unclicked'
    expect(cell_state(2, 2)).toEqual 'unclicked'

  it 'should end the game when double clicking a numeric cell with surrounding falsely marked cells', ->
    givenField """
    * . .
    . . .
    . . *
    """
    left_click  0, 1
    expect(cell_state(0 ,1)).toEqual 'mines1'
    right_click 1, 0
    expect(cell_state(1, 0)).toEqual 'marked'
    double_click 0, 1
    expect(indicator_class()).toEqual 'status dead'
    expect(cell_state(0 ,0)).toEqual 'clicked_mine'
    expect(cell_state(0 ,1)).toEqual 'mines1'
    expect(cell_state(0 ,2)).toEqual 'unclicked'
    expect(cell_state(1 ,0)).toEqual 'nomine'
    expect(cell_state(1 ,1)).toEqual 'unclicked'
    expect(cell_state(1 ,2)).toEqual 'unclicked'