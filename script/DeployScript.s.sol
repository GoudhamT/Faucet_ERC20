//SPDX-License-Identifier:MIT

pragma solidity ^0.8.19;
import {Script} from "forge-std/Script.sol";
import {FaucetToken} from "../src/TokenFaucet.sol";

contract DeployToken is Script {
    function run() external returns (FaucetToken) {
        vm.startBroadcast();
        FaucetToken ft = new FaucetToken();
        vm.stopBroadcast();
        return ft;
    }
}
