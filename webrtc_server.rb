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

      EM::WebSocket.start(host: "0.0.0.0", port: @port) do |ws|
        ws.onopen do
          @clients << ws
          puts "Client connected."
        end

        ws.onmessage do |msg|
          @clients.each { |client| client.send(msg) unless client == ws }
        end

        ws.onclose do
          @clients.delete(ws)
          puts "Client disconnected."
        end
      end
    end
  end
end

server = WebRTCServer.new(8080)
server.start
