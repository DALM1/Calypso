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
      client.puts "You are banned from this thread."
      return
    end

    @clients[username] = client
    broadcast_message("#{username} joined the thread.", 'Server')
  end

  def remove_client(username)
    @clients.delete(username)
    broadcast_message("#{username} left the thread.", 'Server')
  end

  def broadcast_message(message, sender)
    timestamp = Time.now.strftime('%Y-%m-%d %H:%M:%S')
    formatted_message = "[#{timestamp}] #{sender}: #{message}"
    @history << formatted_message
    log_message(formatted_message)
    @clients.each_value { |client| client.puts formatted_message }
  end

  private

  def log_message(message)
    File.open('./logs/chat_logs.txt', 'a') { |file| file.puts(message) }
  rescue => e
    puts "Failed to log message: #{e.message}"
  end
end
