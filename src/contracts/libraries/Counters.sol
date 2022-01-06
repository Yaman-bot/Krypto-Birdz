// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SafeMath.sol";

library Counters {
    using SafeMath for uint256;

    // build our own variable type with the keyword 'struct'
    struct Counter {
        uint256 _value;
    }

    //find the current value of a count
    function current(Counter storage counter) internal view returns (uint256) {
        return counter._value;
    }

    //funtion that always increments by 1
    function increment(Counter storage counter) internal {
        counter._value = counter._value.add(1);
    }

    //function that always decrement by 1
    function decrement(Counter storage counter) internal {
        counter._value = counter._value.sub(1);
    }
}
