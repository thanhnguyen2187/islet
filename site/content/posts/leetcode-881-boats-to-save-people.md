---
title: "Leetcode 881: Boats to Save People"
date: 2023-04-03T21:35:34+07:00
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

The original description of [the
problem](https://leetcode.com/problems/boats-to-save-people/description/) is
clear enough:

> You are given an array `people` where `people[i]` is the weight of the `i`th
> person, and an infinite number of boats where each boat can carry a maximum
> weight of `limit`. Each boat carries at most two people at the same time,
> provided the sum of the weight of those people is at most `limit`.
> 
> Return the minimum number of boats to carry every given person.

A few examples:

```python
# input
people = [1, 2]
limit = 3

# output
1

# explanation
# 
# There is only one boat in this case:
#
# - [1, 2]
```

```python
# input
people = [3, 2, 2, 1]
limit = 3

# output
3

# explanation
# 
# We need 3 boats:
#
# - [3]
# - [2, 1]
# - [2]
```

## Heart of The Problem

For me, the most challenging issue is to... read the problem carefully. I
understood the concepts of boats and `limit`, but somehow missed that:

> Each boat carries at most two people at the same time, provided the sum of the
> weight of those people is at most `limit`.

It was almost like a suggestion for us to solve the problem with the technique
"two pointer". The steps for the algorithm is:

- Sort `people`
- Set a pointer at the beginning and another at the end of `people`
- Try to put the two persons into a boat. There are only two cases:
  - Only the person at the end "fits"
  - The two persons fits
- We can be sure that the process is optimal, since:
  - There can only be two people on a boat
  - One's weight is at most `limit`, which means a the "heavy" person of the
    right side always occupies a boat, and it depends if we can fit the "light"
    person of the left side. We can always move the two cursors until they move
    past each other

For example, let us go through this case:

```python
people = [1, 2, 2, 3, 4, 4, 5]
limit = 5
```

Let us simulate the process:

```
Iteration 1:

   v           v
  [1 2 2 3 4 4 5]

  In this iteration, we can only fits the last person on a boat.

  [5]

Iteration 2:

   v         v
  [1 2 2 3 4 4 5]

  Moving the right cursor left, we find out that `1` and `4` can be fit on a
  boat.

  [5] [1 4]

Iteration 3:

     v     v
  [1 2 2 3 4 4 5]

  [5] [1 4] [4]

Iteration 4:

     v   v  
  [1 2 2 3 4 4 5]

  [5] [1 4] [4] [2 3]

Iteration 5:

       v    
  [1 2 2 3 4 4 5]

  Now the two cursors are joined and we stop iterating.

  [5] [1 4] [4] [2 3] [2]
```

## Implementation 1: Recursive Function

```python
def recurse(people: List[int], limit: int) -> int:
    if len(people) <= 1:
        return len(people)
    elif people[-1] + people[0] <= limit:
        return 1 + recurse(people[1:-1], limit)
    else:
        return 1 + recurse(people[:-1], limit)


class Solution:
    def numRescueBoats(self, people: List[int], limit: int) -> int:
        return recurse(people=sorted(people), limit=limit)
```

In the this version, I implemented a naive recursive function:

- Return `1` if there is only one person
- If the last person and the first person can be fit on a boat, then the result
  is `1` plus a call to itself where there the two is excluded.
- If the first person cannot be fit on a boat with the last, then we exclude the
  last one only.

Using the same input from above:

```python
people = [1, 2, 2, 3, 4, 4, 5]
limit = 5
```

Our function calls are:

```python
>>> recurse(people=[1, 2, 2, 3, 4, 4, 5], limit=5)
>>> 1 + recurse(people=[1, 2, 2, 3, 4, 4], limit=5)
>>> 1 + 1 + recurse(people=[2, 2, 3, 4], limit=5)
>>> 1 + 1 + 1 + recurse(people=[2, 2, 3], limit=5)
>>> 1 + 1 + 1 + 1 + recurse(people=[2], limit=5)
>>> 1 + 1 + 1 + 1 + 1
5
```

Before you are wondering, it TLE-ed.

## Implementation 2: Variable Swapping

The idea of reducing `people` into a smaller array can be implemented using
iteration.

```python
class Solution:
    def numRescueBoats(self, people: List[int], limit: int) -> int:
        result = 0
        people = sorted(people)
        while len(people) > 1:
            if people[-1] + people[0] <= limit:
                result += 1
                people = people[1:-1]
            else:
                result += 1
                people = people[:-1]

        result += len(people)
        return result
```

Before you are questioning again, yes, this also TLE-ed. The problem lies in
these assignments:

```python
people = people[...]
```

Which create a new list that includes shallow copies of the old list's elements.
Using `deque` here should works, too.

## Implementation 3: Two Pointers

Here comes the "intended" implementation:

```python
class Solution:
    def numRescueBoats(self, people: List[int], limit: int) -> int:
        result = 0
        people = sorted(people)
        left_index = 0
        right_index = len(people) - 1
        while left_index <= right_index:
            if people[left_index] + people[right_index] <= limit:
                result += 1
                left_index += 1
                right_index -= 1
            else:
                result += 1
                right_index -= 1
        return result
```

## Conclusion

I think this is a nice "medium" problem. The description's wording and examples
are not too cryptic nor deceiving in anyway. "Two pointer" is a "natural"
technique that people can reasonably come up with in time even if they have not
seen it before.

