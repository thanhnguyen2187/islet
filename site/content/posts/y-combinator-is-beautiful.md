---
title: "Y Combinator Is Beautiful"
date: 2022-02-22T20:31:19+07:00
draft: false
toc: false
images:
categories:
tags:
  - lisp
  - computer-science
---

"Y Combinator" is the name of a "meta" startup (one that powers other startups),
and also is considered the most beautiful term of Computer Science, or Lambda
Calculus.

You may encountered this kind of post somewhere else, but I cannot stop doing
the same. It blown my mind. Spares the techinal jargons, we should just jump
straight into Lisp code. I will try to go step by step in the hope that you will
"get" it.

The "simplest" function of Lisp is this `identity` function, or a function that
takes something and return the thing it took:

```lisp
(lambda (x) x)
```

To apply (or "run") a function, we wrap that function definition around a
bracket:

```lisp
((lambda (x) x) 1)
; returns 1
((lambda (x) x) 2)
; returns 2
```

We have nothing against letting `x` a function, which means it can take itself,
and return itself:

```lisp
((lambda (x) x) (lambda (x) x))
; (lambda (x) x)
```

For the sake of... messing around, can we do it better? Can we have a function
which takes something, and comes back to the state that it takes something?

We surely do.

```lisp
((lambda (x) (x x)) (lambda (x) (x x)))
```

We are seeing something really beautiful here. Again, to be more clarified,
`apply`ing something is just to "substitute" the variables. In this simple
function, `x` is substituted by `1`, and the final result is `1`, as you have
guessed.

```lisp
;         +--+
;         |  |
;         |  v
((lambda (x) x) 1)
;         ^     |
;         |     |
;         +-----+
```

Let us come to that function which

> takes something, and comes back to the state that it takes something

```lisp
;         +-----+
;         |     |
;         +---+ |
;         |   | |
;         |   v v
((lambda (x) (x x)) (lambda (x) (x x)))
;         ^            |
;         |            |
;         +------------+
```

We apply the same principle again. `x` is substituted by `(lambda (x) (x x))`
within the first lambda, which gives us the same application. Freaky, is it not?

What if we take a further step, and try to find a way to make other functions
work like that? We then have this:

```lisp
((lambda (f)
    ((lambda (x) (f (x x)))
     (lambda (x) (f (x x))))))
```

We can "cheat" a little bit, and use the name `Y` for that newly-discover
function. Let us say that we have `F`, which is another function:

```lisp
(Y F)
; becomes
((lambda (x) (F (x x)))
 (lambda (x) (F (x x))))
; becomes
(F ((lambda (x) (F (x x)))
    (lambda (x) (F (x x)))))
; becomes
(F (F (lambda (x) (F (x x)))
      (lambda (x) (F (x x)))))
; becomes
(F (F (F (...))))
```

Which can be shortened to:

```lisp
(= (Y F)
   (F (Y F)))
```

Congratulation on founding "Y Combinator" (pun intended)!

