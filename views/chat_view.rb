require 'curses'
require_relative './futuristic_ui'

class ChatView
  puts "                                               "
    puts "-----------------------------------------------"
    puts "                                               "

    puts "  (       ) (    (       )"
    puts "  (    (     )\\ ) ( /( )\\ ) )\\ ) ( /("
    puts "  )\\   )\\   (()/( )\\()|()/((()/( )\\())"
    puts "  (((_|(((_)(  /(_)|(_)/ /(_))/(_)|(_)/"
    puts "  )\\___)\\ _ )\\(_))__ ((_|_)) (_))   ((_)"
    puts "  ((/ __(_)_\\(_) | \\ \\ / / _ \\/ __| / _ \\"
    puts "  | (__ / _ \\ | |__\\ V /|  _/\\__ \\| (_) |"
    puts "   \\___/_/ \\_\\|____||_| |_|  |___/ \\___/ "

    puts "                                               "
    puts "-----------------------------------------------"
    puts "             Welcome to Calypso                "
    puts "             All right reserved                "
    puts "                                               "
    puts "                                               "

  def initialize
    @ui = FuturisticUI.new
  end

  def show_welcome
    @ui.show_welcome
  end

  def display_message(message)
    @ui.display_message(message, :info)
  end

  def error_message(error)
    @ui.display_message(error, :error)
  end

  def input_prompt(prompt)
    @ui.display_message(prompt, :prompt)
    print "> "
    gets.chomp
  end
end
