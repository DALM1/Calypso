require 'faye/websocket'
require 'eventmachine'
require 'json'

module ChatApp
  class WebSocketApp
    KEEPALIVE_TIME = 15

    def initialize
      @clients = []
    end

    def call(env)
      if Faye::WebSocket.websocket?(env)
        ws = Faye::WebSocket.new(env, nil, {ping: KEEPALIVE_TIME})

        ws.on :open do |event|
          @clients << ws
          puts "Connected: #{ws.object_id}"
        end

        ws.on :message do |event|
          @clients.each { |client| client.send(event.data) }
          puts "Received message: #{event.data}"
        end

        ws.on :close do |event|
          @clients.delete(ws)
          ws = nil
          puts "WebSocket closed | Code: #{event.code}, Reason: #{event.reason}"
        end

        ws.rack_response
      else

        [200, {'Content-Type' => 'text/plain'}, ['WebSocket server']]
      end
    end
  end
end

EventMachine.run {
  server = ChatApp::WebSocketApp.new
  EventMachine.start_server('0.0.0.0', 3630, server)
  puts "Server started on ws://0.0.0.0:3630"
}
