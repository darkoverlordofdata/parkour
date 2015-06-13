###
 * Node templates
###
Nodes = do ->

  HudNode: class HudNode
    hud         : Components.Hud

  RenderNode: class RenderNode
    display     : Components.Display
    transform   : Components.Transform

  PhysicsNode: class PhysicsNode
    physics     : Components.Gravity

  PlayerNode: class PlayerNode
    player     : Components.Player

  TileMapNode: class TileMapNode
    tilemap     : Components.TileMap