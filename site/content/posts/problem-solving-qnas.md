---
title: "Solving Problems By Writing Out Questions and Answers"
date: 2026-02-20T00:54:00+07:00
draft: false
toc: true
images:
categories:
tags:
---

Recently, I've been solving more and more complex problems. From working on
those, I found a "strategy"/method that worked: to lay out the information
needed as a bunch of questions, then answer them. I want to share the idea
because I think it's very useful in these ways:

- Clarification: creating questions and answers is writing, and it's commonly
  known that writing makes your thinking clearer. It also eases your brain from
  keeping too many details at once [^working-memory]. 
- Communication: it helps explaining it to relevant stakeholders (at least your
  manager) on why something is complex and takes time. Let's say they asked you
  why this seemingly simple 1-line bug fix takes that much time, you can show
  them the evidence from your questions and answers, like you asked what
  assumptions were, and verified those, and asked what are the possible fixes,
  and had to try them all, and the work just took time.
- Reusability: I find that once you've solved a "class" of problems (like
  implementing a new feature of this particular codebase), and documented the
  process, you can use the document as a starting point of other similar tasks.
  It saves you a bit of time and brain power as you have a structure to follow
  instead of just starting afresh. For example, you're tasked with adding CRUD
  endpoints, and made some questions: where should we add the routing code, what
  data model do we add, which SQL query are we going to make, etc. Then for a
  new task that we face, we can just copy the document and replace what's
  changed.
- Resumability: this image explains it better than me

  ![](https://gcdnb.pbrd.co/images/gu6GVDfaqrgB.png?o=1)

  It applies to everyone that once he or she gets interrupted, then tries to go
  back, it's extremely tough. Laid out questions and answers make the resuming
  process easier.

[^working-memory]: Most of us can only hold 4 items in our mind at once. A
    related article: https://www.livescience.com/2493-mind-limit-4.html

The intended audience of this post is firstly myself in the past. Being a new
software engineer, I can recall that when I got started with professional
programming, coding itself was not hard, but mapping the code to the
requirements and making it fit with what existed was tough. I couldn't keep all
the details in my mind, and explaining it to my boss then wasn't easy. I wished
someone would show me how to make things clearer. Now, I'm the one fulfilling
the wish.

Other potential audience includes both newbie software engineers and experienced
software ones. It's obvious how newbies would benefit from the method I'm about
to show. For experienced ones, I just feel like they'd have something similar to
decompose tough problems, and we would benefit from exchanging ideas.

Now, the question is on how. The answer looks simple: write out the questions,
then work on the answers, then actually do whatever's left. Simple is not easy,
however [^simple-made-easy]. The method itself is straightforward, but it's not
painless. The questions and answers are there, in plain sight, but to raise the
right questions is hard sometimes, and finding answers is time-consuming. Even
with the questions and answers laid out, the implementation details will still
give us surprise detours.

[^simple-made-easy]: https://www.youtube.com/watch?v=SxdOUGdseq4

To further illustrate the method, I'll show starter questions that I apply to
most problems I solve:

- What's the current state?
- What's the desired state?
- How do we get from the current state to the desired one?

They morph quite naturally into the specific problems you have.

For example, with a bug fix, you would change the questions to:

- What are the assumptions, or things that are generally true (current state)?
- How would it look after the bug is fixed (desired state)?
- What are the hypotheses, or things to be proven as right or wrong (current
  state to desired state how)? 
- How to prove or disprove the hypotheses (current state to desired state how)?

For a new feature implementation task, assuming that you are clear on the
desired state already, you would change the current state and the how questions
to something like:

- Is there any similar feature that we can reuse as a starting point (current
  state)?
- How do we make sure that implementing it doesn't affect other places in the
  codebase (current state to desired state how)?

It surprisingly works for more complex and ambiguous things, like building a new
software product [^more-concrete-example]. We'd change the questions to:

[^more-concrete-example]: I wanted to give an even more concrete "real-life"
    example (solving a real programming task within a real codebase), but found
    it hard to find one that is truly relatable to the readers and thus really
    explain the method, other than those somewhat vague examples I've shown. I
    still hope that it's clear how to do it: write the questions and answers out
    as a way of "preparation" for the actual implementation.

- How many people are we having (current state)?
- What is the time budget (current state)?
- What would the built product look like (desired state)?
- Which architecture are we choosing (current state to desired state how)?

The best way to understand the method is to try it in your next task. Instead of
jumping straight into writing code, take some time to write down a few questions
about the task at hand. It might feel unnatural at first, but after a while,
you'll notice that tasks solving take less efforts, as the details you care
about weren't scattered anymore. It's akin to

- Swimming in the wrong form (without questions and answers written out), and
- Swimming in the right form (with questions and answers written out)

The correct way would help you swim farther (solve more complex tasks), with
less energy needed (physically for swimming, mentally for programming).

