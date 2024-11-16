require 'socket'

server_ip = ENV['SERVER_IP'] || '195.35.1.108'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

begin
  client = TCPSocket.new(server_ip, server_port)
  puts "Connected to Calypso server at #{server_ip}:#{server_port}"
rescue => e
  puts "Unable to connect: #{e.message}"
  exit
end

Thread.new do
  loop do
    begin
      message = client.gets&.chomp
      puts message unless message.nil?
    rescue Errno::ECONNRESET, IOError
      puts "Connection lost. Attempting to reconnect..."
      sleep 2
      retry
    end
  end
end

Thread.new do
  loop do
    begin
      sleep 10
      client.puts '/ping'
    rescue Errno::EPIPE
      puts "Lost connection to server."
      exit
    end
  end
end

loop do
  input = gets.chomp
  client.puts input
end
