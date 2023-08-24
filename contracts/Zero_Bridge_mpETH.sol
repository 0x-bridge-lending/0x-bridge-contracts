// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@aave/core-v3/contracts/interfaces/IPool.sol";

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Zero_Bridge {
    mapping(address => uint) public balances;
    uint256 public platformFee = 0;

     // Goerli
    address public tmpEth = 0xd9145CCE52D386f254917e481eB44e9943F39138; // test metapool token
    address metaPoolLP = 0x02947bD4aDc7F0f8a162B04c39D6965b1CD8c19C;
    address devFund;
   
    event Deposit(address indexed user, uint indexed amount);
    event WithdrawFunds(address indexed user, uint256 indexed amount);

    constructor(uint _platformFee, address _devFund) {
        platformFee = (100 * _platformFee)/ 1000000;
        devFund = _devFund;
    }

    function Deposit(uint amount) public  {
        // pay fee
        (bool payFeeSuccess) = IERC20(tmpEth).transferFrom(msg.sender, devFund, platformFee);
        if(payFeeSuccess) {
            IERC20(tmpEth).approve(metaPoolLP, (amount - platformFee));
            IPool(metaPoolLP).supply(tmpEth, (amount - platformFee), address(this), 0);
            balances[msg.sender] += (amount - platformFee);
            emit Deposit(msg.sender, amount);
        }
    }

    function WithdrawFunds( uint amount, address to) public onlyOwner{
        require(amount <= balances[to], 'Not enought balance');
        balances[to] -= amount;
        IPool(metaPoolLP).withdraw(tmpEth, amount, to);
        emit WithdrawFunds(to, amount);
    }
    
}