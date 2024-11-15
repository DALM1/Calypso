require 'socket'
require_relative './controllers/chat_controller'

server_ip = ENV['SERVER_IP'] || '0.0.0.0'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

server = TCPServer.new(server_ip, server_port)
chat_controller = ChatController.new

puts "Server listening on #{server_ip}:#{server_port}"

loop do
  begin
    client = server.accept
    Thread.new(client) do |client_connection|
      begin
        client_connection.puts "Enter your username:"
        username = client_connection.gets&.chomp
        chat_controller.create_room("Main", nil, "Server") unless chat_controller.chat_rooms.key?("Main")
        chat_controller.chat_rooms["Main"].add_client(client_connection, username)
        chat_controller.chat_loop(client_connection, chat_controller.chat_rooms["Main"], username)
      rescue => e
        puts "Error with client connection: #{e.message}"
        client_connection.puts "An error occurred. Disconnecting..."
      ensure
        client_connection.close
      end
    end
  rescue => e
    puts "Error accepting client: #{e.message}"
  end
end
