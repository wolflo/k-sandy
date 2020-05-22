requires "../prefix.k"

module PREFIX-SELFDESTRUCT-NONEXISTANT-VAL0-SPEC
    imports PREFIX

    rule <k> #execute => #halt </k>
        <mode> NORMAL </mode>
        <schedule> ISTANBUL </schedule>
        <statusCode> EVMC_SUCCESS </statusCode>
        <output> .WordStack </output>
        <touchedAccounts>... ( .Set => SetItem(ACCT) SetItem(killer) ) </touchedAccounts>
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
        <selfDestruct> SDS:Set ( .Set => SetItem(ACCT) ) </selfDestruct>
        <refund> RF => #if ACCT in SDS #then RF #else RF +Word 24000 #fi </refund>
        <memoryUsed> 0 </memoryUsed>
        <localMem> .Map </localMem>

        <activeAccounts> ACCTS:Set </activeAccounts>
        <accounts>
            <account>
                <acctID> killer </acctID>
                <balance> BAL_TO </balance>
                <code> CODE_TO </code>
                <nonce> NONCE_TO </nonce>
                ...
            </account>
            <account>
                <acctID> ACCT </acctID>
                <balance> 0 </balance>
                <code> _:ByteArray </code>
                ...
            </account>
            ...
        </accounts>
    requires
        ACCT =/=Int killer
        andBool #accountEmpty(CODE_TO, NONCE_TO, BAL_TO)
        andBool VGAS >Int 100000
        // andBool notBool killer in ACCTS

endmodule
