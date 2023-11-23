// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

struct User{
    address owner;
    string userName;
    mapping(uint256 => Review) reviewsBuyer;
    uint256 reviewsBuyerCount;
    mapping(uint256 => Review) reviewsSeller;
    uint256 reviewsSellerCount;
    bool isJudge;
    uint256[] jobIds;
}

struct Review{
    string comment;
    uint8 rating;
    address commenter;
}

struct Job{
    address owner;
    uint256 jobId;
    string title;
    string description;
    uint256 price;
    mapping(uint256 => Review) reviewsJob;
    bool inProgress;
}

struct Escrow{
    Job job;
    User buyer;
    uint256 money;
    mapping(uint256 => string) chat;
    mapping(uint8 => address) comittee;
}

contract FreelancerMarketplace{

    address owner;
    mapping(address => User) public users;
    mapping(uint256 => address) addresses;
    uint256 public userCount;
    mapping(uint256 => Job) jobs;
    uint256 public jobCount;
    mapping(uint256 => Escrow) escrow;
    uint256 escrowCount;

       modifier onlyAdmin(address userAddress) {
        require(msg.sender == owner, "Only the Admin can perform this action");
        _;
        }

        modifier nonEmptyString(string memory str) {
        require(bytes(str).length > 0, "String must not be empty");
        _;
         }

       modifier hasAUser() {
        require(users[msg.sender].owner != address(0), "You need a User to interact with a Job");
        _;
        }

        //funktioniert beim ersten index nie
        modifier isJobOwner(uint256 jobId){
            require(msg.sender == jobs[jobId].owner,"You need to be the Owner of the Job to interact with it");
            _;
        }

        modifier notInProgress(uint256 jobId){
            require(jobs[jobId].inProgress == false, "The Job is not allowed to be in Progress");
            _;
        }

        //funktioniert noch nicht richtig
        modifier nameNotTaken(string memory str) {
        bool taken = false;
        if (bytes(users[addresses[userCount]].userName).length == bytes(str).length) {
            for(uint256 i = 0; i < userCount; i++){
                taken = (keccak256(abi.encodePacked(users[addresses[userCount]].userName)) == keccak256(abi.encodePacked(str)));
        }
        }
        require(taken ==  false, "Name is already taken");
        _;
    }


    event JobAdded(address owner, string title, string description, uint256 price);

        function addJob(string memory title, string memory description, uint256 price) public hasAUser nonEmptyString(title) nonEmptyString(description){
            Job storage newJob = jobs[jobCount+1];
            newJob.owner = msg.sender;
            newJob.title = title;
            newJob.description = description;
            newJob.price = price;
            newJob.jobId = jobCount+1;
            newJob.inProgress = false;

            users[msg.sender].jobIds.push(jobCount);

        jobCount++;


    emit JobAdded( owner,  title,  description,  price);
    }

    event ToggledJob(bool inProgress);

        function toggleJob(uint256 jobId) external hasAUser isJobOwner(jobId){
            jobs[jobId].inProgress = !jobs[jobId].inProgress;

    emit ToggledJob(jobs[jobId].inProgress);
    }

    event JobDeleted(address userAddress, uint256 jobId);

        function deleteJob(uint256 jobId) public isJobOwner(jobId) notInProgress(jobId) {
        require(jobId < jobCount, "Invalid job ID");

        removeJobFromUserList(msg.sender, jobId);

        delete jobs[jobId];

    emit JobDeleted(msg.sender, jobId);
    }


    function removeJobFromUserList(address userAddress, uint256 jobId) internal {
        uint256[] storage userJobs = users[userAddress].jobIds;

        for (uint256 i = 0; i < userJobs.length; i++) {
            if (userJobs[i] == jobId) {
                userJobs[i] = userJobs[userJobs.length - 1];
                userJobs.pop();
                break;
            }
        }
    }

    event UserRegistered(address userAddress, string name);

      function registerUser(string memory _name) nonEmptyString(_name) nameNotTaken(_name) external {
        require(users[msg.sender].owner == address(0), "User already registered");

        User storage newUser = users[msg.sender];
        newUser.owner = msg.sender;
        newUser.userName = _name;
        newUser.isJudge = false;
        newUser.reviewsBuyerCount = 0;
        newUser.reviewsSellerCount = 0;

        addresses[userCount] = msg.sender;
        userCount++;

        emit UserRegistered(msg.sender, _name);
    }

   function getUserByAddress(address userAddress) external view returns (address, string memory, bool, Review[] memory buyer, Review[] memory seller, uint256[] memory jobIds) {
    User storage user = users[userAddress];
    (Review[] memory buyerReviews, Review[] memory sellerReviews) = getReviewsByUser(userAddress);
    return (user.owner, user.userName, user.isJudge, buyerReviews, sellerReviews, user.jobIds);
}


    event JudgeSet(address userAddress);

        function setJudge(address userAddress) onlyAdmin(msg.sender) external{
        users[userAddress].isJudge = true;

    emit JudgeSet(userAddress);
    }

    event UserReviewAdded(address userAddress, string comment, uint8 rating);

        function addUserReview(address userAddress, string memory comment, uint8 rating) nonEmptyString(comment) external {
            require(users[userAddress].owner != address(0), "User does not exist");
            require(users[msg.sender].owner != address(0), "Only a User can write a Review");
            require(userAddress != msg.sender, "You cant Review yourself");

            uint256 userIndex = users[userAddress].reviewsBuyerCount+1;
            Review storage newReview = users[userAddress].reviewsBuyer[userIndex];
            newReview.comment = comment;
            newReview.rating = rating;
            newReview.commenter = msg.sender;

            users[userAddress].reviewsBuyerCount++;


    emit UserReviewAdded(userAddress, comment, rating);
    }

    function getReviewsByUser(address userAddress) internal view returns (Review[] memory,Review[] memory) {
        User storage user = users[userAddress];

        Review[] memory buyerReviews = new Review[](user.reviewsBuyerCount);
        Review[] memory sellerReviews = new Review[](user.reviewsSellerCount);

        for (uint256 i = 0; i < user.reviewsBuyerCount; i++) {
            buyerReviews[i] = user.reviewsBuyer[i];
        }

        for (uint256 j = 0; j < user.reviewsSellerCount; j++) {
            sellerReviews[j] = user.reviewsSeller[j];
        }

        return (buyerReviews,sellerReviews);
    }



}
