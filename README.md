# delegation-share-poc

Demonstrates an initialization vulnerability based on share calculations

CMD
```shell
forge test -vvv
```
OUTPUT
```shell
[⠰] Compiling...
[⠊] Compiling 1 files with 0.8.17
[⠢] Solc 0.8.17 finished in 567.70ms
Compiler run successful

Running 3 tests for test/POC.t.sol:Poc
[PASS] testDeposit() (gas: 207958)
Logs:
  1 share to how much ETH: 1
  1 share to how much ETH: 101
  User2 get share: 99009900990099009
  User3 get share: 99009900990099009

[PASS] testExploit() (gas: 192013)
Logs:
  1 share to how much ETH: 1
  1 share to how much ETH: 100000000000000000001
  User2 get share: 0
  User3 get share: 0

[FAIL. Reason: value too small] testFixed() (gas: 152578)
Traces:
  [152578] Poc::testFixed() 
    ├─ [112959] → new SimpleFixedShare@0x5615dEB798BB3E4dFa0139dFa1b3D433Cc23b72f
    │   └─ ← 564 bytes of code
    ├─ [271] SimpleFixedShare::deposit{value: 1}() 
    │   └─ ← "value too small"
    └─ ← "value too small"

Test result: FAILED. 2 passed; 1 failed; finished in 922.25µs

Failing tests:
Encountered 1 failing test in test/POC.t.sol:Poc
[FAIL. Reason: value too small] testFixed() (gas: 152578)

Encountered a total of 1 failing tests, 2 tests succeeded
```
