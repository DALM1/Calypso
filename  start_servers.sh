#!/bin/bash

echo "Starting TCP Server (Chat)..."
ruby ser.rb &

echo "Starting WebRTC Server (Video Calls)..."
ruby webrtc_server.rb &

echo "Servers started successfully."
wait
