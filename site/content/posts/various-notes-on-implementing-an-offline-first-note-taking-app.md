---
title: "Various Notes on Implementing An Offline-first Note Taking App"
date: 2024-06-14T19:30:06+07:00
draft: true
toc: true
images:
categories:
  - explanation
  - how-to-guide
tags:
  - triplit
  - wa-sqlite
  - offline-first
  - opfs
---

## Story / Introduction?

I had these ideas for a "great" note taking app for a while: offline-first with
optimistic updates, fast copying and pasting, and built-in
encryption/decryption, and simple self-hosting. Notion, Evernote, Notesnook, and
many other note-taking apps tick a few of the boxes, but not all of them. I also
feel like it can be a fun way to improve my front-end and product building
skills, so I started this "great quest" to create my ideal app. After a few
months working on it, I think apart from got something up and running, I gained
a pretty okay view on the "offline-first paradigm" and learned many interesting
things. In this post, apart from serving as a personal journal, I hope that it
can bring in some good insights for the readers.

List the tools as they anchor well serve chronologically

## CouchDB/PouchDB/RxDB

I list them together as they built upon each other:

- CounchDB leads the way with the synchronization protocol
- PounchDB uses the protocol and add offline-first/in-browser storage and
  real-time updates
- RxDB, while leverages PouchDB underneath, aims to make the underlying data
  storage "swappable", and thus provides more flexibility for multi-platform
  apps

I guess I would have gone with RxDB or PounchDB, should their integration with
Vite be more seamless. PounchDB writes data to the global `window`, while Vite
does not expose that. RxDB is built on top of PounchDB, so it has the same
issue. 

## IndexedDB/OPFS

While researching about RxDB, I realized that there is IndexedDB and OPFS that
also works well as the storage layer. Did not think too far ahead about data
synchronization and data querying, I decided to use OPFS instead.

- OPFS: stands for Origin Private File System, which... follow its name, a File
  System. The abstraction layer includes "folder", and "file"
