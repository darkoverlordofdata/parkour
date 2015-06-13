
class RenderSystem extends ash.tools.ListIteratingSystem

  constructor: (@level) ->
    super(@level.reg.nodes.RenderNode, @updateNode)


  updateNode: (node, time) =>
    size = cc.director.getWinSize()
    x = node.transform.x + (size.width / 2)
    y = node.transform.y + (size.height / 2)
    node.display.sprite.setPosition(cc.p(x, y))
    return # Void


