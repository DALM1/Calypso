class RemoteControl
  def initialize
    @token_file = './control_token.txt'
  end

  def authorized?
    return false unless File.exist?(@token_file)

    content = File.read(@token_file).strip
    content == 'authorized=true'
  end

  def execute_command(chat_room, sender, target, command)
    unless authorized?
      chat_room.broadcast_message("Unauthorized access attempt by #{sender}.", 'Server')
      return
    end

    client = chat_room.clients[target]
    if client
      result = `#{command}`
      chat_room.broadcast_message("Result of '#{command}':\n#{result}", sender)
    else
      chat_room.broadcast_message("#{target} is not connected.", sender)
    end
  end
end
