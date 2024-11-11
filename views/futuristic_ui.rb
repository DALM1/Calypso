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
    init_pair(1, COLOR_GREEN, -1)
    init_pair(2, COLOR_WHITE, -1)
    init_pair(3, COLOR_RED, -1)
    init_pair(4, COLOR_CYAN, -1)
    @matrix_strings = []
  end

  def show_welcome
    clear
    setpos(lines / 2 - 2, (cols - "WELCOME TO CALYPSO".length) / 2)
    attron(color_pair(1)) { addstr("WELCOME TO CALYPSO") }
    setpos(lines / 2, (cols - "Your Futuristic Chat System".length) / 2)
    attron(color_pair(2)) { addstr("Your Futuristic Chat System") }
    refresh
    sleep(2)
  end

  def matrix_effect
    clear
    @matrix_strings = Array.new(cols) { "" }

    loop do
      stdscr.clear
      cols.times do |x|
        next unless rand(0..100) < 15 # Aléatoire pour la colonne active

        char = (rand(33..126)).chr
        @matrix_strings[x] = char + @matrix_strings[x]
        @matrix_strings[x] = @matrix_strings[x][0, rand(5..15)] # Limite la longueur

        @matrix_strings[x].chars.each_with_index do |c, idx|
          setpos(idx, x)
          attron(color_pair(idx == 0 ? 2 : 1)) { addstr(c) }
        end
      end
      refresh
      sleep(0.05)
    end
  rescue Interrupt
    close_screen
  end

  def display_message(message, type = :info)
    setpos(lines - 3, 0)
    clear_to_eol
    case type
    when :info
      attron(color_pair(2)) { addstr("> #{message}") }
    when :error
      attron(color_pair(3)) { addstr("[ERROR] #{message}") }
    when :prompt
      attron(color_pair(4)) { addstr("#{message}") }
    end
    refresh
  end
end
