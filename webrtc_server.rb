require 'faye/websocket'
require 'eventmachine'

class WebRTCServer
  def initialize(port = 8080)
    @port = port
  end

  def start
    EM.run do
      @clients = []
      puts "WebRTC server started on port #{@port}..."

      Faye::WebSocket::Server.start(host: '0.0.0.0', port: @port) do |ws|
        ws.on :open do
          @clients << ws
          puts "Client connected."
        end

        ws.on :message do |msg|
          @clients.each { |client| client.send(msg.data) unless client == ws }
        end

        ws.on :close do
          @clients.delete(ws)
          puts "Client disconnected."
        end
      end
    end
  end
end

server = WebRTCServer.new(8080)
server.start
