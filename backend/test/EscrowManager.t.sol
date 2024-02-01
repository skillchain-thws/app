// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {EscrowManager} from "../contracts/EscrowManager.sol";
import {FreelancerMarketplace} from "../contracts/FreelancerMarketplace.sol";
import {JobManager} from "../contracts/JobManager.sol";
import {UserManager} from "../contracts/UserManager.sol";
import {CommitteeManager} from "../contracts/CommitteeManager.sol";
import {ChatManager} from "../contracts/ChatManager.sol";

contract EscrowManagerTest is Test {
  EscrowManager public escrowManager;
  FreelancerMarketplace public freelancerMarketplace;
  JobManager public jobManager;
  UserManager public userManager;
  CommitteeManager public committeeManager;
  ChatManager public chatManager;

  address[2] public accounts;

  function setUp() public {
    accounts[0] = vm.addr(
      0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    );
    accounts[1] = vm.addr(
      0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
    );

    escrowManager = new EscrowManager(address(freelancerMarketplace));
    freelancerMarketplace = new FreelancerMarketplace();
    jobManager = new JobManager(address(freelancerMarketplace));
    userManager = new UserManager(address(freelancerMarketplace));
    committeeManager = new CommitteeManager(address(freelancerMarketplace));
    chatManager = new ChatManager(address(freelancerMarketplace));

    // Set Managers
    escrowManager.setJobManager(address(jobManager));
    escrowManager.setUserManager(address(userManager));
    escrowManager.setCommitteeManager(address(committeeManager));
    escrowManager.setChatManager(address(chatManager));
  }

  // Unit tests:
  // ...
}
