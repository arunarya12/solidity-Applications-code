// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract _Bank is ERC20 {
    constructor() ERC20("rewardtoken", "RRT") {}
    struct _staking {
        uint256 _amount;
        uint256 initialTimestamp;
    }
    mapping(address => _staking) public records;
    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
    function burn(address to, uint256 amount) external {
        _burn(to, amount);
    }
    function deposit(uint256 _amount) public {
        require(_amount > 0, "more than 0");
        require(msg.sender != address(0), "invalid");
        records[msg.sender]._amount += _amount;
        records[msg.sender].initialTimestamp = block.timestamp;
        IERC20(address(this)).transferFrom(msg.sender, address(this), _amount);
    }
    function withdrawamount(uint256 _amount) public {
        require(
            block.timestamp >= records[msg.sender].initialTimestamp + 1 seconds,
            "can withdraw amount"
        );
        records[msg.sender]._amount -= _amount;
        IERC20(address(this)).transfer(msg.sender, _amount);
        
    }
    function getreward() public returns (uint256) {
        uint256 periodoftime = block.timestamp -
        records[msg.sender].initialTimestamp;
        require(periodoftime >= 1 seconds, "can withdrawal");
        uint256 calculatedRewards = (records[msg.sender]._amount / 100) * 5;
        uint256 totalAmount = records[msg.sender]._amount + calculatedRewards;
        IERC20(address(this)).transfer(msg.sender, totalAmount);
        return calculatedRewards;
    }
}
