// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {IERC20} from "./IERC20.sol";

/// @title Cassa Router Interface
/// @notice Router for swapping between asset, IT, and UT tokens via a Balancer pool and CassaITUT vault.
interface ICassaRouter {
    /// @notice Returns a quote for swapping `exactAmountIn` of `tokenIn` for `tokenOut`
    /// @dev `tokenIn` and `tokenOut` must be different
    /// @param vault The CassaITUT vault address
    /// @param pool The Balancer pool address
    /// @param tokenIn Input token (asset, IT, or UT)
    /// @param tokenOut Output token (asset or UT)
    /// @param exactAmountIn The exact amount of `tokenIn` to swap
    /// @return amountOut The estimated amount of `tokenOut` received
    function previewSwapExactIn(address vault, address pool, address tokenIn, address tokenOut, uint256 exactAmountIn)
        external
        returns (uint256 amountOut);

    /// @notice Returns a quote for swapping `tokenIn` for `exactAmountOut` of `tokenOut`
    /// @dev `tokenIn` and `tokenOut` must be different
    /// @param vault The CassaITUT vault address
    /// @param pool The Balancer pool address
    /// @param tokenIn Input token (asset or UT)
    /// @param tokenOut Output token (asset, IT, or UT)
    /// @param exactAmountOut The exact amount of `tokenOut` desired
    /// @return amountIn The estimated amount of `tokenIn` required
    function previewSwapExactOut(address vault, address pool, address tokenIn, address tokenOut, uint256 exactAmountOut)
        external
        returns (uint256 amountIn);

    /// @notice Swaps `exactAmountIn` of `tokenIn` for `tokenOut`
    /// @dev `tokenIn` and `tokenOut` must be different
    /// @param vault The CassaITUT vault address
    /// @param pool The Balancer pool address
    /// @param tokenIn Input token (asset, IT, or UT)
    /// @param tokenOut Output token (asset or UT)
    /// @param exactAmountIn The exact amount of `tokenIn` to swap
    /// @param minAmountOut The minimum acceptable amount of `tokenOut`
    /// @return amountOut The actual amount of `tokenOut` received
    function swapExactIn(
        address vault,
        address pool,
        address tokenIn,
        address tokenOut,
        uint256 exactAmountIn,
        uint256 minAmountOut
    ) external returns (uint256 amountOut);

    /// @notice Swaps `tokenIn` for `exactAmountOut` of `tokenOut`
    /// @dev `tokenIn` and `tokenOut` must be different
    /// @param vault The CassaITUT vault address
    /// @param pool The Balancer pool address
    /// @param tokenIn Input token (asset or UT)
    /// @param tokenOut Output token (asset, IT, or UT)
    /// @param exactAmountOut The exact amount of `tokenOut` desired
    /// @param maxAmountIn The maximum acceptable amount of `tokenIn`
    /// @return amountIn The actual amount of `tokenIn` spent
    function swapExactOut(
        address vault,
        address pool,
        address tokenIn,
        address tokenOut,
        uint256 exactAmountOut,
        uint256 maxAmountIn
    ) external returns (uint256 amountIn);

    /// @notice Callback for exact-in swaps, invoked by the vault during credit operations
    /// @dev Only callable during a reentrant context (from within a vault credit operation)
    /// @param pool The Balancer pool address
    /// @param tokenIn Input token address
    /// @param tokenOut Output token address
    /// @param exactAmountIn The exact amount of `tokenIn` to swap
    /// @param minAmountOut The minimum acceptable amount of `tokenOut`
    /// @return amountOut The actual amount of `tokenOut` received
    function swapExactInHook(
        address pool,
        address tokenIn,
        address tokenOut,
        uint256 exactAmountIn,
        uint256 minAmountOut
    ) external returns (uint256 amountOut);

    /// @notice Callback for exact-out swaps, invoked by the vault during credit operations
    /// @dev Only callable during a reentrant context (from within a vault credit operation)
    /// @param pool The Balancer pool address
    /// @param tokenIn Input token address
    /// @param tokenOut Output token address
    /// @param exactAmountOut The exact amount of `tokenOut` desired
    /// @param maxAmountIn The maximum acceptable amount of `tokenIn`
    /// @return amountIn The actual amount of `tokenIn` spent
    function swapExactOutHook(
        address pool,
        address tokenIn,
        address tokenOut,
        uint256 exactAmountOut,
        uint256 maxAmountIn
    ) external returns (uint256 amountIn);
}
