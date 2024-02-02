// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {CommitteeManager} from "../contracts/CommitteeManager.sol";

contract CommitteeManagerTest is Test, ManagerSetup {
    function setUp() public {
        vm.prank(accounts[1]);
        committeeManager.openCommitteeReview(0, 1, "Test reason");
        // Get the required ammount of committee members
        (, , , uint requiredCommitteeMembers, , ) = committeeManager
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

    function test_OpenCommitteeReview() public {
        (, , , , , CommitteeManager.AcceptanceStatus status) = committeeManager
            .getReviewRequestDetails(0);
        assertEq(
            uint(status),
            uint(CommitteeManager.AcceptanceStatus.Pending),
            "Status should be Pending"
        );
    }

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
            CommitteeManager.AcceptanceStatus status
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

    function test_CommitteeDecline() public {
        // Vote from all committee members
        (address[] memory voters, ) = committeeManager.getCommitteeVotes(0);
        uint remaining = voters.length;

        for (uint i = 0; remaining > 0; i++) {
            vm.prank(voters[i]);
            committeeManager.voteReviewRequest(0, false);
            remaining--;
        }

        // Check if the review request is closed and accepted
        (
            ,
            ,
            ,
            ,
            bool isClosed,
            CommitteeManager.AcceptanceStatus status
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
}
