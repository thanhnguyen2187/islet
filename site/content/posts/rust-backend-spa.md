---
title: "Using Rust Backend To Serve An SPA"
date: 2025-05-29T12:49:19+07:00
draft: true
toc: true
tags:
categories:
- explanation
- how-to-guide
---

In web development and deployment, most software engineers are familiar with
either:

1. Separating the built SPA and the backend (Client-Side Rendering), or
2. Return HTML directly from the backend (Server-Side Rendering)

I recently (re)discovered [^rediscovered] that there is a third way, where we
can serve the built SPA by the backend directly.

![](../images/rust-backend-spa.webp)

I think this is a nice approach, as the pros are:

- Simpler deployment, where we don't have to take into account the "destination"
  for the frontend
- Simpler code, where we don't have to take into account CORS and the backend
  endpoint [^simpler-code]

The cons are quite clear:

- No matter how good is it, it's still an unconventional approach; expect lots
  of push back from people
- A little reduced DX of no frontend hot reloading [^simpler-code]

Let's get into how are we doing it with Rust/Axum and Svelte/SvelteKit. While
the code that I'm going to show you is in that specific stack, I think it's not
challenging to adopt the mindset to other languages and frameworks and
libraries.

## Project Structure

I find it hard implement the SPA serving from backend with a polyrepo setup. The
main reason is that with a polyrepo setup (one repository for frontend, and
another for a backend), we have no structure for the build at all, unless we
"cheat" by implementing an aggregation repository that refers to both the
frontend and the backend [^polyrepo-tool].
- 


## 

[^rediscovered]: Actually that's what meta-frameworks like NextJS and SvelteKit
    are doing if we use the "NodeJS output mode" from them.
[^simpler-code]: Digging deeper into this, it can be a trade-off between DX and
    complexity. In more details there are two approaches:

    - Try to keep the frontend as close to the "traditional" SPA approach as
      possible by still doing `npm run dev` and have `PUBLIC_BASE_URL`, and
      handle the deployment where we set `PUBLIC_BASE_URL` to empty, and let the
      fetches go to `window.origin`. The approach means DX goes up, and so does
      the complexity.

      ```ts
      import { PUBLIC_BASE_URL } from "$env/static/public";

      const baseUrl = PUBLIC_BASE_URL === ""
        ? window.origin
        : PUBLIC_BASE_URL;
      const url = new URL("/api/data", baseUrl)
      const resp = await fetch(url);
      ```

    - We just assume that the frontend is being served by the backend; there is
      no difference between the development environment and production
      environment. This approach means DX goes down a tiny bit, and complexity
      also goes down.

      ```ts
      const resp = await fetch("/api/data");
      ```

[^polyrepo-tool]: I'm aware that we have `git submodule` and `git subtree`.
