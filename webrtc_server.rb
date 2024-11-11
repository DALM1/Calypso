require 'faye/websocket'
require 'eventmachine'

EM.run do
  clients = []

  EM::WebSocket.run(host: "0.0.0.0", port: 4567) do |ws|
    ws.onopen do
      clients << ws
      puts "[INFO] WebRTC client connected"
    end

    ws.onmessage do |msg|
      clients.each { |client| client.send(msg) unless client == ws }
    end

    ws.onclose do
      clients.delete(ws)
      puts "[INFO] WebRTC client disconnected"
    end
  end
end
