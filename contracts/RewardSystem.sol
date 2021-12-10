// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./UniVerse.sol";

contract RewardSystem is UniVerse {
  using SafeMath for uint256;
  address marketingAddress = "0x8A1eAA7f43D44D06ac1b7677FD6B979538EBc652";
  // 1 : epic, 2: legendary - upgrade 2, 3: lengendary - upgrade 1, 4: non - lengendary, 5: rare - upgrade, 6: non - rare, 7 : common
  function setMarketingAddress(address _address) external onlyOwner {
    marketingAddress = _address;
  }

  function distribute(uint256 _amount) internal {
    uint256 markertingAmount = _amount.mul(197).min(1000);
    uint256 distributeAmount = _amount.mul(803).min(1000);
    uint256 basicRate = 5;
    for(uint i = 0; i< _totalSupply(), i++){
      address _address = tokenOwner[i];
      basicRate = ownerRate[_address];
      uint256 _amount = rewardAmount(basicRate);
      _address.transfer(_amount);
    }
  }

  function rewardAmount(uint256 _rate) internal returns(uint256) {
    uint256 _rewardAmount = _rate.mul(10).div(_totalSupply());  //_rate.mul(1000).div(100).div(_totalSupply())
    return _rewardAmount;
  }

  function upgradToken(address memory _address) external onlyOwner {
    require(ownerRate[_address] <= 8, "maximum upgrade");
    ownerRate[_address]++;
  }
}