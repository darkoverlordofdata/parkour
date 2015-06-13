
class PlayerSystem extends ash.tools.ListIteratingSystem

  stat: RunnerStat.running
  hud: null

  constructor: (@game) ->
    super(@game.reg.nodes.PlayerNode, @updateNode)
    @hud = @game.hud


  updateNode: (node, time) =>

    vel = node.player.body.getVel()
    sprite = node.player.sprite
    @hud.get(Components.Hud).meter = sprite.getPositionX() - runnerStartX

    if @stat is RunnerStat.jumpUp
      if vel.y < 0.1
        @stat = RunnerStat.jumpDown
        sprite.stopAllActions()
        sprite.runAction(node.player.jumpDownAction)

    else if @stat is RunnerStat.jumpDown
      if vel.y is 0
        @stat = RunnerStat.running
        sprite.stopAllActions()
        sprite.runAction(node.player.runningAction)
    return # Void


