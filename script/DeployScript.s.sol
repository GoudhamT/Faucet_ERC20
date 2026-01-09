//SPDX-License-Identifier:MIT

pragma solidity 0.8.20;
import {Script} from "forge-std/Script.sol";
import {FaucetToken} from "../src/TokenFaucet.sol";

contract DeployToken is Script {
    function run() public returns (FaucetToken) {
        vm.startBroadcast();
        FaucetToken ft = new FaucetToken();
        vm.stopBroadcast();
        return ft;
    }
}
