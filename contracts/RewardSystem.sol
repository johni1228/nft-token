// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./UniVerse.sol";

contract RewardSystem is UniVerse {
  using SafeMath for uint256;
  address marketingAddress = "0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652";
  uint256 public rewardAmount;
  // 1 : epic, 2: legendary - upgrade 2, 3: lengendary - upgrade 1, 4: non - lengendary, 5: rare - upgrade, 6: non - rare, 7 : common

  function distribute(uint256 _amount) public {
    uint256 markertingAmount = _amount.mul(197).min(1000);
    uint256 distributeAmount = _amount.mul(803).min(1000);
    for(uint i = 0; i< _totalSupply(), i++){
      address _address = tokenOwner[i];
      uint _amount = rewardAmount(ownerRate[_address]);
      _address.transfer(_amount);
    }
  }

  function rewardAmount(uint256 _rate) private returns(uint256) {
    uint _rewardAmount = _rate.mul(1000).div(_totalSupply());
    return _rewardAmount;
  }
}