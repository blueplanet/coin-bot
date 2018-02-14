class EventsController < ActionController::API

  def create
    challenge = params[:challenge]

    case params[:event][:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    when 'reaction_added'
      coin = 5

      client = Ethereum::HttpClient.new("https://ropsten.infura.io/#{ENV['INFURA_TOKEN']}")
      key = Eth::Key.new(priv: ENV['ERC20_OWNER_PRIVATE_KEY'])
      abi = JSON.parse(File.open(Rails.root.join('config', 'abi', 'erc20_token.json')).read)
      contract = Ethereum::Contract.create(client: client, name: "ERC20Token", address: ENV['ERC20_ADDRESSES'], abi: abi)
      contract.key = key
      transaction = contract.transact.transfer('', coin * 10**18)

      message = "#{coin} MOF 頂きました〜\nhttps://ropsten.etherscan.io/tx/#{transaction.id}"

      bot = Slack::Web::Client.new
      bot.chat_postMessage(
        as_user: 'true',
        channel: params[:event][:item][:channel],
        text: message
      )

      head :ok
    end
  end
end
