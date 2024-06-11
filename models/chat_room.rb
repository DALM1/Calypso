class ChatRoom
  attr_accessor :name, :password, :clients, :creator

  def initialize(name, password = nil, creator = "Server")
    @name = name
    @password = password
    @clients = {}
    @creator = creator
  end

  def add_client(client, username)
    @clients[username] = client
    broadcast_message("#{username} has joined the chat room.", "Server")
  end

  def remove_client(client, username)
    @clients.delete(username)
    broadcast_message("#{username} has left the chat room.", "Server")
  end

  def broadcast_message(message, sender)
    timestamp = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    formatted_message = "#{timestamp} #{sender}: #{message}"
    @clients.each do |username, client|
      client.puts formatted_message unless username == sender
    end
  end

  def list_users
    @clients.keys.join(', ')
  end
end
