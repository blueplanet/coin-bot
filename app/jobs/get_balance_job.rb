class GetBalanceJob < ApplicationJob
  queue_as :default

  def perform(team_id, user_id, channel)
    slack_user = SlackUser.find_by(team_id: team_id, user_id: user_id)
    bot = Slack::Web::Client.new

    if slack_user
      balance = get_balance(slack_user.address)
      message = "<@#{user_id}> 残高は #{number_to_delimited balance} MOF です〜"
    else
      message = "<@#{user_id}> アドレスはまだ登録されてないようです〜\n/register ADDRESSで登録しましょう！"
    end

    bot.chat_postMessage(as_user: 'true', channel: channel, text: message)
  end

  private

    def get_balance(address)
      client = Ethereum::HttpClient.new("https://ropsten.infura.io/#{ENV['INFURA_TOKEN']}")
      key = Eth::Key.new(priv: ENV['ERC20_OWNER_PRIVATE_KEY'])
      abi = JSON.parse(File.open(Rails.root.join('config', 'abi', 'erc20_token.json')).read)
      contract = Ethereum::Contract.create(client: client, name: "ERC20Token", address: ENV['ERC20_ADDRESSES'], abi: abi)
      contract.sender = key.address

      contract.call.balance_of(address) / 10**18
    end
end
