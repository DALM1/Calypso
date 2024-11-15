class ChatRoom
  attr_accessor :name, :password, :clients, :creator, :history

  def initialize(name, password = nil, creator = nil)
    @name = name
    @password = password
    @clients = {}
    @history = []
    @creator = creator
  end

  def add_client(client, username)
    @clients[username] = client
    broadcast_message("#{username} joined the room.", 'Server')
  end

  def remove_client(username)
    @clients.delete(username)
    broadcast_message("#{username} left the room.", 'Server')
  end

  def broadcast_message(message, sender)
    timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    formatted_message = "[#{timestamp}] #{sender}: #{message}"
    @history << formatted_message
    @clients.each_value { |client| client.puts formatted_message }
  end

  def whisper(sender, recipient, message)
    if @clients.key?(recipient)
      @clients[recipient].puts "[Whisper from #{sender}]: #{message}"
    else
      @clients[sender].puts "#{recipient} is not in the room."
    end
  end

  def list_users
    @clients.keys.join(', ')
  end
end
