// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import {Golem} from "../src/Golem.sol";

contract CounterTest is Test {
    Golem public golem;

    function uintToAddr(uint n) internal pure returns(address) {
        return address(uint160(n));
    }

    address ONE;
    address TWO;
    address constant ORACLE = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    function setUp() public {
        vm.startPrank(TWO);
        golem = new Golem();
        ONE = uintToAddr(1);
        TWO = uintToAddr(2);
    }

    function testNewPrompt() public {
        changePrank(ONE);
        golem.setupPrompt(ONE, "Is the Earth flat?", block.timestamp + 10);
    }

    function testFailInvalidDeadline() public {
        changePrank(ONE);
        golem.setupPrompt(ONE, "Is time travel real?", block.timestamp - 10);
    }

    function testFailImpatient() public {
        changePrank(ONE);
        golem.setupPrompt(ONE, "Is the Earth flat?", block.timestamp + 10);
        //This fails because no time passed
        golem.requestAnswer(ONE);
    }

    function testRequest() public {
        changePrank(ONE);
        golem.setupPrompt(ONE, "Is the Earth flat?", block.timestamp + 10);
        //This fails because no time passed
        vm.warp(block.timestamp + 10);
        golem.requestAnswer(ONE);
    }

    function testFailNotAllowedToAnswer() public {
        changePrank(ONE);
        golem.setupPrompt(ONE, "Is the Earth flat?", block.timestamp + 10);
        //This fails because no time passed
        vm.warp(block.timestamp + 10);
        golem.requestAnswer(ONE);
        changePrank(TWO);
        golem.answer(ONE, "Of course");
    }

    function testAnswer() public {
        changePrank(ONE);
        golem.setupPrompt(ONE, "Is the Earth flat?", block.timestamp + 10);
        //This fails because no time passed
        vm.warp(block.timestamp + 10);
        golem.requestAnswer(ONE);
        changePrank(ORACLE);
        golem.answer(ONE, "No");
    }
}
