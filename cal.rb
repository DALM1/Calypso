require 'socket'

server_ip = ENV['SERVER_IP'] || '195.35.1.108'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

begin
  client = TCPSocket.new(server_ip, server_port)
  puts "Connected to server: #{server_ip}:#{server_port}"
rescue => e
  puts "Connection failed: #{e.message}"
  exit
end

Thread.new do
  loop do
    begin
      message = client.gets&.chomp
      puts message unless message.nil?
    rescue IOError
      puts "Connection lost. Reconnecting..."
      exit
    end
  end
end

loop do
  input = gets.chomp
  client.puts input
end
