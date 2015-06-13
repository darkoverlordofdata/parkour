Rock = cc.Class.extend

  world   : null
  sprite  : null
  shape   : null
  map     : 0 # which map belong to

  getShape: -> @shape

  ctor: (spriteSheet, world, posX) ->
    @world = world
    @sprite = new cc.PhysicsSprite("#rock.png")
    body = new cp.StaticBody()
    body.setPos(cc.p(posX.x, @sprite.getContentSize().height / 2 + groundHeight))
    @sprite.setBody(body)

    @shape = new cp.BoxShape(body, @sprite.getContentSize().width, @sprite.getContentSize().height)
    @shape.setCollisionType(SpriteTag.rock)

    @world.addStaticShape(@shape)
    spriteSheet.addChild(@sprite)
    return

  removeFromParent: ->
    @world.removeStaticShape(@shape)
    @shape = null
    @sprite.removeFromParent()
    @sprite = null
    return

