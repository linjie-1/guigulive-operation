pragma solidity ^0.4.16;

import './SafeMath.sol';

contract Test {
    using SafeMath for uint8;
    
    uint8 public a = 1;
    
    function test () {
        uint8 b = SafeMath.sub(a, 100);
        uint8 c = a.sub(100);
    }
}
