const Eth = require('ethjs');
const unit = require('ethjs-unit');
const eth = new Eth(new Eth.HttpProvider('https://ropsten.infura.io'));
const erc20ABI = [{ "constant": true, "inputs": [], "name": "name", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_spender", "type": "address" }, { "name": "_value", "type": "uint256" } ], "name": "approve", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "totalSupply", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_from", "type": "address" }, { "name": "_to", "type": "address" }, { "name": "_value", "type": "uint256" } ], "name": "transferFrom", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [], "name": "decimals", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_spender", "type": "address" }, { "name": "_subtractedValue", "type": "uint256" } ], "name": "decreaseApproval", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "_owner", "type": "address" } ], "name": "balanceOf", "outputs": [ { "name": "balance", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": true, "inputs": [], "name": "symbol", "outputs": [ { "name": "", "type": "string" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "constant": false, "inputs": [ { "name": "_to", "type": "address" }, { "name": "_value", "type": "uint256" } ], "name": "transfer", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": false, "inputs": [ { "name": "_spender", "type": "address" }, { "name": "_addedValue", "type": "uint256" } ], "name": "increaseApproval", "outputs": [ { "name": "", "type": "bool" } ], "payable": false, "stateMutability": "nonpayable", "type": "function" }, { "constant": true, "inputs": [ { "name": "_owner", "type": "address" }, { "name": "_spender", "type": "address" } ], "name": "allowance", "outputs": [ { "name": "", "type": "uint256" } ], "payable": false, "stateMutability": "view", "type": "function" }, { "inputs": [ { "name": "initialSupply", "type": "uint256" } ], "payable": false, "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "owner", "type": "address" }, { "indexed": true, "name": "spender", "type": "address" }, { "indexed": false, "name": "value", "type": "uint256" } ], "name": "Approval", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": true, "name": "from", "type": "address" }, { "indexed": true, "name": "to", "type": "address" }, { "indexed": false, "name": "value", "type": "uint256" } ], "name": "Transfer", "type": "event" } ];
const mofCoinAddress = '0x93F42602d8448d81E426FB2C38369179790c3E4A';

window.addEventListener('load', () => {
  if (typeof window.web3 !== 'undefined' && typeof window.web3.currentProvider !== 'undefined') {
    eth.setProvider(window.web3.currentProvider);
    window.eth = eth;

    const token = eth.contract(erc20ABI).at(mofCoinAddress);

    eth.accounts().then((accounts) => {
      if (accounts.length == 0) {
        alert('MetaMaskをアンロックしてください');
        return;
      }
    });

    const submitButton = el('#submit');
    submitButton.addEventListener('click', (e) => {
      e.preventDefault();

      token.transfer(el('#to-address').dataset.address, el('#amount').value * 1e18, { from: el('#from-address').dataset.address })
      .then(function(transferTxHash) {
        el('#transfer-response').innerHTML = String(transferTxHash);
      })
      .catch(function(transferError) {
        el('#transfer-response').innerHTML = '送信エラー: ' + String(transferError);
      });
    });

    let accountInterval = setInterval(function() {
      window.eth.accounts().then((accounts) => {
        if (accounts[0] !== window.eth.defaultAccount) {
          window.eth.defaultAccount = web3.eth.accounts[0];
          displayAccount(token);
        }
      });
    }, 100);

  } else {
    alert('MetaMask をインストールしてください');

    location.href = '/';
  }
});

const el = function(id){ return document.querySelector(id); };
const displayAccount = function(token) {
  el('#from-address').dataset.address = eth.defaultAccount;

  token.balanceOf(eth.defaultAccount).then((balance) => {
    let balanceInt = unit.fromWei(balance[0], 'ether');
    el('#balance').textContent = balanceInt;

    if (balanceInt > parseInt(el('#amount').value)) {
      el('#submit').classList.remove('disabled');
    } else {
      el('#submit').classList.add('disabled');
    }
  });
}
