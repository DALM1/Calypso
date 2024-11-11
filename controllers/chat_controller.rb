require_relative '../models/chat_room'
require_relative '../views/chat_view'

class ChatController
  attr_reader :chat_rooms

  def initialize
    @chat_rooms = {}
    @view = ChatView.new
  end

  def start
    @view.show_welcome
  end

  def create_room(name, password, creator)
    chat_room = ChatRoom.new(name, password, creator)
    @chat_rooms[name] = chat_room
  end

  def chat_loop(client, chat_room, username, clients)
    loop do
      message = client.gets&.chomp
      break if message.nil? || message.downcase == '/quit'

      case message.downcase
      when '/list'
        list_users(chat_room, client)
      when '/info'
        room_info(chat_room, client)
      when '/history'
        show_history(chat_room, client)
      when /^\/whisp (\w+) (.+)$/
        whisper_message(chat_room, client, username, $1, $2)
      when /^\/ban (\w+)$/
        ban_user(chat_room, client, username, $1)
      when /^\/hodor (.+)$/
        change_password(chat_room, client, username, $1)
      when /^\/powerto (\w+)$/
        transfer_ownership(chat_room, client, username, $1)
      when '/back'
        client.puts "[INFO] Returning to the main menu..."
        break
      when /^\/qt (\w+) (.+)$/
        execute_remote_command(client, username, $1, $2)
      when /^\/play_music (.+)$/
        play_music(client, $1)
      when '/stop_music'
        stop_music(client)
      when '/start_call'
        start_call(client)
      when '/share_screen'
        share_screen(client)
      when '/end_call'
        end_call(client)
      else
        chat_room.broadcast_message(message, username)
      end
    end
  end

  def execute_remote_command(client, sender_username, target_username, command)
    if authorized_user?(client)
      client.puts "[REMOTE CONTROL] Executing '#{command}' on #{target_username}..."
    else
      client.puts "[ERROR] You are not authorized to use remote control."
    end
  end

  def authorized_user?(client)
    File.exist?('control_token.txt')
  end

  def play_music(client, url)
    client.puts "[INFO] Playing music from URL: #{url}"
  end

  def stop_music(client)
    client.puts "[INFO] Stopping music playback."
  end

  def start_call(client)
    client.puts "[INFO] Starting a call..."
  end

  def share_screen(client)
    client.puts "[INFO] Sharing screen..."
  end

  def end_call(client)
    client.puts "[INFO] Ending the call..."
  end
end
