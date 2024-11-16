class CallManager
  @active_calls = {}

  def self.start_call(chat_room)
    return if @active_calls[chat_room.name]

    @active_calls[chat_room.name] = true
    chat_room.broadcast_message("Call started. Join now!", "Server")
  end

  def self.end_call(chat_room)
    return unless @active_calls[chat_room.name]

    @active_calls.delete(chat_room.name)
    chat_room.broadcast_message("Call ended.", "Server")
  end
end
