// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./UserManager.sol";
import "./EscrowManager.sol";
import "./FreelancerMarketplace.sol";

contract JobManager {
    mapping(uint256 => Job) jobs;
    uint256 public jobCount;

    FreelancerMarketplace freelancerMarketplace;
    EscrowManager escrowManager;
    UserManager userManager;

    struct BuyRequest {
        uint256 jobId;
        uint256 buyRequestId;
        address buyer;
        string comment;
        bool accepted;
    }

    struct Job {
        address owner;
        uint256 jobId;
        string title;
        string description;
        uint256 price;
        mapping(uint256 => BuyRequest) buyRequests;
        uint256 buyRequestCount;
        mapping(uint256 => Review) reviewsJob;
        uint256 reviewCount;
        bool inProgress;
    }

    event JobAdded(
        address owner,
        string title,
        string description,
        uint256 price
    );


    event ToggledJob(bool inProgress);

    event JobDeleted(address userAddress, uint256 jobId);

    constructor(address _freelancerMarketplaceAddress) {
        freelancerMarketplace = FreelancerMarketplace(_freelancerMarketplaceAddress);
    }

    function isUserInArray() external view returns (bool) {
        address[] memory allUsers = userManager.getAllUserAddresses();
        address sender = msg.sender;

        for (uint256 i = 0; i < allUsers.length; i++) {
            if (allUsers[i] == sender) {
                return true; // sender is in the array
            }
        }

        return false; // sender is not in the array
    }


    function setEscrowManager(address _address) external {
        escrowManager = EscrowManager(_address);
    }

    function setUserManager(address _address) external {
        userManager = UserManager(_address);
    }

    function getJobOwner(uint256 jobId) external view returns (address _address) {
        return jobs[jobId].owner;
    }

    function sendBuyRequest(uint256 jobId, string memory comment) public  isAUser()
        isNotJobOwner(jobId)
        notInProgress(jobId)
        jobExists(jobId)
    {
        require(freelancerMarketplace.nonEmptyString(comment), "Comment must not be empty");

        Job storage currentJob = jobs[jobId];
        BuyRequest storage request = currentJob.buyRequests[currentJob.buyRequestCount];
        request.jobId = jobId;
        request.buyer = msg.sender;
        request.comment = comment;
        request.buyRequestId = currentJob.buyRequestCount;
        request.accepted = false;

        currentJob.buyRequestCount++;

    }

    function acceptBuyRequest(uint256 jobId, uint256 buyRequestId) public payable
        notInProgress(jobId)
        isJobOwner(jobId)
        jobExists(jobId)
         isAUser()
    {

        Job storage currentJob = jobs[jobId];
        BuyRequest memory currentBuyRequest = currentJob.buyRequests[buyRequestId];
        currentBuyRequest.accepted = true;

        escrowManager.createEscrow(currentBuyRequest.buyer, jobId, currentBuyRequest.comment);
    }

    function addJob(string memory title, string memory description, uint256 price) public  isAUser(){
        require(freelancerMarketplace.nonEmptyString(title), "Title must not be empty");
        require(freelancerMarketplace.nonEmptyString(description), "Description must not be empty");

        Job storage newJob = jobs[jobCount];
        newJob.owner = msg.sender;
        newJob.title = title;
        newJob.description = description;
        newJob.price = price;
        newJob.jobId = jobCount;
        newJob.inProgress = false;

        userManager.addJobId(jobCount, msg.sender);

        jobCount++;

        emit JobAdded(msg.sender, title, description, price);
    }

    function toggleJob(uint256 jobId) external isJobOwner(jobId)  isAUser() {

        jobs[jobId].inProgress = !jobs[jobId].inProgress;

        emit ToggledJob(jobs[jobId].inProgress);
    }

    function deleteJob(uint256 jobId) public
        isJobOwner(jobId)
        notInProgress(jobId)
        jobExists(jobId)
    {
        userManager.removeJobId(jobId, msg.sender);
        delete jobs[jobId];

        emit JobDeleted(msg.sender, jobId);
    }

    modifier isAUser() {
        address[] memory allUsers = userManager.getAllUserAddresses();
        address sender = msg.sender;
        bool pass = false;
        for (uint256 i = 0; i < allUsers.length; i++) {
            if (allUsers[i] == sender) {
                pass = true;
            }
        }

        require(pass, "You need a User for this Action");
        _;
    }

    modifier isJobOwner(uint256 jobId) {
        require(msg.sender == jobs[jobId].owner, "You need to be the owner of the job");
        _;
    }

    modifier isNotJobOwner(uint256 jobId) {
        require(msg.sender != jobs[jobId].owner, "You cannot buy your own job");
        _;
    }

    modifier notInProgress(uint256 jobId) {
        require(!jobs[jobId].inProgress, "Job is in progress and cannot be modified");
        _;
    }

    modifier jobExists(uint256 jobId) {
        require(jobId <= jobCount, "Job does not exist");
        _;
    }
}
