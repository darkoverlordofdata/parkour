AnimationLayer = cc.Layer.extend

  spriteSheet     : null
  runningAction   : null
  sprite          : null
  world           : null
  body            : null
  shape           : null
  jumpUpAction    : null
  jumpDownAction  : null
  recognizer      : null
  stat            : RunnerStat.running

  ctor: (world) ->
    @_super()
    @world = world
    @init()
    @_debugNode = new cc.PhysicsDebugNode(@world)
    @_debugNode.setVisible(false)
    @addChild(@_debugNode, 10)
    return

  getEyeX: -> @sprite.getPositionX() - runnerStartX


  init:->
    @_super()
    # create sprite sheet
    cc.spriteFrameCache.addSpriteFrames(res.runner_plist)
    @spriteSheet = new cc.SpriteBatchNode(res.runner_png)
    @addChild(@spriteSheet)
    @initAction()
    # 1. create PhysicsSprite with a sprite frame name
    @sprite = new cc.PhysicsSprite("#runner0.png")
    contentSize = @sprite.getContentSize()
    #  2. init the runner physic body
    @body = new cp.Body(1, cp.momentForBox(1, contentSize.width, contentSize.height))
    # 3. set the position of the runner
    @body.p = cc.p(runnerStartX, groundHeight + contentSize.height / 2)
    # 4. apply impulse to the body
    @body.applyImpulse(cp.v(150, 0), cp.v(0, 0))# run speed
    # 5. add the created body to space
    @world.addBody(@body)
    # 6. create the shape for the body
    @shape = new cp.BoxShape(@body, contentSize.width - 14, contentSize.height)
    # 7. add shape to space
    @world.addShape(@shape)
    # 8. set body to the physic sprite
    @sprite.setBody(@body)
    @sprite.runAction(@runningAction)
    @spriteSheet.addChild(@sprite)
    cc.eventManager.addListener(
      event: cc.EventListener.TOUCH_ONE_BY_ONE
      swallowTouches: true
      onTouchBegan: @onTouchBegan
      onTouchMoved: @onTouchMoved
      onTouchEnded: @onTouchEnded
    , this)
    @recognizer = new SimpleRecognizer()
    return

  update: (dx) ->
    statusLayer = @getParent().getParent().getChildByTag(LayerTag.Hud)
    statusLayer.updateMeter(@sprite.getPositionX() - runnerStartX)

    vel = this.body.getVel()
    if @stat is RunnerStat.jumpUp
      if vel.y < 0.1
        @stat = RunnerStat.jumpDown
        @sprite.stopAllActions()
        @sprite.runAction(@jumpDownAction)

    else if @stat is RunnerStat.jumpDown
      if vel.y is 0
        @stat = RunnerStat.running
        @sprite.stopAllActions()
        @sprite.runAction(@runningAction)

    return

  initAction: ->

    # Runner
    animFrames = (cc.spriteFrameCache.getSpriteFrame("runner#{i}.png") for i in [0...8])
    animation = new cc.Animation(animFrames, 0.1)
    @runningAction = new cc.RepeatForever(new cc.Animate(animation))
    @runningAction.retain()

    # Runner Jump Up
    animFrames = (cc.spriteFrameCache.getSpriteFrame("runnerJumpUp#{i}.png") for i in [0...4])
    animation = new cc.Animation(animFrames, 0.2)
    @jumpUpAction = new cc.RepeatForever(new cc.Animate(animation))
    @jumpUpAction.retain()

    # Runner Jump Down
    animFrames = (cc.spriteFrameCache.getSpriteFrame("runnerJumpDown#{i}.png") for i in [0...2])
    animation = new cc.Animation(animFrames, 0.3)
    @jumpDownAction = new cc.RepeatForever(new cc.Animate(animation))
    @jumpDownAction.retain()

    return


  jump: ->
    cc.log("jump")
    if @stat is RunnerStat.running
      @body.applyImpulse(cp.v(0, 250), cp.v(0, 0))
      @stat = RunnerStat.jumpUp
      @sprite.stopAllActions()
      @sprite.runAction(@jumpUpAction)
      cc.audioEngine.playEffect(res.jump_mp3)
      return

  onTouchBegan: (touch, event) ->
    pos = touch.getLocation()
    event.getCurrentTarget().recognizer.beginPoint(pos.x, pos.y)
    return true

  onTouchMoved: (touch, event) ->
    pos = touch.getLocation()
    event.getCurrentTarget().recognizer.movePoint(pos.x, pos.y)
    return

  onTouchEnded: (touch, event) ->
    rtn = event.getCurrentTarget().recognizer.endPoint()
    cc.log("rtn = " + rtn)

    switch rtn
      when 'up' then  event.getCurrentTarget().jump()
    return

  onExit: ->
    @runningAction.release()
    @jumpUpAction.release()
    @jumpDownAction.release()
    @_super()
    return
