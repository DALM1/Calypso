#!/bin/bash
echo "Starting Calypso server..."
ruby ser.rb &
ruby webrtc_server.rb &
wait
