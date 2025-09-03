---
title: "Rust × Algotrading"
date: 2025-09-02T16:38:03+07:00
draft: false
toc: true
tags:
categories:
- explanation
- tutorial
- how-to-guide
- reference
---

I've been pursuing a Master of Finance Engineering degree, and also been playing
with Rust for a while, so I figured: why don't I try to combine both by
implementing an algotrading (short for algorithmic trading) bot? I eventually
implemented some strategies and backtesting from scratch (spoiler: the result is
worse than just holding, not counting trading fee). I'm on my way improving the
result, and putting it into paper trade. This post is a nice distraction from
that, where I'll show you some code [^full-code], then go with some thoughts on
Rust.

## Strategy Implementation

I thought of trying to incorporate risk management/portfolio management to the
strategies at first, but then feel like it would complicate the logic without
real obvious gains, so my implementations focused on managing one position, and
making one action at a time. Here is the model at a high level:

```python
state_new, action = advance(state_current, tick)
```

- `state` is the whole collection of data relating to a strategy itself (for
  example, if we do Moving Average Crossover, then we would have to track the two
  moving averages), and the actions that were made.
- `action` is either an `Entry` or an `Exit`, depends on what are we doing (it's
  obvious that if we had an `Exit` recently, or did nothing at all, then we can
  only do `Entry` and vice versa).
- `tick` can simply be a new price value, or a pair of price value with
  timestamp.

Before we continue on details of a "Hello World" strategy, Moving Average
Crossover [^moving-average-crossover], let's assume some common data structures: 

```rust
#[derive(Debug, PartialEq, Clone)]
pub enum Action {
    Entry { price_record: PriceRecord },
    Exit { price_record: PriceRecord },
}

#[derive(Debug, PartialEq, Clone)]
pub struct PriceRecord {
    pub value: f64,
    pub timestamp_ms: u64,
}
```

The state for the strategy doesn't have anything special, but we need them for
completeness's sake:

```rust
pub struct MovingAverage {
    n: usize,
    values: VecDeque<f64>,
    averages: VecDeque<f64>,
    sum: f64,
}

pub struct Strategy {
    pub ma_shorter: MovingAverage,
    pub ma_longer: MovingAverage,

    pub actions: Vec<Action>,
    pub actions_filled: Vec<Option<Action>>,
    pub price_records: Vec<PriceRecord>,
}
```

The interesting part is in `advance` implementations, where the calculation is
"pure" and change incremental with new data and supposedly works for any time
range:

```rust
impl MovingAverage {
    // ...

    pub fn advance(&mut self, value: f64) {
        if self.values.len() == self.n {
            if let Some(value_first) = self.values.pop_front() {
                self.sum -= value_first;
            }
            self.averages.pop_front();
        }

        self.values.push_back(value);
        self.sum += value;
        self.averages.push_back(self.sum / self.values.len() as f64);
    }

    // ...
}

impl Engine {
    // ...

    pub fn advance(&mut self, price_record: &PriceRecord) {
        self.ma_shorter.advance(price_record.value);
        self.ma_longer.advance(price_record.value);
        self.price_records.push(price_record.clone());

        let crossed = is_crossed(&self.ma_shorter, &self.ma_longer);
        let action_opt: Option<Action>;
        match (crossed, self.actions.last()) {
            (Crossed::Golden, Some(Action::Exit { price_record: _ }) | None) => {
                action_opt = Some(Action::Entry {
                    price_record: price_record.clone(),
                });
            }
            (Crossed::Death, Some(Action::Entry { price_record: _ })) => {
                action_opt = Some(Action::Exit {
                    price_record: price_record.clone(),
                });
            }
            _ => {
                action_opt = None;
            }
        }

        self.actions_filled.push(action_opt.clone());
        if let Some(action) = action_opt {
            (self.on_new_action)(&action);
            self.actions.push(action);
        }
    }
}
```

Using:

- Binance's daily data from January 2023 to December 2024 (around 2 years)
- Shorter MA's length: `10`
- Longer MA's length: `50`
- Maker fee and take fee at `0.1%`

The result looks promising:

```
2025-09-03T02:33:30.787618Z  INFO downloader: Loaded total 731 records
2025-09-03T02:33:30.787675Z  INFO backtests: Action: Entry { price_record: PriceRecord { value: 27151.31, timestamp_ms: 1679097600000 } }
2025-09-03T02:33:30.787722Z  INFO backtests: Action: Exit { price_record: PriceRecord { value: 27613.515, timestamp_ms: 1683676800000 } }
...
2025-09-03T02:33:30.788032Z  INFO backtests: Action: Entry { price_record: PriceRecord { value: 62353.985, timestamp_ms: 1726704000000 } }
2025-09-03T02:33:30.788088Z  INFO backtests: Action: Exit { price_record: PriceRecord { value: 93265.12, timestamp_ms: 1735516800000 } }
2025-09-03T02:33:30.788102Z  INFO backtests: Total return percent: 1.396501006474551
2025-09-03T02:33:30.788107Z  INFO backtests: Total fee: 704.2855500000001
2025-09-03T02:33:30.788111Z  INFO backtests: Number of trade made: 14
```

Where we made around 139% returns over 2 years with 14 trades. However, I doubt
that this is a good strategy as we didn't take into account trading fee and the
period is favorable already. Based roughly on the first and the last actions,
just holding would gives us >200% returns (`(93,265 - 27,151) / 27,151`).

## On Rust Usage

I think most people coming here would have this question in mind: is Rust good
for algotrading?

Let's say we have the research/backtests side, and the low-latency side, then
Rust isn't too good nor too bad at either. It doesn't help with fast iteration
like Python, but not suited for ultra-low latency trading (where C++ dominates)
[^reddit-thread]. If you're building a full trading system from scratch and
value type safety and reproducibility across your entire pipeline, Rust becomes
more compelling.

Therefore, one takeaway is: you won't go wrong with either Python (if you are on
the strategy camp like doing researches and backtesting) or C++ (if you are on
the low-latency trading camp).

---

Another thing I think people would be interested about is an unique review of
Rust. It doesn't stray far from this GitHub's blog post [^github-blog-post]:

- On the bright side, I like the language's and the libraries' extra care for
  correctness (for example, `chrono`, Rust's unofficial official date time
  handling library asks the user to be correct with their timestamp handling by
  providing a timezone; it's more time consuming, but also eliminates potential
  future problems). On DX/Developer Experience, there is no question that
  `cargo` just work, and error messages are mostly helpful, and editors' support
  is good (VSCode plugins and JetBrain's Rust Rover).
- On the other side, the correctness means iteration speed is low as we have to
  do extra steps to make it compile first. I also didn't mention the high
  learning curve, and an almost non-exist job market (at least in Vietnam), did
  I?

Another takeaway: the language is okay. You'll learn a ton from using it and
have fun on the way, but don't expect you can find a job easily.

---

Finally, we have an interesting question: what is Rust good for?

To be honest, I don't have a clear answer, even after I used it to implement a
half-finished toy KV database [^toy-kv-database], an HTTP backend for a personal
financial dashboard [^sifintra], and a trading bot [^full-code]. Recently, I was
asked the same question was asked when in a backend position [^ghosted]. The
company was using Go heavily, and looking to improve the performance of their
services, and was considering Rust. I mentioned correctness and binary build,
but and my interviewer said that the points didn't really hold against Go. I
quoted Discord's switching from Go to Rust [^discord-go-to-rust], and talked
about better memory management, but I guess I couldn't dive deep enough and
convince my interviewer.

Going back to answering the question, let's put it in terms of:

- Functional requirements (users should be able to achieve something using the
  software) and
- Non-functional requirements (the software should be able to do something in
  a specific period of time, like calculate metric XYZ something in 50ms)

Then I think Rust is good if:

- Your functional requirements was mostly static (you aren't a startup
  experimenting different approaches) and
- You're trying to meet a new non-functional requirements (improving throughput
  or latency or something).

`uv` [^uv] is a successful example: the functional requirements of Python
tooling doesn't change that much after the language is stable, but this new tool
nailed the DX and performance.

The final takeaway: Rust is good for rewrites.

## Conclusion

While it's a fun experiment implementing algotrading in Rust, I would say for
job hunting and ease of starting, you should consider using Python. If you are
targeting HFT positions, then do something with C++. For me, I would continue
with Rust as I got something working, and... it's fun doing stuff from scratch
anyway.

[^moving-average-crossover]:
    https://blog.quantinsti.com/moving-average-trading-strategies/
[^reddit-thread]:
    https://www.reddit.com/r/rust/comments/1cj71kn/using_rustlang_in_hft/
[^github-blog-post]:
    https://github.blog/developer-skills/programming-languages-and-frameworks/why-rust-is-the-most-admired-language-among-developers/
[^toy-kv-database]:
    https://github.com/thanhnguyen2187/playground/tree/master/kvs
[^sifintra]: https://github.com/thanhnguyen2187/sifintra/
[^full-code]: TODO update link after cleaning up; I hardcoded some secrets in my
    code and that would show up in Git history, so I must clean it up before
    showing my work
[^uv]: https://docs.astral.sh/uv/
[^ghosted]: The interviewer and the company was quite nice, but it's sad that I
    got ghosted in the end.
[^discord-go-to-rust]:
    https://discord.com/blog/why-discord-is-switching-from-go-to-rust
