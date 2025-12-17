// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

import {ICassaERC20} from "./ICassaERC20.sol";
import {ICassaPolicy} from "./ICassaPolicy.sol";

interface ICassaITUT {
    /// @notice Returns the IT (Insured Token) contract
    /// @return _it The ICassaERC20 contract for the IT token
    function IT() external view returns (ICassaERC20 _it);
    
    /// @notice Returns the UT (Underwriting Token) contract
    /// @return _ut The ICassaERC20 contract for the UT token
    function UT() external view returns (ICassaERC20 _ut);
    
    /// @notice Returns the underlying asset token
    /// @return _asset The IERC20 contract for the underlying asset
    function asset() external view returns (IERC20 _asset);
    
    /// @notice Returns the policy contract
    /// @return _policy The ICassaPolicy contract governing this ITUT
    function policy() external view returns (ICassaPolicy _policy);
    
    /// @notice Returns the name of the IT/UT pair
    /// @return _name The name string
    function name() external view returns (string memory _name);
    
    /// @notice Returns the maximum amount of assets that can be deposited for a receiver
    /// @param receiver The address to check deposit limits for
    /// @return max The maximum deposit amount
    function maxDeposit(address receiver) external view returns (uint256 max);
    
    /// @notice Returns the maximum amount of tokens that can be redeemed by an owner
    /// @param owner The address of the token owner
    /// @return max The maximum redeemable token amount
    function maxRedeem(address owner) external view returns (uint256 max);
    
    /// @notice Returns the maximum amount of IT tokens that can be redeemed by an owner
    /// @param owner The address of the IT token owner
    /// @return max The maximum redeemable IT token amount
    function maxRedeemIT(address owner) external view returns (uint256 max);
    
    /// @notice Returns the maximum amount of UT tokens that can be redeemed by an owner
    /// @param owner The address of the UT token owner
    /// @return max The maximum redeemable UT token amount
    function maxRedeemUT(address owner) external view returns (uint256 max);
    
    /// @notice Deposits assets and mints IT and UT tokens to a receiver
    /// @param assets The amount of assets to deposit
    /// @param receiver The address that will receive the minted tokens
    /// @return tokens The total amount of tokens minted
    function deposit(uint256 assets, address receiver) external returns (uint256 tokens);
    
    /// @notice Redeems tokens and returns assets to a receiver
    /// @param tokens The amount of tokens to redeem
    /// @param receiver The address that will receive the assets
    /// @param owner The address of the token owner
    /// @return assets The amount of assets returned
    function redeem(uint256 tokens, address receiver, address owner) external returns (uint256 assets);
    
    /// @notice Redeems IT tokens and returns assets to a receiver
    /// @param tokens The amount of IT tokens to redeem
    /// @param receiver The address that will receive the assets
    /// @param owner The address of the IT token owner
    /// @return assets The amount of assets returned
    function redeemIT(uint256 tokens, address receiver, address owner) external returns (uint256 assets);
    
    /// @notice Redeems UT tokens and returns assets to a receiver
    /// @param tokens The amount of UT tokens to redeem
    /// @param receiver The address that will receive the assets
    /// @param owner The address of the UT token owner
    /// @return assets The amount of assets returned
    function redeemUT(uint256 tokens, address receiver, address owner) external returns (uint256 assets);
    
    /// @notice Settles the policy and fixes the settlement ratio
    function settle() external;
}
