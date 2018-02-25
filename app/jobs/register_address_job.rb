class RegisterAddressJob < ApplicationJob
  queue_as :default

  def perform(team_id, user_id, address, channel)
    slack_user = SlackUser.find_or_initialize_by(
      team_id: team_id,
      user_id: user_id
    )

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

    SlackBot.instance.send_message(channel: channel, message: message)
  end
end
