require_relative '../models/chat_room'
require_relative '../views/chat_view'
require_relative '../models/call_manager'
require_relative '../models/poll_manager'
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
    client.puts "Wired on thread > #{chat_room.name}. Type /help for commands."

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
    when '/list'
      client.puts "Users - #{chat_room.list_users}"
    when /^\/cp(.+)$/
      new_password = $1
      chat_room.change_password(username, new_password)
      client.puts "Password updated successfully!"
    when /^\/delete_thread (\w+)$/
      thread_name = $1
      if chat_room.creator == username
        @chat_rooms.delete(thread_name)
        client.puts "Thread '#{thread_name}' deleted."
      else
        client.puts "Only the creator can delete this thread."
      end
    when /^\/status (.+)$/
      status = $1
      chat_room.set_status(username, status)
      client.puts "Status updated to: #{status}"
    when '/view_status'
      statuses = chat_room.get_all_statuses
      client.puts "User statuses:\n#{statuses}"
    when /^\/pin_message (\d+)$/
      message_id = $1.to_i
      chat_room.pin_message(message_id, username)
      client.puts "Message #{message_id} pinned!"
    when '/view_pins'
      pins = chat_room.view_pins
      client.puts "Pinned messages:\n#{pins}"
    when /^\/schedule_event "(.+)" (.+)$/
      title, date_time = $1, $2
      chat_room.schedule_event(title, date_time)
      client.puts "Event '#{title}' scheduled for #{date_time}."
    when '/view_events'
      events = chat_room.view_events
      client.puts "Scheduled events:\n#{events}"
    else
      chat_room.broadcast_message(message, username)
    end
  end
end
