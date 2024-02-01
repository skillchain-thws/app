// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {UserManager} from "../contracts/UserManager.sol";
import {FreelancerMarketplace} from "../contracts/FreelancerMarketplace.sol";
import {CommitteeManager} from "../contracts/CommitteeManager.sol";

contract UserManagerTest is Test {
  UserManager public userManager;
  FreelancerMarketplace public freelancerMarketplace;
  CommitteeManager public committeeManager;

  address[2] public accounts;

  function setUp() public {
    accounts[0] = vm.addr(
      0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    );
    accounts[1] = vm.addr(
      0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
    );
    freelancerMarketplace = new FreelancerMarketplace();
    userManager = new UserManager(address(freelancerMarketplace));
    committeeManager = new CommitteeManager(address(freelancerMarketplace));
    userManager.setCommitteeManager(address(committeeManager));
  }

  function test_registerUser() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    (address _acc1, , , , ) = userManager.getUser(accounts[0]);
    assertEq(accounts[0], _acc1, "The address should be the same");
    assertEq(userManager.userCount(), 1, "UserCount should be 1");
  }

  function test_getUser() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    (, string memory name, , , ) = userManager.getUser(accounts[0]);
    assertEq(name, "Acc1", "User name should match");
  }

  function test_getAllUserAddresses() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    address[] memory allAddresses = userManager.getAllUserAddresses();
    assertEq(allAddresses.length, 1, "All user addresses should be returned");
  }

  function test_addJobId() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    userManager.addJobId(1, accounts[0]);
    uint[] memory jobIds = userManager.getAllJobIds(accounts[0]);
    assertEq(jobIds.length, 1, "Job ID should be added");
  }

  function test_removeJobId() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    userManager.addJobId(1, accounts[0]);
    userManager.removeJobId(1, accounts[0]);
    uint256[] memory jobIds = userManager.getAllJobIds(accounts[0]);
    assertEq(jobIds.length, 0, "Job ID should be removed");
  }

  function test_setJudge() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    userManager.setJudge(accounts[0]);
    (, , bool isJudge, , ) = userManager.getUser(accounts[0]);
    assertTrue(isJudge, "User should be set as judge");
  }

  function test_unsetJudge() public {
    vm.prank(accounts[0]);
    userManager.registerUser("Acc1");
    userManager.setJudge(accounts[0]);
    userManager.unsetJudge(accounts[0]);
    (, , bool isJudge, , ) = userManager.getUser(accounts[0]);
    assertFalse(isJudge, "User should be unset as judge");
  }
}
