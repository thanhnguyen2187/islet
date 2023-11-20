---
title: "SICP 5.48"
date: 2023-09-13T23:15:30+07:00
draft: false
toc: true
images:
categories:
  - explanation
tags:
  - lisp
  - sicp
  - scheme
---

## Description

> The `compile-and-go` interface implemented in this section is akward, since
> the compiler can be called only once (when the evaluator machine is started).
> Augment the compiler-interpreter interface by providing a `compile-and-run`
> primitive that can be called from within the explicit-control evaluator as
> follows:
>
> ```lisp
> ;;; EC-Eval input:
> (compile-and-run
> '(define (factorial n)
>    (if (= n 1)
>        1
>        (* (factorial (- n 1)) n))))
>
> ;;; EC-Eval value:
> ok
>
> ;;; EC-Eval input:
> (factorial 5)
>
> ;;; EC-Eval value:
> 120
> ```

I guess even though the description is straight-forward, some layman's
explanation with more context might be easier to be followed:

- We implemented an explicit-control evaluator (or an evaluator in assembly);
  its read-eval-print loop interpret the code "naively".
- We also implemented a `compile-and-go` procedure where we compile a code
  snippet first, and can run the compiled code in our evaluator.
- Now, we need to implement a primitive named `compile-and-run` that also
  "extend" the evaluator in the same way as `compile-and-go`, but is not as
  limited.

## Approach

Luckily, we do have something similar for reference: the function
`compile-and-go` where we compile a procedure first, and somehow get it
"appended" it to the interpreter.

Our reference procedure looks like this:

```lisp
(define (compile-and-go expression)
  (let ((instructions
         (assemble (statements
                    (compile expression 'val 'return))
                   eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    (set-register-contents! eceval 'flag true)
    (start eceval)))
```

I found the book's explanation for `compile-and-go` quite hard to follow, so
here is my annotated version:

```lisp
;; Compile a code snippet and extend an evaluator with the compiled code.
(define (compile-and-go expression)
  ; `statements` is used to "grab" the instruction text resulted from `compile`.
  ; `assemble` is used to enhance the instruction text (various assembly
  ; commands) to actual executable instructions.
  (let ((instructions
         (assemble (statements
                    (compile expression 'val 'return))
                   eceval)))
    (set! the-global-environment (setup-environment))
    (set-register-contents! eceval 'val instructions)
    ; setting `flag` to `true` makes the evaluator execute the instructions
    ; stored within `val` first
    (set-register-contents! eceval 'flag true)
    (start eceval)))
```

We should also look at the relevant assembly code:

```lisp
;;*next instruction supports entry from compiler (from section 5.5.7)
  (branch (label external-entry))
  ...
;;*support for entry from compiler (from section 5.5.7)
external-entry
  (perform (op initialize-stack))
  (assign env (op get-global-environment))
  (assign continue (label print-result))
  (goto (reg val))
```

The "magic trick" in here is to put executable instructions into `val`, and
makes our evaluator run through `val` first. It means if we have a `(define (f
...))`, the evaluator will run through the compiled code. It leads to the
scenario where we are able to use the definition in "normal" read-eval-print
loop.

Apply the same principle in solving this exercise, we naturally come to the
approach of implementing `compile-and-run` that:

- `compile` a code snippet
- Put the compiled code into `val`
- Go through the code in `val`
- Return to the read-eval-print loop

## Implementation

At first, we make sure that `compile-and-run` is recognized as a special name in
the evaluator's loop:

```lisp
eval-dispatch
  (test (op self-evaluating?) (reg exp))
  (branch (label ev-self-eval))
  (test (op variable?) (reg exp))
  (branch (label ev-variable))
  (test (op quoted?) (reg exp))
  (branch (label ev-quoted))
  (test (op assignment?) (reg exp))
  (branch (label ev-assignment))
  (test (op definition?) (reg exp))
  (branch (label ev-definition))
  (test (op if?) (reg exp))
  (branch (label ev-if))
  (test (op lambda?) (reg exp))
  (branch (label ev-lambda))
  (test (op begin?) (reg exp))
  (branch (label ev-begin))
  ;; Exercise 5.48
  (test (op compile-and-run?) (reg exp))
  (branch (label ev-compile-and-run))
  ;;
  (test (op application?) (reg exp))
  (branch (label ev-application))
  (goto (label unknown-expression-type))
```

Then `ev-compile-and-run` comes naturally like this:

```lisp
ev-compile-and-run
  (assign exp (op compile-and-run-exp) (reg exp))
  (save continue)
  (assign continue (label ev-compile-and-run-1))
  (goto (label eval-dispatch))
ev-compile-and-run-1
  (restore continue)
  (assign exp (reg val))
  (assign val (op compile) (reg exp) (const val) (const return))
  (assign val (op statements) (reg val))
  (assign val (op assemble) (reg val))
  (goto (reg val))
```

`compile-and-run-exp` will try to "extract" the needed expression. For example,
if we do `(compile-and-run '(define (factorial n) ...))`, then it would return
`'(define (factorial n) ...)`. The section where we go to `eval-dispatch` is to
make sure that if we pass a variable that contains the code in, then it would
still evaluate correctly.

These assignments:

```lisp
  (assign val (op compile) (reg exp) (const val) (const return))
  (assign val (op statements) (reg val))
  (assign val (op assemble) (reg val))
```

Is not different from the original implementation:

```lisp
(define (compile-and-go expression)
  (let ((instructions
         (assemble (statements
                    (compile expression 'val 'return))
                   eceval)))
    ...))
```

But be noticed of the third line where `(op assemble)` only receives `(reg
val)`, where the original implementation's assemble receives `(statements ...)`
and `eceval`. The reason is that we are going to "hide" `eceval` passing to `(op
assemble)` in this implementation:

```lisp
(define (assemble-eceval controller-text)
  (assemble controller-text eceval))
```

And name it as `assemble` in `eceval-operations`:

```lisp
(define eceval-operations
  (list
   ;;primitive Scheme operations
   (list 'read read)			;used by eceval

   ;;used by compiled code
   (list 'list list)
   (list 'cons cons)

   ...

   ;; Exercise 5.48
   (list 'compile-and-run? compile-and-run?)
   (list 'compile-and-run-exp compile-and-run-exp)
   (list 'compile compile)
   (list 'statements statements)
   (list 'assemble assemble-eceval)
   ;;
   ))
```

Finally, `compile-and-run?` and `compile-and-run-exp`'s implementation is
trivial enough:

```lisp
(define (compile-and-run? exp)
  (tagged-list? exp 'compile-and-run))

(define (compile-and-run-exp exp)
  (cadr exp))
```

## Conclusion

I hope that my explanation is clear enough, as I walked you through my intuition
without the frustration and researching. The full code can be looked at on [my
GitHub](https://github.com/thanhnguyen2187/sicp-notes/blob/master/allcode/ch5-48.scm).

