pragma solidity ^0.4.19;

import "./ERC800.sol";

contract TokenFactory is ERC800 {

    struct Token {
        string name;
        bytes32 tokenHash;
        bytes32 imageHash;
    }

    Token[] internal tokens;

    mapping (uint => address) public tokenOwner;
    mapping (address => uint) ownedTokensCount;
    mapping (uint => address) public originalOwner;

    // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    // which can be also obtained as `ERC721Receiver(0).onERC721Received.selector`
    bytes4 private constant ERC721_RECEIVED = 0x150b7a02;
    // Mapping from owner to number of owned token
    
    modifier onlyOwnerOf(uint _tokenId) {
        require(msg.sender == tokenOwner[_tokenId]);
        _;
    }

    function _createToken(string _name, bytes32 tokenHash, bytes32 imageHash) internal {
        require(msg.sender != address(0));

        uint _id = tokens.push(Token(_name, tokenHash, imageHash)) - 1;
        tokenOwner[_id] = msg.sender;
        originalOwner[_id] = msg.sender;
        ownedTokensCount[msg.sender]++;
        emit Transfer(address(0), msg.sender, _id);
    }

    function _generateRandomDna(address walletId, bytes32 imageHash, uint random_number) pure private returns (bytes32) {
        bytes32 tokenHash = keccak256(abi.encodePacked(walletId,imageHash,random_number));
        return tokenHash;
    }

    function createToken(string _name, bytes32 imageHash) public {
        address walletId = msg.sender;
        uint random_number = uint(blockhash(block.number-1))%100000 + 1;
        bytes32 tokenHash = _generateRandomDna(walletId, imageHash, random_number);
        _createToken(_name, tokenHash, imageHash);
    }

    function _burn(address _owner, uint256 _tokenId) internal {
        ownedTokensCount[msg.sender]--;
        tokenOwner[_tokenId] = address(0);
        originalOwner[_tokenId] = address(0);
        emit Transfer(_owner, address(0), _tokenId);
    }

}