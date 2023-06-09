---
title: "Software Portfolio (WIP)"
date: 2022-11-25T17:50:07+07:00
draft: false
toc: true
tags:
- software
- portfolio
categories:
---

## TL;DR

I am a Fullstack Software Engineer, who has mostly worked in the backend
spectrum, and is comfortable with most layers of modern web development
(frontend, backend, and platform/DevOps). 

I am going to list software projects (professional or personal) that I have
worked on and what I contributed. The purpose is mainly to make it easier for my
readers (future employers hopefully) to see what I have done, evaluate my
technical skills, and decide that I am a suitable candidate or not.

## Mones

The product is originally called Ceres M, a "traditional Web2 game", which
underwent:

- In-game balance patches
- Various UX improvements
- Various blockchain integration implementations

To become a "Web3 Play-N-Earn game" on BNB Chain. The differences are:

- Using cryptocurrencies to replace traditional top-up payments
- Turning in-game items to NFTs and building an NFT marketplace to replace
  traditional game marketplaces

### NFT Marketplace Events Indexing

#### Problem

The game's NFT marketplace is essentially a smart contract. End user can
interact with the blockchain directly via JSON RPC calls to smart contracts, but
it is not friendly enough in terms of speed and UX. 

#### Solution

Implement various services to synchronize on-chain data with a "local" database,
and serve the data to a user-friendly frontend.

#### Implementation

I took part in the design, and implemented a few services and functionalities of
the overall system.

- Without the data synchronization:

```goat
+----------+ +------------+                                                     
| End User | | Blockchain |
+----+-----+ +------+-----+
     |              |
     |   interact   |
     |<------------>|
     |              |
     |              |
     |              |
     |              |
     |              |
     |              |
```

- With the data synchronization:

```goat
+----------+ +-----------+ +-----+ +----------+ +-----------------+ +------------+
| End User | | Front end | | API | | Database | | Synchronization | | Blockchain |
+----+-----+ +-----+-----+ +--+--+ +-----+----+ |    Services     | +------+-----+
     |             |          |          |      +--------+--------+        |
     |             |          |          |               |                 |
     |  interact   |          |          |               | query data      |
     |<----------->|          |          |               |<--------------->|
     |             | request  |          | upsert data   |                 |
     |             | data     |          |<------------->|                 |
     |             |<-------->|          |               |                 |
     |             |          | query    |               |                 |
     |             |          | data     |               |                 |
     |             |          |<-------->|               |                 |
     |             |          |          |               |                 |
     |             |          |          |               |                 |
     |             |          |          |               |                 |
```

- Details of the data synchronization:

```goat
+----------+ +----------+ +----------+ +-------------+ +----------+ +------------+
| Database | | Internal | | Enricher | | Event Queue | | Mediator | | Blockchain |
+----+-----+ |   API    | +----+-----+ +------+------+ +----+-----+ |    Node    |
     |       +----+-----+      |              |             |       +-----+------+
     |            |            |              |             |             |
     |            |            |              |             | fetch       |
     |            |            |              |             | events      |
     |            |            |              |             |<------------+
     |            |            |              | push        |             |
     |            |            |              | events      |             |
     |            |            |              |<------------+             |
     |            |            | receive      |             |             |
     |            |            | events       |             |             |
     |            |            |<-------------|             |             |
     |            |            |              |             |             |
     |            |            | enrich       |             |             |
     |            |            | game data    |             |             |
     |            |            | and metadata |             |             |
     |            |            +---------+    |             |             |
     |            |            |         |    |             |             |
     |            |            |<--------+    |             |             |
     |            | upsert     |              |             |             |
     |            | data       |              |             |             |
     |            |<-----------+              |             |             |
     | upsert     |            |              |             |             |
     | data       |            |              |             |             |
     |<-----------+            |              |             |             |
     |            |            |              |             |             |
     |            |            |              |             |             |
```

Technologies used: Golang, Elasticsearch, TypeScript, web3.js

#### Challenges

- Race Condition Between Enricher, Internal API, and Database

I had a more detailed post
[here](/posts/a-mildy-interesting-technical-challenge/), but it can be turned in
short to this:

1. Enricher sometimes handles events too fast that the requests it send to
   Internal API can be considered come simultaneously
2. Internal API also handles the requests simultaneously
3. The handling creates a case where two threads write to the database at once
4. In the end, the concurrent writing from two threads creates inconsistent
   states

To solve this issue, at step `3.`, I changed the implementation from updating
the whole record to update one field only.

## Oxalus

The name "Oxalus" a brand for a suite of NFT-related products, namely:

- Oxalus Games: NFT games including Mones, Gunfire Hero, and StepHero.
- Oxalus Wallet: a wallet for NFTs
- Oxalus Analytics: NFT data insights

The product aimed to provides users with insights on NFT activities.

- Oxalus NFT Aggregator: NFT marketplaces data aggregator

As for Oxalus NFT Aggregator, it was created to address user's problem on
browsing and buying NFT on multiple marketplaces. It also allows them to save
gas fee by purchasing multiple NFTs at once.

Before having NFT Aggregator:

```goat
+------+ +---------------+ +---------------+ +---------------+
| User | | Marketplace 1 | | Marketplace 2 | | Marketplace 3 |
+--+---+ +-------+-------+ +-------+-------+ +-------+-------+
   |             |                 |                 |
   | browse      |                 |                 |
   |<----------->|                 |                 |
   | buy NFT     |                 |                 |
   |<----------->|                 |                 |
   |             |                 |                 |
   |             |                 |                 |
   | browse      |                 |                 |
   |<------------|---------------->|                 |
   | buy NFT     |                 |                 |
   |<------------|---------------->|                 |
   |             |                 |                 |
   |             |                 |                 |
   | browse      |                 |                 |
   |<------------|-----------------|---------------->|
   | buy NFT     |                 |                 |
   |<------------|-----------------|---------------->|
   |             |                 |                 |
   |             |                 |                 |
```

After having NFT Aggregator:

```goat
+------+ +----------------+ +---------------+ +---------------+
| User | | NFT Aggregator | | Marketplace 1 | | Marketplace 2 |
+--+---+ +--------+-------+ +-------+-------+ +-------+-------+
   |              |                 |                 |
   |              | crawl           |                 |
   |              | data            |                 |
   |              |<--------------->|                 |
   |              |                 |                 |
   |              | crawl           |                 |
   |              | data            |                 |
   |              |<----------------|---------------->|
   |              |                 |                 |
   | browse       |                 |                 |
   |<------------>|                 |                 |
   | buy NFT      |                 |                 |
   |<------------>|                 |                 |
   |              |                 |                 |
   |              |                 |                 |
```

### ERC-20, ERC-721, and ERC-1155 Event Data Indexing

Disclaimer: I am not the one who implemented the whole service, but I fixed a
few complicated bugs of it.

#### Problem

Let us suppose we have a ERC-20 contract's address, we can easily know what is
the current balance of an account (invoking `balanceOf`). To know the change
history is another story, however. It involves manually indexing `Transfer`
events. For ERC-721, apart from an NFT's transfer history, we also want to know
every NFT that a wallet owns. It also involves indexing `Transfer` events.

Indexing one or two contracts is not hard, but for more than a hundred, or even
a thousand contracts, it simply becomes infeasible if we creates many
connections to blockchain nodes and query the data, as we may get rate-limited.

More specificially, in Oxalus Wallet's case, the product's backend have an
unknown number of wallet that it needs to track. Oxalus Analytics can also have
other insights from the transfer data.

#### Solution

The team implemented a service that fetches every ERC-20, ERC-721, and
ERC-1155's `Transfer` events, and try to put the data into a blob storage.

#### Implementation

The service's algorithm is:

- Read the last completed block from blob storage
- Pick a big block range
- Split the block range into smaller chunks
- Fetch the events concurrently with each chunk
- Join the data from the previous step

#### Challenges

- "Unreliable" Data

In the first time the service run, for the same block range (1 to 10 for
example), there are 100 records in the storage, while in the second time, there
are 101. In the third time, there are 99 records. My point is that: since a
blockchain's data is immutable, we expect the number to be stable, or the same
every time, but we get different numbers each time.

Diving deep into the problem, I found that the issue lie at the way data's
returned by the blockchain's node. To be more specific, the nodes from NodeReal
limit their data to 50,000 records, which caused the unreliability.

### Marketplace Contract Events Indexing

TODO

## Minh Phu Analytics

The product aimed to aid Minh Phu, one of the biggest sea food corporate in
Vietnam and in the world, on:

- Market Analytics
- Decision Making Support

### Scheduled News Aggregation

#### Problem

Minh Phu's staffs watch the market from various sources everyday, and need a
more convenient way to do so.

#### Solution

Build simple services to aggregate (crawl) news from various sources.

#### Implementation

I designed, implemented, and deployed services which schedules and dispatches
crawling workers. The overall model was something like this:

```goat
+-------------+ conf +---------+ jobs +---------+ job  +--------+      +--------+
|Configuration|----->|Scheduler|----->|Job Queue|----->|Worker 1|      |News    |
|Database     |      +---------+      +---------+      +--------+      |Websites|
+-------------+                            |                           +--------+
                                           | job       +--------+  data   |
                                           +---------->|Worker 2|<--------+
                                                       +--------+
                                                           |
+--------+              data                               |
|News    |<------------------------------------------------+
|Database|
+--------+
```

Scheduler first fetches configurations from the database, and then create jobs
periodically. The jobs are pushed into a queue, and Workers consume from 

The workers are going to fetch news from various websites, and then put the
fetched data into a database. A queue is needed to scale the fetching
horizontally.

#### Challenges

- Make sure that Scheduler is in synchrony with Configuration Database. The
  strategy is:
  - On Scheduler starting: fetch every configuration rows and do the scheduling
    normally.
  - On updates occurs to any configuration row: send a message to the scheduler
    to make it update the corresponding local data.
- Understanding Python advanced syntaxes: `first class function`, `args` and
  `kwargs`. The syntaxes are used by `APScheduler` on creating a new `job`
  instance like this:

  ```python
  scheduler.add_job(my_func, args=[...], kwargs={...})
  ```

  So in my case, I have a base function that has this signature to crawl data:

  ```python
  def crawl(url: str):
      ...
  ```

  The way to make it works with APScheduler is:

  ```python
  fetched_configurations = ...
  urls = convert(fetched_configurations)
  for url in urls:
      scheduler.add_job(crawl, kwargs={url: url})
  ```
  
  The "magic" comes from Python's allowance for dynamic parameters:

  ```python
  def f(a, b):
      ...

  kwargs = {"a": 1, "b": 2}

  # this "typical" way of evoking function with named parameters
  f(a=1, b=2)
  # is equivalent to
  f(**args)
  ```

The technologies that were used are: PostgresQL, Python, RabbitMQ, pika,
APScheduler, BeautifulSoup, and Selenium.

### Time Series Prediction

#### Problem

Minh Phu has seafood production related data of the past, and they want
to use the data to predict future price.

#### Solution

Implement a service which allows user to rapidly try out different
combinations of models and data column.

```goat
+------+       +--------+     +----------+                                          
| User |       | System |     | Database |
+--+---+       +---+----+     +----+-----+
   |               |               |
   | save          |               |
   | configuration |               |
   +-------------->|               |
   |               |               |
   |               | save          |
   |               | configuration |
   |               +-------------->|
   |               |               |
   | execute       |               |
   | prediction    |               |
   +-------------->|               |
   |               |               |
   |               | fetch         |
   |               | data          |
   |               |<------------->|
   |               |               |
   |               | apply         |
   |               | algorithm     |
   |               +-----+         |
   |               |     |         |
   |               |<----+         |
   |               |               |
   | see           |               |
   | visualization |               |
   +-------------->|               |
   |               |               |
```

#### Implementation

Assuming we have this data:

| Date        | Column 1  | Column 2  | Price  |
| ----------- | --------- | --------- | ------ |
| 2022-01-01  | X1_1      | X2_1      | P1     |
| 2022-01-02  | X1_2      | X2_2      | P2     |
| 2022-01-03  | X1_3      | X2_3      | P3     |
| 2022-01-04  | X1_4      | X2_4      | P4     |

Adding the previous day's price as a column, and change `Price` to `Target
Price`:

| Date        | Column 1  | Column 2  | Previous Price  | Target Price |
| ----------- | --------- | --------- | --------------- | ------------ |
| 2022-01-01  | X1_1      | X2_1      | _               | P1           |
| 2022-01-02  | X1_2      | X2_2      | P1              | P2           |
| 2022-01-03  | X1_3      | X2_3      | P2              | P3           |
| 2022-01-04  | X1_4      | X2_4      | P3              | P4           |

We can put everything into a formula like this:

```
C1*X1 + C2*X2 + C3*P_n-1 = P_n
```

- `X1`: first parameter
- `X2`: second parameter
- `P_n-1`: previous price
- `P_n`: target price
- `C1`: constant 1
- `C2`: constant 2
- `C3`: constant 3

Statistic models (or machine learning models, as a fancier word) are used to
find `C1`, `C2`, and `C3`.

The service then expose these options for the "numbers finding" process:

- Model
- Model parameters
- Columns to use
- Time range

#### Challenges

- Data Wrangling: listing the steps is easy, but I could recall that I struggled
  a lot, even though it sounded simple.
  - Fetch the data
  - Skip the first row
  - Create the "previous price" column
  - Create model
  - Fit the data into the model
  - Save the calculated data
- TBA

Technologies used: Python, pandas, sklearn, and statsmodels.

## Side Projects

### Personal Blog

```goat
+-------+ request  +---+ nguyenhuythanh.com +-----+     +------+
|Devices|<-------->|DNS|<------------------>|Caddy|<--->|Static|
+-------+ response +---+                    +-----+     |files |
                                                        +------+
```

Technologies used: Hugo, Caddy, systemd.

### Darkest Savior

TBA

### Esoterica

TBA

## Miscellanies

WIP

### GitOps

Disclaimer: I encountered this model at two places, and dabbled a bit on one
that was built from scratch. I know how it works in theory, but not in details.

The model is something like this:

```goat
+---------+ +----------+ +----------+ +------+ +--------------+ +----------+
|Developer| |Source Git| |Artifact  | |Worker| |Deployment Git| |Kubernetes|
+---+-----+ |Repository| |Repository| +---+--+ |Repository    | +-----+----+
    |       +-----+----+ +-----+----+     |    +-------+------+       |
    | commit      |            |          |            |              |
    +------------>|            |          |            |              |
    |             | build      |          |            |              |
    |             | Docker     |          |            |              |
    |             | image      |          |            |              |
    |             +-------+    |          |            |              |
    |             |       |    |          |            |              |
    |             |<------+    |          |            |              |
    |             |            |          |            |              |
    |             | push       |          |            |              |
    |             | Docker     |          |            |              |
    |             | image      |          |            |              |
    |             +----------->|          |            |              |
    |             |            |          |            |              |
    |             | trigger    |          |            |              |
    |             | hook       |          |            |              |
    |             +------------|--------->|            |              |
    |             |            |          | auto       |              |
    |             |            |          | commit     |              |
    |             |            |          +----------->|              |
    |             |            |          |            | rebuild      |
    |             |            |          |            | YAML         |
    |             |            |          |            +--------+     |
    |             |            |          |            |        |     |
    |             |            |          |            |<-------+     |
    |             |            |          |            |              |
    |             |            |          |            | apply        |
    |             |            |          |            | YAML         |
    |             |            |          |            +------------->|
    |             |            |          |            |              |
```

Technologies used: Docker, GitLabCI, Google Cloud, and Kubernetes.

