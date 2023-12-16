//SPDX-License-Identifier: GPL3
pragma solidity ^0.8.13;

import "./Prompt.sol";
import "./Set.sol";

contract Golem {
    /*
    Map that links pools to their corresponding prompt
    */

    error Pending();

    using SetLib for Set;
    using PromptLib for Prompt;

    mapping(address => Prompt) prompts;
    Set oracles;
    address constant o1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant o2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    modifier onlyOut(address key) {
        if(prompts[key].exists) {
            revert Pending();
        } else {
            _;
        }
    }

    constructor() {
        oracles.add(o1);
        oracles.add(o2);
    }

    function newPrompt(address _requester, string memory _text, uint _deadline) public pure returns(Prompt memory) {
        return Prompt({
            requester : _requester,
            text : _text,
            answer : "",
            deadline : _deadline,
            executed : false,
            requested : false,
            exists : true
        });
    }

    function setupPrompt(address requester, string memory request, uint deadline) public onlyOut(requester) {
        prompts[requester] = newPrompt(requester, request, deadline);
    }
}
