// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol"; 

contract UniverseToken is ERC20, Ownable {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _totalSupply;
 
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;
 
    constructor() public {
        symbol = "UNIV";
        name = "UniverseToken";
        decimals = 18;
        _totalSupply = 100000000;
        balances[owner()] = _totalSupply;
        emit Transfer(address(0), owner(), _totalSupply);
    }
}