// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import {Test, console} from "forge-std/Test.sol";
import {ManagerSetup} from "./ManagerSetup.t.sol";

contract ExampleManagerTest is Test, ManagerSetup {
    // SetUp funnction if needed:
    // function setUp() public {}
    //
    // Unit tests:
    // function test_nameFunction() public {
    /*
      Possible assert commands:
        - assertEq, assert equal
        - assertLt, assert less than
        - assertLe, assert less than or equal to
        - assertGt, assert greater than
        - assertGe, assert greater than or equal to
        - assertTrue, assert to be true

        Example:
        assertEq(1, 1, "1 and 1 should be eqaul");

      ---

      Test for reverts with:
        vm.expectRevert("exact revert message");

      ---

      Change msg.sender:
        - Only the next command: vm.prank(account[yourNumber]);
        - For several commands:
          - Start with: vm.startPrank(account[yourNumber]);
          - End with: vm.stopPrank();

      */
    // }
    // More unit tests:
    // ...
}
