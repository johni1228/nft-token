// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract RewardSystem {
  using SafeMath for uint256;

  mapping (address => uint256) internal rewardPerUser;

  address marketingAddress = owner();
  // 1 : epic, 2: legendary - upgrade 2, 3: lengendary - upgrade 1, 4: non - lengendary, 5: rare - upgrade, 6: non - rare, 7 : common
  function setMarketingAddress(address _address) external onlyOwner {
    marketingAddress = _address;
  }

  function rewardAmount(uint256 _rate, uint256 _amount) internal view returns(uint256) {
    uint256 _rewardAmount = _rate.mul(10).mul(_amount).div(1000);  //_rate.mul(1000).div(100).div(_totalSupply())
    return _rewardAmount;
  }

  function rewardWithdraw() external returns (bool) {
    require(rewardPerUser[msg.sender] > 0, "Reward is very small");
    uint256 reward = rewardPerUser[msg.sender];
    msg.sender.transfer(reward); // TODO: correctly using transfer function.
    rewardPerUser[msg.sender] = 0;
    return true;
  }

  function getRewardPerUser() external view returns (uint256){
    return rewardPerUser[msg.sender];
  }
}