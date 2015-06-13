###
 * The main menu
###

MenuLayer = cc.Layer.extend

  ctor : ->
    @_super()
    winsize = cc.director.getWinSize()
    centerpos = cc.p(winsize.width / 2, winsize.height / 2)
    spritebg = new cc.Sprite(res.helloBG_png)
    spritebg.setPosition(centerpos)
    @addChild(spritebg)

    cc.MenuItemFont.setFontSize(60)
    menuItemPlay = new cc.MenuItemSprite(
      new cc.Sprite(res.start_n_png),
      new cc.Sprite(res.start_s_png),
      -> cc.director.runScene(GameLayer.scene())
#      -> cc.director.runScene(new PlayScene())
    , this)
    menu = new cc.Menu(menuItemPlay)  #7. create the menu
    menu.setPosition(centerpos)
    @addChild(menu)
    return

MenuLayer.scene = ->
  scene = new cc.Scene()
  scene.addChild(new MenuLayer())
  return scene

