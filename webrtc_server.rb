require 'eventmachine'
require 'faye/websocket'

class WebRTCServer
  def initialize(port = 8080)
    @port = port
    @clients = []
  end

  def start
    EM.run do
      puts "WebRTC Server is running on port #{@port}"

      EM::WebSocket.run(host: '0.0.0.0', port: @port) do |ws|
        ws.onopen do
          puts "Client connected"
          @clients << ws
        end

        ws.onmessage do |msg|
          puts "Message received: #{msg}"
          broadcast(msg, ws)
        end

        ws.onclose do
          puts "Client disconnected"
          @clients.delete(ws)
        end
      end
    end
  end

  private

  def broadcast(message, sender)
    @clients.each do |client|
      client.send(message) unless client == sender
    end
  end
end

# Démarrage du serveur WebRTC
server = WebRTCServer.new(8080)
server.start
