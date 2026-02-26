// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ICassaERC20} from "./ICassaERC20.sol";
import {ICassaPolicy} from "./ICassaPolicy.sol";

/// @title Cassa ITUT Interface
/// @notice Cassa IT/UT vault interface.
interface ICassaITUT {
    /// @notice Thrown when a requirement for the policy to not be effective is not met.
    /// @param timestamp The current block.timestamp
    /// @param effective The policy effective timestamp
    error CassaITUT_PolicyAlreadyEffective(uint256 timestamp, uint256 effective);

    /// @notice Thrown when a requirement for the policy to be effective is not met.
    /// @param timestamp The current block.timestamp
    /// @param effective The policy effective timestamp
    error CassaITUT_PolicyNotEffective(uint256 timestamp, uint256 effective);

    /// @notice Thrown when a requirement for the policy to not be expired is not met.
    /// @param timestamp The current block.timestamp
    /// @param expiration The policy expiration timestamp
    error CassaITUT_PolicyExpired(uint256 timestamp, uint256 expiration);

    /// @notice Thrown when a requirement for the policy to be expired is not met.
    /// @param timestamp The current block.timestamp
    /// @param expiration The policy expiration timestamp
    error CassaITUT_PolicyNotExpired(uint256 timestamp, uint256 expiration);

    /// @notice Thrown when a requirement for the policy to be inside the policy period is not met.
    /// @param timestamp The current block.timestamp
    /// @param effective The policy effective timestamp
    /// @param expiration The policy expiration timestamp
    error CassaITUT_OutsidePolicyPeriod(uint256 timestamp, uint256 effective, uint256 expiration);

    /// @notice Thrown when a requirement for the policy to be unsettled is not met.
    error CassaITUT_AlreadySettled();

    /// @notice Thrown when a requirement for the policy to be settled is not met.
    error CassaITUT_NotSettled();

    /// @notice Thrown when the caller is not authorized to perform the call.
    error CassaITUT_Unauthorized();

    /// @notice Thrown when `policy.settlementRatio()` returns an unsuccessful status.
    error CassaITUT_UnsuccessfulSettlementRatioCall();

    /// @notice Thrown when a deposit would exceed the maximum allowed for `receiver`.
    /// @param receiver The address that would receive the deposit
    /// @param assets The amount of assets attempted to be deposited
    /// @param max The maximum allowable deposit amount for `receiver`
    error CassaITUT_ExceededMaxDeposit(address receiver, uint256 assets, uint256 max);

    /// @notice Thrown when a redeem would exceed the maximum redeemable tokens for `owner`.
    /// @param owner The address attempting to redeem tokens
    /// @param tokens The number of tokens the owner attempted to redeem
    /// @param max The maximum redeemable token amount for `owner`
    error CassaITUT_ExceededMaxRedeem(address owner, uint256 tokens, uint256 max);

    /// @notice Thrown when redeeming IT tokens would exceed the maximum redeemable IT tokens for `owner`.
    /// @param owner The address attempting to redeem IT tokens
    /// @param tokens The amount of IT tokens attempted to redeem
    /// @param max The maximum redeemable IT token amount for `owner`
    error CassaITUT_ExceededMaxRedeem_IT(address owner, uint256 tokens, uint256 max);

    /// @notice Thrown when redeeming UT tokens would exceed the maximum redeemable UT tokens for `owner`.
    /// @param owner The address attempting to redeem UT tokens
    /// @param tokens The amount of UT tokens attempted to redeem
    /// @param max The maximum redeemable UT token amount for `owner`
    error CassaITUT_ExceededMaxRedeem_UT(address owner, uint256 tokens, uint256 max);

    /// @notice Thrown when a flash loan of assets would exceed the maximum allowed.
    /// @param caller The address requesting the flash loan
    /// @param assets The amount of assets requested
    /// @param max The maximum allowable flash loan amount
    error CassaITUT_ExceededMaxFlashLoan_Asset(address caller, uint256 assets, uint256 max);

    /// @notice Thrown when a flash loan of IT/UT tokens would exceed the maximum allowed.
    /// @param caller The address requesting the flash loan
    /// @param tokens The amount of tokens requested
    /// @param max The maximum allowable flash loan amount
    error CassaITUT_ExceededMaxFlashLoan_ITUT(address caller, uint256 tokens, uint256 max);

    /// @notice Thrown when a callback invocation fails.
    error CassaITUT_UnsuccessfulCallback();

    /// @notice Emitted when assets are deposited and IT/UT tokens are minted.
    /// @param sender The address that initiated the deposit
    /// @param receiver The address that received the minted tokens
    /// @param assets The amount of assets deposited
    /// @param tokens The amount of IT/UT token pairs minted
    event Deposit(address indexed sender, address indexed receiver, uint256 assets, uint256 tokens);

    /// @notice Emitted when a deposit is performed via a credit operation.
    /// @param sender The address that initiated the deposit
    /// @param target The callback target address
    /// @param asset The amount of assets involved in the credit
    /// @param assetsIn The net assets transferred in (negative if surplus returned)
    /// @param itOut The amount of IT tokens sent to the receiver
    /// @param utOut The amount of UT tokens sent to the receiver
    event DepositOnCredit(
        address indexed sender, address indexed target, uint256 asset, int256 assetsIn, uint256 itOut, uint256 utOut
    );

    /// @notice Emitted when tokens are redeemed for assets.
    /// @param sender The address that initiated the redemption
    /// @param receiver The address that received the assets
    /// @param owner The address of the token owner
    /// @param assets The amount of assets returned
    /// @param it The amount of IT tokens burned
    /// @param ut The amount of UT tokens burned
    event Redeem(
        address indexed sender, address indexed receiver, address indexed owner, uint256 assets, uint256 it, uint256 ut
    );

    /// @notice Emitted when a redemption is performed via a credit operation.
    /// @param sender The address that initiated the redemption
    /// @param target The callback target address
    /// @param tokens The amount of tokens involved in the credit
    /// @param assetsOut The amount of assets sent to the receiver
    /// @param itIn The net IT tokens burned (negative if surplus returned)
    /// @param utIn The net UT tokens burned (negative if surplus returned)
    event RedeemOnCredit(
        address indexed sender, address indexed target, uint256 tokens, uint256 assetsOut, int256 itIn, int256 utIn
    );

    /// @notice Emitted when the policy is settled.
    /// @param settlementRatio The settlement ratio value scaled by 1e18
    event Settled(uint256 settlementRatio);

    /// @notice Emitted when the fee rate is updated.
    /// @param oldRate The previous fee rate
    /// @param newRate The new fee rate
    event UpdatedFeeRate(uint256 oldRate, uint256 newRate);

    /// @notice Emitted when the fee receiver is updated.
    /// @param oldReceiver The previous fee receiver address
    /// @param newReceiver The new fee receiver address
    event UpdatedFeeReceiver(address oldReceiver, address newReceiver);

    /// @notice Returns the IT (Insured Token) contract
    /// @return _it The ICassaERC20 contract for the IT token
    function IT() external view returns (ICassaERC20 _it);

    /// @notice Returns the UT (Underwriting Token) contract
    /// @return _ut The ICassaERC20 contract for the UT token
    function UT() external view returns (ICassaERC20 _ut);

    /// @notice Returns the underlying asset token
    /// @return _asset The address for the underlying asset
    function asset() external view returns (address _asset);

    /// @notice Returns the policy contract
    /// @return _policy The ICassaPolicy contract governing this ITUT
    function policy() external view returns (ICassaPolicy _policy);

    /// @notice Returns the name of the vault
    /// @return _name The name string
    function name() external view returns (string memory _name);

    /// @notice Returns the maximum amount of assets that can be deposited for a receiver
    /// @param receiver The address to check deposit limits for
    /// @return max The maximum deposit amount
    function maxDeposit(address receiver) external view returns (uint256 max);

    /// @notice Returns the maximum amount of IT/UT pairs that can be deposited from a whitelisted `ICassaITUT` contract
    /// @param vault The address of the whitelisted `ICassaITUT` contract whose IT/UT tokens will be deposited
    /// @param receiver The address to check deposit limits for
    /// @return max The maximum deposit amount in IT/UT pairs
    function maxDepositITUT(address vault, address receiver) external view returns (uint256 max);

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

    /// @notice Previews the amount of IT and UT tokens that would be minted for a given asset deposit
    /// @param assets The amount of assets to simulate depositing
    /// @return tokens The total amount of token pairs that would be minted
    function previewDeposit(uint256 assets) external view returns (uint256 tokens);

    /// @notice Previews the amount of IT and UT tokens that would be minted for depositing IT/UT pairs from a whitelisted `ICassaITUT` contract
    /// @param vault The address of the whitelisted `ICassaITUT` contract whose IT/UT tokens will be deposited
    /// @param amount The amount of IT/UT pairs to simulate depositing
    /// @return tokens The total amount of token pairs that would be minted
    function previewDepositITUT(address vault, uint256 amount) external view returns (uint256 tokens);

    /// @notice Previews the amount of assets that would be returned for redeeming a given amount of tokens
    /// @param tokens The amount of tokens to simulate redeeming
    /// @return assets The amount of assets that would be returned
    function previewRedeem(uint256 tokens) external view returns (uint256 assets);

    /// @notice Previews the amount of assets that would be returned for redeeming IT tokens
    /// @param tokens The amount of IT tokens to simulate redeeming
    /// @return assets The amount of assets that would be returned
    function previewRedeemIT(uint256 tokens) external view returns (uint256 assets);

    /// @notice Previews the amount of assets that would be returned for redeeming UT tokens
    /// @param tokens The amount of UT tokens to simulate redeeming
    /// @return assets The amount of assets that would be returned
    function previewRedeemUT(uint256 tokens) external view returns (uint256 assets);

    /// @notice Deposits assets and mints IT and UT tokens to a receiver
    /// @param assets The amount of assets to deposit
    /// @param receiver The address that will receive the minted tokens
    /// @return tokens The total amount of token pairs minted
    function deposit(uint256 assets, address receiver) external returns (uint256 tokens);

    /// @notice Deposits IT/UT pairs from a whitelisted `ICassaITUT` contract and mints new IT and UT tokens
    /// @dev The deposited IT/UT pairs must be backed by the same underlying asset
    /// @param vault The address of the whitelisted `ICassaITUT` contract whose IT/UT tokens will be deposited
    /// @param amount The amount of IT/UT pairs to deposit
    /// @param receiver The address that will receive the minted tokens
    /// @return tokens The total amount of token pairs minted
    function depositITUT(address vault, uint256 amount, address receiver) external returns (uint256 tokens);

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

    /// @notice Returns the settlement ratio and whether the policy has been settled
    /// @return ratio The settlement ratio value scaled by 1e18 (1e18 = 100%)
    /// @return isSettled Whether the policy has been settled
    function settlementRatio() external view returns (uint256 ratio, bool isSettled);
}
