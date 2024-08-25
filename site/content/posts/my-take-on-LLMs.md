---
title: "My Take on LLMs"
date: 2024-08-25T20:16:58+07:00
draft: false
toc: true
images:
categories:
tags:
  - llm
  - ai
  - claude
  - chatgpt
  - supermaven
---

My career began in Natural Language Processing, and I've studied the mathematics
and theories behind AI extensively. So when ChatGPT took the world by storm, I
approached it with skepticism. I viewed Large Language Models (LLMs) as
sophisticated "next word predictors" -- black boxes that ingest vast amounts of
data and generate plausible word sequences from initial prompts, and felt that
The hype surrounding LLMs seemed overblown. I struggled to see how these
"predictors" could revolutionize our work and lives. However, curiosity and a
touch of boredom eventually led me to explore the world of LLMs.

## Dumb Code Generator, Reading Partner, and Code Kick-starter

My first practical application of LLMs came when I faced the task of creating
numerous Golang API endpoints with similar structures but minor differences.
These attributes made deduplication challenging. To my surprise, I found LLMs
incredibly useful for generating simple, pattern-based code. They saved time and
reduced errors in these tedious tasks.

Experimenting with LLM-aided reading was a revelation. The experience surpassed
traditional reading in many ways:

- It offered a more interactive learning process.
- LLMs could reference additional sources for deeper explanations.
- It enabled real-time interrogation of the text.

The approach of using LLMs as reading partner made reading complex texts more
accessible and engaging. For instance, when I needed to skim through lengthy,
complex regulation documents, using LLMs to summarize the text and answer
follow-up questions proved highly effective.

Taking it a step further, I began using LLMs as first draft writers and project
kick-starters. They excelled at initiating writing projects and providing a
solid foundation for side projects. I could request initialization commands and
receive a "good enough" project structure to build upon.

## Limitations

Despite their benefits, LLMs have significant limitations. To understand these,
let's simplify the LLM working model into two components:

- "Short-term memory", more commonly referred as context length, which store
  what the LLMs can refer to directly right now, and
- "Long-term memory", which is the synthesis of all data used to create the LLM
  (books, internet comments, articles, etc.) [^llms-long-term-memory].

The limited context length means LLMs struggle with longer documents or keeping
large codebases in mind. While we can work around this by dividing knowledge
into smaller pieces or creating summarizations, the limitations of the
"long-term memory" are more challenging to overcome.

There's a wealth of tacit and "esoteric" knowledge that LLMs don't possess in
their "long-term memory." Creating new, nuanced, and complex code, especially in
niche domains where knowledge isn't widely available, remains a significant
challenge for LLMs. Even when writing this "relatively simple" blog post, I
found that while LLMs can produce a decent first draft, they struggle to fully
capture personal experiences or develop more complex arguments without making
the process feel convoluted [^claude-blog-draft].

## Useful LLM Tools and Notes

- [Supermaven](https://supermaven.com): I've found its focus on rapid code
  generation particularly useful for producing straightforward code. The free
  version has been sufficient for my needs, and I highly recommend it.
- [Claude](https://claude.ai): I use Claude for reading assistance and even
  drafted parts of this post with it. Compared to ChatGPT, I appreciate its
  longer context ([200,000
  tokens](https://support.anthropic.com/en/articles/7996856-what-is-the-maximum-prompt-length)
  comparing to [128,000
  tokens](https://platform.openai.com/docs/models/gpt-4o)), and its more precise
  recall abilities. Claude was able to pinpoint an almost exact location in a
  regulation document I provided, while ChatGPT couldn't. For documents
  exceeding Claude's context length, splitting them into manageable parts (e.g.,
  dividing a large book into chapters) and requesting summarizations works well.
- [ChatGPT](https://chatgpt.com): The tool excels at simpler tasks like
  improving wording or general brainstorming.

## Final Thoughts

Despite their current limitations, LLMs have become an invaluable tool in my
workflow. They've transformed how I approach various tasks, from coding to
writing and researching. I'm excited about future developments in this field.
While I believe LLMs can aid [^aider] us in various tasks, I don't foresee them
replacing human judgment anytime soon.

## Footnotes

[^llms-long-term-memory]: While there is actual research on "long-term memory
for LLMs", I'm referring to their "plausible text generation ability".
Scientifically speaking, LLMs do not have memory at all:
https://datascience.stackexchange.com/questions/122225/will-llms-accumulate-its-skills-after-each-time-it-is-taught-by-one-in-context-l.
[^claude-blog-draft]: You can view an example of this on Telegraph, as I
couldn't find a way to share my Claude conversation:
https://telegra.ph/Prompt-and-Draft-for-My-Take-on-LLMs-08-25.
[^aider]: There is actually a tool named
[Aider](https://github.com/paul-gauthier/aider) that promises complex
feature coding. I experimented with Aider using the OpenAI API, but found it
required significant hand-holding to be useful, so I abandoned it after a
while.

