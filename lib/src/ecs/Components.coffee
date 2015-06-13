###
 * Components
###
Components = do ->

  Display: class Display
    sprite: null
    constructor: (@sprite) ->

  Gravity: class Gravity
    x: 0
    y: 0
    constructor: (@x, @y) ->

  Hud: class Hud
    coins: 0
    meter: 0
    lives: 3
    labelCoin: null
    labelMeter: null
    constructor: (@coins, @meter, @lives, @labelCoin, @labelMeter) ->

  Player: class Player
    sprite          : null
    body            : null
    runningAction   : null
    jumpUpAction    : null
    jumpDownAction  : null
    constructor: (@sprite, @body, @runningAction, @jumpUpAction, @jumpDownAction) ->

  TileMap: class TileMap
    mapWidth: 0
    spriteSheet: null
    map00: null
    map01: null
    constructor: (@mapWidth, @spriteSheet, @map00, @map01) ->

  Transform: class Transform
    x: 0
    y: 0
    alpha: 0
    constructor: (@x=0, @y=0, @alpha=1) ->

