class GetBalanceJob < ApplicationJob
  queue_as :default

  def perform(team_id, user_id, channel, ts)
    slack_user = SlackUser.find_by(team_id: team_id, user_id: user_id)

    if slack_user
      balance = get_balance(slack_user.address)
      message = "<@#{user_id}> 残高は #{balance.to_s :delimited} MOF です〜"
    else
      message = "<@#{user_id}> アドレスはまだ登録されてないようです〜\n`@mof-coin register 自分のRopstenアドレス` を送信して登録しましょう！"
    end

    SlackBot.instance.send_message(channel: channel, message: message, ts: ts)
  end

  private

    def get_balance(address)
      TokenContract.instance.call.balance_of(address) / 10**18
    end
end
