requires "../prefix.k"

// case ACCTTO == ACCT - not a possible state with sandy, but necessary to fully specify prefix
// case ACCTTO not in active accounts (just a gas fee thing?)
// case ACCT in selfdestructs

module PREFIX-SELFDESTRUCT-SPEC
    imports PREFIX

    rule <k> #execute => #halt </k>
        <mode> NORMAL </mode>
        <schedule> ISTANBUL </schedule>
        <statusCode> EVMC_SUCCESS </statusCode>
        <output> .WordStack </output>
        <touchedAccounts>
            .Set
        =>
            SetItem(9)
            SetItem(killer)
        </touchedAccounts>
        <program> prefix </program>
        <jumpDests> #computeValidJumpDests(prefix) </jumpDests>
        <id> 9 </id>
        <caller> killer </caller>
        <callData> killFunctionSig  </callData>
        <callValue> _ </callValue>
        <wordStack> .WordStack </wordStack>
        <pc> 0 => #sizeByteArray(prefix) -Int 2 </pc>
        <endPC> #sizeByteArray(prefix) -Int 2 </endPC>
        <gas> 10000 => ?_ </gas>

        <static> false </static>
        <callDepth> _ </callDepth>
        <selfDestruct> .Set => SetItem(9) </selfDestruct>
        <refund> 0 => 24000 </refund>
        <memoryUsed> 0 </memoryUsed>
        <localMem> .Map </localMem>

        <activeAccounts>
            SetItem(9)
            SetItem(killer)
        </activeAccounts>
        <accounts>
          <account>
            <acctID> 9 </acctID>
            <balance> 0 </balance>
            <code> prefix </code>
            <storage> .Map </storage>
            <origStorage> .Map </origStorage>
            <nonce> 0 </nonce>
          </account>
          <account>
            <acctID> killer </acctID>
            <balance> 0 </balance>
            <code> .WordStack </code>
            <storage> .Map </storage>
            <origStorage> .Map </origStorage>
            <nonce> 0 </nonce>
          </account>
        </accounts>

endmodule
