// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

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

struct Review {
  string comment;
  uint8 rating;
  address commenter;
}

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

struct Escrow {
  uint256 jobId;
  address buyer;
  address seller;
  uint256 money;
  bool buyerAccepted;
  bool sellerAccepted;
  mapping(uint256 => string) generalChat;
  uint256 generalChatCount;
  mapping(uint256 => string) buyerChat;
  uint256 buyerChatCount;
  mapping(uint256 => string) sellerChat;
  uint256 sellerChatCount;
  mapping(uint8 => address) comittee;
  uint256 comitteeCount;
}

contract FreelancerMarketplace {
  address owner;
  mapping(address => User) public users;
  mapping(uint256 => address) addresses;
  uint256 public userCount;
  mapping(uint256 => Job) jobs;
  uint256 public jobCount;
  mapping(uint256 => Escrow) escrows;
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
    require(
      users[msg.sender].owner != address(0),
      "You need a User to interact with a Job"
    );
    _;
  }

  //funktioniert beim ersten index nie
  modifier isJobOwner(uint256 jobId) {
    require(
      msg.sender == jobs[jobId].owner,
      "You need to be the Owner of the Job to interact with it"
    );
    _;
  }

  modifier isNotJobOwner(uint256 jobId) {
    require(
      msg.sender != jobs[jobId].owner,
      "You are now allowed to Buy your own Job"
    );
    _;
  }

  modifier notInProgress(uint256 jobId) {
    require(
      jobs[jobId].inProgress == false,
      "The Job is not allowed to be in Progress"
    );
    _;
  }

  modifier escrowExists(uint256 escrowId) {
    require(escrowId <= escrowCount, "Escrow does not exist");
    _;
  }

  modifier jobExists(uint256 jobId) {
    require(jobId <= jobCount, "Job does not exist");
    _;
  }

  modifier isEscrowParty(uint256 escrowId) {
    require(
      msg.sender == escrows[escrowId].seller ||
        msg.sender == escrows[escrowId].buyer,
      "You are not involved in the escrow"
    );
    _;
  }

  modifier isSeller(uint256 escrowId) {
    require(
      msg.sender == escrows[escrowId].seller,
      "You are not the seller in the escrow"
    );
    _;
  }

  modifier isBuyer(uint256 escrowId) {
    require(
      msg.sender == escrows[escrowId].buyer,
      "You are not the buyer in the escrow"
    );
    _;
  }

  //funktioniert noch nicht richtig
  modifier nameNotTaken(string memory str) {
    bool taken = false;
    if (
      bytes(users[addresses[userCount]].userName).length == bytes(str).length
    ) {
      for (uint256 i = 0; i < userCount; i++) {
        taken = (keccak256(
          abi.encodePacked(users[addresses[userCount]].userName)
        ) == keccak256(abi.encodePacked(str)));
      }
    }
    require(taken == false, "Name is already taken");
    _;
  }

  event BuyRequestSent(BuyRequest request);

  function sendBuyRequest(
    uint256 jobId,
    string memory comment
  )
    public
    hasAUser
    nonEmptyString(comment)
    isNotJobOwner(jobId)
    notInProgress(jobId)
    jobExists(jobId)
  {
    Job storage currentJob = jobs[jobId];
    BuyRequest storage request = currentJob.buyRequests[
      currentJob.buyRequestCount + 1
    ];
    request.jobId = jobId;
    request.buyer = msg.sender;
    request.comment = comment;
    request.buyRequestId = currentJob.buyRequestCount;
    request.accepted = false;

    currentJob.buyRequestCount++;

    emit BuyRequestSent(request);
  }

  function acceptBuyRequest(
    uint256 jobId,
    uint256 buyRequestId
  )
    public
    payable
    hasAUser
    notInProgress(jobId)
    isJobOwner(jobId)
    jobExists(jobId)
  {
    Job storage currentJob = jobs[jobId];
    BuyRequest memory currenBuyRequest = currentJob.buyRequests[buyRequestId];
    currenBuyRequest.accepted = true;

    createEscrow(currenBuyRequest.buyer, jobId, currenBuyRequest.comment);
  }

  event EscrowStarted(address buyer, address seller, uint256 jobId);

  function createEscrow(
    address buyer,
    uint256 jobId,
    string memory buyerMessage
  ) public payable notInProgress(jobId) {
    address seller = jobs[jobId].owner;

    Escrow storage newEscrow = escrows[escrowCount + 1];
    newEscrow.jobId = jobId;
    newEscrow.buyer = buyer;
    newEscrow.seller = seller;
    newEscrow.buyerAccepted = false;
    newEscrow.sellerAccepted = false;

    uint256 buyerChatIndex = newEscrow.buyerChatCount + 1;
    newEscrow.buyerChat[buyerChatIndex] = buyerMessage;
    newEscrow.buyerChatCount++;

    uint256 generalChatIndex = newEscrow.generalChatCount + 1;
    newEscrow.generalChat[generalChatIndex] = buyerMessage;
    newEscrow.generalChatCount++;

    escrowCount++;

    emit EscrowStarted(msg.sender, seller, jobId);
  }

  function sendMessageToBuyerChat(
    uint256 escrowId,
    string memory message
  ) public escrowExists(escrowId) isBuyer(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    uint256 buyerChatIndex = currentEscrow.buyerChatCount + 1;
    currentEscrow.buyerChat[buyerChatIndex] = message;
    currentEscrow.buyerChatCount++;
  }

  function sendMessageToSellerChat(
    uint256 escrowId,
    string memory message
  ) public escrowExists(escrowId) isSeller(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    uint256 sellerChatIndex = currentEscrow.sellerChatCount + 1;
    currentEscrow.sellerChat[sellerChatIndex] = message;
    currentEscrow.sellerChatCount++;
  }

  //einbauen der comitee member für sicht noch nötig
  function getChats(
    uint256 escrowId
  )
    public
    view
    escrowExists(escrowId)
    isEscrowParty(escrowId)
    returns (
      string[] memory generalChat,
      string[] memory buyerChat,
      string[] memory sellerChat
    )
  {
    Escrow storage tempEscrow = escrows[escrowId];

    generalChat = new string[](tempEscrow.generalChatCount);
    buyerChat = new string[](tempEscrow.buyerChatCount);
    sellerChat = new string[](tempEscrow.sellerChatCount);

    for (uint256 i = 0; i < tempEscrow.generalChatCount; i++) {
      generalChat[i] = tempEscrow.generalChat[i + 1];
    }

    for (uint256 i = 0; i < tempEscrow.buyerChatCount; i++) {
      buyerChat[i] = tempEscrow.buyerChat[i + 1];
    }

    for (uint256 i = 0; i < tempEscrow.sellerChatCount; i++) {
      sellerChat[i] = tempEscrow.sellerChat[i + 1];
    }

    return (generalChat, buyerChat, sellerChat);
  }

  event JobAdded(
    address owner,
    string title,
    string description,
    uint256 price
  );

  function addJob(
    string memory title,
    string memory description,
    uint256 price
  ) public hasAUser nonEmptyString(title) nonEmptyString(description) {
    Job storage newJob = jobs[jobCount + 1];
    newJob.owner = msg.sender;
    newJob.title = title;
    newJob.description = description;
    newJob.price = price;
    newJob.jobId = jobCount + 1;
    newJob.inProgress = false;

    users[msg.sender].jobIds.push(jobCount);

    jobCount++;

    emit JobAdded(owner, title, description, price);
  }

  event ToggledJob(bool inProgress);

  function toggleJob(uint256 jobId) external hasAUser isJobOwner(jobId) {
    jobs[jobId].inProgress = !jobs[jobId].inProgress;

    emit ToggledJob(jobs[jobId].inProgress);
  }

  event JobDeleted(address userAddress, uint256 jobId);

  function deleteJob(
    uint256 jobId
  ) public isJobOwner(jobId) notInProgress(jobId) jobExists(jobId) {
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

  function registerUser(
    string memory _name
  ) external nonEmptyString(_name) nameNotTaken(_name) {
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

  function getUserByAddress(
    address userAddress
  )
    external
    view
    returns (
      address,
      string memory,
      bool,
      Review[] memory buyer,
      Review[] memory seller,
      uint256[] memory jobIds
    )
  {
    User storage user = users[userAddress];
    (
      Review[] memory buyerReviews,
      Review[] memory sellerReviews
    ) = getReviewsByUser(userAddress);
    return (
      user.owner,
      user.userName,
      user.isJudge,
      buyerReviews,
      sellerReviews,
      user.jobIds
    );
  }

  event JudgeSet(address userAddress);

  function setJudge(address userAddress) external onlyAdmin(msg.sender) {
    users[userAddress].isJudge = true;

    emit JudgeSet(userAddress);
  }

  event UserReviewAdded(address userAddress, string comment, uint8 rating);

  function addUserReview(
    address userAddress,
    string memory comment,
    uint8 rating
  ) external nonEmptyString(comment) {
    require(users[userAddress].owner != address(0), "User does not exist");
    require(
      users[msg.sender].owner != address(0),
      "Only a User can write a Review"
    );
    require(userAddress != msg.sender, "You cant Review yourself");

    uint256 userIndex = users[userAddress].reviewsBuyerCount + 1;
    Review storage newReview = users[userAddress].reviewsBuyer[userIndex];
    newReview.comment = comment;
    newReview.rating = rating;
    newReview.commenter = msg.sender;

    users[userAddress].reviewsBuyerCount++;

    emit UserReviewAdded(userAddress, comment, rating);
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
}
