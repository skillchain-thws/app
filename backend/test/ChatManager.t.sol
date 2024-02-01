// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ChatManager} from "../contracts/ChatManager.sol";
import {FreelancerMarketplace} from "../contracts/FreelancerMarketplace.sol";
import {EscrowManager} from "../contracts/EscrowManager.sol";
import {JobManager} from "../contracts/JobManager.sol";
import {UserManager} from "../contracts/UserManager.sol";
import {CommitteeManager} from "../contracts/CommitteeManager.sol";

contract ChatManagerTest is Test {
  ChatManager public chatManager;
  FreelancerMarketplace public freelancerMarketplace;
  EscrowManager public escrowManager;
  JobManager public jobManager;
  UserManager public userManager;
  CommitteeManager public committeeManager;

  address[2] public accounts;

  function setUp() public {
    accounts[0] = vm.addr(
      0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80
    );
    accounts[1] = vm.addr(
      0x59c6995e998f97a5a0044966f0945389dc9e86dae88c7a8412f4603b6b78690d
    );

    chatManager = new ChatManager(address(freelancerMarketplace));
    freelancerMarketplace = new FreelancerMarketplace();
    escrowManager = new EscrowManager(address(freelancerMarketplace));
    jobManager = new JobManager(address(freelancerMarketplace));
    userManager = new UserManager(address(freelancerMarketplace));
    committeeManager = new CommitteeManager(address(freelancerMarketplace));

    // Set Managers
    chatManager.setEscrowManager(address(escrowManager));
    chatManager.setJobManager(address(jobManager));
    chatManager.setUserManager(address(userManager));
    chatManager.setCommitteeManager(address(committeeManager));
  }

  // Unit tests:
  // ...
}
