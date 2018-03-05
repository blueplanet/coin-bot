class ReactionAddedJob < ApplicationJob
  queue_as :default

  COINS = 5

  def perform(team_id, user_id, channel, ts)
    slack_user = SlackUser.find_by(
      team_id: team_id, 
      user_id: user_id
    )

    if slack_user
      transaction = send_coin(slack_user.address)

      message = "<@#{user_id}> #{COINS} MOF 送金しましたよ〜\nhttps://ropsten.etherscan.io/tx/#{transaction.id}"
    else
      message = "<@#{user_id}> イーサリアムのアドレスはまだ登録されてないようですね〜\n`@mof-coin register 自分のRopstenアドレス` を送信して登録しましょう！"
    end

    SlackBot.instance.send_message(channel: channel, message: message, ts: ts)
  end

  private

    def send_coin(address)
      TokenContract.instance.transact.transfer(address, COINS * 10**18)
    end
end
