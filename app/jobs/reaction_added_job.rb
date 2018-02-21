class ReactionAddedJob < ApplicationJob
  queue_as :default

  COINS = 5

  def perform(team_id, user_id, channel)
    bot = Slack::Web::Client.new

    slack_user = SlackUser.find_by(
      team_id: team_id, 
      user_id: user_id
    )

    if slack_user
      transaction = send_coin(slack_user.address)

      message = "<@#{user_id}> #{COINS} MOF 送金しましたよ〜\nhttps://ropsten.etherscan.io/tx/#{transaction.id}"
    else
      message = "<@#{user_id}> イーサリアムのアドレスはまだ登録されてないようですね〜\n`/register ADDRESS`を実行して登録しましょう！"
    end

    bot.chat_postMessage(as_user: 'true', channel: channel, text: message)
  end

  private

    def send_coin(address)
      TokenContract.instance.transact.transfer(address, COINS * 10**18)
    end
end
