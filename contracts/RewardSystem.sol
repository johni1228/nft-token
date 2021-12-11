// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./UniVerse.sol";

contract RewardSystem is UniVerse {
  using SafeMath for uint256;

  mapping (address => uint256) internal rewardPerUser;

  address marketingAddress = owner();
  // 1 : epic, 2: legendary - upgrade 2, 3: lengendary - upgrade 1, 4: non - lengendary, 5: rare - upgrade, 6: non - rare, 7 : common
  function setMarketingAddress(address _address) external onlyOwner {
    marketingAddress = _address;
  }

  function distribute(uint256 _amount) internal view isEnableDistribute {
    uint256 markertingAmount = _amount.mul(197).min(1000);
    uint256 distributeAmount = _amount.mul(803).min(1000);
    uint256 basicRate = 5;
    for(uint i = 0; i< _totalSupply(), i++){
      address _address = tokenOwner[i];
      basicRate = ownerRate[_address];
      rewardPerUser[_address] =rewardPerUser[_address].add(rewardAmount(basicRate, distributeAmount));
    }
  }

  function rewardAmount(uint256 _rate, uint256 _amount) internal returns(uint256) {
    uint256 _rewardAmount = _rate.mul(10).mul(_amount).div(_totalSupply());  //_rate.mul(1000).div(100).div(_totalSupply())
    return _rewardAmount;
  }

  function upgradToken(address memory _address) external onlyOwner {
    require(ownerRate[_address] <= 8, "maximum upgrade");
    ownerRate[_address]++;
  }

  function rewardWithdraw() external returns (bool) {
    require(rewardPerUser[msg.sender] > 0, "Reward is very small");
    uint reward = rewardPerUser[msg.sender];
    msg.sender.Transfer(reward); // TODO: correctly using transfer function.
    rewardPerUser[msg.sender] = 0;
    return true;
  }

  function getRewardPerUser() external view returns (uint256){
    return rewardPerUser[msg.sender];
  }
}