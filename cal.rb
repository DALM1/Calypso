require 'socket'
require 'colorize'

server_ip = '195.35.1.108'
server_port = 3630

client = TCPSocket.new(server_ip, server_port)

puts "                                               "
    puts "-----------------------------------------------".colorize(:yellow)
    puts "                                               ".colorize(:green)

    puts "  (       ) (    (       )".colorize(:green)
    puts "  (    (     )\\ ) ( /( )\\ ) )\\ ) ( /(".colorize(:red)
    puts "  )\\   )\\   (()/( )\\()|()/((()/( )\\())".colorize(:red)
    puts "  (((_|(((_)(  /(_)|(_)/ /(_))/(_)|(_)/".colorize(:red)
    puts "  )\\___)\\ _ )\\(_))__ ((_|_)) (_))   ((_)".colorize(:red)
    puts "  ((/ __(_)_\\(_) | \\ \\ / / _ \\/ __| / _ \\"
    puts "  | (__ / _ \\ | |__\\ V /|  _/\\__ \\| (_) |"
    puts "   \\___/_/ \\_\\|____||_| |_|  |___/ \\___/ "

    puts "                                               "
    puts "-----------------------------------------------".colorize(:yellow)
    puts "             Welcome to Calypso                "
    puts "             All right reserved                "
    puts "                                               "
    puts "                                               "

puts "Connected to chat server at #{server_ip}:#{server_port}".colorize(:green)

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
