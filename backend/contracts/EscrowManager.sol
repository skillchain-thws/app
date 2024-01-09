// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./JobManager.sol";
import "./FreelancerMarketplace.sol";

contract EscrowManager {
  mapping(uint256 => Escrow) public escrows;
  uint256 escrowCount;
  FreelancerMarketplace freelancerMarketplace;
  JobManager jobManager;
  UserManager userManager;

  struct Escrow {
    uint256 jobId;
    address buyer;
    address seller;
    uint money;
    bool started;
    bool isDone;
    mapping(uint256 => string) generalChat;
    uint256 generalChatCount;
    mapping(uint256 => string) buyerChat;
    uint256 buyerChatCount;
    mapping(uint256 => string) sellerChat;
    uint256 sellerChatCount;
    mapping(uint8 => address) comittee;
    uint8 comitteeCount;
    mapping(address => bool) votes;
    mapping(uint256 => Request) requests;
    uint256 buyRequestCount;
  }

  struct SimplifiedEscrow {
    uint256 jobId;
    address buyer;
    address seller;
    uint money;
    bool started;
    bool isDone;
  }

  enum RequestStatus {
    Pending,
    Accepted,
    Declined
  }

  struct Request {
    uint256 requestId;
    address buyer;
    address seller;
    RequestStatus status;
    bool isStartRequest;
  }

  constructor(address _freelancerMarketplaceAddress) {
    freelancerMarketplace = FreelancerMarketplace(
      _freelancerMarketplaceAddress
    );
  }

  //*********************************************************************
  //*********************************************************************
  //                        Setter Functions
  //*********************************************************************
  //*********************************************************************

  function setJobManager(address _address) external {
    require(
      freelancerMarketplace.onlyAdmin(),
      "Only the Admin can add Managers"
    );
    jobManager = JobManager(_address);
  }

  function setUserManager(address _address) external {
    require(
      freelancerMarketplace.onlyAdmin(),
      "Only the Admin can add Managers"
    );
    userManager = UserManager(_address);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Getter Functions
  //*********************************************************************
  //*********************************************************************

  function getEscrowIdFromJob(
    uint256 jobId
  ) external view returns (uint256 escrowId) {
    for (uint256 i = 0; i < escrowCount; i++) {
      if (escrows[i].jobId == jobId) {
        return i;
      }
    }
    revert("Escrow not found for the given job ID");
  }

  function getEscrow(
    uint256 escrowId
  )
    public
    view
    escrowExists(escrowId)
    returns (
      uint256 _escrowId,
      uint256 jobId,
      address buyer,
      address seller,
      uint money,
      bool started,
      bool isDone
    )
  {
    Escrow storage tempEscrow = escrows[escrowId];
    return (
      escrowId,
      tempEscrow.jobId,
      tempEscrow.buyer,
      tempEscrow.seller,
      tempEscrow.money,
      tempEscrow.started,
      tempEscrow.isDone
    );
  }

  function getPendingRequests(
    uint256 escrowId
  ) external view returns (Request[] memory) {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];

    Request[] memory pendingRequests;
    uint256 pendingCount;

    for (uint256 i = 0; i < escrow.buyRequestCount; i++) {
      if (escrow.requests[i].status == RequestStatus.Pending) {
        pendingRequests[pendingCount] = escrow.requests[i];
        pendingCount++;
      }
    }

    return pendingRequests;
  }

  function getAcceptedRequests(
    uint256 escrowId
  ) external view returns (Request[] memory) {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];

    Request[] memory acceptedRequests;
    uint256 acceptedCount;

    for (uint256 i = 0; i < escrow.buyRequestCount; i++) {
      if (escrow.requests[i].status == RequestStatus.Accepted) {
        acceptedRequests[acceptedCount] = escrow.requests[i];
        acceptedCount++;
      }
    }

    return acceptedRequests;
  }

  function getDeclinedRequests(
    uint256 escrowId
  ) external view returns (Request[] memory) {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];

    Request[] memory declinedRequests;
    uint256 declinedCount;

    for (uint256 i = 0; i < escrow.buyRequestCount; i++) {
      if (escrow.requests[i].status == RequestStatus.Declined) {
        declinedRequests[declinedCount] = escrow.requests[i];
        declinedCount++;
      }
    }

    return declinedRequests;
  }

  function getPendingRequestsForStartedEscrow(
    uint256 escrowId
  ) external view returns (Request[] memory) {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];

    require(escrow.started, "Escrow is not started");

    Request[] memory pendingRequests;
    uint256 pendingCount;

    for (uint256 i = 0; i < escrow.buyRequestCount; i++) {
      if (escrow.requests[i].status == RequestStatus.Pending) {
        pendingRequests[pendingCount] = escrow.requests[i];
        pendingCount++;
      }
    }

    return pendingRequests;
  }

  function getAcceptedRequestsForStartedEscrow(
    uint256 escrowId
  ) external view returns (Request[] memory) {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];

    require(escrow.started, "Escrow is not started");

    Request[] memory acceptedRequests;
    uint256 acceptedCount;

    for (uint256 i = 0; i < escrow.buyRequestCount; i++) {
      if (escrow.requests[i].status == RequestStatus.Accepted) {
        acceptedRequests[acceptedCount] = escrow.requests[i];
        acceptedCount++;
      }
    }

    return acceptedRequests;
  }

  function getDeclinedRequestsForStartedEscrow(
    uint256 escrowId
  ) external view returns (Request[] memory) {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];

    require(escrow.started, "Escrow is not started");

    Request[] memory declinedRequests;
    uint256 declinedCount;

    for (uint256 i = 0; i < escrow.buyRequestCount; i++) {
      if (escrow.requests[i].status == RequestStatus.Declined) {
        declinedRequests[declinedCount] = escrow.requests[i];
        declinedCount++;
      }
    }

    return declinedRequests;
  }

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
      generalChat[i] = tempEscrow.generalChat[i];
    }

    for (uint256 i = 0; i < tempEscrow.buyerChatCount; i++) {
      buyerChat[i] = tempEscrow.buyerChat[i];
    }

    for (uint256 i = 0; i < tempEscrow.sellerChatCount; i++) {
      sellerChat[i] = tempEscrow.sellerChat[i];
    }

    return (generalChat, buyerChat, sellerChat);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Escrow Functions
  //*********************************************************************
  //*********************************************************************

  event EscrowStarted(address buyer, address seller, uint256 jobId);

  function createEscrow(
    address buyer,
    uint256 jobId,
    string memory buyerMessage
  ) external {
    address seller = jobManager.getJobOwner(jobId);

    Escrow storage newEscrow = escrows[escrowCount];
    newEscrow.jobId = jobId;
    newEscrow.buyer = buyer;
    newEscrow.seller = seller;

    uint256 buyerChatIndex = newEscrow.buyerChatCount;
    newEscrow.buyerChat[buyerChatIndex] = string(
      abi.encodePacked("Buyer: ", buyerMessage)
    );
    newEscrow.buyerChatCount++;

    uint256 generalChatIndex = newEscrow.generalChatCount;
    newEscrow.generalChat[generalChatIndex] = string(
      abi.encodePacked("Buyer: ", buyerMessage)
    );
    newEscrow.generalChatCount++;

    escrowCount++;

    emit EscrowStarted(msg.sender, seller, jobId);
  }

  //*********************************************************************
  //*********************************************************************
  //                        Request Functions
  //*********************************************************************
  //*********************************************************************

  function sendRequest(uint256 escrowId) external payable {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];
    bool starter;
    if (!escrow.started) {
      require(
        msg.sender == escrow.buyer,
        "Only the Buyer can send the Start Request"
      );
      require(msg.value > 0, "Sent value must be greater than 0");
      escrows[escrowId].money += msg.value;
      starter = true;
    } else {
      require(
        msg.sender == escrow.seller,
        "Only the Seller can send the End Request"
      );
      starter = false;
    }

    address buyer = msg.sender;
    address seller = escrows[escrowId].seller;

    escrow.requests[escrows[escrowId].buyRequestCount] = Request({
      requestId: escrow.buyRequestCount,
      buyer: buyer,
      seller: seller,
      status: RequestStatus.Pending,
      isStartRequest: starter
    });

    escrows[escrowId].buyRequestCount++;
  }

  function respondToRequest(
    uint256 escrowId,
    uint256 requestId,
    bool accept
  ) external {
    require(escrowId < escrowCount, "Invalid escrow ID");
    Escrow storage escrow = escrows[escrowId];
    require(requestId < escrow.buyRequestCount, "Invalid request ID");
    Request storage request = escrow.requests[requestId];

    require(
      request.status == RequestStatus.Pending,
      "Request has already been responded to"
    );
    bool isStartRequest;

    if (!escrow.started) {
      require(
        msg.sender == escrow.seller,
        "Only the Seller can accpet the Start Request"
      );
      isStartRequest = true;
    } else {
      require(
        msg.sender == escrow.buyer,
        "Only the Buyer can accept the End Request"
      );
      isStartRequest = false;
    }

    if (accept) {
      if (!escrow.started) {
        escrow.started = true;
      } else {
        escrowDone(escrow);
      }
      request.status = RequestStatus.Accepted;
    } else {
      if (!escrow.started) {
        payable(escrow.buyer).transfer(escrow.money);
        escrow.money = 0;
      }
      request.status = RequestStatus.Declined;
    }
  }

  //*********************************************************************
  //*********************************************************************
  //                        Acceptance Functions
  //*********************************************************************
  //*********************************************************************

  function escrowDone(Escrow storage escrow) internal {
    payable(escrow.buyer).transfer(escrow.money);
    escrow.money = 0;
    escrow.isDone = true;
  }

  function cancelEscrow(uint256 escrowId) external isEscrowParty(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    require(!currentEscrow.started, "Cannot cancel a started escrow");

    payable(currentEscrow.buyer).transfer(currentEscrow.money);

    // Reset the escrow state
    currentEscrow.buyer = address(0);
    currentEscrow.seller = address(0);
    currentEscrow.money = 0;
    currentEscrow.started = false;
    currentEscrow.isDone = false;
    currentEscrow.buyerChatCount = 0;
    currentEscrow.sellerChatCount = 0;
    currentEscrow.generalChatCount = 0;
    currentEscrow.buyRequestCount = 0;
  }

  //*********************************************************************
  //*********************************************************************
  //                        Comittee Functions
  //*********************************************************************
  //*********************************************************************

  //TODO
  function startComitteeVote() internal {}

  //*********************************************************************
  //*********************************************************************
  //                        Chat Functions
  //*********************************************************************
  //*********************************************************************

  function sendMessageToBuyerChat(
    uint256 escrowId,
    string memory message
  ) public escrowExists(escrowId) isBuyer(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    uint256 buyerChatIndex = currentEscrow.buyerChatCount;
    currentEscrow.buyerChat[buyerChatIndex] = message;
    currentEscrow.buyerChatCount++;

    uint256 generalChatIndex = currentEscrow.generalChatCount;
    currentEscrow.generalChat[generalChatIndex] = string(
      abi.encodePacked("Buyer: ", message)
    );
    currentEscrow.generalChatCount++;
  }

  function sendMessageToSellerChat(
    uint256 escrowId,
    string memory message
  ) public escrowExists(escrowId) isSeller(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    uint256 sellerChatIndex = currentEscrow.sellerChatCount;
    currentEscrow.sellerChat[sellerChatIndex] = message;
    currentEscrow.sellerChatCount++;

    uint256 generalChatIndex = currentEscrow.generalChatCount;
    currentEscrow.generalChat[generalChatIndex] = string(
      abi.encodePacked("Seller: ", message)
    );
    currentEscrow.generalChatCount++;
  }

  //*********************************************************************
  //*********************************************************************
  //                        Modifiers
  //*********************************************************************
  //*********************************************************************

  modifier escrowExists(uint256 escrowId) {
    require(escrowId <= escrowCount, "Escrow does not exist");
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
}
