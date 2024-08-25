---
title: "My Take on LLM"
date: 2024-08-25T20:16:58+07:00
draft: true
toc: true
images:
categories:
tags:
  - llm
---

My first job was in Natural Language Processing. I did study the math and the
theories behind. Therefore, when ChatGPT took the world by storm, it made me
skeptical. The hype surrounding Large Language Models seemed overblown, and I
couldn't see how a "next word predictor" could revolutionize our work and lives.
However, curiosity and boredom got the better of me, and I decided to dip my
toes into the LLM waters.

## "Smart" Code Generator, Reading Partner, and Kick-starter

For more context, at first, I was tasked with quite a few Golang API endpoints
with the same structure, but minor differences that make deduplicating them
challenging. I found that for simple code that could be derived from existing
patterns, AI was surprisingly useful. It saved time and reduced errors in this
kind of work.

Experimenting with LLM-aided reading was a revelation. The experience felt
superior to traditional reading in many ways:

- The progress was more interactive.
- AI could refer to other sources for deeper explanations.
- It allowed for real-time interrogation of the text.

This approach made complex texts more accessible and engaging.

Taking it a step further, I began using LLMs as a first draft writer and as a
kick-starter for code structure. This approach provided a solid foundation to
build upon, significantly speeding up the initial phases of projects.

## Limitations

Despite its benefits, LLM isn't without limitations. From my personal
experience, the most significant constraint is context length. For instance,
when reading long books, the entire text often can't fit into the LLMs' context
window, requiring us to divide it into smaller parts. This limitation might also
hinder more complex problem-solving scenarios, as for those situations, there
are also too much data to handle (large and intertwined code bases, for
example). Human struggles with tacit knowledge and "esoteric" knowledge, and I
doubt LLMs can do better.

Creating new, nuanced, and complex code, especially in niche domains where
knowledge isn't widely available is one such thing that I don't think LLMs will
ever do well. As I wrote about using AI as a first draft writer, I think it does
that well, but for refining the writing and making the final writing cohesive,
LLMs won't be as effective [1].

## Useful LLMs and Workarounds

- Supermaven: I found its focus on code generation speeds fits my usage,
  generating dumb code, well. I'm happy enough with the free version.
- Claude: 
