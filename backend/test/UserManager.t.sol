// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {UserManager} from "../contracts/UserManager.sol";

contract UserManagerTest is Test, ManagerSetup {
    function setUp() public {
        // Set up additional accounts for testing
        accounts[10] = 0xBcd4042DE499D14e55001CcbB24a551F3b954096;
        accounts[11] = 0x71bE63f3384f5fb98995898A86B02Fb2426c5788;
    }

    // Test registering a user
    function test_registerUser() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        (address _acc10, , , , ) = userManager.getUser(accounts[10]);
        assertEq(accounts[10], _acc10, "The address should be the same");
        assertEq(userManager.userCount(), 11, "UserCount should be 11");
    }

    // Test getting user details
    function test_getUser() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        (, string memory name, , , ) = userManager.getUser(accounts[10]);
        assertEq(name, "Acc10", "User name should match");
    }

    // Test getting all user addresses
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

    // Test adding a job ID to a user
    function test_addJobId() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.addJobId(1, accounts[10]);
        uint[] memory jobIds = userManager.getAllJobIds(accounts[10]);
        assertEq(jobIds.length, 1, "Job ID should be added");
    }

    // Test removing a job ID from a user
    function test_removeJobId() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.addJobId(1, accounts[10]);
        userManager.removeJobId(1, accounts[10]);
        uint256[] memory jobIds = userManager.getAllJobIds(accounts[10]);
        assertEq(jobIds.length, 0, "Job ID should be removed");
    }

    // Test setting a user as a judge
    function test_setJudge() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        (, , bool isJudge, , ) = userManager.getUser(accounts[10]);
        assertTrue(isJudge, "User should be set as judge");
    }

    // Test unsetting a user as a judge
    function test_unsetJudge() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.unsetJudge(accounts[10]);
        (, , bool isJudge, , ) = userManager.getUser(accounts[10]);
        assertFalse(isJudge, "User should be unset as judge");
    }

    // Test attempting to register a user with an existing address
    function test_registerUserWithExistingAddress() public {
        userManager.registerUser("Acc11");
        vm.expectRevert("User already registered");
        userManager.registerUser("Acc12"); // Attempt to register with existing address
    }

    // Test attempting to register a user with an existing name
    function test_registerUserWithExistingName() public {
        userManager.registerUser("Acc13");
        vm.expectRevert("Name is already taken");
        userManager.registerUser("Acc13"); // Attempt to register with existing name
    }

    // Test attempting to set a judge for an unregistered user
    function test_setJudgeForUnregisteredUser() public {
        vm.expectRevert("You are not registered and can't be a judge");
        userManager.setJudge(accounts[11]); // Attempt to set judge for unregistered user
    }

    // Test attempting to unset a judge for an unregistered user
    function test_unsetJudgeForUnregisteredUser() public {
        vm.expectRevert("You have not been a judge");
        userManager.unsetJudge(accounts[11]); // Attempt to unset judge for unregistered user
    }

    // Test attempting to set a judge twice
    function test_setJudgeTwice() public {
        vm.startPrank(accounts[10]);
        userManager.registerUser("Acc10");
        vm.expectRevert("You are already a judge");
        userManager.setJudge(accounts[10]); // Attempt to set judge twice
        vm.stopPrank();
    }

    // Test attempting to unset a judge without being a judge
    function test_unsetJudgeWithoutBeingJudge() public {
        vm.prank(accounts[10]);
        userManager.registerUser("Acc10");
        userManager.unsetJudge(accounts[10]);
        vm.expectRevert("You have not been a judge");
        userManager.unsetJudge(accounts[10]); // Attempt to unset judge without being a judge
    }
}
