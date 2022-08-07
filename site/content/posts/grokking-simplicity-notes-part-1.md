---
title: "Grokking Simplicity Notes: Part 1"
date: 2022-08-07T21:07:40+07:00
draft: false
toc: true
tags:
- reading-notes
- grokking-simplicity
categories:
---

I wanted to put my notes into a separate repository, but then thought that
writing the things on my blog is fine, too. Hence the post (and series)'s
existence.

## Chapter 1: Welcome to Grokking Simplicity

### What is Functional Programming

I had a "academic" definition for myself. Functional Programming mostly revolves
around two concepts: pure functions, and first-class function.

The book gave relevant definitions:

> **functional programming** (FP), *noun*.
> 1. a programming paradigm characterized by the use of mathematical functions
>    and the avoidance of side effects
> 2. a programming style that uses only pure functions without side effects

But also emphasized that *Grokking Simplicity* is about practical uses of
Functional Programming:

> *Grokking Simplicity* takes a different approach from the typical book about
> functional programming. It is decidedly about the industrial uses of
> functional programming.

> In *Grokking Simplicity*, you won't find the latest research or the most
> esoteric ideas. We're only going to learn the skills and concepts you can
> apply today.

### Side Effects

A definition is given within the book:

> *Side Effects* are anything a function does other than returning a value, like
> sending an email or modifying global state.

I also had more technical jargon for that: *Side Effects* are the result of a
function changing the states that are not in its scope. For example:

```python
# `f` is without side effects since it only returns an increased `a`,
# which is something within `f`'s scope
def f(a: int):
    return a + 1

# `g` is with side effects since `send_email` change the state of another mailbox,
# and the mailbox is not within `g`'s scope
def g():
    send_email(...)
```

### Actions, Calculations, and Data

> Actions depend on when they are called or how many times they are called

> [*Actions* are] anything that depends on when it is run, or how many times it is
> run, or both

I am not sure what is the difference between "actions" and "impure functions",
and why does the author need to have these three definitions, but probably
because I did not read far enough into the book.

> *Calculations* are computations from input to output

Or another term for "pure functions".

> *Data* is recorded facts about events.

Enough said.

### What is Functional Thinking

> Functional thinking is the set of skills and ideas that functional programmers
> use to sole problems with software. This book aims to guide you through two
> powerful ideas that are very important in functional programming:
>
> (1) distinguishing actions, calculations, and data
> (2) using first-class abstractions

