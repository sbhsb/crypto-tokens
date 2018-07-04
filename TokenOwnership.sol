pragma solidity ^0.4.19;

import "./TokenFactory.sol";

contract TokenOwnership is TokenFactory {

  // mapping (uint => address) tokenApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerTokenCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return tokenToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private onlyOwnerOf(_tokenId){
    ownerTokenCount[_to]++;
    ownerTokenCount[msg.sender]--;
    tokenToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

  function transfer(address _to, uint256 _tokenId) public {
    _transfer(msg.sender, _to, _tokenId);
  }

  // function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
  //   tokenApprovals[_tokenId] = _to;
  //   // emit Approval(msg.sender, _to, _tokenId);
  // }

  // function takeOwnership(uint256 _tokenId) public {
  //   require(tokenApprovals[_tokenId] == msg.sender);
  //   address owner = ownerOf(_tokenId);
  //   _transfer(owner, msg.sender, _tokenId);
  // }
}
