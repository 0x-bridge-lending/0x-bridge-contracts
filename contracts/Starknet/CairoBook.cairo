/// @dev Core Library Imports for the Traits outside the Starknet Contract
use starknet::ContractAddress;

/// @dev Trait defining the functions that can be implemented or called by the Starknet Contract
#[starknet::interface]
trait CairoBookTrait<T> {
    /// @dev Function that returns the current balance
    fn get_balance(self: @T, user_address: ContractAddress) -> u32;
    /// @dev Function that checks if the user at the specified address is allowed to get a loan
    fn claim_loan(self: @T, user_address: ContractAddress, loan_amount: u32) -> bool;
    /// @dev Function that checks if the specified address has a loan, can make a payments
    fn pay_loan(self: @T, address: ContractAddress, amount: u32) -> u32;
    
}

/// @dev Starknet Contract allowing get a loan from l1 verifying with zkproof
#[starknet::contract]
mod CairoBook {
    use starknet::ContractAddress;
    use starknet::get_caller_address;


    /// @dev Structure that stores vote counts and voter states
    #[storage]
    struct Storage {
        borrower: LegacyMap::<ContractAddress, u32>,
    }


    /// @dev Implementation of CairoBookTrait for ContractState
    #[external(v0)]
    impl CairoBookImpl of super::CairoBookTrait<ContractState> {
        /// @dev Returns the voting results
        fn get_balance(self: @ContractState, user_address: ContractAddress) -> u32 {
            let result = self.borrower.read(user_address);
            return result;
        }

        fn claim_loan(self: @ContractState, user_address: ContractAddress, loan_amount: u32) -> bool {
            let balance = get_balance(user_address);
            self.borrower.write(user_address, (balance + loan_amount));
            return true;
        }

        fn pay_loan(self: @ContractState, address: ContractAddress, amount: u32) -> u32 {
            let balance = get_balance(address);
            self.borrower.write(address, (balance - amount));
            let remaining_debt = get_balance(address);
            return remaining_debt;
        }
    }

}