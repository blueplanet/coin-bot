require 'active_support'
require 'active_support/core_ext'
require 'singleton'

class SlackBot
  include Singleton

  def initialize
    @bot = Slack::Web::Client.new
  end

  def send_message(channel: , message: )
    @bot.chat_postMessage(as_user: 'true', channel: channel, text: message)
  end
end
