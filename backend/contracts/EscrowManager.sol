// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./JobManager.sol";
import "./FreelancerMarketplace.sol";

contract EscrowManager {
  mapping(uint256 => Escrow) escrows;
  uint256 escrowCount;
  FreelancerMarketplace freelancerMarketplace;
  JobManager jobManager;
  UserManager userManager;

  struct Escrow {
    uint256 jobId;
    address buyer;
    address seller;
    uint256 money;
    bool started;
    bool buyerAccepted;
    bool sellerAccepted;
    mapping(uint256 => string) generalChat;
    uint256 generalChatCount;
    mapping(uint256 => string) buyerChat;
    uint256 buyerChatCount;
    mapping(uint256 => string) sellerChat;
    uint256 sellerChatCount;
    mapping(uint8 => address) comittee;
    uint8 comitteeCount;
    mapping(address => bool) votes;
  }

  event EscrowStarted(address buyer, address seller, uint256 jobId);

  constructor(address _freelancerMarketplaceAddress) {
    freelancerMarketplace = FreelancerMarketplace(
      _freelancerMarketplaceAddress
    );
  }

  function setJobManager(address _address) external {
    jobManager = JobManager(_address);
  }

  function setUserManager(address _address) external {
    userManager = UserManager(_address);
  }

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
    newEscrow.buyerAccepted = false;
    newEscrow.sellerAccepted = false;

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

  function getEscrow(
    uint256 escrowId
  )
    public
    view
    escrowExists(escrowId)
    returns (
      uint256 jobId,
      address buyer,
      address seller,
      uint256 money,
      bool started,
      bool buyerAccepted,
      bool sellerAccepted
    )
  {
    Escrow storage tempEscrow = escrows[escrowId];
    return (
      tempEscrow.jobId,
      tempEscrow.buyer,
      tempEscrow.seller,
      tempEscrow.money,
      tempEscrow.started,
      tempEscrow.buyerAccepted,
      tempEscrow.sellerAccepted
    );
  }

  function acceptBuyer(
    bool _accept,
    uint256 escrowId
  ) external payable isBuyer(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    if (_accept) {
      require(msg.value >= currentEscrow.money, "Insufficient funds");

      currentEscrow.money += msg.value; // Add the sent funds to the escrow
    }

    currentEscrow.buyerAccepted = _accept;
  }

  function acceptSeller(
    bool _accept,
    uint256 escrowId
  ) external isSeller(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];

    if (_accept) {
      currentEscrow.sellerAccepted = true;
    } else {
      payable(currentEscrow.buyer).transfer(currentEscrow.money);
      currentEscrow.money = 0;
    }
  }

  function acceptDone(
    bool _accept,
    uint256 escrowId
  ) external isEscrowParty(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];
    require(currentEscrow.started, "The escrow first has to start");
    if (msg.sender == currentEscrow.buyer) {
      currentEscrow.buyerAccepted = _accept;
    } else if (msg.sender == currentEscrow.seller) {
      currentEscrow.sellerAccepted = _accept;
    }
    if (currentEscrow.buyerAccepted && currentEscrow.sellerAccepted) {
      //TODO
      escrowDone(currentEscrow);
    }
  }

  //TODO
  function escrowDone(Escrow storage escrow) internal {
    payable(escrow.seller).transfer(escrow.money);
    escrow.money = 0;
  }

  function startWork(uint256 escrowId) external isSeller(escrowId) {
    require(
      escrows[escrowId].buyerAccepted,
      "The Buyer has first to confirm the Trade"
    );
    require(
      escrows[escrowId].sellerAccepted,
      "You have to first confirm the Trade"
    );
    escrows[escrowId].started = true;
    escrows[escrowId].sellerAccepted = false;
    escrows[escrowId].buyerAccepted = false;
  }

  function cancelEscrow(uint256 escrowId) external isEscrowParty(escrowId) {
    Escrow storage currentEscrow = escrows[escrowId];
    if (
      currentEscrow.buyerAccepted == false &&
      currentEscrow.sellerAccepted == false
    ) {
      payable(currentEscrow.buyer).transfer(currentEscrow.money);
      currentEscrow.money = 0;
    } else {
      //TODO
      startComitteeVote();
    }
  }

  //TODO
  function startComitteeVote() internal {}

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
