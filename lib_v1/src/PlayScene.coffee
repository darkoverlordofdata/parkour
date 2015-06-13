PlayScene = cc.Scene.extend

  world           : null
  gameLayer       : null
  shapesToRemove  : null


  initPhysics: ->
    @world = new cp.Space()
    @world.gravity = cp.v(0, -350)
    wallBottom = new cp.SegmentShape(@world.staticBody,
      cp.v(0, groundHeight),          # start point
      cp.v(4294967295, groundHeight), # MAX INT:4294967295
      0)                                # thickness of walls

    @world.addStaticShape(wallBottom)
    @world.addCollisionHandler(SpriteTag.runner, SpriteTag.coin,
      @collisionCoinBegin.bind(this), null, null, null)
    @world.addCollisionHandler(SpriteTag.runner, SpriteTag.rock,
      @collisionRockBegin.bind(this), null, null, null)

    return

  update: (dt) ->
    @world.step(dt)

    animationLayer = this.gameLayer.getChildByTag(LayerTag.Animation)
    eyeX = animationLayer.getEyeX()
    @gameLayer.setPosition(cc.p(-eyeX,0))

    for shape in @shapesToRemove
      @gameLayer.getChildByTag(LayerTag.Background).removeObjectByShape(shape)
    @shapesToRemove = []
    return


  onEnter:->
    @shapesToRemove = []
    @_super()
    @initPhysics()
    @gameLayer = new cc.Layer()
    #add three layer in the right order
    @gameLayer.addChild(new BackgroundLayer(@world), 0, LayerTag.Background)
    @gameLayer.addChild(new AnimationLayer(@world), 0, LayerTag.Animation)
    @addChild(this.gameLayer)
    @addChild(new HudLayer(), 0, LayerTag.Hud)
    cc.audioEngine.playMusic(res.background_mp3, true)
    @scheduleUpdate()
    return

  collisionCoinBegin: (arbiter, world) ->
    shapes = arbiter.getShapes()
    @shapesToRemove.push(shapes[1])
    statusLayer = @getChildByTag(LayerTag.Hud)
    cc.audioEngine.playEffect(res.pickup_coin_mp3)
    statusLayer.addCoin(1)
    return

  collisionRockBegin: (arbiter, world) ->
    cc.log("==game over")
    return
    cc.audioEngine.stopMusic()
    cc.director.pause()
    @addChild(new GameOverLayer())
    return
