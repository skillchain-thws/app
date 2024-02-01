// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {JobManager} from "../contracts/JobManager.sol";
import {FreelancerMarketplace} from "../contracts/FreelancerMarketplace.sol";
import {EscrowManager} from "../contracts/EscrowManager.sol";
import {UserManager} from "../contracts/UserManager.sol";

contract JobManagerTest is Test {
  JobManager public jobManager;
  FreelancerMarketplace public freelancerMarketplace;
  EscrowManager public escrowManager;
  UserManager public userManager;

  address[2] public accounts;

  function setUp() public {
    accounts[0] = vm.addr(
      0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    );
    accounts[1] = vm.addr(
      0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
    );
    freelancerMarketplace = new FreelancerMarketplace();
    jobManager = new JobManager(address(freelancerMarketplace));
    userManager = new UserManager(address(freelancerMarketplace));
    escrowManager = new EscrowManager(address(freelancerMarketplace));
    // Set Managers
    jobManager.setEscrowManager(address(escrowManager));
    jobManager.setUserManager(address(userManager));
  }

  // Unit tests:
  // ...
}
