// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './UniVerse.sol'

contract RewardSystem is UniVerse {

  uint256 public rewardAmount;

  constructor(uint _amount) {
    rewardAmount = _amount;
  }

  
}