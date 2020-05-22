requires "../prefix.k"

module PREFIX-SELFDESTRUCT-SELF-SPEC
    imports PREFIX

    rule <k> #execute => #halt </k>
        <mode> NORMAL </mode>
        <schedule> ISTANBUL </schedule>
        <statusCode> EVMC_SUCCESS </statusCode>
        <output> _ => .ByteArray </output>
        <touchedAccounts>... (.Set => SetItem(killer)) ...</touchedAccounts>
        <program> prefix </program>
        <jumpDests> #computeValidJumpDests(prefix) </jumpDests>
        <id> killer </id>
        <caller> killer </caller>
        <callData> killFunctionSig </callData>
        <callValue> _ </callValue>
        <wordStack> .WordStack </wordStack>
        <pc> 0 => #sizeByteArray(prefix) -Int 2 </pc>
        <endPC> #sizeByteArray(prefix) -Int 2 </endPC>
        <gas> VGAS => ?_ </gas>

        <static> false </static>
        <callDepth> _ </callDepth>
        <selfDestruct> SDS (.Set => SetItem(killer)) </selfDestruct>
        <refund> RF => #if killer in SDS #then RF #else RF +Word 24000 #fi </refund>
        <memoryUsed> 0 </memoryUsed>
        <localMem> .Map </localMem>

        <activeAccounts> _ </activeAccounts>
        <accounts>
          <account>
            <acctID> killer </acctID>
            <balance> _ => 0 </balance>
            <code> _:ByteArray </code>
            <storage> _ </storage>
            <origStorage> _ </origStorage>
            <nonce> _ </nonce>
          </account>
          ...
        </accounts>
    requires
        VGAS >Int 100000

endmodule
