GameLayer = cc.Layer.extend

  ash             : null
  reg             : null
  entities        : null
  world           : null
  player          : null
  hud             : null


  ctor : ->
    @_super()

    @ash = new ash.core.Engine()
    @reg = new ash.ext.Helper(Components, Nodes)
    @world = new cp.Space()

    @entities = new Entities(this)
    @entities.createPhysics(0, -350)
    @entities.createImage(0, 0, res.PlayBG_png)
    @entities.createTileMap(res.map00_tmx, res.map01_tmx, res.background_plist, res.background_png)

    @hud = @entities.createHud(0, 3)
    @player = @entities.createRunner(res.runner_plist, res.runner_png)

    @ash.addSystem(new RenderSystem(this), SystemPriorities.render)
    @ash.addSystem(new TileMapSystem(this), SystemPriorities.render)
    @ash.addSystem(new HudSystem(this), SystemPriorities.render)
    @ash.addSystem(new PlayerSystem(this), SystemPriorities.move)
    @ash.addSystem(new PhysicsSystem(this), SystemPriorities.resolveCollisions)
    @scheduleUpdate()
    return

  update: (dt) ->
    @ash.update(dt)
    return

GameLayer.scene = ->
  scene = new cc.Scene()
  scene.addChild(new GameLayer())
  return scene

