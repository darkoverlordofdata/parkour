class Point

  constructor: (x, y) ->
    @X = x
    @Y = y

# class define
class SimpleRecognizer

  points: null
  result: null
  getPoints: () -> @points

  constructor: ->
    @points = []
    @result = ''

  # be called in onTouchBegan
  beginPoint: (x, y) ->
    @points = []
    @result = ''
    @points.push(new Point(x, y))
    return

  
  # be called in onTouchMoved
  movePoint: (x, y) ->
    @points.push(new Point(x, y))

    return if @result is 'not supported'
      
  
    newRtn = ''
    len = @points.length
    dx = @points[len - 1].X - @points[len - 2].X
    dy = @points[len - 1].Y - @points[len - 2].Y
  
    if Math.abs(dx) > Math.abs(dy)
      if dx > 0
        newRtn = 'right'
      else
        newRtn = 'left'

    else
      if dy > 0
        newRtn = 'up'
      else
        newRtn = 'down'

    # first set result
    if @result is ''
      @result = newRtn
      return

  
    # if diretcory change, not support Recongnizer
    if @result isnt newRtn
      @result = 'not support'

    return


# be called in onTouchEnded
  endPoint: () ->
    if @points.length < 3
      return 'error'

    return @result

  

