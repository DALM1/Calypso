require 'socket'
require_relative './controllers/chat_controller'

port = 3000
server = TCPServer.new(port)
chat_controller = ChatController.new

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
puts "Server listening lightning fast on port #{port}"

def handle_room_selection(client, chat_controller)
  loop do
    client.puts "Enter the name of the room you want to create or join (or /quit to exit)"
    room_name = client.gets.chomp
    return if room_name.downcase == '/quit'

    client.puts "Enter a password for the room (or press enter to skip)"
    password = client.gets.chomp

    client.puts "Enter your username:"
    username = client.gets.chomp

    if chat_controller.chat_rooms[room_name]
      if chat_controller.chat_rooms[room_name].password == password
        chat_controller.chat_rooms[room_name].add_client(client, username)
        chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name])
      else
        client.puts "Incorrect password. Try again."
      end
    else
      chat_controller.create_room(room_name, password, username)
      chat_controller.chat_rooms[room_name].add_client(client, username)
      chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name])
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
