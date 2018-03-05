require 'active_support'
require 'active_support/core_ext'
require 'singleton'

class SlackBot
  include Singleton

  def initialize
    @bot = Slack::Web::Client.new
  end

  def send_message(channel: , message: , ts: nil)
    @bot.chat_postMessage(as_user: 'true', channel: channel, text: message, thread_ts: ts)
  end

  def user_name(slack_user: )
    response = @bot.users_info(user: slack_user.user_id)
    response.user.name
  rescue Slack::Web::Api::Errors::SlackError
    slack_user.address
  end
end
