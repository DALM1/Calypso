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
    return false if @chat_rooms.key?(name)

    chat_room = ChatRoom.new(name, password, creator)
    @chat_rooms[name] = chat_room
    true
  end

  def chat_loop(client, chat_room, username)
    client.puts "Connected to thread > #{chat_room.name}. Type /help for commands."

    loop do
      message = client.gets&.chomp
      break if message.nil? || message.downcase == '/quit'

      handle_command(message, client, chat_room, username)
    end

    chat_room.remove_client(username)
    client.puts "You have left the thread."
  rescue => e
    puts "Error in chat loop: #{e.message}"
    chat_room.remove_client(username)
  end

  private

  def handle_command(message, client, chat_room, username)
    case message.downcase
    when '/list'
      client.puts "Users: #{chat_room.list_users}"
    when '/history'
      chat_room.history.each { |msg| client.puts msg }
    when '/ping'
      client.puts 'PONG'
    when '/banned'
      client.puts "Banned users: #{chat_room.banned_users.join(', ')}"
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
