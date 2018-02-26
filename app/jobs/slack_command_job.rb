class SlackCommandJob < ApplicationJob
  queue_as :default

  def perform(team_id, user, channel, text)
    _, command, *command_args = text.split

    case command
    when 'send_to'
      # generate_transaction(user, command_args.first, command_args.second, command_args.third)
      # url = new_transaction_path(from: , to: , amount: )
      # message = "下記リンクをクリックし、Metamaskでサインしてください〜\n#{url}"

      SlackBot.instance.send_message(channel: channel, message: 'test')
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
end
