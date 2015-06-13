
class PhysicsSystem extends ash.tools.ListIteratingSystem

  player: null  # player entity
  hud: null

  constructor: (@game) ->
    super(@game.reg.nodes.PhysicsNode, @updateNode)
    @world = @game.world
    @player = @game.player
    @hud = @game.hud
    @world.addCollisionHandler(SpriteTag.runner, SpriteTag.coin,
      @collisionCoinBegin.bind(this), null, null, null)
    @world.addCollisionHandler(SpriteTag.runner, SpriteTag.rock,
      @collisionRockBegin.bind(this), null, null, null)


  updateNode: (node, time) =>
    @world.step(time)
    x = @player.get(Components.Player).sprite.getPositionX() - runnerStartX
    @game.setPosition(cc.p(-x,0))
    return # Void


  collisionCoinBegin: (arbiter, world) ->
    Reg.scored.dispatch(1, arbiter.getShapes())
    @hud.get(Components.Hud).coins++
    cc.audioEngine.playEffect(res.pickup_coin_mp3)
    return

  collisionRockBegin: (arbiter, world) ->
    Reg.killed.dispatch() if @hud.get(Components.Hud).lives-- < 0
    #    cc.audioEngine.stopMusic()
    #    cc.director.pause()
    return

