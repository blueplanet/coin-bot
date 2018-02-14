class RegisterAddressJob < ApplicationJob
  queue_as :default

  def perform(team_id, user_id, address, channel)
    slack_user = SlackUser.find_or_initialize_by(
      team_id: team_id,
      user_id: user_id
    )

    bot = Slack::Web::Client.new

    if slack_user.new_record?
      if Eth::Utils.valid_address?(address)
        slack_user.address = address
        slack_user.save!

        message = "<@#{user_id}> 下記アドレスで登録しました〜\n`#{address}`"
      else
        message = "<@#{user_id}> 有効なアドレスではないようです〜\n`#{address}`"
      end
    else
      message = "<@#{user_id}> 既に下記アドレスで登録済みです〜\n`#{slack_user.address}`"
    end

    bot.chat_postMessage(as_user: 'true', channel: channel, text: message)
  end
end
