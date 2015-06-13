HudLayer = cc.Layer.extend

  labelCoin   : null
  labelMeter  : null
  coins       : 0

  ctor:->
    @_super()
    @init()
    return

  init:->
    @_super()

    winsize = cc.director.getWinSize()

    @labelCoin = new cc.LabelTTF("Coins:0", "Helvetica", 20)
    @labelCoin.setColor(cc.color(0,0,0)) #black color
    @labelCoin.setPosition(cc.p(70, winsize.height - 20))
    @addChild(@labelCoin)

    @labelMeter = new cc.LabelTTF("0M", "Helvetica", 20)
    @labelMeter.setPosition(cc.p(winsize.width - 70, winsize.height - 20))
    @addChild(@labelMeter)
    return

  updateMeter: (px) ->
    @labelMeter.setString(parseInt(px / 10) + "M")
    return

  addCoin: (num) ->
    @coins += num
    @labelCoin.setString("Coins:" + @coins)
    return
