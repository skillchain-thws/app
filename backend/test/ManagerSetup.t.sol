// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "../lib/forge-std/src/Test.sol";

import {FreelancerMarketplace} from "../contracts/FreelancerMarketplace.sol";
import {EscrowManager} from "../contracts/EscrowManager.sol";
import {JobManager} from "../contracts/JobManager.sol";
import {UserManager} from "../contracts/UserManager.sol";
import {CommitteeManager} from "../contracts/CommitteeManager.sol";
import {ChatManager} from "../contracts/ChatManager.sol";
import {ReviewManager} from "../contracts/ReviewManager.sol";

contract ManagerSetup is Test {
  FreelancerMarketplace public freelancerMarketplace;
  EscrowManager public escrowManager;
  JobManager public jobManager;
  UserManager public userManager;
  CommitteeManager public committeeManager;
  ChatManager public chatManager;
  ReviewManager public reviewManager;

  address[20] public accounts;

  constructor() {
    accounts[0] = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
    accounts[1] = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
    accounts[2] = 0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC;
    accounts[3] = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;
    accounts[4] = 0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65;
    accounts[5] = 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc;
    accounts[6] = 0x976EA74026E726554dB657fA54763abd0C3a0aa9;
    accounts[7] = 0x14dC79964da2C08b23698B3D3cc7Ca32193d9955;
    accounts[8] = 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f;
    accounts[9] = 0xa0Ee7A142d267C1f36714E4a8F75612F20a79720;

    vm.startPrank(accounts[0]);
    freelancerMarketplace = new FreelancerMarketplace();
    escrowManager = new EscrowManager(address(freelancerMarketplace));
    jobManager = new JobManager(address(freelancerMarketplace));
    userManager = new UserManager(address(freelancerMarketplace));
    committeeManager = new CommitteeManager(address(freelancerMarketplace));
    chatManager = new ChatManager(address(freelancerMarketplace));
    reviewManager = new ReviewManager(address(freelancerMarketplace));

    // Set Managers
    reviewManager.setEscrowManager(address(escrowManager));
    reviewManager.setJobManager(address(jobManager));
    reviewManager.setUserManager(address(userManager));

    jobManager.setEscrowManager(address(escrowManager));
    jobManager.setUserManager(address(userManager));

    chatManager.setEscrowManager(address(escrowManager));
    chatManager.setJobManager(address(jobManager));
    chatManager.setUserManager(address(userManager));
    chatManager.setCommitteeManager(address(committeeManager));

    userManager.setCommitteeManager(address(committeeManager));

    escrowManager.setJobManager(address(jobManager));
    escrowManager.setUserManager(address(userManager));
    escrowManager.setCommitteeManager(address(committeeManager));
    escrowManager.setChatManager(address(chatManager));

    committeeManager.setEscrowManager(address(escrowManager));
    committeeManager.setUserManager(address(userManager));
    vm.stopPrank();

    // Register user and add funds (100 ether each)
    // Account admin
    vm.prank(accounts[0]);
    userManager.registerUser("admin");
    vm.deal(accounts[0], 100 ether);
    // Account 1
    vm.prank(accounts[1]);
    userManager.registerUser("Acc1");
    vm.deal(accounts[1], 100 ether);
    // Account 2
    vm.prank(accounts[2]);
    userManager.registerUser("Acc2");
    vm.deal(accounts[2], 100 ether);
    // Account 3
    vm.prank(accounts[3]);
    userManager.registerUser("Acc3");
    vm.deal(accounts[3], 100 ether);
    // Account 4
    vm.prank(accounts[4]);
    userManager.registerUser("Acc4");
    vm.deal(accounts[4], 100 ether);
    // Account 5
    vm.prank(accounts[5]);
    userManager.registerUser("Acc5");
    vm.deal(accounts[5], 100 ether);
    // Account 6
    vm.prank(accounts[6]);
    userManager.registerUser("Acc6");
    vm.deal(accounts[6], 100 ether);
    // Account 7
    vm.prank(accounts[7]);
    userManager.registerUser("Acc7");
    vm.deal(accounts[7], 100 ether);
    // Account 8
    vm.prank(accounts[8]);
    userManager.registerUser("Acc8");
    vm.deal(accounts[8], 100 ether);
    // Account 9
    vm.prank(accounts[9]);
    userManager.registerUser("Acc9");
    vm.deal(accounts[9], 100 ether);

    // Create initial demo jobs
    // Create a Job
    string[] memory tags = new string[](2);
    tags[0] = "tag1";
    tags[1] = "tag2";
    vm.prank(accounts[1]);
    jobManager.addJob("test job", "test description", 3, tags);

    // Create second Job
    vm.prank(accounts[3]);
    jobManager.addJob("second test job", "second test description", 5, tags);

    // Send Buy Request
    vm.prank(accounts[2]);
    jobManager.sendBuyRequest(0, "I want this");

    // Accept Buy Request
    vm.prank(accounts[1]);
    jobManager.acceptBuyRequest(0, 0);

    // Send Escrow Start Request
    vm.prank(accounts[2]);
    escrowManager.sendRequest{value: 3}(0);
  }
}
