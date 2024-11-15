class ChatRoom
  attr_accessor :name, :password, :clients, :creator, :history, :banned_users

  def initialize(name, password = nil, creator = nil)
    @name = name
    @password = password
    @clients = {}
    @history = []
    @creator = creator
    @banned_users = []
  end

  def add_client(client, username)
    if @banned_users.include?(username)
      client.puts "You are banned from this room."
      return
    end

    @clients[username] = client
    broadcast_message("#{username} joined the room.", 'Server')
  end

  def remove_client(username)
    @clients.delete(username)
    broadcast_message("#{username} left the room.", 'Server')
  end

  def ban_user(username)
    remove_client(username)
    @banned_users << username
    broadcast_message("#{username} has been banned.", 'Server')
  end

  def kick_user(username)
    remove_client(username)
    broadcast_message("#{username} has been kicked out of the room.", 'Server')
  end

  def react_to_message(message_id, reaction, username)
    if message_id >= 0 && message_id < @history.size
      @history[message_id] += " (#{reaction} by #{username})"
      broadcast_message("Reaction added to message #{message_id}: #{reaction}", 'Server')
    else
      @clients[username].puts "Invalid message ID."
    end
  end

  def broadcast_message(message, sender)
    timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    formatted_message = "[#{timestamp}] #{sender}: #{message}"
    @history << formatted_message
    @clients.each_value { |client| client.puts formatted_message }
  end

  def list_users
    @clients.keys.join(', ')
  end

  def stats
    <<~STATS
      Room Name: #{@name}
      Creator: #{@creator}
      Active Users: #{@clients.keys.size}
      Total Messages: #{@history.size}
    STATS
  end
end
