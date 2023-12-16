//SPDX-License-Identifier: GPL3
pragma solidity ^0.8.10;

struct Prompt {
    address requester;
    string text;
    string answer;
    uint deadline;
    bool requested;
    bool executed;
    bool exists;
}

library PromptLib {
    error notExists();
    error notAswered();
    error alreadyRequested();
    error invalidTime();
    
    event Requested(address requester);

    modifier onlyAfter(uint timestamp) {
        if(block.timestamp >= timestamp) {
            _;
        } else {
            revert invalidTime();
        }
    }


    /*
        The server can use a Bloom filter to fetch every request and aswer it accordingly
    */

    function request(Prompt memory prompt) public onlyAfter(prompt.deadline) returns(Prompt memory) {
        if(prompt.requested) {
            revert alreadyRequested();
        } else {
            emit Requested(prompt.requester);
            prompt.requested = true;
            return prompt;
        }
    }

    function setAnswer(Prompt memory prompt, string memory _answer) public pure returns(Prompt memory) {
        prompt.answer = _answer;
        prompt.executed = true;
        return prompt;
    }

    function getAnswer(Prompt memory prompt) public pure returns(string memory) {
        if(prompt.executed) {
            return prompt.answer;
        } else {
            if(prompt.exists) {
                revert notAswered();
            } else {
                revert notExists();
            }
        }
    }
}
