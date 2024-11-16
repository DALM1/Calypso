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
      result = local_or_remote_command(command)
      chat_room.broadcast_message("Result of '#{command}':\n#{result}", sender)
    else
      chat_room.broadcast_message("#{target} is not connected.", sender)
    end
  rescue => e
    chat_room.broadcast_message("Error executing command: #{e.message}", sender)
  end

  private

  def local_or_remote_command(command)
    if command.start_with?('ssh:')
      execute_remote_command(command)
    else
      `#{command}`.strip
    end
  end

  def execute_remote_command(command)
    _, ssh_details, cmd = command.split(' ', 2)
    user_host, password = ssh_details.split(':', 2)
    user, host = user_host.split('@', 2)

    raise 'Invalid SSH command format' unless user && host && password && cmd

    Net::SSH.start(host, user, password: password) do |ssh|
      ssh.exec!(cmd)
    end
  rescue StandardError => e
    "Error: #{e.message}"
  end
end
