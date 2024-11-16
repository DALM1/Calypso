class PollManager
  @polls = {}

  def self.create_poll(chat_room, question, options)
    @polls[chat_room.name] = { question: question, options: options, votes: Hash.new(0) }
  end

  def self.vote(chat_room, username, option)
    poll = @polls[chat_room.name]
    if poll && option > 0 && option <= poll[:options].size
      poll[:votes][option] += 1
    else
      raise "Invalid poll or option!"
    end
  end

  def self.results(chat_room)
    poll = @polls[chat_room.name]
    if poll
      results = poll[:options].map.with_index(1) do |option, index|
        "#{option}: #{poll[:votes][index]} votes"
      end
      "Poll results:\n#{results.join("\n")}"
    else
      "No active poll in this thread."
    end
  end
end
