class GetBalanceJob < ApplicationJob
  queue_as :default

  def perform(team_id, user_id, channel)
    slack_user = SlackUser.find_by(team_id: team_id, user_id: user_id)
    bot = Slack::Web::Client.new

    if slack_user
      balance = get_balance(slack_user.address)
      message = "<@#{user_id}> 残高は #{balance.to_s :delimited} MOF です〜"
    else
      message = "<@#{user_id}> アドレスはまだ登録されてないようです〜\n/register ADDRESSで登録しましょう！"
    end

    bot.chat_postMessage(as_user: 'true', channel: channel, text: message)
  end

  private

    def get_balance(address)
      TokenContract.instance.call.balance_of(address) / 10**18
    end
end
