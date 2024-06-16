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

  def create_room(name, password, creator)
    chat_room = ChatRoom.new(name, password, creator)
    @chat_rooms[name] = chat_room
  end

  def chat_loop(client, chat_room, username)
    client.puts "Welcome, #{username}"

    loop do
      message = client.gets&.chomp
      break if message.nil? || message.downcase == '/quit'

      case message.downcase
      when '/list'
        list_users(chat_room, client)
      when '/info'
        room_info(chat_room, client)
      when /^\/hodor (.+)$/
        change_password(chat_room, client, username, $1)
      when /^\/ban (.+)$/
        ban_user(chat_room, client, username, $1)
      when /^\/powerto (.+)$/
        transfer_ownership(chat_room, client, username, $1)
      when /^\/erased (.+)$/
        erase_room(chat_room, client, username, $1)
      when /^\/axios (.+) (.+)$/
        redirect_room(chat_room, client, username, $1, $2)
      else
        chat_room.broadcast_message(message, username)
      end
    end

    chat_room.remove_client(client, username)
    client.puts "You have left the room. Enter another room name or /quit to exit"
  end

  def list_users(chat_room, client)
    client.puts "Users in this room: #{chat_room.list_users}"
  end

  def room_info(chat_room, client)
    client.puts "Room Name: #{chat_room.name}"
    client.puts "Creator: #{chat_room.creator}"
    client.puts "Users: #{chat_room.list_users}"
  end

  def change_password(chat_room, client, username, new_password)
    if username == chat_room.creator
      chat_room.change_password(new_password)
      client.puts "Password changed successfully."
    else
      client.puts "Only the creator can change the password."
    end
  end

  def ban_user(chat_room, client, username, user_to_ban)
    if username == chat_room.creator
      if chat_room.clients[user_to_ban]
        chat_room.remove_client(chat_room.clients[user_to_ban], user_to_ban)
        client.puts "#{user_to_ban} has been banned from the room."
      else
        client.puts "User #{user_to_ban} not found."
      end
    else
      client.puts "Only the creator can ban users."
    end
  end

  def transfer_ownership(chat_room, client, username, new_owner)
    if username == chat_room.creator
      if chat_room.clients[new_owner]
        chat_room.creator = new_owner
        client.puts "#{new_owner} is now the owner of the room."
      else
        client.puts "User #{new_owner} not found."
      end
    else
      client.puts "Only the current owner can transfer ownership."
    end
  end

  def erase_room(chat_room, client, username, room_name)
    if username == chat_room.creator
      @chat_rooms.delete(room_name)
      chat_room.clients.each do |user, client_conn|
        client_conn.puts "The room #{room_name} has been erased by the creator."
        client_conn.close
      end
      client.puts "Room #{room_name} has been erased."
    else
      client.puts "Only the creator can erase the room."
    end
  end

  def redirect_room(chat_room, client, username, current_room, new_room)
    if username == chat_room.creator
      if @chat_rooms[new_room]
        chat_room.clients.each do |user, client_conn|
          @chat_rooms[new_room].add_client(client_conn, user)
          client_conn.puts "You have been redirected to room #{new_room} by the creator."
        end
        @chat_rooms.delete(current_room)
        client.puts "All users have been redirected to #{new_room} and #{current_room} has been closed."
      else
        client.puts "Target room #{new_room} does not exist."
      end
    else
      client.puts "Only the creator can redirect rooms."
    end
  end

  def prompt_username(client)
    client.puts "Enter a username:"
    client.gets.chomp
  end
end
