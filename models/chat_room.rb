require 'tzinfo'

class ChatRoom
  attr_accessor :name, :password, :clients, :creator, :history

  def initialize(name, password = nil, creator = 'Server')
    @name = name
    @password = password
    @clients = {}
    @creator = creator
    @history = []
  end

  def add_client(client, username)
    @clients[username] = client
    broadcast_message("#{username} has joined the chat", 'Server')
  end

  def remove_client(client, username)
    @clients.delete(username)
    broadcast_message("#{username} has left the chat", 'Server')
  end

  def broadcast_message(message, sender)
    tz = TZInfo::Timezone.get('Europe/Paris')
    timestamp = tz.now.strftime('%Y-%m-%d %H:%M:%S')

    formatted_message = "#{timestamp} #{sender}: #{message}"
    @history << formatted_message
    @clients.each do |username, client|
      client.puts formatted_message unless username == sender
    end
  end

  def list_users
    @clients.keys.join(', ')
  end

  def change_password(new_password)
    @password = new_password
  end
end
