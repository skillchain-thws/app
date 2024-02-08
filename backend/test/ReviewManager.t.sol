// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";

contract ReviewManagerTest is Test, ManagerSetup {
  // Test creating a review
  function test_createReview() public {
    // Create a review for a specific escrow ID
    vm.prank(accounts[2]);
    reviewManager.createReview(0, 5, "Excellent work!");

    // Check if the review was successfully created by retrieving and verifying the details
    (
      ,
      uint rating,
      address reviewingAddress,
      address beingReviewedAddress,
      string memory reviewComment,
      uint relevantEscrowId,
      bool responded,
      uint id
    ) = reviewManager.getReview(1);
    assertEq(rating, 5, "Rating should be 5");
    assertEq(reviewingAddress, accounts[2], "Reviewing address should match");
    assertEq(
      beingReviewedAddress,
      accounts[1],
      "Being reviewed address should match"
    );
    assertEq(reviewComment, "Excellent work!", "Review comment should match");
    assertEq(relevantEscrowId, 0, "Escrow ID should match");
    assertEq(responded, false, "Response should not be added yet");
    assertEq(id, 1, "ID should be 1");
    vm.stopPrank();
  }

  // Test creating a response
  function test_createResponse() public {
    // Create a review for a specific escrow ID
    vm.startPrank(accounts[2]);
    reviewManager.createReview(0, 5, "Excellent work!");
    vm.stopPrank();

    // Create a response to the created review
    vm.startPrank(accounts[1]);
    reviewManager.createResponse(1, "Thank you!");

    // Check if the response was successfully created by retrieving and verifying the details
    (, address responder, string memory responseComment) = reviewManager
      .getResponse(1);

    assertEq(responder, accounts[1], "Responder should match");
    assertEq(responseComment, "Thank you!", "Response comment should match");
    vm.stopPrank();
  }

  // Test that review comment must not be empty
  function test_reviewCommentNotEmpty() public {
    // Create a review with an empty comment and check if an exception is thrown
    vm.startPrank(accounts[1]);
    vm.expectRevert("String must not be empty");
    reviewManager.createReview(0, 5, "");
    vm.stopPrank();
  }

  // Test that only the escrow entity can create a review
  function test_onlyEscrowEntityCanCreateReview() public {
    // Attempt to create a review as a non-escrow entity and check if an exception is thrown
    vm.startPrank(accounts[3]);
    vm.expectRevert("you are not party of this");
    reviewManager.createReview(1, 5, "Excellent work!");
    vm.stopPrank();
  }

  // Test that only the being-reviewed address can create a response
  function test_onlyBeingReviewedAddressCanCreateResponse() public {
    // Create a review and attempt to create a response as a different address than the being-reviewed address
    vm.startPrank(accounts[2]);
    reviewManager.createReview(0, 5, "Excellent work!");

    // Attempt to create a response as a different address than the being-reviewed address and check if an exception is thrown
    vm.expectRevert(
      "You can only respond to reviews where you are being reviewed"
    );
    reviewManager.createResponse(1, "Thank you!");
    vm.stopPrank();
  }

  // Test that only one review can be submitted for an escrow
  function test_reviewOnceForEscrow() public {
    // Create a review for a specific escrow ID
    vm.startPrank(accounts[2]);
    reviewManager.createReview(0, 5, "Excellent work!");

    // Attempt to create a second review for the same escrow ID and check if an exception is thrown
    vm.expectRevert("You can only review once for this escrowId");
    reviewManager.createReview(0, 4, "Second review");
    vm.stopPrank();
  }

  // Test that response comment must not be empty
  function test_responseCommentNotEmpty() public {
    // Create a review for a specific escrow ID
    vm.prank(accounts[2]);
    reviewManager.createReview(0, 5, "Excellent work!");

    // Attempt to create a response with an empty comment and check if an exception is thrown
    vm.startPrank(accounts[1]);
    vm.expectRevert("String must not be empty");
    reviewManager.createResponse(1, "");
    vm.stopPrank();
  }

  // Test attempting to retrieve a review with an invalid ID
  function test_invalidReviewId() public {
    // Attempt to retrieve a review with an invalid ID and check if an exception is thrown
    vm.expectRevert("Invalid reviewId");
    reviewManager.getReview(100);
  }
}
