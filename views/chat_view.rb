require_relative './futuristic_ui'

class ChatView
  def initialize
    @ui = FuturisticUI.new
  end

  def show_welcome
    @ui.show_welcome
  end

  def display_message(message)
    @ui.display_message(message, :info)
  end

  def error_message(error)
    @ui.display_message(error, :error)
  end

  def input_prompt(prompt)
    @ui.display_message(prompt, :prompt)
    print "> "
    gets.chomp
  end
end
