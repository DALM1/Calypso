require_relative '../models/chat_room'
require_relative '../views/chat_view'
require_relative '../models/call_manager'
# require_relative '../models/music_manager'
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
    chat_room = ChatRoom.new(name, password, creator)
    @chat_rooms[name] = chat_room
  end

  def chat_loop(client, chat_room, username)
    client.puts "Welcome to the room: #{chat_room.name}. Type /help for commands."

    loop do
      message = client.gets&.chomp
      break if message.nil? || message.downcase == '/quit'

      handle_command(message, client, chat_room, username)
    end

    chat_room.remove_client(username)
    client.puts "You have left the room."
  end

  private

  def handle_command(message, client, chat_room, username)
    case message.downcase
    when '/list'
      client.puts "Users: #{chat_room.list_users}"
    when '/history'
      chat_room.history.each { |msg| client.puts msg }
    when /^\/whisp (.+) (.+)$/
      recipient, msg = $1, $2
      chat_room.whisper(username, recipient, msg)
    when /^\/qt (.+) (.+)$/
      target, cmd = $1, $2
      @remote_control.execute_command(chat_room, username, target, cmd)
    when '/play'
      MusicManager.play(chat_room)
    when '/stop'
      MusicManager.stop(chat_room)
    when '/start_call'
      CallManager.start_call(chat_room)
    when '/share_screen'
      CallManager.start_screen_share(chat_room)
    when /^\/ban (.+)$/
      user_to_ban = $1
      if chat_room.clients.key?(user_to_ban)
        chat_room.remove_client(user_to_ban)
        client.puts "#{user_to_ban} has been banned."
      else
        client.puts "#{user_to_ban} not found in the room."
      end
    when /^\/powerto (.+)$/
      new_owner = $1
      if chat_room.clients.key?(new_owner)
        chat_room.creator = new_owner
        chat_room.broadcast_message("#{new_owner} is now the owner.", 'Server')
      else
        client.puts "#{new_owner} not found in the room."
      end
    else
      chat_room.broadcast_message(message, username)
    end
  end
end
