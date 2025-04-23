// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EtherGame {
    uint256 public constant TARGET_AMOUNT = 7 ether;
    uint256 public balance;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "You can only send 1 Ether");

        balance += msg.value; // since we're using a seperate storage variable to track funded ether's not on address(this).balance (raw ether balance) we can prevent selfdestruct attack. Even if the contract receives unsolicited Ether (through selfdestruct or other unintended ways), the game still works as intended.
        require(balance <= TARGET_AMOUNT, "Game is over");

        if (balance == TARGET_AMOUNT) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "Not winner");
        uint256 amount = balance;
        balance = 0;
        (bool sent,) = msg.sender.call{value: amount}("");
        require(sent, "Failed to send Ether");
    }
}
