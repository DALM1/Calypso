require 'socket'
require_relative './controllers/chat_controller'

server_ip = ENV['SERVER_IP'] || '0.0.0.0'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

server = TCPServer.new(server_ip, server_port)
chat_controller = ChatController.new

puts "Server listening on #{server_ip}:#{server_port}"

loop do
  client = server.accept
  Thread.new(client) do |client_connection|
    client_connection.puts "Enter your username:"
    username = client_connection.gets&.chomp
    chat_controller.create_room("Main", nil, "Server")
    chat_controller.chat_rooms["Main"].add_client(client_connection, username)
    chat_controller.chat_loop(client_connection, chat_controller.chat_rooms["Main"], username)
    client_connection.close
  end
end
