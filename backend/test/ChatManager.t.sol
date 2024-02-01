// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";
import {ChatManager} from "../contracts/ChatManager.sol";

contract ChatManagerTest is Test, ManagerSetup {
    function setUp() public {}

    function test_openChannel() public {
        vm.startPrank(accounts[1]);
        escrowManager.createEscrow(accounts[3], 0, 2);
        ChatManager.Channel memory channel = chatManager.getChannel(1);
        bool isOpen = false;
        if (channel.channelStatus == ChatManager.ChannelStatus.Open) {
            isOpen = true;
        }
        assertEq(channel.escrowId, 1, "Escrow ID should match");
        assertEq(isOpen, true, "Channel should be open");
        assertEq(channel.messageCount, 0, "Message count should be 0");
        vm.stopPrank();
    }

    function test_closeChannel() public {
        vm.startPrank(accounts[1]);
        chatManager.closeChannel(0);
        ChatManager.Channel memory channel = chatManager.getChannel(0);
        bool isClosed = false;
        if (channel.channelStatus == ChatManager.ChannelStatus.Closed) {
            isClosed = true;
        }
        assertEq(channel.escrowId, 0, "Escrow ID should match");
        assertEq(isClosed, true, "Channel should be closed");
        vm.stopPrank();
    }

    function test_sendMessage() public {
        vm.startPrank(accounts[1]);
        chatManager.sendMessage(0, "Hello, world!");

        ChatManager.Message memory message = chatManager.getMessage(0, 0);

        assertEq(message.sender, accounts[1], "Sender should match");
        assertEq(message.receiver, accounts[2], "Receiver should match");
        assertEq(
            message.content,
            "Hello, world!",
            "Message content should match"
        );
        vm.stopPrank();
    }

    function test_getAllChannelMessages() public {
        vm.startPrank(accounts[1]);
        escrowManager.createEscrow(accounts[4], 0, 2);
        chatManager.sendMessage(1, "Message 1");
        chatManager.sendMessage(1, "Message 2");

        ChatManager.Message[] memory messages = chatManager
            .getAllChannelMessages(1);

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
        vm.stopPrank();
    }
}
