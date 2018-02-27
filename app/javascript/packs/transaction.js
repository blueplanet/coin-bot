window.addEventListener('load', function() {
  if (typeof web3 !== 'undefined') {
    // Use Mist/MetaMask's provider
    web3js = new Web3(web3.currentProvider);

    web3.version.getNetwork((err, netId) => {
      switch (netId) {
        case "3":
          console.log('This is the ropsten test network.')
          break
        default:
          alert('現在 MOF コインは Ropsten で稼働しているので、MetaMaskで Ropsten ネットワークを選択してください。');
          location.href = '/';
      }
    })
  } else {
    alert('MetaMask をインストールしてください');

    location.href = '/';
  }

});
