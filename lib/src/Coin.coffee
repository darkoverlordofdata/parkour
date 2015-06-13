Coin = cc.Class.extend
  world     : null
  sprite    : null
  shape     : null
  mapIndex  : 0 # which map belongs to

  getShape: -> @shape

  ctor: (spriteSheet, world, pos) ->
    @world = world

    animFrames = (cc.spriteFrameCache.getSpriteFrame("coin#{i}.png") for i in [0...8])
    animation = new cc.Animation(animFrames, 0.2)
    action = new cc.RepeatForever(new cc.Animate(animation))
    @sprite = new cc.PhysicsSprite("#coin0.png")

    radius = 0.95 * @sprite.getContentSize().width / 2
    body = new cp.StaticBody()
    body.setPos(pos)
    @sprite.setBody(body)

    @shape = new cp.CircleShape(body, radius, cp.vzero)
    @shape.setCollisionType(SpriteTag.coin)

    @shape.setSensor(true)
    @world.addStaticShape(@shape)

    @sprite.runAction(action)
    spriteSheet.addChild(@sprite, 1)
    return

  removeFromParent: () ->
    @world.removeStaticShape(@shape)
    @shape = null
    @sprite.removeFromParent()
    @sprite = null
    return

