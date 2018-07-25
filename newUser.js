//0xaabcc0b41a53a329c57700acb23dd7d355ef64da

var Web3 = require('web3-quorum')
var web3 = new Web3(new Web3.providers.HttpProvider("http://13.126.36.79:22000"));
web3.personal.unlockAccount(web3.eth.accounts[web3.eth.accounts.length-1],'')
var acct = "0xaabcc0b41a53a329c57700acb23dd7d355ef64da"
var solc = require('solc')
var fs = require('fs')

var input = {
  'ERC800.sol': fs.readFileSync('ERC800.sol', 'utf8'),
  'TokenFactory.sol': fs.readFileSync('TokenFactory.sol', 'utf8'),
  'TokenOwnership.sol': fs.readFileSync('TokenOwnership.sol', 'utf8')
};

let compiledCode = solc.compile({sources: input}, 1);
// console.log("VVVVVVVVVVVvv" , compiledCode)
var abiDefinition = JSON.parse(compiledCode.contracts['TokenOwnership.sol:TokenOwnership'].interface)
var TokenContract = web3.eth.contract(abiDefinition)

var byteCode = compiledCode.contracts['TokenOwnership.sol:TokenOwnership'].bytecode

console.log(web3.eth.accounts)


//
/* var deployedContract = TokenContract.new({ data: '0x'+byteCode, from: web3.eth.accounts[web3.eth.accounts.length-1], gas: 4700000 },function(a,b){
    console.log(a,b)
    address=b.address;
    console.log('ADDRESS:: ',address);
  }) */
//

// fs.writeFileSync("Token.json", JSON.stringify(deployedContract))

var address = '0x48303f3459776976283538b18ea9988e75ead6d6'
var ci = TokenContract.at(address)

var events = ci.allEvents([]);

//watch for changes
events.watch(function (error, event) {
  if (!error)
    console.log("NAME ",event.event,"RESULT - ", event.args, 'tokenId - ', event.args.tokenId.toNumber());
  else {
    console.log("ERROR:", error);
  }
});