---
title: "Leetcode 6: Zigzag Conversion"
date: 2023-02-03T15:10:06+07:00
draft: false
toc: true
images:
categories:
  - explanation
  - tutorial
tags:
  - leetcode
  - python
---

## Description

The original description is available
[here](https://leetcode.com/problems/zigzag-conversion/description/). This is my
take on it however:

We put characters of string `s` into a grid with row count `n` following a
zigzag pattern, then return a "result" string, which is the characters
themselves joined left to right, up to down.

For example

```python
# with
s = "abcdefghijklmno"
n = 3

# then
result = "aeimbdfhjlncgko"
```

For clarification, putting the string on a grid for zigzag is like this:

```
+-+-+-+-+-+-+-+
|a| |e| |i| |m|
+-+-+-+-+-+-+-+
|b|d|f|h|j|l|n|
+-+-+-+-+-+-+-+
|c| |g| |k| |o|
+-+-+-+-+-+-+-+
```

## Heart of The Problem

- The zigzag pattern is in this form:

```
|  /|  /|
| / | / |
|/  |/  |
```

- It means we put the characters gradually like this:

```
1.               2.               3.               4.             
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|*| | | | | | |  |*| | | | | | |  |*| | | | | | |  |*| | | | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
| | | | | | | |  |*| | | | | | |  |*| | | | | | |  |*|*| | | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
| | | | | | | |  | | | | | | | |  |*| | | | | | |  |*| | | | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+

5.               6.               7.               8.             
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|*| |*| | | | |  |*| |*| | | | |  |*| |*| | | | |  |*| |*| |…| | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|*|*| | | | | |  |*|*|*| | | | |  |*|*|*| | | | |  |*|*|*|*| | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|*| | | | | | |  |*| | | | | | |  |*| |*| | | | |  |*| |*| | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
```

- It means for string `abcdefghijklmno`, we put them down gradually:

```
1.               2.               3.               4.             
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|a| | | | | | |  |a| | | | | | |  |a| | | | | | |  |a| | | | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
| | | | | | | |  |b| | | | | | |  |b| | | | | | |  |b|d| | | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
| | | | | | | |  | | | | | | | |  |c| | | | | | |  |c| | | | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+

5.               6.               7.               8.             
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|a| |e| | | | |  |a| |e| | | | |  |a| |e| | | | |  |a| |e| |…| | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|b|d| | | | | |  |b|d|f| | | | |  |b|d|f| | | | |  |b|d|f|h| | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
|c| | | | | | |  |c| | | | | | |  |c| |g| | | | |  |c| |g| | | | |
+-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+  +-+-+-+-+-+-+-+
```

- Until it becomes the full-filled grid:

```
+-+-+-+-+-+-+-+
|a| |e| |i| |m|
+-+-+-+-+-+-+-+
|b|d|f|h|j|l|n|
+-+-+-+-+-+-+-+
|c| |g| |k| |o|
+-+-+-+-+-+-+-+
```

- Before forming the result string from characters left to right, up to down, we
  can make it easier by tearing it down row-wise:

```python
row_0 = ['a', 'e', 'i', 'm']
row_1 = ['b', 'd', 'f', 'h', 'j', 'l', 'n']
row_2 = ['c', 'g', 'k', 'o']
```

- Now we understand why the result is `aeimbdfhjlncgko`: we put `aeim` and
  `bdfhjln` and `cgko` together.

- Understanding the problem is fun, but coming up with a solution is more
  interesting. We can see that the zigzag pattern does have some repetition:

```
|  / |  / |  /
| /  | /  | /
|/   |/   |/

1.   2.   3.   ...
```

- Let us see how our characters also have that pattern:

```
+-+-+  +-+-+  +-+-+
|a| |  |e| |  |i| |
+-+-+  +-+-+  +-+-+
|b|d|  |f|h|  |j|l|  ...
+-+-+  +-+-+  +-+-+
|c| |  |g| |  |k| |
+-+-+  +-+-+  +-+-+
```


- Let us have a look at the coordinations:

```
   0 1    2 3    4 5
  +-+-+  +-+-+  +-+-+
0 |a| |  |e| |  |i| |
  +-+-+  +-+-+  +-+-+
1 |b|d|  |f|h|  |j|l|  ...
  +-+-+  +-+-+  +-+-+
2 |c| |  |g| |  |k| |
  +-+-+  +-+-+  +-+-+

- a: (0, 0)
- b: (1, 0)
- c: (2, 0)
- d: (1, 1)

- e: (0, 2)
- f: (1, 2)
- g: (2, 2)
- h: (1, 3)

- ...
```

- Then we can notice that the changes to each character's positions follows a
  pattern:

```
- a: (0, 0)
     +1
- b: (1, 0)
     +1
- c: (2, 0)
     -1 +1
- d: (1, 1)
     -1 +1
- e: (0, 2)
     +1
- f: (1, 2)
     +1
- g: (2, 2)
     -1 +1
- h: (1, 3)
     -1 +1
...
```

- The algorithm then is:
  - Set the first position
  - Generate position changes
  - Generate the positions of the string
  - Sort the characters of the string by their positions

## Implementation

Seeing the changes as an infinite stream, we can leverage Python's iterator like
this:

```python
def generate_changes(num_rows: int) -> Iterator:
    while True:
        # step down
        yield from repeat((1, 0), num_rows - 1)
        # step up right
        yield from repeat((-1, 1), num_rows - 1)
```

Then generating the positions is a bit more tricky:

```python
def generate_positions(
    start_position: (int, int),
    num_rows: int,
) -> Iterator:
    changes = generate_changes(num_rows=num_rows)
    current_position = start_position
    while True:
        yield current_position
        change = next(changes)
        x, y = current_position
        change_x, change_y = change
        current_position = (x + change_x, y + change_y)
```

We wrap it up in the class `Solution` that LeetCode provides us:

```python
class Solution:
    def convert(self, s: str, numRows: int) -> str:
        if numRows == 1:
            return s
        positions = generate_positions(start_position=(0, 0), num_rows=numRows)
        s_with_position = list(zip(s, positions))
        s_sorted_by_position = sorted(s_with_position, key=lambda pair: pair[1])
        s_sorted_without_position = list(map(lambda pair: pair[0], s_sorted_by_position))
        result = ''.join(s_sorted_without_position)
        return result
```

## Conclusion

Some people may not like the original description of the problem, as it is too
vague and lack of explanation, but I found the decrypting process fun anyway.

Also, the solution that I proposed might not be the most optimal one, but it is
intuitive for me anyway.

