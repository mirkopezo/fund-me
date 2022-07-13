//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error NotEnoughETH();

contract FundMe is Ownable {
    AggregatorV3Interface private immutable priceFeed;

    uint256 public constant MINIMUM_USD_VALUE = 10;

    /**
     * Network: Rinkeby
     * Aggregator: ETH/USD
     * Address: 0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
     */
    constructor() {
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function withdrawAllFunds() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function fund() public payable {
        if (msg.value < getMinimumEthValue()) revert NotEnoughETH();
    }

    function getMinimumEthValue() public view returns (uint256) {
        return (MINIMUM_USD_VALUE * 10**26) / _getEthPrice();
    }

    function _getEthPrice() internal view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();

        return uint256(price);
    }
}
