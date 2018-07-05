const Web3 = require('web3')
const solc = require('solc')
const fs = require('fs')

var web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));

var input = {
    'ERC800.sol': fs.readFileSync('ERC800.sol', 'utf8'),
    'TokenFactory.sol': fs.readFileSync('TokenFactory.sol', 'utf8'),
    'TokenOwnership.sol': fs.readFileSync('TokenOwnership.sol', 'utf8')
};

let compiledCode = solc.compile({ sources: input }, 1);
var abiDefinition = JSON.parse(compiledCode.contracts['TokenOwnership.sol:TokenOwnership'].interface)
var byteCode = compiledCode.contracts['TokenOwnership.sol:TokenOwnership'].bytecode;

(async function doer() {
    let address = ''
    let privateKey = ''
    console.log('started deploying')
    const accounts = await web3.eth.getAccounts()
    console.log('getAccounts', accounts)
    // web3.eth.getAccounts((err, result) => {
    //     console.log('cb getAccounts err', err)
    //     console.log('cb getAccounts result', result)
    // })

    if(accounts.length === 0) {
        console.log('Creating new account')
        const newAccount = web3.eth.accounts.create()
        address = newAccount.address
        privateKey = newAccount.privateKey
    } else {
        address = accounts[0]
    }
    console.log('Account Address: ', address)

    // const accountsX = await web3.eth.getAccounts()
    // console.log('getAccounts', accountsX)

    // return;
    // web3.personal.unlockAccount('0x' + address, '', 5000)

    web3.eth.sendTransaction({
        from: address,
        data:  '0x' + byteCode, // deploying a contracrt
    }, function(error, hash){
        console.log(error)
        if(!error) {
            console.log('XXXXXXXXXXXXXXXXXXXXXXX')
            console.log('hash', hash)
        }
    });

    return
    
    var TokenContract = new web3.eth.Contract(abiDefinition)

    TokenContract.deploy({
        data: '0x' + byteCode,
        from: address,
        gas: 150000,
        gasPrice: '300000'
    }, function (error, transactionHash) {
        console.log(error)
        if (transactionHash) {
            console.log('XXX transactionHash', transactionHash)
        }
    })
        .on('error', function (error) {
            console.log('error', error)
        })
        .on('transactionHash', function (transactionHash) {
            console.log('transactionHash', transactionHash)
        })
        .on('receipt', function (receipt) {
            console.log(receipt.contractAddress) // contains the new contract address
        })
        .on('confirmation', function (confirmationNumber, receipt) {
            console.log('confirmation', confirmationNumber)
        })
        .then(function (newContractInstance) {
            console.log(newContractInstance.options.address) // instance with the new contract address
        });
})().catch(console.error)