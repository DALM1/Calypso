require 'net/ssh'

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
      result = `#{command}`.strip
      chat_room.broadcast_message("Result of '#{command}':\n#{result}", sender)
    else
      chat_room.broadcast_message("#{target} is not connected. Available users: #{chat_room.clients.keys.join(', ')}", sender)
    end
  rescue => e
    chat_room.broadcast_message("Error executing command: #{e.message}", sender)
  end
end
