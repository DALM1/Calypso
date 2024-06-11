require_relative '../models/chat_room'
require_relative '../views/chat_view'

class ChatController
  attr_reader :chat_rooms

  def initialize
    @chat_rooms = {}
    @view = ChatView.new
  end

  def start
    @view.welcome_message
  end

  def create_room(name, password)
    chat_room = ChatRoom.new(name, password)
    @chat_rooms[name] = chat_room
  end

  def chat_loop(client, chat_room)
    username = prompt_username(client)
    client.puts "Welcome, #{username}"
    chat_room.add_client(client, username)

    loop do
      message = client.gets.chomp
      if message.downcase == '/quit'
        chat_room.remove_client(client, username)
        break
      elsif message.downcase == '/list'
        list_users(chat_room, client)
      else
        chat_room.broadcast_message(message, username)
      end
    end

    client.puts "You have left the room. Enter another room name or /quit to exit."
  end

  def list_users(chat_room, client)
    usernames = chat_room.clients.keys
    client.puts "Users in this room: #{usernames.join(', ')}"
  end

  def prompt_username(client)
    client.puts "Enter a username:"
    client.gets.chomp
  end
end
