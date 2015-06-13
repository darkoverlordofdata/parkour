
/* <==================================================
                      __
  ___________ _______|  | ______  __ _________
  \____ \__  \\_  __ \  |/ /  _ \|  |  \_  __ \
  |  |_> > __ \|  | \/    <  <_> )  |  /|  | \/
  |   __(____  /__|  |__|_ \____/|____/ |__|
  |__|       \/           \/

==================================================>
 */
'use strict';

/*
 * Resources
 */
var Coin, Components, Entities, GameLayer, HudSystem, LayerTag, MenuLayer, Nodes, PhysicsSystem, PlayerSystem, Point, Reg, RenderSystem, Rock, RunnerStat, SimpleRecognizer, SpriteTag, SystemPriorities, TileMapSystem, groundHeight, res, runnerStartX,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

res = {
  helloBG_png: 'res/helloBG.png',
  start_n_png: 'res/start_n.png',
  start_s_png: 'res/start_s.png',
  PlayBG_png: 'res/PlayBG.png',
  runner_png: 'res/running.png',
  runner_plist: 'res/running.plist',
  map_png: 'res/map.png',
  map00_tmx: 'res/map00.tmx',
  map01_tmx: 'res/map01.tmx',
  background_png: 'res/background.png',
  background_plist: 'res/background.plist',
  restart_n_png: 'res/restart_n.png',
  restart_s_png: 'res/restart_s.png',
  background_mp3: 'res/background.mp3',
  jump_mp3: 'res/jump.mp3',
  pickup_coin_mp3: 'res/pickup_coin.mp3'
};

groundHeight = 57;

runnerStartX = 80;

LayerTag = {
  Background: 0,
  Animation: 1,
  Hud: 2
};

SpriteTag = {
  runner: 0,
  coin: 1,
  rock: 2
};

RunnerStat = {
  running: 0,
  jumpUp: 1,
  jumpDown: 2
};


/*
 * Global communications
 */

Reg = (function() {
  function Reg() {}

  Reg.score = 0;

  Reg.lives = 0;

  Reg.scored = new ash.signals.Signal2();

  Reg.killed = new ash.signals.Signal0();

  return Reg;

})();


/*
 * Components
 */

Components = (function() {
  var Display, Gravity, Hud, Player, TileMap, Transform;
  return {
    Display: Display = (function() {
      Display.prototype.sprite = null;

      function Display(sprite) {
        this.sprite = sprite;
      }

      return Display;

    })(),
    Gravity: Gravity = (function() {
      Gravity.prototype.x = 0;

      Gravity.prototype.y = 0;

      function Gravity(x, y) {
        this.x = x;
        this.y = y;
      }

      return Gravity;

    })(),
    Hud: Hud = (function() {
      Hud.prototype.coins = 0;

      Hud.prototype.meter = 0;

      Hud.prototype.lives = 3;

      Hud.prototype.labelCoin = null;

      Hud.prototype.labelMeter = null;

      function Hud(coins, meter, lives, labelCoin, labelMeter) {
        this.coins = coins;
        this.meter = meter;
        this.lives = lives;
        this.labelCoin = labelCoin;
        this.labelMeter = labelMeter;
      }

      return Hud;

    })(),
    Player: Player = (function() {
      Player.prototype.sprite = null;

      Player.prototype.body = null;

      Player.prototype.runningAction = null;

      Player.prototype.jumpUpAction = null;

      Player.prototype.jumpDownAction = null;

      function Player(sprite, body, runningAction, jumpUpAction, jumpDownAction) {
        this.sprite = sprite;
        this.body = body;
        this.runningAction = runningAction;
        this.jumpUpAction = jumpUpAction;
        this.jumpDownAction = jumpDownAction;
      }

      return Player;

    })(),
    TileMap: TileMap = (function() {
      TileMap.prototype.mapWidth = 0;

      TileMap.prototype.spriteSheet = null;

      TileMap.prototype.map00 = null;

      TileMap.prototype.map01 = null;

      function TileMap(mapWidth, spriteSheet, map00, map01) {
        this.mapWidth = mapWidth;
        this.spriteSheet = spriteSheet;
        this.map00 = map00;
        this.map01 = map01;
      }

      return TileMap;

    })(),
    Transform: Transform = (function() {
      Transform.prototype.x = 0;

      Transform.prototype.y = 0;

      Transform.prototype.alpha = 0;

      function Transform(x, y, alpha) {
        this.x = x != null ? x : 0;
        this.y = y != null ? y : 0;
        this.alpha = alpha != null ? alpha : 1;
      }

      return Transform;

    })()
  };
})();


/*
 * Node templates
 */

Nodes = (function() {
  var HudNode, PhysicsNode, PlayerNode, RenderNode, TileMapNode;
  return {
    HudNode: HudNode = (function() {
      function HudNode() {}

      HudNode.prototype.hud = Components.Hud;

      return HudNode;

    })(),
    RenderNode: RenderNode = (function() {
      function RenderNode() {}

      RenderNode.prototype.display = Components.Display;

      RenderNode.prototype.transform = Components.Transform;

      return RenderNode;

    })(),
    PhysicsNode: PhysicsNode = (function() {
      function PhysicsNode() {}

      PhysicsNode.prototype.physics = Components.Gravity;

      return PhysicsNode;

    })(),
    PlayerNode: PlayerNode = (function() {
      function PlayerNode() {}

      PlayerNode.prototype.player = Components.Player;

      return PlayerNode;

    })(),
    TileMapNode: TileMapNode = (function() {
      function TileMapNode() {}

      TileMapNode.prototype.tilemap = Components.TileMap;

      return TileMapNode;

    })()
  };
})();

Entities = (function() {

  /*
   * Imports
   */
  var Display, Entity, Gravity, Hud, Player, TileMap, Transform;

  Display = Components.Display;

  Gravity = Components.Gravity;

  Hud = Components.Hud;

  Player = Components.Player;

  TileMap = Components.TileMap;

  Transform = Components.Transform;

  Entity = ash.core.Entity;

  Entities.prototype.ash = null;

  Entities.prototype.game = null;

  Entities.prototype.world = null;

  function Entities(game) {
    this.game = game;
    this.ash = this.game.ash;
    this.world = this.game.world;
  }

  Entities.prototype.destroyEntity = function(entity) {
    this.ash.removeEntity(entity);
  };


  /*
   * Image
   *
   * @param x
   * @param y
   * @param path
   * @return image
   */

  Entities.prototype.createImage = function(x, y, path, alpha) {
    var image, sprite;
    if (alpha == null) {
      alpha = 1;
    }
    sprite = new cc.Sprite(path);
    this.game.addChild(sprite);
    image = new Entity();
    image.add(new Display(sprite));
    image.add(new Transform(x, y, alpha));
    this.ash.addEntity(image);
    return image;
  };


  /*
   * TileMap
   *
   * @param tmx00 even map
   * @param tmx01 odd map
   * @param plist map to packed png
   * @param png plist data
   * @return tilemap
   */

  Entities.prototype.createTileMap = function(tmx00, tmx01, plist, png) {
    var map00, map01, mapWidth, spriteSheet, tilemap;
    map00 = new cc.TMXTiledMap(tmx00);
    this.game.addChild(map00);
    mapWidth = map00.getContentSize().width;
    map01 = new cc.TMXTiledMap(tmx01);
    map01.setPosition(cc.p(mapWidth, 0));
    this.game.addChild(map01);
    cc.spriteFrameCache.addSpriteFrames(plist);
    spriteSheet = new cc.SpriteBatchNode(png);
    this.game.addChild(spriteSheet);
    tilemap = new Entity();
    tilemap.add(new TileMap(mapWidth, spriteSheet, map00, map01));
    this.ash.addEntity(tilemap);
    return tilemap;
  };


  /*
   * Physics
   *
   * @param x - gravity
   * @param y - gravity
   * @return physics
   */

  Entities.prototype.createPhysics = function(gravityX, gravityY) {
    var physics, wallBottom;
    this.world.gravity = cp.v(gravityX, gravityY);
    wallBottom = new cp.SegmentShape(this.world.staticBody, cp.v(0, groundHeight), cp.v(4294967295, groundHeight), 0);
    this.world.addStaticShape(wallBottom);
    physics = new Entity();
    physics.add(new Gravity(gravityX, gravityY));
    this.ash.addEntity(physics);
    return physics;
  };


  /*
   * Runner
   *
   * @param plist map to packed png
   * @param png image data
   * @return runner
   */

  Entities.prototype.createRunner = function(plist, png) {
    var animFrames, animation, body, contentSize, i, jumpDownAction, jumpUpAction, runner, runningAction, shape, sprite, spriteSheet;
    cc.spriteFrameCache.addSpriteFrames(plist);
    spriteSheet = new cc.SpriteBatchNode(png);
    this.game.addChild(spriteSheet);
    animFrames = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; _i < 8; i = ++_i) {
        _results.push(cc.spriteFrameCache.getSpriteFrame("runner" + i + ".png"));
      }
      return _results;
    })();
    animation = new cc.Animation(animFrames, 0.1);
    runningAction = new cc.RepeatForever(new cc.Animate(animation));
    runningAction.retain();
    animFrames = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; _i < 4; i = ++_i) {
        _results.push(cc.spriteFrameCache.getSpriteFrame("runnerJumpUp" + i + ".png"));
      }
      return _results;
    })();
    animation = new cc.Animation(animFrames, 0.2);
    jumpUpAction = new cc.RepeatForever(new cc.Animate(animation));
    jumpUpAction.retain();
    animFrames = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; _i < 2; i = ++_i) {
        _results.push(cc.spriteFrameCache.getSpriteFrame("runnerJumpDown" + i + ".png"));
      }
      return _results;
    })();
    animation = new cc.Animation(animFrames, 0.3);
    jumpDownAction = new cc.RepeatForever(new cc.Animate(animation));
    jumpDownAction.retain();
    sprite = new cc.PhysicsSprite("#runner0.png");
    contentSize = sprite.getContentSize();
    body = new cp.Body(1, cp.momentForBox(1, contentSize.width, contentSize.height));
    body.p = cc.p(runnerStartX, groundHeight + contentSize.height / 2);
    body.applyImpulse(cp.v(150, 0), cp.v(0, 0));
    this.world.addBody(body);
    shape = new cp.BoxShape(body, contentSize.width - 14, contentSize.height);
    this.world.addShape(shape);
    sprite.setBody(body);
    sprite.runAction(runningAction);
    spriteSheet.addChild(sprite);
    runner = new Entity();
    runner.add(new Player(sprite, body, runningAction, jumpUpAction, jumpDownAction));
    this.ash.addEntity(runner);
    return runner;
  };


  /*
   * Hud
   *
   * @param score
   * @param lives
   * @return hud
   */

  Entities.prototype.createHud = function(coins, meter, lives) {
    var hud, labelCoin, labelMeter, winsize;
    winsize = cc.director.getWinSize();
    labelCoin = new cc.LabelTTF("Coins:0", "Helvetica", 20);
    labelCoin.setColor(cc.color(0, 0, 0));
    labelCoin.setPosition(cc.p(70, winsize.height - 20));
    this.game.addChild(labelCoin);
    labelMeter = new cc.LabelTTF("0M", "Helvetica", 20);
    labelMeter.setPosition(cc.p(winsize.width - 70, winsize.height - 20));
    this.game.addChild(labelMeter);
    hud = new Entity();
    hud.add(new Hud(coins, meter, lives, labelCoin, labelMeter));
    this.ash.addEntity(hud);
    return hud;
  };

  return Entities;

})();

SystemPriorities = (function() {
  function SystemPriorities() {}

  SystemPriorities.preUpdate = 1;

  SystemPriorities.update = 2;

  SystemPriorities.move = 3;

  SystemPriorities.resolveCollisions = 4;

  SystemPriorities.stateMachines = 5;

  SystemPriorities.render = 6;

  SystemPriorities.animate = 7;

  return SystemPriorities;

})();

HudSystem = (function(_super) {
  __extends(HudSystem, _super);

  HudSystem.prototype.shapesToRemove = null;

  function HudSystem(game) {
    this.game = game;
    this.updateNode = __bind(this.updateNode, this);
    HudSystem.__super__.constructor.call(this, this.game.reg.nodes.HudNode, this.updateNode);
    this.player = this.game.player;
  }

  HudSystem.prototype.updateNode = function(node, time) {
    var labelCoin, labelMeter, winsize, x;
    winsize = cc.director.getWinSize();
    x = this.player.get(Components.Player).sprite.getPositionX() - runnerStartX;
    labelCoin = node.hud.labelCoin;
    labelCoin.setPosition(cc.p(x + 70, winsize.height - 20));
    labelCoin.setString("Coins:" + node.hud.coins);
    labelMeter = node.hud.labelMeter;
    labelMeter.setPosition(cc.p(x + winsize.width - 70, winsize.height - 20));
    labelMeter.setString(parseInt(node.hud.meter / 10) + "M");
  };

  return HudSystem;

})(ash.tools.ListIteratingSystem);

PhysicsSystem = (function(_super) {
  __extends(PhysicsSystem, _super);

  PhysicsSystem.prototype.player = null;

  PhysicsSystem.prototype.hud = null;

  function PhysicsSystem(game) {
    this.game = game;
    this.updateNode = __bind(this.updateNode, this);
    PhysicsSystem.__super__.constructor.call(this, this.game.reg.nodes.PhysicsNode, this.updateNode);
    this.world = this.game.world;
    this.player = this.game.player;
    this.hud = this.game.hud;
    this.world.addCollisionHandler(SpriteTag.runner, SpriteTag.coin, this.collisionCoinBegin.bind(this), null, null, null);
    this.world.addCollisionHandler(SpriteTag.runner, SpriteTag.rock, this.collisionRockBegin.bind(this), null, null, null);
  }

  PhysicsSystem.prototype.updateNode = function(node, time) {
    var x;
    this.world.step(time);
    x = this.player.get(Components.Player).sprite.getPositionX() - runnerStartX;
    this.game.setPosition(cc.p(-x, 0));
  };

  PhysicsSystem.prototype.collisionCoinBegin = function(arbiter, world) {
    Reg.scored.dispatch(1, arbiter.getShapes());
    this.hud.get(Components.Hud).coins++;
    cc.audioEngine.playEffect(res.pickup_coin_mp3);
  };

  PhysicsSystem.prototype.collisionRockBegin = function(arbiter, world) {
    if (this.hud.get(Components.Hud).lives-- < 0) {
      Reg.killed.dispatch();
    }
  };

  return PhysicsSystem;

})(ash.tools.ListIteratingSystem);

PlayerSystem = (function(_super) {
  __extends(PlayerSystem, _super);

  PlayerSystem.prototype.stat = RunnerStat.running;

  PlayerSystem.prototype.hud = null;

  function PlayerSystem(game) {
    this.game = game;
    this.updateNode = __bind(this.updateNode, this);
    PlayerSystem.__super__.constructor.call(this, this.game.reg.nodes.PlayerNode, this.updateNode);
    this.hud = this.game.hud;
  }

  PlayerSystem.prototype.updateNode = function(node, time) {
    var sprite, vel;
    vel = node.player.body.getVel();
    sprite = node.player.sprite;
    this.hud.get(Components.Hud).meter = sprite.getPositionX() - runnerStartX;
    if (this.stat === RunnerStat.jumpUp) {
      if (vel.y < 0.1) {
        this.stat = RunnerStat.jumpDown;
        sprite.stopAllActions();
        sprite.runAction(node.player.jumpDownAction);
      }
    } else if (this.stat === RunnerStat.jumpDown) {
      if (vel.y === 0) {
        this.stat = RunnerStat.running;
        sprite.stopAllActions();
        sprite.runAction(node.player.runningAction);
      }
    }
  };

  return PlayerSystem;

})(ash.tools.ListIteratingSystem);

RenderSystem = (function(_super) {
  __extends(RenderSystem, _super);

  function RenderSystem(level) {
    this.level = level;
    this.updateNode = __bind(this.updateNode, this);
    RenderSystem.__super__.constructor.call(this, this.level.reg.nodes.RenderNode, this.updateNode);
  }

  RenderSystem.prototype.updateNode = function(node, time) {
    var size, x, y;
    size = cc.director.getWinSize();
    x = node.transform.x + (size.width / 2);
    y = node.transform.y + (size.height / 2);
    node.display.sprite.setPosition(cc.p(x, y));
  };

  return RenderSystem;

})(ash.tools.ListIteratingSystem);

TileMapSystem = (function(_super) {
  __extends(TileMapSystem, _super);

  TileMapSystem.prototype.first = true;

  TileMapSystem.prototype.level = null;

  TileMapSystem.prototype.world = null;

  TileMapSystem.prototype.objects = null;

  TileMapSystem.prototype.player = null;

  TileMapSystem.prototype.mapIndex = 0;

  TileMapSystem.prototype.deadPool = null;

  function TileMapSystem(game) {
    this.game = game;
    this.updateNode = __bind(this.updateNode, this);
    TileMapSystem.__super__.constructor.call(this, this.game.reg.nodes.TileMapNode, this.updateNode);
    this.world = this.game.world;
    this.player = this.game.player;
    this.objects = [];
    this.deadPool = [];
    Reg.scored.add((function(_this) {
      return function(points, shapes) {
        console.log('Score ', points);
        return _this.deadPool.push(shapes[1]);
      };
    })(this));
  }

  TileMapSystem.prototype.updateNode = function(node, time) {
    var map00, map01, mapWidth, newMapIndex, shape, spriteSheet, x;
    map00 = node.tilemap.map00;
    map01 = node.tilemap.map01;
    mapWidth = node.tilemap.mapWidth;
    spriteSheet = node.tilemap.spriteSheet;
    if (this.first) {
      this.first = false;
      this.loadObjects(map00, 0, mapWidth, spriteSheet);
      this.loadObjects(map01, 1, mapWidth, spriteSheet);
    }
    x = this.player.get(Components.Player).sprite.getPositionX() - runnerStartX;
    newMapIndex = parseInt(x / mapWidth);
    if (this.mapIndex !== newMapIndex) {
      if (0 === newMapIndex % 2) {
        map01.setPositionX(mapWidth * (newMapIndex + 1));
        this.loadObjects(map01, newMapIndex + 1, mapWidth, spriteSheet);
      } else {
        map00.setPositionX(mapWidth * (newMapIndex + 1));
        this.loadObjects(map00, newMapIndex + 1, mapWidth, spriteSheet);
      }
      this.removeObjects(newMapIndex - 1);
      this.mapIndex = newMapIndex;
    }
    while ((shape = this.deadPool.pop()) != null) {
      this.removeObjectByShape(shape);
    }
  };

  TileMapSystem.prototype.loadObjects = function(map, mapIndex, mapWidth, spriteSheet) {
    var coin, coinArray, coinGroup, p, rock, rockArray, rockGroup, _i, _j, _len, _len1;
    coinGroup = map.getObjectGroup('coin');
    coinArray = coinGroup.getObjects();
    for (_i = 0, _len = coinArray.length; _i < _len; _i++) {
      p = coinArray[_i];
      coin = new Coin(spriteSheet, this.world, cc.p(p["x"] + mapWidth * mapIndex, p["y"]));
      coin.mapIndex = mapIndex;
      this.objects.push(coin);
    }
    rockGroup = map.getObjectGroup('rock');
    rockArray = rockGroup.getObjects();
    for (_j = 0, _len1 = rockArray.length; _j < _len1; _j++) {
      p = rockArray[_j];
      rock = new Rock(spriteSheet, this.world, cc.p(p["x"] + mapWidth * mapIndex, p["y"]));
      rock.mapIndex = mapIndex;
      this.objects.push(rock);
    }
  };

  TileMapSystem.prototype.removeObjects = function(mapIndex) {
    while ((function(obj, index) {
        var i, _i, _ref;
        for (i = _i = 0, _ref = obj.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
          if (obj[i].mapIndex === index) {
            obj[i].removeFromParent();
            obj.splice(i, 1);
            return true;
          }
        }
        return false;
      })(this.objects, mapIndex)) {
      return;
    }
  };

  TileMapSystem.prototype.removeObjectByShape = function(shape) {
    var i, _i, _ref;
    for (i = _i = 0, _ref = this.objects.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
      if (this.objects[i].getShape() === shape) {
        this.objects[i].removeFromParent();
        this.objects.splice(i, 1);
        break;
      }
    }
  };

  return TileMapSystem;

})(ash.tools.ListIteratingSystem);


/*
 * The main menu
 */

MenuLayer = cc.Layer.extend({
  ctor: function() {
    var centerpos, menu, menuItemPlay, spritebg, winsize;
    this._super();
    winsize = cc.director.getWinSize();
    centerpos = cc.p(winsize.width / 2, winsize.height / 2);
    spritebg = new cc.Sprite(res.helloBG_png);
    spritebg.setPosition(centerpos);
    this.addChild(spritebg);
    cc.MenuItemFont.setFontSize(60);
    menuItemPlay = new cc.MenuItemSprite(new cc.Sprite(res.start_n_png), new cc.Sprite(res.start_s_png), function() {
      return cc.director.runScene(GameLayer.scene());
    }, this);
    menu = new cc.Menu(menuItemPlay);
    menu.setPosition(centerpos);
    this.addChild(menu);
  }
});

MenuLayer.scene = function() {
  var scene;
  scene = new cc.Scene();
  scene.addChild(new MenuLayer());
  return scene;
};

GameLayer = cc.Layer.extend({
  ash: null,
  reg: null,
  entities: null,
  world: null,
  player: null,
  hud: null,
  ctor: function() {
    this._super();
    this.ash = new ash.core.Engine();
    this.reg = new ash.ext.Helper(Components, Nodes);
    this.world = new cp.Space();
    this.entities = new Entities(this);
    this.entities.createPhysics(0, -350);
    this.entities.createImage(0, 0, res.PlayBG_png);
    this.entities.createTileMap(res.map00_tmx, res.map01_tmx, res.background_plist, res.background_png);
    this.hud = this.entities.createHud(0, 3);
    this.player = this.entities.createRunner(res.runner_plist, res.runner_png);
    this.ash.addSystem(new RenderSystem(this), SystemPriorities.render);
    this.ash.addSystem(new TileMapSystem(this), SystemPriorities.render);
    this.ash.addSystem(new HudSystem(this), SystemPriorities.render);
    this.ash.addSystem(new PlayerSystem(this), SystemPriorities.move);
    this.ash.addSystem(new PhysicsSystem(this), SystemPriorities.resolveCollisions);
    this.scheduleUpdate();
  },
  update: function(dt) {
    this.ash.update(dt);
  }
});

GameLayer.scene = function() {
  var scene;
  scene = new cc.Scene();
  scene.addChild(new GameLayer());
  return scene;
};

Coin = cc.Class.extend({
  world: null,
  sprite: null,
  shape: null,
  mapIndex: 0,
  getShape: function() {
    return this.shape;
  },
  ctor: function(spriteSheet, world, pos) {
    var action, animFrames, animation, body, i, radius;
    this.world = world;
    animFrames = (function() {
      var _i, _results;
      _results = [];
      for (i = _i = 0; _i < 8; i = ++_i) {
        _results.push(cc.spriteFrameCache.getSpriteFrame("coin" + i + ".png"));
      }
      return _results;
    })();
    animation = new cc.Animation(animFrames, 0.2);
    action = new cc.RepeatForever(new cc.Animate(animation));
    this.sprite = new cc.PhysicsSprite("#coin0.png");
    radius = 0.95 * this.sprite.getContentSize().width / 2;
    body = new cp.StaticBody();
    body.setPos(pos);
    this.sprite.setBody(body);
    this.shape = new cp.CircleShape(body, radius, cp.vzero);
    this.shape.setCollisionType(SpriteTag.coin);
    this.shape.setSensor(true);
    this.world.addStaticShape(this.shape);
    this.sprite.runAction(action);
    spriteSheet.addChild(this.sprite, 1);
  },
  removeFromParent: function() {
    this.world.removeStaticShape(this.shape);
    this.shape = null;
    this.sprite.removeFromParent();
    this.sprite = null;
  }
});

Rock = cc.Class.extend({
  world: null,
  sprite: null,
  shape: null,
  map: 0,
  getShape: function() {
    return this.shape;
  },
  ctor: function(spriteSheet, world, posX) {
    var body;
    this.world = world;
    this.sprite = new cc.PhysicsSprite("#rock.png");
    body = new cp.StaticBody();
    body.setPos(cc.p(posX.x, this.sprite.getContentSize().height / 2 + groundHeight));
    this.sprite.setBody(body);
    this.shape = new cp.BoxShape(body, this.sprite.getContentSize().width, this.sprite.getContentSize().height);
    this.shape.setCollisionType(SpriteTag.rock);
    this.world.addStaticShape(this.shape);
    spriteSheet.addChild(this.sprite);
  },
  removeFromParent: function() {
    this.world.removeStaticShape(this.shape);
    this.shape = null;
    this.sprite.removeFromParent();
    this.sprite = null;
  }
});

Point = (function() {
  function Point(x, y) {
    this.X = x;
    this.Y = y;
  }

  return Point;

})();

SimpleRecognizer = (function() {
  SimpleRecognizer.prototype.points = null;

  SimpleRecognizer.prototype.result = null;

  SimpleRecognizer.prototype.getPoints = function() {
    return this.points;
  };

  function SimpleRecognizer() {
    this.points = [];
    this.result = '';
  }

  SimpleRecognizer.prototype.beginPoint = function(x, y) {
    this.points = [];
    this.result = '';
    this.points.push(new Point(x, y));
  };

  SimpleRecognizer.prototype.movePoint = function(x, y) {
    var dx, dy, len, newRtn;
    this.points.push(new Point(x, y));
    if (this.result === 'not supported') {
      return;
    }
    newRtn = '';
    len = this.points.length;
    dx = this.points[len - 1].X - this.points[len - 2].X;
    dy = this.points[len - 1].Y - this.points[len - 2].Y;
    if (Math.abs(dx) > Math.abs(dy)) {
      if (dx > 0) {
        newRtn = 'right';
      } else {
        newRtn = 'left';
      }
    } else {
      if (dy > 0) {
        newRtn = 'up';
      } else {
        newRtn = 'down';
      }
    }
    if (this.result === '') {
      this.result = newRtn;
      return;
    }
    if (this.result !== newRtn) {
      this.result = 'not support';
    }
  };

  SimpleRecognizer.prototype.endPoint = function() {
    if (this.points.length < 3) {
      return 'error';
    }
    return this.result;
  };

  return SimpleRecognizer;

})();

//# sourceMappingURL=parkour.js.map
