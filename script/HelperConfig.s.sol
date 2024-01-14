// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mock/MockV3Aggregator.sol";

contract HelperConfig is Script {
    NetwotkConfig public activeNetworkConfig;
    struct NetwotkConfig {
        address priceFeed;
    }

    uint8 constant DECIMAL = 8;
    int256 constant INITIAL_ANSWER = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetwotkConfig memory) {
        NetwotkConfig memory sepoliaConfig = NetwotkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetwotkConfig memory) {
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockv3Aggregator = new MockV3Aggregator(
            DECIMAL,
            INITIAL_ANSWER
        );
        vm.stopBroadcast();
        return NetwotkConfig(address(mockv3Aggregator));
    }
}
