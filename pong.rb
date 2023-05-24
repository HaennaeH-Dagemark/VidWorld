require 'rubygems'
require 'gosu'
require_relative 'menu'

class Starter < Gosu::Window
  def initialize
    settings = ""
    File.foreach("Saves/default.txt") { |line, index| settings += line}
    screensize = settings.split("\n")
    puts screensize
    @global_x = 420
    @global_y = 680
    super 420, 680
    self.caption = "Games of History - Initializer"
    @font_large = Gosu::Font.new(35)
    @selected_i = 1
    @@pressing = false
  end

  def update

  end

  module ZOrder
    BACKGROUND, STARS, PLAYER, UI = *0..3
  end

  def start_game(num)
    if num == 1
      File.open("Saves/default.txt", "w") { |f| f.write "1600 = W\n900 = H" }
    elsif num == 2
      File.open("Saves/default.txt", "w") { |f| f.write "1920 = W\n1080 = H" }
    else
      File.open("Saves/default.txt", "w") { |f| f.write "2560 = W\n1440 = H" }
    end
    Starter.hide
    new_do(true)
  end

  def draw
    @font_large.draw_text("Pick Desired Screen Size", @global_x / 2 - 175, @global_y / 2 - 230, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
    Gosu.draw_rect 0, 0, 420, 680, Gosu::Color::BLACK, -10
  end
end
Starter.new.show
