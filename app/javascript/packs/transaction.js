window.addEventListener('load', function() {
  if (typeof web3 !== 'undefined') {
    web3.version.getNetwork((err, netId) => {
      if (netId !== "3") {
        alert('現在 MOF コインは Ropsten で稼働しているので、MetaMaskで Ropsten ネットワークを選択してください。');
        location.href = '/';
      }
    });

    let defaultAccount = web3.eth.accounts[0];
    if (typeof defaultAccount !== 'undefined') {
      console.log('Use account: [' + defaultAccount + ']');
    } else {
      alert('MetaMask をアンロックしてください。')
      return;
    }

    form = document.getElementById("transaction-form");
    form.addEventListener('submit', function(e) {
      e.preventDefault();
      
      web3.
    });
  } else {
    alert('MetaMask をインストールしてください');

    location.href = '/';
  }
});
