requires "../prefix.k"

module PREFIX-CONTINUE-CALLDATASIZE-SPEC
    imports PREFIX

    rule <k> #execute </k>
        <mode> NORMAL </mode>
        <schedule> ISTANBUL </schedule>
        <memoryUsed> 0 </memoryUsed>
        <localMem> .Map </localMem>
        <program> prefix </program>
        <jumpDests> #computeValidJumpDests(prefix) </jumpDests>
        <pc> 0 => #sizeByteArray(prefix) </pc>
        <wordStack> .WordStack </wordStack>
        <gas> VGAS => VGAS -Int 57 </gas>
        <callData> CALLDATA </callData>
        <caller> _ </caller>
    requires
        notBool #sizeByteArray(CALLDATA) ==Int 4
        andBool VGAS >=Int 57

endmodule
