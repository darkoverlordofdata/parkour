GameOverLayer = cc.LayerColor.extend

  ctor: () ->
    @_super()
    @init()
    return

  init: () ->
    @_super(cc.color(0, 0, 0, 180))
    winSize = cc.director.getWinSize()

    centerPos = cc.p(winSize.width / 2, winSize.height / 2)
    cc.MenuItemFont.setFontSize(30)
    menuItemRestart = new cc.MenuItemSprite(
      new cc.Sprite(res.restart_n_png),
      new cc.Sprite(res.restart_s_png),
      this.onRestart, this)

    menu = new cc.Menu(menuItemRestart)
    menu.setPosition(centerPos)
    @addChild(menu)
    return

  onRestart: (sender) ->
    cc.director.resume()
    cc.director.runScene(new PlayScene())
    return
