//SPDX-License-Identifier: GPL3
pragma solidity ^0.8.13;

import "./Prompt.sol";
import "./Set.sol";

/*

TODO :

 - Add automatic on chain format checker -> move towards decentralization
 - Regex lib?
*/

contract Golem {
    /*
    Map that links pools to their corresponding prompt
    */

    error Pending();
    error NotOracle();
    error NegativeTimeDelta();

    using SetLib for Set;
    using PromptLib for Prompt;

    /*

        The lifecycle of a prompt is:

        Creation
        Request (after deadline)
        Fullfiled

    */

    mapping(address => Prompt) prompts;
    Set oracles;
    address constant o1 = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    address constant o2 = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;

    modifier onlyOut(address key) {
        if(prompts[key].state != PromptState.Null) {
            revert Pending();
        } else {
            _;
        }
    }

    modifier onlyOracle() {
        if(oracles.isIn(msg.sender)) {
            _;
        } else {
            revert NotOracle();
        }
    }

    constructor() {
        oracles.add(o1);
        oracles.add(o2);
    }

    function newPrompt(address _requester, string memory _text, uint _deadline) internal pure returns(Prompt memory)
    {
        return Prompt({
            requester : _requester,
            text : _text,
            answer : "",
            deadline : _deadline,
            state : PromptState.Pending
        });
    }

    function setupPrompt(address requester, string memory request, uint deadline) public onlyOut(requester)
    {
        if(deadline < block.timestamp) {
            revert NegativeTimeDelta();
        }

        prompts[requester] = newPrompt(requester, request, deadline);
    }

    function requestAnswer(address requester) public {
        prompts[requester] = prompts[requester].request();
    }

    function answer(address requester, string memory reply) public onlyOracle {
        prompts[requester] = prompts[requester].setAnswer(reply);
    }

    function getAnswer(address requester) public view returns(string memory) {
        return prompts[requester].getAnswer();
    }
}
