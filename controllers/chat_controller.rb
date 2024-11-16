require_relative '../models/chat_room'
require_relative '../views/chat_view'
require_relative '../models/call_manager'
require_relative '../controllers/remote_control'

class ChatController
  attr_reader :chat_rooms

  def initialize
    @chat_rooms = {}
    @view = ChatView.new
    @remote_control = RemoteControl.new
  end

  def start
    @view.show_welcome
  end

  def create_room(name, password, creator)
    if @chat_rooms.key?(name)
      return false
    end

    chat_room = ChatRoom.new(name, password, creator)
    @chat_rooms[name] = chat_room
    true
  end

  def chat_loop(client, chat_room, username)
    client.puts "Welcome to thread '#{chat_room.name}'. Type /help for commands."

    loop do
      message = client.gets&.chomp
      break if message.nil? || message.downcase == '/quit'

      handle_command(message, client, chat_room, username)
    end

    chat_room.remove_client(username)
    client.puts "You have left the thread."
  end

  private

  def handle_command(message, client, chat_room, username)
    case message.downcase
    when '/help'
      client.puts chat_room.commands
    when '/list'
      client.puts "Users: #{chat_room.list_users}"
    when '/history'
      chat_room.history.each { |msg| client.puts msg }
    when '/banned'
      client.puts "Banned users: #{chat_room.banned_users.join(', ')}"
    when /^\/cr (\w+)(?: (.+))?$/
      room_name = $1
      room_password = $2
      if create_room(room_name, room_password, username)
        client.puts "Thread '#{room_name}' created successfully."
      else
        client.puts "Thread '#{room_name}' already exists."
      end
    when /^\/cd (\w+)(?: (.+))?$/
      room_name = $1
      room_password = $2
      if @chat_rooms.key?(room_name)
        target_room = @chat_rooms[room_name]
        if target_room.password.nil? || target_room.password == room_password
          chat_room.remove_client(username)
          target_room.add_client(client, username)
          chat_loop(client, target_room, username)
          return
        else
          client.puts "Incorrect password for thread '#{room_name}'"
        end
      else
        client.puts "Thread '#{room_name}' does not exist."
      end
    when /^\/cpd (.+)$/
      new_password = $1
      if username == chat_room.creator
        chat_room.password = new_password
        chat_room.broadcast_message("Thread password has been changed.", 'Server')
      else
        client.puts "Only the thread creator can change the password."
      end
    when /^\/ban (.+)$/
      user_to_ban = $1
      if username == chat_room.creator
        chat_room.ban_user(user_to_ban)
        client.puts "#{user_to_ban} has been banned."
      else
        client.puts "Only the thread creator can ban users."
      end
    when /^\/kick (.+)$/
      user_to_kick = $1
      if username == chat_room.creator
        chat_room.kick_user(user_to_kick)
        client.puts "#{user_to_kick} has been kicked from the thread."
      else
        client.puts "Only the thread creator can kick users."
      end
    when /^\/dm (\w+) (.+)$/
      recipient, dm_message = $1, $2
      chat_room.direct_message(username, recipient, dm_message)
    when /^\/qt (.+) (.+)$/
      target, cmd = $1, $2
      @remote_control.execute_command(chat_room, username, target, cmd)
    else
      chat_room.broadcast_message(message, username)
    end
  end
end
