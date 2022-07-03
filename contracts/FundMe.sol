//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    AggregatorV3Interface private immutable priceFeed;

    uint256 public constant MINIMUM_USD_VALUE = 10;

    constructor() {
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    function fund() external payable {
        if (msg.value < _getMinimumEthValue()) revert();
    }

    function _getMinimumEthValue() internal view returns (uint256) {
        return (MINIMUM_USD_VALUE * 10**8) / _getEthPrice();
    }

    function _getEthPrice() internal view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();

        return uint256(price);
    }
}
