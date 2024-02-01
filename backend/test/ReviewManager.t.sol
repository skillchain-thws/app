// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";

contract ReviewManagerTest is Test, ManagerSetup {
    function test_createReview() public {
        // Erstelle eine Bewertung für eine bestimmte Escrow-ID
        vm.prank(accounts[2]);
        reviewManager.createReview(0, 5, "Excellent work!");

        // Überprüfe, ob die Bewertung erfolgreich erstellt wurde, indem die Details abgerufen und überprüft werden
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
        console.log(reviewingAddress);
        assertEq(rating, 5, "Rating should be 5");
        assertEq(
            reviewingAddress,
            accounts[2],
            "Reviewing address should match"
        );
        assertEq(
            beingReviewedAddress,
            accounts[1],
            "Being reviewed address should match"
        );
        assertEq(
            reviewComment,
            "Excellent work!",
            "Review comment should match"
        );
        assertEq(relevantEscrowId, 0, "Escrow ID should match");
        assertEq(responded, false, "Response should not be added yet");
        assertEq(id, 1, "ID should be 1");
        vm.stopPrank();
    }

    function test_createResponse() public {
        // Erstelle eine Bewertung für eine bestimmte Escrow-ID
        vm.startPrank(accounts[2]);
        reviewManager.createReview(0, 5, "Excellent work!");
        vm.stopPrank();

        // Erstelle eine Antwort auf die erstellte Bewertung
        vm.startPrank(accounts[1]);
        reviewManager.createResponse(1, "Thank you!");

        // Überprüfe, ob die Antwort erfolgreich erstellt wurde, indem die Details abgerufen und überprüft werden
        (, address responder, string memory responseComment) = reviewManager
            .getResponse(1);

        assertEq(responder, accounts[1], "Responder should match");
        assertEq(
            responseComment,
            "Thank you!",
            "Response comment should match"
        );
        vm.stopPrank();
    }
}
