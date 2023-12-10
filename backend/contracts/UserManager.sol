// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./FreelancerMarketplace.sol";

contract UserManager {
  FreelancerMarketplace freelancerMarketplace;

  mapping(address => User) public users;
  mapping(uint256 => address) public addresses;
  uint256 public userCount;

  struct User {
    address owner;
    string userName;
    mapping(uint256 => Review) reviewsBuyer;
    uint256 reviewsBuyerCount;
    mapping(uint256 => Review) reviewsSeller;
    uint256 reviewsSellerCount;
    bool isJudge;
    uint256[] jobIds;
  }

  constructor(address _freelancerMarketplaceAddress) {
    freelancerMarketplace = FreelancerMarketplace(
      _freelancerMarketplaceAddress
    );
  }

  //*********************************************************************
  //*********************************************************************
  //                        Getter Functions
  //*********************************************************************
  //*********************************************************************

  function getUser(
    address _address
  )
    external
    view
    returns (
      address owner,
      string memory userName,
      bool isJudge,
      uint256[] memory jobIds
    )
  {
    User storage user = users[_address];
    return (user.owner, user.userName, user.isJudge, user.jobIds);
  }

  function getAllUserAddresses() external view returns (address[] memory) {
    address[] memory allUserAddresses = new address[](userCount);

    for (uint256 i = 0; i < userCount; i++) {
      allUserAddresses[i] = addresses[i];
    }

    return allUserAddresses;
  }

  function getAllJobIds(
    address userAddress
  ) external view returns (uint256[] memory) {
    return users[userAddress].jobIds;
  }

  function getReviewsByUser(
    address userAddress
  ) internal view returns (Review[] memory, Review[] memory) {
    User storage user = users[userAddress];

    Review[] memory buyerReviews = new Review[](user.reviewsBuyerCount);
    Review[] memory sellerReviews = new Review[](user.reviewsSellerCount);

    for (uint256 i = 0; i < user.reviewsBuyerCount; i++) {
      buyerReviews[i] = user.reviewsBuyer[i];
    }

    for (uint256 j = 0; j < user.reviewsSellerCount; j++) {
      sellerReviews[j] = user.reviewsSeller[j];
    }

    return (buyerReviews, sellerReviews);
  }

  //*********************************************************************
  //*********************************************************************
  //                        User Functions
  //*********************************************************************
  //*********************************************************************

  event UserRegistered(address userAddress, string name);

  function registerUser(string memory _name) external nameNotTaken(_name) {
    require(
      freelancerMarketplace.nonEmptyString(_name),
      "String must not be empty"
    );
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

  //*********************************************************************
  //*********************************************************************
  //                        Job Functions
  //*********************************************************************
  //*********************************************************************

  function addJobId(uint256 jobId, address _address) external {
    users[_address].jobIds.push(jobId);
  }

  function removeJobId(uint256 jobId, address _address) external {
    User storage currentUser = users[_address];
    uint256 indexToRemove;

    for (uint256 i = 0; i < currentUser.jobIds.length; i++) {
      if (currentUser.jobIds[i] == jobId) {
        indexToRemove = i;
        break;
      }
    }

    require(indexToRemove < currentUser.jobIds.length, "Job ID not found");

    currentUser.jobIds[indexToRemove] = currentUser.jobIds[
      currentUser.jobIds.length - 1
    ];
    currentUser.jobIds.pop();
  }

  //*********************************************************************
  //*********************************************************************
  //                        Judge Functions
  //*********************************************************************
  //*********************************************************************

  event JudgeSet(address userAddress);

  function setJudge(address userAddress) external {
    require(freelancerMarketplace.onlyAdmin(), "You need to be Admin");
    users[userAddress].isJudge = true;

    emit JudgeSet(userAddress);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Review Functions
  //*********************************************************************
  //*********************************************************************

  event UserReviewAdded(address userAddress, string comment, uint8 rating);

  function addUserReview(
    address userAddress,
    string memory comment,
    uint8 rating
  ) external {
    require(
      freelancerMarketplace.nonEmptyString(comment),
      "Comment must not be empty"
    );
    require(users[userAddress].owner != address(0), "User does not exist");
    require(
      users[msg.sender].owner != address(0),
      "Only a User can write a Review"
    );
    require(userAddress != msg.sender, "You can't Review yourself");

    uint256 userIndex = users[userAddress].reviewsBuyerCount;
    Review storage newReview = users[userAddress].reviewsBuyer[userIndex];
    newReview.comment = comment;
    newReview.rating = rating;
    newReview.commenter = msg.sender;

    users[userAddress].reviewsBuyerCount++;

    emit UserReviewAdded(userAddress, comment, rating);
  }

  //*********************************************************************
  //*********************************************************************
  //                              Modifier
  //*********************************************************************
  //*********************************************************************

  modifier nameNotTaken(string memory str) {
    bool taken = false;

    for (uint256 i = 0; i < userCount; i++) {
      taken = (keccak256(abi.encodePacked(users[addresses[i]].userName)) ==
        keccak256(abi.encodePacked(str)));

      if (taken) {
        break;
      }
    }

    require(!taken, "Name is already taken");
    _;
  }
}
