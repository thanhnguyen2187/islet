---
title: "SICP 4.44"
date: 2022-05-09T21:56:38+07:00
draft: false
toc: true
images:
categories:
  - explanation
tags:
  - sicp
  - lisp
  - scheme
---

It has been a while since my last post (and also a while since I have last
written about SICP). The main reason is that I struggled with Chapter 4 a lot,
and only have been escaped the struggle by discovering "the one true REPL-driven
programming". The post on how to setup SICP with Vim will be updated at a later
time, I hope. For now, I am going to show you my solution to SICP 4.44, which is
something quite fun that I worked on.

## Description

> **Exercise 4.44**: Exercise 2.42 described the "eight-queens puzzle" of
> placing queens on a chessboard so that no two attack each other. Write a
> nondeterministic program to solve this puzzle.

## Eight-queens Puzzle

Let us assume that you are a well-versed Computer Science person, if you
actively read my blog and clicked on this my post about SICP and stuff, but...
Alright. Again, let us assume that you know basic chess rules. There is a rule
about how can queens move: anywhere they want, horizontally, vertically, or
diagonally.

![moves-of-the-queen](https://www.chessvariants.com/d.chess/queenmov.gif)

Find a way (or different ways) that eight (n) queens can be placed on a 8 x 8 (n
x n) board.

## Representing Chess Board

Looking at the problem, we can instinctively think of representing the board as
a 2D map, with `x`s, and `y`s as the coordinations. For example, position `(1
3)` is something like this:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   |     |     |     |     |     |     |     |     |
| 1   |     |     |     | ♕   |     |     |     |     |
| 2   |     |     |     |     |     |     |     |     |
| 3   |     |     |     |     |     |     |     |     |
| 4   |     |     |     |     |     |     |     |     |
| 5   |     |     |     |     |     |     |     |     |
| 6   |     |     |     |     |     |     |     |     |
| 7   |     |     |     |     |     |     |     |     |

## The "Naivest" Approach That Actually Works

Our naivest (and actually works) approach then is to pick one position to put
the queen, again and again, and hope that the picking somehow works out in the
end:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   | 1 🗸 |     |     |     |     |     |     |     |
| 1   |     |     | 2 🗸 |     |     |     |     |     |
| 2   |     | 3 ✗ |     |     |     |     |     |     |
| 3   |     |     |     |     |     |     |     |     |
| 4   |     |     |     |     |     |     |     |     |
| 5   |     |     |     |     |     |     |     |     |
| 6   |     |     |     |     |     |     |     |     |
| 7   |     |     |     |     |     |     |     |     |

```
1. Pick position (0 0): success 🗸
2. Pick position (1 2): success 🗸
3. Pick position (2 1): fail ✗, since it lies in the same diagonal with (1 2)
```

What matter is how we pick those positions. In the simplest way, we can:

- Generate `(0 0) (0 1) (0 2) ... (1 0) (1 1) (1 2) ... (7 5) (7 6) (7 7)`
- Try to pick 8 positions
- See if the newly-created solution is valid

In this way, we have to wade through `64 * 63 * ... * 57` solutions, which is
roughly `O(n^n)`, not counting the ways that we have to check for the validation
itself. It is not something feasible for our poor computers!

Let us find a better way by more observing:

- After picking a position, every other position with the same row, and the same
  column is going to be left out:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   | 1 🗸 | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   |
| 1   | ✗   |     |     |     |     |     |     |     |
| 2   | ✗   |     |     |     |     |     |     |     |
| 3   | ✗   |     |     |     |     |     |     |     |
| 4   | ✗   |     |     |     |     |     |     |     |
| 5   | ✗   |     |     |     |     |     |     |     |
| 6   | ✗   |     |     |     |     |     |     |     |
| 7   | ✗   |     |     |     |     |     |     |     |

- Again, pick another position (let us skip the constraint on diagonal lines
  here):

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   | 1 🗸 | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   |
| 1   | ✗   | 2 🗸 | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   |
| 2   | ✗   | ✗   |     |     |     |     |     |     |
| 3   | ✗   | ✗   |     |     |     |     |     |     |
| 4   | ✗   | ✗   |     |     |     |     |     |     |
| 5   | ✗   | ✗   |     |     |     |     |     |     |
| 6   | ✗   | ✗   |     |     |     |     |     |     |
| 7   | ✗   | ✗   |     |     |     |     |     |     |

- Again, pick another position:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   | 1 🗸 | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   |
| 1   | ✗   | 2 🗸 | ✗   | ✗   | ✗   | ✗   | ✗   | ✗   |
| 2   | ✗   | ✗   | ✗   | 3 🗸 | ✗   | ✗   | ✗   | ✗   |
| 3   | ✗   | ✗   |     | ✗   |     |     |     |     |
| 4   | ✗   | ✗   |     | ✗   |     |     |     |     |
| 5   | ✗   | ✗   |     | ✗   |     |     |     |     |
| 6   | ✗   | ✗   |     | ✗   |     |     |     |     |
| 7   | ✗   | ✗   |     | ✗   |     |     |     |     |

No matter how we pick it, the next position's `x` is not going to be the
previous ones' `x`. `y` has the same pattern. We then come to a simple
conclusion: the `x`s of our solution is going to be a permutation of `0` to `7`;
same goes for the `y`s.

Which means, within our algorithm, instead of:

```
1. Pick position
2. See if it is valid
3. Pick position
4. See if it is valid
5. Pick position
6. See if it is valid
...
```

We can do:

```
1. Choose a permutation
2. Choose a permutation
3. Generate the pair as positions
4. See if it is valid
```

For a really simple example, with `n = 5`, I am going to have this:

```
(range 0 8 1)
; (0 1 2 3 4 5 6 7)

(a-permutation-of (range 0 8 1))
; A possible result: (0 1 2 3 4 5 6 7)
; Another possible result: (2 1 3 4 0 5 7 6)

(zip (range 0 4 1) (range 4 8 1))
; ((0 4) (1 5) (2 6) (3 7))

(define xs (a-permutation-of (range 0 8 1)))
(define ys (a-permutation-of (range 0 8 1)))
(define positions (zip xs ys))
```

The new approach's complexity gets a bit better: `O(n!)`. There is only one
piece left to solve: how can we check that the generated positions do not have
lie on the same diagonal?

Let us focus on the "first" diagonal:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   | *   |     |     |     |     |     |     |     |
| 1   |     | *   |     |     |     |     |     |     |
| 2   |     |     | *   |     |     |     |     |     |
| 3   |     |     |     | *   |     |     |     |     |
| 4   |     |     |     |     | *   |     |     |     |
| 5   |     |     |     |     |     | *   |     |     |
| 6   |     |     |     |     |     |     | *   |     |
| 7   |     |     |     |     |     |     |     | *   |

Its positions are:

```
; the first line
(0 0)
(1 1)
(2 2)
(3 3)
; ...
```

The first line's "previous" and "next" are like this:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   |     | *   |     |     |     |     |     |     |
| 1   | *   |     | *   |     |     |     |     |     |
| 2   |     | *   |     | *   |     |     |     |     |
| 3   |     |     | *   |     | *   |     |     |     |
| 4   |     |     |     | *   |     | *   |     |     |
| 5   |     |     |     |     | *   |     | *   |     |
| 6   |     |     |     |     |     | *   |     | *   |
| 7   |     |     |     |     |     |     | *   |     |

```
; the "previous" line
(1 0)
(2 1)
(3 2)
(4 3)
; ...

; the "next" line
(0 1)
(1 2)
(2 3)
(3 4)
```

We then see a pattern:

- If the *difference* (`(- (x-of position) (y-of position))`) is the same, then
- the two position lies on the same diagonal.

For example position 1 `(1 0)` lies on the same diagonal with position 3 `(5
4)`, since `(- 1 0)` and `(- 5 4)` both returns `1`. We cannot say the same for
position 2 `(5 1)`.

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   |     |     |     |     |     |     |     |     |
| 1   | 1.  |     |     |     |     |     |     |     |
| 2   |     | *   |     |     |     |     |     |     |
| 3   |     |     | *   |     |     |     |     |     |
| 4   |     |     |     | *   |     |     |     |     |
| 5   |     | 2.  |     |     | 3.  |     |     |     |
| 6   |     |     |     |     |     |     |     |     |
| 7   |     |     |     |     |     |     |     |     |

Let us look at another "first" diagonal:

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   |     |     |     |     |     |     |     | *   |
| 1   |     |     |     |     |     |     | *   |     |
| 2   |     |     |     |     |     | *   |     |     |
| 3   |     |     |     |     | *   |     |     |     |
| 4   |     |     |     | *   |     |     |     |     |
| 5   |     |     | *   |     |     |     |     |     |
| 6   |     | *   |     |     |     |     |     |     |
| 7   | *   |     |     |     |     |     |     |     |

The positions are:

```lisp
(0 7)
(1 6)
(2 5)
(3 4)
; ...
```

And its "next", and "previous":

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   |     |     |     |     |     | *   |     |     |
| 1   |     |     |     |     | *   |     |     | *   |
| 2   |     |     |     | *   |     |     | *   |     |
| 3   |     |     | *   |     |     | *   |     |     |
| 4   |     | *   |     |     | *   |     |     |     |
| 5   | *   |     |     | *   |     |     |     |     |
| 6   |     |     | *   |     |     |     |     |     |
| 7   |     | *   |     |     |     |     |     |     |

The positions are:

```lisp
; the "previous" diagonal
(0 5)
(1 4)
(2 3)
(3 2)
; ...

; the "next" diagonal
(1 7)
(2 6)
(3 5)
(4 4)
; ...
```

We see the same pattern, but instead of *difference*, we have *sum*.

For example, position 1 `(0 6)` lies on the same diagonal with position 3 `(6
0)`, since the sum of each is `6`.

|     |     |     |     |     |     |     |     |     |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| x   | 0   | 1   | 2   | 3   | 4   | 5   | 6   | 7   |
| 0   |     |     |     |     |     |     | 1.  |     |
| 1   |     |     |     |     |     | *   |     |     |
| 2   |     |     |     |     | *   |     |     |     |
| 3   |     |     |     | *   |     |     |     |     |
| 4   |     |     | *   |     |     |     |     |     |
| 5   |     | *   |     |     | 2.  |     |     |     |
| 6   | 3.  |     |     |     |     |     |     |     |
| 7   |     |     |     |     |     |     |     |     |

Checking if two of no two positions have lie on the same diagonal is damn
simple:

```lisp
(define diagonals-1
  (map (lambda (position)
         (- (x-of position)
            (y-of position)))
       positions))

(define diagonals-2
  (map (lambda (position)
         (+ (x-of position)
            (y-of position)))
       positions))

(distinct? (list 1 2 3))
; true
(distinct? (list 1 1 3))
; false

(require (distinct? diagonals-1))
(require (distinct? diagonals-2))
```

## Nondeterministic Program

This section in SICP explained it clearly:

> Basically, a nondeterministic program's interpreter allows the usage of a
> special form called `amb`:
>
> ```lisp
> (amb <e_1> <e_2> ... <e_n>)
> ```
>
> ... [`amb`] returns the value of one of the *n* expressions <e_i>
> "ambiguously".
>
> For example
>
> ```lisp
> (list (amb 1 2 3)
>       (amb 'a 'b))
> ```
>
> Can have six possible values:
>
> ```lisp
> (1 a) (1 b) (2 a) (2 b) (3 a) (3 b)
> ```

## Final Solution

Stripping all the "essential" functions, our program is just this:

```lisp
(define (solve board-size)

  (define xs (a-permutation-of (range 0 board-size 1)))
  (define ys (a-permutation-of (range 0 board-size 1)))
  (define (x-of position)
    (car position))
  (define (y-of position)
    (cadr position))

  (define positions
    (zip xs ys))

  (define diagonals-1
    (map (lambda (position)
           (- (x-of position)
              (y-of position)))
         positions))

  (define diagonals-2
    (map (lambda (position)
           (+ (x-of position)
              (y-of position)))
         positions))

  (require (distinct? diagonals-1))
  (require (distinct? diagonals-2))

  positions)

(solve 5)
; ((0 0) (1 2) (2 4) (3 1) (4 3))
; try-again
; ((0 0) (1 3) (2 1) (3 4) (4 2))
```

The full code can be found on my GitHub.

## Conclusion

In the end, I walked you through the solving of excerise 4.44 of SICP. The code
is probably a bit "`amb` evaluator" specific, but I hope that the solving
approach is good and clear to be implemented in any other language. In short,
instead of:

```
- Choose one of `n * n` positions
- Check validity
- Choose another position from those `n * n` positions
- Check validity
```

This approach of using permutation is much better:

```
- Choose one permutation
- Choose one permutation
- Pair the two permutations into positions
- Check diagonal validity
```
