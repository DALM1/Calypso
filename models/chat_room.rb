class ChatRoom
  attr_accessor :name, :password, :clients, :creator, :history, :banned_users, :roles, :statuses, :pinned_messages, :events

  def initialize(name, password = nil, creator = nil)
    @name = name
    @password = password
    @clients = {}
    @history = []
    @creator = creator
    @banned_users = []
    @roles = { creator => 'admin' }
    @statuses = {}
    @pinned_messages = []
    @events = []
  end

  def change_password(username, new_password)
    if username == @creator
      @password = new_password
    else
      raise "Only the creator can change the password."
    end
  end

  def set_status(username, status)
    @statuses[username] = status
  end

  def get_all_statuses
    @statuses.map { |user, status| "#{user}: #{status}" }.join("\n")
  end

  def pin_message(message_id, username)
    if @roles[username] == 'admin' || username == @creator
      @pinned_messages << @history[message_id]
    else
      raise "Only administrators can pin messages."
    end
  end

  def view_pins
    @pinned_messages.join("\n")
  end

  def schedule_event(title, date_time)
    @events << { title: title, date_time: date_time }
  end

  def view_events
    @events.map { |event| "#{event[:title]} at #{event[:date_time]}" }.join("\n")
  end
end

def add_client(client, username)
  if @banned_users.include?(username)
    client.puts "You are banned from this thread."
    return
  end

  @clients[username] = client
  broadcast_message("#{username} joined the thread.", 'Server')
  notify_all("#{username} is now online.", 'Server')
end

def remove_client(username)
  @clients.delete(username)
  broadcast_message("#{username} left the thread.", 'Server')
  notify_all("#{username} is now offline.", 'Server')
end

private

def notify_all(notification, sender)
  @clients.each_value { |client| client.puts "[#{sender}] #{notification}" }
end
