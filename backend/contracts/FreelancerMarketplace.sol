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
}

struct Review{
    string comment;
    uint8 rating;
    address commenter;
}

struct Job{
    User owner;
    uint256 jobId;
    string title;
    string description;
    uint256 price;
    mapping(uint256 => Review) reviews;
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

        //funktioniert noch nicht richtig
        modifier nameNotTaken(string memory str) {
        bool taken = false;
        for(uint256 i = 0; i < userCount; i++){
            if(bytes(users[addresses[userCount]].userName).length == bytes(str).length){
                taken = true;
                break;
            }
        }
        require(taken ==  false, "Name is already taken");
        _;
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

    function getUserByAddress(address userAddress) external view returns (address, string memory, bool,Review[] memory buyer, Review[] memory seller ) {
        User storage user = users[userAddress];
        (Review[] memory buyerReviews,Review[] memory sellerReviews) = getReviewsByUser(userAddress);
        return (user.owner, user.userName, user.isJudge,buyerReviews,sellerReviews);
    }

    event JudgeSet(address userAddress);

        function setJudge(address userAddress) onlyAdmin(msg.sender) external{
        users[userAddress].isJudge = true;

    emit JudgeSet(userAddress);
    }

    event ReviewAdded(address userAddress, string comment, uint8 rating);

        function addReview(address userAddress, string memory comment, uint8 rating) nonEmptyString(comment) external {
            require(users[userAddress].owner != address(0), "User does not exist");
            require(users[msg.sender].owner != address(0), "Only a User can write a Review");
            require(userAddress != msg.sender, "You cant Review yourself");

            uint256 userIndex = users[userAddress].reviewsBuyerCount+1;
            Review storage newReview = users[userAddress].reviewsBuyer[userIndex];
            newReview.comment = comment;
            newReview.rating = rating;
            newReview.commenter = msg.sender;

            users[userAddress].reviewsBuyerCount++;


    emit ReviewAdded(userAddress, comment, rating);
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
