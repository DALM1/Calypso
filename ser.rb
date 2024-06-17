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
puts "Server listening lightning fast on port #{port}"

def handle_room_selection(client, chat_controller)
  prompt = TTY::Prompt.new

  loop do
    room_name = prompt.ask("Enter the name of the room you want to create or join (or /quit to exit):")
    break if room_name.downcase == '/quit'

    password = prompt.mask("Enter a password for the room (or press enter to skip):")
    username = prompt.ask("Enter your username:")

    if chat_controller.chat_rooms[room_name]
      if chat_controller.chat_rooms[room_name].password == password
        chat_controller.chat_rooms[room_name].add_client(client, username)
        chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name], username)
      else
        client.puts "Incorrect password. Try again.".colorize(:red)
      end
    else
      chat_controller.create_room(room_name, password, username)
      chat_controller.chat_rooms[room_name].add_client(client, username)
      chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name], username)
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
