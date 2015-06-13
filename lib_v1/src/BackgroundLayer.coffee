BackgroundLayer = cc.Layer.extend

  map00       : null
  map01       : null
  mapWidth    : 0
  mapIndex    : 0
  objects     : null
  world       : null
  spriteSheet : null

  ctor: (world) ->
    @_super()
    @objects = []
    @world = world
    @init()
    return

  init: ->
    @_super()
    @map00 = new cc.TMXTiledMap(res.map00_tmx)
    @addChild(@map00)
    @mapWidth = @map00.getContentSize().width

    @map01 = new cc.TMXTiledMap(res.map01_tmx)
    @map01.setPosition(cc.p(@mapWidth, 0))
    @addChild(@map01)

    cc.spriteFrameCache.addSpriteFrames(res.background_plist)
    @spriteSheet = new cc.SpriteBatchNode(res.background_png)
    @addChild(@spriteSheet)
    @loadObjects(@map00, 0)
    @loadObjects(@map01, 1)
    @scheduleUpdate()
    return

  checkAndReload: (eyeX) ->
    newMapIndex = parseInt(eyeX / @mapWidth)
    return false if @mapIndex is newMapIndex

    if 0 is newMapIndex % 2
      @map01.setPositionX(@mapWidth * (newMapIndex + 1))
      @loadObjects(@map01, newMapIndex  + 1)

    else
      @map00.setPositionX(@mapWidth * (newMapIndex + 1))
      @loadObjects(@map00, newMapIndex + 1)

    @removeObjects(newMapIndex - 1)
    @mapIndex = newMapIndex
    return true

  loadObjects: (map, mapIndex) ->

    coinGroup = map.getObjectGroup('coin')
    coinArray = coinGroup.getObjects()
    for p in coinArray
      coin = new Coin(@spriteSheet, @world, cc.p(p["x"] + @mapWidth * mapIndex, p["y"]))
      coin.mapIndex = mapIndex
      @objects.push(coin)

    rockGroup = map.getObjectGroup('rock')
    rockArray = rockGroup.getObjects()
    for p in rockArray
      rock = new Rock(@spriteSheet, @world, cc.p(p["x"] + @mapWidth * mapIndex, p["y"]))
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

  update: (dt) ->
    animationLayer = @getParent().getChildByTag(LayerTag.Animation)
    eyeX = animationLayer.getEyeX()
    @checkAndReload(eyeX)
    return

