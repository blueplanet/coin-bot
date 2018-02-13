class EventsController < ActionController::API

  def create
    challenge = params[:challenge]

    case params[:type]
    when 'url_verification'
      render json: { challenge: params[:challenge] }
    end

    client = Ethereum::HttpClient.new("https://ropsten.infura.io/#{ENV['INFURA_TOKEN']}")
    key = Eth::Key.new(priv: ENV['ERC20_OWNER_PRIVATE_KEY'])
    abi = JSON.parse(File.open(Rails.root.join('config', 'abi', 'erc20_token.json')).read)
    contract = Ethereum::Contract.create(client: client, name: "ERC20Token", address: ENV['ERC20_ADDRESSES'], abi: abi)
    contract.key = key
    contract.transact.transfer('to_address', 5e18.to_i)
  end
end
