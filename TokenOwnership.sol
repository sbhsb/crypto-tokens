pragma solidity ^0.4.19;

import "./TokenFactory.sol";

contract TokenOwnership is TokenFactory {
    
    function() payable {
        
    }

    uint price;
   mapping (uint => address) tokenApprovals;

  function balanceOf(address _owner) public view returns (uint256 _balance) {
    return ownerTokenCount[_owner];
  }

  function ownerOf(uint256 _tokenId) public view returns (address _owner) {
    return tokenToOwner[_tokenId];
  }

  function _transfer(address _from, address _to, uint256 _tokenId) private {
    ownerTokenCount[_to]++;
    ownerTokenCount[msg.sender]--;
    tokenToOwner[_tokenId] = _to;
    emit Transfer(_from, _to, _tokenId);
  }

//   function transfer(address _to, uint256 _tokenId, uint price) public {
//     _transfer(msg.sender, _to, _tokenId, price);
//   }

   function approve(address _to, uint256 _tokenId, uint pricep) public payable onlyOwnerOf(_tokenId) {
     tokenApprovals[_tokenId] = _to;
     price  = pricep;
     emit Approval(msg.sender, _to, _tokenId);
   }

   function takeOwnership(uint256 _tokenId) public payable {
     require(tokenApprovals[_tokenId] == msg.sender);
     address owner = ownerOf(_tokenId);
     _transfer(owner, msg.sender, _tokenId);
     owner.transfer(price);
   }
}
