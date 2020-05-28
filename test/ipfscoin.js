const IpfsCoin = artifacts.require("IpfsCoin");

contract('IpfsCoin', (accounts) => {
  it('should put 10000 IpfsCoin in the first account', async () => {
    const ipfsCoinInstance = await IpfsCoin.deployed();
    const balance = await ipfsCoinInstance.getBalance.call(accounts[0]);

    assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
  });
  it('should call a function that depends on a linked library', async () => {
    const ipfsCoinInstance = await IpfsCoin.deployed();
    const ipfsCoinBalance = (await ipfsCoinInstance.getBalance.call(accounts[0])).toNumber();
    const ipfsCoinEthBalance = (await ipfsCoinInstance.getBalanceInEth.call(accounts[0])).toNumber();

    assert.equal(ipfsCoinEthBalance, 2 * ipfsCoinBalance, 'Library function returned unexpected function, linkage may be broken');
  });
  it('should send coin correctly', async () => {
    const ipfsCoinInstance = await IpfsCoin.deployed();

    // Setup 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = (await ipfsCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoStartingBalance = (await ipfsCoinInstance.getBalance.call(accountTwo)).toNumber();

    // Make transaction from first account to second.
    const amount = 10;
    await ipfsCoinInstance.sendCoin(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = (await ipfsCoinInstance.getBalance.call(accountOne)).toNumber();
    const accountTwoEndingBalance = (await ipfsCoinInstance.getBalance.call(accountTwo)).toNumber();


    assert.equal(accountOneEndingBalance, accountOneStartingBalance - amount, "Amount wasn't correctly taken from the sender");
    assert.equal(accountTwoEndingBalance, accountTwoStartingBalance + amount, "Amount wasn't correctly sent to the receiver");
  });
});
