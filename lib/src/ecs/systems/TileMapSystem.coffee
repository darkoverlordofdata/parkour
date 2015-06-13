
class TileMapSystem extends ash.tools.ListIteratingSystem

  first: true
  level: null
  world: null
  objects: null
  player: null
  mapIndex: 0
  deadPool  : null

  constructor: (@game) ->
    super(@game.reg.nodes.TileMapNode, @updateNode)
    @world = @game.world
    @player = @game.player
    @objects = []
    @deadPool = []
    Reg.scored.add (points, shapes) =>
      console.log 'Score ',points
      @deadPool.push(shapes[1])

  updateNode: (node, time) =>

    map00 = node.tilemap.map00
    map01 = node.tilemap.map01
    mapWidth = node.tilemap.mapWidth
    spriteSheet = node.tilemap.spriteSheet

    if @first
      @first = false
      @loadObjects(map00, 0, mapWidth, spriteSheet)
      @loadObjects(map01, 1, mapWidth, spriteSheet)

    x = @player.get(Components.Player).sprite.getPositionX() - runnerStartX
    newMapIndex = parseInt(x / mapWidth)
    if @mapIndex isnt newMapIndex

      if 0 is newMapIndex % 2
        map01.setPositionX(mapWidth * (newMapIndex + 1))
        @loadObjects(map01, newMapIndex  + 1, mapWidth, spriteSheet)

      else
        map00.setPositionX(mapWidth * (newMapIndex + 1))
        @loadObjects(map00, newMapIndex + 1, mapWidth, spriteSheet)

      @removeObjects(newMapIndex - 1)
      @mapIndex = newMapIndex

    while (shape = @deadPool.pop())?
      @removeObjectByShape(shape)

    return


  loadObjects: (map, mapIndex, mapWidth, spriteSheet) ->

    coinGroup = map.getObjectGroup('coin')
    coinArray = coinGroup.getObjects()
    for p in coinArray
      coin = new Coin(spriteSheet, @world, cc.p(p["x"] + mapWidth * mapIndex, p["y"]))
      coin.mapIndex = mapIndex
      @objects.push(coin)

    rockGroup = map.getObjectGroup('rock')
    rockArray = rockGroup.getObjects()
    for p in rockArray
      rock = new Rock(spriteSheet, @world, cc.p(p["x"] + mapWidth * mapIndex, p["y"]))
      rock.mapIndex = mapIndex
      @objects.push(rock)
    return


  removeObjects: (mapIndex) ->
    return while do(obj = @objects, index = mapIndex) ->
      for i in [0...obj.length]
        if obj[i].mapIndex is index
          obj[i].removeFromParent()
          obj.splice(i, 1)
          return true
      return false

  removeObjectByShape: (shape) ->
    for i in [0...@objects.length]
      if @objects[i].getShape() is shape
        @objects[i].removeFromParent()
        @objects.splice(i, 1)
        break
    return
