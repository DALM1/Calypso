class MusicManager
  def self.play(chat_room)
    chat_room.broadcast_message("Playing music...")
  end

  def self.stop(chat_room)
    chat_room.broadcast_message("Music stopped.")
  end
end
