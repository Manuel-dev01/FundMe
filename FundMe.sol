// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;
import "./PriceConverter.sol";

import "@chainlink/contracts/v0.8/interfaces/AggregatorV3Interface.sol";

error NotOwner();

contract FundMe {
    using PriceConverter for uint256;

    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders

    uint256 public constant MINIMUM_USD = 50;
    address public immutable i_owner;

    constructor {
        i_owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= MINIMUM_USD, "Didn't send enough!");
        //require(PriceConverter.getConversionRate(msg.value) > = minimumUsd, "Didn't send enough!")
        addressToAmountFunded[msg.sender] += msg.value;

        funders.push(msg.sender);
    }

    function getVersion() public view returns(uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return priceFeed.version();
    }

    modifier onlyOwner {
        if(msg.sender != i_owner) revert NotOwner();
        _;
    }

    function withdraw() public onlyOwner{
        for(uint256 i = 0; i < funders.length; i++) {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        funders = new address[](0);
        // //transfer
        // payable(msg.sender).transfer(address(this).balance);
        // // send
        // bool sendSuccess = payable(msg.sender).send(address(this).balance)
        // call
        (bool callSucess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");
        revert();
    }

    //What happens if someone send us ETH without calling the fund function?
    // We'll be using the special fnc "receive" and "fallback"

    //This is fall fnc is triggered when data is sent alongside the transact
    fallback() external payable {
        fund();
    }

    //The receive function will be trigerred if we send the contract some ETH without any data sent with that transact
    receive() external payable {
        fund();
    }
}