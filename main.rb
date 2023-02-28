require 'gosu'

class Starter < Gosu::Window
  def initialize
    @render_squares = [[],[],[],[]]
    settings = ""
    File.foreach("Saves/default.txt") { |line, index| settings += line}
    screensize = settings.split("\n")
    @global_x = screensize[0].to_i
    @global_y = screensize[1].to_i
    super @global_x, @global_y
    self.caption = "Games of History - Initializer"
    @font_large = Gosu::Font.new(35)
  end

  def update

  end
  def clocking(update)
    i = i.to_i + update.to_i
    return i
  end

  module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

  def draw
    @font_large.draw_text("Games of History!", @global_x / 2 - 125, @global_y / 2, ZOrder::UI, 1.0, 1.0, Gosu::Color::YELLOW)
    if Gosu.button_down? Gosu::MS_LEFT
      draw_def_item(100, 100, 100, 100)
    end
  end
  def draw_def_item(x1,y1,x2,y2)
    Gosu.draw_rect x1, y1, x2, y2, 0xff_00ffff
    i = clocking(1)
    @render_squares[i][0] = x1
    @render_squares[i][1] = y1
    @render_squares[i][2] = x2
    @render_squares[i][3] = y2
    print @render_squares
  end

  def button_down(id)
    while id == Gosu::MS_LEFT
      #if #Add if the mouse is over "X" button
      #  File.open("Saves/default.txt", "w") { |f| f.write "1080 = W\n1080 = H\n1 = S" }
      #  Starter.new.show
      #end
    end
  end
end

Starter.new.show
