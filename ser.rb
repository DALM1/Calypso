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

puts "Server listening on #{server_ip}:#{server_port}"

loop do
  begin
    client = server.accept
    Thread.new(client) do |client_connection|
      begin
        client_connection.puts "Enter your username:"
        username = client_connection.gets&.chomp

        if username.nil? || username.empty?
          client_connection.puts "Invalid username. Disconnecting..."
          next
        end

        chat_controller.create_room("Main", nil, "Server") unless chat_controller.chat_rooms.key?("Main")
        chat_room = chat_controller.chat_rooms["Main"]

        chat_room.add_client(client_connection, username)
        chat_controller.chat_loop(client_connection, chat_room, username)
      rescue Errno::ECONNRESET
        puts "Client #{username} disconnected abruptly."
      rescue => e
        puts "Error with client #{username}: #{e.message}"
        client_connection.puts "An error occurred. Disconnecting..."
      ensure
        chat_controller.chat_rooms["Main"]&.remove_client(username) if username
        client_connection.close
      end
    end
  rescue => e
    puts "Error accepting client: #{e.message}"
  end
end
