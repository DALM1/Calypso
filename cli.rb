require 'socket'

server_ip = '127.0.0.1'
server_port = 3000

client = TCPSocket.new(server_ip, server_port)

puts "                                               "
    puts "-----------------------------------------------"
    puts "                                               "

    puts "(       ) (    (       )"
    puts "(    (     )\\ ) ( /( )\\ ) )\\ ) ( /("
    puts ")\\   )\\   (()/( )\\()|()/((()/( )\\())"
    puts "(((_|(((_)(  /(_)|(_)/ /(_))/(_)|(_)/"
    puts ")\\___)\\ _ )\\(_))__ ((_|_)) (_))   ((_)"
    puts "((/ __(_)_\\(_) | \\ \\ / / _ \\/ __| / _ \\"
    puts "| (__ / _ \\ | |__\\ V /|  _/\\__ \\| (_) |"
    puts " \\___/_/ \\_\\|____||_| |_|  |___/ \\___/ "

    puts "                                               "
    puts "-----------------------------------------------"
    puts "             Welcome to Calypso                "
    puts "             All right reserved                "
    puts "                                               "
    puts "                                               "

puts "Connected to chat server at #{server_ip}:#{server_port}"

Thread.new do
  loop do
    message = client.gets.chomp
    puts message
  end
end

loop do
  message = gets.chomp
  client.puts message
end

client.close
