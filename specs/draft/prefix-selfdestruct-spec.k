requires "../prefix.k"

// case ACCTTO == ACCT - not a possible state with sandy, but necessary to fully specify prefix
// case ACCTTO not in active accounts (just a gas fee thing?)

module PREFIX-SELFDESTRUCT-SPEC
    imports PREFIX

    rule <k> #execute => #halt </k>
        <mode> NORMAL </mode>
        <schedule> ISTANBUL </schedule>
        <statusCode> EVMC_SUCCESS </statusCode>
        <output> .WordStack </output>
        <touchedAccounts>... (.Set => SetItem(ACCT) SetItem(killer)) </touchedAccounts>
        <program> prefix </program>
        <jumpDests> #computeValidJumpDests(prefix) </jumpDests>
        <id> ACCT </id>
        <caller> killer </caller>
        <callData> killFunctionSig </callData>
        <callValue> _ </callValue>
        <wordStack> .WordStack </wordStack>
        <pc> 0 => #sizeByteArray(prefix) -Int 2 </pc>
        <endPC> #sizeByteArray(prefix) -Int 2 </endPC>
        <gas> VGAS => ?_ </gas>

        <static> false </static>
        <callDepth> _ </callDepth>
        <selfDestruct> SDS (.Set => SetItem(ACCT)) </selfDestruct>
        <refund> RF => #if ACCT in SDS #then RF #else chop( RF +Int 24000 ) #fi </refund>
        <memoryUsed> 0 </memoryUsed>
        <localMem> .Map </localMem>

        <activeAccounts> ACTIVE_ACCTS </activeAccounts> // Cnew
        <accounts>
          <account>
            <acctID> ACCT </acctID>
            <balance> BAL_FROM => 0 </balance>
            <code> _:WordStack </code>
            <storage> _ </storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
          <account>
            <acctID> killer </acctID>
            <balance> BAL_TO => chop( BAL_TO +Int BAL_FROM ) </balance>
            <code> _:WordStack </code>
            <storage> _ </storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
          ...
        </accounts>
    requires
        ACCT =/=Int killer
        andBool VGAS >Int 100000
        andBool killer in ACTIVE_ACCTS  // TODO

endmodule
