// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "@aave/core-v3/contracts/interfaces/IPool.sol";
import "@aave/periphery-v3/contracts/misc/WalletBalanceProvider.sol";
//import onlyOwner;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

contract Zero_Bridge {
    mapping(address => uint) public balances;
    uint256 public platformFee = 0;

     // Goerli
    address public stableToken = 0xcbE9771eD31e761b744D3cB9eF78A1f32DD99211; // GHO
    address aavePool = 0x02947bD4aDc7F0f8a162B04c39D6965b1CD8c19C;
    address payable aaveBalanceProvider = payable(0xBc790382B3686abffE4be14A030A96aC6154023a);
    address aaveToken = 0x625E7708f30cA75bfd92586e17077590C60eb4cD;
    address devFund;
   
    event Deposit(address indexed user, uint indexed amount);
    event WithdrawFunds(address indexed user, uint256 indexed amount);

    constructor(uint _platformFee, address _devFund) {
        platformFee = (100 * _platformFee)/ 1000000;
        devFund = _devFund;
    }

    function Deposit(uint amount) public  {
        // pay fee
        (bool payFeeSuccess) = IERC20(stableToken).transferFrom(msg.sender, devFund, platformFee);
        if(payFeeSuccess) {
            IERC20(stableToken).approve(aavePool, (amount - platformFee));
            IPool(aavePool).supply(stableToken, (amount - platformFee), address(this), 0);
            balances[msg.sender] += (amount - platformFee);
            emit Deposit(msg.sender, amount);
        }
    }

    function WithdrawFunds( uint amount, address to) public onlyOwner{
        require(amount <= balances[to], 'Not enought balance');
        balances[to] -= amount;
        IPool(aavePool).withdraw(stableToken, amount, to);
        emit WithdrawFunds(to, amount);
    }

    
}
