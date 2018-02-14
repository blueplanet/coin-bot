class ReactionAddedJob < ApplicationJob
  queue_as :default

  COINS = 5

  def perform(team_id, api_app_id, user_id, channel)
    bot = Slack::Web::Client.new

    slack_user = SlackUser.find_by(
      team_id: team_id, 
      api_app_id: api_app_id, 
      user_id: user_id
    )

    if slack_user
      transaction = send_coin(slack_user.address)

      message = "<@#{user_id}> #{COINS} MOF 送金しましたよ〜\nhttps://ropsten.etherscan.io/tx/#{transaction.id}"

      bot.chat_postMessage(as_user: 'true', channel: channel, text: message)
    else
      bot.chat_postMessage(
        as_user: 'true',
        channel: channel,
        text: "アドレスはまだ登録されていません。\n`@bot register ADDRESS`を実行して登録しましょう！"
      )
    end

  end

  private

    def send_coin(address)
      client = Ethereum::HttpClient.new("https://ropsten.infura.io/#{ENV['INFURA_TOKEN']}")
      key = Eth::Key.new(priv: ENV['ERC20_OWNER_PRIVATE_KEY'])
      abi = JSON.parse(File.open(Rails.root.join('config', 'abi', 'erc20_token.json')).read)
      contract = Ethereum::Contract.create(client: client, name: "ERC20Token", address: ENV['ERC20_ADDRESSES'], abi: abi)
      contract.key = key

      contract.transact.transfer(address, COINS * 10**18)
    end
end
