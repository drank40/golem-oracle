//SPDX-License-Identifier: GPL3
pragma solidity ^0.8.10;

enum PromptState {
    Null,
    Pending,
    Requested,
    Answered
}

struct Prompt {
    address requester;
    string text;
    string answer;
    uint deadline;
    PromptState state;
}

library PromptLib {
    error notExists();
    error notAswered();
    error alreadyRequested();
    error alreadyAnswered();
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
        The server can use a Bloom filter to fetch every request event and aswer it accordingly
    */

    function request(Prompt memory prompt) public onlyAfter(prompt.deadline) returns(Prompt memory) {
        if(prompt.state == PromptState.Requested) {
            revert alreadyRequested();
        } else {
            emit Requested(prompt.requester);
            prompt.state = PromptState.Requested;
            return prompt;
        }
    }

    function setAnswer(Prompt memory prompt, string memory _answer) public pure returns(Prompt memory) {
        if(prompt.state == PromptState.Null) {
            revert notExists();
        }
        if(prompt.state == PromptState.Answered) {
            revert alreadyAnswered();
        }

        prompt.answer = _answer;
        prompt.state = PromptState.Answered;
        return prompt;
    }

    function getAnswer(Prompt memory prompt) public pure returns(string memory) {
        if(prompt.state == PromptState.Answered) {
            return prompt.answer;
        } else {
            if(prompt.state == PromptState.Null) {
                revert notExists();
            } else {
                revert notAswered();
            }
        }
    }
}
