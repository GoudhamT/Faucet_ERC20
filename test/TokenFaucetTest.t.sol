// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployToken} from "script/DeployScript.s.sol";
import {FaucetToken} from "../src/TokenFaucet.sol";

contract FaucetTokenTest is Test {
    DeployToken public deployer;
    FaucetToken public ft;

    function setUp() public {
        deployer = new DeployToken();
        // ft = deployer.run();
        ft = new FaucetToken();
    }

    function testCheckOwner() public view {
        assert(ft.getOwner() == address(this));
    }
}
