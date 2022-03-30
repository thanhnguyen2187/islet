---
title: "Blockchain Technical Jargons Mindmap"
date: 2022-03-28T21:50:19+07:00
draft: false
toc: true
images:
categories:
  - explanation
tags:
  - blockchain
  - mindmap
---

I found the idea tree, as a data structure, interesting. It probably maps better
to our brain, where one term can be linked to another. Within this post, I will
try to draw a mindmap for the "techincal jargons" (techical words that belong to
a field) of blockchain, in the hope that it can bring some values to myself and
my readers.

In short, we have this picture:

![blockchain-technical-jargons-mindmap](../images/blockchain-technical-jargons-mindmap.svg)

I did my best to include a small amount of terms that are considered important.
These terms can be used as a base, a root to build our understanding of
blockchain on.

## Bitcoin

Bitcoin, the original blockchain is built on this term: "decentralized ledger".
We are familiar with our bank as a "centralized ledger", in where our
transactions are recorded in one place.

### Decentralized Ledger

In its simplest sense, the end result of a ledger looks like this:

```
...
A: 40
B: 0
C: 100
...
```

Where we can find how much is "A" having within an instant. The content of the
ledger itself looks like this:

```
...
A -> B: 20
B -> C: 40
C -> A: 10
...
```

Where each transaction is recorded, and we can build the end result from those
transaction. Be "centralized" means the end result (how much is one having) and
the content of the ledger (who transferred to whom) is stored in one place, (a
"normal" bank to be precise), and it risks us that the storge's owner can...
change the number.

It means our money is not really controlled by us, and "decentralized ledger"
comes to our rescue! The transactions that build our needed end result is not
stored at one place anymore. Multiple "nodes" (or transactions storing machine)
store does it for us.

Let us assume that we are done with "decentralized ledger", and come to another
question: if multiple machines store those transactions, how do they agree on
new ones?

### Proof of Work

Our last question can be rephrased as: How do the machines that store our
transactions aggree on newly-written transactions? The answer is that: let those
machines agree on a common set of rule for a newly-written transaction.

If the newly-written transaction comes too easy, everyone can generate a valid
history themself. We come to the conclusion: let the process hard. Coming up
with the newly-written transaction is challenging, needs a lot of "work", and
that is the "proof" of its validity.

It is Proof of Work.

People do not like to let their machines work for free. Those machines are
rewarded, and called "miners".

## Ethereum

I consider Ethereum a "generation 2" blockchain, since it upgrades
"decentralized ledger" to "decentralized computer", and comes up with "Proof of
Stake" to replace "Proof of Work". There are a lot of "Ethereum killers", but
I think they are not novelty enough, or at the writing time (March of 2022), I
could not find one yet.

### Decentralized Computer

Our question is: what if we store code along with transactions? The answer is
Ethereum Virtual Machine and its bytecode. With "immutable" code, we are sured
that the computation is also immutable.

"Smart contract" is nothing but that: immutable code. "Token" is the "truer"
"virtual currency" on immutable code. "Non-fungible Token" is another "virtual
currency", that are "non-fungible", a deed of who is owning what.

### Proof of Stake

Proof of Work is condemned for its resource wasteness. Proof of Stake hopes to
solve that by letting the rule be: if a machine "stake" some "coin" (let some
of its owned "coins" be locked), it is the needed "proof" to let it write a new
transaction.

A machine that does the work is called "validator".

## Conclusion

A better name for the post might let the title's "blockchain" be replaced with
"cryptocurrency". I slacked. Sorry for that. It might also raised more question
on:

- How does one actually use Bitcoin/Ethereum to buy something?
- What is "crypto trading"?
- What is "decentralized finance"?
- ...

Many more, but let us hope that the questions actually exist, and I got over my
laziness to write another part of on this.
