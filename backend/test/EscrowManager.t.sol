// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {EscrowManager} from "../contracts/EscrowManager.sol";

contract EscrowManagerTest is Test, ManagerSetup {
  // Test for the create Escrow function
  // The Escrow is already getting created in the ManagerSetup
  function test_createEscrow() public {
    EscrowManager.SimplifiedEscrow memory newEscrow = escrowManager
      .getSimplifiedEscrow(0);
    assertEq(newEscrow.price, 3, "Escrow was not added correctly");
    assertEq(newEscrow.buyer, accounts[2], "Escrow was not added correctly");
  }

  // Test for the sending of a Request
  // The Request is already being sent in the MangagerSetup
  function test_sendRequest() public {
    EscrowManager.Request memory newRequest = escrowManager.getCurrentRequest(
      0
    );
    assertEq(
      uint(newRequest.status),
      uint(EscrowManager.RequestStatus.Pending),
      "Request was not sent correctly"
    );
  }

  // Test for the acceptance of a Request
  // The Request is already being sent in the MangagerSetup
  function test_acceptRequest() public {
    vm.prank(accounts[1]);
    escrowManager.respondToRequest(0, true);

    EscrowManager.Request memory newRequest = escrowManager.getCurrentRequest(
      0
    );
    assertEq(
      uint(newRequest.status),
      uint(EscrowManager.RequestStatus.Accepted),
      "Request was not sent correctly"
    );
  }

  // Test for ending the Escrow
  function test_escrowAcceptedDone() public {
    vm.prank(accounts[1]);
    escrowManager.respondToRequest(0, true);

    EscrowManager.SimplifiedEscrow memory newEscrow = escrowManager
      .getSimplifiedEscrow(0);
    assertEq(newEscrow.isDone, true, "Escrow was not ended correctly");
  }

  // Test for updating the Escrow
  function test_updateEscrow() public {
    vm.prank(accounts[1]);
    uint newMoney = 1;
    escrowManager.updateEscrow(0, newMoney, true);

    EscrowManager.SimplifiedEscrow memory newEscrow = escrowManager
      .getSimplifiedEscrow(0);
    assertEq(newEscrow.money, 0, "Escrow was not updated correctly");
  }
}
