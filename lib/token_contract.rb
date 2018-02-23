require 'active_support'
require 'active_support/core_ext'
require 'singleton'

class TokenContract
  include Singleton

  delegate :call, :transact, to: :contract

  attr_reader :contract

  def initialize
    client = Ethereum::Client.create("https://ropsten.infura.io/#{ENV['INFURA_TOKEN']}")
    key = Eth::Key.new(priv: ENV['ERC20_OWNER_PRIVATE_KEY'])
    abi = JSON.parse(File.open(Rails.root.join('config', 'abi', 'erc20_token.json')).read)
    @contract = Ethereum::Contract.create(client: client, name: "ERC20Token", address: ENV['ERC20_ADDRESSES'], abi: abi)
    @contract.key = key
    @contract.sender = key.address
  end
end
