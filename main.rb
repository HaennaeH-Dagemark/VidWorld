require 'gosu'
require_relative 'menu'

class Starter < Gosu::Window
  def initialize
    settings = ""
    File.foreach("Saves/default.txt") { |line, index| settings += line}
    screensize = settings.split("\n")
    @global_x = 420
    @global_y = 680
    super 420, 680
    self.caption = "Games of History - Initializer"
    @font_large = Gosu::Font.new(35)
    @selected_i = 1
    @@pressing = false
  end

  def update

    if button_down? Gosu::KB_S
      if @selected_i != 3 && @@pressing == false
        @selected_i += 1
        @@pressing = true
      elsif @@pressing == false
        @selected_i = 1
        @@pressing = true
      end
    elsif button_down? Gosu::KB_W
      if @selected_i != 1 && @@pressing == false
        @selected_i -= 1
        @@pressing = true
      elsif @@pressing == false
        @selected_i = 3
        @@pressing = true
      end
    else
      @@pressing = false
    end
  end

  module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

  def start_game(num)
    if num == 1
      File.open("Saves/default.txt", "w") { |f| f.write "1600 \#= W\n900 \#= H" }
   elsif num == 2
      File.open("Saves/default.txt", "w") { |f| f.write "1920 \#= W\n1080 \#= H" }
    else
      File.open("Saves/default.txt", "w") { |f| f.write "2560 \#= W\n1440 \#= H" }
    end
    Starter.hide
    new_do(true)
  end

  def is_selected(num)
    if num == @selected_i
      if button_down? Gosu::KB_SPACE
        start_game(num)
      else
        return Gosu::Color::GRAY
      end
    else
      return Gosu::Color::WHITE
    end
  end

  def draw
    @font_large.draw_text("Pick Desired Screen Size", @global_x / 2 - 175, @global_y / 2 - 230, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    Gosu.draw_rect 0, 0, 420, 680, Gosu::Color::BLACK, -10
    Buttons.new.draw_first(45, 150, 325, 50, is_selected(1))
    Buttons.new.draw_second(45, 250, 325, 50, is_selected(2))
    Buttons.new.draw_third(45, 350, 325, 50, is_selected(3))
  end

  #def button_down(id)
    #while id == Gosu::MS_LEFT
      #if #Add if the mouse is over "X" button
        #File.open("Saves/default.txt", "w") { |f| f.write "1080 = W\n1080 = H\n1 = S" }
        #Starter.new.show
      #end
    #end
  #end
end

class Buttons
  def initialize
    @render_squares = [[],[],[],[]]
    @@i = 0
  end

  def draw_first(x1, y1, x2, y2, color)
    Gosu.draw_rect x1, y1, x2, y2, color
  end
  def draw_second(x1, y1, x2, y2, color)
    Gosu.draw_rect x1, y1, x2, y2, color
  end
  def draw_third(x1, y1, x2, y2, color)
    Gosu.draw_rect x1, y1, x2, y2, color
  end
end

Starter.new.show
