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

    event EscrowStarted(address buyer, address seller, uint256 jobId);

    constructor(address _freelancerMarketplaceAddress) {
        freelancerMarketplace = FreelancerMarketplace(_freelancerMarketplaceAddress);
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

    function sendMessageToBuyerChat(uint256 escrowId, string memory message)
        public
        escrowExists(escrowId)
        isBuyer(escrowId)
    {
        Escrow storage currentEscrow = escrows[escrowId];

        uint256 buyerChatIndex = currentEscrow.buyerChatCount + 1;
        currentEscrow.buyerChat[buyerChatIndex] = message;
        currentEscrow.buyerChatCount++;
    }

    function sendMessageToSellerChat(uint256 escrowId, string memory message)
        public
        escrowExists(escrowId)
        isSeller(escrowId)
    {
        Escrow storage currentEscrow = escrows[escrowId];

        uint256 sellerChatIndex = currentEscrow.sellerChatCount + 1;
        currentEscrow.sellerChat[sellerChatIndex] = message;
        currentEscrow.sellerChatCount++;
    }

    function getChats(uint256 escrowId)
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
