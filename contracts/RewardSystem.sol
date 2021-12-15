// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Token.sol";

contract RewardSystem is ERC20, Ownable{
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

  function getRewardPerUser() external view returns (uint256){
    return rewardPerUser[msg.sender];
  }
}