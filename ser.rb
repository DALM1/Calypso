require 'socket'
require 'tty-prompt'
require 'colorize'
require_relative './controllers/chat_controller'

port = 3630
server = TCPServer.new(port)
chat_controller = ChatController.new

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
puts "Server listening lightning fast on port #{port}".colorize(:green)

def handle_room_selection(client, chat_controller)
  prompt = TTY::Prompt.new

  loop do
    choices = chat_controller.chat_rooms.keys + ["Create a new room", "Quit"]
    room_name = prompt.select("Select the room you want to join or create a new one:", choices)

    if room_name == "Create a new room"
      room_name = prompt.ask("Enter the name of the new room:")
      password = prompt.mask("Enter a password for the room (or press enter to skip):")
      username = prompt.ask("Enter your username:")
      chat_controller.create_room(room_name, password, username)
      chat_controller.chat_rooms[room_name].add_client(client, username)
      chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name], username)
    elsif room_name == "Quit"
      break
    else
      password = prompt.mask("Enter the room password:")
      username = prompt.ask("Enter your username:")
      if chat_controller.chat_rooms[room_name].password == password
        chat_controller.chat_rooms[room_name].add_client(client, username)
        chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name], username)
      else
        client.puts "Incorrect password. Try again.".colorize(:red)
      end
    end
  end
end

loop do
  client = server.accept
  Thread.new(client) do |client_connection|
    handle_room_selection(client_connection, chat_controller)
    client_connection.close
  end
end
