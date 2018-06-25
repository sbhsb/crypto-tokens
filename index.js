var Web3 = require('web3-quorum')
var web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:8545"));

var solc = require('solc')
var fs = require('fs')

var input = {
  'TokenFactory.sol': fs.readFileSync('TokenFactory.sol', 'utf8')
};

let compiledCode = solc.compile({sources: input}, 1);
console.log("VVVVVVVVVVVvv" , compiledCode)
var abiDefinition = JSON.parse(compiledCode.contracts['TokenFactory.sol:TokenFactory'].interface)
var TokenContract = web3.eth.contract(abiDefinition)

var byteCode = compiledCode.contracts['TokenFactory.sol:TokenFactory'].bytecode
////
var deployedContract = TokenContract.new({ data: '0x'+byteCode, from: web3.eth.accounts[web3.eth.accounts.length-1], gas: 4700000 },function(a,b){
    console.log(a,b)
    address=b.address;
    console.log('ADDRESS:: ',address);
  })
////


fs.writeFileSync("Token.json", JSON.stringify(deployedContract))

// var address = '0x82a8d775c8746cb1d701e1eb3aa84d3c6ecdfb0b'
// var ci = TokenContract.at(address)

// var events = ci.allEvents([]);

// // watch for changes
// events.watch(function (error, event) {
//   if (!error)
//     console.log("NAME ",event.event,"RESULT - ", event.args);
//   else {
//     console.log("ERROR:", error);
//   }
// });

// ci.createRandomToken("pikachu", "0xca35b7d915458ef540ade6068dfe2f44e8fa733c" , 
//   {
//     from: "0x4b3687c4e5BcD0E794B90bAd52e9fDe427F42fc2",
//     gas: 879873
//   },
//   function (a, b) {
//     console.log(a, b);
//   }
// )