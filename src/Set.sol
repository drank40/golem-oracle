//SPDX-License-Identifier: GPL3
pragma solidity ^0.8.10;


struct Set
{
    mapping(address => bool) inner;
}

library SetLib {
    
    function isIn(Set storage set, address key) public view returns(bool) {
        return set.inner[key];
    }

    function add(Set storage set, address key) public returns(bool) {
        set.inner[key] = true;
        return !isIn(set, key);
    }

    function remove(Set storage set, address key) public returns(bool) {
        set.inner[key] = false;
        return isIn(set, key);
    }
}
