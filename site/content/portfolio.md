---
title: "Software Portfolio"
date: 2022-11-25T17:50:07+07:00
draft: true
toc: true
tags:
- software
- portfolio
categories:
---

I am going to list software projects (professionally or hobby) that I have
worked on and what I contributed. The purpose is mainly to make it easier for my
readers (future employers hopefully) to see what I have done, evaluate my
technical skills, and decide that I am a good fit or not.

## Minh Phu Analytics

The project aimed to aid Minh Phu, one of the biggest sea food corporate in
Vietnam and in the world, on:

- Market Analytics
- Decision Making Support

### Scheduled News Aggregation

Problem: Minh Phu's staffs watch the market from various sources everyday,
and need a more convenient way to do so.

Solution: build simple services to aggregate (crawl) news from various
sources.

Implementation: I designed, implemented, and deployed services which
schedules and dispatches crawling workers. The overall model was something like
this:

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

Challenges: 

- Make sure that Scheduler is in synchronization with Configuration Database.
  The strategy is:
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
  
  The "magic" comes Python's allowance for dynamic parameters:

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

Problem: Minh Phu has seafood production related data of the past, and they want
to use the data to predict future price.

Solution: implement a service which allows user to rapidly try out different
combinations of models and data column.

Implementation:

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

Challenges:

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

## "DevOps"

The term "DevOps" is not the right one technically, I know, but I had a hard
time grouping these pieces. They are half "what I learned", and half "what am I
capable of", all related to software deployment and operation.

### *.nguyenhuythanh.com

I built, deployed, and managed this website (and a few others) all under a cheap
VPS. The model for this website is:

```goat
+-------+ request  +---+ nguyenhuythanh.com +-----+     +------+
|Devices|<-------->|DNS|<------------------>|Caddy|<--->|Static|
+-------+ response +---+                    +-----+     |files |
                                                        +------+
```

The model for analytics.nguyenhuythanh.com is:

```goat
+-------+ request  +---+ analytics.nguyenhuythanh.com +-----+     +-----------+
|Devices|<-------->|DNS|<---------------------------->|Caddy|<--->|Self-hosted|
+-------+ response +---+                              +-----+     |Umami      |
                                                                  +-----------+
```
(see the dashboard for this site [here](https://analytics.nguyenhuythanh.com/websites/260ae155-57fc-4eb6-95a8-18ea8fc6fc56/Islet))

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

