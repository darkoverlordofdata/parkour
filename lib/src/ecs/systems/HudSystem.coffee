
class HudSystem extends ash.tools.ListIteratingSystem

  shapesToRemove  : null

  constructor: (@game) ->
    super(@game.reg.nodes.HudNode, @updateNode)
    @player = @game.player

  updateNode: (node, time) =>

    winsize = cc.director.getWinSize()
    x = @player.get(Components.Player).sprite.getPositionX() - runnerStartX

    labelCoin = node.hud.labelCoin
    labelCoin.setPosition(cc.p(x+70, winsize.height - 20))
    labelCoin.setString("Coins:" + node.hud.coins)

    labelMeter = node.hud.labelMeter
    labelMeter.setPosition(cc.p(x+winsize.width - 70, winsize.height - 20))
    labelMeter.setString(parseInt(node.hud.meter / 10) + "M")
    return # Void


