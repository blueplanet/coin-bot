class EventsController < ActionController::API

  def create
    challenge = params[:challenge]

    case params[:event][:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    when 'reaction_added'
      bot = Slack::Web::Client.new
      slack_user = SlackUser.find_by(
        team_id: params[:team_id], 
        api_app_id: params[:api_app_id], 
        user_id: params[:event][:item_user]
      )

      if slack_user
        coin = 5

        client = Ethereum::HttpClient.new("https://ropsten.infura.io/#{ENV['INFURA_TOKEN']}")
        key = Eth::Key.new(priv: ENV['ERC20_OWNER_PRIVATE_KEY'])
        abi = JSON.parse(File.open(Rails.root.join('config', 'abi', 'erc20_token.json')).read)
        contract = Ethereum::Contract.create(client: client, name: "ERC20Token", address: ENV['ERC20_ADDRESSES'], abi: abi)
        contract.key = key

        transaction = contract.transact.transfer(slack_user.address, coin * 10**18)

        message = "#{coin} MOF 頂きました〜\nhttps://ropsten.etherscan.io/tx/#{transaction.id}"

        bot.chat_postMessage(
          as_user: 'true',
          channel: params[:event][:item][:channel],
          text: message
        )
      else
        bot.chat_postMessage(
          as_user: 'true',
          channel: params[:event][:item][:channel],
          text: "アドレスはまだ登録されていません。\n`@bot register ADDRESS`を実行して登録しましょう！"
        )
      end

      head :ok
    else
      head :ok
    end
  end
end
