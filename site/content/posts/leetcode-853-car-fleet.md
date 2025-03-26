---
title: "Leetcode 853: Car Fleet"
date: 2025-03-26T10:53:29+07:00
draft: false
toc: true
tags:
- leetcode
- python
- stack
- monotonic-stack
categories:
- explanation
- how-to-guide
---

I find the problem strikes a balance between tricky (needing specific knowledge
of data structure and algorithm) and interesting (solvable with first-principle
thinking). However, after understanding the tricky part, and working through the
thinking, and implementing working code, I still could not really explain the
intuition concisely. Hence this writing. Let's hope that it helps you as much as
it helped me.

## Problem Description

You can find the problem description on
[Leetcode](https://leetcode.com/problems/car-fleet/description/) yourself.
However, I find it easier describe with a visual aid:

![](../images/leetcode-853-car-fleet.png)

Imagine a multi-lane road with cars starting at different positions and
traveling at different speeds. Each car has a position `p` and speed `s`. When a
faster car catches up to a slower car, they merge to form a "car fleet" that
travels at the speed of the slower car.

Given:

- A target distance (finish line)
- An array of starting positions for each car
- An array of speeds for each car

Calculate how many car fleets will reach the target. Note that:

- A car reaching the finish line by itself counts as one fleet
- If two cars merge exactly at the target, they count as one fleet

## Insights

Two cars will merge to form a fleet if they meet before reaching the finish
line. This happens when:

- One is slower, but starts closer to the finish line
- The other is faster, but starts further to the end

For example:

- A car starts at position 2, and takes 2 units of time to reach the end
- Another car starts at position 4, and takes 3 unit of time to reach the end

Then the second car would merge with the first car.

![](../images/leetcode-853-car-fleet-intuition.png)

The key insights to solve the problem are: if a further car arrives faster than
a closer one, we merge the two by just recording the slower car (one that has
higher arrival time). In the end, we should have a list of arrive times that
corresponds to the number of car fleets.

## Implementation

From the insights above, the algorithm is quite straightforward:

- Create pairs of positions and speeds for each car
- Sort these pairs by position in descending order (cars closest to the target
  first)
   - When two cars start at the same position, sort by speed in ascending order
     (slowest first)
- Calculate the time each car takes to reach the target
- Maintain a non-decreasing [^monotonic] sequence of times
   - If a car takes longer to reach the target than the car ahead of it, it
     forms a new fleet
   - If a car would reach the target sooner than the car ahead, it merges with
     that fleet
- Count the number of fleets (length of our time sequence)

Here is an implementation in Python:

```python
def calculate_time(target, pair):
    position = pair[0]
    speed = pair[1]
    return (target - position) / speed


class Solution:
    def carFleet(self, target: int, positions: List[int], speeds: List[int]) -> int:
        pairs = [
            (p, s)
            for p, s in zip(positions, speeds)
        ]
        pairs.sort(key=lambda pair: (pair[0], -pair[1]), reverse=True)

        times = [
            calculate_time(target=target, pair=pairs[0])
        ]

        for pair in pairs[1:]:
            time_current = calculate_time(target=target, pair=pair)
            time_last = times[-1]
            if time_current > time_last:
                times.append(time_current)

        return len(times)
```

- Time Complexity: `O(n log n)`
- Space Complexity: `O(n)`

## Conclusion

I hope that my explanation is clear enough, and you are able to derive your own
implementation after reading the algorithm steps. The monotonic [^monotonic]
sequence pattern used here (a monotonic stack, to be precise) appears in
various LeetCode problems and is worth adding to your algorithm solving
skillset.

[^monotonic]: the mathematics term "monotonic" means

    > varying in such a way that it either never decreases or never increases

