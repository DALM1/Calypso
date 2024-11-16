require 'socket'

server_ip = ENV['SERVER_IP'] || '195.35.1.108'
server_port = ENV['SERVER_PORT'] ? ENV['SERVER_PORT'].to_i : 3630

begin
  client = TCPSocket.new(server_ip, server_port)

  puts "                                               "
    puts "-----------------------------------------------"
    puts "                                               "

    puts "  (       ) (    (       )"
    puts "  (    (     )\\ ) ( /( )\\ ) )\\ ) ( /("
    puts "  )\\   )\\   (()/( )\\()|()/((()/( )\\())"
    puts "  (((_|(((_)(  /(_)|(_)/ /(_))/(_)|(_)/"
    puts "  )\\___)\\ _ )\\(_))__ ((_|_)) (_))   ((_)"
    puts "  ((/ __(_)_\\(_) | \\ \\ / / _ \\/ __| / _ \\"
    puts "  | (__ / _ \\ | |__\\ V /|  _/\\__ \\| (_) |"
    puts "   \\___/_/ \\_\\|____||_| |_|  |___/ \\___/ "

    puts "                                               "
    puts "-----------------------------------------------"
    puts "             Welcome to Calypso                "
    puts "             All right reserved                "
    puts "                                               "
    puts "                                               "

  puts "Connected to Calypso at #{server_ip}-#{server_port}"
rescue => e
  puts "Unable to connect: #{e.message}"
  exit
end

Thread.new do
  loop do
    begin
      message = client.gets&.chomp
      puts message unless message.nil?
    rescue => e
      puts "Connection lost: #{e.message}. Retrying..."
      sleep 5
      retry
    end
  end
end

loop do
  input = gets.chomp
  client.puts input
end
