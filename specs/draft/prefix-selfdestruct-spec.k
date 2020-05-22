requires "../prefix.k"

// case ACCTTO == ACCT - not a possible state with sandy, but necessary to fully specify prefix
// case ACCTTO not in active accounts
    // case val == 0
    // case val > 0

module PREFIX-SELFDESTRUCT-SPEC
    imports PREFIX

    rule <k> #execute => #halt </k>
        <mode> NORMAL </mode>
        <schedule> ISTANBUL </schedule>
        <statusCode> EVMC_SUCCESS </statusCode>
        <output> _ => .ByteArray </output>
        <touchedAccounts>... (.Set => SetItem(ACCT) SetItem(killer)) ...</touchedAccounts>
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
        <refund> RF => #if ACCT in SDS #then RF #else RF +Word 24000 #fi </refund>
        <memoryUsed> 0 </memoryUsed>
        <localMem> .Map </localMem>

        <activeAccounts> ACCTS </activeAccounts> // Cnew
        <accounts>
          <account>
            <acctID> ACCT </acctID>
            <balance> BAL_FROM => 0 </balance>
            <code> _:ByteArray </code>
            <storage> _ </storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
          <account>
            <acctID> killer </acctID>
            <balance> BAL_TO => BAL_TO +Word BAL_FROM </balance>
            <code> _:ByteArray </code>
            <storage> _ </storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
          ...
        </accounts>
    requires
        killer in ACCTS  // TODO
        andBool ACCT =/=Int killer
        andBool VGAS >Int 100000

endmodule
