// SPDX-License-Identifier: MIT

use starknet::ContractAddress;

// StarkNet interface for managing own DApps.
// This trait defines a set of functions for interacting with DApps from the perspective of an own.
#[starknet::interface]
trait IOwnDappManage<TContractState> {

    // Set the status (active or inactive) of multiple DApps.
    // `self` is a reference to the contract's state.
    // `dapps` is an array of DApp class hashes identifying each DApp.
    // `status` is an array of boolean values representing the status (active/inactive) of each DApp.
    fn set_own_dapps(ref self: TContractState, dapps: Array<starknet::ClassHash>, status: Array<bool>);

    // Get the status (active or inactive) of a specific DApp.
    // `self` is a pointer to the contract's state.
    // `dapp` is the class hash of the DApp for which the status is being queried.
    // Returns a boolean indicating the DApp's status.
    fn get_own_dapp_state(self: @TContractState, dapp: starknet::ClassHash) -> bool;

    // Set the approval status for all DApps.
    // `self` is a reference to the contract's state.
    // `approved` is a boolean value indicating the approval status to be set for all DApps.
    fn set_approval_all_dapps(ref self: TContractState, approved: bool);

    // Get the approval status for all DApps.
    // `self` is a pointer to the contract's state.
    // Returns a boolean indicating the global approval status for all DApps.
    fn get_approval_all_dapps(self: @TContractState) -> bool;

    // Execute a function on a specific DApp.
    // `self` is a reference to the contract's state.
    // `dapp` is the class hash of the target DApp.
    // `selector` is a 252-bit field element representing the function to be called on the DApp.
    // `calldata` is an array of 252-bit field elements representing the arguments for the function call.
    // Returns a span of field elements, which is the return value from the DApp function call.
    fn execute_own_dapp(ref self: TContractState, dapp: starknet::ClassHash, selector: felt252, calldata: Array<felt252>) -> Span<felt252>;

    // Read data from a specific DApp without modifying its state.
    // `self` is a pointer to the contract's state.
    // `dapp` is the class hash of the target DApp.
    // `selector` is a 252-bit field element representing the function to be called on the DApp.
    // `calldata` is an array of 252-bit field elements representing the arguments for the function call.
    // Returns a span of field elements, which is the data read from the DApp.
    fn read_own_dapp(self: @TContractState, dapp: starknet::ClassHash, selector: felt252, calldata: Array<felt252>) -> Span<felt252>;
}


