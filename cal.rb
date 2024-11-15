require 'socket'

server_ip = ENV['SERVER_IP'] || '0.0.0.0'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

client = TCPSocket.new(server_ip, server_port)

puts "Connected to Calypso server at #{server_ip}:#{server_port}"

Thread.new do
  loop do
    message = client.gets&.chomp
    puts message
  end
end

loop do
  input = gets.chomp
  client.puts input
end
