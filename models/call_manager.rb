class CallManager
  def self.start_call(chat_room)
    chat_room.broadcast_message("Call started in the room. Join now!")
  end

  def self.start_screen_share(chat_room)
    chat_room.broadcast_message("Screen sharing started. Share the link to join.")
  end
end
