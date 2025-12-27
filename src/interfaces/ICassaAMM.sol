// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {ICassaITUT} from "./ICassaITUT.sol";

/// @title Cassa AMM Interface
/// @notice Automated Market Maker interface for swapping between asset, underlying, and insured tokens.
interface ICassaAMM {
    /// @notice Token types used in the AMM
    enum Token {
        ASSET,
        UNDERLYING,
        INSURED
    }

    /// @notice Returns the IT/UT pair contract for this AMM
    /// @return _pair The ICassaITUT contract associated with this AMM
    function pair() external view returns (ICassaITUT _pair);

    /// @notice Returns the swap fee in parts per million
    /// @return _feePpm The swap fee in parts per million (1e6 = 100%)
    function swapFee() external view returns (uint256 _feePpm);

    /// @notice Previews the output amount for a token swap
    /// @param tokenIn The token being swapped in (ASSET, UNDERLYING, or INSURED)
    /// @param tokenOut The token being swapped out (ASSET, UNDERLYING, or INSURED)
    /// @param amountIn The amount of tokenIn to swap
    /// @return out The estimated amount of tokenOut to receive
    function previewSwap(Token tokenIn, Token tokenOut, uint256 amountIn) external view returns (uint256 out);

    /// @notice Previews the amount of LP tokens to receive for adding liquidity
    /// @param amountsIn The amounts of tokens to add [ASSET, UNDERLYING, INSURED]
    /// @return out The estimated amount of LP tokens to receive
    function previewAddLiquidity(uint256[3] calldata amountsIn) external view returns (uint256 out);

    /// @notice Previews the amounts of tokens to receive for removing liquidity
    /// @param amountIn The amount of LP tokens to burn
    /// @return out The estimated amounts of tokens to receive [ASSET, UNDERLYING, INSURED]
    function previewRemoveLiquidity(uint256 amountIn) external view returns (uint256[3] memory out);

    /// @notice Previews the amount of a single token to receive for removing liquidity
    /// @param tokenOut The token to receive (ASSET, UNDERLYING, or INSURED)
    /// @param amountIn The amount of LP tokens to burn
    /// @return out The estimated amount of tokenOut to receive
    function previewRemoveLiquidityOneToken(Token tokenOut, uint256 amountIn) external view returns (uint256 out);

    /// @notice Swaps one token for another
    /// @param tokenIn The token being swapped in (ASSET, UNDERLYING, or INSURED)
    /// @param tokenOut The token being swapped out (ASSET, UNDERLYING, or INSURED)
    /// @param amountIn The amount of tokenIn to swap
    /// @param minAmountOut The minimum amount of tokenOut to accept
    /// @return out The actual amount of tokenOut received
    function swap(Token tokenIn, Token tokenOut, uint256 amountIn, uint256 minAmountOut) external returns (uint256 out);

    /// @notice Adds liquidity to the pool
    /// @param amountsIn The amounts of tokens to add [ASSET, UNDERLYING, INSURED]
    /// @param minAmountOut The minimum amount of LP tokens to accept
    /// @return out The actual amount of LP tokens received
    function addLiquidity(uint256[3] calldata amountsIn, uint256 minAmountOut) external returns (uint256 out);

    /// @notice Removes liquidity from the pool
    /// @param amountIn The amount of LP tokens to burn
    /// @param minAmountsOut The minimum amounts of tokens to accept [ASSET, UNDERLYING, INSURED]
    /// @return out The actual amounts of tokens received [ASSET, UNDERLYING, INSURED]
    function removeLiquidity(uint256 amountIn, uint256[3] calldata minAmountsOut)
        external
        returns (uint256[3] memory out);

    /// @notice Removes liquidity from the pool as a single token
    /// @param tokenOut The token to receive (ASSET, UNDERLYING, or INSURED)
    /// @param amountIn The amount of LP tokens to burn
    /// @param minAmountOut The minimum amount of tokenOut to accept
    /// @return out The actual amount of tokenOut received
    function removeLiquidityOneToken(Token tokenOut, uint256 amountIn, uint256 minAmountOut)
        external
        returns (uint256 out);
}
