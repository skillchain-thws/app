// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {CommitteeManager} from "../contracts/CommitteeManager.sol";

contract CommitteeManagerTest is Test, ManagerSetup {
  function setUp() public {
    // Prank accounts to simulate setting up a committee review
    vm.prank(accounts[1]);
    committeeManager.openCommitteeReview(0, 1, "Test reason");

    // Get the required amount of committee members
    (, , , uint requiredCommitteeMembers, , , ) = committeeManager
      .getReviewRequestDetails(0);

    // Set committee members
    address[] memory committeeMemberArray = new address[](
      requiredCommitteeMembers
    );
    uint accountIndex = 3;
    uint remaining = requiredCommitteeMembers;
    for (uint i = 0; remaining > 0; i++) {
      committeeMemberArray[i] = accounts[accountIndex];
      accountIndex++;
      remaining--;
    }
    vm.prank(accounts[0]);
    committeeManager.setCommitteeMembers(0, committeeMemberArray);
  }

  // Test for opening a committee review
  function test_OpenCommitteeReview() public {
    // Retrieve the status of the review
    (, , , , , CommitteeManager.AcceptanceStatus status, ) = committeeManager
      .getReviewRequestDetails(0);
    assertEq(
      uint(status),
      uint(CommitteeManager.AcceptanceStatus.Pending),
      "Status should be Pending"
    );
  }

  // Test for voting on a review request
  function test_VoteReviewRequest() public {
    // Vote from one of the committee members
    vm.prank(accounts[3]);
    committeeManager.voteReviewRequest(0, true);

    // Check if the vote is recorded correctly
    (, CommitteeManager.MemberVote[] memory votes) = committeeManager
      .getCommitteeVotes(0);
    assertEq(
      uint(votes[0]),
      uint(CommitteeManager.MemberVote.Yes),
      "Vote should be Yes"
    );
  }

  // Test for when the committee agrees
  function test_CommitteeAgrees() public {
    // Vote from all committee members
    (address[] memory voters, ) = committeeManager.getCommitteeVotes(0);
    uint remaining = voters.length;

    for (uint i = 0; remaining > 0; i++) {
      vm.prank(voters[i]);
      committeeManager.voteReviewRequest(0, true);
      remaining--;
    }

    // Check if the review request is closed and accepted
    (
      ,
      ,
      ,
      ,
      bool isClosed,
      CommitteeManager.AcceptanceStatus status,

    ) = committeeManager.getReviewRequestDetails(0);
    assertEq(isClosed, true, "Review request should be closed");
    assertEq(
      uint(status),
      uint(CommitteeManager.AcceptanceStatus.Accepted),
      "Status should be Accepted"
    );

    // Check if the escrow was updated
    (, , , , , , , bool isDone) = escrowManager.getEscrow(0);
    assertEq(isDone, true, "Escrow should be closed");

    // Check buyer balance
    assertEq(
      accounts[2].balance,
      99999999999999999999,
      "The balance of the Buyer should be equal"
    );

    // Check seller balance
    assertEq(
      accounts[1].balance,
      100000000000000000001,
      "The balance of the Seller should be equal"
    );
  }

  // Test for when the committee declines
  function test_CommitteeDecline() public {
    // Vote from all committee members
    (address[] memory voters, ) = committeeManager.getCommitteeVotes(0);
    uint remaining = voters.length;

    for (uint i = 0; remaining > 0; i++) {
      vm.prank(voters[i]);
      committeeManager.voteReviewRequest(0, false);
      remaining--;
    }

    // Check if the review request is closed and declined
    (
      ,
      ,
      ,
      ,
      bool isClosed,
      CommitteeManager.AcceptanceStatus status,

    ) = committeeManager.getReviewRequestDetails(0);
    assertEq(isClosed, true, "Review request should be closed");
    assertEq(
      uint(status),
      uint(CommitteeManager.AcceptanceStatus.Declined),
      "Status should be Declined"
    );

    // Check if the escrow was updated
    (, , , , , , , bool isDone) = escrowManager.getEscrow(0);
    assertEq(isDone, true, "Escrow should be closed");

    // Check buyer balance
    assertEq(
      accounts[2].balance,
      99999999999999999997,
      "The balance of the Buyer should be equal"
    );

    // Check seller balance
    assertEq(
      accounts[1].balance,
      100000000000000000003,
      "The balance of the Seller should be equal"
    );
  }

  // Test for opening a committee review by a non-authorized account
  function test_OpenCommitteeReview_NotAuthorized() public {
    // Expect revert when opening a review by a non-authorized account
    vm.startPrank(accounts[5]);
    vm.expectRevert("You are not a party to this escrow");
    committeeManager.openCommitteeReview(1, 1, "Test reason");
    vm.stopPrank();
  }

  // Test for voting on a review request by a non-authorized account
  // function test_VoteReviewRequest_NotAuthorized() public {
  //   // Expect revert when voting by a non-authorized account
  //   vm.startPrank(accounts[1]);
  //   vm.expectRevert("you are not a part of the committee for this escrow");
  //   committeeManager.voteReviewRequest(0, true);
  //   vm.stopPrank();
  // }

  // Test for voting on a closed review request
  function test_VoteReviewRequest_ReviewClosed() public {
    // Vote on a closed review request
    (address[] memory voters, ) = committeeManager.getCommitteeVotes(0);
    uint remaining = voters.length;

    for (uint i = 0; remaining > 0; i++) {
      vm.prank(voters[i]);
      committeeManager.voteReviewRequest(0, true);
      remaining--;
    }

    // Expect revert when voting on a closed review request
    vm.startPrank(accounts[3]);
    vm.expectRevert("Review request is closed");
    committeeManager.voteReviewRequest(0, true);
    vm.stopPrank();
  }
}
