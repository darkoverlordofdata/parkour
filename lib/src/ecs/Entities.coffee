#
# Entities
#
class Entities

  ###
   * Imports
  ###
  Display         = Components.Display
  Gravity         = Components.Gravity
  Hud             = Components.Hud
  Player          = Components.Player
  TileMap         = Components.TileMap
  Transform       = Components.Transform
  Entity          = ash.core.Entity

  ash             : null  # Ash Engine
  game            : null  # parent game layer
  world           : null  # physics model

  constructor: (@game) ->
    @ash = @game.ash
    @world = @game.world


  destroyEntity: (entity) ->
    @ash.removeEntity entity
    return


  ###
   * Image
   *
   * @param x
   * @param y
   * @param path
   * @return image
  ###
  createImage: (x, y, path, alpha=1) ->

    sprite = new cc.Sprite(path)
    @game.addChild(sprite)

    image = new Entity()
    image.add(new Display(sprite))
    image.add(new Transform(x, y, alpha))
    @ash.addEntity(image)
    return image


  ###
   * TileMap
   *
   * @param tmx00 even map
   * @param tmx01 odd map
   * @param plist map to packed png
   * @param png plist data
   * @return tilemap
  ###
  createTileMap: (tmx00, tmx01, plist, png) ->

    map00 = new cc.TMXTiledMap(tmx00)
    @game.addChild(map00)
    mapWidth = map00.getContentSize().width

    map01 = new cc.TMXTiledMap(tmx01)
    map01.setPosition(cc.p(mapWidth, 0))
    @game.addChild(map01)

    cc.spriteFrameCache.addSpriteFrames(plist)
    spriteSheet = new cc.SpriteBatchNode(png)
    @game.addChild(spriteSheet)

    tilemap = new Entity()
    tilemap.add(new TileMap(mapWidth, spriteSheet, map00, map01))
    @ash.addEntity(tilemap)
    return tilemap

  ###
   * Physics
   *
   * @param x - gravity
   * @param y - gravity
   * @return physics
  ###
  createPhysics: (gravityX, gravityY) ->
    @world.gravity = cp.v(gravityX, gravityY)
    wallBottom = new cp.SegmentShape(@world.staticBody,
      cp.v(0, groundHeight),          # start point
      cp.v(4294967295, groundHeight), # MAX INT:4294967295
      0)                                # thickness of walls

    @world.addStaticShape(wallBottom)

    physics = new Entity()
    physics.add(new Gravity(gravityX, gravityY))
    @ash.addEntity(physics)
    return physics


  ###
   * Runner
   *
   * @param plist map to packed png
   * @param png image data
   * @return runner
  ###
  createRunner: (plist, png) ->
    cc.spriteFrameCache.addSpriteFrames(plist)
    spriteSheet = new cc.SpriteBatchNode(png)
    @game.addChild(spriteSheet)

    # Runner
    animFrames = (cc.spriteFrameCache.getSpriteFrame("runner#{i}.png") for i in [0...8])
    animation = new cc.Animation(animFrames, 0.1)
    runningAction = new cc.RepeatForever(new cc.Animate(animation))
    runningAction.retain()

    # Runner Jump Up
    animFrames = (cc.spriteFrameCache.getSpriteFrame("runnerJumpUp#{i}.png") for i in [0...4])
    animation = new cc.Animation(animFrames, 0.2)
    jumpUpAction = new cc.RepeatForever(new cc.Animate(animation))
    jumpUpAction.retain()

    # Runner Jump Down
    animFrames = (cc.spriteFrameCache.getSpriteFrame("runnerJumpDown#{i}.png") for i in [0...2])
    animation = new cc.Animation(animFrames, 0.3)
    jumpDownAction = new cc.RepeatForever(new cc.Animate(animation))
    jumpDownAction.retain()

    # 1. create PhysicsSprite with a sprite frame name
    sprite = new cc.PhysicsSprite("#runner0.png")
    contentSize = sprite.getContentSize()
    #  2. init the runner physic body
    body = new cp.Body(1, cp.momentForBox(1, contentSize.width, contentSize.height))
    # 3. set the position of the runner
    body.p = cc.p(runnerStartX, groundHeight + contentSize.height / 2)
    # 4. apply impulse to the body
    body.applyImpulse(cp.v(150, 0), cp.v(0, 0))# run speed
    # 5. add the created body to space
    @world.addBody(body)
    # 6. create the shape for the body
    shape = new cp.BoxShape(body, contentSize.width - 14, contentSize.height)
    # 7. add shape to space
    @world.addShape(shape)
    # 8. set body to the physic sprite
    sprite.setBody(body)
    sprite.runAction(runningAction)
    spriteSheet.addChild(sprite)

    runner = new Entity()
    runner.add(new Player(sprite, body, runningAction, jumpUpAction, jumpDownAction))
    @ash.addEntity(runner)
    return runner

  ###
   * Hud
   *
   * @param score
   * @param lives
   * @return hud
  ###
  createHud: (coins, meter, lives) ->

    winsize = cc.director.getWinSize()

    labelCoin = new cc.LabelTTF("Coins:0", "Helvetica", 20)
    labelCoin.setColor(cc.color(0,0,0)) #black color
    labelCoin.setPosition(cc.p(70, winsize.height - 20))
    @game.addChild(labelCoin)

    labelMeter = new cc.LabelTTF("0M", "Helvetica", 20)
    labelMeter.setPosition(cc.p(winsize.width - 70, winsize.height - 20))
    @game.addChild(labelMeter)

    hud = new Entity()
    hud.add(new Hud(coins, meter, lives, labelCoin, labelMeter))
    @ash.addEntity(hud)
    return hud
