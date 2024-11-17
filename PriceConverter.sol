// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0

import "@chainlink/contracts/v0.8/interfaces/AggregatorV3Interface.sol";

//Why is this a library and not an abstract
// Why not an interface

library PriceConverter {
    // We could make this public then we'd have to deploy it

    function getPrice() internal view returns(uint256) {
        // Sepolia ETH / USD Address
        //https://docs.chain.link/data-feeds/price-feeds/addresses#Sepoli%20Testnet

        AggregatorV3Interface priceFeed = AggregatorV3Interface (0x694AA1769357215DE4FAC081bf1f309aDC325306);

        (, int256 price,,,) = priceFeed.latestRoundData();
        //ETH/USD rate in 18 digit

        return uint256(price * 1e10)
    }

    funtion getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;

        return ethAmountInUsd
    }
}

















