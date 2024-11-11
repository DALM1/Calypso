require 'curses'

class FuturisticUI
  include Curses

  def initialize
    init_screen
    start_color
    use_default_colors
    curs_set(0)
    noecho
    stdscr.keypad(true)
    init_pair(1, COLOR_YELLOW, -1) # Texte doré
    init_pair(2, COLOR_BLUE, -1)   # Texte bleu
    init_pair(3, COLOR_RED, -1)    # Texte rouge
  end

  def show_welcome
    clear
    logo = File.read('./assets/star_wars_logo.txt')
    setpos(lines / 2 - 4, (cols - logo.split("\n").first.length) / 2)
    attron(color_pair(1)) { addstr(logo) }
    setpos(lines - 2, (cols - "Press Enter to Begin...".length) / 2)
    attron(color_pair(2)) { addstr("Press Enter to Begin...") }
    refresh
    getch
  end

  def display_message(message, type = :info)
    case type
    when :info
      attron(color_pair(1)) { puts "> #{message}" }
    when :error
      attron(color_pair(3)) { puts "[ERROR] #{message}" }
    when :prompt
      attron(color_pair(2)) { puts "#{message}" }
    end
  end
end
