# basic Gosu: gui test file

require 'gosu'

class TestWindow < Gosu::Window   # <-- inherits from Gosu Window Super class

  def initialize
    super 640, 480, false         # <-- width, height, fullscreen = false
    self.caption = "successful gosu test window"
  end

  def update
  end

  def draw
  end

end


TestWindow.new.show