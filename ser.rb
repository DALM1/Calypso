require 'socket'
require_relative './controllers/chat_controller'

server_ip = ENV['SERVER_IP'] || '0.0.0.0'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

server = TCPServer.new(server_ip, server_port)
chat_controller = ChatController.new

clients = {}

puts "Server listening on #{server_ip}:#{server_port}"

def handle_room_selection(client, chat_controller, clients)
  client.puts "Enter the name of the room you want to create or join (or /quit to exit):"
  room_name = client.gets&.chomp
  return if room_name.nil? || room_name.downcase == '/quit'

  client.puts "Enter a password for the room (or press enter to skip):"
  password = client.gets&.chomp

  client.puts "Enter your username:"
  username = client.gets&.chomp

  clients[username] = client

  if chat_controller.chat_rooms[room_name]
    if chat_controller.chat_rooms[room_name].password == password
      chat_controller.chat_rooms[room_name].add_client(client, username)
      chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name], username, clients)
    else
      client.puts "[ERROR] Incorrect password. Try again."
    end
  else
    chat_controller.create_room(room_name, password, username)
    chat_controller.chat_rooms[room_name].add_client(client, username)
    chat_controller.chat_loop(client, chat_controller.chat_rooms[room_name], username, clients)
  end
end

loop do
  client = server.accept
  Thread.new(client) do |client_connection|
    handle_room_selection(client_connection, chat_controller, clients)
    client_connection.close
  end
end
