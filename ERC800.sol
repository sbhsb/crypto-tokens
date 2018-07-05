pragma solidity ^0.4.19;

contract ERC800 {
    // Required methods
    // function totalSupply() public view returns (uint256 total);
    function balanceOf(address _owner) public view returns (uint256 balance);
    function ownerOf(uint256 _tokenId) public view returns (address owner);
    function approve(address _to, uint256 _tokenId, uint price) public payable;
    // function transfer(address _to, uint256 _tokenId, uint price) public;
    function takeOwnership(uint256 _tokenId) public payable;
    // function transferFrom(address _from, address _to, uint256 _tokenId) public;
    function createToken(string _name, bytes32 imageHash) public;

    // Events
    event Transfer(address from, address to, uint256 tokenId);
    event NewToken(uint tokenId, string name, bytes32 tokenHash);
    event Approval(address owner, address approved, uint256 tokenId);

    // Optional
    // function name() public view returns (string name);
    // function symbol() public view returns (string symbol);
    // function tokensOfOwner(address _owner) external view returns (uint256[] tokenIds);
    // function tokenMetadata(uint256 _tokenId, string _preferredTransport) public view returns (string infoUrl);

    // ERC-165 Compatibility (https://github.com/ethereum/EIPs/issues/165)
    // function supportsInterface(bytes4 _interfaceID) public view returns (bool);
}
