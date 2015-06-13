###
 * Global communications
###
class Reg

  @score = 0
  @lives = 0

  @scored = new ash.signals.Signal2()
  @killed = new ash.signals.Signal0()