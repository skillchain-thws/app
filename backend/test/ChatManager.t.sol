// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {ChatManager} from "../contracts/ChatManager.sol";

contract ChatManagerTest is Test, ManagerSetup {
    // Test for the openChannel function
    function test_openChannel() public {
        // Prank an account to simulate escrow creation
        vm.startPrank(accounts[1]);
        escrowManager.createEscrow(accounts[3], 0, 2);

        // Retrieve channel information
        ChatManager.Channel memory channel = chatManager.getChannel(1);
        bool isOpen = false;
        if (channel.channelStatus == ChatManager.ChannelStatus.Open) {
            isOpen = true;
        }

        // Assertions
        assertEq(channel.escrowId, 1, "Escrow ID should match");
        assertEq(isOpen, true, "Channel should be open");
        assertEq(channel.messageCount, 0, "Message count should be 0");

        // Stop pranking
        vm.stopPrank();
    }

    // Test for the closeChannel function
    function test_closeChannel() public {
        // Prank an account to simulate closing a channel
        vm.startPrank(accounts[1]);
        chatManager.closeChannel(0);

        // Retrieve channel information
        ChatManager.Channel memory channel = chatManager.getChannel(0);
        bool isClosed = false;
        if (channel.channelStatus == ChatManager.ChannelStatus.Closed) {
            isClosed = true;
        }

        // Assertions
        assertEq(channel.escrowId, 0, "Escrow ID should match");
        assertEq(isClosed, true, "Channel should be closed");

        // Stop pranking
        vm.stopPrank();
    }

    // Test for the sendMessage function
    function test_sendMessage() public {
        // Prank an account to simulate sending a message
        vm.startPrank(accounts[1]);
        chatManager.sendMessage(0, "Hello, world!");

        // Retrieve the sent message
        ChatManager.Message memory message = chatManager.getMessage(0, 0);

        // Assertions
        assertEq(message.sender, accounts[1], "Sender should match");
        assertEq(message.receiver, accounts[2], "Receiver should match");
        assertEq(
            message.content,
            "Hello, world!",
            "Message content should match"
        );

        // Stop pranking
        vm.stopPrank();
    }

    // Test for the getAllChannelMessages function
    function test_getAllChannelMessages() public {
        // Prank an account to simulate creating messages
        vm.startPrank(accounts[1]);
        escrowManager.createEscrow(accounts[4], 0, 2);
        chatManager.sendMessage(1, "Message 1");
        chatManager.sendMessage(1, "Message 2");

        // Retrieve all messages for the channel
        ChatManager.Message[] memory messages = chatManager
            .getAllChannelMessages(1);

        // Assertions
        assertEq(messages.length, 2, "Message array length should be 2");
        assertEq(
            messages[0].content,
            "Message 1",
            "First message content should match"
        );
        assertEq(
            messages[1].content,
            "Message 2",
            "Second message content should match"
        );

        // Stop pranking
        vm.stopPrank();
    }

    // Test for handling invalid messageId
    function test_invalidMessageId() public {
        // Prank an account to simulate requesting an invalid message
        vm.startPrank(accounts[1]);

        // Expect a revert due to an invalid message ID
        vm.expectRevert("Invalid messageId");
        chatManager.getMessage(0, 100);

        // Stop pranking
        vm.stopPrank();
    }

    // Test for handling a channel not open for sendMessage
    function test_channelNotOpenForSendMessage() public {
        // Prank an account to simulate closing the channel
        vm.startPrank(accounts[1]);
        chatManager.closeChannel(0);

        // Expect a revert due to attempting to send a message on a closed channel
        vm.expectRevert("Channel not open");
        chatManager.sendMessage(0, "Hello, world!");

        // Stop pranking
        vm.stopPrank();
    }

    // Test for handling only authorized users for sendMessage
    function test_onlyAuthorizedForSendMessage() public {
        // Prank an account to simulate an unauthorized user trying to send a message
        vm.startPrank(accounts[3]);
        escrowManager.createEscrow(accounts[3], 0, 2);
        chatManager.openChannel(0); // Open the channel

        // Expect a revert due to unauthorized user attempting to send a message
        vm.expectRevert(
            "you are not a part of the committee or party of this escrow"
        );
        chatManager.sendMessage(0, "Hello, world!");

        // Stop pranking
        vm.stopPrank();
    }
}
