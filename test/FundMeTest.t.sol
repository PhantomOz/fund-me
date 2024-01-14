// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDollarIsFive() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function testForVersion() public {
        uint256 version = fundMe.getVersion();
        assertEq(version, 4);
    }

    function testFunding() public {
        fundMe.fund{value: 5e18}();
        assertEq(fundMe.addressToAmountFunded(address(this)), 5e18);
    }

    function testFunders() public {
        fundMe.fund{value: 5e18}();
        address funder = fundMe.funders(0);
        console.log(funder);
        assertEq(funder, address(this));
    }

    function testNotOwner() public {
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdraw() public {
        fundMe.fund{value: 5e18}();
        vm.prank(fundMe.i_owner());
        fundMe.withdraw();
        assertEq(fundMe.addressToAmountFunded(address(this)), 0);
    }
}
