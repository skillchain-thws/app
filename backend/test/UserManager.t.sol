// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";

contract UserManagerTest is Test, ManagerSetup {
    function setUp() public {
        accounts[10] = 0xBcd4042DE499D14e55001CcbB24a551F3b954096;
    }

    function test_registerUser() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        (address _acc10, , , , ) = userManager.getUser(accounts[10]);
        assertEq(accounts[10], _acc10, "The address should be the same");
        assertEq(userManager.userCount(), 11, "UserCount should be 11");
    }

    function test_getUser() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        (, string memory name, , , ) = userManager.getUser(accounts[10]);
        assertEq(name, "Acc10", "User name should match");
    }

    function test_getAllUserAddresses() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        address[] memory allAddresses = userManager.getAllUserAddresses();
        assertEq(
            allAddresses.length,
            11,
            "All user addresses should be returned"
        );
    }

    function test_addJobId() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.addJobId(1, accounts[10]);
        uint[] memory jobIds = userManager.getAllJobIds(accounts[10]);
        assertEq(jobIds.length, 1, "Job ID should be added");
    }

    function test_removeJobId() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.addJobId(1, accounts[10]);
        userManager.removeJobId(1, accounts[10]);
        uint256[] memory jobIds = userManager.getAllJobIds(accounts[10]);
        assertEq(jobIds.length, 0, "Job ID should be removed");
    }

    function test_setJudge() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.setJudge(accounts[10]);
        (, , bool isJudge, , ) = userManager.getUser(accounts[10]);
        assertTrue(isJudge, "User should be set as judge");
    }

    function test_unsetJudge() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.setJudge(accounts[10]);
        userManager.unsetJudge(accounts[10]);
        (, , bool isJudge, , ) = userManager.getUser(accounts[10]);
        assertFalse(isJudge, "User should be unset as judge");
    }
}
