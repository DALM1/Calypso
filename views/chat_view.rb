# views/chat_view.rb
class ChatView
  def welcome_message
    puts "                                               "
    puts "-----------------------------------------------"
    puts "                                               "

    puts "(       ) (    (       )"
    puts "(    (     )\\ ) ( /( )\\ ) )\\ ) ( /("
    puts ")\\   )\\   (()/( )\\()|()/((()/( )\\())"
    puts "(((_|(((_)(  /(_)|(_)/ /(_))/(_)|(_)/"
    puts ")\\___)\\ _ )\\(_))__ ((_|_)) (_))   ((_)"
    puts "((/ __(_)_\\(_) | \\ \\ / / _ \\/ __| / _ \\"
    puts "| (__ / _ \\ | |__\\ V /|  _/\\__ \\| (_) |"
    puts " \\___/_/ \\_\\|____||_| |_|  |___/ \\___/ "

    puts "                                               "
    puts "-----------------------------------------------"
    puts "             Welcome to Calypso                "
    puts "             All right reserved                "
    puts "                                               "
    puts "                                               "

  end

  def prompt_room_name
    puts "Enter the name of the chat room you want to create or join:"
    gets.chomp
  end

  def prompt_password
    puts "Enter a password for the chat room (or press enter to skip):"
    gets.chomp
  end

  def prompt_message
    print ">: "
    gets.chomp
  end
end
