pragma solidity ^0.4.19;

contract TokenFactory {

    event NewToken(uint tokenId, string name, bytes32 tokenHash);

    struct Token {
      string name;
      bytes32 tokenHash;
      bytes32 imageHash;
    }

    Token[] public tokens;

    mapping (uint => address) public tokenToOwner;
    mapping (address => uint) ownerTokenCount;
    
    modifier onlyOwnerOf(uint _tokenId) {
    require(msg.sender == tokenToOwner[_tokenId]);
    _;
  }

    function _createToken(string _name, bytes32 tokenHash, bytes32 imageHash) internal {
        uint id = tokens.push(Token(_name, tokenHash, imageHash)) - 1;
        tokenToOwner[id] = msg.sender;
        ownerTokenCount[msg.sender]++;
        emit NewToken(id, _name, tokenHash);
    }

    function _generateRandomDna(address walletId, bytes32 imageHash, uint random_number) private view returns (bytes32) {
        bytes32 tokenHash = keccak256(walletId,imageHash,random_number);
        return tokenHash;
    }

    function createRandomToken(string _name, bytes32 imageHash) public {
        address walletId = msg.sender;
        uint random_number = uint(blockhash(block.number-1))%10 + 1;
        bytes32 tokenHash = _generateRandomDna(walletId, imageHash, random_number);
        _createToken(_name, tokenHash, imageHash);
    }
    
    // function getBlockId() constant public returns(uint) {
    //     return (uint(blockhash(block.number-1)));
    // }

}