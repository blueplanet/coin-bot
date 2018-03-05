class SlackCommandJob < ApplicationJob
  queue_as :default

  include Rails.application.routes.url_helpers

  def perform(team_id, user, channel, text)
    _, command, *command_args = text.split

    case command
    when 'send_to'
      from_user = SlackUser.find_by(team_id: team_id, user_id: user)
      to_user = SlackUser.find_by(team_id: team_id, user_id: parse_user_id(command_args.first))
      url = new_transaction_url(from_user_id: from_user.id, to_user_id: to_user.id, amount: command_args.second)
      message = "下記リンクをクリックし、Metamaskでサインしてください〜\n#{url}"

      SlackBot.instance.send_message(channel: channel, message: message)
    when 'balance'
      GetBalanceJob.perform_later(team_id, user, channel)
    when 'register'
      RegisterAddressJob.perform_later(team_id, user, command_args.first, channel)
    else
      message = <<~EOS
      下記のコマンド実行できます。
      `@mof-coin register 自分のRopstenアドレス` アドレス登録
      `@mof-coin balance` 残高表示
      EOS

      SlackBot.instance.send_message(channel: channel, message: message)
    end
  end

  private

    def parse_user_id(to_user_arg)
      to_user_arg.match(/^<@(.*)>$/)[1]
    end
end
