---
title: "Learning Solidity Notes"
date: 2023-08-05T15:54:01+07:00
draft: true
toc: true
images:
categories:
  - explanation
  - how-to-guide
  - reference
tags:
  - solidity
  - smart-contract
  - foundry
---

As you may or may have not know it, I worked with blockchain data (EVM smart
contract event to be precise) a lot. I feel like working as an engineer in the
blockchain/cryptocurrency domain, data-related or not, understanding smart
contract is a fundamental skill. Even though I had a rudimentary knowledge of
the landscape, I feel like the act of writing/implementing smart contracts
myself could really benefit me if I want to go further in the domain career-wise
(despite all the turbulence and negativity, I still feel like
blockchain/cryptocurrency has a bright future ahead, and I want to continue
working with it). The post's title includes "Notes", but I hope that it can
serve as a reference for personal usage.

## Blockchain

### Gas

> Gas refers to the unit that measures the amount of computational effort
> required to execute specific operations on the Ethereum network.

Source: https://ethereum.org/en/developers/docs/gas/

## Toolchain

I found that there are a few prominent frameworks for Solidity development:

- Hardhat
- Truffle
- Foundry

I went with Foundry for its blazing fast™ marketing. Getting started with it had
a few gotchas since my operating system is NixOS, a quite esoteric Linux.

### Installing Foundry

There are a few ways picked. The easiest way is to run a command for `foundryup`
like `rustup` but I went with `cargo` installation from source since NixOS does
not play well with that kind of "traditional" installation.

```shell
cargo install \
    --git https://github.com/foundry-rs/foundry \
    --profile local \
    --force foundry-cli anvil chisel
```

### Scaffolding A New Project:

The command itself is simple:

```shell
forge init my_project_name
```

However, it automatically create an initialization commit for you, and it
requires globally set Git name and email.

```
Initializing /home/thanh/Sources/thanhnguyen2187/my_project_name...
Error:
failed to commit (code=Some(128), stdout="", stderr="Author identity unknown\n\n*** Please tell me who you are.\n\nRun\n\n  git config --global user.email \"you@example.com\"\n  git config --global user.name \"Your Name\"\n\nto set your account's default identity.\nOmit --global to set the identity only in this repository.\n\nfatal: unable to auto-detect email address (got 'thanh@nixos.(none)')")
```

The command runs normally with `--no-commit`:

```shell
forge init my_project_name
```

### Testing

Normally, we do:

```shell
forge test
```

But `--gas-report` can also be useful:

```shell
forge test --gas-report
```

Making it more verbose can also be useful:

```shell
# Logs emitted during tests are also displayed. That includes assertion errors
# from test, showing information such as expected vs actual.
forge test -vv

# Stack traces for failing tests are also displayed.
forge test -vvv
```

> Test are deployed to `0xb4c79daB8f259C7Aee6E5b2Aa729821864227e84`. If you
> deploy a contract within your test, then `0xb4c...` will be its deployer. If
> the contract deployed within a test gives special permissions to its deployer,
> such as `Ownable.sol`'s `onlyOwner` modifier, then the test contract
> `0xb4c...` will have those permissions.

To "mock" `msg.sender`, we use `vm`:

```solidity
vm.prank(another_address);
contract.call_my_function();
```

To check emitted events, we also use `vm`:

```solidity
// in the original contract and the test contract, we define this event
event Transfer(address indexed _from, address indexed _to, uint256 _amount);

// then we use `vm.expectEmit`
// and `emit` our expected event
vm.expectEmit(true, true, true, true);
emit Transfer(address(0), address(0), 0);

// now we call the function to emit our actual event
contract.emit_actual_event();
```

`vm.expectEmit` is not well-explained in the original document, so here is my
take. We can look at a Solidity event like this:

```solidity
event MyEvent(
    uint256 argument_1,
    uint256 argument_2,
    uint256 argument_3,
    uint256 argument_4
)
```

An event has four "topics", TODO

We can imagine that the signature for `vm.expectEmit` is:

```solidity
function expectEmit(
    bool check_indexed_topic_1,
    bool check_indexed_topic_2,
    bool check_indexed_topic_3,
    bool check_data
) {
    ...
}
```

Which means in the test contract, when we do:

```solidity
event Transfer(address indexed _from, address indexed _to, uint256 _amount);

vm.expectEmit(true, true, true, true);
emit Transfer(address(0), address(1), 2);
```

TODO

We are checking 

Sources:

- https://book.getfoundry.sh/forge/writing-tests
- https://book.getfoundry.sh/cheatcodes/

## Solidity

### Style Guide

The style guide is quite similar to JavaScript, but there is some specialties
that I want to note on underscore prefix and parameters:

> Underscore Prefix for Non-external Functions and Variables
>
> - `_singleLeadingUnderscore`
>
> This convention is suggested for non-external functions and state variables
> (`private` or `internal`). State variables without a specified visibility are
> `internal` by default.
>
> When designing a smart contract, the public-facing API (functions that can be
> called by any account) is an important consideration. Leading underscores
> allow you to immediately recognize the intent of such functions, but more
> importantly, if you change a function from non-external to external (including
> `public`) and rename it accordingly, this forces you to review every call site
> while renaming. This can be an important manual check against unintended
> external functions and a common source of security vulnerabilities (avoid
> find-replace-all tooling for this change).

> Solidity Conventions
>
> - Internal or private state variables or functions should have an underscore
>   prefix.

> Parameters must not be prefixed with an underscore.
>
> ```solidity
> function test(uint256 testParameter1, uint256 testParameter2) {
>     ...
> }
> ```

Sources:

- https://primitivefi.notion.site/Solidity-Style-44daebebfbd645b0b9cbad7075ba42fe
- https://docs.soliditylang.org/en/latest/style-guide.html
- https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/GUIDELINES.md#solidity-conventions

### Function Scope Modifiers (`public`, `external`, `internal`, and `private`)

I found a pretty good answer on Ethereum StackExchange for this:

> As for best practices, you should use `external` if you expect that the
> function will only ever be called externally, and use `public` if you need to
> call the function internally. It almost never makes sense to use the
> `this.f()` pattern, as this requires a real `CALL` to be executed, which is
> expensive. Also, passing arrays via this method would be far more expensive
> than passing them internally.

> - `public`: all can access
> - `external`: cannot be access internally, only externally
> - `internal`: only this contract and contracts deriving from it can access
> - `private`: can be accessed only from this contract

Source: https://ethereum.stackexchange.com/questions/19380/external-vs-public-best-practices

### Data Area Modifiers (`memory`, `calldata`, and `storage`)

> [...] are keywords that define the data area where a variable is stored.
>
> - `memory` should be used when declaring variables (both function parameters
>   as well as inside the logic of a function) that you want stored in memory
>   (temporary), and
> - `calldata` must be used when declaring an external function's dynamic
>   parameters.

> `calldata` is allocated by the caller, while `memory` is allocated by the
> callee.

Source: https://ethereum.stackexchange.com/questions/74442/when-should-i-use-calldata-and-when-should-i-use-memory

### Error Handling

> - `require` for input validation as it's a little more efficient than
>   if/throw.
> - `assert` should be used for runtime error catching.
> - `revert` will revert changes and refund unused gas [...].

Sources:

- https://ethereum.stackexchange.com/questions/15166/difference-between-require-and-assert-and-the-difference-between-revert-and-thro
- https://dev.to/tawseef/require-vs-assert-in-solidity-5e9d

