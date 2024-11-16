require 'socket'
require_relative './controllers/chat_controller'

server_ip = ENV['SERVER_IP'] || '0.0.0.0'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

server = TCPServer.new(server_ip, server_port)
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

puts "Server running at #{server_ip}-#{server_port}"

loop do
  Thread.new(server.accept) do |client_connection|
    begin
      client_connection.puts "Enter your username"
      username = client_connection.gets&.chomp
      chat_controller.create_room("Main", nil, "Server") unless chat_controller.chat_rooms.key?("Main")
      chat_controller.chat_rooms["Main"].add_client(client_connection, username)
      chat_controller.chat_loop(client_connection, chat_controller.chat_rooms["Main"], username)
    rescue => e
      puts "Client error: #{e.message}"
    ensure
      client_connection.close
    end
  end
end
