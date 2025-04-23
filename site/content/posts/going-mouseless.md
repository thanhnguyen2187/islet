---
title: "Going Mouseless, Or Using The Computer Without a Physical Mouse"
date: 2025-04-13T10:45:24+07:00
draft: false
toc: true
tags:
- vimium
- warpd
- mouseless
- ergonomics
categories:
- how-to-guide
---

I've gone mouseless, or using the computer without a physical mouse, for around
2 months. The supporting tools I used are:

- Vimium: a browser extension for interaction (mainly navigation/links
  following) while browsing the web
- `warpd`: a program to control the mouse in other cases
- A drawing tablet: the last resort if `warpd` cannot make it

To be honest, I don't think there is a huge boost in productivity, but it helps
with concentration as I don't have to move my hands that often anymore. Going
mouseless might aid in preventing common pains and injuries of software
engineers (namely RSI and carpel tunnel) as well. In this post, I'll try to get
into each tool I used and my thoughts about them.

![meme](../images/mouseless-meme.png)

## Vimium

As a software engineer, I spend a lot of time in the browser to skim
library/language documents. At a certain point, scrolling up and down and
jumping between links using the mouse felt like a chore, so I wanted a tool to
help with that. One additional point is that I'm familiar with Vim and its key
binding (I'm drafting and editing this post on Neovim), so Vimium [^vimium]
comes as a natural aid.

Here is a demo of how I use Vimium to scroll up and down in my blog post list:

![vimium-demo](../images/mouseless-vimium-demo.gif)

Another useful feature of Vimium that you might use daily is to:

- Press `f` to highlight clickable links with labels, and then
- Press the keys written on the labels to finally select the one you want

Here is a demo of the feature, where I slowed down a lot to make sure that it's
not too confusing:

![vimium-demo-2](../images/mouseless-vimium-demo-2.gif)

Vimium is a browser plugin and sometimes, you hit the limit of what it can do.
One sticking example that I can think of is that:

- Vimium allows us to use `Ctrl + [label keys]` to open a link in a new tab
- If `[label keys]` ends with `w`, then the key combination becomes `Ctrl + w`,
  which is overridden by a browser to close the current tab instead, which is
  really undesirable

Overall, I think Vimium fits my needs and I don't plan to find a replacement any
time soon. There are alternatives like Qutebrowser [^qutebrowser], and Nyxt
[^nyxt] which in theory is more powerful, but I did not find the time to try
them.

## `warpd`

Vimium served 80% of my browsing scenarios. For the 20% left and when I have to
leave the browser, I reached out to `warpd` [^warpd], which touts itself as 

> a modal keyboard-driven virtual pointer

Let's go with a demo, where I try to move my cursor (which currently is a red
dot) and click on a link:

![warpd-demo](../images/mouseless-warpd-demo.gif)

(I turned `screenkey` [^screenkey] on to better show how I used the keyboard to
control the cursor, but it didn't work and only able to capture the first
`Window + Alt + c`, which is the combination to start `warpd`; additionally,
having the red dot overlap the normal cursor seems like a bug)

Despite being a reliable tool, I must admit that there are some caveats:

- It's barely updated (the last GitHub commit is 3 years ago)
- It only works in Linux X11. Wayland is partially supported (Sway/wlroots and
  no Gnome)
- High learning curve: I must admit the original key binding of `warpd` is not
  that intuitive (despite being Vim-like, I'm unsure why it uses `e` and `r` to
  scroll up/down). Getting used to the way `warpd` override other keyboard
  shortcuts when it's activated isn't easy, either (let's say we are used to
  being able to `Ctrl + c` after you select a text with our mouse, but as
  `warpd` is taking control of the keyboard, it won't work)
- Unexpected bugs: sometimes it renders the software unusable (when the cursor's
  movable area is totally off from the screen; it can be fixed by restarting
  `warpd`'s process), and sometimes it's highly annoying (the cursor is
  overlayed by another on-screen element)

There is `keynav` [^keynav], which works on X11 and is not that feature-ful.
I've heard good words about `hints` [^hints], but did not try it out as... it's
not available on NixOS [^lazy]. Finally, for Wayland users, there is `wl-kbptr`
[^wl-kbptr].

## Drawing Tablet

I have had a drawing tablet for around half a year. In the beginning, before I
went mouseless, it served well as a tool for diagram sketching. After I went
mouseless, it has an additional use: to serve as the ultimate fallback in case
`warpd` cannot make it.

Here is a quick snap of the drawing tablet that I'm using:

![drawing-tablet](../images/mouseless-drawing-tablet.jpg)

It's a XP-Pen Deco V2, which is quite affordable at around 50 dollars. You can
"activate" the tablet pen's main button by pressing the tip down the screen.
There are two additional side buttons which are similar to the smart phone's
volume buttons. My binding for the buttons are:

- The main button: the mouse's left click
- One side button: the mouse's middle button for screen moving
- Another side button: the mouse's right click button

In theory, the drawing tablet could work as a mouse replacement completely.
However, in reality, my multiple monitors usage prevents it from being fully
workable: I'm using two screens, which mean I can either let the tablet covers
the two screens (doesn't fully utilize the pad's screen, and may affect the
input's precision as it's covering an area that is too large), or just let it
cover one screen (I have no way to access the other screen).

Here is an illustration to the problem:

![drawing-tablet](../images/mouseless-drawing-tablet-problem.png)

This is not a post about drawing tablets, so I won't dive too deep into which
one should you choose in case you are intrigued, but we generally have 3 options
[^buying-a-drawing-tablet-guide] :

- Pen tablet: a pen + a pad for drawing that connects to your computer
- Pen display: a pen + a display screen that can be drawn on that connects to
  your computer
- Standalone tablet: a separate computer that is able to receive pen input

I would say you should go with a small pen tablet first, as it's cheap for your
expirement (just give it away or even throw it away in case you don't sketch as
much as expected or don't want to replace your mouse with it).

## Conclusion

I hope I showed you my intriguing setup that replaced the physical mouse and
allow me to just rest my hand on my keyboard all the time. Sometimes, it feels
like a... red herring to a problem: the thinking involved in software
development is hard work; no matter how good my setup is, the hard work is still
there to be done. Then I balance myself with the thought that the "seemingly"
useless effort to avoid being distracted helps me at... concentrating better,
and getting into the flow better to solve harder problems, so it isn't that
useless.

[^vimium]: https://vimium.github.io/
[^screenkey]: https://gitlab.com/screenkey/screenkey
[^qutebrowser]: https://www.qutebrowser.org/
[^nyxt]: https://nyxt.atlas.engineer/
[^warpd]: https://github.com/rvaiya/warpd
[^hints]: https://github.com/AlfredoSequeida/hints
[^keynav]: https://github.com/jordansissel/keynav
[^wl-kbptr]: https://github.com/moverest/wl-kbptr
[^lazy]: I know I suppose to package it myself if I'm a true NixOS user, but
    despite my daily driving of NixOS, I'm still is not that familiar with Nix
    the language.
[^buying-a-drawing-tablet-guide]: A good and detailed guide on picking up a new
    drawing tablet https://docs.thesevenpens.com/drawtab/buying-a-drawing-tablet
