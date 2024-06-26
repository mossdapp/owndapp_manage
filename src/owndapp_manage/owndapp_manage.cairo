// SPDX-License-Identifier: MIT

/// # OwnDappManage Component
///
/// See [the documentation](https://docs.mossdapp.com)
#[starknet::component]
mod OwnDappManageComponent {
    use starknet::ContractAddress;
    use starknet::ClassHash;
    use starknet::account::Call;
    use starknet::SyscallResultTrait;
    use owndapp_manage::owndapp_manage::interface;


    #[storage]
    struct Storage {
        Own_dapps: LegacyMap<starknet::ClassHash, bool>,
        Approval_all_dapps: bool,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        SetOwnDappState: SetOwnDappState,
        SetApprovalAllDapp: SetApprovalAllDapp
    }

    #[derive(Drop, starknet::Event)]
    struct SetOwnDappState {
        dapp_manage: ContractAddress,
        dapp: ClassHash,
        state: bool
    }

    #[derive(Drop, starknet::Event)]
    struct SetApprovalAllDapp {
        dapp_manage: ContractAddress,
        approved: bool
    }


    #[embeddable_as(OwnDappManageImpl)]
    impl OwnDappManage<
        TContractState, +HasComponent<TContractState>
    > of interface::IOwnDappManage<ComponentState<TContractState>> {

        fn set_own_dapps(
            ref self: ComponentState<TContractState>,
            dapps: Array<starknet::ClassHash>,
            status: Array<bool>
        ) {
            assert(dapps.len() == status.len(), 'DappM: length mismatch');
            let mut i: usize = 0;
            let j: usize = dapps.len();
            loop {
                if i >= j {
                    break;
                }
                self.Own_dapps.write(*dapps[i], *status[i]);
                self.emit(SetOwnDappState { dapp_manage: starknet::get_contract_address(), dapp: *dapps[i], state: *status[i]});
                i += 1;
            };
        }


        fn get_own_dapp_state(
            self: @ComponentState<TContractState>,
            dapp: ClassHash
        ) -> bool {
            // Dapp Registry verification
            let state = self.Approval_all_dapps.read();
            if state == true {
                state
            }
            else {
                self.Own_dapps.read(dapp)
            }
        }

        fn set_approval_all_dapps(ref self: ComponentState<TContractState>, approved: bool){
            self.Approval_all_dapps.write(approved);
            self.emit(SetApprovalAllDapp { dapp_manage: starknet::get_contract_address(), approved });
        }

        fn get_approval_all_dapps(self: @ComponentState<TContractState>) -> bool{
            self.Approval_all_dapps.read()
        }


        fn execute_own_dapp(
            ref self: ComponentState<TContractState>,
            dapp: starknet::ClassHash,
            selector: felt252,
            calldata: Array<felt252>
        ) -> Span<felt252> {
            assert(self.get_own_dapp_state(dapp), 'DappM: not support this dapp');
            starknet::library_call_syscall(dapp, selector, calldata.span())
                .unwrap()
        }


        fn read_own_dapp(
            self: @ComponentState<TContractState>,
            dapp: starknet::ClassHash,
            selector: felt252,
            calldata: Array<felt252>
        ) -> Span<felt252> {
            assert(self.get_own_dapp_state(dapp), 'DappM: not support this dapp');
            starknet::library_call_syscall(dapp, selector, calldata.span())
                .unwrap()
        }

    }

}
