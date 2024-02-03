// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {JobManager} from "../contracts/JobManager.sol";

contract JobManagerTest is Test, ManagerSetup {
    // Test for the addJob function
    function test_AddJob() public {
        string[] memory tags = new string[](2);
        tags[0] = "tag1";
        tags[1] = "tag2";

        vm.prank(accounts[3]);
        jobManager.addJob("Job Title", "Job Description", 3, tags);

        // Check if the job was added successfully
        JobManager.SimplifiedJob memory newJob = jobManager.getJob(2);
        assertEq(newJob.title, "Job Title", "Job was not added correctly");
    }

    // Test for the toggleJob function
    function test_ToggleJob() public {
        vm.prank(accounts[3]);
        jobManager.toggleJob(1);

        // Check if the job was toggled successfully
        JobManager.SimplifiedJob memory toggledJob = jobManager.getJob(1);
        assertEq(toggledJob.inProgress, true, "Job was not toggled correctly");
    }

    // Test for the deleteJob function
    function test_DeleteJob() public {
        vm.prank(accounts[3]);
        jobManager.deleteJob(1);

        // Check if the job was deleted successfully
        // We use getJob(jobId) and compare the returned object
        // As deleteJob not removes the object from the mapping jobs it will just
        // replace it with standard values
        JobManager.SimplifiedJob memory job = jobManager.getJob(1);
        bool deleted = false;
        if (
            job.jobId == 0 &&
            bytes(job.title).length == 0 &&
            bytes(job.description).length == 0 &&
            job.price == 0 &&
            job.inProgress == false &&
            job.tags.length == 0
        ) {
            deleted = true;
        }
        assertEq(deleted, true, "Job was not deleted correctly");
    }

    // Test for the sendBuyRequest function
    function test_SendBuyRequest() public {
        vm.prank(accounts[4]);
        jobManager.sendBuyRequest(1, "I want to buy this job");

        // Check if the buy request was sent successfully
        vm.prank(accounts[3]);
        JobManager.BuyRequest[] memory buyRequests = jobManager
            .getJobBuyRequests(1);
        assertEq(
            buyRequests.length,
            1,
            "Buy request was not sent successfully"
        );
    }

    // Test for the acceptBuyRequest function
    function test_AcceptBuyRequest() public {
        vm.prank(accounts[4]);
        jobManager.sendBuyRequest(1, "I want to buy this job");

        vm.startPrank(accounts[3]);
        jobManager.acceptBuyRequest(1, 0);

        // Check if the buy request was accepted successfully
        JobManager.BuyRequest[] memory allBuyRequests = jobManager
            .getJobBuyRequests(1);
        assertEq(
            allBuyRequests[0].accepted,
            true,
            "Buy request was not accepted successfully"
        );
        vm.stopPrank();
    }
}
