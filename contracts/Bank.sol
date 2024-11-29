// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/interfaces/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract Bank{
    mapping (address => uint) deposited;

    address public immutable token;

    constructor(address _token) {
        token = _token;
    }

    function myBalance() public view returns (uint balance) {
        balance = deposited[msg.sender]/(10**18);
    }
 
    function deposit(uint amount) public {
        amount = amount * 10 ** 18;
        require(IERC20(token).transferFrom(msg.sender, address(this), amount), "transfer error");
        deposited[msg.sender] += amount;
    }

    modifier requireBalance(uint amount){
        amount = amount * 10 ** 18;
        uint balance = deposited[msg.sender];
        require(amount <= balance, "not enough balance");
        _;
    }

    function withdraw(uint amount) external requireBalance(amount){
        amount = amount * 10 ** 18;
        SafeERC20.safeTransfer(IERC20(token), msg.sender, amount);
        deposited[msg.sender] -= amount;
    }

    function bankTransfer(address to, uint amount) public requireBalance(amount){
        amount = amount * 10 ** 18;
        SafeERC20.safeTransfer(IERC20(token), to, amount);
        deposited[to] += amount;
        deposited[msg.sender] -= amount;
    }
}